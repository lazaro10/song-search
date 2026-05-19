import Foundation

final class URLSessionHTTPRequester: HTTPRequester {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request(
        baseURL: URL,
        path: String,
        method: NetworkMethod,
        query: [String: String],
        body: Data?,
        headers: [String: String]
    ) async throws -> Data {
        guard let url = makeURL(baseURL: baseURL, path: path, query: query) else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        return data
    }

    private func makeURL(baseURL: URL, path: String, query: [String: String]) -> URL? {
        let urlWithPath = baseURL.appending(path: path)
        guard var components = URLComponents(url: urlWithPath, resolvingAgainstBaseURL: false) else {
            return nil
        }
        if !query.isEmpty {
            components.queryItems = query
                .sorted { $0.key < $1.key }
                .map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return components.url
    }
}
