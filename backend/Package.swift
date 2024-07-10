// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "ed-practice-backend",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.77.1"),
        .package(url: "https://github.com/lukaskubanek/LoremSwiftum.git", from: "2.2.1")
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "LoremSwiftum", package: "LoremSwiftum")
            ]
        ),
    ]
)
