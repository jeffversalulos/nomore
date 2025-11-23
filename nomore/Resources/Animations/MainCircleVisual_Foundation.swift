//
//  MainCircleVisual_Foundation.swift
//  nomore
//
//  Created by Aa on 2025-11-23.
//

import SwiftUI
import Lottie

struct MainCircleVisual_Foundation: View {
    var body: some View {
        LottieView(animation: .named("MainCircle"))
            .playing(loopMode: .loop)
            .animationSpeed(0.6)
            .frame(width: 317, height: 317)
            .blur(radius: 2)
            .saturation(1.3)
            .colorMultiply(.blue) // Blue - solid foundation and stability
    }
}

#Preview {
    MainCircleVisual_Foundation()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
}

