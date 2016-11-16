//
//  config.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 
import PathKit 
import json 

public func Config() -> Settings? {
    let current = Path.current + Path(".overlook")

    do {
      let data      = try current.read()
      let json      = try JSONSerialization.jsonObject(with: data) as! JSONDictionary
      let settings  = try Settings(jsonRepresentation: json)

      return settings

    } catch (_) {
        return nil
    }
}
