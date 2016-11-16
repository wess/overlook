//
//  base.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 
import SwiftCLI 
import config

extension Equatable where Self : Command {}

public func ==(lhs:Command, rhs:Command) -> Bool {
  let left  = lhs.name.lowercased()
  let right = rhs.name.lowercased()
  
  return left == right
}
