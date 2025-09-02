import SwiftUI

struct HeaderView: View {
    @Binding var showingStreakModal: Bool
    @Binding var showingAchievementsSheet: Bool
    
    var body: some View {
        HStack {
            // Logo/Brand name on the left
            Text("QUITTR")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
            
            Spacer()
            
            // Symbols on the right
            HStack(spacing: 16) {
                // Fire symbol - tappable
                Button {
                    showingStreakModal = true
                } label: {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.orange)
                }
                
                // Trophy symbol - tappable
                Button {
                    showingAchievementsSheet = true
                } label: {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Theme.mint)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

#Preview {
    HeaderView(showingStreakModal: .constant(false), showingAchievementsSheet: .constant(false))
        .padding()
        .appBackground()
}
