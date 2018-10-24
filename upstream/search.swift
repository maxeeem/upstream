//
//  search.swift
//  upstream
//
//  Created by Maxim Tarasov
//

import Foundation


enum SearchError: Error {
    case NotFound
}


extension Array where Element == URL {
    /// recursively search elements for `string`
    /// moving upwards in directory structure
    ///
    /// - Parameter string: search term
    /// - Returns: URL containing `string`
    /// - Throws: SearchError
    mutating func upstreamSearch(_ string: String) throws -> URL {
        /// return first directory containing file matching `search`
        return try first(where: {
            try _fs.contentsOfDirectory(atPath: $0.path).contains(string)
        })
        ?? // OR move up one level
        {
            self = map { $0.deletingLastPathComponent() } .filter { !$0.path.isEmpty }
            
            /// break if list is empty
            if self.isEmpty {
                throw SearchError.NotFound
            }
            
            /// repeat from the beginning
            return try upstreamSearch(string)
        }()
    }

    /// return directory urls containing Podfiles with
    /// local :path references to framework folder
    ///
    /// - Parameters:
    ///   - filename: Podfile
    ///   - folder: framework folder url
    /// - Returns: array of matching urls
    /// - Throws: Error if any file cannot be read
    func findURLs(containing filename: String, referencing folder: URL) throws -> [URL] {
        /// find all files matching `filename`
        let urls = map { $0.appendingPathComponent(filename) } .filter { _fs.fileExists(atPath: $0.path) }

        /// check for local :path references to framework folder
        return try urls.filter { url in
            let file = try String(contentsOfFile: url.path, encoding: .utf8)
            return file.containsLocalReferences(to: folder.lastPathComponent)
        }.map { $0.deletingLastPathComponent() } // return directory urls
    }
}
