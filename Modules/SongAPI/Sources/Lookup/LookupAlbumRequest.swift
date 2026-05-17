import Foundation
import Network

struct LookupAlbumRequest: NetworkRequestConfigurator {
    let baseURL: URL
    let collectionId: Int

    var path: String { "/lookup" }
    var query: [String: String] {
        [
            "id": "\(collectionId)",
            "entity": "song",
        ]
    }
}
