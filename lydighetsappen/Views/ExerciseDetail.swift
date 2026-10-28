//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct ExerciseDetail: View {
    let exercise: LPExercise
    
    var body: some View {
        List {
            Section {
                summaryCard
                    // Litt luft rundt kortet, ellers klipper listeraden hjørnene og kanten.
                    .listRowInsets(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
                    .listRowBackground(Color.clear)
            }
            
            
            if !exercise.commands.isEmpty {
                Section("Kommandoer") {
                    ForEach(exercise.commands, id: \.self) { command in
                        Label(command, systemImage: "person.wave.2")
                    }
                }
            }
            
            Section {
                ForEach(Array(exercise.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(index + 1).")
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                        VStack(alignment: .leading, spacing: 2) {
                            if step.isOrdered {
                                Label("På ordre", systemImage: "megaphone")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.tint)
                            }
                            Text(step.text)
                        }
                    }
                }
            } header: {
                Text("Slik utføres øvelsen")
            } footer: {
                Text("«På ordre» betyr at konkurranselederen gir beskjed før du gjør handlingen. Vent på ordren. Konkurranselederen gir beskjed i alle faser av øvelsen, også der regelteksten ikke sier det uttrykkelig.")
            }
            
            Section("Dommeren legger vekt på") {
                ForEach(exercise.judging, id: \.self) { point in
                    Text(point)
                }
            }
        }
        .navigationTitle(exercise.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Øvelse \(exercise.number)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.tint)
                Spacer()
                Label("Koeffisient \(exercise.coefficient)", systemImage: "star.fill")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.tint.opacity(0.15), in: Capsule())
                    .foregroundStyle(.tint)
            }
            
            Text(exercise.title)
                .font(.title2.bold())
            
            Text(exercise.summary)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(.tint.opacity(0.25), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        ExerciseDetail(exercise: LPClass.klasse1.exercises[2])
    }
}
