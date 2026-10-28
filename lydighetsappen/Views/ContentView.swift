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
            Tab {
                HomeView()
            } label: {
                Label {
                    Text("Hjem")
                } icon: {
                    Image(uiImage: Self.outlineTabImage("text.rectangle.page"))
                }
            }

            Tab("Fot", systemImage: "pawprint") {
                FotView()
            }
            
            Tab {
                BrowseView()
            } label: {
                Label {
                    Text("Utforsk")
                } icon: {
                    Image(uiImage: Self.outlineTabImage("square.grid.2x2"))

                }
            }
        }
    }

    private static func outlineTabImage(_ name: String) -> UIImage {
        let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        guard let symbol = UIImage(systemName: name, withConfiguration: configuration)?
            .withTintColor(.black, renderingMode: .alwaysOriginal) else {
            return UIImage()
        }
        let bitmap = UIGraphicsImageRenderer(size: symbol.size).image { _ in
            symbol.draw(at: .zero)
        }
        return bitmap.withRenderingMode(.alwaysTemplate)
    }
}

#Preview {
    ContentView()
}
