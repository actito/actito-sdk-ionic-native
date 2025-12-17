// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorActito",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CapacitorActito",
            targets: ["ActitoPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0"),
        .package(url: "https://github.com/Actito/actito-sdk-ios.git", from: "5.0.0-beta.2"),
    ],
    targets: [
        .target(
            name: "ActitoPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "ActitoKit", package: "actito-sdk-ios"),
            ],
            path: "ios/Sources/ActitoPlugin"),
    ]
)
