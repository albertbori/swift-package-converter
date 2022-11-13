//
//  ProjectSpec+Extensions.swift
//  
//
//  Created by Albert Bori on 11/6/22.
//

import Foundation
import ProjectSpec
import XcodeProj

extension Platform {
    func asSwiftPackageString() throws -> String {
        switch rawValue {
        case "iOS":
             return ".iOS(.v14)"
        case "macOS":
            return ".macOS(.v12)"
        default:
            throw "Unrecognized XcodeGen platform value: \(self)"
        }
    }
}

extension XCRemoteSwiftPackageReference.VersionRequirement {
    func getSwiftPackageVersionParameters() throws -> String {
        switch self {
        case .upToNextMajorVersion(let majorVersion):
            return "\"0\"...\"\(majorVersion)"
        case .upToNextMinorVersion(let minorVersion):
            return "\"0.0\"...\"\(minorVersion)"
        case .range(from: let fromVersion, to: let toVersion):
            return "\(fromVersion)\"...\"\(toVersion)"
        case .exact(let version):
            return "exact: \"\(version)\""
        case .branch(let branch):
            return "branch: \"\(branch)\""
        case .revision(let revision):
            return "revision: \"\(revision)\""
        }
    }
}
