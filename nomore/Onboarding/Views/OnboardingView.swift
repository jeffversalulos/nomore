//
//  OnboardingView.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var manager: OnboardingManager
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
                    insertion: .scale(scale: 0.8).combined(with: .opacity),
                    removal: .scale(scale: 1.1).combined(with: .opacity)
                ))
            } else if showingCommitment {
                SignCommitmentView {
                    manager.completeCommitment()
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            } else {
                OnboardingQuestionView(
                    question: manager.questions[manager.currentQuestionIndex],
                    manager: manager
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            }
        }
        .appBackground()
        .animation(.easeInOut(duration: 0.4), value: manager.currentQuestionIndex)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showingCommitment)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showingCompletion)
        .onChange(of: manager.showingCommitmentView) { showingCommitmentView in
            if showingCommitmentView {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showingCommitment = true
                }
            }
        }
        .onChange(of: manager.showingCompletionView) { showingCompletionView in
            if showingCompletionView {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
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
