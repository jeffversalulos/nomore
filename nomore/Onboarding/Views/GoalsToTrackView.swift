//
//  GoalsToTrackView.swift
//  nomore
//
//  Created by Aa on 2025-08-27.
//

import SwiftUI

struct OnboardingGoal: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let icon: String
    let gradient: [Color]
    var isSelected: Bool = false
}

struct GoalsToTrackView: View {
    @ObservedObject var manager: OnboardingManager
    let onContinue: (() -> Void)?

    private let goalTitles: [String] = [
        "Stronger relationships",
        "Improved self-confidence", 
        "Improved mood and happiness",
        "More energy and motivation",
        "Improved desire and sex life",
        "Improved self-control",
        "Improved focus and clarity"
    ]
    
    private let goalIcons: [String] = [
        "heart.fill",
        "person.fill",
        "face.smiling.fill", 
        "bolt.fill",
        "doc.text.fill",
        "brain.head.profile",
        "target"
    ]
    
    private let goalGradients: [[Color]] = [
        [Color(red: 0.8, green: 0.2, blue: 0.4), Color(red: 0.6, green: 0.15, blue: 0.3)],
        [Color(red: 0.2, green: 0.6, blue: 0.9), Color(red: 0.15, green: 0.4, blue: 0.7)],
        [Color(red: 0.95, green: 0.7, blue: 0.2), Color(red: 0.8, green: 0.5, blue: 0.1)],
        [Color(red: 0.9, green: 0.5, blue: 0.2), Color(red: 0.7, green: 0.3, blue: 0.1)],
        [Color(red: 0.8, green: 0.3, blue: 0.3), Color(red: 0.6, green: 0.2, blue: 0.2)],
        [Color(red: 0.4, green: 0.7, blue: 0.9), Color(red: 0.3, green: 0.5, blue: 0.7)],
        [Color(red: 0.6, green: 0.3, blue: 0.9), Color(red: 0.4, green: 0.2, blue: 0.7)]
    ]
    

    @EnvironmentObject var goalsStore: GoalsStore

    init(manager: OnboardingManager, onContinue: (() -> Void)? = nil) {
        self._manager = ObservedObject(wrappedValue: manager)
        self.onContinue = onContinue
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    HStack {
                        Button(action: {
                            manager.goBackFromGoals()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Theme.textPrimary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    Text("Choose your goals")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                        .padding(.top, 20)

                    Text("Select the goals you wish to track during\nyour reboot.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }

                // Goals List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(goalTitles.indices, id: \.self) { index in
                            GoalCardSimple(
                                title: goalTitles[index],
                                icon: goalIcons[index],
                                gradient: goalGradients[index],
                                isSelected: manager.isGoalSelected(goalTitles[index]),
                                onTap: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        manager.toggleGoalSelection(goalTitles[index])
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                }
                .padding(.bottom, 90) // Account for button height + padding
            }

            // Bottom Button
            VStack {
                Spacer()

                Button(action: {
                    // Transfer selected goals to the store at the end of onboarding
                    transferGoalsToStore()

                    // Call the continue callback if provided
                    if let onContinue = onContinue {
                        onContinue()
                    }
                }) {
                    HStack {
                        Text("Track these goals")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                    )
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)
            }
        }
        .appBackground()
    }
    
    private func transferGoalsToStore() {
        // Clear existing selections in the store
        goalsStore.clearAllSelections()
        
        // Transfer selected onboarding goals to the store
        goalsStore.setGoals(manager.profile.selectedGoalIds)
    }
}

struct GoalCardSimple: View {
    let title: String
    let icon: String
    let gradient: [Color]
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                // Title
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Selection indicator
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 28, height: 28)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, isSelected ? 20 : 28)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .opacity(isSelected ? 1.0 : 0.6)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}


#Preview {
    let manager = OnboardingManager()
    return GoalsToTrackView(manager: manager) {
        print("Goals selected and continuing...")
    }
    .environmentObject(GoalsStore())
}
