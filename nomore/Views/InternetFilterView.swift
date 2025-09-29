import SwiftUI
import FamilyControls

struct InternetFilterView: View {
    @State private var isContentRestrictionsEnabled = false
    @State private var authorizationCenter = AuthorizationCenter.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header with back button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                            Text("Back")
                                .font(.system(size: 17, weight: .regular))
                        }
                        .foregroundColor(Theme.textPrimary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                // Title
                Text("Internet filter")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .padding(.bottom, 40)
                
                Spacer()
                
                // Main content area with starfield background effect
                VStack(spacing: 40) {
                    // Internet Filter icon/title
                    VStack(spacing: 16) {
                        Text("Internet Filter")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Theme.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text("QUITTR protects you by managing content restrictions and disabling private browsing.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .padding(.horizontal, 40)
                    }
                    
                    // Enable Content Restrictions Toggle
                    VStack(spacing: 20) {
                        HStack {
                            Text("Enable Content Restrictions")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Theme.textPrimary)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isContentRestrictionsEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: Theme.mint))
                                .scaleEffect(1.1)
                        }
                        .padding(.horizontal, 40)
                        .onChange(of: isContentRestrictionsEnabled) { newValue in
                            if newValue {
                                requestFamilyControlsAuthorization()
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Bottom button
                VStack(spacing: 16) {
                    Button(action: {
                        // Placeholder - no action for now
                    }) {
                        HStack(spacing: 8) {
                            Text("Block Apps")
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(Theme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Theme.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 28)
                                        .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
                                )
                        )
                    }
                    .disabled(true) // Disabled for now as requested
                    .opacity(0.6)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            
            // Starfield background effect
            StarfieldView()
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
        .appBackground()
        .navigationBarHidden(true)
    }
    
    private func requestFamilyControlsAuthorization() {
        Task {
            do {
                try await authorizationCenter.requestAuthorization(for: .individual)
                // Authorization successful - toggle stays enabled
                print("Family Controls authorization granted")
            } catch {
                // Authorization failed - reset toggle
                await MainActor.run {
                    isContentRestrictionsEnabled = false
                }
                print("Family Controls authorization failed: \(error)")
                
                // Show alert to user about going to Settings
                showSettingsAlert()
            }
        }
    }
    
    private func showSettingsAlert() {
        // In a real implementation, you might want to show an alert
        // For now, we'll just open Settings directly
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

// Starfield background view to match the design
struct StarfieldView: View {
    @State private var stars: [Star] = []
    
    var body: some View {
        ZStack {
            ForEach(stars, id: \.id) { star in
                Circle()
                    .fill(Color.white.opacity(star.opacity))
                    .frame(width: star.size, height: star.size)
                    .position(x: star.x, y: star.y)
            }
        }
        .onAppear {
            generateStars()
        }
    }
    
    private func generateStars() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        stars = (0..<50).map { _ in
            Star(
                id: UUID(),
                x: CGFloat.random(in: 0...screenWidth),
                y: CGFloat.random(in: 0...screenHeight),
                size: CGFloat.random(in: 1...3),
                opacity: Double.random(in: 0.2...0.8)
            )
        }
    }
}

struct Star {
    let id: UUID
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let opacity: Double
}

#Preview {
    InternetFilterView()
}
