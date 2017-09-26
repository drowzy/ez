.PHONY: build clean test

build:
	jbuilder build @install
	jbuilder build bin/main.exe

deps:
	jbuilder external-lib-deps --missing @install
clean:
	jbuilder clean

test:
	jbuilder runtest
