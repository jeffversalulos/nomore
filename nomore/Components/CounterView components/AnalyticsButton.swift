import SwiftUI

struct AnalyticsButton: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = 1
            }
        } label: {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 18, weight: .medium))
                Text("View Analytics")
                    .font(.system(size: 16, weight: .medium))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(Theme.surface)
            .foregroundStyle(Theme.textPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

#Preview {
    AnalyticsButton(selectedTab: .constant(0))
}
