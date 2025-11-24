import SwiftUI

struct PanicBottomButtons: View {
    var onIRelapsed: () -> Void = {}
    var onThinkingOfRelapsing: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 16) {
            // "I Relapsed" button
            Button(action: onIRelapsed) {
                HStack(spacing: 8) {
                    Image(systemName: "hand.thumbsdown.fill")
                        .font(.system(size: 16))
                    
                    Text("I Relapsed")
                        .font(.system(size: 16, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red.opacity(0.5), lineWidth: 1)
                        )
                )
                .foregroundColor(.red)
            }
            
            // "I'm thinking of relapsing" button
            Button(action: onThinkingOfRelapsing) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 16))
                    
                    Text("I'm thinking of relapsing")
                        .font(.system(size: 16, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red)
                )
                .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            // Gradient background for the sticky section
            LinearGradient(
                colors: [Color.black.opacity(0.8), Color.black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            PanicBottomButtons()
        }
    }
}
