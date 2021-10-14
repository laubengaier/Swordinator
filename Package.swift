// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Swordinator",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Swordinator", targets: ["Swordinator"]),
    ],
    dependencies: [
        //
    ],
    targets: [
        .target(
            name: "Swordinator",
            dependencies: []
        ),
        .testTarget(
            name: "SwordinatorTests",
            dependencies: [
                "Swordinator"
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
