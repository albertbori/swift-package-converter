//
//  String+Regex.swift
//  
//
//  Created by Albert Bori on 11/12/22.
//

import Foundation

/// Extends the String type to support simple regex searches
public extension String {

    /// Determines if the String matches the regular expression
    /// - Parameters:
    ///   - regex: Regular expression for evaluation
    ///   - options: Regular expression options (defaults to `.caseInsensitive`)
    /// - Returns: True if the string matches the regular expression
    func isMatch(
        _ regex: String,
        options: NSRegularExpression.Options = [.caseInsensitive]
    ) throws -> Bool {
        try NSRegularExpression(pattern: regex, options: options)
            .firstMatch(in: self, range: NSRange(location: 0, length: self.utf16.count)) != nil
    }

    /// Fetches all regular expression matches for this String
    /// - Parameters:
    ///   - regex: Regular expression for evaluation
    ///   - options: Regular expression options (defaults to `.caseInsensitive`)
    /// - Returns: An array of regex matches
    func getMatches(
        _ regex: String,
        options: NSRegularExpression.Options = [.caseInsensitive]
    ) throws -> [RegexMatch] {
        try NSRegularExpression(pattern: regex, options: options)
            .matches(in: self, range: NSRange(location: 0, length: self.utf16.count))
            .map({ try RegexMatch(original: self, result: $0) })
    }

    func replace(
        _ regex: String,
        with replacement: String,
        options: NSRegularExpression.Options = [.caseInsensitive]
    ) throws -> String {
        try NSRegularExpression(pattern: regex, options: options)
            .stringByReplacingMatches(
                in: self,
                range: NSRange(location: 0, length: self.utf16.count),
                withTemplate: replacement
            )
    }

    /// A description of a single regular expression match, along with its sub-groups
    struct RegexMatch {
        /// The range of the entire match (groups included)
        public let range: Range<String.Index>
        /// The text that was matched
        public let text: String
        /// The groups that were matched, with their respective range and text
        public let groups: [(range: Range<String.Index>, text: String)]

        init(original: String, result: NSTextCheckingResult) throws {
            guard let swiftRange = Range(result.range, in: original) else {
                throw RangeError(description: "Failed to get swift range for \(result.range)")
            }
            range = swiftRange
            text = String(original[swiftRange])
            var groups: [(range: Range<String.Index>, text: String)] = []
            for groupIndex in 0..<result.numberOfRanges {
                let groupRange = result.range(at: groupIndex)
                if result.range == groupRange { continue } // skip outer group
                guard let swiftGroupRange = Range(groupRange, in: original) else {
                    throw RangeError(description: "Failed to get group index \(groupIndex)'s swift range for \(groupRange)")
                }
                groups.append((range: swiftGroupRange, text: String(original[swiftGroupRange])))
            }
            self.groups = groups
        }

        struct RangeError: Error, CustomStringConvertible {
            public var description: String
        }
    }
}
