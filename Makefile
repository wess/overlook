
all: build

build:
	@swift build 

install: release
	@mv .build/release/overlook /usr/local/bin/


clean:
	@swift build --clean=dist

xcode:
	@rm -rf overlook.xcodeproject
	@swift package generate-xcodeproj

run: build
	@.build/debug/overlook

release: clean
	@swift build --configuration release
	

