#!/usr/bin/env nash

# universal formatter

import "io"
import "acme/acme.sh"

fn abortonerr(status, msg) {
	if $status != "0" {
		io_println($msg)
		exit(1)
	}
}

fn getext(path) {
	var base, status <= basename $path
	abortonerr($status, "basename failed")

	var parts <= split($base, ".")
	if len($parts) == "1" {
		return ""
	}

	var partsz <= len($parts)
	var last, _ <= expr $partsz "-" 1

	return $parts[$last]
}

fn main() {
	var fname, err <= acme_fname()
	if $err != "" {
		io_println($err)
		exit(1)
	}

	var ext <= getext($fname)

	if $ext == "sh" {
		nashfmt.sh
	} else if $ext == "go" {
		gofmt.sh
	} else {
		io_println("Extension %s not supported", $ext)
		exit(1)
	}
}

main()