//
//  OnboardingQuestionView.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

struct OnboardingQuestionView: View {
    let question: OnboardingQuestion
    @ObservedObject var manager: OnboardingManager
    @State private var selectedOptions: Set<Int> = []
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Progress bar
                HStack {
                    Button(action: {
                        manager.back()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .disabled(manager.currentQuestionIndex == 0)
                    .opacity(manager.currentQuestionIndex == 0 ? 0.3 : 1.0)
                    
                    // Progress bar
                    GeometryReader { progressGeometry in
                        ZStack(alignment: .leading) {
                            // Background
                            Capsule()
                                .fill(Theme.surface)
                                .frame(height: 6)
                            
                            // Progress
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Theme.aqua, Theme.mint],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(
                                    width: progressGeometry.size.width * CGFloat(manager.currentQuestionIndex + 1) / CGFloat(manager.questions.count),
                                    height: 6
                                )
                                .animation(.easeInOut(duration: 0.3), value: manager.currentQuestionIndex)
                        }
                    }
                    .frame(height: 6)
                    
                    // Language selector (placeholder)
                    /*
                    HStack {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.white)
                        Text("EN")
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                    )
                    */
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                Spacer(minLength: 40)
                
                // Question content
                VStack(spacing: 40) {
                    // Question title
                    Text(question.title)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Question text
                    Text(question.question)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 32)
                    
                    Spacer(minLength: 20)
                    
                    // Options
                    VStack(spacing: 16) {
                        ForEach(Array(question.options.enumerated()), id: \.element.id) { index, option in
                            OnboardingOptionButton(
                                option: option,
                                isSelected: manager.isOptionSelected(questionId: question.id, optionId: option.id),
                                optionNumber: index + 1
                            ) {
                                manager.selectOption(
                                    questionId: question.id,
                                    optionId: option.id,
                                    isMultiSelect: question.isMultiSelect
                                )
                                
                                // Auto-advance for single select questions after a brief delay
                                if !question.isMultiSelect {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        if manager.canProceed() {
                                            manager.next()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                    
                    // Skip option (only show for less critical questions)
                    /*
                    if question.id > 13 {
                        Button("Skip question") {
                            manager.nextQuestion()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.bottom, 20)
                    }
                    */
                }
            }
        }
        .onAppear {
            updateSelectedOptions()
        }
    }
    
    private func updateSelectedOptions() {
        if let response = manager.profile.responses.first(where: { $0.questionId == question.id }) {
            selectedOptions = Set(response.selectedOptions)
        }
    }
}

struct OnboardingOptionButton: View {
    let option: OnboardingOption
    let isSelected: Bool
    let optionNumber: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Option number circle
                ZStack {
                    Circle()
                        .fill(isSelected ? Theme.mint : Theme.aqua)
                        .frame(width: 44, height: 44)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Text("\(optionNumber)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                
                // Option text
                Text(option.text)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(
                        isSelected 
                            ? Color.white.opacity(0.25)
                            : Color.white.opacity(0.08)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .stroke(
                                isSelected 
                                    ? Theme.mint.opacity(0.8)
                                    : Color.white.opacity(0.15),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let manager = OnboardingManager()
    return OnboardingQuestionView(
        question: manager.questions[0],
        manager: manager
    )
}
