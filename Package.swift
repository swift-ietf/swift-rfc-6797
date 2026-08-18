// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-rfc-6797",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27")
    ],
    products: [
        .library(
            name: "RFC 6797",
            targets: ["RFC 6797"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-ietf/swift-rfc-9110.git", branch: "main")
    ],
    targets: [
        .target(
            name: "RFC 6797",
            dependencies: [
                .product(name: "RFC 9110", package: "swift-rfc-9110")
            ]
        ),
        .testTarget(
            name: "RFC 6797 Tests",
            dependencies: ["RFC 6797"]
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes")
    ]
}
