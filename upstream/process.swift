//
//  process.swift
//  upstream
//
//  Created by Maxim Tarasov
//

import Foundation


/// Travels up the directory hierarchy to locate other Podfiles.
/// If any of them contain local references to the original framework,
/// execute a block to update CocoaPods for that project
///
/// - Parameters:
///   - baseURL: original framework folder
///   - block: receives directory containing another framework referencing
///             original framework as well as the original framework's name
///
/// - Returns: Never
func processChanges(in baseUrl: URL, block: (URL, String) -> Void) -> Never {    
    do {
        print(color: .yellow, "--- Synchronizing ---")
        
        /// load contents of a Podfile
        let podfile: String = try {
            let fileUrl = baseUrl.appendingPathComponent(_filename)
            return try String(contentsOf: fileUrl, encoding: .utf8)
        }()
        
        /// extract Framework name
        guard let framework = podfile.extractFramework() else {
            /// :(
            print("Failed to extract framework name from Podfile")
            exit(1)
        }
        
        /// enumerate parent directory

        let rootDir = baseUrl.deletingLastPathComponent()

        var directories = try _fs.contentsOfDirectory(at: rootDir, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
        
        /// exclude baseUrl from enumeration
        directories = directories.filter { $0.lastPathComponent != baseUrl.lastPathComponent }
        
        /// find directories containing local references to the original framework
        let requireUpdate = try directories.findURLs(containing: _filename, referencing: baseUrl)

        /// run completion block
        for directory in requireUpdate {
            block(directory, framework)
        }
        
        /// :-)
        exit(0)
    } catch SearchError.NotFound {
        /// :(
        print("Failed to locate \(_filename)")
        exit(1)
    } catch {
        /// :(
        print(error)
        exit(1)
    }
    
    /// :-)
    exit(0)
}
