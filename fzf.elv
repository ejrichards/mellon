use str
use store

fn history {|&edit-key='tab' &delete-key='ctrl-d' &down-exit=$true @argv|
	tmp E:SHELL = 'elvish'

	var fzf-args = [
		--no-multi
		--no-sort
		--read0
		--print0
		--info-command="print History"
		--scheme=history
		--query=$edit:current-command
		$@argv
	]

	if (not-eq $edit-key $nil) {
		set fzf-args = [$@fzf-args --expect=$edit-key]
	}
	if (not-eq $delete-key $nil) {
		set fzf-args = [$@fzf-args --expect=$delete-key]
	}
	if $down-exit {
		set fzf-args = [$@fzf-args --bind 'down:transform:if (<= $E:FZF_POS 1) { print abort } else { print down }']
	}

	var key line @ignored = (str:split "\x00" (
		edit:command-history &dedup &newest-first |
		each {|cmd| printf "%s %s\x00" $cmd[id] $cmd[cmd] } |
		try {
			fzf $@fzf-args | slurp
		} catch {
			edit:redraw &full=$true
			return
		}
	))
	edit:redraw &full=$true

	var id command = (str:split &max=2 ' ' $line)

	if (eq $key $delete-key) {
		store:del-cmd $id
		edit:notify 'Deleted '$id
	} else {
		edit:replace-input $command

		if (not-eq $key $edit-key) {
			edit:return-line
		}
	}
}
