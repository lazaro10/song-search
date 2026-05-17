import Foundation
import Testing
@testable import Networking

@MainActor
@Suite struct NetworkReachabilityTests {
    @Test func defaultsToOnlineWithZeroRetryToken() {
        let sut = NetworkReachability()
        #expect(sut.isOnline == true)
        #expect(sut.retryToken == 0)
    }

    @Test func updatingOnlineWhileAlreadyOnlineDoesNotBumpRetryToken() {
        let sut = NetworkReachability(initialState: true)
        sut.updateOnlineState(true)
        #expect(sut.retryToken == 0)
    }

    @Test func goingOfflineDoesNotBumpRetryToken() {
        let sut = NetworkReachability(initialState: true)
        sut.updateOnlineState(false)
        #expect(sut.isOnline == false)
        #expect(sut.retryToken == 0)
    }

    @Test func transitioningOfflineToOnlineBumpsRetryToken() {
        let sut = NetworkReachability(initialState: true)
        sut.updateOnlineState(false)
        sut.updateOnlineState(true)
        #expect(sut.isOnline == true)
        #expect(sut.retryToken == 1)
    }

    @Test func retryTokenIncrementsOnEachOfflineOnlineCycle() {
        let sut = NetworkReachability(initialState: true)
        for _ in 0..<3 {
            sut.updateOnlineState(false)
            sut.updateOnlineState(true)
        }
        #expect(sut.retryToken == 3)
    }
}
