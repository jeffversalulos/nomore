//
//  OnboardingView.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var manager: OnboardingManager
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            switch manager.currentScreen {
            case .question(let index):
                OnboardingQuestionView(
                    question: manager.questions[index],
                    manager: manager
                )
                
            case .goals:
                GoalsToTrackView(manager: manager)
                
            case .commitment:
                SignCommitmentView(manager: manager)
                
            case .reviews:
                ReviewsView(manager: manager)
                
            case .completion:
                OnboardingCompletionView(
                    profile: manager.profile,
                    onContinue: onComplete
                )
            }
        }
        .appBackground()
        .transition(transitionFor(manager.isNavigatingBack))
        .animation(.spring(response: 0.5, dampingFraction: 0.9), value: manager.currentIndex)
    }
    
    private func transitionFor(_ isBack: Bool) -> AnyTransition {
        .asymmetric(
            insertion: .move(edge: isBack ? .leading : .trailing).combined(with: .opacity),
            removal: .move(edge: isBack ? .trailing : .leading).combined(with: .opacity)
        )
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
    .environmentObject(OnboardingManager())
}
