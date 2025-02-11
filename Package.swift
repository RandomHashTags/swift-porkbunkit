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
    targets: [
        .target(
            name: "PorkbunKit"
        ),
        .testTarget(
            name: "PorkbunKitTests",
            dependencies: ["PorkbunKit"]
        ),
    ]
)
