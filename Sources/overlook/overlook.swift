//
//  overlook.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

struct Overlook {
  static let name     = "Overlook"
  static let version  = "0.0.1"
  static let desc     = "File monitoring tool that excutes on change. Used anywhere."
}

func startDisplay(_ target:String, directories:[String]) {
  let executing = "executing: ".green.bold
  let target    = config.execute.bold
  
  print("\nStarting Overlook...".green.bold)
  print(executing + target.bold)
  print("watching:".green.bold)

  for directory in directories {
    print("  ", directory.bold)
  }

  print("")
}


