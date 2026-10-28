//
// This file is a part of the Lydighetsappen project
//
// Copyright (c) 2026 the Lydighetsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import SwiftUI

struct HelpAndSupportScreen: View {
    var body: some View {
        List {
            Section {
                Link(destination: URL(string: "https://rallyappen.no/#faq")!) {
                    HStack {
                        Label("Ofte stilte spørsmål", systemImage: "questionmark.circle")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(UIColor.systemGray3))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                
                Link(destination: URL(string: "https://rallyappen.no/help/feedback")!) {
                    HStack {
                        Label("Send oss feedback", systemImage: "bubble.and.pencil")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(UIColor.systemGray3))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .navigationTitle("Hjelp og support")
    }
}

#Preview {
    NavigationStack {
        HelpAndSupportScreen()
    }
}
