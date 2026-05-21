import Foundation

public extension TimeInterval {
    var formattedAsMinutesAndSeconds: String {
        Duration.seconds(self).formatted(.time(pattern: .minuteSecond))
    }
}
