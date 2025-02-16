// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "SwiftSound",
  platforms: [.macOS(SupportedPlatform.MacOSVersion.v15)],
  products: [
    .library(name: "SwiftSound", targets: ["SwiftSound"]),
    // swift run fft
    .executable(name: "fft", targets: ["FFT"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    .package(url: "https://github.com/KarthikRIyer/swiftplot.git", from: "2.0.0"),
  ],
  targets: [
    .target(
      name: "SwiftSound",
      dependencies: [
        .product(name: "SwiftPlot", package: "swiftplot"),
        .product(name: "SVGRenderer", package: "swiftplot"),
      ]
    ),
    .executableTarget(
      name: "FFT",
      dependencies: [
        "SwiftSound", .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]
    ),
  ]
)
