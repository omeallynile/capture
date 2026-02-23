# AI Agent Instructions for "Capture" (iOS / Swift)

## Role & Context
You are a Senior iOS Engineer tasked with scaffolding and building "Capture," a frictionless, multi-modal capture app. The human developer will be taking over this codebase, so prioritize readability, modularity, and comprehensive in-line documentation over clever, overly terse code.

## Architectural Rules
1. **Separation of Concerns:** Strictly adhere to the established folder structure (`Models`, `Views`, `Intents`, `Managers`). Do not put business logic or data processing inside SwiftUI Views.
2. **State Management:** Use modern observation (`@Observable`, `@State`, `@Environment`). Avoid Combine unless bridging legacy APIs.
3. **Concurrency:** Use modern Swift Concurrency (`async/await`, `Task`, `actors`) exclusively. Do not use completion handlers or `DispatchQueue` unless absolutely required by an older Apple framework.
4. **Access Control:** Default to `private` or `fileprivate` for properties and functions unless they strictly need to be exposed to other modules.

## Framework Constraints
1. **SwiftData:** - The app is Local-Only. Do not configure models for CloudKit (no need for all properties to be optional/defaulted if not logically required).
   - Keep models clean and relational.
2. **AVFoundation & Hardware:**
   - Always implement and check for system permissions (Camera, Microphone) before attempting to initialize capture sessions.
   - Fail gracefully. If a simulator or unsupported device lacks dual-camera support, provide a fallback rather than crashing.
3. **AppIntents:**
   - Design intents to be lightweight. They should trigger the app to open and pass the necessary launch context, rather than executing heavy media processing in the background.

## Formatting & Documentation
- **Breadcrumbs:** Whenever you implement a complex framework (like Vision OCR or AVFoundation buffering), leave a clear comment explaining *why* you chose that approach.
- **TODOs:** If a feature is mocked for the POC (e.g., NLP extraction), leave a `// TODO:` comment detailing exactly where the actual implementation should be injected later.
- **UI Code:** Break down massive SwiftUI `body` properties into smaller, private computed properties or sub-views. Keep the main view body highly scannable.