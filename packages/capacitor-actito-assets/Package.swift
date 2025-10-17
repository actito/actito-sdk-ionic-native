// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorActitoAssets",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CapacitorActitoAssets",
            targets: ["ActitoAssetsPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0"),
        .package(url: "git@github.com:actito/actito-sdk-ios-in-house-releases.git", from: "5.0.0-canary.4"),
    ],
    targets: [
        .target(
            name: "ActitoAssetsPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "ActitoKit", package: "actito-sdk-ios-in-house-releases"),
                .product(name: "ActitoAssetsKit", package: "actito-sdk-ios-in-house-releases"),
            ],
            path: "ios/Sources/ActitoAssetsPlugin"),
    ]
)
