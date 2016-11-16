//
//  main.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 
import PathKit
import Rainbow
import SwiftCLI
import watch 
import config
import task
import env 

let _           = Env(Path.current)
let taskManager = TaskManager()
let config      = Config()!
let envVars     = config.envVars
let directories = config.directories.map { "\(Path($0).absolute())" }
let execute     = config.execute.components(separatedBy: " ")
let ignore      = config.ignore

let task = taskManager.create(execute) { (data) in
  let str = String(data: data, encoding: .utf8)!

  print(str)
} 

// taskManager.start()

// Watch(directories, exclude:ignore) {
//   taskManager.restart()
// }

// if config.verbose {
//   startDisplay(config.execute, directories:directories)
// }


CLI.setup(name: Overlook.name, version: Overlook.version, description: Overlook.desc)

CLI.router = OverlookRouter()

let _ = CLI.go()

dispatchMain()
