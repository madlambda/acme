# Common acme functions

fn acme_read(rpath) {
	var fpath = "acme/"+$winid+"/"+$rpath

	var content, status <= 9p read $fpath

	if $status != "0" {
		return "", format("failed to read 9p path: %s", $fpath)
	}

	return $content, ""
}

fn acme_write(rpath, data) {
	var fpath = "acme/"+$winid+"/"+$rpath

	var _, errmsg, status <= echo -n $data | 9p write $fpath

	if $status != "0" {
		return format("failed to write to: (%s): %s", $fpath, $errmsg)
	}

	return ""
}

fn acme_fname() {
	var path = "acme/"+$winid+"/tag"

	var tag, status <= 9p read $path

	if $status != "0" {
		return "", format("Failed to read tag: %s", $path)
	}

	var fname, status <= echo -n $tag | cut -d " " -f1

	if $status != "0" {
		return "", format("failed to get tag filename: %s", $tag)
	}

	return $fname, ""
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

# acme_mktmpfile creates a temporary file and returns the path name
# and an error (if any)
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
	var tmpsrc, err <= acme_mktmpfile()

	if $err != "" {
		return $err
	}

	fn clean() {
		rm -f $tmpsrc
	}

	var body, err <= acme_read("body")

	if $err != "" {
		clean()
		
		return $err
	}

	var err <= acme_savefile($tmpsrc, $body)

	if $err != "" {
		clean()
		
		return $err
	}

	var newbody, err <= $fmtfn($tmpsrc)

	clean()

	if $err != "" {
		return $err
	}
	if $body != $newbody {
		# code changed, we need to update buffer
		var operations = (
			("ctl" "mark")
			("ctl" "nomark")
			("addr" ",")
			("data" $newbody)
			("ctl" "mark")
			("addr" "#0")
			("ctl" "dot=addr")
			("ctl" "show")
		)
		
		for op in $operations {
			var err <= acme_write($op[0], $op[1])
		
			if $err != "" {
				return $err
			}
		}
	}

	return ""
}

fn acme_put() {
	return acme_write("ctl", "put")
}