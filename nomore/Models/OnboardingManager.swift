//
//  OnboardingManager.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

class OnboardingManager: ObservableObject {
    @Published var currentIndex: Int = 0
    @Published var previousIndex: Int = 0
    @Published var profile = OnboardingProfile()
    @Published var hasCompletedOnboarding = false
    
    private let userDefaults = UserDefaults.standard
    private let onboardingCompletedKey = "hasCompletedOnboarding"
    private let onboardingProfileKey = "onboardingProfile"
    
    // MARK: - Core Questions Data
    let questions: [OnboardingQuestion] = OnboardingQuestionsData.questions
    private lazy var screenSequence = OnboardingFlow.screenSequence(questionCount: questions.count)
    
    var currentScreen: OnboardingScreenType {
        screenSequence[currentIndex]
    }
    
    var isNavigatingBack: Bool {
        previousIndex > currentIndex
    }
    
    // Computed property for question index when on question screen
    var currentQuestionIndex: Int {
        if case .question(let index) = currentScreen {
            return index
        }
        return 0
    }
    
    init() {
        loadOnboardingStatus()
        loadOnboardingProfile()
    }
    
    // MARK: - Navigation Methods
    func next() {
        guard currentIndex < screenSequence.count - 1 else { return }
        previousIndex = currentIndex
        currentIndex += 1
        
        // Auto-save profile on each navigation
        saveOnboardingProfile()
        
        // Generate personalized message when reaching completion
        if case .completion = currentScreen {
            profile.isCompleted = true
            profile.personalizedMessage = generatePersonalizedMessage()
        }
    }
    
    func back() {
        guard currentIndex > 0 else { return }
        previousIndex = currentIndex
        currentIndex -= 1
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
        if case .question(let index) = currentScreen {
            let currentQuestion = questions[index]
            return profile.responses.contains { $0.questionId == currentQuestion.id && !$0.selectedOptions.isEmpty }
        }
        return true
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
    // No longer needed - handled by next() method

    // MARK: - Completion
    // No longer needed - handled by next() method
    
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
        currentIndex = 0
        previousIndex = 0
        profile = OnboardingProfile()
        saveOnboardingStatus()
        saveOnboardingProfile()
        
        // Clear any previously selected goals
        goalsStore?.clearAllSelections()
    }
}
