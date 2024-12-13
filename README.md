# mellon
## Speak, friend, and enter 

Modules for [Elvish Shell](https://github.com/elves/elvish)

# Install

```elvish
use epm
epm:install &silent-if-installed=$true github.com/ejrichards/mellon

```

## NixOS

`/etc/nixos/flake.nix`
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

TODO
