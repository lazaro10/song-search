import SwiftUI

public struct DSIcon: Sendable, Hashable {
    public let systemName: String

    public init(systemName: String) {
        self.systemName = systemName
    }
}

public extension DSIcon {
    static let back = DSIcon(systemName: "chevron.left")
    static let disclosure = DSIcon(systemName: "chevron.right")
    static let clear = DSIcon(systemName: "xmark")
    static let more = DSIcon(systemName: "ellipsis")

    static let play = DSIcon(systemName: "play.fill")
    static let pause = DSIcon(systemName: "pause.fill")
    static let skipBackward = DSIcon(systemName: "backward.fill")
    static let skipForward = DSIcon(systemName: "forward.fill")
    static let shuffle = DSIcon(systemName: "shuffle")

    static let search = DSIcon(systemName: "magnifyingglass")

    static let note = DSIcon(systemName: "music.note")
    static let trackList = DSIcon(systemName: "music.note.list")
    static let album = DSIcon(systemName: "opticaldisc")

    static let viewAlbum = DSIcon(systemName: "square.stack")
    static let share = DSIcon(systemName: "square.and.arrow.up")

    static let warning = DSIcon(systemName: "exclamationmark.triangle")
    static let offline = DSIcon(systemName: "wifi.slash")
}

public extension Image {
    init(_ icon: DSIcon) {
        self.init(systemName: icon.systemName)
    }
}
