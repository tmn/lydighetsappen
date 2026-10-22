import SwiftUI
import Playgrounds

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Hjem", systemImage: "square.grid.2x2") {
                NavigationStack {
                    List {
                        Section {
                            NavigationLink {
                                ExerciseOverview()
                            } label: {
                                Label("Klasse 1", systemImage: "1.circle")
                            }
                            
                            NavigationLink {
                                ExerciseOverview()
                            } label: {
                                Label("Klasse 2", systemImage: "2.circle")
                            }
                            
                            NavigationLink {
                                ExerciseOverview()
                            } label: {
                                Label("Klasse 3", systemImage: "3.circle")
                            }
                            
                            NavigationLink {
                                ExerciseOverview()
                            } label: {
                                Label("FCI 3", systemImage: "pawprint.circle")
                            }
                        } header: {
                            Text("Klasser")
                        }
                    }
                    .navigationTitle("LP")
                    .navigationBarTitleDisplayMode(.large)
                }
                
            }
            
            Tab("Fot", systemImage: "pawprint") {
                Fot()
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
//
//#Playground {
//    _ = 1 + 2
//}
