import SwiftUI

struct InternetFilterCard: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 16) {
            // Internet Filter Heading
            HStack {
                Text("Protection Tools")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Theme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 24)
            
            // Internet Filter Card
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedTab = 3
                }
            } label: {
                HStack(spacing: 16) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(Theme.purple.opacity(0.15))
                            .frame(width: 48, height: 48)
                        
                        Text("🛡️")
                            .font(.system(size: 48))
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Internet Filter")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Theme.textPrimary)
                        
                        Text("Choose the content \nyou want to block")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    // Arrow
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 27)
                .background(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    InternetFilterCard(selectedTab: .constant(0))
        .appBackground()
}
