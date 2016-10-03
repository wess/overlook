//
//  task.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation
import PathKit 

public typealias TaskHandler = ((Data) -> Void)

public class TaskSource {
  private let callback:TaskHandler
  private let source:DispatchSourceRead
  private let queue:DispatchQueue = DispatchQueue(label: "com.overlook.tasks.queue")
  private var output:Pipe         = Pipe()
  private let MaxBuffer           = 4096
  
  private var process:Process?
  private let path:String           = "/usr/bin/env"
  private var arguments:[String]    = []

  public init(_ arguments:[String], callback:@escaping TaskHandler) {
    self.arguments  = arguments
    self.callback   = callback
    
    source = DispatchSource.makeReadSource(fileDescriptor: output.fileHandleForReading.fileDescriptor, queue: queue)

    output.fileHandleForReading.readabilityHandler = { [weak self] handle in
      guard let `self` = self else { return }

      DispatchQueue.main.async {
        self.callback(handle.availableData)
      }
    }
    
    source.resume()
  }

  private func createProcess() -> Process {
    let process            = Process()
    process.launchPath     = self.path
    process.arguments      = self.arguments
    process.standardOutput = self.output

    return process
  }
  
  public func launch() {
    self.process = self.process ?? createProcess()

    guard let process = self.process else { return }

    process.terminationHandler = { [weak self] process in
      guard let `self` = self else { return }
      
      let handle  = self.output.fileHandleForReading
      let data    = handle.readDataToEndOfFile()

      DispatchQueue.main.async {
        self.callback(data)
      }

      self.source.cancel()
    }

    process.launch()
  }

  public func terminate() {
    source.suspend()
    source.cancel()

    guard let process = process else { return }

    process.interrupt()
    process.suspend()
    process.terminate()

    self.process = nil 
  }
}

public func task(_ arguments:[String], callback: @escaping TaskHandler) -> TaskSource {
  return TaskSource(arguments, callback: callback)
}






