import Foundation
import Observation
import ShazamKit

@Observable
class ShazamManager {
    enum Status {
        case idle
        case listening
        case matching
        case matched
        case failed
    }

    var status: Status = .idle
    var currentMatch: SHMatch?

    // We can't easily mock SHMatch properly without valid audio data,
    // so we'll use a simpler struct or just rely on the mock logic.
    // For POC, we'll expose a custom `MatchedTrack` struct to the ViewModel.

    struct MatchedTrack {
        let title: String
        let artist: String
        let artworkURL: URL?
    }

    var matchedTrack: MatchedTrack?

    func startListening() {
        guard status != .listening else { return }

        status = .listening

        // Mock a match after a random delay
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2s
            await MainActor.run {
                self.status = .matched
                self.matchedTrack = MatchedTrack(
                    title: "Never Gonna Give You Up",
                    artist: "Rick Astley",
                    artworkURL: URL(string: "https://music.apple.com/us/album/never-gonna-give-you-up/1558533900?i=1558534271")
                )
            }
        }
    }

    func stopListening() {
        status = .idle
        matchedTrack = nil
    }
}
