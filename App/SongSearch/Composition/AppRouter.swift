import Foundation
import Observation

@MainActor
@Observable
final class AppRouter {
    var path: [AppRoute] = [] {
        didSet { collapseLoops() }
    }

    func navigate(to route: AppRoute) {
        path.append(route)
    }

    private func collapseLoops() {
        guard
            path.count > 1,
            let last = path.last,
            let first = path.firstIndex(of: last),
            first < path.count - 1
        else { return }
        path = Array(path.prefix(first + 1))
    }
}
