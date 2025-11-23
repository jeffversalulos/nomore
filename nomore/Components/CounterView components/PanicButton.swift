import SwiftUI
import Combine

struct PanicButton: View {
    var action: () -> Void
    
    @State private var isAnimating = false
    @State private var rotation: Double = 0
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon Container
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.0, green: 0.6, blue: 1.0), Color(red: 0.0, green: 0.8, blue: 1.0)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: Color(red: 0.0, green: 0.5, blue: 1.0).opacity(0.3), radius: 5, x: 0, y: 0)
                    
                    Image(systemName: "exclamationmark.shield.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.leading, 20)
                
                Text("Panic Button")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                // Trailing Arrow Circle
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                }
                .padding(.trailing, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .background(
                ZStack {
                    // Deep dark background
                    Color(red: 0.02, green: 0.05, blue: 0.1)
                    
                    // Dynamic fill gradient that rotates with the border lights
                    // It creates a subtle sheen connecting the two light points
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.0),
                            Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.09), // Peak 1
                            Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.0),
                            Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.0),
                            Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.09), // Peak 2 (opposite)
                            Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.0)
                        ]),
                        center: .center,
                        startAngle: .degrees(rotation),
                        endAngle: .degrees(rotation + 360)
                    )
                    .blur(radius: 6) // Blur to make it a soft internal glow
                    
                    // Subtle inner glow for depth
                    RadialGradient(
                        gradient: Gradient(colors: [Color(red: 0.1, green: 0.15, blue: 0.3).opacity(0.18), .clear]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 150
                    )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .overlay(
                // Static Border Base
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .overlay(
                // Dual Traveling Light Border
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .strokeBorder(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                .clear,
                                Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.04),
                                Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.34), // Light Point 1
                                Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.04),
                                .clear,
                                .clear,
                                Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.04),
                                Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.34), // Light Point 2 (Opposite)
                                Color(red: 0.0, green: 0.8, blue: 1.0).opacity(0.04),
                                .clear
                            ]),
                            center: .center,
                            startAngle: .degrees(rotation),
                            endAngle: .degrees(rotation + 360)
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: Color.black.opacity(0.24), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(HighEndButtonStyle())
        .onAppear {
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

struct HighEndButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .brightness(configuration.isPressed ? -0.05 : 0)
    }
}

#Preview {
    ZStack {
        Color(red: 0.05, green: 0.05, blue: 0.1).ignoresSafeArea()
        PanicButton {
            print("Panic tapped")
        }
        .padding()
    }
}
