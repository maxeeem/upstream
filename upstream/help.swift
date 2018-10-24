//
//  help.swift
//  upstream
//
//  Created by Maxim Tarasov
//

import Foundation


/// Display default help message
///
func displayHelp() {
    let help = """

    \(bold("==== Upstream ===="))

    Updates CocoaPods for all projects in the parent directory that reference this framework using its local path.

    
    \(bold("If called with no arguments")), the program uses current directory as starting point to locate the Podfile.

    \(bold("If used with a file change observer")) (ex. fswatch), it can accept a list of changed files. It will then
    travel up the directory structure until it finds a Podfile, using that directory as the starting point.

    """

    print(help)
}


private func bold(_ string: String) -> String {
    return "\u{001B}[1m" + string + "\u{001B}[22m"
}

private func italics(_ string: String) -> String {
    return "\u{001B}[3m" + string + "\u{001B}[23m"
}
