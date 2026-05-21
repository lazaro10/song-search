import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("17.0")

let baseSettings: SettingsDictionary = [
    "SWIFT_VERSION": "6.0",
    "GENERATE_INFOPLIST_FILE": "YES",
    "INFOPLIST_KEY_UIApplicationSceneManifest_Generation": "YES",
    "INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents": "YES",
    "INFOPLIST_KEY_UILaunchScreen_Generation": "YES",
    "INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone": "UIInterfaceOrientationPortrait",
    "INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad": "UIInterfaceOrientationPortrait",
]

let project = Project(
    name: "SongSearch",
    targets: [
        .target(
            name: "SongSearch",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "com.lazaro.songsearch",
            deploymentTargets: deploymentTargets,
            infoPlist: .extendingDefault(with: [:]),
            sources: ["SongSearch/**/*.swift"],
            resources: .resources([
                "SongSearch/Assets.xcassets",
                "SongSearch/Preview Content/**",
            ]),
            dependencies: [
                .project(target: "Networking", path: "../Modules/Networking"),
                .project(target: "SongAPI", path: "../Modules/SongAPI"),
                .project(target: "DesignSystem", path: "../Modules/DesignSystem"),
                .project(target: "AudioPlayer", path: "../Modules/AudioPlayer"),
                .project(target: "Storage", path: "../Modules/Storage"),
                .project(target: "Localization", path: "../Modules/Localization"),
                .project(target: "Formatting", path: "../Modules/Formatting"),
            ],
            settings: .settings(base: baseSettings)
        ),
        .target(
            name: "SongSearchTests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.lazaro.songsearch.tests",
            deploymentTargets: deploymentTargets,
            sources: ["SongSearchTests/**/*.swift"],
            dependencies: [
                .target(name: "SongSearch"),
            ]
        ),
        .target(
            name: "SongSearchUITests",
            destinations: [.iPhone, .iPad],
            product: .uiTests,
            bundleId: "com.lazaro.songsearch.uitests",
            deploymentTargets: deploymentTargets,
            sources: ["SongSearchUITests/**/*.swift"],
            dependencies: [
                .target(name: "SongSearch"),
            ]
        ),
    ],
    schemes: [
        .scheme(
            name: "SongSearch",
            shared: true,
            buildAction: .buildAction(targets: ["SongSearch"]),
            testAction: .targets(["SongSearchTests", "SongSearchUITests"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
