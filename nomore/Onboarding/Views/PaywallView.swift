//
//  PaywallView.swift
//  nomore
//
//  Created by Aa on 2025-11-04.
//

import SwiftUI

struct PaywallView: View {
    @State private var selectedPlan: PricingPlan = .monthly
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
                HStack(spacing: 16) {
                    FeatureCard(
                        emoji: "📅",
                        title: "DAYS",
                        subtitle: "365",
                        description: "Track time\nsober"
                    )
                    
                    FeatureCard(
                        emoji: "🐝",
                        title: "",
                        subtitle: "",
                        description: "Meet your\nsponsor"
                    )
                    
                    FeatureCard(
                        emoji: "🌻",
                        title: "",
                        subtitle: "",
                        description: "Find sober\nfriends"
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
                
                // Pricing Options
                VStack(spacing: 14) {
                    // Weekly Plan
                    PricingBubble(
                        plan: .weekly,
                        isSelected: selectedPlan == .weekly
                    ) {
                        selectedPlan = .weekly
                    }
                    
                    // Monthly Plan
                    PricingBubble(
                        plan: .monthly,
                        isSelected: selectedPlan == .monthly
                    ) {
                        selectedPlan = .monthly
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
                
                // CTA Button
                Button(action: {
                    // Hardcoded - no actual purchase logic
                    onContinue()
                }) {
                    Text("Start Your Journey")
                        .font(.system(size: 18, weight: .semibold))
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
                .font(.system(size: 44))
            
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
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
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
        case .weekly: return "$4.99"
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
        case .weekly: return "Billed weekly at $4.99"
        case .monthly: return "Billed monthly at $12.99"
        }
    }
    
    var savings: String? {
        switch self {
        case .weekly: return nil
        case .monthly: return "35% Off"
        }
    }
}

// MARK: - Pricing Bubble Component
struct PricingBubble: View {
    let plan: PricingPlan
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    // Plan name
                    Text(plan == .weekly ? "Weekly" : "Monthly")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                    
                    // Price per period
                    Text("\(plan.price)/\(plan.period)")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                }
                
                Spacer()
                
                // Savings badge (if applicable)
                if let savings = plan.savings {
                    Text(savings)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.35, green: 0.25, blue: 0.85),
                                            Color(red: 0.45, green: 0.15, blue: 0.95)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 22)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
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
                RoundedRectangle(cornerRadius: 20)
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
                        lineWidth: isSelected ? 3 : 1.5
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
    }
}

// MARK: - Preview
#Preview {
    PaywallView {
        print("Continue tapped")
    }
}

