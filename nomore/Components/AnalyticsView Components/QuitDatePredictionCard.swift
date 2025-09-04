import SwiftUI

struct QuitDatePredictionCard: View {
    @EnvironmentObject var streakStore: StreakStore
    
    var body: some View {
        VStack(spacing: 12) {
            Text("You're on track to quit porn by:")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(formattedQuitDate)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.textPrimary)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Theme.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Theme.surfaceStroke, lineWidth: 1)
                        )
                )
        }
        .padding(.horizontal, 24)
    }
    
    // REUSE the EXACT same logic as QuitDateCard (90 days from start date)
    private var formattedQuitDate: String {
        let quitDate = Calendar.current.date(byAdding: .day, value: 90, to: streakStore.lastRelapseDate) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: quitDate)
    }
}

#Preview {
    QuitDatePredictionCard()
        .environmentObject(StreakStore())
        .appBackground()
}
