// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "scipio-s3",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "scipio-s3", targets: ["ScipioS3"])
    ],
    dependencies: [
        .package(url: "https://github.com/giginet/Scipio", revision: "0.29.1"),
        .package(url: "https://github.com/giginet/scipio-s3-storage", from: "2.0.0"),
        .package(url: "https://github.com/giginet/scipio-cache-storage", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/freddi-kit/ArtifactBundleGen.git", from: "0.0.7"),

        // Need to specify fixed soto version.
        .package(url: "https://github.com/soto-project/soto-core", revision: "7.2.0"),
        .package(url: "https://github.com/soto-project/soto-codegenerator", revision: "7.3.1"),
    ],
    targets: [
        .executableTarget(
            name: "ScipioS3",
            dependencies: [
                .product(name: "ScipioKit", package: "Scipio"),
                .product(name: "ScipioS3Storage", package: "scipio-s3-storage"),
                .product(name: "ScipioStorage", package: "scipio-cache-storage"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),

                // Need to suppress a warning
                .product(name: "SotoCore", package: "soto-core"),
            ]
        ),
    ]
)
