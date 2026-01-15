//
//  ContentView.swift
//  LearningMetal
//
//  Created by Elyan Gutierrez on 1/9/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var startTime = Date.now
    
    var body: some View {
        VStack {
            TimelineView(.animation) { tl in
                
                let timeAfter = startTime.timeIntervalSince(tl.date)
                
                Image("doggy")
                    .resizable()
                    .frame(width: 300, height: 350)
                    .visualEffect { content, proxy in
                        content
                            .distortionEffect(ShaderLibrary.ripple(
                                .float2(proxy.size),
                                .float(timeAfter)
                            ), maxSampleOffset: .zero)
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
