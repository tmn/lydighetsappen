//
//  ExerciseOverview.swift
//  lydighetsappen
//
//  Created by Tri Nguyen on 22/10/2026.
//

import SwiftUI

struct ExerciseOverview: View {
    var body: some View {
        List {
            NavigationLink {
                
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text("Lineføring")
                        Text("Grunnleggende samarbeid")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "pawprint")
                }
            }
            
            NavigationLink {
                
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text("Dekk fra holdt")
                        Text("Grunnleggende samarbeid")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "pawprint")
                }
            }
            
            NavigationLink {
                
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text("Innkalling")
                        Text("Presisjon og selvstendighet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "pawprint")
                }
            }
            
            NavigationLink {
                
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text("Hopp over hinder")
                        Text("Presisjon og selvstendighet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "pawprint")
                }
            }
            
            NavigationLink {
                
            } label: {
                Label {
                    VStack(alignment: .leading) {
                        Text("Avstandskontroll")
                        Text("Presisjon og selvstendighet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "pawprint")
                }
            }
        }.navigationTitle("Klasse 1")
    }
}

#Preview {
    ExerciseOverview()
}
