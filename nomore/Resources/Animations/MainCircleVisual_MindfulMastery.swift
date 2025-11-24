//
//  MainCircleVisual_MindfulMastery.swift
//  nomore
//
//  Created by Aa on 2025-11-23.
//

import SwiftUI
import Lottie

struct MainCircleVisual_MindfulMastery: View {
    var body: some View {
        LottieView(animation: .named("MainCircle"))
            .playing(loopMode: .loop)
            .animationSpeed(0.6)
            .frame(width: 317, height: 317)
            .blur(radius: 2)
            .saturation(1.3)
            .colorMultiply(Color(red: 0.85, green: 0.5, blue: 1.0)) // Bright lavender - mindfulness and mastery
    }
}

#Preview {
    MainCircleVisual_MindfulMastery()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
}

