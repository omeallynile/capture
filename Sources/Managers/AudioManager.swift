import SwiftUI
import Observation
import AVFoundation

@Observable
class AudioManager {
    enum Status {
        case idle
        case recording
        case paused
        case failed
    }

    var status: Status = .idle
    var powerLevel: Float = 0.0 // 0.0 to 1.0
    var recordingDuration: TimeInterval = 0

    private var timer: Timer?

    // Simulate audio power levels for the visualizer
    func startRecording() {
        guard status != .recording else { return }

        status = .recording
        recordingDuration = 0

        // Simulate level metering
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordingDuration += 0.1
            // Random power level between 0.1 and 0.8
            self.powerLevel = Float.random(in: 0.1...0.8)
        }
    }

    func stopRecording() -> URL? {
        timer?.invalidate()
        timer = nil
        status = .idle
        powerLevel = 0.0

        // Return a mock file URL
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent("mock_audio_recording_\(UUID().uuidString).m4a")
        return fileURL
    }

    func pauseRecording() {
        timer?.invalidate()
        status = .paused
    }

    func requestPermission() async -> Bool {
        // Mock permission grant
        try? await Task.sleep(nanoseconds: 200_000_000)
        return true
    }
}
