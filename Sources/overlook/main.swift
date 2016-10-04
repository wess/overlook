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
import cli
import task

let taskManager = TaskManager()
let config      = Config()!
let directories = config.directories.map { "\(Path($0).absolute())" }

let task = taskManager.create(["\(Path.current.absolute())/while.sh"]) { (data) in
  let str = String(data: data, encoding: .utf8)!
  
  print("TASK: ", str)
}

taskManager.start()

Watch(directories) {
  taskManager.restart()
}

dispatchMain()
