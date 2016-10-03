//
//  watch.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation

fileprivate class FileWatch {
    fileprivate static let instance = FileWatch()
    
    fileprivate var context = FSEventStreamContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
    fileprivate let flags   = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
    
    fileprivate let callback: FSEventStreamCallback = {(streamRef: ConstFSEventStreamRef, clientCallBackInfo: UnsafeMutableRawPointer?, numEvents: Int, eventPaths: UnsafeMutableRawPointer, eventFlags: UnsafePointer<FSEventStreamEventFlags>?, eventIds: UnsafePointer<FSEventStreamEventId>?) -> Void in
        DispatchQueue.main.async {
            FileWatch.instance.handler?()
        }
    }
    
    fileprivate var handler:(() -> ())?
    fileprivate var stream:FSEventStreamRef?
    
    fileprivate var isRunning = false
    
    fileprivate func start(_ paths:[String], queue:DispatchQueue, callback:@escaping () -> ()) {
        guard isRunning == false else { return }
        
        handler = callback
        stream = FSEventStreamCreate(kCFAllocatorDefault, FileWatch.instance.callback, &context, (paths as CFArray), FSEventStreamEventId(kFSEventStreamEventIdSinceNow), 0, flags)
        
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
    
    init() {}
}

public func Watch(_ paths:[String], queue:DispatchQueue = DispatchQueue.global(), callback:@escaping (() -> ())) {
    FileWatch.instance.start(paths, queue: queue, callback: callback)
}

public func Watch(stop:Bool) {
    guard stop == true else { return }
    
    FileWatch.instance.stop()
}

