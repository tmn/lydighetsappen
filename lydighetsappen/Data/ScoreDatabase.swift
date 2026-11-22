//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation
import SQLite3

private let sqliteTransient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

struct SQLiteError: Error, LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

final class ScoreDatabase {
    private enum Value {
        case int(Int64)
        case double(Double)
        case text(String)
        case null
    }

    private var handle: OpaquePointer?

    /// `path` kan være `":memory:"` (brukes i tester).
    init(path: String) throws {
        guard sqlite3_open(path, &handle) == SQLITE_OK else {
            let message = handle.map { String(cString: sqlite3_errmsg($0)) } ?? "Kunne ikke åpne databasen"
            sqlite3_close(handle)
            throw SQLiteError(message: message)
        }
        try run("PRAGMA foreign_keys = ON")
        try migrate()
    }

    deinit {
        sqlite3_close(handle)
    }

    static func defaultPath() throws -> String {
        let directory = try FileManager.default.url(
            for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        )
        return directory.appendingPathComponent("lydighetsappen.sqlite3").path
    }

    // MARK: - Skjema

    private func migrate() throws {
        var version: Int64 = 0
        try run("PRAGMA user_version") { version = sqlite3_column_int64($0, 0) }

        if version < 1 {
            try run("""
                CREATE TABLE sessions (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    class TEXT NOT NULL,
                    started_at REAL NOT NULL,
                    finished_at REAL
                )
                """)
            try run("""
                CREATE TABLE exercise_scores (
                    session_id INTEGER NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
                    exercise_number TEXT NOT NULL,
                    half_grade INTEGER NOT NULL,
                    skipped INTEGER NOT NULL DEFAULT 0,
                    PRIMARY KEY (session_id, exercise_number)
                )
                """)
            try run("PRAGMA user_version = 1")
        }
    }

    // MARK: - Økter

    func createSession(lpClass: LPClass, startedAt: Date = Date()) throws -> Int64 {
        try run(
            "INSERT INTO sessions (class, started_at) VALUES (?, ?)",
            [.text(lpClass.rawValue), .double(startedAt.timeIntervalSince1970)]
        )
        return sqlite3_last_insert_rowid(handle)
    }

    func saveScore(sessionID: Int64, exerciseNumber: String, score: ExerciseScore) throws {
        try run("""
            INSERT INTO exercise_scores (session_id, exercise_number, half_grade, skipped)
            VALUES (?, ?, ?, ?)
            ON CONFLICT (session_id, exercise_number)
            DO UPDATE SET half_grade = excluded.half_grade, skipped = excluded.skipped
            """,
            [.int(sessionID), .text(exerciseNumber), .int(Int64(score.halfGrade)), .int(score.isSkipped ? 1 : 0)]
        )
    }

    func finishSession(id: Int64, at date: Date = Date()) throws {
        try run(
            "UPDATE sessions SET finished_at = ? WHERE id = ?",
            [.double(date.timeIntervalSince1970), .int(id)]
        )
    }

    func deleteSession(id: Int64) throws {
        try run("DELETE FROM sessions WHERE id = ?", [.int(id)])
    }

    func loadSessions() throws -> [ScoreSession] {
        var sessions: [ScoreSession] = []
        try run("SELECT id, class, started_at, finished_at FROM sessions ORDER BY started_at DESC, id DESC") { statement in
            guard let lpClass = LPClass(rawValue: Self.text(statement, 1)) else { return }
            let finishedAt = sqlite3_column_type(statement, 3) == SQLITE_NULL
                ? nil
                : Date(timeIntervalSince1970: sqlite3_column_double(statement, 3))
            sessions.append(ScoreSession(
                id: sqlite3_column_int64(statement, 0),
                lpClass: lpClass,
                startedAt: Date(timeIntervalSince1970: sqlite3_column_double(statement, 2)),
                finishedAt: finishedAt,
                scores: [:]
            ))
        }

        var scores: [Int64: [String: ExerciseScore]] = [:]
        try run("SELECT session_id, exercise_number, half_grade, skipped FROM exercise_scores") { statement in
            scores[sqlite3_column_int64(statement, 0), default: [:]][Self.text(statement, 1)] = ExerciseScore(
                halfGrade: Int(sqlite3_column_int64(statement, 2)),
                isSkipped: sqlite3_column_int64(statement, 3) != 0
            )
        }

        for index in sessions.indices {
            sessions[index].scores = scores[sessions[index].id] ?? [:]
        }
        return sessions
    }

    // MARK: - SQLite-hjelpere

    private static func text(_ statement: OpaquePointer, _ column: Int32) -> String {
        sqlite3_column_text(statement, column).map { String(cString: $0) } ?? ""
    }

    private func run(_ sql: String, _ values: [Value] = [], row: ((OpaquePointer) -> Void)? = nil) throws {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(handle, sql, -1, &statement, nil) == SQLITE_OK, let statement else {
            throw lastError()
        }
        defer { sqlite3_finalize(statement) }

        for (offset, value) in values.enumerated() {
            let index = Int32(offset + 1)
            switch value {
            case .int(let number): sqlite3_bind_int64(statement, index, number)
            case .double(let number): sqlite3_bind_double(statement, index, number)
            case .text(let string): sqlite3_bind_text(statement, index, string, -1, sqliteTransient)
            case .null: sqlite3_bind_null(statement, index)
            }
        }

        while true {
            switch sqlite3_step(statement) {
            case SQLITE_ROW: row?(statement)
            case SQLITE_DONE: return
            default: throw lastError()
            }
        }
    }

    private func lastError() -> SQLiteError {
        SQLiteError(message: handle.map { String(cString: sqlite3_errmsg($0)) } ?? "Ukjent databasefeil")
    }
}
