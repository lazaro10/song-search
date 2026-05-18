import Foundation
import SongAPI
import Storage

final class SearchHistoryRepositorySpy: SearchHistoryRepository, @unchecked Sendable {
    struct SaveCall: Equatable {
        let term: String
        let songs: [Song]
    }

    var stubbedSnapshot: SearchHistorySnapshot?
    private(set) var lastSearchCallCount = 0
    private(set) var saveCalls: [SaveCall] = []

    func lastSearch() async -> SearchHistorySnapshot? {
        lastSearchCallCount += 1
        return stubbedSnapshot
    }

    func save(term: String, songs: [Song]) async {
        saveCalls.append(SaveCall(term: term, songs: songs))
    }
}
