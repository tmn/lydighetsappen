//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

struct ExerciseScore: Hashable {
    static let maxHalfGrade = 20

    var halfGrade: Int
    var isSkipped: Bool

    var grade: Double { Double(halfGrade) / 2 }

    static let skipped = ExerciseScore(halfGrade: maxHalfGrade, isSkipped: true)
}

struct ScoreSession: Identifiable, Hashable {
    let id: Int64
    let lpClass: LPClass
    let startedAt: Date
    var finishedAt: Date?
    var scores: [String: ExerciseScore]

    var isFinished: Bool { finishedAt != nil }

    var isComplete: Bool {
        lpClass.exercises.allSatisfy { scores[$0.number] != nil }
    }

    var firstUnscoredIndex: Int? {
        lpClass.exercises.firstIndex { scores[$0.number] == nil }
    }

    func points(for exercise: LPExercise) -> Double {
        Double(exercise.coefficient) * (scores[exercise.number]?.grade ?? 0)
    }

    var points: Double {
        lpClass.exercises.reduce(0) { $0 + points(for: $1) }
    }

    var prize: Int? {
        lpClass.prizeThresholds.first { points >= Double($0.points) }?.prize
    }
}

extension Double {
    var scoreText: String {
        formatted(.number.precision(.fractionLength(0...1)))
    }
}
