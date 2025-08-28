import SwiftUI

struct BrainRewiringProgressBar: View {
    let progress: Double // 0.0 to 1.0 representing progress toward 100 days
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Brain Rewiring")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
            
            // Progress bar container
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.white.opacity(0.15))
                        .frame(height: 8)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Theme.aqua, Theme.mint],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geometry.size.width * progress), height: 8)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: 8)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(.white.opacity(0.05))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.1), lineWidth: 0.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
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
