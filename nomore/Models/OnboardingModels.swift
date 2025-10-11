//
//  OnboardingModels.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

// MARK: - Onboarding Screen Type Enum
enum OnboardingScreenType: Equatable {
    case question(Int)
    case goals
    case commitment
    case reviews
    case completion
}

// MARK: - Onboarding Flow Definition
struct OnboardingFlow {
    static func screenSequence(questionCount: Int) -> [OnboardingScreenType] {
        var screens: [OnboardingScreenType] = []
        for i in 0..<questionCount {
            screens.append(.question(i))
        }
        screens.append(.goals)
        screens.append(.commitment)
        screens.append(.reviews)
        screens.append(.completion)
        return screens
    }
}

// MARK: - Onboarding Question Model
struct OnboardingQuestion {
    let id: Int
    let title: String
    let question: String
    let options: [OnboardingOption]
    let isMultiSelect: Bool
    
    init(id: Int, title: String, question: String, options: [OnboardingOption], isMultiSelect: Bool = false) {
        self.id = id
        self.title = title
        self.question = question
        self.options = options
        self.isMultiSelect = isMultiSelect
    }
}

// MARK: - Onboarding Option Model
struct OnboardingOption {
    let id: Int
    let text: String
    let value: String
    let impactLevel: ImpactLevel
    
    enum ImpactLevel {
        case low, medium, high, critical
        
        var color: Color {
            switch self {
            case .low: return Theme.mint
            case .medium: return Theme.aqua
            case .high: return Theme.accent
            case .critical: return Color.red.opacity(0.8)
            }
        }
    }
}

// MARK: - User Response Model
struct OnboardingResponse: Codable {
    let questionId: Int
    let selectedOptions: [Int]
    let timestamp: Date
    
    init(questionId: Int, selectedOptions: [Int]) {
        self.questionId = questionId
        self.selectedOptions = selectedOptions
        self.timestamp = Date()
    }
}

// MARK: - Onboarding Profile Model
struct OnboardingProfile: Codable {
    var responses: [OnboardingResponse] = []
    var selectedGoalIds: [String] = []
    var isCompleted: Bool = false
    var personalizedMessage: String = ""
    
    mutating func addResponse(_ response: OnboardingResponse) {
        // Remove existing response for this question if any
        responses.removeAll { $0.questionId == response.questionId }
        responses.append(response)
    }
}
