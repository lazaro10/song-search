import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("17.0")

let baseSettings: SettingsDictionary = [
    "SWIFT_VERSION": "6.0",
    "GENERATE_INFOPLIST_FILE": "YES",
]

let project = Project(
    name: "Storage",
    targets: [
        .target(
            name: "Storage",
            destinations: [.iPhone, .iPad],
            product: .staticFramework,
            bundleId: "com.lazaro.songsearch.storage",
            deploymentTargets: deploymentTargets,
            sources: ["Sources/**/*.swift"],
            dependencies: [
                .project(target: "SongAPI", path: "../SongAPI"),
            ],
            settings: .settings(base: baseSettings)
        ),
        .target(
            name: "StorageTests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.lazaro.songsearch.storage.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Tests/**/*.swift"],
            dependencies: [
                .target(name: "Storage"),
            ],
            settings: .settings(base: baseSettings)
        ),
    ],
    schemes: [
        .scheme(
            name: "Storage",
            shared: true,
            buildAction: .buildAction(targets: ["Storage"]),
            testAction: .targets(["StorageTests"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
