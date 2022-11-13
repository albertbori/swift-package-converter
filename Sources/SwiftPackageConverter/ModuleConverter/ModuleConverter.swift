//
//  ModuleConverter.swift
//  
//
//  Created by Albert Bori on 11/5/22.
//

import Foundation
import ProjectSpec

struct ModuleConverter {
    func convert(module: Module) throws {
        print("Reading XcodeGen file at \(module.xcodeGenFileURL.path)")
        let project = try module.loadXcodeGenProject()
        print("Converting \(project.name) at \(module.xcodeGenFileURL.deletingLastPathComponent().path)")
        try createSwiftPackageFile(from: project, module: module)
        try moveFiles(in: project, module: module)
        try updateXcodeGenFile(for: project, module: module)
        print("\(project.name) was converted at \(module.xcodeGenFileURL.deletingLastPathComponent().path)")
    }
    
    func createSwiftPackageFile(from project: Project, module: Module) throws {
        let swiftPackageFile = try SwiftPackageFile(project: project)
        try swiftPackageFile.save(to: module.packageURL)
    }
    
    func moveFiles(in project: Project, module: Module) throws {
        
    }
    
    func updateXcodeGenFile(for project: Project, module: Module) throws {
        
    }
}
