// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-emailaddress-standard",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
    ],
    products: [
        .library(name: "EmailAddress Standard", targets: ["EmailAddress Standard"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-ietf/swift-rfc-2822.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-5321.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-5322.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-6531.git", branch: "main"),
        .package(
            url: "https://github.com/swift-standards/swift-domain-standard.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "EmailAddress Standard",
            dependencies: [
                .product(name: "Domain Standard", package: "swift-domain-standard"),
                .product(name: "RFC 2822", package: "swift-rfc-2822"),
                .product(name: "RFC 5321", package: "swift-rfc-5321"),
                .product(name: "RFC 5322", package: "swift-rfc-5322"),
                .product(name: "RFC 6531", package: "swift-rfc-6531"),
            ]
        ),
        .testTarget(
            name: "EmailAddress Standard Tests",
            dependencies: [
                .target(name: "EmailAddress Standard")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
