//
//  ReviewsView.swift
//  nomore
//
//  Created by Aa on 2025-08-27.
//

import SwiftUI
import StoreKit

struct ReviewsView: View {
    @ObservedObject var manager: OnboardingManager
    
    @State private var showContent = false
    @State private var animateStars = false
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        VStack(spacing: 0) {
            // Header section
            VStack(spacing: 24) {
                // Back button (top left)
                HStack {
                Button(action: {
                    manager.back()
                }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer()
                
                // Main title
                VStack(spacing: 16) {
                    Text("Give us a rating")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1.0 : 0.0)
                        .offset(y: showContent ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.3), value: showContent)
                    
                    // Decorative stars with leaves
                    HStack(spacing: 8) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.7))
                            .rotationEffect(.degrees(-15))
                        
                        ForEach(0..<5, id: \.self) { index in
                            Image(systemName: "star.fill")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                                .scaleEffect(animateStars ? 1.03 : 1.0)
                                .animation(
                                    .easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.15),
                                    value: animateStars
                                )
                        }
                        
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.7))
                            .rotationEffect(.degrees(15))
                    }
                    .opacity(showContent ? 1.0 : 0.0)
                    .offset(y: showContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.6), value: showContent)
                }
                
                Spacer()
            }
            .frame(height: 300)
            
            // Content section
            VStack(spacing: 32) {
                // Subtitle
                VStack(spacing: 16) {
                    Text("This app was designed for people\nlike you.")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                    
                    // User avatars and count
                    HStack(spacing: -8) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Theme.mint, Theme.aqua],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                )
                                .overlay(
                                    Image(systemName: ["person.fill", "heart.fill", "star.fill"][index])
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white)
                                )
                        }
                        
                        Text("+ 1,000,000 people")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.leading, 16)
                    }
                }
                .opacity(showContent ? 1.0 : 0.0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.9), value: showContent)
                
                // Reviews section
                VStack(spacing: 16) {
                    ReviewCard(
                        name: "Michael Stevens",
                        handle: "@michaels",
                        review: "\"QUITTR has been a lifesaver for me. The progress tracking and motivational notifications have kept me on track. I haven't watched porn in 3 months and feel more in control of my life.\"",
                        delay: 1.2
                    )
                    
                    ReviewCard(
                        name: "Tony Coleman",
                        handle: "@tcoleman23",
                        review: "\"I was skeptical at first, but QUITTR's panic button feature has helped me resist temptation when it feels overwhelming. This app actually works.\"",
                        delay: 1.5,
                        isPartial: true
                    )
                }
                .opacity(showContent ? 1.0 : 0.0)
                .offset(y: showContent ? 0 : 30)
                .animation(.easeOut(duration: 0.8).delay(1.2), value: showContent)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Next button
            Button(action: {
                // Show Apple's native review prompt
                requestReview()
                
                // Navigate to next screen after a brief delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    manager.next()
                }
            }) {
                Text("Rate Us!")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.white)
                    )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .opacity(showContent ? 1.0 : 0.0)
            .offset(y: showContent ? 0 : 30)
            .animation(.easeOut(duration: 0.6).delay(1.8), value: showContent)
        }
        .appBackground()
        .onAppear {
            showContent = true
            animateStars = true
        }
    }
}

struct ReviewCard: View {
    let name: String
    let handle: String
    let review: String
    let delay: Double
    var isPartial: Bool = false
    
    @State private var showContent = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with avatar and rating
            HStack(spacing: 12) {
                // Avatar
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.aqua, Theme.mint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(String(name.prefix(1)))
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(handle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Star rating
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                    }
                }
            }
            
            // Review text
            Text(review)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Theme.surfaceStroke, lineWidth: 1)
                )
        )
        .opacity(showContent ? 1.0 : 0.0)
        .offset(y: showContent ? 0 : 20)
        .animation(.easeOut(duration: 0.6).delay(delay), value: showContent)
        .onAppear {
            showContent = true
        }
    }
}

#Preview {
    let manager = OnboardingManager()
    return ReviewsView(manager: manager)
}
