# mellon - Speak, friend, and enter

Modules for [Elvish Shell](https://github.com/elves/elvish)

# Install

```elvish
use epm
epm:install &silent-if-installed=$true github.com/ejrichards/mellon

```

## NixOS

`flake.nix` supplies a NixOS module that lets you import in the same manner as `epm`

```nix
{
  inputs = {
    mellon.url = "github:ejrichards/mellon";
  };

  outputs = {
    mellon,
    ...
  }:
  {
    ...
    nixosConfigurations = {
      modules = [
        mellon.nixosModules.default
      ];
    };
}
```

# Usage

```elvish
use github.com/ejrichards/mellon/<module>
```

## `fzf.elv`

Add bindings for `Ctrl-r` and `Up` to use fzf for searching history.
```elvish
if (has-external fzf) {
	use github.com/ejrichards/mellon/fzf
	set edit:insert:binding[Ctrl-r] = { fzf:history }
	set edit:insert:binding[Up] = { fzf:history }
}
```

## `yazi.elv`

Add an alias `y` that will `cd` on quit.
```elvish
if (has-external yazi) {
	use github.com/ejrichards/mellon/yazi
	edit:add-var y~ $yazi:y~
}
```
