import Foundation

struct ITunesTrack: Decodable, Equatable, Sendable {
    let trackId: Int?
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let collectionId: Int?
    let artworkUrl100: String?
    let previewUrl: String?
    let trackTimeMillis: Int?
}
