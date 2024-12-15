{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "mellon";
          src = ./.;
          installPhase = ''
            mkdir -p $out/share/elvish/lib/github.com/ejrichards/mellon
            cp *.elv $out/share/elvish/lib/github.com/ejrichards/mellon
          '';
        };
      }
    )
    // {
      nixosModules.default =
        { pkgs, ... }:
        {
          environment.systemPackages = [ self.packages.${pkgs.system}.default ];
          environment.pathsToLink = [ "/share/elvish/lib/github.com/ejrichards" ];
        };
    };
}
