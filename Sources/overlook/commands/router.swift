//
//  default.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import SwiftCLI
import Rainbow
import config

public class OverlookRouter: Router {
  public var current:Command
  
  public var exitImmediately = false
  
  public init(_ defaultCommand:Command) {
    self.current = defaultCommand
  }
  
  public func route(commands: [Command], aliases: [String : String], arguments: RawArguments) -> Command? {
    guard let name = arguments.unclassifiedArguments.first else {
      return current
    }

    let cmd = aliases[name.value] ?? name.value
    
    if let command = commands.first(where: { $0.name == cmd }) {
      name.classification = .commandName
      current             = command
    }

    var next = name.next
    
    while next != nil {
      if next?.value == "-h" || next?.value == "--help" {
        exitImmediately = true
        
        break
      }
      
      next = next?.next
    }
    
    if cmd.hasPrefix("-") {
      return nil
    }
    
    return current
  }
  
}
