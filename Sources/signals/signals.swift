//
//  signals.swift
//  overlook
//
//  Created by Wesley Cope on 11/29/16.
//
//

import Foundation
import Darwin

public enum Signal {
  case hup
  case int
  case quit
  case abrt
  case kill
  case alrm
  case term
  case user(Int)

  public static var all:[Signal] = [.hup, .int, .quit, .abrt, .kill, .alrm, .term,]

  public var rawValue:Int32 {
    switch self {
      case .hup:            return Int32(SIGHUP)
      case .int:            return Int32(SIGINT)
      case .quit:           return Int32(SIGQUIT)
      case .abrt:           return Int32(SIGABRT)
      case .kill:           return Int32(SIGKILL)
      case .alrm:           return Int32(SIGALRM)
      case .term:           return Int32(SIGTERM)
      case .user(let sig):  return Int32(sig)
    }
  }
}

public typealias SignalHandler = @convention(c)(Int32) -> Void

public func signalTrap(_ signal:Signal, handler:SignalHandler) {
    var signalAction  = sigaction(__sigaction_u: unsafeBitCast(handler, to: __sigaction_u.self), sa_mask: 0, sa_flags: 0)
        _             = withUnsafePointer(to: &signalAction) { actionPointer in

        Darwin.sigaction(signal.rawValue, actionPointer, nil)
    }
}
