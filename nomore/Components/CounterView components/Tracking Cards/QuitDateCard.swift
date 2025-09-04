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
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Text(formattedQuitDate)
                        .font(.system(size: 25, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 110)
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .background(Theme.surface)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Theme.surfaceStroke, lineWidth: Theme.borderThickness)
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
