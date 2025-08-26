//
//  OnboardingModels.swift
//  nomore
//
//  Created by Aa on 2025-07-14.
//

import SwiftUI

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
struct OnboardingResponse {
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
struct OnboardingProfile {
    var responses: [OnboardingResponse] = []
    var isCompleted: Bool = false
    var riskScore: Int = 0
    var personalizedMessage: String = ""
    
    mutating func addResponse(_ response: OnboardingResponse) {
        // Remove existing response for this question if any
        responses.removeAll { $0.questionId == response.questionId }
        responses.append(response)
        calculateRiskScore()
    }
    
    private mutating func calculateRiskScore() {
        // Calculate risk score based on responses
        // Higher scores indicate more severe addiction patterns
        riskScore = responses.reduce(0) { total, response in
            let questionWeight = getQuestionWeight(response.questionId)
            let optionWeight = response.selectedOptions.reduce(0) { $0 + getOptionWeight(response.questionId, $1) }
            return total + (questionWeight * optionWeight)
        }
    }
    
    private func getQuestionWeight(_ questionId: Int) -> Int {
        // Weight questions based on their importance for addiction assessment
        switch questionId {
        case 1, 2, 3: return 3 // Frequency and compulsive behavior
        case 4, 5, 6: return 4 // Impact on life and relationships
        case 7, 8, 9: return 2 // Emotional triggers
        case 10, 11, 12: return 2 // Recovery motivation and support
        default: return 1
        }
    }
    
    private func getOptionWeight(_ questionId: Int, _ optionId: Int) -> Int {
        // Higher weights for more concerning responses
        // This would be customized based on the specific question and option
        return optionId // Simplified for now
    }
}
