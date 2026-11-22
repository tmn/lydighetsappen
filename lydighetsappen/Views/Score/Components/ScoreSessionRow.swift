//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct ScoreSessionRow: View {
    let session: ScoreSession

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(session.lpClass.title)
                Spacer()
                Text(session.startedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Text(summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var summary: String {
        guard session.isFinished else {
            return "Pågår · \(session.scores.count) av \(session.lpClass.exercises.count) øvelser"
        }
        let points = "\(session.points.scoreText) av \(session.lpClass.maxPoints) poeng"
        guard let prize = session.prize else { return points }
        return "\(points) · \(prize). premie"
    }
}
