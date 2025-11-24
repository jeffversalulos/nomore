//
//  OnboardingCompletionView.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

struct OnboardingCompletionView: View {
    let profile: OnboardingProfile
    let onContinue: () -> Void
    
    @State private var showContent = false
    @State private var pulseAnimation = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 60)
            
            // Success animation
            ZStack {
                // Pulsing background circle
                ZStack {
                    Circle()
                        .fill(Theme.mint.opacity(0.2))
                        .frame(width: pulseAnimation ? 200 : 160, height: pulseAnimation ? 200 : 160)
                        .animation(
                            .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: pulseAnimation
                        )
                    
                    // Inner circle
                    Circle()
                        .fill(Theme.mint.opacity(0.3))
                        .frame(width: 120, height: 120)
                    
                    // Checkmark
                    Image(systemName: "checkmark")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(showContent ? 1.0 : 0.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showContent)
                }
                .frame(width: 200, height: 200) // Fixed container size
            }
            .padding(.bottom, 40)
            
            // Content
            VStack(spacing: 24) {
                // Title
                Text("Your Journey Starts Now")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1.0 : 0.0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.6), value: showContent)
                
                // Personalized message
                Text(profile.personalizedMessage)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, 32)
                    .opacity(showContent ? 1.0 : 0.0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.9), value: showContent)
                
                // Features preview
                VStack(spacing: 16) {
                    FeatureHighlight(
                        icon: "timer",
                        title: "Track Your Progress",
                        description: "Real-time streak counter and milestone celebrations"
                    )
                    
                    FeatureHighlight(
                        icon: "brain.head.profile",
                        title: "Mindfulness Tools",
                        description: "Guided meditations and breathing exercises for urge management"
                    )
                    
                    FeatureHighlight(
                        icon: "square.and.pencil",
                        title: "Personal Journal",
                        description: "Private space to process emotions and track triggers"
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .opacity(showContent ? 1.0 : 0.0)
                .offset(y: showContent ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(1.2), value: showContent)
            }
            
            Spacer()
            
            // Continue button
            Button(action: onContinue) {
                HStack {
                    Text("Begin Your Recovery")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Theme.mint, Theme.aqua],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .opacity(showContent ? 1.0 : 0.0)
            .offset(y: showContent ? 0 : 30)
            .animation(.easeOut(duration: 0.6).delay(1.5), value: showContent)
        }
        .onAppear {
            showContent = true
            pulseAnimation = true
        }
    }
}

struct FeatureHighlight: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Theme.surface)
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Theme.aqua)
            }
            
            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Theme.surfaceStroke, lineWidth: 1)
                )
        )
    }
}

#Preview {
    let profile = OnboardingProfile()
    return OnboardingCompletionView(profile: profile) {
        print("Continue tapped")
    }
}
