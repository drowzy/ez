.PHONY: build clean test

build:
	jbuilder build @install
	jbuilder build bin/cli/main.exe
	jbuilder build bin/compiler_service/ez_cs.exe
deps:
	jbuilder external-lib-deps --missing @install
clean:
	jbuilder clean

test:
	jbuilder runtest
