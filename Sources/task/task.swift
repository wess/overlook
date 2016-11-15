//
//  task.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation
import PathKit

public typealias TaskHandler      = ((Data) -> Void)
internal let MAX_BUFFER           = 4096


public class Task : Equatable, NSCopying {

  public var identifier:Int32 {
    return process.processIdentifier
  }

  public var isRunning:Bool {
    return process.isRunning
  }

  public var workItem:DispatchWorkItem {
    return DispatchWorkItem { [weak self] in
      guard let `self` = self else { return }
      
      self.start()
    }
  }
  
  public let callback:TaskHandler
  public let path:String
  public let arguments:[String]
  public lazy var process:Process = {
    $0.launchPath         = self.path
    $0.arguments          = self.arguments
    $0.standardOutput     = self.output
    $0.terminationHandler = self.terminationHandler
    
    return $0
  }(Process())
  
  private(set) var output:Pipe? = Pipe()
  private let maxBuffer         = MAX_BUFFER
  
  private var handleBlock:((FileHandle) -> Void) {
    return { [weak self] handle in
      guard let `self` = self else { return }
      
      DispatchQueue.main.async {
        self.callback(handle.availableData)
      }
    }
  }
  
  private var terminationHandler:((Process) -> Void) {
    return { [weak self] process in
      guard let `self` = self, let handle = self.output?.fileHandleForReading else { return }
      
      let data = handle.readDataToEndOfFile()
      
      DispatchQueue.main.async {
        self.callback(data)
        handle.closeFile()
      }
    }
  }
  
  public init(arguments:[String], path:String, callback: @escaping TaskHandler) {
    self.arguments  = arguments
    self.path       = path
    self.callback   = callback
  }
  
  public func copy(with zone: NSZone? = nil) -> Any {
    return Task(arguments: self.arguments, path: self.path, callback: self.callback)
  }
  
  public func start() {
    output = output ?? Pipe()

    guard let output = self.output else { fatalError("Unable to create task output") }
    
    output.fileHandleForReading.readabilityHandler = handleBlock
    
    process.launch()
  }
  
  public func stop() {
    process.interrupt()
    process.terminate()
    process.waitUntilExit()
  }
}

public func ==(lhs:Task, rhs:Task) -> Bool {
  return lhs.identifier == rhs.identifier
}


