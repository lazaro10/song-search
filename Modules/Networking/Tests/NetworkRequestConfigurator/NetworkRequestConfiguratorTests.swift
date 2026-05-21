import Foundation
import Testing
@testable import Networking

@Suite struct NetworkRequestConfiguratorTests {
    @Test func defaultMethodIsGet() {
        #expect(MinimalNetworkRequestConfiguratorFixture().method == .get)
    }

    @Test func defaultQueryIsEmpty() {
        #expect(MinimalNetworkRequestConfiguratorFixture().query.isEmpty)
    }

    @Test func defaultBodyIsNil() {
        #expect(MinimalNetworkRequestConfiguratorFixture().body == nil)
    }

    @Test func defaultHeadersAreEmpty() {
        #expect(MinimalNetworkRequestConfiguratorFixture().headers.isEmpty)
    }
}
