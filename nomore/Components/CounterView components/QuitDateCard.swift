import SwiftUI

struct QuitDateCard: View {
    let startDate: Date
    
    private var quitDate: Date {
        Calendar.current.date(byAdding: .day, value: 90, to: startDate) ?? Date()
    }
    
    private var formattedQuitDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: quitDate)
    }
    
    var body: some View {
        ZStack {
            // Main card content
            VStack(spacing: 16) {
                // Spacer to push content down for the icon
                Spacer(minLength: 24)
                
                VStack(spacing: 8) {
                    Text("You're on track to quit by:")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                    
                    Text(formattedQuitDate)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 110)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.white.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.white.opacity(0.15), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            // Icon positioned on top border
            VStack {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.black)
                }
                .offset(y: -24)
                
                Spacer()
            }
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        QuitDateCard(startDate: Date())
        QuitDateCard(startDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date())
    }
    .padding()
    .background(Theme.backgroundGradient)
}
