//
//  Chapter4.metal
//  LearningMetal
//
//  Created by Elyan Gutierrez on 1/12/26.
//

#include <metal_stdlib>
using namespace metal;

// FUNCTIONS

float rand(float2 co) {
    float a = 12.9888;
    float b = 78.223;
    float c = 43758.90;
    
    return fract(sin(dot(co.xy, float2(a, b))) * c);
}

// EXAMPLES

[[ stitchable ]]
half4 interferencePattern(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    
    float wave1 = sin(uv.x * 10.0);
    float wave2 = sin(uv.y * 10.0);
    
    float interference = wave1 * wave2;
    
    float brightness = interference * 0.5 + 0.5;
    
    return half4(brightness, brightness, brightness, 1.0);
}

[[ stitchable ]]
half4 travelingWave(float2 position, half4 color, float2 size, float time) {
    float2 uv = position / size;
    
    float phase = time * 2.0; // double the rotations
    float amount = 10.0 - phase; // higher the number the more waves appear
    float wave = sin(uv.x * amount); // phase creates the wave
    
    float brightness = wave * 0.5 + 0.5; // brightness = light/dark
    
    return half4(brightness, brightness, brightness, 1.0);
}

[[ stitchable ]]
half4 radialPulse(float2 position, half4 color, float2 size, float time) {
    float2 uv = position / size;
    float2 center = uv - 0.5;
    
    float radius = length(center);
    
    float wave = sin(radius * 30.0 - time * 3.0);
    
    float mask = 1.0 - smoothstep(0.4, 0.5, radius);
    
    float brightness = wave * 0.5 + 0.5;
    
    float final = brightness * mask;
    
    return half4(final, final, final, 1.0);
}

[[ stitchable ]]
half4 falloffComparision(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    
    float linear = uv.x;
    float quadratic = pow(uv.x, 2.0);
    float sqrt = pow(uv.x, 0.5);
    
    return half4(linear, quadratic, sqrt, 1.0);
}

[[ stitchable ]]
half4 complexWave(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    
    float wave = 0.0;
    float amplitude = 1.0;
    float frequency = 1.0;
    
    for (int i = 0; i < 4; i++) {
        wave += sin(uv.x * frequency * 10.0) * amplitude;
        
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    
    float brightness = wave * 0.5 + 0.5;
    
    return half4(brightness, brightness, brightness, 1.0);
}

// CHALLENGES

// Wave Mastery

[[ stitchable ]]
half4 waveVisualizer(float2 position, half4 color, float2 size, float time) {
    float2 uv = position / size;
    uv = uv * 2.0 - 1.0;
    uv = uv * 3.0;
    
    float regSine = sin(uv.x + time);
    float doubleFreqSine = sin(uv.x * 2.0 + time);
    float halfAmpSine = sin(uv.x + time) * 0.5;
    
    float lineThickness = 0.05;
    
    // (logic below is from shadertoy)
    // normal sine
    
    float dist = abs(uv.y - regSine); // checks if pixel is close to wave 
    float wave = smoothstep(0.1, lineThickness, dist); // create smooth lines
    
    // double freq sine
    
    float dist2 = abs(uv.y - doubleFreqSine);
    float wave2 = smoothstep(0.1, lineThickness, dist2);
    
    // half amp sin
    
    float dist3 = abs(uv.y - halfAmpSine);
    float wave3 = smoothstep(0.1, lineThickness, dist3);
    
    half3 finalColor = half3(wave, wave2, wave3);
    
    return half4(finalColor, 1.0);
}

// Fract Exploration

[[ stitchable ]]
half4 gridExplorer(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    
    float2 f = fract(uv * 5.0);
    f = f - 0.5;
    
    float2 gridCoord = floor(uv * 5.0);
    
    // using function from online to generate colors based off of gridCoord
    float r = rand(gridCoord);
    float g = rand(gridCoord + float2(1.0, 0.0));
    float b = rand(gridCoord + float2(0.0, 1.0));

    half3 finalColor = half3(r, g, b);
    
    if (step(0.35, f.x) || step(0.35, f.y)) {
        finalColor = half3(1.0); // borders
    }
    
    return half4(finalColor, 1.0);
}

// Smoothstep Animation

[[ stitchable ]]
half4 breathingCircle(float2 position, half4 color, float2 size, float time) {
    float2 uv = position / size;
    float2 center = uv - 0.5;
    
    float distance = length(center);
    
    float pulse = (distance + abs(sin(time * 0.5)) * 0.15); // sine freq in half and rate is slow
    
    float smooth = 1.0 - smoothstep(0.33, 0.4, pulse);
    
    half3 newColor = half3(smooth * abs(sin(time)), smooth * 0.3, smooth * 0.8); // use random numbers and time to get color
    
    return half4(newColor, 1.0);
}
