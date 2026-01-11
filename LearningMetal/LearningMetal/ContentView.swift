//
//  ContentView.swift
//  LearningMetal
//
//  Created by Elyan Gutierrez on 1/9/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var time : Float = 0.0
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 400, height: 300)
                .visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.rotatingPattern(
                            .float2(proxy.size),
                            .float(time)
                        ))
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1/60.0, repeats: true) { _ in
                        time += 1/60.0;
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
