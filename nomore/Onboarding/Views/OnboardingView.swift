//
//  OnboardingView.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var manager: OnboardingManager
    @State private var showingGoals = false
    @State private var showingCommitment = false
    @State private var showingCompletion = false
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            if showingCompletion {
                OnboardingCompletionView(
                    profile: manager.profile,
                    onContinue: onComplete
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            } else if showingCommitment {
                SignCommitmentView(
                    manager: manager,
                    onFinish: {
                        manager.completeCommitment()
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: manager.isNavigatingBack ?
                        .move(edge: .trailing).combined(with: .opacity) :
                        .move(edge: .leading).combined(with: .opacity)
                ))
            } else if showingGoals {
                GoalsToTrackView {
                    manager.completeGoals()
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: manager.isNavigatingBack ?
                        .move(edge: .trailing).combined(with: .opacity) :
                        .move(edge: .leading).combined(with: .opacity)
                ))
            } else {
                OnboardingQuestionView(
                    question: manager.questions[manager.currentQuestionIndex],
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
        .animation(.spring(response: 0.5, dampingFraction: 0.9), value: showingGoals)
        .animation(.spring(response: 0.5, dampingFraction: 0.9), value: showingCommitment)
        .animation(.spring(response: 0.5, dampingFraction: 0.9), value: showingCompletion)
        .onChange(of: manager.showingGoalsView) { showingGoalsView in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0)) {
                showingGoals = showingGoalsView
            }
        }
        .onChange(of: manager.showingCommitmentView) { showingCommitmentView in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0)) {
                showingCommitment = showingCommitmentView
            }
        }
        .onChange(of: manager.showingCompletionView) { showingCompletionView in
            if showingCompletionView {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0)) {
                    showingCompletion = true
                }
            }
        }
    }
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
