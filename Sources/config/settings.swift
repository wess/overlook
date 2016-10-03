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
  public var directories:[String] = []
}

extension Settings {
  public init(jsonRepresentation dictionary: JSONDictionary) throws {
    directories = try decode(dictionary, key: "directories")
  }
}

