import AppIntents

struct CaptureShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartComboCaptureIntent(),
            phrases: [
                "Start \(.applicationName) Capture",
                "Capture Quick Note",
                "Combo Capture"
            ],
            shortTitle: "Quick Capture",
            systemImageName: "camera.shutter.button"
        )
    }
}
