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

let config      = Config()!
let directories = config.directories.map { "\(Path($0).absolute())" }

print("Directories: ", directories)

Watch(directories) { 
    print(exec(["ls", "-la"]) ?? "nope")
}

dispatchMain()
