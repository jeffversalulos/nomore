//
//  OnboardingManager.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

class OnboardingManager: ObservableObject {
    @Published var currentStep: OnboardingStep = .question(index: 0)
    @Published var previousStep: OnboardingStep? = nil
    @Published var profile = OnboardingProfile()
    @Published var hasCompletedOnboarding = false
    
    private let userDefaults = UserDefaults.standard
    private let onboardingCompletedKey = "hasCompletedOnboarding"
    private let onboardingProfileKey = "onboardingProfile"
    
    init() {
        loadOnboardingStatus()
        loadOnboardingProfile()
    }
    
    // MARK: - Core Questions Data
    let questions: [OnboardingQuestion] = OnboardingQuestionsData.questions
    
    // Computed property for backward compatibility
    var currentQuestionIndex: Int {
        switch currentStep {
        case .question(let index):
            return index
        default:
            return 0
        }
    }
    
    // MARK: - Navigation Methods
    func nextQuestion() {
        switch currentStep {
        case .question(let index):
            if index < questions.count - 1 {
                navigateTo(.question(index: index + 1))
            } else {
                navigateTo(.goals)
            }
        default:
            break
        }
    }
    
    func previousQuestion() {
        switch currentStep {
        case .question(let index):
            if index > 0 {
                navigateTo(.question(index: index - 1))
            }
        default:
            break
        }
    }
    
    private func navigateTo(_ step: OnboardingStep) {
        previousStep = currentStep
        currentStep = step
    }
    
    func goBack() {
        switch currentStep {
        case .goals:
            navigateTo(.question(index: questions.count - 1))
        case .commitment:
            navigateTo(.goals)
        case .completion:
            navigateTo(.commitment)
        case .question(let index):
            if index > 0 {
                navigateTo(.question(index: index - 1))
            }
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
        switch currentStep {
        case .question(let index):
            let currentQuestion = questions[index]
            return profile.responses.contains { $0.questionId == currentQuestion.id && !$0.selectedOptions.isEmpty }
        default:
            return true
        }
    }
    
    // MARK: - Goal Selection Methods
    func toggleGoalSelection(_ goalTitle: String) {
        if profile.selectedGoalIds.contains(goalTitle) {
            profile.selectedGoalIds.removeAll { $0 == goalTitle }
        } else {
            profile.selectedGoalIds.append(goalTitle)
        }
        saveOnboardingProfile()
    }
    
    func isGoalSelected(_ goalTitle: String) -> Bool {
        return profile.selectedGoalIds.contains(goalTitle)
    }
    
    // MARK: - Goals View Navigation
    func completeGoals() {
        navigateTo(.commitment)
    }

    // MARK: - Completion
    func completeCommitment() {
        profile.isCompleted = true
        profile.personalizedMessage = generatePersonalizedMessage()
        navigateTo(.completion)
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
    
    func resetOnboarding(goalsStore: GoalsStore? = nil) {
        hasCompletedOnboarding = false
        currentStep = .question(index: 0)
        previousStep = nil
        profile = OnboardingProfile()
        saveOnboardingStatus()
        saveOnboardingProfile()
        
        // Clear any previously selected goals
        goalsStore?.clearAllSelections()
    }
}
