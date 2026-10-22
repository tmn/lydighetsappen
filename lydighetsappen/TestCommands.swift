//
//  TestCommands.swift
//  lydighetsappen
//
//  Created by Tri Nguyen on 22/10/2026.
//

import SwiftUI

struct TestCommands: View {
    @State private var audioCommand = AudioCommand()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(FotCommand.allCases, id: \.rawValue) { item in
                    Button {
                        Task {
                            audioCommand.say("\(item.title)")
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
    TestCommands()
}
