//
//  RecoveryAnalysisView.swift
//  nomore
//
//  Created by Aa on 2025-01-27.
//

import SwiftUI

struct RecoveryAnalysisView: View {
    @ObservedObject var manager: OnboardingManager
    @State private var progress: Double = 0.0
    @State private var currentMessageIndex = 0
    @State private var showCheckmarks: [Bool] = Array(repeating: false, count: 5)
    
    private let loadingMessages = [
        "Analyzing your recovery profile...",
        "Optimizing your success patterns...",
        "Finalizing your recovery plan..."
    ]
    
    private let recoveryMetrics = [
        "Recovery Timeline",
        "Trigger Management", 
        "Support Network",
        "Progress Tracking",
        "Motivation System"
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer(minLength: 80)
                
                // Main Content
                VStack(spacing: 32) {
                    // Progress Percentage
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 64, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    // Main Message
                    Text("We're building your\nrecovery foundation")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                    
                    // Progress Bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 8)
                            
                            // Progress Fill
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: [Theme.accent, Theme.aqua],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * progress, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: progress)
                        }
                    }
                    .frame(height: 8)
                    .padding(.horizontal, 20)
                    
                    // Loading Message
                    Text(loadingMessages[currentMessageIndex])
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                        .animation(.easeInOut(duration: 0.5), value: currentMessageIndex)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
                
                // Recovery Metrics Card
                VStack(spacing: 20) {
                    Text("Personalized recovery plan for")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                    
                    VStack(spacing: 12) {
                        ForEach(recoveryMetrics.indices, id: \.self) { index in
                            HStack(spacing: 12) {
                                // Checkmark or bullet
                                ZStack {
                                    Circle()
                                        .fill(showCheckmarks[index] ? Theme.mint : Color.white.opacity(0.3))
                                        .frame(width: 20, height: 20)
                                    
                                    if showCheckmarks[index] {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.white)
                                    } else {
                                        Circle()
                                            .fill(Color.white.opacity(0.6))
                                            .frame(width: 6, height: 6)
                                    }
                                }
                                
                                Text(recoveryMetrics[index])
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Theme.textPrimary)
                                
                                Spacer()
                            }
                            .opacity(showCheckmarks[index] ? 1.0 : 0.6)
                            .animation(.easeInOut(duration: 0.3), value: showCheckmarks[index])
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                Spacer(minLength: 40)
            }
        }
        .appBackground()
        .onAppear {
            startLoadingAnimation()
        }
    }
    
    private func startLoadingAnimation() {
        // Animate progress gradually over 10 seconds
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if progress < 1.0 {
                progress += 0.01 // Increment by 1% every 0.1 seconds
            } else {
                timer.invalidate()
            }
        }
        
        // Animate loading messages - each message shows for ~3.3 seconds
        Timer.scheduledTimer(withTimeInterval: 3.3, repeats: true) { timer in
            if currentMessageIndex < loadingMessages.count - 1 {
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentMessageIndex += 1
                }
            } else {
                timer.invalidate()
            }
        }
        
        // Animate checkmarks sequentially over the 10-second duration
        for i in 0..<recoveryMetrics.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 2.0 + 1.0) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    showCheckmarks[i] = true
                }
            }
        }
        
        // Navigate to next screen after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 11.0) {
            manager.next()
        }
    }
}

#Preview {
    RecoveryAnalysisView(manager: OnboardingManager())
}
