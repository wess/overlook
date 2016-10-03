//
//  config.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 
import PathKit 
import JSON 

public func Config() -> Settings? {
    let current = Path.current + Path(".overlook")
    let data    = try! current.read()
    let json    = try! JSONSerialization.jsonObject(with: data) as! JSONDictionary

    do {
      let settings = try Settings(jsonRepresentation: json)

      return settings

    } catch (let err) {
        fatalError("\(err)")
    }
}