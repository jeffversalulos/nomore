import SwiftUI

struct TemptationCard: View {
    // Hardcoded placeholders as requested
    @State private var isTempted: Bool = false
    private let temptationEmoji = "😄"
    
    var body: some View {
        ZStack {
            // Main card content
            VStack(spacing: 16) {
                // Spacer to push content down for the emoji
                Spacer(minLength: 24)
                
                VStack(spacing: 8) {
                                    Text("Tempted to Relapse:")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    
                    Text(isTempted ? "True" : "False")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(isTempted ? .red : Color(red: 0.0, green: 0.8, blue: 0.4))
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 110)
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .background(.white.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.white.opacity(0.15), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            // Emoji positioned on top border
            VStack {
                Text(temptationEmoji)
                    .font(.system(size: 40))
                    .offset(y: -20)
                
                Spacer()
            }
        }
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
