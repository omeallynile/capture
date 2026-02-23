import SwiftUI
import SwiftData

struct CaptureCardView: View {
    let session: CaptureSession

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(session.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                // Origin Badge
                Text(session.launchOrigin)
                    .font(.caption2)
                    .padding(4)
                    .background(Color.secondary.opacity(0.1), in: Capsule())
            }

            if !session.textNote.isEmpty {
                Text(session.textNote)
                    .font(.body)
                    .lineLimit(3)
            } else {
                Text("No text note")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .italic()
            }

            // Media Badges
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if !session.audioRecords.isEmpty {
                        Label("\(session.audioRecords.count)", systemImage: "mic.fill")
                            .font(.caption)
                            .padding(6)
                            .background(Color.red.opacity(0.1), in: Capsule())
                            .foregroundStyle(.red)
                    }

                    if !session.visualMedia.isEmpty {
                        Label("\(session.visualMedia.count)", systemImage: "photo.fill")
                            .font(.caption)
                            .padding(6)
                            .background(Color.blue.opacity(0.1), in: Capsule())
                            .foregroundStyle(.blue)
                    }

                    if !session.shazamMatches.isEmpty {
                        ForEach(session.shazamMatches) { match in
                            Label(match.title, systemImage: "shazam.logo.fill")
                                .font(.caption)
                                .padding(6)
                                .background(Color.blue.opacity(0.1), in: Capsule())
                                .foregroundStyle(.blue)
                        }
                    }

                    ForEach(session.smartTags) { tag in
                        Text("#\(tag.name)")
                            .font(.caption)
                            .padding(6)
                            .background(Color.green.opacity(0.1), in: Capsule())
                            .foregroundStyle(.green)
                    }
                }
            }

            Divider()

            HStack {
                Spacer()
                // Share Link
                ShareLink(item: session.textNote) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .labelStyle(.iconOnly)
                .foregroundStyle(.blue)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
