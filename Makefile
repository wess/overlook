
all: build run

build: xcode
	@swift build 

clean:
	@swift build --clean=dist
	@rm -rf overlook.xcodeproject

xcode:
	@swift package generate-xcodeproj

run:
	@.build/debug/overlook
