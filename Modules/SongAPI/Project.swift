import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("17.0")

let baseSettings: SettingsDictionary = [
    "SWIFT_VERSION": "6.0",
    "GENERATE_INFOPLIST_FILE": "YES",
]

let project = Project(
    name: "SongAPI",
    targets: [
        .target(
            name: "SongAPI",
            destinations: [.iPhone, .iPad],
            product: .staticFramework,
            bundleId: "com.lazaro.songsearch.songapi",
            deploymentTargets: deploymentTargets,
            sources: ["Sources/**/*.swift"],
            dependencies: [
                .project(target: "Network", path: "../Network"),
                .project(target: "Environment", path: "../Environment"),
            ],
            settings: .settings(base: baseSettings)
        ),
        .target(
            name: "SongAPITests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.lazaro.songsearch.songapi.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Tests/**/*.swift"],
            dependencies: [
                .target(name: "SongAPI"),
            ],
            settings: .settings(base: baseSettings)
        ),
    ],
    schemes: [
        .scheme(
            name: "SongAPI",
            shared: true,
            buildAction: .buildAction(targets: ["SongAPI"]),
            testAction: .targets(["SongAPITests"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
