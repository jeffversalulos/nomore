//
//  PaywallView.swift
//  nomore
//
//  Created by Aa on 2025-11-04.
//

import SwiftUI

struct PaywallView: View {
    @State private var selectedPlan: PricingPlan = .weekly
    let onContinue: () -> Void
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                
                // Headline
                VStack(spacing: 4) {
                    Text("Finally quit for good,")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("with NoMore")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, 36)
                
                // Features
                HStack(spacing: 12) {
                    FeatureCard(
                        emoji: "📊",
                        title: "DAYS",
                        subtitle: "365",
                        description: "Track your\nrecovery"
                    )
                    
                    FeatureCard(
                        emoji: "🧠",
                        title: "",
                        subtitle: "",
                        description: "Rewire your\nbrain"
                    )
                    
                    FeatureCard(
                        emoji: "🎯",
                        title: "",
                        subtitle: "",
                        description: "Achieve\nyour goals"
                    )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 36)
                Spacer()
                
                // Pricing Options
                HStack(spacing: 14) {
                    // Monthly Plan
                    PricingBubble(
                        plan: .monthly,
                        isSelected: selectedPlan == .monthly
                    ) {
                        selectedPlan = .monthly
                    }
                    
                    // Weekly Plan (Yearly)
                    PricingBubble(
                        plan: .weekly,
                        isSelected: selectedPlan == .weekly
                    ) {
                        selectedPlan = .weekly
                    }
                }
                .frame(height: 160)
                .padding(.horizontal, 18)
                .padding(.bottom, 28)
                
                // CTA Button
                Button(action: {
                    // Hardcoded - no actual purchase logic
                    onContinue()
                }) {
                    Text("Start Your Journey")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.4, green: 0.3, blue: 0.9),
                                    Color(red: 0.5, green: 0.2, blue: 0.95)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(28)
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            
            // Footer Section - Pinned to bottom
            VStack(spacing: 16) {
                Spacer()
                
                // Subtext
                Text("Change or cancel anytime")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                
                // Footer Links
                HStack(spacing: 32) {
                    Button("Restore Purchases") {
                        // Hardcoded - no actual logic
                    }
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                    
                    Button("Terms") {
                        // Hardcoded - no actual logic
                    }
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                    
                    Button("Privacy") {
                        // Hardcoded - no actual logic
                    }
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                }
                .padding(.bottom, 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .appBackground()
    }
}

// MARK: - Feature Card Component
struct FeatureCard: View {
    let emoji: String
    let title: String
    let subtitle: String
    let description: String
    
    var body: some View {
        VStack(spacing: 10) {
            // Icon/Emoji
            Text(emoji)
                .font(.system(size: 52))
            
            // Title and Subtitle (for calendar card)
            if !title.isEmpty {
                VStack(spacing: 2) {
                    Text(title)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    Text(subtitle)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // Description
            Text(description)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .padding(.horizontal, 8)
    }
}

// MARK: - Pricing Plan Model
enum PricingPlan {
    case weekly
    case monthly
    
    var price: String {
        switch self {
        case .weekly: return "$3.33"
        case .monthly: return "$12.99"
        }
    }
    
    var period: String {
        switch self {
        case .weekly: return "week"
        case .monthly: return "month"
        }
    }
    
    var billingDetails: String {
        switch self {
        case .weekly: return "Billed yearly at $39.99"
        case .monthly: return "Billed monthly at $12.99"
        }
    }
    
    var savings: String? {
        switch self {
        case .weekly: return "SAVE 35%"
        case .monthly: return nil
        }
    }
}

// MARK: - Pricing Bubble Component
struct PricingBubble: View {
    let plan: PricingPlan
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            Button(action: onTap) {
                // Main content with horizontal layout
                HStack(alignment: .center, spacing: 0) {
                    // Left side: Plan info (LEFT-aligned)
                    VStack(alignment: .leading, spacing: 4) {
                        // Plan name
                        Text(plan == .weekly ? "Yearly" : "Monthly")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                        
                        // Price per period
                        Text("\(plan.price) /mo")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Right side: Selection indicator
                    ZStack {
                        Circle()
                            .strokeBorder(Color.white.opacity(0.5), lineWidth: 2)
                            .frame(width: 32, height: 32)
                        
                        if isSelected {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 32, height: 32)
                            
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 28)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            isSelected ?
                            LinearGradient(
                                colors: [
                                    Color(red: 0.45, green: 0.35, blue: 0.88).opacity(0.4),
                                    Color(red: 0.55, green: 0.25, blue: 0.95).opacity(0.4)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.08),
                                    Color.white.opacity(0.08)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            isSelected ?
                            LinearGradient(
                                colors: [
                                    Color(red: 0.5, green: 0.3, blue: 0.95),
                                    Color(red: 0.6, green: 0.4, blue: 1.0)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.25),
                                    Color.white.opacity(0.25)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isSelected ? 2.5 : 1.5
                        )
                )
                .shadow(
                    color: isSelected ? Color(red: 0.5, green: 0.3, blue: 0.95).opacity(0.4) : Color.clear,
                    radius: isSelected ? 12 : 0,
                    x: 0,
                    y: isSelected ? 4 : 0
                )
            }
            .buttonStyle(PlainButtonStyle())
            .animation(.easeInOut(duration: 0.2), value: isSelected)
            
            // Savings badge at the top (OUTSIDE button, in front of everything)
            if let savings = plan.savings {
                Text(savings)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 9)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.5, green: 0.3, blue: 0.95),
                                        Color(red: 0.6, green: 0.4, blue: 1.0)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .offset(y: -13)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    PaywallView {
        print("Continue tapped")
    }
}

