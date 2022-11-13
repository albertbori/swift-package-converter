import ArgumentParser
import Foundation

@main
struct SwiftPackageConverter: AsyncParsableCommand, Configuration {
    static var configuration: CommandConfiguration = .init(
        discussion: "This script converts XcodeGen modules to Swift Packages. It will not convert a module that has already been converted."
    )
    
    @Option(
        name: [.customShort("d"), .customLong("dry-run")],
        help: "Causes the script to print changes instead of actually performing them."
    )
    var isDryRun: Bool = false
    
    @Option(
        name: [.customShort("p"), .customLong("yml-pattern")],
        help: "The regex pattern used for identifying the XcodeGen yml files"
    )
    var xcodeGenYMLFilePattern: String = #"wf-generate-project\.yml"#
    
    @Argument(help: "The path of the folder that contains one or more XcodeGen modules to be converted")
    var searchPath: String
        
    func validate() throws {
        var errors: [String] = []
        
        if !FileManager.default.fileExists(atPath: expandedSearchURL.path) {
            errors.append("Root URL does not exist: \(expandedSearchURL.path)")
        }
        
        if !errors.isEmpty {
            throw " - " + errors.joined(separator: "\n - ")
        }
    }
    
    func run() async throws {
        let moduleConverter = ModuleConverter()
        let moduleFinder = try ModuleFinder(fileManager: FileManager.default, xcodeGenFilePattern: xcodeGenYMLFilePattern)
        try await moduleFinder.search(directoryPath: expandedSearchURL) { module in
            try moduleConverter.convert(module: module)
        }
    }
}

extension SwiftPackageConverter {
    var expandedSearchURL: URL {
        return URL(fileURLWithPath: NSString(string: searchPath).expandingTildeInPath)
    }
}
