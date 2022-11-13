//
//  Configuration.swift
//  
//
//  Created by Albert Bori on 11/5/22.
//

import Foundation

protocol Configuration {
    var isDryRun: Bool { get }
    var expandedSearchURL: URL { get }
    var xcodeGenYMLFilePattern: String { get }
}
