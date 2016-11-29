//
//  init.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation
import SwiftCLI
import PathKit
import Rainbow

public class InitCommand : Command {
  public let name              = "init"
  public let signature         = ""
  public let shortDescription  = "Prints the current version of Overlook"

  public func execute(arguments: CommandArguments) throws {
    let data = try JSONSerialization.data(withJSONObject: Overlook.dotTemplate, options: .prettyPrinted)
    let path = Path.current + Path(".overlook")

    try path.write(data)
  }
}
