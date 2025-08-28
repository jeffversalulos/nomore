import SwiftUI

struct CounterView: View {
    @EnvironmentObject var streakStore: StreakStore
    @Binding var selectedTab: Int
    
    @State private var showingMoreView = false //Remove
    @State private var now: Date = Date()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // More button in top right
            VStack { //Remove
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
            
            VStack(spacing: 28) {
                Spacer(minLength: 24)
                
                // Weekly Progress Tracker
                WeeklyProgressTracker()
                    .padding(.horizontal, 24)

                // Decorative progress ring (30-day horizon)
                let secondsSince = now.timeIntervalSince(streakStore.lastRelapseDate)
                let progress = min(max(secondsSince / (30 * 24 * 3600), 0), 1)
                StreakRingView(progress: progress)
                    .padding(.top, 8)

                VStack(spacing: 10) {
                    Text("Your streak")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Theme.textSecondary)

                    let components = calculateTimeComponents(from: streakStore.lastRelapseDate, to: now)
                    HStack(spacing: 12) {
                        CounterPill(value: components.months, unit: "Months")
                        CounterPill(value: components.days, unit: "Days")
                        CounterPill(value: components.hours, unit: "Hours")
                        CounterPill(value: components.minutes, unit: "Minutes")
                    }
                    .padding(.horizontal)
                }

                // Panic Button
                PanicButton {
                    // Navigate to Journal view
                    selectedTab = 1
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Button {
                    streakStore.resetRelapseDate()
                    selectedTab = 1
                } label: {
                    Text("Relapse")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.surface)
                        .foregroundStyle(Theme.textPrimary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Theme.surfaceStroke, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .appBackground()
        .onReceive(timer) { value in
            now = value
        }
        .sheet(isPresented: $showingMoreView) { //Remove
            MoreView() //Remove
        } //Remove
    }
}



#Preview {
    @State var tab = 0
    let store = StreakStore()
    return CounterView(selectedTab: .constant(0))
        .environmentObject(store)
        .environmentObject(OnboardingManager()) //Remove
        .environmentObject(JournalStore()) //Remove
        .environmentObject(GoalsStore()) //Remove
        
}


