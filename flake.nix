{
  description = "Node development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
    }:
    # instead of duplicating the same configuration for every system
    # eachDefaultSystem will iterate over the default list of systems
    # and then map the outputs of devShells = { default } to devShells = { <system> = default }
    #
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          system = system;
          config = {
            allowUnfree = true;
          };
        };
        prisma-engines = (import ./nix/prisma-engines { inherit pkgs; });
        addCorepack = import "${nixpkgs}/pkgs/development/web/nodejs/corepack.nix";
        nodejs = pkgs.nodejs_20;
        corepack-enable = pkgs.hiPrio (pkgs.callPackage addCorepack { nodejs = nodejs; });
      in
      {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              # put packages for development shells here
              nodejs
              corepack-enable
              pkgs.yarn
              pkgs.pnpm
              pkgs.jq
              # needed for node-gyp
              pkgs.python3
              pkgs.openssl
              prisma-engines
              #pkgs.imagemagick
              #pkgs.openjdk11 # needed for firebase realtime db emulation
            ];

            env = {
              PRISMA_FTM_BINARY = "${prisma-engines}/bin/prisma-fmt";
              PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
              PRISMA_QUERY_ENGINE_BINARY = "${prisma-engines}/bin/query-engine";
              PRISMA_SCHEMA_ENGINE_BINARY = "${prisma-engines}/bin/schema-engine";
            };

            shellHook = ''
              export PS1="(node-env) $PS1"
              #export HISTFILE=".bash_history"
              export DEVSHELL_NAME="videollamada"
            '';
          };
        };
      }
    );
}
