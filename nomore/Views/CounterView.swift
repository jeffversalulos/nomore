import SwiftUI

struct CounterView: View {
    @EnvironmentObject var streakStore: StreakStore
    @EnvironmentObject var onboardingManager: OnboardingManager
    @EnvironmentObject var journalStore: JournalStore
    @EnvironmentObject var goalsStore: GoalsStore
    @EnvironmentObject var dailyUsageStore: DailyUsageStore
    @EnvironmentObject var achievementStore: AchievementStore
    @EnvironmentObject var appStreakStore: AppStreakStore
    @Binding var selectedTab: Int
    
    @State private var showingMoreView = false
    @State private var showingStreakModal = false
    @State private var showingAchievementsSheet = false
    @State private var showingJournalView = false
    @State private var now: Date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            VStack {
                // Fixed header at top
                HeaderView(showingStreakModal: $showingStreakModal, showingAchievementsSheet: $showingAchievementsSheet)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                
                // Scrollable content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        Spacer(minLength: 20)
                        
                        // Weekly Progress Tracker
                        WeeklyProgressTracker()
                            .padding(.horizontal, 24)

                    // Achievement progress ring
                    let achievementSeconds = now.timeIntervalSince(streakStore.lastRelapseDate)
                    let achievementDays = achievementSeconds / (24 * 3600) // Keep as Double for fractional days
                    AchievementProgressRing(daysSinceLastRelapse: achievementDays, achievementStore: achievementStore, showingAchievementsSheet: $showingAchievementsSheet)

                    let components = calculateTimeComponents(from: streakStore.lastRelapseDate, to: now)
                    StreakCounter(components: components)
                    
                    // Brain Rewiring Progress Bar (100-day goal)
                    let secondsSinceRelapse = now.timeIntervalSince(streakStore.lastRelapseDate)
                    let daysSinceRelapse = secondsSinceRelapse / (24 * 3600)
                    let brainRewiringProgress = min(max(daysSinceRelapse / 100.0, 0), 1)
                    BrainRewiringProgressBar(progress: brainRewiringProgress)
                        .padding(.horizontal, 24)

                    // Action buttons section
                    VStack(spacing: 16) {
                        // Panic Button
                        PanicButton {
                            // Navigate to Journal view
                            selectedTab = 1
                        }
                        .padding(.horizontal)

                        // Relapse button - more subtle and refined
                        Button {
                            streakStore.resetRelapseDate()
                            selectedTab = 1
                        } label: {
                            Text("Reset Streak")
                                .font(.system(size: 16, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 24)
                                .background(Theme.surface)
                                .foregroundStyle(.white.opacity(0.7))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 32)
                    
                    // Tracking Cards Section
                    TrackingCards(startDate: streakStore.lastRelapseDate)
                        .padding(.top, 24)

                    // Analytics Button
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
                    .padding(.horizontal, 24)
                    .padding(.top, 32)

                    // Daily Reflection Component
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showingJournalView = true
                        }
                    } label: {
                        VStack(spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
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
                            
                            HStack {
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
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Theme.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Theme.accent.opacity(0.3), Theme.mint.opacity(0.2)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

                    // Add some bottom padding for better scrolling experience
                    Spacer(minLength: 50)
                }
                    .padding(.bottom, 20)
            }
            }
            
            // More button in top right - positioned above ScrollView
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingMoreView = true
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 22))
                            .foregroundStyle(Theme.textPrimary)
                            .padding(8)
                            .background(Theme.surface)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
                            )
                    }
                    .padding(.trailing, 16)
                }
                .padding(.top, 8)
                Spacer()
            }
        }
        .appBackground()
        .onReceive(timer) { value in
            withAnimation(.easeInOut(duration: 0.3)) {
                now = value
            }
        }
        .sheet(isPresented: $showingMoreView) {
            MoreView()
                .environmentObject(onboardingManager)
                .environmentObject(streakStore)
                .environmentObject(journalStore)
                .environmentObject(goalsStore)
                .environmentObject(dailyUsageStore)
        }
        .overlay(
            // Streak modal overlay
            showingStreakModal ? StreakModal(isPresented: $showingStreakModal)
                .environmentObject(appStreakStore) : nil
        )
        .fullScreenCover(isPresented: $showingAchievementsSheet) {
            AchievementsSheet(isPresented: $showingAchievementsSheet)
                .environmentObject(streakStore)
                .environmentObject(achievementStore)
        }
        .sheet(isPresented: $showingJournalView) {
            JournalView()
                .environmentObject(journalStore)
        }
    }
}



#Preview {
    @State var tab = 0
    let store = StreakStore()
    let achievementStore = AchievementStore()
    let dailyUsageStore = DailyUsageStore()
    let appStreakStore = AppStreakStore(dailyUsageStore: dailyUsageStore)
    return CounterView(selectedTab: .constant(0))
        .environmentObject(store)
        .environmentObject(OnboardingManager())
        .environmentObject(JournalStore())
        .environmentObject(GoalsStore())
        .environmentObject(dailyUsageStore)
        .environmentObject(achievementStore)
        .environmentObject(appStreakStore)
        
}


