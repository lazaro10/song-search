import Foundation
import Testing
import Networking
@testable import ImageLoader

@Suite struct ImageLoaderTests {
    @Test func returnsNilWhenCachedBytesAreNotDecodableAsImage() async {
        // Seed the shared cache with junk under a unique URL so the load
        // hits the disk-cache path (no network) and the decode fails.
        let url = URL(string: "https://image-loader-tests.example.com/\(UUID().uuidString).png")!
        ImageDiskCache.shared.save(Data("not an image".utf8), for: url)

        let image = await ImageLoader.load(from: url)

        #expect(image == nil)
    }
}
