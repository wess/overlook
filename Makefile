
all: build run

build:
	@swift build 
	@swift package generate-xcodeproj

clean: 
	@swift build --clean=dist
	@rm -rf overlook.xcodeproj

run:
	@.build/debug/overlook
