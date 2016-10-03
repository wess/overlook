import PackageDescription

let package = Package(
    name: "overlook",
    targets: [
      Target(name: "overlook", dependencies: ["watch", "config", "JSON"]),
      Target(name: "watch"),
      Target(name: "config", dependencies: ["JSON"]),
      Target(name: "JSON"),
    ],

    dependencies: [
        .Package(url: "https://github.com/kylef/PathKit.git",   majorVersion: 0, minor: 7),
    ]
)
