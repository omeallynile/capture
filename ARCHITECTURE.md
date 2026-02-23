# Architectural Overview

## 1. Architectural Overview

### System Design
We follow a **MVVM + Services (Managers)** architecture.
-   **Models:** Pure data structures and SwiftData entities. They contain no business logic.
-   **Views:** Declarative SwiftUI views. They are dumb and only reflect the state provided by ViewModels.
-   **ViewModels:** Contain view-specific logic, transformation of data for display, and handle user intent. They communicate with Managers.
-   **Managers (Services):** Singleton-like actors or classes that handle system resources (Camera, Audio, Permissions, Persistence). They are the source of truth for system state.

**Data Flow:**
1.  **Hardware/System Events** (Camera input, Location) -> **Managers**
2.  **Managers** -> **ViewModels** (via Observation or Async Streams)
3.  **ViewModels** -> **Views** (State Binding)
4.  **User Action** -> **ViewModels** -> **Managers** -> **Models/Persistence**

### Key Design Patterns
-   **Observation:** heavily rely on the `@Observable` macro for ViewModels and Managers to drive UI updates efficiently.
-   **Actors:** Use `actor` for Managers (like `CameraManager`) to ensure thread safety when accessing shared resources or hardware.
-   **SwiftData:** Use `@Model` for persisting capture data. We use a single `ModelContainer` injected into the environment.
-   **Repository Pattern (Light):** While SwiftData handles much of this, we wrap complex queries or data operations in a `DataService` or extension on the ModelContext to keep ViewModels clean.

### Dependency Rationale
-   **SwiftUI & SwiftData:** Chosen for their modernity, performance, and first-party support.
-   **AVFoundation:** Essential for granular control over the camera and audio capture, which `UIImagePickerController` cannot provide.
-   **Vision Framework:** Native OCR and image analysis without external dependencies.
-   **No Third-Party Libraries:** We aim to stick to Apple's SDKs to minimize bloat and dependency hell.

---

## 2. Technical Onboarding

### Project Topology
-   `CaptureApp.swift`: App Entry Point. Sets up the ModelContainer.
-   **`Models/`**: SwiftData entities (`CaptureItem.swift`, `Tag.swift`).
-   **`Views/`**: SwiftUI Views, organized by feature (`Camera/`, `Gallery/`, `Settings/`).
-   **`ViewModels/`**: The brains of the views (`CameraViewModel.swift`).
-   **`Managers/`**: System interfaces (`CameraManager.swift`, `PermissionManager.swift`, `LocationManager.swift`).
-   **`Intents/`**: AppIntents for Shortcuts and Siri (`CaptureIntent.swift`).
-   **`Extensions/`**: Useful extensions on standard types.

### The "Golden Path" (Capture Flow)
1.  **App Launch:** `CaptureApp` initializes the `ModelContainer` and injects it.
2.  **View Load:** `CameraView` appears. It holds a `@State` of `CameraViewModel`.
3.  **Initialization:** `CameraViewModel` asks `PermissionManager` for camera access.
4.  **Session Start:** If granted, `CameraManager` (an `actor`) configures the `AVCaptureSession` and starts the preview stream.
5.  **User Action:** User taps the "Capture" button.
6.  **Capture:** `CameraViewModel` calls `await cameraManager.capturePhoto()`.
7.  **Processing:** The photo data is returned. The ViewModel creates a new `CaptureItem` model.
8.  **Persistence:** The `CaptureItem` is inserted into the `modelContext` and saved.
9.  **Feedback:** The UI shows a brief animation, and the new item appears in the Gallery (automatically, thanks to `@Query`).

### State Management & Side Effects
-   **Persistence:** All captures are saved to SwiftData. Changes to context automatically trigger UI updates via `@Query`.
-   **Side Effects:** Use `.task` modifier in SwiftUI for async work on view appearance.
-   **Error Handling:** Errors are propagated up from Managers to ViewModels, which expose user-friendly error states (e.g., alerts or toast messages).

---

## 3. Developer Guardrails

### Coding Standards
-   **Naming:** Clear and verbose. `capturePhoto()` is better than `snap()`.
-   **Access Control:** Default to `private`. Expose only what is necessary (`public` or `internal`).
-   **Grouping:** Use `// MARK: - Section Name` to organize code within files.

### Common Pitfalls (Don'ts)
-   **Don't use `DispatchQueue.main.async`**: Use `@MainActor` on the class or function instead.
-   **Don't put logic in Views**: If you have an `if-else` block handling data logic in a View, move it to the ViewModel.
-   **Don't force unwrap**: Avoid `!` unless it's a critical programmer error that *should* crash the app (e.g., missing bundle resources).
-   **Don't use Combine**: Unless you are bridging a legacy delegate to an async stream.
-   **Don't bloat Models**: Models are for data. Helper methods for formatting should go in Extensions or ViewModels.
