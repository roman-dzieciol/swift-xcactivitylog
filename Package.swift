// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private struct SWXCActivityLog {
    static let name = "SWXCActivityLog"
}

let package = Package(
    name: SWXCActivityLog.name,
    platforms: [
        .macOS(.v10_14),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: SWXCActivityLog.name,
            targets: [SWXCActivityLog.name]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/roman-dzieciol/swift-gzip.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: SWXCActivityLog.name,
            dependencies: ["SWGZip"]),
        .testTarget(
            name: SWXCActivityLog.name + "Tests",
            dependencies: [.target(name: SWXCActivityLog.name)]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
