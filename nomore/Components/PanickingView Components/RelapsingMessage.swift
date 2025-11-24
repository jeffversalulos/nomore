import SwiftUI

struct RelapsingMessage: View {
    var body: some View {
        ZStack {
            // Dark background with slight transparency
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
            
            Text("RELAPSING WON'T\nSOLVE ANYTHING.")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }
        .frame(height: 80)
        .padding(.horizontal, 40)
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        RelapsingMessage()
    }
}
