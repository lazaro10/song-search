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
tuist install
tuist generate
open SongSearch.xcworkspace
```

Select the `SongSearch` scheme on an iOS 17+ simulator and press Run.

## Tests

Run everything (every module + the app, unit + snapshot) in one shot:

```bash
tuist test
```

Each scheme also exposes its own test action, so you can focus on a single
module from Xcode (Cmd+T) by picking the scheme — for example
`DesignSystem`, `Networking`, `Storage`, `SongAPI`, `Formatting`,
`ImageLoader`, `Localization`, `AudioPlayer`, or `Environment`. The
`SongSearch` scheme runs the app's unit tests plus its snapshot tests;
design-system snapshots live inside the `DesignSystem` scheme.
