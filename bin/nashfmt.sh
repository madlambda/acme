#!/usr/bin/env nash

import "io"
import "acme/acme.sh"

# acme's nash formatter

fn nashfmt(file) {
	var newbody, errmsg, status <= nashfmt $file

	abortonerr($status, format("error: %s", $errmsg))

	return $newbody
}

fn main() {
	simplefmt($nashfmt)
}

main()