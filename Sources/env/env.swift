//
//  env.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 
import PathKit 

public struct Env {
  public let path:Path

  public init() {
    self.init(Path.current)
  }

  public init(_ path:String) {
    self.init(Path(path))
  }

  public init(_ path:Path) {
    self.path = path

    setup()
  }

  private func setup() {
    var path = ProcessInfo.processInfo.environment["PATH"] ?? ""
    path    += ":\(Path.current.absolute())"
    
    set("PATH", value: path)
  }

  @discardableResult
  private func exec(_ arguments:[String]) -> String? {
    let pipe                = Pipe()
    let process             = Process()
    process.launchPath      = "/usr/bin/env"
    process.arguments       = arguments
    process.standardOutput  = pipe

    process.launch()

    let handle  = pipe.fileHandleForReading
    let data    = handle.readDataToEndOfFile()

    return String(data: data, encoding: .utf8)
  }
}

extension Env /* Get/Set */ {
  public func get(_ key:String) -> String? {
    return ProcessInfo.processInfo.environment[key]
  }
  
  public func set(_ key:String, value:String) {
    set(key, value:value, override:true)
  }

  public func set(_ key:String, value:String, override:Bool = true) {
    setenv(key, value, override ? 1 : 0)
  }
  
  public func delete(_ key:String) {
    unsetenv(key)
  }
}

extension Env /* subscript */ {
  
  public subscript(key:String) -> String? {
    get {
      return self.get(key)
    }
  
    set {
      guard let newValue = newValue else {
        self.delete(key)
        return
      }
      
      self.set(key, value: newValue)
    }
  }
}



