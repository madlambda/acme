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

fn savefile(path, data) {
	var _, status <= test -f $path

	abortonerr($status, format("file exists: %s", $path))

	_, status <= echo -n $data > $path

	abortonerr($status, format("failed to write content: %s", $path))
}

fn mktmpfile() {
	var tmp, status <= mktemp /tmp/acme-XXXX

	abortonerr($status, "failed to create tmp file")

	return $tmp
}