import Foundation
import Testing
@testable import Formatting

@Suite struct TimeIntervalFormattingTests {
    @Test func zeroSecondsRendersAsZeroMinutesAndZeroSeconds() {
        #expect(TimeInterval(0).formattedAsMinutesAndSeconds == "0:00")
    }

    @Test func subMinuteIntervalsPadSecondsToTwoDigits() {
        #expect(TimeInterval(5).formattedAsMinutesAndSeconds == "0:05")
        #expect(TimeInterval(30).formattedAsMinutesAndSeconds == "0:30")
    }

    @Test func sixtySecondsRollsToOneMinute() {
        #expect(TimeInterval(60).formattedAsMinutesAndSeconds == "1:00")
    }

    @Test func multipleMinutesAndSecondsAreRendered() {
        #expect(TimeInterval(65).formattedAsMinutesAndSeconds == "1:05")
        #expect(TimeInterval(225).formattedAsMinutesAndSeconds == "3:45")
    }

    @Test func fractionalSecondsAreRoundedToNearest() {
        #expect(TimeInterval(45.4).formattedAsMinutesAndSeconds == "0:45")
        #expect(TimeInterval(45.9).formattedAsMinutesAndSeconds == "0:46")
    }

    @Test func longDurationsBeyondTenMinutesRender() {
        #expect(TimeInterval(720).formattedAsMinutesAndSeconds == "12:00")
        #expect(TimeInterval(3661).formattedAsMinutesAndSeconds == "61:01")
    }
}
