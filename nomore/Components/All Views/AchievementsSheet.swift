import SwiftUI

struct AchievementsSheet: View {
    @EnvironmentObject var achievementStore: AchievementStore
    @EnvironmentObject var streakStore: StreakStore
    @Binding var isPresented: Bool
    @State private var showingResetAlert = false
    @State private var now: Date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var daysSinceLastRelapse: Int {
        let secondsSince = now.timeIntervalSince(streakStore.lastRelapseDate)
        return max(0, Int(secondsSince / (24 * 3600)))
    }
    
    private var unlockedCount: Int {
        achievementStore.getUnlockedCount(daysSinceLastRelapse: daysSinceLastRelapse)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header section
                VStack(spacing: 16) {
                    // Header content
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(unlockedCount) of \(achievementStore.achievements.count) unlocked")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Theme.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Progress indicator and reset button
                        HStack(spacing: 16) {
                            // Progress ring
                            ZStack {
                                Circle()
                                    .stroke(.white.opacity(0.1), lineWidth: 3)
                                    .frame(width: 40, height: 40)
                                
                                Circle()
                                    .trim(from: 0, to: CGFloat(unlockedCount) / CGFloat(achievementStore.achievements.count))
                                    .stroke(Theme.mint, lineWidth: 3)
                                    .frame(width: 40, height: 40)
                                    .rotationEffect(.degrees(-90))
                                
                                Text("\(unlockedCount)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(Theme.mint)
                            }
                            
                            // Reset button
                            Button {
                                showingResetAlert = true
                            } label: {
                                Image(systemName: "arrow.clockwise")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(Theme.textSecondary)
                                    .frame(width: 44, height: 44)
                                    .background(Theme.surface)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Theme.surfaceStroke, lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 20)
                
                // Achievements list
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(achievementStore.achievements) { achievement in
                            AchievementCard(
                                achievement: achievement,
                                isUnlocked: achievement.isUnlocked(daysSinceLastRelapse: daysSinceLastRelapse),
                                daysSinceLastRelapse: daysSinceLastRelapse
                            )
                            .padding(.horizontal, 24)
                        }
                        
                        // Bottom padding for better scrolling
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 8)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .appBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Milestones")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
            }
        }
        .onReceive(timer) { value in
            now = value
        }
        .alert("Reset Achievements", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                achievementStore.resetAchievements()
            }
        } message: {
            Text("Are you sure you want to reset your achievement progress? This action cannot be undone.")
        }
    }
}

#Preview {
    @State var isPresented = true
    let achievementStore = AchievementStore()
    let streakStore = StreakStore()
    
    return AchievementsSheet(isPresented: .constant(true))
        .environmentObject(achievementStore)
        .environmentObject(streakStore)
        .appBackground()
}
