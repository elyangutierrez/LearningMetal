//
//  Chapter3.metal
//  LearningMetal
//
//  Created by Elyan Gutierrez on 1/10/26.
//

#include <metal_stdlib>
using namespace metal;

// EXAMPLES

// Simplified but functional RGB→HSV
float3 rgb2hsv(float3 c) {
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 p = mix(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
    float4 q = mix(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
    
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// HSV→RGB
float3 hsv2rgb(float3 c) {
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

[[ stitchable ]]
half4 brighten(float2 position, half4 color, float2 size) {
    return half4(color.rgb * 1.2, color.a);
}

[[ stitchable ]]
half4 saturate(float2 position, half4 color, float2 size) {
    float3 colorFloat = float3(color.rgb);
    float3 hsv = rgb2hsv(colorFloat);
    hsv.y = clamp(hsv.y * 1.5, 0.0, 1.0);
    float3 hsvFloat = float3(hsv);
    return half4(half3(hsv2rgb(hsvFloat)), color.a);
}

// CHALLENGES

// Basic Color Filters

[[ stitchable ]]
half4 grayscale(float2 position, half4 color, float2 size) {
    float3 weights = float3(0.299, 0.587, 0.114);
    
    float weightedR = color.r * weights.r;
    float weightedG = color.g * weights.g;
    float weightedB = color.b * weights.b;
    
    float luminance = float(weightedR + weightedG + weightedB);
    
    half3 newColor = half3(luminance, luminance, luminance) * color.a;
    
    return half4(newColor, color.a);
}

[[ stitchable ]]
half4 sepia(float2 position, half4 color, float2 size) {
    float3 weights = float3(0.299, 0.587, 0.114);
    
    float weightedR = color.r * weights.r;
    float weightedG = color.g * weights.g;
    float weightedB = color.b * weights.b;
    
    float luminance = float(weightedR + weightedG + weightedB);
    half3 brownTint = half3(0.141, 0.086, 0.0);
    
    half3 newColor = half3(luminance + brownTint.r, luminance + brownTint.g, luminance + brownTint.b) * color.a;
    
    return half4(newColor, color.a);
}

[[ stitchable ]]
half4 invert(float2 position, half4 color, float2 size) {
    half3 invertColor = 1.0 - color.rgb * color.a;
    return half4(invertColor, color.a);
}

// Selective Color Modification

[[ stitchable ]]
half4 redBoost(float2 position, half4 color, float2 size) {
    
    half3 newColor = color.rgb;
    
    if (color.r > 0.5) {
        float halfValue = newColor.r * 0.5;
        newColor.r += halfValue;
    }
    
    return half4(newColor * color.a, color.a);
}

// Color Temperature

[[ stitchable ]]
half4 warmth(float2 position, half4 color, float2 size, float temperature) {
    
    float3 weights = float3(0.299, 0.587, 0.114);
    
    half3 blueColor = half3(0.0, 0.0, 1.0);
    half3 orangeColor = half3(1.0, 0.5, 0.0);
    
    float originalLuminance = dot(float3(color.rgb), weights); // dot is a more efficient way to add and multiply values
    
    half3 tint = half3(0.0);
    
    if (temperature < 0.0) {
        tint = blueColor;
    } else {
        tint = orangeColor;
    }
    
    half3 shiftedColor = mix(color.rgb, tint, abs(temperature) * 0.2); // 0.2 helps with keeping the color not too blue or orange and feel real
    
    float newLuminance = dot(float3(shiftedColor), weights);
    
    half3 newColor = shiftedColor * (originalLuminance / newLuminance); // multiplying new color by the result of old / new luminance preserves the original luminance
    
    return half4(newColor * color.a, color.a);
}

// Hue Rotation

[[ stitchable ]]
half4 hueRotate(float2 position, half4 color, float2 size, float angle) {
    float normAngle = angle / 360.0; // normal angle between 0.0 to 1.0
    
    float3 hsv = rgb2hsv(float3(color.rgb)); // convert to hsv
    float hue = hsv.x + normAngle; // hsv.x represents hue so add the angle to that
    float nHue = fmod(hue, 1.0); // use fmod so that color is bounded 0.0 - 1.0 ( could use fract aswell )
    float3 newHsv = float3(nHue, hsv.y, hsv.z); // reconstruct hsv
    
    half3 rgbColor = half3(hsv2rgb(newHsv));
    
    return half4(rgbColor, color.a);
}

// Gradient Mapping

[[ stitchable ]]
half4 duotone(float2 position, half4 color, float2 size) {
    float3 weights = float3(0.299, 0.587, 0.114);
    
    float luminance = dot(float3(color.rgb), weights); // calc weights
    
    half3 deepBlue = half3(0.0, 0.145, 0.429);
    half3 brightOrange = half3(1.0, 0.518, 0.0);
    
    half3 tint = half3(0.0);
    
    if (luminance > 0.5) {
        // orange
        tint = brightOrange;
    } else {
        // blue
        tint = deepBlue;
    }
    
    half3 mixedColor = mix(luminance, tint, 0.5); // set to 0.5 but can be altered for a higher/lower intensity
    float newLuminance = dot(float3(mixedColor), weights); // calc new luminance based off of mixedColor
    
    half3 newColor = mixedColor * (luminance / newLuminance); // update mixed color with original luminance
    
    return half4(newColor * color.a, color.a);
}


