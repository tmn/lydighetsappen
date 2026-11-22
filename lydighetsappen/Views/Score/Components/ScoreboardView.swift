//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct ScoreboardView: View {
    let text: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black
            Text(text)
                .font(.system(size: 600, weight: .heavy, design: .rounded))
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .foregroundStyle(.white)
                .padding()
        }
        .ignoresSafeArea()
        .contentShape(Rectangle())
        .onTapGesture { dismiss() }
        .statusBarHidden()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Karakter \(text)")
        .accessibilityHint("Trykk for å lukke poengtavla")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    ScoreboardView(text: "7,5")
}
