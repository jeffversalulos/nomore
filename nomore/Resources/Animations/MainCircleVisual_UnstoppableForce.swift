//
//  MainCircleVisual_UnstoppableForce.swift
//  nomore
//
//  Created by Aa on 2025-11-23.
//

import SwiftUI
import Lottie

struct MainCircleVisual_UnstoppableForce: View {
    var body: some View {
        LottieView(animation: .named("MainCircle"))
            .playing(loopMode: .loop)
            .animationSpeed(0.6)
            .frame(width: 317, height: 317)
            .blur(radius: 2)
            .saturation(1.3)
            .colorMultiply(.pink) // Pink - unstoppable force and power
    }
}

#Preview {
    MainCircleVisual_UnstoppableForce()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
}

