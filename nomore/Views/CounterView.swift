import SwiftUI

struct CounterView: View {
    @EnvironmentObject var streakStore: StreakStore
    @EnvironmentObject var onboardingManager: OnboardingManager
    @EnvironmentObject var journalStore: JournalStore
    @EnvironmentObject var goalsStore: GoalsStore
    @EnvironmentObject var dailyUsageStore: DailyUsageStore
    @Binding var selectedTab: Int
    
    @State private var showingMoreView = false
    @State private var now: Date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 32) {
                    Spacer(minLength: 20)
                    
                    // Weekly Progress Tracker
                    WeeklyProgressTracker()
                        .padding(.horizontal, 24)

                    // Decorative progress ring (30-day horizon)
                    let secondsSince = now.timeIntervalSince(streakStore.lastRelapseDate)
                    let progress = min(max(secondsSince / (30 * 24 * 3600), 0), 1)
                    StreakRingView(progress: progress)

                    let components = calculateTimeComponents(from: streakStore.lastRelapseDate, to: now)
                    StreakCounter(components: components)

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
                                .background(.white.opacity(0.04))
                                .foregroundStyle(.white.opacity(0.7))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(.white.opacity(0.1), lineWidth: 0.5)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 32)

                    // Add some bottom padding for better scrolling experience
                    Spacer(minLength: 50)
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
                                    .stroke(Theme.surfaceStroke, lineWidth: 1)
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
    }
}



#Preview {
    @State var tab = 0
    let store = StreakStore()
    return CounterView(selectedTab: .constant(0))
        .environmentObject(store)
        .environmentObject(OnboardingManager())
        .environmentObject(JournalStore())
        .environmentObject(GoalsStore())
        .environmentObject(DailyUsageStore())
        
}


