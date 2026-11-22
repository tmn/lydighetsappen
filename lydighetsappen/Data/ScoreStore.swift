//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation
import Observation

@MainActor
@Observable
final class ScoreStore {
    private let database: ScoreDatabase

    private(set) var sessions: [ScoreSession] = []
    var errorMessage: String?

    init(database: ScoreDatabase) {
        self.database = database
        reload()
    }

    static let shared = ScoreStore.live()

    static func live() -> ScoreStore {
        do {
            return ScoreStore(database: try ScoreDatabase(path: ScoreDatabase.defaultPath()))
        } catch {
            // `:memory:` kan ikke feile på samme måte, så feilen kan ignoreres her.
            let store = ScoreStore(database: (try? ScoreDatabase(path: ":memory:"))!)
            store.errorMessage = "Kunne ikke åpne databasen. Økter lagres ikke: \(error.localizedDescription)"
            return store
        }
    }

    func session(id: Int64) -> ScoreSession? {
        sessions.first { $0.id == id }
    }

    func startSession(lpClass: LPClass) -> Int64? {
        perform {
            let id = try database.createSession(lpClass: lpClass)
            reload()
            return id
        }
    }

    func record(_ score: ExerciseScore, for exercise: LPExercise, in sessionID: Int64) {
        perform {
            try database.saveScore(sessionID: sessionID, exerciseNumber: exercise.number, score: score)
            reload()
        }
    }

    func finish(sessionID: Int64) {
        perform {
            try database.finishSession(id: sessionID)
            reload()
        }
    }

    func delete(sessionID: Int64) {
        perform {
            try database.deleteSession(id: sessionID)
            reload()
        }
    }

    private func reload() {
        perform { sessions = try database.loadSessions() }
    }

    @discardableResult
    private func perform<T>(_ work: () throws -> T) -> T? {
        do {
            return try work()
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
