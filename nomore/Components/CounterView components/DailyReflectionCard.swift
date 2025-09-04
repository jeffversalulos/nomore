import SwiftUI

struct DailyReflectionCard: View {
    @Binding var showingJournalView: Bool
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showingJournalView = true
            }
        } label: {
            VStack(spacing: 24) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Daily Reflection")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Theme.textPrimary)
                        Text("Take a moment to reflect on your journey")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Image(systemName: "pencil.line")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.accent)
                }
                
                HStack(spacing: 10) {
                    Image(systemName: "heart.text.square")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Theme.mint)
                    Text("Express your thoughts and feelings")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                    Spacer()
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Theme.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Theme.surfaceStroke.opacity(0.5), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(ReflectionCardButtonStyle())
    }
}

struct ReflectionCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    DailyReflectionCard(showingJournalView: .constant(false))
}
