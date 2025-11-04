import SwiftUI

struct StreakModal: View {
    @EnvironmentObject var appStreakStore: AppStreakStore
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
                            let streak = appStreakStore.consecutiveDaysStreak
                            
                            // Main streak count
                            Text("\(streak) Day Streak")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(Theme.textPrimary)
                            
                            // Streak explanation
                            Text("Consecutive days you've opened ANEW")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            // Motivational message
                            Text("Gain a streak for every consecutive day you login to ANEW.")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
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
                                .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
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
    let dailyUsageStore = DailyUsageStore()
    let appStreakStore = AppStreakStore(dailyUsageStore: dailyUsageStore)
    
    return StreakModal(isPresented: .constant(true))
        .environmentObject(appStreakStore)
        .appBackground()
}
