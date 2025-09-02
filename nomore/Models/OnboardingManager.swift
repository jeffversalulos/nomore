//
//  OnboardingManager.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

class OnboardingManager: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var profile = OnboardingProfile()
    @Published var hasCompletedOnboarding = false
    @Published var showingCompletionView = false
    
    private let userDefaults = UserDefaults.standard
    private let onboardingCompletedKey = "hasCompletedOnboarding"
    
    init() {
        loadOnboardingStatus()
    }
    
    // MARK: - Core Questions Data
    let questions: [OnboardingQuestion] = OnboardingQuestionsData.questions
    
    // MARK: - Navigation Methods
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showCompletionView()
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    func selectOption(questionId: Int, optionId: Int, isMultiSelect: Bool = false) {
        let existingResponse = profile.responses.first { $0.questionId == questionId }
        
        if isMultiSelect {
            var selectedOptions = existingResponse?.selectedOptions ?? []
            if selectedOptions.contains(optionId) {
                selectedOptions.removeAll { $0 == optionId }
            } else {
                selectedOptions.append(optionId)
            }
            let response = OnboardingResponse(questionId: questionId, selectedOptions: selectedOptions)
            profile.addResponse(response)
        } else {
            let response = OnboardingResponse(questionId: questionId, selectedOptions: [optionId])
            profile.addResponse(response)
        }
    }
    
    func isOptionSelected(questionId: Int, optionId: Int) -> Bool {
        guard let response = profile.responses.first(where: { $0.questionId == questionId }) else {
            return false
        }
        return response.selectedOptions.contains(optionId)
    }
    
    func canProceed() -> Bool {
        let currentQuestion = questions[currentQuestionIndex]
        return profile.responses.contains { $0.questionId == currentQuestion.id && !$0.selectedOptions.isEmpty }
    }
    
    // MARK: - Completion
    private func showCompletionView() {
        profile.isCompleted = true
        profile.personalizedMessage = generatePersonalizedMessage()
        showingCompletionView = true
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveOnboardingStatus()
    }
    
    private func generatePersonalizedMessage() -> String {
        let riskScore = profile.riskScore
        
        switch riskScore {
        case 0...20:
            return "You're taking the right steps toward a healthier relationship with technology. This app will help you build stronger habits and maintain your progress."
        case 21...40:
            return "You've recognized important patterns in your life. This app provides the tools and support you need to break free and build a better future."
        case 41...60:
            return "Your courage to seek change is admirable. This addiction has impacted your life significantly, but recovery is absolutely possible with the right support and tools."
        default:
            return "Taking this step shows incredible strength. You've been fighting this battle for too long alone. This app will be your companion in reclaiming your life, relationships, and self-worth."
        }
    }
    
    // MARK: - Persistence
    private func loadOnboardingStatus() {
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingCompletedKey)
    }
    
    private func saveOnboardingStatus() {
        userDefaults.set(hasCompletedOnboarding, forKey: onboardingCompletedKey)
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        showingCompletionView = false
        profile = OnboardingProfile()
        currentQuestionIndex = 0
        saveOnboardingStatus()
    }
}
