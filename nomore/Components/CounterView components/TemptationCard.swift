import SwiftUI

struct TemptationCard: View {
    // Hardcoded placeholders as requested
    @State private var isTempted: Bool = false
    private let temptationEmoji = "😄"
    
    var body: some View {
        VStack(spacing: 16) {
            // Emoji
            Text(temptationEmoji)
                .font(.system(size: 40))
            
            VStack(spacing: 8) {
                Text("Tempted to Relapse:")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Text(isTempted ? "True" : "False")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(isTempted ? .red : Color(red: 0.0, green: 0.8, blue: 0.4))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 140)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(.white.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.15), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onTapGesture {
            // For demo purposes - toggle temptation state
            withAnimation(.easeInOut(duration: 0.2)) {
                isTempted.toggle()
            }
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        TemptationCard()
        TemptationCard()
    }
    .padding()
    .background(Theme.backgroundGradient)
}
