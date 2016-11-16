//
//  default.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import SwiftCLI

class OverlookRouter: Router {
    
    func route(commands: [Command], aliases: [String : String], arguments: RawArguments) -> Command? {

        return DefaultCommand()
    }
    
}
