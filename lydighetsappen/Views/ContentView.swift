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
                HomeView()
    
            }
            
            Tab("Fot", systemImage: "pawprint") {
                FotView()
            }
            
            Tab("Utforsk", systemImage: "square.grid.2x2.fill") {
                BrowseView()
            }
            
//            Tab("Kommandoer", systemImage: "pawprint") {
//                TestCommands()
//            }
        }
    }
}

#Preview {
    ContentView()
}
