import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("17.0")

let baseSettings: SettingsDictionary = [
    "SWIFT_VERSION": "6.0",
    "GENERATE_INFOPLIST_FILE": "YES",
]

let project = Project(
    name: "Network",
    targets: [
        .target(
            name: "Network",
            destinations: [.iPhone, .iPad],
            product: .staticFramework,
            bundleId: "com.lazaro.songsearch.network",
            deploymentTargets: deploymentTargets,
            sources: ["Sources/**/*.swift"],
            settings: .settings(base: baseSettings)
        ),
        .target(
            name: "NetworkTests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.lazaro.songsearch.network.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Tests/**/*.swift"],
            dependencies: [
                .target(name: "Network"),
            ],
            settings: .settings(base: baseSettings)
        ),
    ],
    schemes: [
        .scheme(
            name: "Network",
            shared: true,
            buildAction: .buildAction(targets: ["Network"]),
            testAction: .targets(["NetworkTests"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
