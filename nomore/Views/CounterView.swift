import SwiftUI

struct CounterView: View {
    @EnvironmentObject var streakStore: StreakStore
    @Binding var selectedTab: Int
    
    @State private var showingMoreView = false //Remove
    @State private var now: Date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
            
            VStack(spacing: 32) {
                Spacer(minLength: 20)
                
                // Weekly Progress Tracker
                WeeklyProgressTracker()
                    .padding(.horizontal, 24)

                // Decorative progress ring (30-day horizon)
                let secondsSince = now.timeIntervalSince(streakStore.lastRelapseDate)
                let progress = min(max(secondsSince / (30 * 24 * 3600), 0), 1)
                StreakRingView(progress: progress)

                VStack(spacing: 24) {
                    Text("You've been porn-free for:")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.white.opacity(0.75))
                        .tracking(0.3)

                    let components = calculateTimeComponents(from: streakStore.lastRelapseDate, to: now)
                    
                    // Main counter display - ultra clean and minimal
                    VStack(spacing: 16) {
                        // Primary time display (largest unit)
                        HStack(alignment: .lastTextBaseline, spacing: 6) {
                            if components.months > 0 {
                                Text("\(components.months)")
                                    .font(.system(size: 82, weight: .ultraLight, design: .rounded))
                                    .foregroundStyle(.white)
                                    .contentTransition(.numericText())
                                Text("mo")
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundStyle(.white.opacity(0.65))
                                    .offset(y: -12)
                            } else if components.days > 0 {
                                Text("\(components.days)")
                                    .font(.system(size: 82, weight: .ultraLight, design: .rounded))
                                    .foregroundStyle(.white)
                                    .contentTransition(.numericText())
                                Text("d")
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundStyle(.white.opacity(0.65))
                                    .offset(y: -12)
                            } else {
                                Text("\(components.hours)")
                                    .font(.system(size: 82, weight: .ultraLight, design: .rounded))
                                    .foregroundStyle(.white)
                                    .contentTransition(.numericText())
                                Text("hr")
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundStyle(.white.opacity(0.65))
                                    .offset(y: -12)
                                
                                Text("\(components.minutes)")
                                    .font(.system(size: 82, weight: .ultraLight, design: .rounded))
                                    .foregroundStyle(.white)
                                    .contentTransition(.numericText())
                                Text("m")
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundStyle(.white.opacity(0.65))
                                    .offset(y: -12)
                            }
                        }
                        
                        // Secondary time display (smaller unit) - only show if relevant
                        if components.months > 0 && components.days > 0 {
                            Text("\(components.days)d")
                                .font(.system(size: 18, weight: .light, design: .rounded))
                                .foregroundStyle(.white.opacity(0.6))
                                .contentTransition(.numericText())
                        } else if components.days > 0 && components.hours > 0 {
                            Text("\(components.hours)hr")
                                .font(.system(size: 18, weight: .light, design: .rounded))
                                .foregroundStyle(.white.opacity(0.6))
                                .contentTransition(.numericText())
                        }
                    }
                    
                    // Dedicated seconds counter - clean and minimal
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text("\(components.seconds)")
                            .font(.system(size: 32, weight: .ultraLight, design: .rounded))
                            .foregroundStyle(.white.opacity(0.85))
                            .contentTransition(.numericText())
                        Text("s")
                            .font(.system(size: 18, weight: .light))
                            .foregroundStyle(.white.opacity(0.65))
                            .offset(y: -4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.white.opacity(0.06))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(.white.opacity(0.12), lineWidth: 0.5)
                            )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.top, 8)
                }

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

                Spacer()
            }
        }
        .appBackground()
        .onReceive(timer) { value in
            withAnimation(.easeInOut(duration: 0.3)) {
                now = value
            }
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


