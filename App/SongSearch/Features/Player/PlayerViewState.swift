enum PlayerViewState: Equatable {
    case idle
    case playing
    case paused
    case error(message: String)
}
