//
//  default.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 
import SwiftCLI 

class DefaultCommand : Command {
  let name              = ""
  let signature         = "[<optional>] ..."
  let shortDescription  = ""

  func execute(arguments: CommandArguments) throws {
    print("Args: ", arguments)
  }
}


