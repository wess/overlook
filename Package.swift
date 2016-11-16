import PackageDescription

let package = Package(
    name: "overlook",
    targets: [
      Target(name: "overlook", dependencies: ["watch", "config", "task", "env",]),
      Target(name: "watch"),
      Target(name: "config", dependencies: ["json"]),
      Target(name: "json"),
      Target(name: "task"),
      Target(name: "env"),
    ],

    dependencies: [
        .Package(url: "https://github.com/kylef/PathKit",     majorVersion: 0, minor: 7),
        .Package(url: "https://github.com/onevcat/Rainbow",   majorVersion: 2),
        .Package(url: "https://github.com/jakeheis/SwiftCLI", majorVersion: 2),
    ]
)
