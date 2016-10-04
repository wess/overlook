//
//  settings.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 
import json 

public struct Settings {
  public var envVars:[String:String]  = [:]
  public var verbose:Bool             = true
  public var ignore:[String]          = []
  public var directories:[String]     = []
  public var execute:[String]         = []
}

extension Settings {
  public init(jsonRepresentation dictionary: JSONDictionary) throws {
    envVars     = try decode(dictionary, key: "env")
    verbose     = try decode(dictionary, key: "verbose")
    ignore      = try decode(dictionary, key: "ignore")
    directories = try decode(dictionary, key: "directories")
    execute     = try decode(dictionary, key: "execute")
  }
}

