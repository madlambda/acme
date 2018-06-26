#!/usr/bin/env nash

import io

fn install(bindir) {
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