
all: build run

build: xcode
	@swift build 

clean:
	@swift build --clean=dist

xcode:
	@rm -rf overlook.xcodeproject
	@swift package generate-xcodeproj

run: build
	@.build/debug/overlook

version: build
	@.build/debug/overlook version 

help: build
	@.build/debug/overlook help

release: clean
	@swift build --configuration release
	

