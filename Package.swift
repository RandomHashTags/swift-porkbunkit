// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-porkbunkit",
    products: [
        .library(
            name: "PorkbunKit",
            targets: ["PorkbunKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client", from: "1.25.1")
    ],
    targets: [
        .target(
            name: "PorkbunKit",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client")
            ]
        ),
        .testTarget(
            name: "PorkbunKitTests",
            dependencies: ["PorkbunKit"]
        )
    ]
)
