import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("17.0")

let baseSettings: SettingsDictionary = [
    "SWIFT_VERSION": "6.0",
    "GENERATE_INFOPLIST_FILE": "YES",
]

let project = Project(
    name: "AudioPlayer",
    targets: [
        .target(
            name: "AudioPlayer",
            destinations: [.iPhone, .iPad],
            product: .staticFramework,
            bundleId: "com.lazaro.songsearch.audioplayer",
            deploymentTargets: deploymentTargets,
            sources: ["Sources/**/*.swift"],
            settings: .settings(base: baseSettings)
        ),
        .target(
            name: "AudioPlayerTests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.lazaro.songsearch.audioplayer.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Tests/**/*.swift"],
            dependencies: [
                .target(name: "AudioPlayer"),
            ],
            settings: .settings(base: baseSettings)
        ),
    ],
    schemes: [
        .scheme(
            name: "AudioPlayer",
            shared: true,
            buildAction: .buildAction(targets: ["AudioPlayer"]),
            testAction: .targets(["AudioPlayerTests"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
