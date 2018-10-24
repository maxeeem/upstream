//
//  parse.swift
//  upstream
//
//  Created by Maxim Tarasov
//

extension Optional {
    /// true if not nil
    func asBool() -> Bool {
        return self != nil
    }
}


extension String {
    /// split podfile into lines
    /// search for `:path` references to `framework`
    /// compactMap to get rid of irrelevant lines
    /// ignore commented out lines
    ///
    /// - Parameter framework: name of framework to search for
    /// - Returns: True if any un-commented lines contain `:path` references to `framework`
    func containsLocalReferences(to framework: String) -> Bool {
        return components(separatedBy: .newlines) .compactMap { line -> String? in
            guard let range = line.range(of: ":path.*?(\(framework))", options: .regularExpression) else {
                /// no match found, ignore this line
                return nil
            }
            /// line fragment from start of line to location of `:path`
            return String(line[line.startIndex..<range.lowerBound])
        }
        /// ignore commented out lines
        .first(where: { !$0.contains("#") }).asBool()
    }
    
    /// return workspace name if found
    func extractFramework() -> String? {
        return range(of: "(?<=workspace ')([A-Z])\\w+", options: .regularExpression) .map { range in String(self[range]) }
    }
}
