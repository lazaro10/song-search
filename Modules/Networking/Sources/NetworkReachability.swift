import Foundation
import Network
import Observation

@MainActor
@Observable
public final class NetworkReachability {
    public private(set) var isOnline: Bool
    public private(set) var retryToken: Int = 0

    private let monitor: NWPathMonitor
    private let queue: DispatchQueue

    public init(initialState: Bool = true) {
        self.isOnline = initialState
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue(label: "com.songsearch.reachability")

        monitor.pathUpdateHandler = { [weak self] path in
            let online = path.status == .satisfied
            Task { @MainActor in
                self?.updateOnlineState(online)
            }
        }
        monitor.start(queue: queue)
    }

    func updateOnlineState(_ online: Bool) {
        if !isOnline && online {
            retryToken += 1
        }
        isOnline = online
    }

    deinit {
        monitor.cancel()
    }
}
