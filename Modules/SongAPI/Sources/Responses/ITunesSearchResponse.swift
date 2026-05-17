import Foundation

struct ITunesSearchResponse: Decodable, Equatable, Sendable {
    let resultCount: Int
    let results: [ITunesTrack]
}
