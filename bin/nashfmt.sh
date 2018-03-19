#!/usr/bin/env nash

import "io"
import "acme/acme.sh"

# acme's nash formatter

fn main() {
	var tmpsrc <= mktmpfile()
	var body <= acme_read("body")

	savefile($tmpsrc, $body)

	var newbody, errmsg, status <= nashfmt $tmpsrc

	abortonerr($status, $errmsg)

	var tmpdst <= mktmpfile()

	savefile($tmpdst, $newbody)

	var _, status <= cmp -s $tmpsrc $tmpdst

	if $status != "0" {
		# code changed, we need to update buffer
		
		# mark cancel any previous nomark of user
		acme_write("ctl", "mark")
		
		# nomark disables 'marking', that means that
		# the future changes to the body could be undone
		# by a single Undo operation.
		acme_write("ctl", "nomark")
		acme_write("addr", ",")
		acme_write("data", $newbody)
		acme_write("ctl", "mark")
		
		# put us at the top of the file, rather than the bottom
		acme_write("addr", "#0")
		acme_write("ctl", "dot=addr")
		acme_write("ctl", "show")
	}

	rm -f $tmpsrc $tmpdst
}

main()