import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("17.0")

let baseSettings: SettingsDictionary = [
    "SWIFT_VERSION": "6.0",
    "GENERATE_INFOPLIST_FILE": "YES",
]

let project = Project(
    name: "DesignSystem",
    targets: [
        .target(
            name: "DesignSystem",
            destinations: [.iPhone, .iPad],
            product: .staticFramework,
            bundleId: "com.lazaro.songsearch.designsystem",
            deploymentTargets: deploymentTargets,
            sources: ["Sources/**/*.swift"],
            settings: .settings(base: baseSettings)
        ),
        .target(
            name: "DesignSystemTests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.lazaro.songsearch.designsystem.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Tests/**/*.swift"],
            dependencies: [
                .target(name: "DesignSystem"),
            ],
            settings: .settings(base: baseSettings)
        ),
    ],
    schemes: [
        .scheme(
            name: "DesignSystem",
            shared: true,
            buildAction: .buildAction(targets: ["DesignSystem"]),
            testAction: .targets(["DesignSystemTests"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
