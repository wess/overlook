//
//  main.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 
import PathKit
import watch
import config
import terminal
import task
import env 

let _           = Env(Path.current)
let taskManager = TaskManager()
let config      = Config()!
let envVars     = config.envVars
let directories = config.directories.map { "\(Path($0).absolute())" }
let execute     = config.execute

print("Env: ", envVars)
print("Dirs: ", directories)
print("Execute: ", execute)

let task = taskManager.create(execute) { (data) in
  let str = String(data: data, encoding: .utf8)!
  
  print("TASK: ", str)
}

taskManager.start()

Watch(directories) {
  taskManager.restart()
}

dispatchMain()
