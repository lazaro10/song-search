import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("17.0")

let baseSettings: SettingsDictionary = [
    "SWIFT_VERSION": "6.0",
    "GENERATE_INFOPLIST_FILE": "YES",
]

let project = Project(
    name: "Formatting",
    targets: [
        .target(
            name: "Formatting",
            destinations: [.iPhone, .iPad],
            product: .staticFramework,
            bundleId: "com.lazaro.songsearch.formatting",
            deploymentTargets: deploymentTargets,
            sources: ["Sources/**/*.swift"],
            settings: .settings(base: baseSettings)
        ),
        .target(
            name: "FormattingTests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.lazaro.songsearch.formatting.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Tests/**/*.swift"],
            dependencies: [
                .target(name: "Formatting"),
            ],
            settings: .settings(base: baseSettings)
        ),
    ],
    schemes: [
        .scheme(
            name: "Formatting",
            shared: true,
            buildAction: .buildAction(targets: ["Formatting"]),
            testAction: .targets(["FormattingTests"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
