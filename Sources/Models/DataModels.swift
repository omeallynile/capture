import Foundation
import SwiftData
import CoreLocation

@Model
final class CaptureSession {
    var id: UUID
    var timestamp: Date
    var launchOrigin: String // "AppIcon", "ActionButton", "Widget", "Siri"
    var textNote: String

    // Relationships
    @Relationship(deleteRule: .cascade) var audioRecords: [AudioRecord] = []
    @Relationship(deleteRule: .cascade) var visualMedia: [VisualMedia] = []
    @Relationship(deleteRule: .cascade) var shazamMatches: [ShazamMatch] = []
    @Relationship(deleteRule: .cascade) var smartTags: [SmartTag] = []

    init(id: UUID = UUID(), timestamp: Date = Date(), launchOrigin: String = "AppIcon", textNote: String = "") {
        self.id = id
        self.timestamp = timestamp
        self.launchOrigin = launchOrigin
        self.textNote = textNote
    }
}

@Model
final class AudioRecord {
    var id: UUID
    var timestamp: Date
    var duration: TimeInterval
    var fileURL: URL? // Local file URL

    // Inverse Relationship
    var session: CaptureSession?

    init(id: UUID = UUID(), timestamp: Date = Date(), duration: TimeInterval = 0, fileURL: URL? = nil) {
        self.id = id
        self.timestamp = timestamp
        self.duration = duration
        self.fileURL = fileURL
    }
}

@Model
final class VisualMedia {
    var id: UUID
    var timestamp: Date
    var type: String // "Photo", "Video"
    var fileURL: URL? // Local file URL

    // Inverse Relationship
    var session: CaptureSession?

    init(id: UUID = UUID(), timestamp: Date = Date(), type: String = "Photo", fileURL: URL? = nil) {
        self.id = id
        self.timestamp = timestamp
        self.type = type
        self.fileURL = fileURL
    }
}

@Model
final class ShazamMatch {
    var id: UUID
    var timestamp: Date
    var title: String
    var artist: String
    var artworkURL: URL?

    // Inverse Relationship
    var session: CaptureSession?

    init(id: UUID = UUID(), timestamp: Date = Date(), title: String = "", artist: String = "", artworkURL: URL? = nil) {
        self.id = id
        self.timestamp = timestamp
        self.title = title
        self.artist = artist
        self.artworkURL = artworkURL
    }
}

@Model
final class SmartTag {
    var id: UUID
    var name: String
    var confidence: Double

    // Inverse Relationship
    var session: CaptureSession?

    init(id: UUID = UUID(), name: String, confidence: Double = 1.0) {
        self.id = id
        self.name = name
        self.confidence = confidence
    }
}

@Model
final class LaunchPreferences {
    var id: String // Singleton ID "Main"
    var defaultToComboCapture: Bool
    var autoStartAudio: Bool
    var autoStartCamera: Bool
    var autoStartShazam: Bool

    init(defaultToComboCapture: Bool = true, autoStartAudio: Bool = true, autoStartCamera: Bool = true, autoStartShazam: Bool = true) {
        self.id = "Main"
        self.defaultToComboCapture = defaultToComboCapture
        self.autoStartAudio = autoStartAudio
        self.autoStartCamera = autoStartCamera
        self.autoStartShazam = autoStartShazam
    }
}
