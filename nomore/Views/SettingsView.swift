import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @State private var notificationsEnabled: Bool = true
    
    var body: some View {
        ZStack {
            // Header with close button
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Theme.textSecondary)
                            .frame(width: 36, height: 36)
                            .background(Theme.surface)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
                            )
                    }
                    
                    Spacer()
                    
                    Text("Settings")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)
                    
                    Spacer()
                    
                    // Invisible spacer for centering
                    Color.clear
                        .frame(width: 36, height: 36)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                // Scrollable content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        // Account Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Account")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Theme.textSecondary.opacity(0.7))
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "creditcard.fill",
                                    iconColor: Theme.mint,
                                    title: "Manage Subscription",
                                    showDivider: false
                                ) {
                                    // TODO: Implement subscription management
                                }
                            }
                        }
                        
                        // Preferences Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Preferences")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Theme.textSecondary.opacity(0.7))
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            VStack(spacing: 0) {
                                SettingsToggleRow(
                                    icon: "bell.fill",
                                    iconColor: Color.orange,
                                    title: "Notifications",
                                    showDivider: false,
                                    isOn: $notificationsEnabled
                                )
                            }
                        }
                        
                        // Legal Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Legal")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Theme.textSecondary.opacity(0.7))
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "doc.text.fill",
                                    iconColor: Theme.aqua,
                                    title: "Terms of Service"
                                ) {
                                    // TODO: Implement Terms of Service
                                }
                                
                                SettingsRow(
                                    icon: "lock.shield.fill",
                                    iconColor: Theme.accent,
                                    title: "Privacy Policy",
                                    showDivider: false
                                ) {
                                    // TODO: Implement Privacy Policy
                                }
                            }
                        }
                        
                        // App Info
                        VStack(spacing: 6) {
                            Text("ANEW")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundStyle(Theme.textSecondary.opacity(0.6))
                            
                            Text("Version 1.0.0")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(Theme.textSecondary.opacity(0.4))
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 50)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .appBackground()
    }
}

#Preview {
    SettingsView(isPresented: .constant(true))
}

