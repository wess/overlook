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
  let name              = "version"
  let signature         = ""
  let shortDescription  = "Prints the current version of Overlook"

  public func execute(arguments: CommandArguments) throws {
    print("Overlook".green.bold + " Version: " + Overlook.version.bold)
  }
}


