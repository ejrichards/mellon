{
  outputs = _: {
    nixosModules.default = _: {
      environment.etc."mellon/elvish/lib/github.com/ejrichards/mellon/fzf.elv".source = ./fzf.elv;

      environment.variables = {
        XDG_DATA_DIRS = "/etc/mellon";
      };
    };
  };
}
