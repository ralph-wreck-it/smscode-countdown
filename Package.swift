// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SMSCodeCountdown",
    products: [
        .library(
            name: "SMSCodeCountdown",
            targets: ["SMSCodeCountdown"]),
    ],
    targets: [
        .target(
            name: "SMSCodeCountdown",
            dependencies: []),
        .testTarget(
            name: "SMSCodeCountdownTests",
            dependencies: ["SMSCodeCountdown"]),
    ]
)
