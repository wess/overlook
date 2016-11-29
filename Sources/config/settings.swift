//
//  settings.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 
import json
import PathKit

public struct Settings {
  public var verbose:Bool             = true
  public var envVars:[String:String]  = [:]
  public var ignore:[String]          = []
  public var directories:[String]     = []
  public var routes:[String:String]   = [:]
  public var execute:String           = ""
  
  public var paths:[Path] {
    return directories.map { Path($0).absolute() }
  }
}

extension Settings {
  public init(jsonRepresentation dictionary: JSONDictionary) throws {
    envVars     = try decode(dictionary, key: "env")
    verbose     = try decode(dictionary, key: "verbose")
    ignore      = try decode(dictionary, key: "ignore")
    directories = try decode(dictionary, key: "directories")
    routes      = try decode(dictionary, key: "routes")
    execute     = try decode(dictionary, key: "execute")
  }
}

