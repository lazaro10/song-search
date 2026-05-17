import Foundation
import Network

struct SearchSongsRequest: NetworkRequestConfigurator {
    let baseURL: URL
    let term: String
    let limit: Int
    let offset: Int

    var path: String { "/search" }
    var query: [String: String] {
        [
            "term": term,
            "media": "music",
            "entity": "song",
            "limit": "\(limit)",
            "offset": "\(offset)",
        ]
    }
}
