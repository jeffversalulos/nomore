import SwiftUI

struct SideEffectsSection: View {
    let sideEffects = [
        SideEffect(icon: "chart.line.downtrend.xyaxis", title: "REDUCED PERFORMANCE", description: "Your cognitive abilities and focus will decline"),
        SideEffect(icon: "brain.head.profile", title: "BRAIN FOG", description: "Mental clarity and decision-making become impaired"),
        SideEffect(icon: "heart.slash", title: "DECREASED MOTIVATION", description: "Loss of drive and enthusiasm for goals"),
        SideEffect(icon: "moon.zzz", title: "DISRUPTED SLEEP", description: "Poor sleep quality and irregular sleep patterns"),
        SideEffect(icon: "person.crop.circle.badge.minus", title: "SOCIAL ISOLATION", description: "Withdrawal from relationships and social activities"),
        SideEffect(icon: "exclamationmark.triangle", title: "INCREASED ANXIETY", description: "Heightened stress and worry about the future"),
        SideEffect(icon: "arrow.down.circle", title: "LOWERED SELF-ESTEEM", description: "Negative self-talk and feelings of failure"),
        SideEffect(icon: "clock.arrow.circlepath", title: "WASTED TIME", description: "Hours that could be spent on meaningful activities")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Side effects of Relapsing:")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            LazyVStack(spacing: 12) {
                ForEach(sideEffects, id: \.title) { effect in
                    SideEffectRow(sideEffect: effect)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct SideEffect {
    let icon: String
    let title: String
    let description: String
}

struct SideEffectRow: View {
    let sideEffect: SideEffect
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: sideEffect.icon)
                .font(.system(size: 20))
                .foregroundColor(.red)
                .frame(width: 30, height: 30)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(sideEffect.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(sideEffect.description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(nil)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        ScrollView {
            SideEffectsSection()
        }
    }
}
