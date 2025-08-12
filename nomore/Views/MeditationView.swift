import SwiftUI

struct MeditationView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Meditation Mode")
                .font(.largeTitle.bold())
            Text("Find your breath. This is a placeholder for guided meditations.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 32)
    }
}

#Preview {
    MeditationView()
}


