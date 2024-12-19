use math
use os
use file
use str

set-env ATUIN_SESSION (atuin uuid)
unset-env ATUIN_HISTORY_ID

set edit:after-readline = [$@edit:after-readline {|line|
	try {
		set-env ATUIN_HISTORY_ID (atuin history start -- $line)
	} catch e {
		unset-env ATUIN_HISTORY_ID
	}
}]

set edit:after-command = [$@edit:after-command {|m|
	if (has-env ATUIN_HISTORY_ID) {
		var exit-status = 0
		if (not-eq $m[error] $nil) {
			if (has-key $m[error][reason] exit-status) {
				set exit-status = $m[error][reason][exit-status]
			} else {
				set exit-status = 127
			}
		}
		var duration = (exact-num (math:round (* $m[duration] 1000000000)))

		with E:ATUIN_LOG = 'error' { atuin history end --exit $exit-status --duration=$duration -- $E:ATUIN_HISTORY_ID >$os:dev-null 2>&1 & }

		unset-env ATUIN_HISTORY_ID
	}
}]

fn search {|@argv|
	var accept-prefix = '__atuin_accept__:'

	var p = (file:pipe)
	# TODO: Will need an elvish flag in Atuin binary
	with [E:ATUIN_LOG = 'error'] [E:ATUIN_SHELL_BASH = t] [E:ATUIN_QUERY = $edit:current-command] {
		atuin search $@argv -i >$os:dev-tty 2>$p; edit:redraw &full=$true
	}
	file:close $p[w]
	var command = (str:trim-space (slurp < $p))
	file:close $p[r]

	if (not-eq $command '') {
		if (str:has-prefix $command $accept-prefix) {
			edit:replace-input (str:trim-prefix $command $accept-prefix)
			edit:return-line
		} else {
			edit:replace-input $command
		}
	}
}

fn search-up {
	search --shell-up-key-binding
}
