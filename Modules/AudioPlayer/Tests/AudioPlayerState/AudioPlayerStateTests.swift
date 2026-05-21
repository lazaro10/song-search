import Foundation
import Testing
@testable import AudioPlayer

@Suite struct AudioPlayerStateTests {
    @Test func initStoresAllProperties() {
        let sut = AudioPlayerState(isPlaying: true, currentTime: 5, duration: 30)
        #expect(sut.isPlaying == true)
        #expect(sut.currentTime == 5)
        #expect(sut.duration == 30)
    }

    @Test func twoStatesWithSameValuesAreEqual() {
        let a = AudioPlayerState(isPlaying: true, currentTime: 5, duration: 30)
        let b = AudioPlayerState(isPlaying: true, currentTime: 5, duration: 30)
        #expect(a == b)
    }

    @Test func statesWithDifferentValuesAreNotEqual() {
        let a = AudioPlayerState(isPlaying: true, currentTime: 5, duration: 30)
        let b = AudioPlayerState(isPlaying: false, currentTime: 5, duration: 30)
        #expect(a != b)
    }
}
