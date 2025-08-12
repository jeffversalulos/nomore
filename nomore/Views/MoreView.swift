import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Coming soon") {
                    Label("Community", systemImage: "person.3")
                    Label("Insights", systemImage: "chart.xyaxis.line")
                    Label("Settings", systemImage: "gear")
                }
            }
            .navigationTitle("More")
        }
    }
}

#Preview {
    MoreView()
}


