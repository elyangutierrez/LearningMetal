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
                
                Rectangle()
                    .frame(width: 300, height: 300)
                    .visualEffect { content, proxy in
                        content
                            .colorEffect(ShaderLibrary.gridExplorer(
                                .float2(proxy.size)
                            ))
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
