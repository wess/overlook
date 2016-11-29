//
//  task.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation
import PathKit 

public class TaskManager {
  private let defaultPath:String

  private(set) var tasks:[Task]       = []
  private let lock                    = DispatchSemaphore(value: 1)
  private let taskQueue:DispatchQueue = DispatchQueue(label: "com.overlook.queue")
  
  public init(_ path:String = "/usr/bin/env") {
    self.defaultPath = path
  }
  
  public func add(_ task:Task) {
    sync {
      var current = tasks.filter { $0 != task }
      current.append(task)
    
      tasks = current
    }
  }
  
  @discardableResult
  public func create(_ arguments:[String], callback: @escaping TaskHandler) -> Task {
    let task  = Task(arguments: arguments, path: defaultPath, callback: callback)
  
    add(task)
    
    return task
  }
  
  public func start(task:Task) {
    let filtered = tasks.filter { $0 == task }
    
    for task in filtered {
      task.start()
    }
  }
  
  public func start() {
    for task in tasks {
      taskQueue.async(execute: task.workItem)
    }
  }

  public func restart() {
    sync {
      let current = tasks
      
      for task in current {
        while(task.isRunning) {
          task.workItem.cancel()
          task.stop()
        }
      }
      
      tasks.removeAll()
      
      tasks = current.map { $0.copy() as! Task }

      start()
    }
  }

  
  public func stop(task:Task) {
    sync {
      let filtered = tasks.filter { $0 == task }
      
      for task in filtered {
        task.stop()
      }
    }
  }
  
  public func remove(task:Task) {
    sync {
      var current       = tasks
      let filtered      = current.filter { $0 == task }
      
      for (index, task) in filtered.enumerated() {
        task.workItem.cancel()
        task.stop()
        
        current.remove(at: index)
      }
      
      tasks = current
    }
  }
  
  private func sync(block:((Void) -> Void)) {
    lock.wait()
    block()
    lock.signal()
  }
}
