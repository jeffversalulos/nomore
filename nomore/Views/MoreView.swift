import SwiftUI

struct MoreView: View {
    @EnvironmentObject var onboardingManager: OnboardingManager
    
    var body: some View {
        ZStack {

            NavigationStack {
                List {
                    Section("Recovery Tools") {
                        NavigationLink(destination: GoalsView()) {
                            Label("Your Goals", systemImage: "target")
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
                            onboardingManager.resetOnboarding()
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
}


