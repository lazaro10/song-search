import Foundation

final class URLProtocolSpy: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var responder: (@Sendable (URLRequest) throws -> (URLResponse, Data)) = { _ in
        fatalError("URLProtocolSpy.responder not set")
    }
    nonisolated(unsafe) static var capturedRequests: [URLRequest] = []

    static func reset() {
        responder = { _ in fatalError("URLProtocolSpy.responder not set") }
        capturedRequests = []
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        Self.capturedRequests.append(request)
        do {
            let (response, data) = try Self.responder(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
