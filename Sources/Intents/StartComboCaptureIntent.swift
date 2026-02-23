import AppIntents
import SwiftUI
import SwiftData

struct StartComboCaptureIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Capture"
    static var description = IntentDescription("Starts a quick capture session.")
    static var openAppWhenRun: Bool = true

    @Parameter(title: "Capture Mode")
    var captureMode: CaptureMode

    @Parameter(title: "Launch Origin")
    var origin: String

    init() {
        self.captureMode = .combo
        self.origin = "ActionButton"
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        // In a real app, we would inject the mode into the App State or ViewModel here.
        // For POC, we'll assume the App reads this intent's execution or a shared state.
        // A common pattern is using a Dependency or Environment value, or deep linking.
        // We'll use a Deep Link strategy: open URL "capture://start?mode=\(captureMode)&origin=\(origin)"

        // Wait, standard AppIntents don't easily pass data to the running app instance without a specific mechanism like `AppDependency` or `OpenURLIntent`.
        // But since `openAppWhenRun = true`, the app launches.
        // We can use `Dependency` injection if we set it up, but that's complex for a single file POC.
        // A simpler way for the POC is to assume the View checks for active intents or a shared singleton.

        // Let's use UserDefaults to signal the app for the POC, as it's robust and simple.
        UserDefaults.standard.set(captureMode.rawValue, forKey: "lastCaptureMode")
        UserDefaults.standard.set(origin, forKey: "lastLaunchOrigin")
        UserDefaults.standard.set(Date(), forKey: "lastLaunchTime")

        // Notify the app if it's running
        NotificationCenter.default.post(name: Notification.Name("TriggerCapture"), object: nil)

        return .result()
    }
}

enum CaptureMode: String, AppEnum {
    case combo
    case audio
    case photo

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Capture Mode"
    static var caseDisplayRepresentations: [CaptureMode : DisplayRepresentation] = [
        .combo: "Combo Capture",
        .audio: "Audio Only",
        .photo: "Photo Only"
    ]
}
