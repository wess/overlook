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
import Rainbow

public func Config() -> Settings? {
    let current = Path.current + Path(".overlook")

    do {
      let data      = try current.read()
      let json      = try JSONSerialization.jsonObject(with: data) as! JSONDictionary
      let settings  = try Settings(jsonRepresentation: json)

      return settings

    } catch (let err) {
        fatalError(err.localizedDescription)
    }
}
