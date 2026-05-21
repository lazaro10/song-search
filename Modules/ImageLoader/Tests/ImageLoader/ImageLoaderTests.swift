import Foundation
import Testing
import Networking
@testable import ImageLoader

@Suite struct ImageLoaderTests {
    @Test func returnsNilWhenCachedBytesAreNotDecodableAsImage() async {
        let url = URL(string: "https://image-loader-tests.example.com/\(UUID().uuidString).png")!
        ImageDiskCache.shared.save(Data("not an image".utf8), for: url)

        let image = await ImageLoader.load(from: url)

        #expect(image == nil)
    }
}
