// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkLoggerMiddleware",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "NetworkLoggerMiddleware",
            targets: ["NetworkLoggerMiddleware"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pprokopowicz/NetworkKit.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "NetworkLoggerMiddleware",
            dependencies: [
                .product(name: "NetworkKit", package: "NetworkKit")
            ]),
        .testTarget(
            name: "NetworkLoggerMiddlewareTests",
            dependencies: ["NetworkLoggerMiddleware"]),
    ]
)
