//
//  StreakCounter.swift
//  nomore
//
//  Created by Aa on 2025-08-21.
//

import SwiftUI

struct StreakCounter: View {
    let components: TimeComponents
    
    var body: some View {
        VStack(spacing: 24) {
            Text("You've been porn-free for:")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.white.opacity(0.75))
                .tracking(0.3)
            
            // Main counter display - ultra clean and minimal
            MainTimeCounter(components: components)
            
            // Dedicated bubble counter - shows appropriate units based on time
            SmallerUnitsCounter(components: components)
                .padding(.top, -20)
        }
    }
}

#Preview {
    let sampleComponents = TimeComponents(months: 0, days: 0, hours: 4, minutes: 28, seconds: 35)
    return StreakCounter(components: sampleComponents)
        .padding()
        .background(Color.black)
}
