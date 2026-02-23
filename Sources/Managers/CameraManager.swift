import SwiftUI
import Observation

@Observable
class CameraManager {
    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }

    var status: Status = .unconfigured
    var viewfinderImage: Image?

    // Simulation properties
    private var isRunning = false

    init() {
        // Automatically configure on init for this POC
        configure()
    }

    func configure() {
        // Simulate checking permissions
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s delay
            self.status = .configured
            self.startSession()
        }
    }

    func startSession() {
        guard status == .configured else { return }
        isRunning = true
        // Simulate a camera feed
        simulateCameraFeed()
    }

    func stopSession() {
        isRunning = false
    }

    func takePhoto() async -> Data? {
        // Return a mock JPEG
        return Data() // Empty data for POC
    }

    private func simulateCameraFeed() {
        Task {
            while isRunning {
                // In a real app, this would be a CVPixelBuffer converted to Image
                // Here we just toggle or update something to simulate liveness if needed
                // For now, we set a static placeholder if not set
                if viewfinderImage == nil {
                    await MainActor.run {
                        self.viewfinderImage = Image(systemName: "camera.viewfinder")
                    }
                }
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1s
            }
        }
    }
}
