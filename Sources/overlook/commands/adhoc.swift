//
//  adhoc.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 
import SwiftCLI 
import PathKit
import Rainbow
import task
import watch

public class AdhocCommand : OptionCommand {
  public let name              = "watch"
  public let signature         = ""
  public let shortDescription  = "Watch files or directories and execute command"
  
  private var targets:[String]  = []
  private var ignore:[String]   = []
  private var exec:[String]     = []
  
  public func setupOptions(options: OptionRegistry) {
    options.add(keys: ["-t", "--target",], usage: "Comma separated list of directory or files to monitor", valueSignature: "target") { value in
      let targets = value.replacingOccurrences(of: ", ", with: ",").components(separatedBy: ",")
      
      self.targets = targets.map {
        String(describing: (Path($0).absolute()))
      }
    }
    
    options.add(keys: ["-e", "--execute",], usage: "What is executed when targets are changed", valueSignature: "execute") { value in
      self.exec = value.components(separatedBy: " ")
    }
    
    options.add(keys: ["-i", "--ignore",], usage: "Comma separated list of files or directories to ignore", valueSignature: "ignore") { value in
      self.ignore = value.replacingOccurrences(of: ", ", with: ",").components(separatedBy: ",")
    }
  }
  
  private let taskManager = TaskManager()
  public func execute(arguments: CommandArguments) throws {

    guard targets.count > 0, exec.count > 0 else {
      throw CLIError.error("Arguments `target` and `execute` is required")
    }

    startup(exec.joined(separator: " "), watching: targets)

    taskManager.create(exec) { (data) in
      guard let str = String(data: data, encoding: .utf8) else {
        return
      }
      
      print(str)
    }
    
    taskManager.start()
    watch()
  }
  
  private func watch() {
    Watch(targets, exclude:ignore) {
      self.taskManager.restart()
    }
  }
}

