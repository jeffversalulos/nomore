import SwiftUI

enum Theme {
    // Brand colors
    static let purple = Color(#colorLiteral(red: 0.73, green: 0.0, blue: 1.0, alpha: 1.0))
    static let indigo = Color(#colorLiteral(red: 0.18, green: 0.09, blue: 0.54, alpha: 1.0))
    static let accent = Color(#colorLiteral(red: 0.55, green: 0.2, blue: 0.98, alpha: 1.0))
    static let aqua = Color(#colorLiteral(red: 0.0, green: 0.86, blue: 0.98, alpha: 1.0))
    static let mint = Color(#colorLiteral(red: 0.0, green: 0.98, blue: 0.65, alpha: 1.0))

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
        background(
            ZStack {
                Theme.backgroundGradient
                // Subtle colored glows
                RadialGradient(colors: [Theme.accent.opacity(0.35), .clear], center: .topLeading, startRadius: 8, endRadius: 420)
                    .blur(radius: 20)
                    .offset(x: -40, y: -60)
                RadialGradient(colors: [Theme.aqua.opacity(0.35), .clear], center: .bottomTrailing, startRadius: 8, endRadius: 520)
                    .blur(radius: 20)
                    .offset(x: 60, y: 80)
                // Gentle vignette for depth
                LinearGradient(
                    colors: [Color.black.opacity(0.35), .clear, .clear, Color.black.opacity(0.35)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                LinearGradient(
                    colors: [Color.black.opacity(0.35), .clear, Color.black.opacity(0.35)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
        )
    }
}

extension View {
    /// Consistent soft shadow used across frosted cards and controls
    func softShadow() -> some View {
        shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 10)
    }
}


