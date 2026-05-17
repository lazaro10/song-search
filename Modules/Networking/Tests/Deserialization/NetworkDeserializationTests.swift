import Foundation
import Testing
@testable import Networking

@Suite struct NetworkDeserializationTests {
    @Test func decodeReturnsValueOnValidJSON() throws {
        let sut = NetworkDeserialization()
        let data = Data("{\"id\":1,\"name\":\"abc\"}".utf8)

        let result: DecodableFixture = try sut.decode(data: data)

        #expect(result == DecodableFixture(id: 1, name: "abc"))
    }

    @Test func decodeThrowsDecodingFailedOnInvalidJSON() {
        let sut = NetworkDeserialization()
        let data = Data("not json".utf8)

        #expect(throws: NetworkDeserializationError.decodingFailed) {
            let _: DecodableFixture = try sut.decode(data: data)
        }
    }

    @Test func decodeThrowsDecodingFailedOnSchemaMismatch() {
        let sut = NetworkDeserialization()
        let data = Data("{\"id\":\"not-an-int\",\"name\":\"abc\"}".utf8)

        #expect(throws: NetworkDeserializationError.decodingFailed) {
            let _: DecodableFixture = try sut.decode(data: data)
        }
    }
}
