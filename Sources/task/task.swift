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

internal let MAX_BUFFER = 4096

fileprivate let DefaultTaskQueue = DispatchQueue(label: "com.overlook.tasks.queue")

public class Task : Equatable, NSCopying {

  public var identifier:Int32 {
    guard let process = process else { return -1 }
    
    return process.processIdentifier
  }

  public let queue:DispatchQueue
  public let callback:TaskHandler 
  public var source:DispatchSourceRead?
  public let path:String
  public let arguments:[String]

  public var process:Process? = Process()
  public let output:Pipe      = Pipe()
  private let maxBuffer       = MAX_BUFFER
  
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
      guard let `self` = self else { return }
      
      let handle  = self.output.fileHandleForReading
      let data    = handle.readDataToEndOfFile()
      
      DispatchQueue.main.async {
        self.callback(data)
      }
      
      self.source?.cancel()
    }
  }
  
  public init(arguments:[String], queue:DispatchQueue = DefaultTaskQueue, path:String = "/usr/bin/env", callback: @escaping TaskHandler) {
    self.arguments  = arguments 
    self.queue      = queue 
    self.path       = path 
    self.callback   = callback
    self.source     = DispatchSource.makeReadSource(fileDescriptor: output.fileHandleForReading.fileDescriptor, queue: queue)
    
    
    self.output.fileHandleForReading.readabilityHandler = handleBlock
    self.process?.terminationHandler                    = terminationHandler
  }
  
  deinit {
    stop()
  }
  
  public func copy(with zone: NSZone? = nil) -> Any {
    return Task(arguments: self.arguments, queue: self.queue, path: self.path, callback: self.callback)
  }

  public func start() {
    source?.resume()
    process?.launch()
  }
  
  public func stop() {
    process?.interrupt()
    process?.suspend()
    process?.terminate()
    
    process = nil
    
    source?.suspend()
    source?.cancel()
    
    source = nil
  }
}

public func ==(lhs:Task, rhs:Task) -> Bool {
  return lhs.identifier == rhs.identifier
}

public class TaskManager {
  private var tasks:[Task] = []

  func add(_ task:Task) {
    var current = tasks.filter { $0 != task }
    current.append(task)
    
    tasks = current
  }
  
  func create(_ arguments:[String], callback: @escaping TaskHandler) -> Task {
    let task = Task(arguments: arguments, callback: callback)
  
    add(task)
    
    return task
  }
  
  func start(task:Task) {
    let filtered = tasks.filter { $0 == task }
    
    for task in filtered {
      task.start()
    }
  }
  
  func start() {
    for task in tasks {
      task.start()
    }
  }

  func restart() {
    var current = tasks
    
    for (index, task) in tasks.enumerated() {
      task.stop()
      
      let copy = task.copy() as! Task
      
      current.remove(at: index)
      current.append(copy)
      
      copy.start()
    }
  }

  
  func stop(task:Task) {
    let filtered = tasks.filter { $0 == task }
    
    for task in filtered {
      task.stop()
    }
  }
  
  func remove(task:Task) {
    var current       = tasks
    let filtered      = current.filter { $0 == task }
    
    for (index, task) in filtered.enumerated() {
      task.stop()
      
      current.remove(at: index)
    }
    
    tasks = current
  }
}

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






