# Common acme functions

fn abortonerr(status, msg) {
	if $status != "0" {
		io_println($msg)
		exit(1)
	}
}

fn acme_read(rpath) {
	var fpath = "acme/"+$winid+"/"+$rpath

	var content, status <= 9p read $fpath

	abortonerr($status, format("failed to read 9p path: %s", $fpath))

	return $content
}

fn acme_write(rpath, data) {
	var fpath = "acme/"+$winid+"/"+$rpath

	var _, status <= echo -n $data | 9p write $fpath

	abortonerr($status, format("failed to write to: %s", $fpath))
}

fn acme_fname() {
	var path = "acme/"+$winid+"/tag"

	var tag, status <= 9p read $path

	abortonerr($status, format("Failed to read tag: %s", $path))

	var fname, status <= echo -n $tag | cut -d " " -f1

	abortonerr($status, format("failed to get tag filename: %s", $tag))

	return $fname
}

fn acme_savefile(path, data) {
	var _, status <= test -f $path
	if $status != "0" {
		return format("file exists: %s", $path)
	}

	_, status <= echo -n $data > $path
	if $status != "0" {
		return format("failed to write content: %s", $path)
	}

	return ""
}

fn acme_mktmpfile() {
	var tmp, status <= mktemp /tmp/acme-XXXX
	if $status != "0" {
		return "", format("failed to create tmp file")
	}

	return $tmp, ""
}

# acme_simplefmt is a common formatter routine.
# It could be used to format code for languages that
# support some kind of formatter utility.
# The `fmtfn` parameter is a function that receives
# a file path with the source code as argument
# and return the modified body or an error.
fn acme_simplefmt(fmtfn) {
	var garbage = ()

	fn removeGarbage() {
		for f in $garbage {
			rm -f $f
		}
	}

	var tmpsrc, err <= acme_mktmpfile()
	if $err != "" {
		return $err
	}

	garbage <= append($garbage, $tmpsrc)
	var err <= acme_savefile($tmpsrc, acme_read("body"))
	if $err != "" {
		removeGarbage()
		return $err
	}

	var newbody, err <= $fmtfn($tmpsrc)
	if $err != "" {
		removeGarbage()
		return $err
	}

	var tmpdst, err <= acme_mktmpfile()
	if $err != "" {
		removeGarbage()
		return $err
	}

	garbage <= append($garbage, $tmpdst)

	err <= acme_savefile($tmpdst, $newbody)
	if $err != "" {
		removeGarbage()
		return $err
	}

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

	removeGarbage()
	return ""
}