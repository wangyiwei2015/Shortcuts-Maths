//
//  ContentView.swift
//  shortcuts-maths
//
//  Created by leo on 2026.02.28.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack {
            Text("Hello, world!")
            
            Button("Shortcuts") {
                openURL(URL(string: "shortcuts:")!)
            }
        }.padding()
    }
}

#Preview { ContentView() }
