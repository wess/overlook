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
  
  private lazy var process:Process = {
    $0.launchPath      = self.path
    $0.arguments       = self.arguments
    $0.standardOutput  = self.output

    return $0
  }(Process())

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
  
  @discardableResult
  public func launch() -> TaskSource {
    if process.isRunning {
      terminate()
    }
    
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
    process.waitUntilExit()
    
    return self
  }

  public func terminate() {
    source.suspend()
    source.cancel()
    process.interrupt()
    process.suspend()
    process.terminate()
  }
}

public func task(_ arguments:[String], callback: @escaping TaskHandler) -> TaskSource {
  let source = TaskSource(arguments, callback: callback)
  
  return source
}






