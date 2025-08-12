import SwiftUI

enum Theme {
    // Brand colors
    static let purple = Color(#colorLiteral(red: 0.73, green: 0.0, blue: 1.0, alpha: 1.0))
    static let indigo = Color(#colorLiteral(red: 0.18, green: 0.09, blue: 0.54, alpha: 1.0))
    static let accent = Color(#colorLiteral(red: 0.55, green: 0.2, blue: 0.98, alpha: 1.0))

    // Text
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.85)

    // Surfaces
    static let surface = Color.white.opacity(0.10)
    static let surfaceStroke = Color.white.opacity(0.20)

    // Background
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [purple, indigo],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension View {
    /// Apply the app's gradient as a full-screen background behind the view.
    func appBackground() -> some View {
        background(Theme.backgroundGradient.ignoresSafeArea())
    }
}


