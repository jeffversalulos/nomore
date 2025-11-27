import SwiftUI

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let showDivider: Bool
    let action: () -> Void
    
    init(
        icon: String,
        iconColor: Color = Theme.textPrimary,
        title: String,
        showDivider: Bool = true,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.showDivider = showDivider
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                HStack(spacing: 14) {
                    // Icon
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(iconColor)
                        .frame(width: 28)
                    
                    // Title
                    Text(title)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(Theme.textPrimary)
                    
                    Spacer()
                    
                    // Chevron
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.textSecondary.opacity(0.5))
                }
                .padding(.vertical, 14)
                
                // Divider
                if showDivider {
                    Rectangle()
                        .fill(Theme.textSecondary.opacity(0.15))
                        .frame(height: 0.5)
                        .padding(.leading, 42)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// Toggle variant for notifications
struct SettingsToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let showDivider: Bool
    @Binding var isOn: Bool
    
    init(
        icon: String,
        iconColor: Color = Theme.textPrimary,
        title: String,
        showDivider: Bool = true,
        isOn: Binding<Bool>
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.showDivider = showDivider
        self._isOn = isOn
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(iconColor)
                    .frame(width: 28)
                
                // Title
                Text(title)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundStyle(Theme.textPrimary)
                
                Spacer()
                
                // Toggle
                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .tint(Theme.mint)
            }
            .padding(.vertical, 14)
            
            // Divider
            if showDivider {
                Rectangle()
                    .fill(Theme.textSecondary.opacity(0.15))
                    .frame(height: 0.5)
                    .padding(.leading, 42)
            }
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        SettingsRow(
            icon: "doc.text.fill",
            iconColor: Theme.aqua,
            title: "Terms of Service"
        ) {
            // Action
        }
        
        SettingsRow(
            icon: "lock.shield.fill",
            iconColor: Theme.accent,
            title: "Privacy Policy",
            showDivider: false
        ) {
            // Action
        }
        
        SettingsToggleRow(
            icon: "bell.fill",
            iconColor: Color.orange,
            title: "Notifications",
            showDivider: false,
            isOn: .constant(true)
        )
    }
    .padding(.horizontal, 24)
    .appBackground()
}

