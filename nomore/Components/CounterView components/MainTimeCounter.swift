//
//  MainTimeCounter.swift
//  nomore
//
//  Created by Aa on 2025-08-21.
//

import SwiftUI

struct MainTimeCounter: View {
    let components: TimeComponents
    
    var body: some View {
        VStack(spacing: 16) {
            // Primary time display (largest unit)
            HStack(alignment: .lastTextBaseline, spacing: 6) {
                if components.months > 0 {
                    Text("\(components.months)")
                        .font(.system(size: 82, weight: .ultraLight, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                    Text("mo")
                        .font(.system(size: 28, weight: .light))
                        .foregroundStyle(.white.opacity(0.65))
                        .offset(y: -12)
                } else if components.days > 0 {
                    Text("\(components.days)")
                        .font(.system(size: 82, weight: .ultraLight, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                    Text("d")
                        .font(.system(size: 28, weight: .light))
                        .foregroundStyle(.white.opacity(0.65))
                        .offset(y: -12)
                } else {
                    Text("\(components.hours)")
                        .font(.system(size: 82, weight: .ultraLight, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                    Text("hr")
                        .font(.system(size: 28, weight: .light))
                        .foregroundStyle(.white.opacity(0.65))
                        .offset(y: -12)
                    
                    Text("\(components.minutes)")
                        .font(.system(size: 82, weight: .ultraLight, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                    Text("m")
                        .font(.system(size: 28, weight: .light))
                        .foregroundStyle(.white.opacity(0.65))
                        .offset(y: -12)
                }
            }
            
            // Secondary time display (smaller unit) - only show if relevant
            if components.months > 0 && components.days > 0 {
                Text("\(components.days)d")
                    .font(.system(size: 18, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
                    .contentTransition(.numericText())
            } else if components.days > 0 && components.hours > 0 {
                Text("\(components.hours)hr")
                    .font(.system(size: 18, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
                    .contentTransition(.numericText())
            }
        }
    }
}

#Preview {
    let sampleComponents = TimeComponents(months: 0, days: 0, hours: 4, minutes: 28, seconds: 35)
    return MainTimeCounter(components: sampleComponents)
        .padding()
        .background(Color.black)
}
