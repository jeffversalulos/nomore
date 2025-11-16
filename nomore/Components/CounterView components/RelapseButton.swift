import SwiftUI

struct RelapseButton: View {
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text("I Relapsed")
                .font(.system(size: 16, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .padding(.horizontal, 24)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Theme.surface)
                        
                        Theme.bubbleGradient
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
                    )
                )
                .foregroundStyle(.white.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.horizontal)
    }
}

#Preview {
    RelapseButton {
        print("Relapse button tapped")
    }
}
