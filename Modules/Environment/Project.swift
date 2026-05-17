import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("17.0")

let baseSettings: SettingsDictionary = [
    "SWIFT_VERSION": "6.0",
    "GENERATE_INFOPLIST_FILE": "YES",
]

let project = Project(
    name: "Environment",
    targets: [
        .target(
            name: "Environment",
            destinations: [.iPhone, .iPad],
            product: .staticFramework,
            bundleId: "com.lazaro.songsearch.environment",
            deploymentTargets: deploymentTargets,
            sources: ["Sources/**/*.swift"],
            settings: .settings(base: baseSettings)
        ),
        .target(
            name: "EnvironmentTests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.lazaro.songsearch.environment.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Tests/**/*.swift"],
            dependencies: [
                .target(name: "Environment"),
            ],
            settings: .settings(base: baseSettings)
        ),
    ],
    schemes: [
        .scheme(
            name: "Environment",
            shared: true,
            buildAction: .buildAction(targets: ["Environment"]),
            testAction: .targets(["EnvironmentTests"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
