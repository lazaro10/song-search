import Foundation

public enum L10n {
    public enum Home {
        public static var title: String { lookup("home.title") }
        public static var searchPlaceholder: String { lookup("home.search_placeholder") }
        public static var recentlyPlayed: String { lookup("home.recently_played") }
        public static var emptyTitle: String { lookup("home.empty.title") }
        public static var emptyMessage: String { lookup("home.empty.message") }
        public static func resultsFor(_ term: String) -> String {
            String(format: lookup("home.results_for"), term)
        }
        public static var noSongsTitle: String { lookup("home.no_songs.title") }
        public static func noSongsMessage(_ term: String) -> String {
            String(format: lookup("home.no_songs.message"), term)
        }
        public static var loadingMore: String { lookup("home.loading_more") }
        public static var tapToRetry: String { lookup("home.tap_to_retry") }
    }

    public enum Common {
        public static var errorTitle: String { lookup("common.error.title") }
        public static var tryAgain: String { lookup("common.try_again") }
    }

    public enum Album {
        public static var title: String { lookup("album.title") }
        public static var play: String { lookup("album.play") }
        public static var playHint: String { lookup("album.play.hint") }
        public static var shuffle: String { lookup("album.shuffle") }
        public static var shuffleHint: String { lookup("album.shuffle.hint") }
        public static var metaPrefix: String { lookup("album.meta.prefix") }
        public static func trackCount(_ count: Int) -> String {
            String(format: lookup("album.track_count"), count)
        }
        public static var noTracksTitle: String { lookup("album.no_tracks.title") }
        public static var noTracksMessage: String { lookup("album.no_tracks.message") }
    }

    public enum Player {
        public static var title: String { lookup("player.title") }
        public static var previewUnavailable: String { lookup("player.preview_unavailable") }
        public static func fromTheAlbum(_ album: String) -> String {
            String(format: lookup("player.from_the_album"), album)
        }
    }

    public enum MoreOptions {
        public static var viewAlbum: String { lookup("more.view_album") }
        public static var viewAlbumSub: String { lookup("more.view_album.sub") }
        public static var share: String { lookup("more.share") }
        public static var shareSub: String { lookup("more.share.sub") }
        public static func shareMessage(songName: String, artistName: String) -> String {
            String(format: lookup("more.share_message"), songName, artistName)
        }
    }

    public enum Splash {
        public static var appName: String { lookup("splash.app_name") }
        public static var tagline: String { lookup("splash.tagline") }
    }

    public enum Offline {
        public static var banner: String { lookup("offline.banner") }
    }

    public enum A11y {
        public static var back: String { lookup("a11y.back") }
        public static var moreOptions: String { lookup("a11y.more_options") }
        public static var play: String { lookup("a11y.play") }
        public static var pause: String { lookup("a11y.pause") }
        public static var skipBackward: String { lookup("a11y.skip_backward") }
        public static var skipForward: String { lookup("a11y.skip_forward") }
        public static var clearSearch: String { lookup("a11y.clear_search") }
        public static var loading: String { lookup("a11y.loading") }
        public static var playbackProgress: String { lookup("a11y.playback_progress") }
        public static func playbackValue(current: String, total: String) -> String {
            String(format: lookup("a11y.playback_value"), current, total)
        }
        public static func moreOptionsFor(songName: String) -> String {
            String(format: lookup("a11y.more_options_for"), songName)
        }
        public static func songLabel(name: String, artist: String, duration: String) -> String {
            String(format: lookup("a11y.song_label"), name, artist, duration)
        }
        public static func songCardLabel(name: String, artist: String) -> String {
            String(format: lookup("a11y.song_card_label"), name, artist)
        }
        public static var opensPlayer: String { lookup("a11y.opens_player") }
        public static var opensAlbum: String { lookup("a11y.opens_album") }
        public static func fromTheAlbum(_ album: String) -> String {
            String(format: lookup("a11y.from_the_album"), album)
        }
        public static func trackLabel(number: Int, name: String, duration: String) -> String {
            String(format: lookup("a11y.track_label"), number, name, duration)
        }
        public static func albumHeaderLabel(name: String, artist: String, meta: String) -> String {
            String(format: lookup("a11y.album_header_label"), name, artist, meta)
        }
        public static var offlineBanner: String { lookup("a11y.offline_banner") }
        public static var splash: String { lookup("a11y.splash") }
    }
}

private func lookup(_ key: String) -> String {
    NSLocalizedString(key, bundle: .module, comment: "")
}
