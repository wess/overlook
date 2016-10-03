//
//  exec.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 

func exec(_ arguments:[String]) -> String? {
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
