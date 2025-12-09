// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "EPUBKit",
    
    platforms: [
        .macOS(.v10_13),
        .iOS(.v12),
        .tvOS(.v12)
    ],
    
    products: [
        .library(name: "EPUBKit", targets: ["EPUBKit"]),
    ],
    
    dependencies: [
        .package(
            url: "https://github.com/tadija/AEXML",
            from: "4.7.0"
        ),
        .package(
            url: "https://github.com/marmelroy/Zip",
            from: "2.1.2"
        )
    ],
    
    targets: [
        .target(
            name: "EPUBKit",
            dependencies: ["AEXML", "Zip"]
        ),
        .testTarget(
            name: "EPUBKitTests",
            dependencies: ["EPUBKit"],
            resources: [.copy("Resources")]
        )
    ]
)
