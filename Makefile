
all: build run

build:
	@swift build 

clean: 
	@swift build --clean=dist

run:
	@.build/debug/overlook
