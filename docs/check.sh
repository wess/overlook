#!/bin/bash

SWIFTC=`which swift`
SWIFTV=`swift --version`
OS=`uname`

if [[ $SWIFTC == "" ]];
  then
  echo "❌ Unable to locate a swift installation."
  echo ""
  echo "Swift 3 is required to install Overlook."
  echo "For more information on Swift, visit Swift.org"
  echo ""
  exit 1;
fi

if [[ $OS == "Darwin" ]]; # macOS
then
    XCBVERSION=`xcodebuild -version`
    if [[ $XCBVERSION != *"Xcode 8"* ]];
    then
        echo "⚠️  It looks like your Command Line Tools version is incorrect."
        echo ""
        echo "Open Xcode and make sure the correct SDK is selected:"
        echo "👀  Xcode > Preferences > Locations > Command Line Tools"
        echo ""
        echo "Correct: Xcode 8.x (Any Build Number)"
        echo "Current: $XCBVERSION"
        echo ""
        help
        exit 1;
    fi
fi

if [[ $SWIFTV == *"3.0"* ]];
then
    echo "✅  Compatible"
    exit 0;
else    
    echo "❌  Incompatible"
    echo "Reason: Swift 3.0 is required."
    echo ""
    echo "'swift --version' output:"
    echo $SWIFTV
    echo ""
    echo "Output does not contain '3.0'."
    echo ""
    help
    exit 1;
fi
