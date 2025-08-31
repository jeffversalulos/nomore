//
//  SecondsCounter.swift
//  nomore
//
//  Created by Aa on 2025-08-21.
//

import SwiftUI

struct SecondsCounter: View {
    let components: TimeComponents
    
    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 8) {
            // Show appropriate content based on time hierarchy
            if components.months > 0 || components.days > 0 {
                // When months or days exist: show hours, minutes and seconds in bubble
                if components.hours > 0 {
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("\(components.hours)")
                            .font(.system(size: 32, weight: .ultraLight, design: .rounded))
                            .foregroundStyle(.white.opacity(0.85))
                            .contentTransition(.numericText())
                        Text("hr")
                            .font(.system(size: 18, weight: .light))
                            .foregroundStyle(.white.opacity(0.65))
                            .offset(y: -4)
                    }
                }
                
                if components.minutes > 0 {
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("\(components.minutes)")
                            .font(.system(size: 32, weight: .ultraLight, design: .rounded))
                            .foregroundStyle(.white.opacity(0.85))
                            .contentTransition(.numericText())
                        Text("m")
                            .font(.system(size: 18, weight: .light))
                            .foregroundStyle(.white.opacity(0.65))
                            .offset(y: -4)
                    }
                }
                
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(components.seconds)")
                        .font(.system(size: 32, weight: .ultraLight, design: .rounded))
                        .foregroundStyle(.white.opacity(0.85))
                        .contentTransition(.numericText())
                    Text("s")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(.white.opacity(0.65))
                        .offset(y: -4)
                }
            } else if components.hours > 0 {
                // When hours exist but no days/months: show minutes and seconds in bubble
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(components.minutes)")
                        .font(.system(size: 32, weight: .ultraLight, design: .rounded))
                        .foregroundStyle(.white.opacity(0.85))
                        .contentTransition(.numericText())
                    Text("m")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(.white.opacity(0.65))
                        .offset(y: -4)
                }
                
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(components.seconds)")
                        .font(.system(size: 32, weight: .ultraLight, design: .rounded))
                        .foregroundStyle(.white.opacity(0.85))
                        .contentTransition(.numericText())
                    Text("s")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(.white.opacity(0.65))
                        .offset(y: -4)
                }
            } else if components.minutes > 0 {
                // When minutes exist but no hours: show only seconds in bubble
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(components.seconds)")
                        .font(.system(size: 32, weight: .ultraLight, design: .rounded))
                        .foregroundStyle(.white.opacity(0.85))
                        .contentTransition(.numericText())
                    Text("s")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(.white.opacity(0.65))
                        .offset(y: -4)
                }
            } else {
                // When only seconds exist: show seconds in bubble
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text("\(components.seconds)")
                        .font(.system(size: 32, weight: .ultraLight, design: .rounded))
                        .foregroundStyle(.white.opacity(0.85))
                        .contentTransition(.numericText())
                    Text("s")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(.white.opacity(0.65))
                        .offset(y: -4)
                }
            }
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
    let sampleComponents = TimeComponents(months: 0, days: 0, hours: 4, minutes: 28, seconds: 35)
    return SecondsCounter(components: sampleComponents)
        .padding()
        .background(Color.black)
}
