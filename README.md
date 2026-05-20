# Song Search

iOS app to search the iTunes catalog, preview tracks, and explore albums.

Built with Swift 6, SwiftUI, MVVM, and SwiftData. Multi-project workspace
managed by [Tuist](https://tuist.io).

## Requirements

- Xcode 16 or later
- iOS 17+ simulator
- Tuist 4+ (`mise install tuist` or `brew install --formula tuist`)

## Build and run

```bash
tuist generate
open SongSearch.xcworkspace
```

Select the `SongSearch` scheme on an iOS 17+ simulator and press Run.

## Tests

```bash
xcodebuild -workspace SongSearch.xcworkspace \
           -scheme SongSearch \
           -destination 'platform=iOS Simulator,name=iPhone 17' \
           test
```

Each module has its own scheme (`Networking`, `Storage`, `DesignSystem`,
`SongAPI`, `AudioPlayer`, `Environment`) and can be tested in isolation.
