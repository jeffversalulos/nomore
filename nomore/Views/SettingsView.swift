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
                    VStack(spacing: 24) {
                        // Account Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Account")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Theme.textSecondary)
                                .textCase(.uppercase)
                                .tracking(1)
                                .padding(.leading, 4)
                            
                            VStack(spacing: 10) {
                                SettingsRow(
                                    icon: "creditcard.fill",
                                    iconColor: Theme.mint,
                                    title: "Manage Subscription",
                                    subtitle: "View and manage your plan"
                                ) {
                                    // TODO: Implement subscription management
                                }
                            }
                        }
                        
                        // Preferences Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Preferences")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Theme.textSecondary)
                                .textCase(.uppercase)
                                .tracking(1)
                                .padding(.leading, 4)
                            
                            VStack(spacing: 10) {
                                SettingsToggleRow(
                                    icon: "bell.fill",
                                    iconColor: Color.orange,
                                    title: "Notifications",
                                    subtitle: "Enable push notifications",
                                    isOn: $notificationsEnabled
                                )
                            }
                        }
                        
                        // Legal Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Legal")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Theme.textSecondary)
                                .textCase(.uppercase)
                                .tracking(1)
                                .padding(.leading, 4)
                            
                            VStack(spacing: 10) {
                                SettingsRow(
                                    icon: "doc.text.fill",
                                    iconColor: Theme.aqua,
                                    title: "Terms of Service",
                                    subtitle: "Read our terms and conditions"
                                ) {
                                    // TODO: Implement Terms of Service
                                }
                                
                                SettingsRow(
                                    icon: "lock.shield.fill",
                                    iconColor: Theme.accent,
                                    title: "Privacy Policy",
                                    subtitle: "Learn how we protect your data"
                                ) {
                                    // TODO: Implement Privacy Policy
                                }
                            }
                        }
                        
                        // App Info
                        VStack(spacing: 8) {
                            Text("ANEW")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundStyle(Theme.textPrimary)
                            
                            Text("Version 1.0.0")
                                .font(.system(size: 13, weight: .regular))
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .padding(.top, 32)
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

