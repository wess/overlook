
all: build run

build: xcode clean
	@swift build 

clean:
	@swift build --clean=dist

xcode:
	@rm -rf overlook.xcodeproject
	@swift package generate-xcodeproj

run:
	@.build/debug/overlook


release: clean
	@swift build --configuration release
	

