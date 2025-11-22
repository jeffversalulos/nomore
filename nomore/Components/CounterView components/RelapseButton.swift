import SwiftUI

struct RelapseButton: View {
    let action: () -> Void
    
    @State private var rotation: Double = 0
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 12) {
                // Centered Content
                Spacer()
                
                // Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.7, green: 0.2, blue: 0.2), // Muted Red
                                    Color(red: 0.5, green: 0.1, blue: 0.1)  // Darker Muted Red
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36) // Slightly smaller icon
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        .shadow(color: Color(red: 0.6, green: 0.1, blue: 0.1).opacity(0.3), radius: 6, x: 0, y: 0)
                    
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 16, weight: .bold)) // Smaller icon size
                        .foregroundStyle(.white.opacity(0.9))
                }
                
                Text("I Relapsed")
                    .font(.system(size: 18, weight: .bold)) // Slightly smaller text
                    .foregroundStyle(.white.opacity(0.95))
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 64) // Reduced height
            .background(
                ZStack {
                    // Deep dark background with very subtle reddish tint
                    Color(red: 0.08, green: 0.04, blue: 0.04)
                    
                    // Subtle inner glow
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.red.opacity(0.08),
                            .clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 200
                    )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous)) // Slightly smaller corner radius
            .overlay(
                // Static Border
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
            .overlay(
                // Very faint traveling light border
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                Color.red.opacity(0.05),
                                Color.red.opacity(0.25), // Reduced peak opacity
                                Color.red.opacity(0.05),
                                .clear,
                                .clear,
                                Color.red.opacity(0.05),
                                Color.red.opacity(0.25), // Reduced peak opacity
                                Color.red.opacity(0.05),
                                .clear
                            ]),
                            center: .center,
                            startAngle: .degrees(rotation),
                            endAngle: .degrees(rotation + 360)
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(RelapseButtonStyle())
        .onAppear {
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
        .padding(.horizontal)
    }
}

struct RelapseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .brightness(configuration.isPressed ? -0.05 : 0)
    }
}

#Preview {
    ZStack {
        Theme.backgroundGradient.ignoresSafeArea()
        RelapseButton {
            print("Relapse button tapped")
        }
    }
}
