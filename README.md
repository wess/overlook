# Overlook 

![Swift](http://img.shields.io/badge/swift-3.0-brightgreen.svg)
[![Twitter Follow](https://img.shields.io/twitter/follow/overlookcli.svg?style=social&label=Follow&maxAge=2592000)](https://twitter.com/overlookcli)


A commandline app that will watch your folder and monitor any changes. When a change occurs, *Overlook* will execute (or restart) a command you specify. *Overlook* is platform
independent and will work with anything from writing a README file, to developing a service.

---
### Quick Start
```bash
$ overlook watch -t /folder/to/watch -e /script/to/execute
```
---

### Table of Contents

   * [Requirements](#requirements)
   * [Installation](#installation)
       * [Homebrew](#homebrew)
       * [Via Script](#via-script)
       * [Manual](#manual)
   * [Usage](#usage)
      * [.overlook](#.overlook)
      * [Commandline](#commandline)
   * [To Do](#to-do)
   * [Contributing](#contributing)
   * [License](#license)
	 

---
# Requirements
- Swift 3.0 or up.

# Installation
## Homebrew
```bash
brew install wess/repo/overlook --HEAD
```

## Via Script
```bash
curl -sL wess.io/overlook/install.sh | bash
```

## Build It Yourself
```bash
git clone https://github.com/wess/overlook.git
cd overlook
make release
ln -s .build/release/overlook /usr/local/bin/overlook
```

# Usage
There are 2 ways to use *Overlook*. You can either use it completely on the command line, or setup a _.overlook_ config file.

## .overlook
The _.overlook_ file is a configuration file that defines environment variables, what to ignore, what to watch and what to excute on change. To create a _.overlook_ file in your current directory, simply run:

```bash
$ overlook init
```

This will generate the following file:

```json
{
  "ignore" : [
    ".git",
    ".gitignore",
    ".overlook"
  ],
  "env" : {
    "example" : "variable"
  },
  "execute" : "ls -la",
  "directories" : [
    "build",
    "tests"
  ]
}
```

*Available*
- _*ignore*_ : A list of files or folders that Overlook should ignore changes on.

- _*env*_ : Environment variables _overlook_ can set for you when running/restarting.

- _*execute*_ : A list of commands for _overlook_ to run when a change has been observed.

- _*directories*_ : Directories that should be watched for changes.

---

## Commandline
Overlook can run without a _.overlook_ file. You can run ```overlook help``` for a list of available commands

The main command you will use with _overlook_ will be _watch_. This command is what tells _overlook_ what to watch for changes and what to execute.

The required flags for _overlook watch_ are:
- *e, execute* What is executed when targets are changed.
	
- *h, help* Show help information for this command.



	
- *i, ignore* Comma separated list of files or directories to ignore.
	
- *t, target* Comma separated list of directory or files to monitor.


Example:

```bash
$ overlook watch -t /folder/to/watch -e /script/to/execute
```

# To Do
- Parallel observations/executions
- Task running

# Contributing
Contributions are welcome, just make a pull request. If you are including new functionality, please write a usage example, and include any information that will impact installation and/or setup.

# License
*Overlook* is released under the MIT license. See LICENSE for details.

# Get in touch
- Any questions, comments, concerns? Hit me up on twitter: [@wesscope](https://twitter.com/wesscope)



