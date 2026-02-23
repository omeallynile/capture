import SwiftUI
import SwiftData
import Observation

struct CaptureView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel = CaptureViewModel()
    @FocusState private var isNoteFocused: Bool

    @State private var cameraStyle: CameraPreviewStyle = .pip

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header Area (could be empty or show status)
                    HStack {
                        if viewModel.isShazamActive {
                            HStack {
                                Image(systemName: "shazam.logo.fill")
                                    .symbolEffect(.pulse)
                                Text("Listening...")
                                    .font(.caption)
                            }
                            .foregroundStyle(.blue)
                            .padding(.horizontal)
                            .background(.ultraThinMaterial, in: Capsule())
                        }
                        Spacer()

                        Picker("View Style", selection: $cameraStyle) {
                            Text("PIP").tag(CameraPreviewStyle.pip)
                            Text("Tile").tag(CameraPreviewStyle.tile)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 120)
                    }
                    .padding()

                    // Main Content Area
                    if cameraStyle == .tile {
                        HStack(spacing: 0) {
                            // Text Area (Left/Top)
                            TextEditor(text: $viewModel.textNote)
                                .focused($isNoteFocused)
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)

                            // Camera Area (Right/Bottom)
                            CameraPreview(manager: viewModel.cameraManager, style: .tile)
                                .frame(width: 150)
                                .padding(8)
                        }
                    } else {
                        // PIP Style: Text fills screen, Camera floats
                        ZStack(alignment: .topTrailing) {
                            TextEditor(text: $viewModel.textNote)
                                .focused($isNoteFocused)
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)

                            CameraPreview(manager: viewModel.cameraManager, style: .pip)
                                .frame(width: 120, height: 160)
                                .padding()
                                .opacity(viewModel.isCameraActive ? 1 : 0)
                                .animation(.easeInOut, value: viewModel.isCameraActive)
                        }
                    }

                    // Bottom Control Bar
                    VStack(spacing: 12) {
                        // Audio Feedback
                        if viewModel.isRecording {
                            HStack {
                                Image(systemName: "mic.fill")
                                    .foregroundStyle(.red)
                                Text(timeString(from: viewModel.audioManager.recordingDuration))
                                    .monospacedDigit()
                                Spacer()
                                AudioVisualizerView(powerLevel: viewModel.audioManager.powerLevel)
                                    .frame(width: 100, height: 30)
                            }
                            .padding(.horizontal)
                        }

                        Divider()

                        HStack {
                            // Keep Recording Toggle
                            Toggle(isOn: $viewModel.isKeepRecordingActive) {
                                Label("Keep Recording", systemImage: "infinity")
                                    .font(.caption)
                            }
                            .toggleStyle(.button)
                            .tint(.orange)
                            .onChange(of: viewModel.isKeepRecordingActive) { _, newValue in
                                viewModel.toggleKeepRecording()
                            }

                            Spacer()

                            // Save Button
                            Button(action: {
                                Task {
                                    await viewModel.saveSession(context: modelContext)
                                    dismiss()
                                }
                            }) {
                                Text("Save")
                                    .bold()
                                    .frame(minWidth: 80)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                    .background(.bar)
                }
            }
            .navigationTitle("Quick Capture")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.stopComboCapture()
                        dismiss()
                    }
                }
            }
            .onAppear {
                // Check if launched via Intent (Mock check)
                if let mode = UserDefaults.standard.string(forKey: "lastCaptureMode"),
                   let origin = UserDefaults.standard.string(forKey: "lastLaunchOrigin") {
                    // Consume the intent
                    UserDefaults.standard.removeObject(forKey: "lastCaptureMode")
                    viewModel.startComboCapture(origin: origin, mode: mode)
                } else {
                    // Default behavior
                    viewModel.startComboCapture()
                }

                // Focus text field
                isNoteFocused = true
            }
            .onDisappear {
                viewModel.stopComboCapture()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("TriggerCapture"))) { _ in
                // Check defaults again
                if let origin = UserDefaults.standard.string(forKey: "lastLaunchOrigin") {
                    let mode = UserDefaults.standard.string(forKey: "lastCaptureMode") ?? "combo"
                    UserDefaults.standard.removeObject(forKey: "lastCaptureMode")
                    viewModel.startComboCapture(origin: origin, mode: mode)
                    // Ensure focus
                    isNoteFocused = true
                }
            }
        }
    }

    func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval) % 60
        let minutes = (Int(timeInterval) / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    CaptureView()
        .modelContainer(for: CaptureSession.self, inMemory: true)
}
