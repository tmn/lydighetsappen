//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct ScoreScreen: View {
    @State private var store = ScoreStore.shared
    @State private var path: [Int64] = []

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    ForEach(LPClass.allCases) { lpClass in
                        Button {
                            if let id = store.startSession(lpClass: lpClass) {
                                path.append(id)
                            }
                        } label: {
                            Label {
                                VStack(alignment: .leading) {
                                    Text(lpClass.title)
                                        .foregroundStyle(.primary)
                                    Text("\(lpClass.exercises.count) øvelser · maks \(lpClass.maxPoints) poeng")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            } icon: {
                                Image(systemName: lpClass.systemImage)
                            }
                        }
                    }
                } header: {
                    Text("Start ny økt")
                } footer: {
                    Text("Velg klasse, gi karakter for hver øvelse og få sluttsummen. Hopper du over en øvelse, får den full score.")
                }

                if !store.sessions.isEmpty {
                    Section("Tidligere økter") {
                        ForEach(store.sessions) { session in
                            NavigationLink(value: session.id) {
                                ScoreSessionRow(session: session)
                            }
                        }
                        .onDelete { offsets in
                            let ids = offsets.map { store.sessions[$0].id }
                            ids.forEach { store.delete(sessionID: $0) }
                        }
                    }
                }
            }
            .navigationTitle("Konkurranse")
            .navigationDestination(for: Int64.self) { id in
                ScoreSessionScreen(store: store, sessionID: id) {
                    path.removeAll()
                }
            }
            .alert("Noe gikk galt", isPresented: errorBinding) {
                Button("OK") { store.errorMessage = nil }
            } message: {
                Text(store.errorMessage ?? "")
            }
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { store.errorMessage != nil },
            set: { if !$0 { store.errorMessage = nil } }
        )
    }
}

#Preview {
    ScoreScreen()
}
