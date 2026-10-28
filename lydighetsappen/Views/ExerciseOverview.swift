//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct ExerciseOverview: View {
    let lpClass: LPClass
    
    var body: some View {
        List {
            Section {
                
            } header: {
                VStack(alignment: .leading, spacing: 12) {
                    Text(lpClass.introduction)
                        .font(.subheadline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        pill {
                            Label("Maks poengsum: \(lpClass.maxPoints)", systemImage: "trophy")
                        }
                        
                        HStack(spacing: 8) {
                            ForEach(lpClass.prizeThresholds, id: \.prize) { threshold in
                                pill {
                                    Text("\(threshold.prize). premie: \(threshold.points)")
                                }
                            }
                        }
                    }
                }
                .textCase(nil)
                .listRowInsets(EdgeInsets())
            }
            
            Section("Øvelser") {
                ForEach(lpClass.exercises) { exercise in
                    NavigationLink {
                        ExerciseDetail(exercise: exercise)
                    } label: {
                        Label {
                            VStack(alignment: .leading) {
                                Text("\(exercise.number) · \(exercise.title)")
                                Text("Koeffisient \(exercise.coefficient)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: "pawprint")
                        }
                    }
                }
            }
        }
        .navigationTitle(lpClass.title)
    }
    
    private func pill<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .font(.footnote.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray5), in: Capsule())
    }
}

#Preview {
    NavigationStack {
        ExerciseOverview(lpClass: .klasse1)
    }
}
