{
  description = "mkp224o.nix";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    flake-utils.url = github:numtide/flake-utils;
    mkp224o.url = github:cathugger/mkp224o/v1.6.1;
    mkp224o.flake = false;
  };

  outputs = inputs:
    with inputs.flake-utils.lib;
    eachDefaultSystem (system:

    let
      pkgs = import inputs.nixpkgs {
        inherit system;
      };
      utils = inputs.flake-utils.lib;
    in rec {
        # nix build
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "mkp224o";
          version = "v1.6.1";
          src = inputs.mkp224o;
          buildInputs = with pkgs; [
            gcc
            libsodium
            autoconf
          ];
          configurePhase = "true";
          buildPhase = ''
            echo "installing mk224o from sources"
            mkdir -p $out/bin
            ./autogen.sh
            ./configure
            ${pkgs.gnumake}/bin/make
            cp ./mkp224o $out/bin/mkp224o
          '';
          checkPhase = "true";
          installPhase = "true";
        };

        # nix run
        apps.default = utils.mkApp {
          name = "mkp224o";
          drv = packages.default;
        };

        # nix develop
        devShell =
          pkgs.mkShell {};
      });
}
