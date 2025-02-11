{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      systems,
      nixpkgs,
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.stdenv.mkDerivation {
            name = "mellon";
            src = ./.;
            installPhase = ''
              mkdir -p $out/share/elvish/lib/github.com/ejrichards/mellon
              cp *.elv $out/share/elvish/lib/github.com/ejrichards/mellon
            '';
          };
        }
      );

      nixosModules.default =
        { pkgs, ... }:
        {
          environment.systemPackages = [ self.packages.${pkgs.system}.default ];
          environment.pathsToLink = [ "/share/elvish/lib/github.com/ejrichards" ];
        };
    };
}
