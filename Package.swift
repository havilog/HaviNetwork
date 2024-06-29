// swift-tools-version:5.10

import PackageDescription

let package = Package(
  name: "HaviNetwork",
  platforms: [
    .iOS(.v17)
  ],
  products: [
    .library(
      name: "HaviNetwork",
      targets: ["HaviNetwork"]
    )
  ],
  dependencies: [
  ],
  targets: [
    .target(name: "HaviNetwork"),
  ]
)
