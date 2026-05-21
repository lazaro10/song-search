# Song Search

iOS app to search the iTunes catalog, preview tracks, and explore albums.

Built with Swift 6, SwiftUI, MVVM, and SwiftData. Multi-project workspace
managed by [Tuist](https://tuist.io).

## Architecture

The codebase is one app target plus several Swift modules grouped under two
top-level roots:

- **`APIs/`** — external service integrations (today: `SongAPI`, wrapping
  the iTunes Search endpoints).
- **`Modules/`** — infrastructure (`Networking`, `Storage`, `AudioPlayer`,
  `ImageLoader`, `Environment`), cross-cutting utilities (`Formatting`,
  `Localization`) and the `DesignSystem`.

Each module is its own Tuist project, with its own scheme and test target,
and a strictly downward dependency direction enforced by the compiler. We
chose this layering because it gives us:

- **Build isolation** — change one module, only its dependents recompile.
- **Test scope** — `tuist test` runs every module's suite in isolation
  (App tests don't pull in `Networking`'s test target, and vice versa).
- **Reusability** — `DesignSystem`, `ImageLoader`, `Localization`, and
  `Formatting` know nothing about this product specifically and could move
  to another app unchanged.
- **Clear seams** — adding a second backend, a new caching layer, or
  another audio backend is a focused change in one module rather than a
  ripple across the app.

### Why features aren't modularized

The five screens (Splash, Home, Player, Album, MoreOptions) live inside
the App target on purpose. For an app this size, splitting each feature
into its own module would mean inter-module wiring for cross-feature
navigation (sheets, route handoffs), `public` on every type a feature
exposes, and Builders that re-thread all dependencies — significant
ceremony for marginal isolation gain.

The trade-off flips around ~20+ screens or when multiple teams need
ownership boundaries. Until then, App composes the features and the
navigation tree stays readable in one place.

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
