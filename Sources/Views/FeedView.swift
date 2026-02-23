import SwiftUI
import SwiftData

struct FeedView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CaptureSession.timestamp, order: .reverse) private var sessions: [CaptureSession]
    @State private var showingCapture = false

    var body: some View {
        List {
            ForEach(sessions) { session in
                ZStack {
                    CaptureCardView(session: session)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 16)
                    NavigationLink(destination: SessionDetailView(session: session)) {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: deleteSessions)
        }
        .listStyle(.plain)
        .navigationTitle("Feed")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingCapture = true
                } label: {
                    Label("Capture", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCapture) {
            CaptureView()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("TriggerCapture"))) { _ in
            showingCapture = true
        }
        .overlay {
            if sessions.isEmpty {
                ContentUnavailableView(
                    "No Captures Yet",
                    systemImage: "camera.aperture",
                    description: Text("Tap + to start capturing moments.")
                )
            }
        }
    }

    private func deleteSessions(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(sessions[index])
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: CaptureSession.self, configurations: config)

    // Add Mock Data
    let session = CaptureSession(
        textNote: "Check wrecker pricing for part 3V0 035 020"
    )
    let tag1 = SmartTag(name: "Receipt")
    let tag2 = SmartTag(name: "Task")
    session.smartTags = [tag1, tag2]

    container.mainContext.insert(session)

    return NavigationStack {
        FeedView()
    }
    .modelContainer(container)
}
