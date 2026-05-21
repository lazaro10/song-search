import Foundation
import Testing
@testable import Networking

@Suite(.serialized)
struct URLSessionHTTPRequesterTests {
    init() {
        URLProtocolSpy.reset()
    }

    @Test func buildsURLFromBaseURLPathAndQuery() async throws {
        let sut = makeSUT()
        URLProtocolSpy.responder = { _ in (Self.okResponse(), Data()) }

        _ = try await sut.request(
            baseURL: URL(string: "https://api.example.com")!,
            path: "/v1/songs",
            method: .get,
            query: ["term": "beatles", "limit": "20"],
            body: nil,
            headers: [:]
        )

        let captured = try #require(URLProtocolSpy.capturedRequests.first)
        #expect(captured.url?.host == "api.example.com")
        #expect(captured.url?.path == "/v1/songs")
        let queryItems = URLComponents(url: captured.url!, resolvingAgainstBaseURL: false)?.queryItems ?? []
        #expect(Set(queryItems) == Set([
            URLQueryItem(name: "term", value: "beatles"),
            URLQueryItem(name: "limit", value: "20"),
        ]))
    }

    @Test func preservesBaseURLPathAndAppendsPath() async throws {
        let sut = makeSUT()
        URLProtocolSpy.responder = { _ in (Self.okResponse(), Data()) }

        _ = try await sut.request(
            baseURL: URL(string: "https://api.example.com/base")!,
            path: "/v1/songs",
            method: .get,
            query: [:],
            body: nil,
            headers: [:]
        )

        let captured = try #require(URLProtocolSpy.capturedRequests.first)
        #expect(captured.url?.path == "/base/v1/songs")
    }

    @Test func setsMethodBodyAndHeaders() async throws {
        let sut = makeSUT()
        URLProtocolSpy.responder = { _ in (Self.okResponse(), Data()) }
        let body = Data("{\"a\":1}".utf8)

        _ = try await sut.request(
            baseURL: URL(string: "https://api.example.com")!,
            path: "/v1/songs",
            method: .post,
            query: [:],
            body: body,
            headers: ["Authorization": "Bearer X", "Content-Type": "application/json"]
        )

        let captured = try #require(URLProtocolSpy.capturedRequests.first)
        #expect(captured.httpMethod == "POST")
        let readBody = try Self.readBody(from: captured)
        #expect(readBody == body)
        #expect(captured.value(forHTTPHeaderField: "Authorization") == "Bearer X")
        #expect(captured.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test func returnsDataOn2xx() async throws {
        let sut = makeSUT()
        let expected = Data("{\"ok\":true}".utf8)
        URLProtocolSpy.responder = { _ in (Self.okResponse(), expected) }

        let data = try await sut.request(
            baseURL: URL(string: "https://api.example.com")!,
            path: "/v1/songs",
            method: .get,
            query: [:],
            body: nil,
            headers: [:]
        )

        #expect(data == expected)
    }

    @Test func throwsInvalidResponseWhenNotHTTPURLResponse() async {
        let sut = makeSUT()
        URLProtocolSpy.responder = { request in
            let response = URLResponse(
                url: request.url!,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil
            )
            return (response, Data())
        }

        await #expect(throws: NetworkError.invalidResponse) {
            _ = try await sut.request(
                baseURL: URL(string: "https://api.example.com")!,
                path: "/v1/songs",
                method: .get,
                query: [:],
                body: nil,
                headers: [:]
            )
        }
    }

    @Test func normalizesTrailingSlashInBaseURLAgainstLeadingSlashInPath() async throws {
        let sut = makeSUT()
        URLProtocolSpy.responder = { _ in (Self.okResponse(), Data()) }

        _ = try await sut.request(
            baseURL: URL(string: "https://api.example.com/")!,
            path: "/v1/songs",
            method: .get,
            query: [:],
            body: nil,
            headers: [:]
        )

        let captured = try #require(URLProtocolSpy.capturedRequests.first)
        #expect(captured.url?.path == "/v1/songs")
        #expect(captured.url?.absoluteString.contains("//v1/songs") == false)
    }

    @Test func acceptsPathWithoutLeadingSlash() async throws {
        let sut = makeSUT()
        URLProtocolSpy.responder = { _ in (Self.okResponse(), Data()) }

        _ = try await sut.request(
            baseURL: URL(string: "https://api.example.com")!,
            path: "v1/songs",
            method: .get,
            query: [:],
            body: nil,
            headers: [:]
        )

        let captured = try #require(URLProtocolSpy.capturedRequests.first)
        #expect(captured.url?.path == "/v1/songs")
    }

    @Test func throwsHttpErrorOnNon2xx() async {
        let sut = makeSUT()
        URLProtocolSpy.responder = { _ in (Self.response(statusCode: 404), Data()) }

        await #expect(throws: NetworkError.httpError(statusCode: 404)) {
            _ = try await sut.request(
                baseURL: URL(string: "https://api.example.com")!,
                path: "/v1/songs",
                method: .get,
                query: [:],
                body: nil,
                headers: [:]
            )
        }
    }

    private func makeSUT() -> URLSessionHTTPRequester {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolSpy.self]
        let session = URLSession(configuration: configuration)
        return URLSessionHTTPRequester(session: session)
    }

    private static func okResponse(url: URL = URL(string: "https://api.example.com")!) -> HTTPURLResponse {
        response(statusCode: 200, url: url)
    }

    private static func response(
        statusCode: Int,
        url: URL = URL(string: "https://api.example.com")!
    ) -> HTTPURLResponse {
        HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }

    private static func readBody(from request: URLRequest) throws -> Data {
        if let body = request.httpBody { return body }
        guard let stream = request.httpBodyStream else { return Data() }
        stream.open()
        defer { stream.close() }
        var data = Data()
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }
        while stream.hasBytesAvailable {
            let read = stream.read(buffer, maxLength: bufferSize)
            if read <= 0 { break }
            data.append(buffer, count: read)
        }
        return data
    }
}
