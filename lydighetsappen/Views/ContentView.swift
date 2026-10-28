//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Hjem", systemImage: "square.grid.2x2") {
                NavigationStack {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(LPClass.allCases) { lpClass in
                                NavigationLink {
                                    ExerciseOverview(lpClass: lpClass)
                                } label: {
                                    ClassCard(lpClass: lpClass)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .background(Color(.systemGroupedBackground))
                    .navigationTitle("Lydighetsappen")
                    .navigationBarTitleDisplayMode(.large)
                }
                
            }
            
            Tab("Fot", systemImage: "pawprint") {
                FotView()
            }
            
            Tab("Kommandoer", systemImage: "pawprint") {
                TestCommands()
            }
        }
    }
}

#Preview {
    ContentView()
}
