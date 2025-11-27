import SwiftUI

struct CounterView: View {
    @EnvironmentObject var streakStore: StreakStore
    @EnvironmentObject var onboardingManager: OnboardingManager
    @EnvironmentObject var journalStore: JournalStore
    @EnvironmentObject var goalsStore: GoalsStore
    @EnvironmentObject var dailyUsageStore: DailyUsageStore
    @EnvironmentObject var achievementStore: AchievementStore
    @EnvironmentObject var appStreakStore: AppStreakStore
    @EnvironmentObject var consistencyStore: ConsistencyStore
    @Binding var selectedTab: Int
    
    @State private var showingMoreView = false
    @State private var showingStreakModal = false
    @State private var showingAchievementsSheet = false
    @State private var showingSettingsView = false
    @State private var showingJournalView = false
    @State private var showingPanickingView = false
    @State private var showingRelapseView = false
    @State private var now: Date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            VStack {
                // Fixed header at top
                HeaderView(
                    showingStreakModal: $showingStreakModal,
                    showingAchievementsSheet: $showingAchievementsSheet,
                    showingSettingsView: $showingSettingsView
                )
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                // Scrollable content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        Spacer(minLength: 0.5)
                        
                        // Weekly Progress Tracker
                        WeeklyProgressTracker()
                            .padding(.horizontal, 24)

                    // Achievement progress ring
                    let achievementSeconds = now.timeIntervalSince(streakStore.lastRelapseDate)
                    let achievementDays = achievementSeconds / (24 * 3600) // Keep as Double for fractional days
                    AchievementProgressRing(daysSinceLastRelapse: achievementDays, achievementStore: achievementStore, showingAchievementsSheet: $showingAchievementsSheet)
                        .padding(.vertical, -28)

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
                            // Show PanickingView as sheet
                            showingPanickingView = true
                        }
                        .padding(.horizontal)

                        // Relapse button
                        RelapseButton {
                            showingRelapseView = true
                        }
                    }
                    .padding(.top, 32)
                    
                    // Tracking Cards Section
                    TrackingCards(startDate: streakStore.lastRelapseDate)
                        .padding(.top, 24)

                    // Analytics Section
                    VStack(spacing: 16) {
                        // View Analytics Heading
                        HStack {
                            Text("View Analytics")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Theme.textPrimary)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        // Chart Image Button
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = 1
                            }
                        } label: {
                            Image("Chart FIgma")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .offset(y: -4)
                                .background(Theme.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 32)

                    // Internet Filter Section
                    InternetFilterCard(selectedTab: $selectedTab)
                        .padding(.top, 32)

                    // Daily Reflection Component
                    DailyReflectionCard(showingJournalView: $showingJournalView)
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
        .sheet(isPresented: $showingPanickingView) {
            PanickingView()
        }
        .fullScreenCover(isPresented: $showingRelapseView) {
            RelapseView(isPresented: $showingRelapseView, selectedTab: $selectedTab)
                .environmentObject(streakStore)
                .environmentObject(consistencyStore)
        }
        .fullScreenCover(isPresented: $showingSettingsView) {
            SettingsView(isPresented: $showingSettingsView)
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
        .environmentObject(ConsistencyStore())
        
}


