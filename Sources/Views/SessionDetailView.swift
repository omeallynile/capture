import SwiftUI
import SwiftData

struct SessionDetailView: View {
    @Bindable var session: CaptureSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Metadata
                HStack {
                    Label(session.launchOrigin, systemImage: "arrow.up.left.and.arrow.down.right")
                    Spacer()
                    Text(session.timestamp.formatted(date: .long, time: .shortened))
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

                // Text Note
                if !session.textNote.isEmpty {
                    Text(session.textNote)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                // Media Grid
                if !session.visualMedia.isEmpty {
                    Text("Visual Media")
                        .font(.headline)
                        .padding(.horizontal)

                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(session.visualMedia) { media in
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 150, height: 150)
                                    .overlay {
                                        Image(systemName: "photo")
                                            .font(.largeTitle)
                                            .foregroundStyle(.secondary)
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Audio
                if !session.audioRecords.isEmpty {
                    Text("Audio Records")
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(session.audioRecords) { record in
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.blue)
                            VStack(alignment: .leading) {
                                Text("Duration: \(record.duration.formatted())s")
                                Text(record.timestamp.formatted(date: .omitted, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }

                // Shazam
                if !session.shazamMatches.isEmpty {
                    Text("Music Identified")
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(session.shazamMatches) { match in
                        HStack {
                            Image(systemName: "music.note")
                                .padding()
                                .background(Color.blue.opacity(0.1), in: Circle())
                            VStack(alignment: .leading) {
                                Text(match.title)
                                    .bold()
                                Text(match.artist)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Tags
                if !session.smartTags.isEmpty {
                    Text("Smart Tags")
                        .font(.headline)
                        .padding(.horizontal)

                    FlowLayout(items: session.smartTags) { tag in
                        Text("#\(tag.name)")
                            .font(.caption)
                            .padding(8)
                            .background(Color.green.opacity(0.1), in: Capsule())
                            .foregroundStyle(.green)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Capture Details")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                ShareLink(item: session.textNote)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: CaptureSession.self, configurations: config)

    let session = CaptureSession(
        textNote: "Check wrecker pricing for part 3V0 035 020"
    )
    let tag1 = SmartTag(name: "Receipt")
    let tag2 = SmartTag(name: "Task")
    session.smartTags = [tag1, tag2]

    // Add mock audio
    let audio = AudioRecord(duration: 12.5)
    session.audioRecords = [audio]

    container.mainContext.insert(session)

    return NavigationStack {
        SessionDetailView(session: session)
    }
    .modelContainer(container)
}

// Simple FlowLayout helper for tags
struct FlowLayout<Item: Identifiable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content

    var body: some View {
        // Simple mock flow layout using LazyVGrid or just HStack/VStack combo
        // For POC, let's use a wrapping HGrid logic or just scroll horizontal if easier
        // But requested is "navigate through thoughts".
        // Let's use a simple lazy grid.
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
            ForEach(items) { item in
                content(item)
            }
        }
    }
}
