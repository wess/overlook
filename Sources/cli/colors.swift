//
//  colors.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation 

// fileprivate let ColorsEndabled:Bool = {
//   let arguments = CommandLine.arguments 

//   if arguments.contains("--no-color") || arguments.contains("--color=false") {
//     return false
//   }
    
//   if Process.arguments.contains("--color") || Process.arguments.contains("--color=true") || Process.arguments.contains("--color=always") {
//     return true
//   }
    
//     guard let terminal = String.fromCString(getenv("TERM")) else { return false }
    
//     return terminal.hasPrefix("screen")
//         || terminal.hasPrefix("xterm")
//         || terminal.hasPrefix("vt100")
//         || terminal.containsString("color")
//         || terminal.containsString("ansi")
//         || terminal.containsString("cygwin")
//         || terminal.containsString("linux")
// }()

public enum ColorCode {
  case black
  case red  
  case green
  case yellow
  case blue  
  case magenta
  case cyan   
  case white  

  public var foreground:(Int, Int) {
    switch self {
      case .black:   return (30, 39) 
      case .red:     return (31, 39)
      case .green:   return (32, 39)
      case .yellow:  return (33, 39)
      case .blue:    return (34, 39)
      case .magenta: return (35, 39)
      case .cyan:    return (36, 39)
      case .white:   return (37, 39)
    }
  }

  public var background:(Int, Int) {
    switch self {
      case .black:   return (40, 49) 
      case .red:     return (41, 49)
      case .green:   return (42, 49)
      case .yellow:  return (43, 49)
      case .blue:    return (44, 49)
      case .magenta: return (45, 49)
      case .cyan:    return (46, 49)
      case .white:   return (47, 49)
    }
  }
}

public enum StyleCode {
  case off
  case bold
  case dim 
  case italic
  case underline
  case inverse  
  case hidden   
  case strikethrough

  var rawValue:(Int, Int) {
    switch self {
      case .off:           return (0, 0)
      case .bold:          return (1, 22)
      case .dim:           return (2, 22)
      case .italic:        return (3, 23)
      case .underline:     return (4, 24)
      case .inverse:       return (7, 27)
      case .hidden:        return (8, 28)
      case .strikethrough: return (9, 29)
    }
  }
}

public extension String {
  public func paint(_ color:ColorCode) -> String {  
    return apply(color.foreground)
  }

  public func paint(color:ColorCode) -> String {  
    return apply(color.foreground)
  }

  public func paint(background:ColorCode) -> String {
    return apply(background.background)
  }

  public func style(style:StyleCode) -> String {
    return apply(style.rawValue)
  }

  private func apply(_ code: (Int, Int), enabled:Bool = true) -> String {
    guard enabled == true else { return self }

    return "\u{001b}[\(code.0)m\(self)\u{001b}[\(code.1)m"
  }


}


