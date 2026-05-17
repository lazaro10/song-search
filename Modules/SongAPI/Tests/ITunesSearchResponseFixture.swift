import Foundation
@testable import SongAPI

enum ITunesSearchResponseFixture {
    static func make(
        tracks: [ITunesTrack] = [ITunesTrackFixture.make()]
    ) -> ITunesSearchResponse {
        ITunesSearchResponse(resultCount: tracks.count, results: tracks)
    }
}
