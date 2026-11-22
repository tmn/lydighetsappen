//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct ScoreResultView: View {
    let session: ScoreSession
    let onClose: () -> Void

    private var skippedCount: Int {
        session.scores.values.filter(\.isSkipped).count
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 4) {
                    Text(session.points.scoreText)
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                    Text("av \(session.lpClass.maxPoints) poeng")
                        .foregroundStyle(.secondary)
                    Text(prizeText)
                        .font(.headline)
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .accessibilityElement(children: .combine)
            }

            Section {
                ForEach(session.lpClass.exercises) { exercise in
                    row(for: exercise)
                }
            } header: {
                Text(session.lpClass.title)
            } footer: {
                if skippedCount > 0 {
                    Text("\(skippedCount) øvelse(r) ble hoppet over og gir full score.")
                }
            }
        }
        .navigationTitle("Resultat")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Ferdig", action: onClose)
            }
        }
    }

    private var prizeText: String {
        session.prize.map { "\($0). premie" } ?? "Ingen premie"
    }

    private func row(for exercise: LPExercise) -> some View {
        let score = session.scores[exercise.number]
        return HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(exercise.number) · \(exercise.title)")
                Text(detail(for: score, coefficient: exercise.coefficient))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(session.points(for: exercise).scoreText)
                .font(.headline)
                .monospacedDigit()
        }
    }

    private func detail(for score: ExerciseScore?, coefficient: Int) -> String {
        guard let score else { return "Ikke vurdert" }
        let calculation = "Karakter \(score.grade.scoreText) × \(coefficient)"
        return score.isSkipped ? "Hoppet over · \(calculation)" : calculation
    }
}
