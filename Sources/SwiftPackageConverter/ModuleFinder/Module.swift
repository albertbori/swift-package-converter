//
//  Module.swift
//  
//
//  Created by Albert Bori on 11/5/22.
//

import Foundation

// XcodeGen imports
import PathKit
import ProjectSpec
import Version

struct Module {
    var xcodeGenFileURL: URL
    
    var packageURL: URL {
        xcodeGenFileURL.deletingLastPathComponent().appendingPathComponent("Package.swift")
    }
    
    func loadXcodeGenProject() throws -> Project {
        let specLoader = SpecLoader(version: Version("2.32.0"))
        return try specLoader.loadProject(path: Path(xcodeGenFileURL.path))
    }
}
