//
//  SecondsCounter.swift
//  nomore
//
//  Created by Aa on 2025-08-21.
//

import SwiftUI

struct SecondsCounter: View {
    let seconds: Int
    
    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 4) {
            Text("\(seconds)")
                .font(.system(size: 32, weight: .ultraLight, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))
                .contentTransition(.numericText())
            Text("s")
                .font(.system(size: 18, weight: .light))
                .foregroundStyle(.white.opacity(0.65))
                .offset(y: -4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(.white.opacity(0.12), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    SecondsCounter(seconds: 35)
        .padding()
        .background(Color.black)
}
