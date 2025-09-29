import SwiftUI

struct MoreView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    @EnvironmentObject var goalsStore: GoalsStore
    
    var body: some View {
        ZStack {

            NavigationStack {
                List {
                    Section("Recovery Tools") {
                        NavigationLink(destination: PurposeView()) {
                            Label("Your Purpose", systemImage: "target")
                        }
                        NavigationLink(destination: InternetFilterView()) {
                            Label("Internet Filter", systemImage: "shield.checkered")
                        }
                    }
                    
                    Section("Coming soon") {
                        Label("Community", systemImage: "person.3")
                        Label("Insights", systemImage: "chart.xyaxis.line")
                        Label("Settings", systemImage: "gear")
                    }
                    
                    #if DEBUG
                    Section("Debug") {
                        Button("Reset Onboarding") {
                            onboardingManager.resetOnboarding(goalsStore: goalsStore)
                        }
                        .foregroundColor(.red)
                    }
                    #endif
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
                .tint(.white)
                .navigationTitle("More")
            }
        }
        .appBackground()
    }
}

#Preview {
    MoreView()
        .environmentObject(OnboardingManager())
        .environmentObject(StreakStore())
        .environmentObject(JournalStore())
        .environmentObject(GoalsStore())
        .environmentObject(PurposeStore())
        .environmentObject(DailyUsageStore())
}


