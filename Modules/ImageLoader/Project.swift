import ProjectDescription

let deploymentTargets: DeploymentTargets = .iOS("17.0")

let baseSettings: SettingsDictionary = [
    "SWIFT_VERSION": "6.0",
    "GENERATE_INFOPLIST_FILE": "YES",
]

let project = Project(
    name: "ImageLoader",
    targets: [
        .target(
            name: "ImageLoader",
            destinations: [.iPhone, .iPad],
            product: .staticFramework,
            bundleId: "com.lazaro.songsearch.imageloader",
            deploymentTargets: deploymentTargets,
            sources: ["Sources/**/*.swift"],
            dependencies: [
                .project(target: "Networking", path: "../Networking"),
            ],
            settings: .settings(base: baseSettings)
        ),
        .target(
            name: "ImageLoaderTests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "com.lazaro.songsearch.imageloader.tests",
            deploymentTargets: deploymentTargets,
            sources: ["Tests/**/*.swift"],
            dependencies: [
                .target(name: "ImageLoader"),
            ],
            settings: .settings(base: baseSettings)
        ),
    ],
    schemes: [
        .scheme(
            name: "ImageLoader",
            shared: true,
            buildAction: .buildAction(targets: ["ImageLoader"]),
            testAction: .targets(["ImageLoaderTests"]),
            runAction: .runAction(configuration: "Debug"),
            archiveAction: .archiveAction(configuration: "Release")
        ),
    ]
)
