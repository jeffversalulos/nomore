import SwiftUI

struct BrainRewiringProgressBar: View {
    let progress: Double // 0.0 to 1.0 representing progress toward 100 days
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with Icon, Label and Percentage
            HStack(alignment: .center) {
                HStack(spacing: 12) {
                    // Icon Container
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Theme.purple.opacity(0.5))
                            .frame(width: 32, height: 32)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            )
                        
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 14))
                            .foregroundStyle(Color(red: 0.8, green: 0.6, blue: 1.0)) // Light lilac
                    }
                    
                    Text("REWIRING")
                        .font(.system(size: 12, weight: .bold))
                        .tracking(1.5)
                        .foregroundStyle(Color.white.opacity(0.9))
                }
                
                Spacer()
                
                // Percentage Text with Gradient
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.8, green: 0.6, blue: 1.0), // Light lilac
                                Color(red: 0.9, green: 0.7, blue: 0.9)  // Soft pink
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: Theme.accent.opacity(0.3), radius: 8, x: 0, y: 0)
            }
            
            Text("Brain Healing")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, -4)
            
            // Progress bar container
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .frame(height: 12)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Theme.accent, // Purple
                                    Color(red: 0.9, green: 0.6, blue: 0.9) // Pinkish
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geometry.size.width * progress), height: 12)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                        // Glow effect
                        .shadow(color: Theme.accent.opacity(0.5), radius: 8, x: 0, y: 0)
                }
            }
            .frame(height: 12)
        }
        .padding(24)
        .background(
            ZStack {
                // Deep rich background base - using a very dark purple/black
                Color(red: 0.03, green: 0.02, blue: 0.08)
                
                // Dynamic fill gradient that rotates
                AngularGradient(
                    gradient: Gradient(colors: [
                        Theme.purple.opacity(0.0),
                        Theme.purple.opacity(0.2), // Peak 1
                        Theme.purple.opacity(0.0),
                        Theme.purple.opacity(0.0),
                        Theme.accent.opacity(0.15), // Peak 2
                        Theme.purple.opacity(0.0)
                    ]),
                    center: .center,
                    startAngle: .degrees(rotation),
                    endAngle: .degrees(rotation + 360)
                )
                .blur(radius: 20)
                
                // Subtle inner glow for depth
                RadialGradient(
                    gradient: Gradient(colors: [
                        Theme.indigo.opacity(0.3),
                        Color.clear
                    ]),
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: 400
                )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            // Static Border for Definition (Glass Effect)
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.5), radius: 15, x: 0, y: 8)
        .onAppear {
            withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        BrainRewiringProgressBar(progress: 0.01)
        BrainRewiringProgressBar(progress: 0.25)
        BrainRewiringProgressBar(progress: 0.75)
        BrainRewiringProgressBar(progress: 1.0)
    }
    .padding()
    .background(Theme.backgroundGradient)
}
