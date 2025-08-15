import SwiftUI

struct MoreView: View {
    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()

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
                }
                .scrollContentBackground(.hidden)
                .listStyle(.insetGrouped)
                .tint(.white)
                .navigationTitle("More")
            }
        }
    }
}

#Preview {
    MoreView()
}


