//
//  OnboardingView.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var manager = OnboardingManager()
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
        .animation(.easeInOut(duration: 0.4), value: manager.currentQuestionIndex)
        .animation(.easeInOut(duration: 0.4), value: showingCompletion)
        .onChange(of: manager.hasCompletedOnboarding) { completed in
            if completed {
                withAnimation(.easeInOut(duration: 0.5)) {
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
