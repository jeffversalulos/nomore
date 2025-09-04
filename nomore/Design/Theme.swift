import SwiftUI

enum Theme {
    // Brand colors
    static let purple = Color(#colorLiteral(red: 0.1353843808, green: 0.01142665092, blue: 0.4896459579, alpha: 1))
    static let indigo = Color(#colorLiteral(red: 0.18, green: 0.09, blue: 0.54, alpha: 1.0))
    static let accent = Color(#colorLiteral(red: 0.55, green: 0.2, blue: 0.98, alpha: 1.0))
    static let aqua = Color(#colorLiteral(red: 0.0, green: 0.86, blue: 0.98, alpha: 1.0))
    static let mint = Color(#colorLiteral(red: 0.0, green: 0.98, blue: 0.65, alpha: 1.0))

    // Text
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.85)

    // Surfaces
    static let surface = Color.black.opacity(0.15)
    static let surfaceTwo = Color.black.opacity(0.75)
    static let surfaceStroke = Color.black.opacity(0.25)

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
    ///
    ///
    func appBackground() -> some View {
        background(
            ZStack {
                Image("BG2")
                            .resizable()
                            .scaledToFit()
                            .scaledToFill()
                            .ignoresSafeArea() // makes sure it goes edge-to-edge
            }
            .ignoresSafeArea()
        )
    }
    
    func appBackgroundT() -> some View {
        background(
            ZStack {
                Image("BG")
                            .resizable()
                            .scaledToFit()
                            .scaledToFill()
                            .ignoresSafeArea() // makes sure it goes edge-to-edge
            }
            .ignoresSafeArea()
        )
    }
    
    func appBackgroundTwo() -> some View {
        background(
            ZStack {
                Theme.backgroundGradient
                // Very subtle vignette for depth (kept minimal for a refined look)
                LinearGradient(
                    colors: [Color.black.opacity(0.12), .clear, Color.black.opacity(0.12)],
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
        shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 6)
    }
}


