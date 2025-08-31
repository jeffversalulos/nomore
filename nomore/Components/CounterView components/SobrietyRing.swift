//
//  SobrietyRing.swift
//  nomore
//
//  Created by Aa on 2025-08-16.
//

import SwiftUI

struct SobrietyRing: View {
    let progress: Double // 0...1

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.25), lineWidth: 22)

            Circle()
                .trim(from: 0, to: max(0.001, min(progress, 1)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Theme.aqua, Theme.accent, Theme.aqua]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 22, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 220, height: 220)
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient
        SobrietyRing(progress: 0.3)
    }
}
