#!/usr/bin/env nash

import "io"
import "acme/acme.sh"

fn gofmt(file) {
	var newbody, errmsg, status <= gofmt $file

	abortonerr($status, $errmsg)

	return $newbody
}

fn main() {
	simplefmt($gofmt)
}

main()