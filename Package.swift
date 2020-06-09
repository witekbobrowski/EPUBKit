// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "EPUBKit",
    
    platforms: [
        .macOS(.v10_10),
        .iOS(.v9),
        .tvOS(.v9)
    ],
    
    products: [
        .library(name: "EPUBKit", targets: ["EPUBKit"]),
    ],
    
    dependencies: [.package(url: "https://github.com/tadija/AEXML", from: "4.5.0")],
    
    targets: [
        .target(
            name: "EPUBKit",
            dependencies: ["AEXML"],
            path: "Sources"
        )
    ]
)
