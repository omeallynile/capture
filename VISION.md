# Vision & Intent

## 1. The Core Vision

### The "Problem" Statement
Modern capture tools often suffer from feature bloat, cloud dependency, and privacy concerns. Users need a **frictionless, multi-modal capture app** that launches instantly, respects their data privacy by staying **local-only**, and allows for the seamless collection of ideas, images, and audio without the overhead of account creation or network latency.

### Guiding Principles

1.  **Local-First & Privacy-Centric:**
    -   **Non-negotiable:** No cloud sync, no analytics, no third-party SDKs that track users.
    -   All data (media, metadata, text) lives in `SwiftData` on the device.
    -   Permissions (Camera, Microphone) are requested transparently and only when needed.

2.  **Performance & Responsiveness:**
    -   **Speed over bells and whistles.** The app must be ready to capture within milliseconds of launch.
    -   Heavy processing (OCR, transcribing) happens asynchronously without blocking the UI.
    -   We use `async/await` and `Actors` to manage concurrency safely and efficiently.

3.  **Modern Swift Architecture:**
    -   **Zero Legacy Debt:** We use `@Observable`, SwiftUI, and SwiftData.
    -   **No Combine** (unless bridging legacy APIs).
    -   **No Completion Handlers**.
    -   Strong typing and value types are preferred over reference types where possible.

4.  **Simplicity & Maintainability:**
    -   Code is read more often than it is written.
    -   We prioritize clear, self-documenting code with "breadcrumbs" (comments explaining *why*, not just *what*).
    -   Modular design allows features (like a new capture mode) to be added without rewriting the core loop.

### Target State (v1.0)
A robust iOS application that:
-   [ ] Opens directly to a camera/capture interface.
-   [ ] Supports **Photo**, **Video**, and **Text** capture modes.
-   [ ] Persists all captures to a local SwiftData store.
-   [ ] Allows viewing and basic management of captured items.
-   [ ] Handles all permissions gracefully.
-   [ ] Demonstrates a stable, crash-free experience even in edge cases (e.g., no camera permissions).
