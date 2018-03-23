#!/usr/bin/env nash

import "io"
import "acme/acme.sh"

# acme's nash formatter

fn nashfmt(file) {
	var newbody, errmsg, status <= nashfmt $file
	if $status != "0" {
		return "", format("failed to format: %s", $errmsg)
	}

	return $newbody, ""
}

fn main() {
	var err <= acme_simplefmt($nashfmt)
	if $err != "" {
		io_println($err)
		exit(1)
	}
}

main()