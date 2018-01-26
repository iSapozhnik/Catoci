// swift-tools-version:3.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Catoci",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//        .package(url: "https://github.com/vapor/vapor.git", from: "2.0")
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2)
    ]
)

//import PackageDescription
//
//let package = Package(
//    name: "SlackBot",
//    dependencies: [
//        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1)
//    ],
//    exclude: [
//        "Images"
//    ]
//)
