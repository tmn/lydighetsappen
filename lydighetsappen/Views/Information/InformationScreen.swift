//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct InformationScreen: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    
                } header: {
                    VStack(alignment: .leading) {
                        Text("Lydighetsappen gir deg oversikt over alle klasser i lydighet.")
                    }
                    .font(.subheadline)
                    .listRowInsets(EdgeInsets())
                }
                
                Section {
                    NavigationLink {
                        HelpAndSupportScreen()
                    } label: {
                        Label("Hjelp og support", systemImage: "questionmark.circle.fill")
                    }
                    NavigationLink {
                        AboutScreen()
                    } label: {
                        Label("Om", systemImage: "info.circle.fill")
                    }
                } footer: {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Informasjon er hentet fra NKKs reglement og gjengitt.")
                        Text("Lydighetsappen er en uavhengig applikasjon og har ingen tilknytning til Lydighetsnorge, Norsk Kennel Klub, eller andre klubber.")
                    }
                }
            }
            .navigationTitle("Informasjon")
        }
    }
}

#Preview {
    InformationScreen()
}
