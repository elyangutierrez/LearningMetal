//
//  ContentView.swift
//  LearningMetal
//
//  Created by Elyan Gutierrez on 1/9/26.
//

import SwiftUI

struct ContentView: View {
    
    let size: CGSize = CGSize(width: 300, height: 300)
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(width: 300, height: 300)
                .visualEffect { content, proxy in
                    content
                        .colorEffect(
                            ShaderLibrary.stripes(.float2(proxy.size))
                        )
                }
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .shadow(radius: 15)
        }
    }
}

#Preview {
    ContentView()
}
