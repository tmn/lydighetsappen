//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct ScoreSessionScreen: View {
    let store: ScoreStore
    let sessionID: Int64

    let onClose: () -> Void

    var body: some View {
        if let session = store.session(id: sessionID) {
            if session.isFinished {
                ScoreResultView(session: session, onClose: onClose)
            } else {
                ScoreRunView(store: store, session: session)
            }
        } else {
            ContentUnavailableView("Økta finnes ikke", systemImage: "questionmark.folder")
        }
    }
}
