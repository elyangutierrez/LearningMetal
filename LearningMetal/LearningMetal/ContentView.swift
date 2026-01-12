//
//  ContentView.swift
//  LearningMetal
//
//  Created by Elyan Gutierrez on 1/9/26.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Image("doggy")
                .resizable()
                .frame(width: 300, height: 375)
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.duotone(
                            .float2(proxy.size),
                        ))
                }
        }
    }
}

#Preview {
    ContentView()
}
