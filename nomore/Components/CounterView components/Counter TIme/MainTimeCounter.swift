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
            // Primary time display (largest unit outside bubble)
            HStack(alignment: .lastTextBaseline, spacing: 6) {
                if components.months > 0 {
                    Text("\(components.months)")
                        .font(.system(size: 90, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                    Text("mo")
                        .font(.system(size: 55, weight: .bold))
                        .foregroundStyle(.white)
                        .offset(y: -12)
                } else if components.days > 0 {
                    Text("\(components.days)")
                        .font(.system(size: 90, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                    Text(components.days == 1 ? "day" : "days")
                        .font(.system(size: 55, weight: .bold))
                        .foregroundStyle(.white)
                        .offset(y: -12)
                } else if components.hours > 0 {
                    Text("\(components.hours)")
                        .font(.system(size: 90, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                    Text("hr")
                        .font(.system(size: 55, weight: .bold))
                        .foregroundStyle(.white)
                        .offset(y: -12)
                } else if components.minutes > 0 {
                    Text("\(components.minutes)")
                        .font(.system(size: 90, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                    Text(components.minutes == 1 ? "minute" : "minutes")
                        .font(.system(size: 55, weight: .bold))
                        .foregroundStyle(.white)
                        .offset(y: -12)
                }
            }
            
            // Secondary time display (smaller unit) - only show if relevant
            if components.months > 0 && components.days > 0 {
                Text("\(components.days) \(components.days == 1 ? "day" : "days")")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
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
