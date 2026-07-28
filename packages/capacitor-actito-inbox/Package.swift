// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorActitoInbox",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CapacitorActitoInbox",
            targets: ["ActitoInboxPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", "7.0.0"..<"9.0.0"),
        .package(url: "https://github.com/Actito/actito-sdk-ios.git", from: "5.2.0"),
    ],
    targets: [
        .target(
            name: "ActitoInboxPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "ActitoKit", package: "actito-sdk-ios"),
                .product(name: "ActitoInboxKit", package: "actito-sdk-ios"),
            ],
            path: "ios/Sources/ActitoInboxPlugin"),
    ]
)
