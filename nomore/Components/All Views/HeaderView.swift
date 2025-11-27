import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var appStreakStore: AppStreakStore
    @Binding var showingStreakModal: Bool
    @Binding var showingAchievementsSheet: Bool
    @Binding var showingSettingsView: Bool
    
    var body: some View {
        HStack {
            // Logo/Brand name on the left
            Text("ANEW")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
            
            Spacer()
            
            // Symbols on the right
            HStack(spacing: 16) {
                // Fire symbol with streak count - tappable
                Button {
                    showingStreakModal = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color.orange)
                        
                        Text("\(appStreakStore.consecutiveDaysStreak)")
                            .font(.system(size: 21, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.orange)
                    }
                }
                
                // Trophy symbol - tappable
                Button {
                    showingAchievementsSheet = true
                } label: {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Theme.mint)
                }
                
                // Settings symbol - tappable
                Button {
                    showingSettingsView = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

#Preview {
    let dailyUsageStore = DailyUsageStore()
    let appStreakStore = AppStreakStore(dailyUsageStore: dailyUsageStore)
    
    return HeaderView(
        showingStreakModal: .constant(false),
        showingAchievementsSheet: .constant(false),
        showingSettingsView: .constant(false)
    )
    .environmentObject(appStreakStore)
    .padding()
    .appBackground()
}
