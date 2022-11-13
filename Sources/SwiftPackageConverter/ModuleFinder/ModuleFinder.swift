//
//  ModuleFinder.swift
//  
//
//  Created by Albert Bori on 11/5/22.
//

import Foundation

struct ModuleFinder {
    let fileManager: FileManager
    let xcodeGenFileRegex: NSRegularExpression
    
    init(fileManager: FileManager, xcodeGenFilePattern: String) throws {
        self.fileManager = fileManager
        xcodeGenFileRegex = try NSRegularExpression(pattern: xcodeGenFilePattern)
    }
    
    func search(directoryPath: URL, resultHandler: @escaping (Module) throws -> Void) async throws {
        let filePaths = try fileManager
            .subpathsOfDirectory(atPath: directoryPath.path)
            .map { URL(fileURLWithPath: $0, relativeTo: directoryPath) }
            .filter { xcodeGenFileRegex.isMatch(for: $0.lastPathComponent) }
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for filePath in filePaths.makeIterator() {
                group.addTask { [filePath] in
                    let module = Module(xcodeGenFileURL: filePath)
//                    guard !fileManager.fileExists(atPath: module.packageURL.path) else {
//                        print("\(module.xcodeGenFileURL.path) has already been converted. Skipping...")
//                        return
//                    }
                    try resultHandler(module)
                }
            }
            try await group.waitForAll()
        }
    }
}

extension NSRegularExpression {
    func isMatch(for text: String) -> Bool {
        firstMatch(in: text, range: NSRange(location: 0, length: text.utf16.count)) != nil
    }
}
