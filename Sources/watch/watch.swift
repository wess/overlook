//
//  watch.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation
import config

fileprivate class FileWatch {
  fileprivate static let instance = FileWatch()

  fileprivate let settings = Config()!
  fileprivate var excluding:[String]              = []
  fileprivate var context                         = FSEventStreamContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
  fileprivate let flags                           = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
  fileprivate let callback: FSEventStreamCallback =  { (streamRef, userInfo, numEvents, eventPaths, eventFlags, eventIds) -> Void in
    guard let paths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String],
          let path  = paths.first else { return }
    

    let excludes = FileWatch.instance.excluding.map { $0.lowercased() }
    let filename = path.components(separatedBy: "/").last ?? ""
    let filtered = excludes.filter { $0.lowercased() == filename.lowercased() }
    
    guard filtered.count < 1 else { return }
    
    DispatchQueue.main.async {

      FileWatch.instance.stop()
      FileWatch.instance.handler()
      FileWatch.instance.start(FileWatch.instance.paths, queue: FileWatch.instance.queue, callback: FileWatch.instance.handler)   
    }
  }

  fileprivate var handler:(() -> ()) = {}
  fileprivate var stream:FSEventStreamRef?
  
  fileprivate var isRunning           = false
  fileprivate var paths:[String]      = []
  fileprivate var queue:DispatchQueue = DispatchQueue.global()

  fileprivate func start(_ paths:[String], queue:DispatchQueue, callback:@escaping () -> ()) {
    guard isRunning == false else { return }
    
    self.paths   = paths
    self.queue   = queue
    self.handler = callback
    self.stream  = FSEventStreamCreate(kCFAllocatorDefault, FileWatch.instance.callback, &context, (paths as CFArray), FSEventStreamEventId(kFSEventStreamEventIdSinceNow), 0, flags)
    
    if let stream = stream {
      FSEventStreamSetDispatchQueue(stream, queue)
      FSEventStreamStart(stream)
      
      isRunning = true 
    }
  }
  
  fileprivate func stop() {
    guard let stream = stream, isRunning == true else { return }
    
    FSEventStreamStop(stream)
    FSEventStreamInvalidate(stream)
    FSEventStreamRelease(stream)
    
    self.stream = nil
    isRunning   = false
  }
  
  fileprivate func cleanPath(path:String) -> String {
    return ""
  }

  init() {}
}

public func Watch(_ paths:[String], exclude:[String] = [], queue:DispatchQueue = DispatchQueue.global(), callback:@escaping (() -> ())) {
  FileWatch.instance.excluding = exclude
  
  FileWatch.instance.start(paths, queue: queue, callback: callback)
}

public func Watch(stop:Bool) {
  guard stop == true else { return }
  
  FileWatch.instance.stop()
}

