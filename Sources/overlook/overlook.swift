//
//  overlook.swift
//  overlook
//
//  Created by Wesley Cope on 9/30/16.
//
//

import Foundation
import SwiftCLI
import PathKit
import Rainbow
import config
import env

public class Overlook {
  static let name           = "overlook"
  static let version        = "0.1.1"
  static let desc           = "File monitoring tool that excutes on change. Used anywhere."

  static let dotTemplate:[String:Any] = [
    "env"         : ["example" : "variable"],
    "verbose"     : true,
    "ignore"      : [".git", ".gitignore", ".overlook",],
    "directories" : ["build", "tests",],
    "execute"     : "ls -la",
  ]

  private lazy var helpCommand:HelpCommand        = HelpCommand()
  private lazy var versionCommand:VersionCommand  = VersionCommand()
  private lazy var defaultCommand:DefaultCommand  = DefaultCommand()
  private lazy var initCommand:InitCommand        = InitCommand()
  private lazy var adhocCommand:AdhocCommand      = AdhocCommand()
  private lazy var router:OverlookRouter          = OverlookRouter(self.defaultCommand)

  private var runOnce:[Command] {
    return [
      helpCommand,
      versionCommand,
      initCommand,
    ]
  }

  public init() {
    CLI.setup(name: Overlook.name, version: Overlook.version, description: Overlook.desc)

    setupRouter()
    setupCommands()
    setupAliases()
  }

  private func setupRouter() {
    CLI.router = self.router
  }

  private func setupCommands() {
    CLI.versionCommand  = versionCommand
    CLI.helpCommand     = helpCommand

    CLI.register(command: initCommand)
    CLI.register(command: adhocCommand)
  }

  private func setupAliases() {
    CLI.alias(from: "-h",     to: "help")
    CLI.alias(from: "--help", to: "help")

    CLI.alias(from: "-v",         to: "version")
    CLI.alias(from: "--version",  to: "version")


    CLI.alias(from: "-i",     to: "init")
    CLI.alias(from: "--init", to: "init")

    CLI.alias(from: "-w",       to: "watch")
    CLI.alias(from: "--watch",  to: "watch")
  }

  public func run() {
    let result = CLI.go()

    guard result == CLIResult.success else {
      exit(result)
    }

    guard self.router.exitImmediately == false else {
      exit(result)
    }

    guard runOnce.contains(where: { $0 == self.router.current } ) else {
      dispatchMain()
    }

    exit(result)
  }
}

public func startup(_ run:String, watching:[String]) {
    let executing = "executing: "
    let target    = run.bold

    print("\nStarting Overlook...".green.bold)
    print(executing + target.bold)
    print("watching:")

    for directory in watching {
      print("  ", directory.bold)
    }

    print("")
  }





