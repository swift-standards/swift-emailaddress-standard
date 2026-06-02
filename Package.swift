// swift-tools-version: 6.3.1

import PackageDescription

extension String {
    static let emailAddress: Self = "EmailAddress Standard"
}

extension Target.Dependency {
    static var emailAddress: Self { .target(name: .emailAddress) }
}

extension Target.Dependency {
    static var rfc2822: Self { .product(name: "RFC 2822", package: "swift-rfc-2822") }
    static var rfc5321: Self { .product(name: "RFC 5321", package: "swift-rfc-5321") }
    static var rfc5322: Self { .product(name: "RFC 5322", package: "swift-rfc-5322") }
    static var rfc6531: Self { .product(name: "RFC 6531", package: "swift-rfc-6531") }
    static var domain: Self { .product(name: "Domain Standard", package: "swift-domain-standard") }
}

let package = Package(
    name: "swift-emailaddress-standard",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26)
    ],
    products: [
        .library(name: "EmailAddress Standard", targets: ["EmailAddress Standard"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-ietf/swift-rfc-2822.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-5321.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-5322.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-rfc-6531.git", branch: "main"),
        .package(url: "https://github.com/swift-standards/swift-domain-standard.git", branch: "main")
    ],
    targets: [
        .target(
            name: "EmailAddress Standard",
            dependencies: [
                .domain,
                .rfc2822,
                .rfc5321,
                .rfc5322,
                .rfc6531
            ]
        ),
        .testTarget(
            name: "EmailAddress Standard Tests",
            dependencies: [
                "EmailAddress Standard",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
    var foundation: Self { self + " Foundation" }
}

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
