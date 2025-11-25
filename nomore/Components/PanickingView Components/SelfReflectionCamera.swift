import SwiftUI
import AVFoundation

struct SelfReflectionCamera: View {
    @StateObject private var cameraService = CameraService()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.15, green: 0.1, blue: 0.1))
                .frame(height: 300)
                .overlay(
                    cameraContent
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
        .padding(.horizontal, 20)
        .onAppear {
            handleOnAppear()
        }
        .onDisappear {
            cameraService.stopSession()
        }
    }
    
    // MARK: - Content Based on Permission Status
    
    @ViewBuilder
    private var cameraContent: some View {
        switch cameraService.permissionStatus {
        case .authorized:
            // Show live camera preview
            CameraPreviewView(session: cameraService.captureSession)
            
        case .notDetermined:
            // Request permission UI
            permissionRequestView
            
        case .denied, .restricted:
            // Denied - show settings link
            permissionDeniedView
            
        @unknown default:
            permissionRequestView
        }
    }
    
    // MARK: - Permission Request View
    
    private var permissionRequestView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.6))
            
            Text("Camera access needed\nfor self-reflection")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button(action: {
                cameraService.requestPermission()
            }) {
                Text("Enable Camera")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red)
                    )
            }
        }
    }
    
    // MARK: - Permission Denied View
    
    private var permissionDeniedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.6))
            
            Text("Camera access was denied.\nEnable it in Settings to use\nthe self-reflection feature.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button(action: {
                cameraService.openSettings()
            }) {
                Text("Open Settings")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red)
                    )
            }
        }
    }
    
    // MARK: - Lifecycle Handling
    
    private func handleOnAppear() {
        cameraService.checkPermissionStatus()
        
        if cameraService.permissionStatus == .authorized {
            cameraService.setupCaptureSession()
        }
    }
}

#Preview {
    ZStack {
        Color.black
            .ignoresSafeArea()
        
        SelfReflectionCamera()
    }
}
