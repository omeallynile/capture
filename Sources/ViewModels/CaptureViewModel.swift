import SwiftUI
import SwiftData
import Observation
import AVFoundation

@Observable
class CaptureViewModel {
    // Dependencies
    var cameraManager = CameraManager()
    var audioManager = AudioManager()
    var shazamManager = ShazamManager()
    var aiManager = AIProcessingManager()

    // State
    var textNote: String = ""
    var isRecording: Bool = false
    var isCameraActive: Bool = false
    var isShazamActive: Bool = false
    var isKeepRecordingActive: Bool = false

    // Captured Data
    var capturedImage: Data?
    var audioDuration: TimeInterval = 0
    var matchedSong: ShazamManager.MatchedTrack?

    // Configuration
    var launchOrigin: String = "AppIcon"
    var captureMode: String = "combo"

    init() {
        // Initialize managers
        // In a real app, we might configure them based on settings
    }

    func startComboCapture(origin: String = "AppIcon", mode: String = "combo") {
        self.launchOrigin = origin
        self.captureMode = mode

        // Determine active sensors based on mode
        let startAudio = mode == "combo" || mode == "audio"
        let startCamera = mode == "combo" || mode == "photo"
        let startShazam = mode == "combo" // Assume Shazam is part of combo only for now

        if startCamera {
            isCameraActive = true
            cameraManager.startSession()
        }

        if startAudio {
            isRecording = true
            audioManager.startRecording()
        }

        if startShazam {
            isShazamActive = true
            shazamManager.startListening()
        }
    }

    func stopComboCapture() {
        // Stop all sensors
        isRecording = false
        audioManager.stopRecording()

        isCameraActive = false
        cameraManager.stopSession()

        isShazamActive = false
        shazamManager.stopListening()
    }

    func toggleKeepRecording() {
        isKeepRecordingActive.toggle()
        if !isKeepRecordingActive && !isRecording {
            // If we toggled off and were only keeping recording alive because of it, stop now.
            // But logic is usually: "Keep Recording" extends the session beyond the default "quick capture"
            // So if user toggles it OFF, we might stop if other conditions are met.
            // For now, let's just update the state.
        }
    }

    @MainActor
    func saveSession(context: ModelContext) async {
        // Create the session
        let session = CaptureSession(
            timestamp: Date(),
            launchOrigin: launchOrigin,
            textNote: textNote
        )

        // Add Audio
        if audioManager.recordingDuration > 0 {
            // In a real app, we would move the file from temp to Documents
            // For POC, we just create the record
            let record = AudioRecord(
                timestamp: Date(),
                duration: audioManager.recordingDuration,
                fileURL: nil // Mock
            )
            session.audioRecords.append(record)
        }

        // Add Photo (if we took one, or capture current frame)
        // For POC, let's assume we capture a frame on save or have one ready
        if let _ = cameraManager.viewfinderImage {
             // Mock saving visual media
            let media = VisualMedia(
                timestamp: Date(),
                type: "Photo",
                fileURL: nil // Mock
            )
            session.visualMedia.append(media)
        }

        // Add Shazam
        if let match = shazamManager.matchedTrack {
            let shazam = ShazamMatch(
                timestamp: Date(),
                title: match.title,
                artist: match.artist,
                artworkURL: match.artworkURL
            )
            session.shazamMatches.append(shazam)
        }

        // AI Processing
        let tags = await aiManager.analyzeText(textNote)
        for tag in tags {
            let smartTag = SmartTag(name: tag, confidence: 0.9)
            session.smartTags.append(smartTag)
        }

        // Insert into Context
        context.insert(session)

        // Reset state for next capture? Or dismiss view?
        // Usually dismiss.
    }
}
