//
//  SwiftPackageFile.swift
//  
//
//  Created by Albert Bori on 11/6/22.
//

import Foundation
import ProjectSpec

class SwiftPackageFile {
    let project: Project
    private(set) var fileContents: String = ""
    
    init(project: Project) throws {
        self.project = project
        fileContents = try buildFile()
    }
    
    func buildFile() throws -> String {
"""
// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "\(project.name)",
    platforms: [
\(try getPlatformLines(from: project))
    ],
    products: [
\(try getProductLines(from: project))
    ],
    dependencies: [
\(try getDependenciesLines(from: project))
    ],
    targets: [
\(try getTargetsLines(from: project))
    ]
)
"""
    }
    
    /// Prints the `platforms` section
    ///
    /// Example
    /// ```
    /// .iOS(.v14),
    /// .macOS(.v12)
    /// ```
    private func getPlatformLines(from project: Project) throws -> String {
        try project.targets
            .map(\.platform)
            .map { try
"""
        \($0.asSwiftPackageString()),
"""
            }
            .uniqued()
            .sorted()
            .joined(separator: "\n")
    }
    
    /// Prints the `products` section of the package declaration
    ///
    /// Example:
    /// ```swift
    /// .library(
    ///     name: "Logging",
    ///     targets: [
    ///         "Logging"
    ///     ]
    /// ),
    /// ```
    private func getProductLines(from project: Project) throws -> String {
        try project.targets
            .compactMap { target in
                try target.asSwiftPackageProductTypeString()
            }
            .sorted()
            .joined(separator: "\n")
    }
    
    /// Prints the `dependencies` section of the package declaration
    ///
    /// Example:
    /// ```swift
    /// .package(path: "../../Platform/SharedTypes"),
    /// .package(
    ///     url: "git@github.csnzoo.com:shared/vsm-ios.git",
    ///     exact: "0.3.0"
    /// ),
    /// ```
    private func getDependenciesLines(from project: Project) throws -> String {
        try project.targets
            .flatMap(\.dependencies)
            .uniqued()
            .compactMap { dependency in
                try dependency.asSwiftPackageDependency(in: project)
            }
            .sorted()
            .joined(separator: "\n")
    }
    
    /// Prints the `targets` section
    ///
    /// Example:
    /// ```
    /// .target(
    ///     name: "Logging",
    ///     dependencies: [
    ///         .product(name: "SharedTypes", package: "SharedTypes"),
    ///         .product(name: "VSM", package: "vsm-ios"),
    ///         .product(name: "DatadogStatic", package: "dd-sdk-ios"),
    ///     ]
    /// ),
    /// ```
    private func getTargetsLines(from project: Project) throws -> String {
        try project.targets
            .compactMap { target in
                try target.asSwiftPackageTarget(in: project)
            }
            .sorted()
            .joined(separator: "\n")
    }
    
    func save(to url: URL) throws {
//        guard let fileData = fileContents.data(using: .utf8) else {
//            throw "Failed to convert file contents to data."
//        }
//        try fileData.write(to: url)
        print(">>> Writing the following package file:\n\n\(fileContents)")
    }
}

extension Target {
    func asSwiftPackageProductTypeString() throws -> String? {
        switch type {
        case .framework, .staticFramework, .xcFramework, .dynamicLibrary, .staticLibrary, .bundle:
            return
"""
        .library(
            name: "\(productName)",
            targets: ["\(productName)"]
        ),
"""
        case .commandLineTool:
            return
"""
        .executable(
            name: "\(productName)",
            targets: ["\(productName)"]
        ),
"""
        default:
            print("Skipping unsupported product type: \(type)")
            return nil
        }
    }
}

extension Target {
    func asSwiftPackageTarget(in project: Project) throws -> String? {
        let dependenciesLines = try dependencies
            .compactMap({ try $0.asSwiftPackageTargetDependency(for: self, in: project) })
            .sorted()
            .joined(separator: "\n")
        
        switch type {
        case .none, .application, .uiTestBundle, .appExtension, .extensionKitExtension, .watchApp, .watch2App, .watch2AppContainer, .watchExtension, .watch2Extension, .tvExtension, .messagesApplication, .messagesExtension, .stickerPack, .xpcService, .ocUnitTestBundle, .xcodeExtension, .instrumentsPackage, .intentsServiceExtension, .onDemandInstallCapableApplication, .metalLibrary, .driverExtension:
            print("Skipping unsupported target type: \(type) for target '\(name)'")
            return nil
        case .framework, .staticFramework, .xcFramework, .dynamicLibrary, .staticLibrary, .bundle:
            return
"""
        .target(
            name: "\(name)",
            dependencies: [
\(dependenciesLines)
            ]
        ),
"""
        case .unitTestBundle:
            return
"""
        .testTarget(
            name: "\(name)",
            dependencies: [
\(dependenciesLines)
            ]
        ),
"""
        case .commandLineTool:
            return
"""
        .executableTarget(
            name: "\(name)",
            dependencies: [
\(dependenciesLines)
            ]
        ),
"""
        case .systemExtension:
            return
"""
        .systemLibrary(
            name: "\(name)",
            dependencies: [
\(dependenciesLines)
            ]
        ),
"""
        }
    }
}

extension Dependency {
    
    /// Remove '.framework' extension from product name (ie: "SharedTypesMocks.framework")
    var trimmedFrameworkName: String {
        get throws {
            try reference.replace("\\.framework$", with: "")
        }
    }
    
    func asSwiftPackageTargetDependency(for target: Target, in project: Project) throws -> String? {
        switch type {
        case .target:
            return
"""
                "\(reference)",
"""
        case .framework:
            return
"""
                "\(try trimmedFrameworkName)",
"""
        case .carthage(findFrameworks: _, linkType: _):
            print("Skipping unsupported target dependency type: \(type)")
            return nil
        case .sdk(root: _):
            print("Skipping unsupported target dependency type: \(type)")
            return nil
        case .package(product: let product):
            if let product {
                return
"""
                .product(name: "\(product)", package: "\(reference)"),
"""
            } else {
                return
"""
                "\(reference)",
"""
            }
        case .bundle:
            return
"""
                "\(reference)",
"""
        }
    }
    
    func asSwiftPackageDependency(in project: Project) throws -> String? {
        switch type {
        case .target:
            print("Skipping unsupported dependency type: \(type)")
            return nil
        case .framework:
            return
"""
        .package(path: "\(try trimmedFrameworkName)"),
"""
        case .carthage(findFrameworks: _, linkType: _):
            print("Skipping unsupported dependency type: \(type)")
            return nil
        case .sdk(root: _):
            print("Skipping unsupported dependency type: \(type)")
            return nil
        case .package(product: _):
            guard let package = project.packages[reference] else {
                throw "Missing package for dependency: \(self)"
            }
            switch package {
            case .remote(url: let url, versionRequirement: let version):
                return
"""
        .package(
            url: "\(url)",
            \(try version.getSwiftPackageVersionParameters())
        ),
"""
            case .local(path: let path, group: _):
                return
"""
        .package(path: "\(path)"),
"""
            }
        case .bundle:
            print("Skipping unsupported dependency type: \(type)")
            return nil
        }
    }
}
