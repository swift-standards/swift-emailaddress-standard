// swift-tools-version:6.2

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
        .package(path: "../swift-rfc-2822"),
        .package(path: "../swift-rfc-5321"),
        .package(path: "../swift-rfc-5322"),
        .package(path: "../swift-rfc-6531"),
        .package(path: "../swift-domain-standard")
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
        )
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
    var foundation: Self { self + " Foundation" }
}

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let existing = target.swiftSettings ?? []
    target.swiftSettings = existing + [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility")
    ]
}
