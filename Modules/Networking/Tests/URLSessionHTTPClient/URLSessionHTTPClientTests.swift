import Foundation
import Testing
@testable import Networking

@Suite struct URLSessionHTTPClientTests {
    @Test func forwardsConfigurationToRequester() async throws {
        let (sut, requester, deserialization) = makeSUT()
        let configuration = NetworkRequestConfiguratorFixture.make(
            baseURL: URL(string: "https://api.example.com")!,
            path: "/v1/songs",
            method: .post,
            query: ["term": "beatles", "limit": "20"],
            body: Data("{\"a\":1}".utf8),
            headers: ["Authorization": "Bearer X"]
        )
        deserialization.stubbedResult = DecodableFixture(id: 1, name: "x")

        let _: DecodableFixture = try await sut.request(configuration: configuration)

        #expect(requester.calls.count == 1)
        #expect(requester.calls.first == HTTPRequesterSpy.Call(
            baseURL: URL(string: "https://api.example.com")!,
            path: "/v1/songs",
            method: .post,
            query: ["term": "beatles", "limit": "20"],
            body: Data("{\"a\":1}".utf8),
            headers: ["Authorization": "Bearer X"]
        ))
    }

    @Test func returnsDecodedValueFromDeserialization() async throws {
        let (sut, requester, deserialization) = makeSUT()
        requester.stubbedData = Data("{\"id\":42,\"name\":\"x\"}".utf8)
        deserialization.stubbedResult = DecodableFixture(id: 42, name: "x")

        let result: DecodableFixture = try await sut.request(
            configuration: NetworkRequestConfiguratorFixture.make()
        )

        #expect(result == DecodableFixture(id: 42, name: "x"))
        #expect(deserialization.receivedData == [Data("{\"id\":42,\"name\":\"x\"}".utf8)])
    }

    @Test func propagatesRequesterError() async {
        let (sut, requester, _) = makeSUT()
        requester.errorToThrow = NetworkError.httpError(statusCode: 500)

        await #expect(throws: NetworkError.httpError(statusCode: 500)) {
            let _: DecodableFixture = try await sut.request(
                configuration: NetworkRequestConfiguratorFixture.make()
            )
        }
    }

    @Test func propagatesDeserializationError() async {
        let (sut, _, deserialization) = makeSUT()
        deserialization.errorToThrow = NetworkDeserializationError.decodingFailed

        await #expect(throws: NetworkDeserializationError.decodingFailed) {
            let _: DecodableFixture = try await sut.request(
                configuration: NetworkRequestConfiguratorFixture.make()
            )
        }
    }

    @Test func convenienceInitBuildsWithDefaultProviders() {
        _ = URLSessionHTTPClient()
    }

    private func makeSUT() -> (
        sut: URLSessionHTTPClient,
        requester: HTTPRequesterSpy,
        deserialization: NetworkDeserializableSpy
    ) {
        let requester = HTTPRequesterSpy()
        let deserialization = NetworkDeserializableSpy()
        let sut = URLSessionHTTPClient(requester: requester, deserialization: deserialization)
        return (sut, requester, deserialization)
    }
}
