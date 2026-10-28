//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    
                } header: {
                    VStack(alignment: .leading) {
                        Text("Velg en klasse")
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                        Text("Se beskrivelser og øvelser fra alle kalsser.")
                            .font(.subheadline)
                    }
                    .listRowInsets(EdgeInsets())
                }
                
                ForEach(LPClass.allCases) { lpClass in
                    Section {
                        NavigationLink {
                            ExerciseOverview(lpClass: lpClass)
                        } label: {
                            ClassCard(lpClass: lpClass)
                        }
                    }
                }
                
            }
            .listSectionSpacing(.compact)
//            .background(Color(.systemGroupedBackground))
            .navigationTitle("Lydighetsappen")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    HomeScreen()
}
