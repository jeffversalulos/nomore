//
//  SoothingOrb.swift
//  nomore
//
//  Created by Aa on 2025-08-24.
//

import SwiftUI

struct SoothingOrb: View {
    let phase: BreathPhase
    let progress: Double // 0...1 within current phase

    private var scale: CGFloat {
        let baseScale: CGFloat = 0.65
        let amplitude: CGFloat = 0.25
        
        switch phase {
        case .inhale:
            return baseScale + amplitude * CGFloat(progress)
        case .hold:
            return baseScale + amplitude
        case .exhale:
            return baseScale + amplitude * CGFloat(1 - progress)
        case .rest:
            return baseScale
        }
    }
    
    private var borderWidth: CGFloat {
        let minBorderWidth: CGFloat = 2
        let maxBorderWidth: CGFloat = 10
        let borderAmplitude = maxBorderWidth - minBorderWidth
        
        switch phase {
        case .inhale:
            return minBorderWidth + borderAmplitude * CGFloat(progress)
        case .hold:
            return maxBorderWidth
        case .exhale:
            return maxBorderWidth - borderAmplitude * CGFloat(progress)
        case .rest:
            return minBorderWidth
        }
    }

    var body: some View {

        ZStack {
            // Soft glowing gradient circles
            Circle()
                .fill(
                    RadialGradient(colors: [Theme.accent.opacity(0.7), .clear], center: .center, startRadius: 20, endRadius: 220)
                )
                .blur(radius: 30)

            Circle()
                .fill(
                    LinearGradient(colors: [Theme.purple.opacity(0.9), Theme.indigo.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .overlay(
                    Circle().stroke(.white, lineWidth: borderWidth)
                )
                .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
        }
        .scaleEffect(scale)
        .frame(width: 260, height: 260)
        .animation(.easeInOut(duration: 0.25), value: scale)
        .animation(.easeInOut(duration: 0.25), value: borderWidth)
        // Removed line progress overlay
        .accessibilityHidden(true)
    }
}
