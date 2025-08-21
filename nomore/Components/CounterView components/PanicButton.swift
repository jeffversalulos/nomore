import SwiftUI

struct PanicButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.shield.fill")
                    .font(.title3)
                
                Text("Panic Button")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [Theme.aqua, Theme.mint],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundStyle(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .accessibilityLabel("Panic Button")
        .accessibilityHint("Takes you to the journal to help prevent relapse")
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient
        PanicButton {
            print("Panic button tapped")
        }
        .padding()
    }
}
