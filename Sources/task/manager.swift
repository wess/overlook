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
  private let defaultPath   = "/usr/bin/env"
  private var tasks:[Task]  = []

  private let lock        = DispatchSemaphore(value: 1)
  private let taskQueue   = DispatchQueue(label: "com.overlook.task.queue")
  private let group       = DispatchGroup()
  
  public init() {}
  
  public func add(_ task:Task) {
    sync {
      var current = tasks.filter { $0 != task }
      current.append(task)
    
      tasks = current
    }
  }
  
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
    sync {
      group.enter()
      
      taskQueue.async(group: group, execute: DispatchWorkItem(block: { [weak self] in
        guard let `self` = self else { fatalError("\(#function) - No self") }
        
        for task in self.tasks {
          task.start()
        }
      }))
      
      group.leave()
    }
  }

  public func restart() {
    
    let current = tasks
    
    for task in current {
      task.stop()
    }
    
    tasks.removeAll()
    
    tasks = current.map { $0.copy() as! Task }
    
    start()
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
