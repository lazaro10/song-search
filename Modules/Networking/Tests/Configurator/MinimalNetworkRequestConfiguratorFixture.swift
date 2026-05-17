import Foundation
@testable import Networking

struct MinimalNetworkRequestConfiguratorFixture: NetworkRequestConfigurator {
    var baseURL: URL = URL(string: "https://api.example.com")!
    var path: String = "/v1/minimal"
}
