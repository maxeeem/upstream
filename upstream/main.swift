#!/usr/bin/swift
//
//  main.swift
//  upstream
//
//  Created by Maxim Tarasov
//

import Foundation


let _filename = "Podfile"
let _fs = FileManager.default
let _args = CommandLine.arguments.dropFirst() // first is `self`

/// Display Help
if ["-h", "--help"].contains(_args.first) {
    displayHelp()
    
    /// :-)
    exit(0)
}

/// get urls of changed items from arguments
/// delete last component to get directory urls and not file urls
var dirs = _args.map { URL(fileURLWithPath: $0).deletingLastPathComponent() }

/// get root directory
var rootDir: URL = try {
    if dirs.isEmpty {
        /// called without url parameters, use current directory
        return URL(fileURLWithPath: _fs.currentDirectoryPath)
    } else {
        /// find root in passed in directories
        return try dirs.upstreamSearch(_filename)
    }
}()

/// update cocoapods for all projects in parent directory
/// that contain local references to our current framework
processChanges(in: rootDir) { (directory, framework) in
    /// switch to the relevant project's directory
    _fs.changeCurrentDirectoryPath(directory.path)
    print(">>-", _fs.currentDirectoryPath)

    /// update CocoaPods
    let exitCode = run(command: "pod", args: "update", framework)
    
    /// output update status
    if exitCode == 0 { // no error
        print(color: .green, "-== In-Sync ==-")
    } else {
        print(color: .red, "=-- ERROR --=")
    }
}
