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

/// Kort som presenterer en klasse på hjemskjermen.
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

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
                .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func chip(_ text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.caption2.weight(.medium))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(lpClass.accentColor.opacity(0.12), in: Capsule())
            .foregroundStyle(lpClass.accentColor)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            ForEach(LPClass.allCases) { ClassCard(lpClass: $0) }
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
