//
//  Chapter1.metal
//  LearningMetal
//
//  Created by Elyan Gutierrez on 1/9/26.
//

#include <metal_stdlib>
using namespace metal;

// Basic Colors

[[ stitchable ]]
half4 challengeOne (float2 position, half4 color, half4 newColor) {
    return half4(newColor.rgb, color.a);
}

// Interactive Brightness

[[ stitchable ]]
half4 challengeTwo (float2 position, half4 color, float brightness) {
    return half4(color.rgb * brightness, color.a);
}

// Color Channel Isolation

[[ stitchable ]]
half4 challengeThree (float2 position, half4 color, float option) {
    
    if (option == 2.0) {
        return half4(color.r, 0.0, 0.0, color.a);
    } else if (option == 3.0) {
        return half4(0.0, color.g, 0.0, color.a);
    } else if (option == 4.0) {
        return half4(0.0, 0.0, color.b, color.a);
    }
    
    return color;
}

// Simple Flag Creator

[[ stitchable ]]
half4 challengeFourA (float2 position, half4 color, half4 newColor) {
    return half4(newColor.rgb, color.a);
}

[[ stitchable ]]
half4 challengeFourB (float2 position, half4 color, half4 newColor) {
    return half4(newColor.rgb, color.a);
}

[[ stitchable ]]
half4 challengeFourC (float2 position, half4 color, half4 newColor) {
    return half4(newColor.rgb, color.a);
}

// Animated Pulse

[[ stitchable ]]
half4 challengeFive (float2 position, half4 color, float time) {
    half4 colorA = half4(1.0, 0.0, 0.0, 1.0);
    half4 colorB = half4(0.0, 0.0, 1.0, 1.0);
    
    half4 newColor = mix(colorA, colorB, abs(sin(time)));
    
    return newColor;
}
