//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

extension LPClass {
    var accentColor: Color {
        switch self {
        case .klasse1: .blue
        case .klasse2: .green
        case .klasse3: .orange
        case .fci3: .purple
        }
    }
}

struct ClassCard: View {
    let lpClass: LPClass

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(lpClass.title)
                        .font(.headline)
                    Text(lpClass.tagline)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                HStack(spacing: 6) {
                    chip("\(lpClass.exercises.count) øvelser", systemImage: "list.bullet")
                    chip("\(lpClass.footExerciseName), ca. \(lpClass.recommendedFootMinutes) min", systemImage: "figure.walk")
                }
            }

            Spacer(minLength: 0)
        }
    }

    private func chip(_ text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.caption2.weight(.medium))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(lpClass.accentColor.opacity(0.12), in: Capsule())
            .foregroundStyle(lpClass.accentColor)
            .labelIconToTitleSpacing(2)
    }
}

#Preview {
    NavigationStack {
        List(LPClass.allCases) { lpClass in
            Section {
                NavigationLink {
                    ExerciseOverview(lpClass: lpClass)
                } label: {
                    ClassCard(lpClass: lpClass)
                }
            }
        }
        .listSectionSpacing(.compact)
    }
}
