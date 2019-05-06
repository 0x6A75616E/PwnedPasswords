// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "PwnedPasswords",
    // platforms: [.iOS("9.0"), .macOS("10.10"), tvOS("9.0"), .watchOS("2.0")],
    products: [
        .library(name: "PwnedPasswords", targets: ["PwnedPasswords"])
    ],
    targets: [
        .target(
            name: "PwnedPasswords",
            path: "src"
        )
    ]
)