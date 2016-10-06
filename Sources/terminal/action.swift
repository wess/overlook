//
//  action.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 

public typealias ActionHandler = (_:[String:String]) -> Void

public struct Action {
  public let name:String 
  public let flags:[String]
  public let description:String?
  public let handler:ActionHandler

  public init(name:String, flags:[String], description:String? = nil, handler: @escaping ActionHandler) {
    self.name         = name
    self.flags        = flags
    self.description  = description
    self.handler      = handler 
  }
}
