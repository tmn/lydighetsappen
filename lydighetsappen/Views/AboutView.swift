//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct AboutView: View {
    let appVersion: String

    init () {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            appVersion = version
        } else {
            appVersion = "..."
        }
    }
    
    
    var body: some View {
        List {
            LabeledContent("Versjon", value: appVersion)
        }
        .navigationTitle("Om")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
