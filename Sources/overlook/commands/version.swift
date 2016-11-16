//
//  version.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 
import SwiftCLI 
import Rainbow

public class VersionCommand : Command {
  public let name              = "version"
  public let signature         = ""
  public let shortDescription  = "Prints the current version of Overlook"

  public func execute(arguments: CommandArguments) throws {
    print("Overlook".green.bold + " Version: " + Overlook.version.bold)
  }
}


