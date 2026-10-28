//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct BrowseScreen: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        InformationScreen()
                    } label: {
                        Label("Informasjon", systemImage: "info.circle.fill")
                    }
                }
                
                Section {
                    NavigationLink {
                        TestCommandsScreen()
                    } label: {
                        Label("Test av kommandoer", systemImage: "speaker.wave.2")
                    }
                } header: {
                    VStack(alignment: .leading) {
                        Text("Verktøy")
                    }
                }
            }
            .navigationTitle("Utforsk")
        }
    }
}

#Preview {
    BrowseScreen()
}
