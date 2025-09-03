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
    @Published var showingGoalsView = false
    @Published var showingCommitmentView = false
    @Published var showingCompletionView = false
    @Published var isNavigatingBack = false
    
    private let userDefaults = UserDefaults.standard
    private let onboardingCompletedKey = "hasCompletedOnboarding"
    private let onboardingProfileKey = "onboardingProfile"
    
    init() {
        loadOnboardingStatus()
        loadOnboardingProfile()
    }
    
    // MARK: - Core Questions Data
    let questions: [OnboardingQuestion] = OnboardingQuestionsData.questions
    
    // MARK: - Navigation Methods
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showGoalsView()
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
        
        saveOnboardingProfile()
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
    
    // MARK: - Goals View Navigation
    private func showGoalsView() {
        showingGoalsView = true
    }

    func goBackFromGoals() {
        isNavigatingBack = true
        showingGoalsView = false
        // Go back to the last question (which should be the last question since we just finished them all)
        currentQuestionIndex = questions.count - 1

        // Reset the flag after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isNavigatingBack = false
        }
    }

    func completeGoals() {
        showingGoalsView = false
        showCommitmentView()
    }

    // MARK: - Completion
    private func showCommitmentView() {
        showingCommitmentView = true
    }
    
    func goBackFromCommitment() {
        isNavigatingBack = true
        showingCommitmentView = false
        // Go back to the goals view
        showingGoalsView = true

        // Reset the flag after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isNavigatingBack = false
        }
    }
    
    func completeCommitment() {
        showingCommitmentView = false
        showCompletionView()
    }
    
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
        return "Taking this step shows incredible strength. You've been fighting this battle for too long alone. This app will be your companion in reclaiming your life, relationships, and self-worth."
    }
    
    // MARK: - Persistence
    private func loadOnboardingStatus() {
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingCompletedKey)
    }
    
    private func saveOnboardingStatus() {
        userDefaults.set(hasCompletedOnboarding, forKey: onboardingCompletedKey)
    }
    
    private func loadOnboardingProfile() {
        guard let data = userDefaults.data(forKey: onboardingProfileKey) else { return }
        profile = (try? JSONDecoder().decode(OnboardingProfile.self, from: data)) ?? OnboardingProfile()
    }
    
    private func saveOnboardingProfile() {
        guard let data = try? JSONEncoder().encode(profile) else { return }
        userDefaults.set(data, forKey: onboardingProfileKey)
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        showingGoalsView = false
        showingCommitmentView = false
        showingCompletionView = false
        profile = OnboardingProfile()
        currentQuestionIndex = 0
        saveOnboardingStatus()
        saveOnboardingProfile()
    }
}
