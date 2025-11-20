import SwiftUI
import Combine

struct PanicButton: View {
    var action: () -> Void
    
    @State private var isAnimating = false
    @State private var showShimmer = false
    
    // Static timer to ensure stability across view updates
    private static let shimmerTimer = Timer.publish(every: 4.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                // Icon Container with pulsing glow
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.25), Color.white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    
                    Image(systemName: "exclamationmark.shield.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: .white.opacity(0.6), radius: 4, x: 0, y: 0)
                }
                .padding(.leading, 16)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("NEED HELP?")
                        .font(.system(size: 11, weight: .bold))
                        .tracking(1.2)
                        .foregroundStyle(Color.white.opacity(0.8))
                    
                    Text("Panic Button")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                }
                .padding(.leading, 16)
                
                Spacer()
                
                // Trailing Arrow
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.white.opacity(0.9))
                }
                .padding(.trailing, 16)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 84)
            .background(
                ZStack {
                    // Main Gradient
                    LinearGradient(
                        colors: [
                            Color(red: 0.25, green: 0.1, blue: 0.85), // Deep Electric Purple
                            Color(red: 0.0, green: 0.75, blue: 0.95)   // Bright Cyan
                        ],
                        startPoint: isAnimating ? .topLeading : .bottomLeading,
                        endPoint: isAnimating ? .bottomTrailing : .topTrailing
                    )
                    
                    // Glassy Surface
                    LinearGradient(
                        colors: [.white.opacity(0.15), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    // Shimmer Effect
                    GeometryReader { geo in
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .clear,
                                        .white.opacity(0.5),
                                        .clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 80, height: geo.size.height * 3)
                            .rotationEffect(.degrees(25))
                            .offset(y: -geo.size.height) // Pull up to center vertically
                            .offset(x: showShimmer ? geo.size.width + 100 : -150)
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.6), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(
                color: Color(red: 0.1, green: 0.3, blue: 0.9).opacity(isAnimating ? 0.5 : 0.25),
                radius: isAnimating ? 20 : 10,
                x: 0,
                y: isAnimating ? 10 : 5
            )
            .scaleEffect(isAnimating ? 1.02 : 1.0)
        }
        .buttonStyle(HighEndButtonStyle())
        .onAppear {
            // Pulse animation
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
        .onReceive(Self.shimmerTimer) { _ in
            showShimmer = false
            withAnimation(.linear(duration: 1.5)) {
                showShimmer = true
            }
        }
    }
}

struct HighEndButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
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
