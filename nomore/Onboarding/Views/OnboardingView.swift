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
            switch manager.currentStep {
            case .completion:
                OnboardingCompletionView(
                    profile: manager.profile,
                    onContinue: onComplete
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
            case .commitment:
                SignCommitmentView(
                    manager: manager,
                    onFinish: {
                        manager.completeCommitment()
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: isNavigatingBack ?
                        .move(edge: .trailing).combined(with: .opacity) :
                        .move(edge: .leading).combined(with: .opacity)
                ))
                
            case .goals:
                GoalsToTrackView(manager: manager, onContinue: {
                    manager.completeGoals()
                })
                .transition(.asymmetric(
                    insertion: isNavigatingBack ?
                        .move(edge: .leading).combined(with: .opacity) :
                        .move(edge: .trailing).combined(with: .opacity),
                    removal: isNavigatingBack ?
                        .move(edge: .trailing).combined(with: .opacity) :
                        .move(edge: .leading).combined(with: .opacity)
                ))
                
            case .question(let index):
                OnboardingQuestionView(
                    question: manager.questions[index],
                    manager: manager
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
        }
        .appBackground()
        .animation(.easeInOut(duration: 0.4), value: manager.currentQuestionIndex)
        .animation(.spring(response: 0.5, dampingFraction: 0.9), value: manager.currentStep)
    }
    
    private var isNavigatingBack: Bool {
        guard let previousStep = manager.previousStep else { return false }
        
        switch (previousStep, manager.currentStep) {
        case (.goals, .question), (.commitment, .goals), (.completion, .commitment):
            return true
        default:
            return false
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
    .environmentObject(OnboardingManager())
}
