// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPackageConverter",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "SwiftPackageConverter",
            targets: ["SwiftPackageConverter"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.32.0"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftPackageConverter",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "ProjectSpec", package: "XcodeGen"),
            ]
        ),
        .testTarget(
            name: "SwiftPackageConverterTests",
            dependencies: [
                "SwiftPackageConverter",
            ]
        ),
    ]
)
