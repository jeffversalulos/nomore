//
//  BreathPhase.swift
//  nomore
//
//  Created by Aa on 2025-08-24.
//

import Foundation

enum BreathPhase: String, CaseIterable {
    case inhale
    case hold
    case exhale
    case rest

    var displayName: String {
        switch self {
        case .inhale: return "Inhale"
        case .hold: return "Hold"
        case .exhale: return "Exhale"
        case .rest: return "Rest"
        }
    }

    var instruction: String {
        switch self {
        case .inhale: return "Inhale gently through your nose"
        case .hold: return "Hold your breath softly"
        case .exhale: return "Exhale slowly through your mouth"
        case .rest: return "Rest and prepare for the next breath"
        }
    }
}
