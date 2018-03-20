#!/usr/bin/env nash

import "io"
import "acme/acme.sh"

fn gofmt(file) {
	var newbody, errmsg, status <= gofmt $file
	if $status != "0" {
		return "", format("failed to format: %s", $errmsg)
	}

	return $newbody, ""
}

fn main() {
	var err <= acme_simplefmt($gofmt)
}

main()