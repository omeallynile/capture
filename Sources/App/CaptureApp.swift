import SwiftUI
import SwiftData

@main
struct CaptureApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CaptureSession.self,
            AudioRecord.self,
            VisualMedia.self,
            ShazamMatch.self,
            SmartTag.self,
            LaunchPreferences.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    handleDeepLink(url)
                }
        }
        .modelContainer(sharedModelContainer)
    }

    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "capture" else { return }

        // Simple URL parsing
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let mode = components?.queryItems?.first(where: { $0.name == "mode" })?.value ?? "combo"

        // Signal the app via UserDefaults for simplicity in this POC
        // In a real app, we would inject this into the environment or a singleton manager
        UserDefaults.standard.set(mode, forKey: "lastCaptureMode")
        UserDefaults.standard.set("Widget", forKey: "lastLaunchOrigin")

        // Force a notification or update if the view is already loaded
        // Since CaptureView checks onAppear, this works if the app was cold.
        // If the app is warm, we might need a more reactive approach.
        // For POC, we rely on the View checking or re-checking.
        // A better way is posting a Notification.
        NotificationCenter.default.post(name: Notification.Name("TriggerCapture"), object: nil)
    }
}
