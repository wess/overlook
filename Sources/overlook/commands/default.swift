//
//  default.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation
import PathKit
import SwiftCLI
import Rainbow 
import config
import env
import task
import watch

public class DefaultCommand : Command {
  public let name              = ""
  public let signature         = "[<optional>] ..."
  public let shortDescription  = ""
  
  private let taskManager = TaskManager()
  private var env         = Env()
  private var directories = [String]()
  private var exec        = [String]()
  private var ignore      = [String]()
  
  public init() {}
  
  public func execute(arguments: CommandArguments) throws {
    guard let settings = Config() else {
      throw CLIError.error("Unable to locate .overlook file, please run `overlook init`")
    }
    
    directories = settings.directories.map { String(describing: Path($0).absolute()) }
    ignore      = settings.ignore.map { String(describing: Path($0).absolute()) }
    exec        = settings.execute.components(separatedBy: " ")
    
    guard directories.count > 0, exec.count > 0 else {
      throw CLIError.error("No `directories` or `execute` found in .overlook file. They are required. ")
    }
  
    startup(exec.joined(separator: " "), watching: directories)
    
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
    Watch(directories, exclude:ignore) {
      self.taskManager.restart()
    }
  }
  
  private func setupEnv(_ vars:[String:String]) {
    for(k,v) in vars {
      env[k] = v
    }
  }
}
