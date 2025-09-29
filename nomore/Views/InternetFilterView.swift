import SwiftUI
import FamilyControls
import ManagedSettings

struct InternetFilterView: View {
    @EnvironmentObject private var appRestrictionsStore: AppRestrictionsStore
    @State private var authorizationCenter = AuthorizationCenter.shared
    @State private var isAppPickerPresented = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Title
                Text("Internet Filter")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                
                Spacer()
                
                // Main content area with starfield background effect
                VStack(spacing: 40) {
                    // Description and status
                    VStack(spacing: 16) {
                        VStack(spacing: 12) {
                            Text("QUITTR protects you by managing content restrictions and disabling private browsing.")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                                .padding(.horizontal, 40)
                            
                            if appRestrictionsStore.hasActiveRestrictions {
                                Text("Active restrictions: \(appRestrictionsStore.activitySelection.applicationTokens.count) apps, \(appRestrictionsStore.activitySelection.categoryTokens.count) categories")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Theme.mint)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                        }
                    }
                    
                    // Enable Content Restrictions Toggle
                    VStack(spacing: 20) {
                        HStack {
                            Text("Enable Content Restrictions")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Theme.textPrimary)
                            
                            Spacer()
                            
                            Toggle("", isOn: $appRestrictionsStore.isContentRestrictionsEnabled)
                                .toggleStyle(SwitchToggleStyle(tint: Theme.mint))
                                .scaleEffect(1.1)
                        }
                        .padding(.horizontal, 40)
                        .onChange(of: appRestrictionsStore.isContentRestrictionsEnabled) { oldValue, newValue in
                            if newValue {
                                requestFamilyControlsAuthorization()
                            } else {
                                appRestrictionsStore.setContentRestrictionsEnabled(false)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Bottom button
                VStack(spacing: 16) {
                    Button(action: {
                        isAppPickerPresented = true
                    }) {
                        HStack(spacing: 8) {
                            Text(appRestrictionsStore.hasActiveRestrictions ? "Manage Blocked Apps" : "Block Apps")
                            Image(systemName: appRestrictionsStore.hasActiveRestrictions ? "gear" : "plus")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(appRestrictionsStore.isContentRestrictionsEnabled ? Theme.textPrimary : Theme.textSecondary)
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
                    .disabled(!appRestrictionsStore.isContentRestrictionsEnabled)
                    .opacity(appRestrictionsStore.isContentRestrictionsEnabled ? 1.0 : 0.6)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) // Add bottom padding to account for the custom tab bar
                }
            }
            
            // Starfield background effect
            StarfieldView()
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
        .appBackground()
        .familyActivityPicker(isPresented: $isAppPickerPresented, selection: $appRestrictionsStore.activitySelection)
        .onChange(of: appRestrictionsStore.activitySelection) { oldSelection, newSelection in
            appRestrictionsStore.updateActivitySelection(newSelection)
        }
        .onChange(of: isAppPickerPresented) { oldValue, newValue in
            // Handle picker dismissal to prevent navigation glitch
            if !newValue {
                // Picker was dismissed, ensure we stay in this view
                print("Family activity picker dismissed")
            }
        }
    }
    
    private func requestFamilyControlsAuthorization() {
        Task {
            do {
                try await authorizationCenter.requestAuthorization(for: .individual)
                // Authorization successful - update store
                await MainActor.run {
                    appRestrictionsStore.setContentRestrictionsEnabled(true)
                }
                print("Family Controls authorization granted")
            } catch {
                // Authorization failed - reset toggle
                await MainActor.run {
                    appRestrictionsStore.setContentRestrictionsEnabled(false)
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
