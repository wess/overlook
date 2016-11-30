//
//  task.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation
import PathKit
import signals

public class TaskManager {
  public  var verbose:Bool  = true

  private let defaultPath   = "/usr/bin/env"
  private var tasks:[Task]  = []
  private var isFirstRun    = true

  private let lock                    = DispatchSemaphore(value: 1)
  private let taskQueue:DispatchQueue = DispatchQueue(label: "com.overlook.queue")

  static weak var this:TaskManager? = nil

  public init(verbose:Bool = true) {
    self.verbose = verbose
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
    TaskManager.this = self

    signalTrap(.int) { signal in
      TaskManager.this?.kill()

      exit(signal)
    }

    for task in tasks {
      taskQueue.async(execute: task.workItem)
    }
    
    if !verbose {
      if isFirstRun {
        isFirstRun = false
      }
      else {
        print("Overlook has restarted.")
      }
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
        task.workItem.cancel()
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

  public func kill() {
    sync {
      for task in tasks {
        task.workItem.cancel()
        task.stop()
      }
    }
  }

  private func sync(block:((Void) -> Void)) {
    lock.wait()
    block()
    lock.signal()
  }
}
