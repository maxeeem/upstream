//
//  execute.swift
//  upstream
//
//  Created by Maxim Tarasov
//

import Foundation


/// adapted from https://stackoverflow.com/a/26973384


@discardableResult
func run(command: String, args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/local/bin/" + command
    task.arguments = args
    return execute(process: task)
}


@discardableResult
func echo(command: String, args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/bin/echo"
    task.arguments = [command] + args
    return execute(process: task)
}


private func execute(process: Process) -> Int32 {
    process.launch()
    process.waitUntilExit()
    return process.terminationStatus
}
