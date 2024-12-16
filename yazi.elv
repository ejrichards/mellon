use os
use str
use file

fn y {|@argv|
	var tmp = (os:temp-file)
	yazi $@argv --cwd-file=$tmp[name]
	var cwd = (str:trim-space (slurp < $tmp))
	file:close $tmp
	os:remove $tmp[name]
	if (and (not-eq $cwd '') (not-eq $cwd $pwd)) {
		cd $cwd
	}
}
