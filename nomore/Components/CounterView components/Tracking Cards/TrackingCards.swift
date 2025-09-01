import SwiftUI

struct TrackingCards: View {
    let startDate: Date
    
    var body: some View {
        HStack(spacing: 16) {
            QuitDateCard(startDate: startDate)
            TemptationCard()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    TrackingCards(startDate: Date())
        .padding()
        .background(Theme.backgroundGradient)
}
