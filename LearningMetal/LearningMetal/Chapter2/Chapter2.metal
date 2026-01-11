//
//  Chapter2.metal
//  LearningMetal
//
//  Created by Elyan Gutierrez on 1/9/26.
//

#include <metal_stdlib>
using namespace metal;

// EXAMPLES

[[ stitchable ]]
half4 horizontalGradient(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    return half4(uv.x, uv.x, uv.x, 1.0);
}

[[ stitchable ]]
half4 circle(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    float2 center = uv - 0.5;
    
    float distance = length(center);
    
    if (distance < 0.3) {
        return half4(1.0, 1.0, 1.0, 1.0);
    } else {
        return half4(0.0, 0.0, 0.0, 1.0);
    }
}

[[ stitchable ]]
half4 smoothCircle(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    float2 center = uv - 0.5;
    
    float distance = length(center);
    
    float circle = 1.0 - smoothstep(0.29, 0.41, distance);
    
    if (circle >= 0.3 and circle <= 0.35) {
        return half4(0.0, 1.0, 0.0, 1.0);
    }
    
    return half4(circle, circle, circle, 1.0);
}

[[ stitchable ]]
half4 grid(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    float2 grid = fract(uv * 8.0); // allows for repeating textures/views
    
    float lineWidth = 0.1;
    float lines = 0.0;
    
    if (grid.x < lineWidth || grid.y < lineWidth) {
        lines = 1.0;
    }
    
    return half4(lines, lines, lines, 1.0);
}

[[ stitchable ]]
half4 radial(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    float2 center = uv - 0.5;
    
    // float aspectRatio = size.x / size.y // ensures that it is a circle regardless of screen size
    // float2 center = (uv - 0.5) * float2(aspectRatio, 1.0)
    
    float distance = length(center);
    float scale = 40.0; // higher the scale, the more circles that appear
    float pattern = sin(distance * scale) * 0.5 + 0.5;
    
    return half4(pattern, pattern, pattern, 1.0);
}

// CHALLENGES

// Basic Gradients

[[ stitchable ]]
half4 verticalGradient(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    half3 newColor = half3(uv.y);
    
    return half4(newColor, 1.0);
}

[[ stitchable ]]
half4 diagonalGradient(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    
    float diagonal = (uv.x + uv.y) / 2.0;
    
    return half4(diagonal, diagonal, diagonal, 1.0);
}

[[ stitchable ]]
half4 radialGradient(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    float2 center = uv - 0.5;

    float distance = length(center);
    
    float smoothGradient = 1.0 - smoothstep(0.01, 1.0, distance);
    
    return half4(smoothGradient, smoothGradient, smoothGradient, 1.0);
}

// Shape Drawing

// smoothCircle validates this one here...

[[ stitchable ]]
half4 ring(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    float2 center = uv - 0.5;
    
    float distance = length(center);
    
    if (distance >= 0.4) {
        return half4(0.0, 0.0, 0.0, 1.0);
    } else if (distance <= 0.4 and distance >= 0.2) {
        return half4(1.0, 1.0, 1.0, 1.0);
    } else {
        return half4(0.0, 0.0, 0.0, 1.0);
    }
}

[[ stitchable ]]
half4 square(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    float2 center = uv - 0.5;
    
    float halfSize = 0.2;
    
    if (abs(center.x) < halfSize && abs(center.y) < halfSize) { // creates strips for both x = -0.2 ~ 0.2 and y = -0.2 ~ 0.2 and checks if current position is within the absolute x and y.
        return half4(1.0, 1.0, 1.0, 1.0);
    } else {
        return half4(0.0, 0.0, 0.0, 1.0);
    }
}

// Pattern Creation

[[ stitchable ]]
half4 checkerboard(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    float2 grid = fract(uv * 4.0); // 4.0 since 0.5 in steps doubles
    
    float2 v = step(0.5, grid); // creates horizontal and vertical stripe pattern
    
    float result = abs(v.x - v.y); // gets absolute value of subtraction
    
    return half4(half3(result), 1.0);
}

[[ stitchable ]]
half4 stripes(float2 position, half4 color, float2 size) {
    float2 uv = position / size;
    
    float2 f = fract(uv * 3.7); // creates ~ 3 stripes
    
    float topStep = smoothstep(0.6, 1.0, f.y); // smooth gradient for top
    float bottomStep = smoothstep(0.0, 0.4, f.y); // smooth gradient for bottom
    
    float result = (bottomStep - topStep); // gets resulting color
    
    return half4(result, result, result, 1.0);
}

// Interactive Spotlight

[[ stitchable ]]
half4 spotlight(float2 position, half4 color, float2 size, float2 lightCenter) {
    float2 uv = position / size;
    float2 center = uv - lightCenter; // instead of -0.5, - lightCenter since we are updating the center based off of the new position from DragGesture
    
    float distance = length(center);
    
    float circle = 1.0 - smoothstep(0.15, 0.35, distance);
    
    return half4(circle, circle, circle, 1.0);
}

// Coordinate Transformations

[[ stitchable ]]
half4 rotatingPattern(float2 position, half4 color, float2 size, float time) {
    // need to rotate the coordinates using time
    // create pattern
    
    float aspectRatio = size.x / size.y;
    
    float2 uv = position / size;
    float2 centeredUV = uv - 0.5; // center so that pattern rotates based off of center and not (0,0)
    centeredUV.x *= aspectRatio;
    
    // formulas from online
    float cosT = cos(time);
    float sinT = sin(time);
    float rotX = centeredUV.x * cosT - centeredUV.y * sinT;
    float rotY = centeredUV.x * sinT + centeredUV.y * cosT;
    
    float2 rotatedUV = float2(rotX, rotY); // updated uv
    
    float2 f = fract(rotatedUV * 3.0);
    float2 centerCircle = (f - 0.5);
    
    float distance = length(centerCircle);
    
    float smoothCircle = 1.0 - smoothstep(0.25, 0.40, distance);
    
    half3 pulsingColor = half3(smoothCircle) * abs(sin(time)); // brightness pulses for extra fun!
    
    return half4(pulsingColor, 1.0);
}
