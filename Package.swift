// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Swordinator",
    products: [
        .library(
            name: "Swordinator",
            targets: ["Swordinator"]
        ),
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
            dependencies: ["Swordinator"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
