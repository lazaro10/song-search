import Foundation
import Networking

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
