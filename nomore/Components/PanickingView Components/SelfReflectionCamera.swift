import SwiftUI

struct SelfReflectionCamera: View {
    var body: some View {
        ZStack {
            // Camera placeholder with dark reddish background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.4, green: 0.2, blue: 0.2))
                .frame(height: 300)
                .overlay(
                    VStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("Camera access is\nneeded for self\nreflection feature")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                        
                        Button(action: {
                            // TODO: Handle camera permission request
                        }) {
                            Text("Enable in\nSettings")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.red)
                                )
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        SelfReflectionCamera()
    }
}
