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

    @State private var goals: [OnboardingGoal] = [
        OnboardingGoal(
            title: "Stronger relationships",
            icon: "heart.fill",
            gradient: [Color(red: 0.8, green: 0.2, blue: 0.4), Color(red: 0.6, green: 0.15, blue: 0.3)]
        ),
        OnboardingGoal(
            title: "Improved self-confidence",
            icon: "person.fill",
            gradient: [Color(red: 0.2, green: 0.6, blue: 0.9), Color(red: 0.15, green: 0.4, blue: 0.7)]
        ),
        OnboardingGoal(
            title: "Improved mood and happiness",
            icon: "face.smiling.fill",
            gradient: [Color(red: 0.95, green: 0.7, blue: 0.2), Color(red: 0.8, green: 0.5, blue: 0.1)]
        ),
        OnboardingGoal(
            title: "More energy and motivation",
            icon: "bolt.fill",
            gradient: [Color(red: 0.9, green: 0.5, blue: 0.2), Color(red: 0.7, green: 0.3, blue: 0.1)]
        ),
        OnboardingGoal(
            title: "Improved desire and sex life",
            icon: "doc.text.fill",
            gradient: [Color(red: 0.8, green: 0.3, blue: 0.3), Color(red: 0.6, green: 0.2, blue: 0.2)]
        ),
        OnboardingGoal(
            title: "Improved self-control",
            icon: "brain.head.profile",
            gradient: [Color(red: 0.4, green: 0.7, blue: 0.9), Color(red: 0.3, green: 0.5, blue: 0.7)]
        ),
        OnboardingGoal(
            title: "Improved focus and clarity",
            icon: "target",
            gradient: [Color(red: 0.6, green: 0.3, blue: 0.9), Color(red: 0.4, green: 0.2, blue: 0.7)],
            isSelected: true
        )
    ]

    @StateObject private var goalsStore = GoalsStore()

    init(manager: OnboardingManager, onContinue: (() -> Void)? = nil) {
        self._manager = ObservedObject(wrappedValue: manager)
        self.onContinue = onContinue
    }
    
    var body: some View {
        ZStack {
            // Background
            Theme.backgroundGradient
                .ignoresSafeArea()

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
                        ForEach(goals.indices, id: \.self) { index in
                            GoalCards(
                                goal: goals[index],
                                onTap: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        goals[index].isSelected.toggle()
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
                    // Save selected goals to the store
                    saveSelectedGoals()

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
    
    private func saveSelectedGoals() {
        // Clear existing selections
        for goal in goalsStore.goals {
            if goal.isSelected {
                goalsStore.toggleGoalSelection(goal)
            }
        }
        
        // Add selected onboarding goals to the store
        for onboardingGoal in goals.filter({ $0.isSelected }) {
            // Try to find matching goal by title, otherwise create a custom goal
            if let existingGoal = goalsStore.goals.first(where: { $0.title.lowercased().contains(onboardingGoal.title.lowercased().split(separator: " ").first ?? "") }) {
                if !existingGoal.isSelected {
                    goalsStore.toggleGoalSelection(existingGoal)
                }
            } else {
                // Create a new custom goal
                goalsStore.addCustomGoal(
                    title: onboardingGoal.title,
                    description: "Selected during onboarding"
                )
            }
        }
    }
}

struct GoalCards: View {
    let goal: OnboardingGoal
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: goal.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                // Title
                Text(goal.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Selection indicator
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 28, height: 28)
                    
                    if goal.isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, goal.isSelected ? 20 : 28)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: goal.gradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .opacity(goal.isSelected ? 1.0 : 0.6)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(goal.isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: goal.isSelected)
    }
}

#Preview {
    let manager = OnboardingManager()
    return GoalsToTrackView(manager: manager) {
        print("Goals selected and continuing...")
    }
}
