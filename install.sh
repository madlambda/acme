#!/usr/bin/env nash

import io

fn install_go_tools() {
	io_println("installing Go tools")
	
	go get -u github.com/madlambda/A
	go get -u golang.org/x/tools/cmd/guru
	go get -u github.com/zmb3/gogetdoc
	go get -u github.com/godoctor/godoctor
	go get -u github.com/josharian/impl
	go get -u golang.org/x/tools/cmd/gorename
	go get -u github.com/fatih/gomodifytags
	go get -u github.com/davidrjenni/reftools/cmd/fillstruct
	go get -u github.com/davidrjenni/reftools/cmd/fillswitch
	go get -u golang.org/x/tools/cmd/goimports
}

fn install(bindir) {
	install_go_tools()
	
	io_println("installing acme nash lib")

	nash -install ./acme

	io_println("installing binaries at %s", $bindir)

	mkdir -p $bindir

	var bin, err <= glob("./bin/*")

	if $err != "" {
		io_println("fatal error %s running glob", $err)
		exit("1")
	}

	for b in $bin {
		io_println("installing %s", $b)

		cp $b $bindir
	}

	io_println("done")
}

if len($ARGS) == "2" {
	install($ARGS[1])
	
	return
}
if $PLAN9 == "" {
	io_println("if no install dir is provided the PLAN9 environment var must be exported")
	exit("1")
}

var bindir <= format("%s/acme/edit", $PLAN9)

install($bindir)