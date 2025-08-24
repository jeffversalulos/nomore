//
//  CounterPill.swift
//  nomore
//
//  Created by Aa on 2025-08-21.
//

import SwiftUI

struct CounterPill: View {
    let value: Int
    let unit: String

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(unit)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(width: 74, height: 74)
        .background(Theme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    CounterPill(value: 5, unit: "Days")
        .padding()
        .background(Color.black)
}
