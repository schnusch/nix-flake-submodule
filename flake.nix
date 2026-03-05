{
  inputs = {
    nixpkgs = { };
  };

  outputs =
    { self, nixpkgs }:
    {
      apps."x86_64-linux".default = {
        type = "app";
        program = toString (
          (import nixpkgs {
            system = "x86_64-linux";
          }).writeShellScript
            "ls-flake"
            ''
              find ${./.} -exec ls -dhlp {} +
            ''
        );
      };
    };
}
