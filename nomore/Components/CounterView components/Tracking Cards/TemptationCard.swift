import SwiftUI

struct TemptationCard: View {
    // Hardcoded placeholders as requested
    @State private var isTempted: Bool = false
    @State private var showingTemptationSheet = false
    @State private var selectedMoodEmoji: String = "😄" // Default mood emoji
    
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
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Theme.surface)
                    
                    Theme.bubbleGradient
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            // Emoji positioned on top border
            VStack {
                Text(selectedMoodEmoji)
                    .font(.system(size: 40))
                    .offset(y: -20)
                
                Spacer()
            }
        }
        .onTapGesture {
            showingTemptationSheet = true
        }
        .sheet(isPresented: $showingTemptationSheet) {
            TemptationSheet(
                isPresented: $showingTemptationSheet,
                isTempted: $isTempted,
                selectedMoodEmoji: $selectedMoodEmoji
            )
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
