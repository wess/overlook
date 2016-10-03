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

let config      = Config()!
let directories = config.directories.map { "\(Path($0).absolute())" }
let output      = "Directories: \(directories)".paint(.green)

let running = task(["\(Path.current.absolute())/while.sh"]) { data in
  let str = String(data: data, encoding: .utf8)
  
  print("STR: \(str)")
}

Watch(directories) {
  running.launch()
}

dispatchMain()
