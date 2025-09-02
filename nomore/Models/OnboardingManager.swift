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
    let questions: [OnboardingQuestion] = [
        // Question 1: Frequency Assessment
        OnboardingQuestion(
            id: 1,
            title: "Question #1",
            question: "How often do you typically view pornography?",
            options: [
                OnboardingOption(id: 1, text: "Multiple times per day", value: "multiple_daily", impactLevel: .critical),
                OnboardingOption(id: 2, text: "Once a day", value: "daily", impactLevel: .high),
                OnboardingOption(id: 3, text: "A few times a week", value: "few_weekly", impactLevel: .medium),
                OnboardingOption(id: 4, text: "Once a week or less", value: "weekly_less", impactLevel: .low)
            ]
        ),
        
        // Question 2: Compulsive Behavior
        OnboardingQuestion(
            id: 2,
            title: "Question #2",
            question: "Do you find it difficult to stop viewing pornography once you start?",
            options: [
                OnboardingOption(id: 1, text: "Always - I can't control myself", value: "always_uncontrollable", impactLevel: .critical),
                OnboardingOption(id: 2, text: "Usually - It's very hard to stop", value: "usually_difficult", impactLevel: .high),
                OnboardingOption(id: 3, text: "Sometimes - Depends on my mood", value: "sometimes_difficult", impactLevel: .medium),
                OnboardingOption(id: 4, text: "Rarely - I can usually stop when I want", value: "rarely_difficult", impactLevel: .low)
            ]
        ),
        
        // Question 3: Time Investment
        OnboardingQuestion(
            id: 3,
            title: "Question #3",
            question: "How much time do you typically spend viewing pornography in a single session?",
            options: [
                OnboardingOption(id: 1, text: "More than 2 hours", value: "over_2_hours", impactLevel: .critical),
                OnboardingOption(id: 2, text: "1-2 hours", value: "1_2_hours", impactLevel: .high),
                OnboardingOption(id: 3, text: "30 minutes - 1 hour", value: "30min_1hour", impactLevel: .medium),
                OnboardingOption(id: 4, text: "Less than 30 minutes", value: "under_30min", impactLevel: .low)
            ]
        ),
        
        // Question 4: Life Impact
        OnboardingQuestion(
            id: 4,
            title: "Question #4",
            question: "Has pornography use negatively impacted your work, school, or daily responsibilities?",
            options: [
                OnboardingOption(id: 1, text: "Severely - I've lost jobs/failed classes", value: "severe_impact", impactLevel: .critical),
                OnboardingOption(id: 2, text: "Significantly - Regular performance issues", value: "significant_impact", impactLevel: .high),
                OnboardingOption(id: 3, text: "Somewhat - Occasional problems", value: "moderate_impact", impactLevel: .medium),
                OnboardingOption(id: 4, text: "Minimally - Rare issues", value: "minimal_impact", impactLevel: .low)
            ]
        ),
        
        // Question 5: Relationship Impact
        OnboardingQuestion(
            id: 5,
            title: "Question #5",
            question: "How has pornography affected your relationships or ability to connect intimately?",
            options: [
                OnboardingOption(id: 1, text: "Destroyed relationships/marriage", value: "destroyed_relationships", impactLevel: .critical),
                OnboardingOption(id: 2, text: "Caused serious relationship problems", value: "serious_problems", impactLevel: .high),
                OnboardingOption(id: 3, text: "Created some tension or distance", value: "some_tension", impactLevel: .medium),
                OnboardingOption(id: 4, text: "Little to no impact", value: "no_impact", impactLevel: .low)
            ]
        ),
        
        // Question 6: Self-Worth Impact
        OnboardingQuestion(
            id: 6,
            title: "Question #6",
            question: "How do you feel about yourself after viewing pornography?",
            options: [
                OnboardingOption(id: 1, text: "Deeply ashamed and disgusted", value: "deeply_ashamed", impactLevel: .critical),
                OnboardingOption(id: 2, text: "Guilty and disappointed in myself", value: "guilty_disappointed", impactLevel: .high),
                OnboardingOption(id: 3, text: "Somewhat regretful", value: "somewhat_regretful", impactLevel: .medium),
                OnboardingOption(id: 4, text: "Neutral or indifferent", value: "neutral", impactLevel: .low)
            ]
        ),
        
        // Question 7: Stress Trigger
        OnboardingQuestion(
            id: 7,
            title: "Question #7",
            question: "Do you turn to pornography when feeling stressed, anxious, or depressed?",
            options: [
                OnboardingOption(id: 1, text: "Always - It's my main coping mechanism", value: "always_coping", impactLevel: .critical),
                OnboardingOption(id: 2, text: "Frequently - It's a common escape", value: "frequently_escape", impactLevel: .high),
                OnboardingOption(id: 3, text: "Occasionally - Sometimes when overwhelmed", value: "occasionally", impactLevel: .medium),
                OnboardingOption(id: 4, text: "Rarely or never", value: "rarely_never", impactLevel: .low)
            ]
        ),
        
        // Question 8: Boredom Trigger
        OnboardingQuestion(
            id: 8,
            title: "Question #8",
            question: "Do you watch pornography out of boredom or habit?",
            options: [
                OnboardingOption(id: 1, text: "Constantly - It's become automatic", value: "constantly_automatic", impactLevel: .high),
                OnboardingOption(id: 2, text: "Frequently - Often when I have free time", value: "frequently_bored", impactLevel: .medium),
                OnboardingOption(id: 3, text: "Sometimes - When I can't find anything else", value: "sometimes_bored", impactLevel: .medium),
                OnboardingOption(id: 4, text: "Rarely - I have other activities I prefer", value: "rarely_bored", impactLevel: .low)
            ]
        ),
        
        // Question 9: Failed Attempts
        OnboardingQuestion(
            id: 9,
            title: "Question #9",
            question: "How many times have you tried to quit or reduce pornography use?",
            options: [
                OnboardingOption(id: 1, text: "Countless times - I've lost count", value: "countless_attempts", impactLevel: .critical),
                OnboardingOption(id: 2, text: "Many times (10+ attempts)", value: "many_attempts", impactLevel: .high),
                OnboardingOption(id: 3, text: "Several times (3-9 attempts)", value: "several_attempts", impactLevel: .medium),
                OnboardingOption(id: 4, text: "This is my first serious attempt", value: "first_attempt", impactLevel: .low)
            ]
        ),
        
        // Question 10: Motivation Level
        OnboardingQuestion(
            id: 10,
            title: "Question #10",
            question: "How motivated are you to completely quit pornography?",
            options: [
                OnboardingOption(id: 1, text: "Extremely - I'll do whatever it takes", value: "extremely_motivated", impactLevel: .low),
                OnboardingOption(id: 2, text: "Very motivated - This is a top priority", value: "very_motivated", impactLevel: .low),
                OnboardingOption(id: 3, text: "Moderately - I want to change", value: "moderately_motivated", impactLevel: .medium),
                OnboardingOption(id: 4, text: "Somewhat - I'm exploring options", value: "somewhat_motivated", impactLevel: .high)
            ]
        ),
        
        // Question 11: Support System
        OnboardingQuestion(
            id: 11,
            title: "Question #11",
            question: "Do you have support from friends, family, or professionals in your recovery?",
            options: [
                OnboardingOption(id: 1, text: "Strong support - Multiple people helping me", value: "strong_support", impactLevel: .low),
                OnboardingOption(id: 2, text: "Some support - A few trusted people know", value: "some_support", impactLevel: .medium),
                OnboardingOption(id: 3, text: "Limited support - One person knows", value: "limited_support", impactLevel: .medium),
                OnboardingOption(id: 4, text: "No support - I'm facing this alone", value: "no_support", impactLevel: .high)
            ]
        ),
        
        // Question 12: Recovery Tools
        OnboardingQuestion(
            id: 12,
            title: "Question #12",
            question: "What tools or strategies have you tried before to overcome this addiction?",
            options: [
                OnboardingOption(id: 1, text: "Professional therapy/counseling", value: "professional_help", impactLevel: .low),
                OnboardingOption(id: 2, text: "Support groups or online communities", value: "support_groups", impactLevel: .low),
                OnboardingOption(id: 3, text: "Self-help books or apps", value: "self_help", impactLevel: .medium),
                OnboardingOption(id: 4, text: "Nothing formal - just willpower", value: "willpower_only", impactLevel: .high)
            ]
        )
    ]
    
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
