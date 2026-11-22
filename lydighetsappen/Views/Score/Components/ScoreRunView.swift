//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct ScoreRunView: View {
    let store: ScoreStore
    let session: ScoreSession

    @State private var index: Int

    @State private var wholeGrade: Int?
    @State private var hasHalf = false
    @State private var showsScoreboard = false

    init(store: ScoreStore, session: ScoreSession) {
        self.store = store
        self.session = session
        _index = State(initialValue: session.firstUnscoredIndex ?? 0)
    }

    private var exercises: [LPExercise] { session.lpClass.exercises }
    private var exercise: LPExercise { exercises[index] }
    private var isLast: Bool { index == exercises.count - 1 }

    private var halfGrade: Int? {
        wholeGrade.map { $0 * 2 + (hasHalf && $0 < 10 ? 1 : 0) }
    }

    private var gradeText: String {
        halfGrade.map { (Double($0) / 2).scoreText } ?? "–"
    }

    var body: some View {
        List {
            ExerciseDetailSections(exercise: exercise)
        }
        .id(exercise.number)
        .safeAreaInset(edge: .bottom, spacing: 0) { controls }
        .navigationTitle("Øvelse \(index + 1) av \(exercises.count)")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: index, initial: true) { loadSelection() }
        .fullScreenCover(isPresented: $showsScoreboard) {
            ScoreboardView(text: gradeText)
        }
    }

    private var controls: some View {
        VStack(spacing: 12) {
            HStack {
                Text(gradeText)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .monospacedDigit()
                Spacer()
                Toggle("+ ½", isOn: $hasHalf)
                    .toggleStyle(.button)
                    .disabled(wholeGrade == nil || wholeGrade == 10)
                Button {
                    showsScoreboard = true
                } label: {
                    Label("Poengtavle", systemImage: "arrow.up.left.and.arrow.down.right")
                        .labelStyle(.iconOnly)
                        .font(.title2)
                }
                .buttonStyle(.bordered)
                .disabled(halfGrade == nil)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6), spacing: 8) {
                ForEach(0...10, id: \.self) { grade in
                    gradeButton(grade)
                }
            }

            HStack {
                if index > 0 {
                    Button("Forrige") { index -= 1 }
                        .buttonStyle(.bordered)
                }
                Button("Hopp over") { save(.skipped) }
                    .buttonStyle(.bordered)
                Spacer()
                Button(isLast ? "Fullfør" : "Neste") {
                    if let halfGrade {
                        save(ExerciseScore(halfGrade: halfGrade, isSkipped: false))
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(halfGrade == nil)
            }
        }
        .padding()
        .background(.bar)
    }

    private func gradeButton(_ grade: Int) -> some View {
        let isSelected = wholeGrade == grade
        return Button {
            wholeGrade = grade
            if grade == 10 { hasHalf = false }
        } label: {
            Text("\(grade)")
                .font(.title3.weight(.semibold))
                .frame(maxWidth: .infinity, minHeight: 40)
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .background(isSelected ? Color.accentColor : Color(.systemGray5), in: RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func loadSelection() {
        if let score = session.scores[exercise.number], !score.isSkipped {
            wholeGrade = score.halfGrade / 2
            hasHalf = score.halfGrade % 2 == 1
        } else {
            wholeGrade = nil
            hasHalf = false
        }
    }

    private func save(_ score: ExerciseScore) {
        store.record(score, for: exercise, in: session.id)
        if !isLast {
            index += 1
        } else if store.session(id: session.id)?.isComplete == true {
            store.finish(sessionID: session.id)
        }
    }
}
