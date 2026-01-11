//
//  ContentView.swift
//  LearningMetal
//
//  Created by Elyan Gutierrez on 1/9/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var temp : Float = 0.0;
    
    var body: some View {
        VStack {
            Image("doggy")
                .resizable()
                .frame(width: 300, height: 375)
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.warmth(
                            .float2(proxy.size),
                            .float(temp)
                        ))
                }
            
            Slider(value: $temp, in: -1...1)
                .padding()
            
            Button(action: {
                temp = 0.0
            }) {
                Text("Reset")
            }
        }
    }
}

#Preview {
    ContentView()
}
