import SwiftUI

struct TimeComponents {
    let months: Int
    let days: Int
    let hours: Int
    let minutes: Int
}

/// Calculates rough calendar-based difference between two dates in months, days, hours, minutes.
private func calculateTimeComponents(from startDate: Date, to endDate: Date = Date(), calendar: Calendar = .current) -> TimeComponents {
    var from = startDate
    var months = 0
    var days = 0
    var hours = 0
    var minutes = 0

    // Count months by adding months until we exceed endDate
    while let next = calendar.date(byAdding: .month, value: 1, to: from), next <= endDate {
        from = next
        months += 1
    }

    // Days
    while let next = calendar.date(byAdding: .day, value: 1, to: from), next <= endDate {
        from = next
        days += 1
    }

    // Hours
    while let next = calendar.date(byAdding: .hour, value: 1, to: from), next <= endDate {
        from = next
        hours += 1
    }

    // Minutes
    while let next = calendar.date(byAdding: .minute, value: 1, to: from), next <= endDate {
        from = next
        minutes += 1
    }

    return TimeComponents(months: months, days: days, hours: hours, minutes: minutes)
}

private struct StreakRingView: View {
    let progress: Double // 0...1

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.25), lineWidth: 22)

            Circle()
                .trim(from: 0, to: max(0.001, min(progress, 1)))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [Theme.aqua, Theme.accent]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 22, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
        }
        .frame(width: 220, height: 220)
    }
}

struct CounterView: View {
    @EnvironmentObject var streakStore: StreakStore
    @Binding var selectedTab: Int

    @State private var now: Date = Date()
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {

            VStack(spacing: 28) {
                Spacer(minLength: 24)

                // Decorative progress ring (30-day horizon)
                let secondsSince = now.timeIntervalSince(streakStore.lastRelapseDate)
                let progress = min(max(secondsSince / (30 * 24 * 3600), 0), 1)
                StreakRingView(progress: progress)
                    .padding(.top, 16)

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
    }
}

private struct CounterPill: View {
    let value: Int
    let unit: String

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Text(unit)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(width: 74, height: 74)
        .background(Theme.surface)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    @State var tab = 0
    let store = StreakStore()
    return CounterView(selectedTab: .constant(0))
        .environmentObject(store)
        .padding()
}


