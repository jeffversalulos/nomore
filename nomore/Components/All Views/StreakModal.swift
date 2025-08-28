import SwiftUI

struct StreakModal: View {
    @EnvironmentObject var streakStore: StreakStore
    @Binding var isPresented: Bool
    @State private var now: Date = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            // Modal content - centered
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    // Close button
                    HStack {
                        Spacer()
                        Button {
                            isPresented = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(Theme.textSecondary)
                                .padding(8)
                                .background(Theme.surface)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Centered content area
                    VStack(spacing: 32) {
                        // Fire icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.orange.opacity(0.8), Color.red.opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 140, height: 140)
                                .overlay(
                                    Circle()
                                        .stroke(Color.orange.opacity(0.3), lineWidth: 2)
                                )
                            
                            Image(systemName: "flame.fill")
                                .font(.system(size: 60, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .softShadow()
                        
                        // Streak information
                        VStack(spacing: 16) {
                            let components = calculateTimeComponents(from: streakStore.lastRelapseDate, to: now)
                            
                            // Main streak count
                            Text("\(components.days) Day Streak")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(Theme.textPrimary)
                            
                            // Detailed time breakdown
                            if components.hours > 0 || components.minutes > 0 || components.seconds > 0 {
                                Text("\(components.hours)h \(components.minutes)m \(components.seconds)s")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(Theme.textSecondary)
                            }
                            
                            // Motivational message
                            Text("Gain a streak for every consecutive day you login to QUITTR.")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundStyle(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(32)
                .frame(width: UIScreen.main.bounds.width - 40, height: 500)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Theme.surfaceTwo)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(Theme.surfaceStroke, lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .softShadow()
                
                Spacer()
            }
        }
        .onReceive(timer) { value in
            withAnimation(.easeInOut(duration: 0.3)) {
                now = value
            }
        }
    }
}

#Preview {
    @State var isPresented = true
    let store = StreakStore()
    
    return StreakModal(isPresented: .constant(true))
        .environmentObject(store)
        .appBackground()
}
