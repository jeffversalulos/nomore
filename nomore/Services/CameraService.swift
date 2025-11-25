import AVFoundation
import SwiftUI

/// Manages camera session and permission handling for the self-reflection camera feature.
/// This service handles AVCaptureSession setup and provides the preview layer.
final class CameraService: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var permissionStatus: AVAuthorizationStatus = .notDetermined
    @Published var isSessionRunning = false
    @Published var error: CameraError?
    
    // MARK: - Camera Session
    
    let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "com.nomore.camera.session")
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        checkPermissionStatus()
    }
    
    // MARK: - Permission Handling
    
    /// Checks the current camera permission status
    func checkPermissionStatus() {
        permissionStatus = AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    /// Requests camera permission from the user
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.permissionStatus = granted ? .authorized : .denied
                if granted {
                    self?.setupCaptureSession()
                }
            }
        }
    }
    
    /// Opens the app's settings page so user can enable camera permission
    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    // MARK: - Session Management
    
    /// Sets up the capture session with the front camera
    func setupCaptureSession() {
        sessionQueue.async { [weak self] in
            self?.configureSession()
        }
    }
    
    private func configureSession() {
        guard permissionStatus == .authorized else { return }
        
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        
        // Get front camera
        guard let frontCamera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front
        ) else {
            DispatchQueue.main.async {
                self.error = .cameraUnavailable
            }
            captureSession.commitConfiguration()
            return
        }
        
        // Create and add input
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            } else {
                DispatchQueue.main.async {
                    self.error = .cannotAddInput
                }
                captureSession.commitConfiguration()
                return
            }
        } catch {
            DispatchQueue.main.async {
                self.error = .cannotAddInput
            }
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.commitConfiguration()
        startSession()
    }
    
    /// Starts the capture session
    func startSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = true
                }
            }
        }
    }
    
    /// Stops the capture session
    func stopSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = false
                }
            }
        }
    }
}

// MARK: - Camera Errors

enum CameraError: LocalizedError {
    case cameraUnavailable
    case cannotAddInput
    
    var errorDescription: String? {
        switch self {
        case .cameraUnavailable:
            return "Front camera is not available on this device."
        case .cannotAddInput:
            return "Unable to configure camera input."
        }
    }
}

