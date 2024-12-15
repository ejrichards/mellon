# mellon
## Speak, friend, and enter 

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
## TODO

```elvish
use github.com/ejrichards/mellon/<module>
```
