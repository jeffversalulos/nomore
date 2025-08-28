import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            // Logo/Brand name on the left
            Text("QUITTR")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
            
            Spacer()
            
            // Symbols on the right
            HStack(spacing: 16) {
                // Fire symbol
                Image(systemName: "flame.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Theme.accent)
                
                // Trophy symbol
                Image(systemName: "trophy.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Theme.mint)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Theme.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Theme.surfaceStroke, lineWidth: 0.5)
                )
        )
    }
}

#Preview {
    HeaderView()
        .padding()
        .appBackground()
}
