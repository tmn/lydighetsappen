//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct TestCommandsScreen: View {
    @State private var audioCommand = AudioCommand()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    
                } header: {
                    Text("Her kan du teste lydkommandoer.")
                        .listRowInsets(EdgeInsets())
                        .font(.subheadline)
                }
                ForEach(FotCommand.allCases, id: \.rawValue) { item in
                    Button {
                        Task {
                            audioCommand.say(item.spokenText)
                        }
                    } label: {
                        Text("\(item.title)")
                            .frame(maxWidth: .infinity)
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                    .padding(.bottom)
                    .buttonStyle(.glassProminent)
                    .controlSize(.large)
                    .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Testkommandoer")
        }
    }
}

#Preview {
    TestCommandsScreen()
}
