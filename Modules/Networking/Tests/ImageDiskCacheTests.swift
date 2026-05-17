import Foundation
import Testing
@testable import Networking

@Suite struct ImageDiskCacheTests {
    @Test func returnsNilForUncachedURL() {
        let sut = makeSUT()
        let url = URL(string: "https://example.com/never-saved.png")!
        #expect(sut.data(for: url) == nil)
    }

    @Test func saveAndReadRoundtrips() {
        let sut = makeSUT()
        let url = URL(string: "https://example.com/art.png")!
        let payload = Data("hello".utf8)

        sut.save(payload, for: url)
        let result = sut.data(for: url)

        #expect(result == payload)
    }

    @Test func saveOverwritesPreviousData() {
        let sut = makeSUT()
        let url = URL(string: "https://example.com/art.png")!

        sut.save(Data("first".utf8), for: url)
        sut.save(Data("second".utf8), for: url)
        let result = sut.data(for: url)

        #expect(result == Data("second".utf8))
    }

    @Test func keyIsStableAcrossCalls() {
        let url = URL(string: "https://example.com/art.png")!
        let a = ImageDiskCache.key(for: url)
        let b = ImageDiskCache.key(for: url)
        #expect(a == b)
    }

    @Test func differentURLsProduceDifferentKeys() {
        let urlA = URL(string: "https://example.com/a.png")!
        let urlB = URL(string: "https://example.com/b.png")!
        #expect(ImageDiskCache.key(for: urlA) != ImageDiskCache.key(for: urlB))
    }

    // MARK: - Helpers

    private func makeSUT() -> ImageDiskCache {
        let temp = FileManager.default.temporaryDirectory
            .appendingPathComponent("ImageDiskCacheTests-\(UUID().uuidString)", isDirectory: true)
        return ImageDiskCache(directory: temp)
    }
}
