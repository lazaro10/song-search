import Foundation
import Testing
@testable import Environment

@Suite struct APIEnvironmentTests {
    @Test func initStoresItunesBaseURL() {
        let url = URL(string: "https://test.example.com")!
        let sut = APIEnvironment(itunesBaseURL: url)
        #expect(sut.itunesBaseURL == url)
    }

    @Test func liveITunesBaseURLPointsToAppleITunes() {
        #expect(APIEnvironment.live.itunesBaseURL == URL(string: "https://itunes.apple.com")!)
    }
}
