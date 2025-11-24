import SwiftUI

struct MotivationalMessageCard: View {
    var body: some View {
        Text("You've made it through the hardest part. Your foundation is stronger. Reflect on how far you've come.")
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(Theme.textSecondary)
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .padding(.horizontal, 32)
    }
}

#Preview {
    MotivationalMessageCard()
        .appBackground()
}
