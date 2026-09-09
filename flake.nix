{
  description = "markitdwon flake.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            python311
            python311Packages.venvShellHook
            python311Packages.pip
            zlib
            libxml2
            libxslt
            stdenv.cc.cc
          ];

          venvDir = ".venv";

          postVenvCreation = ''
            unset SOURCE_DATE_EPOCH
            pip install --upgrade pip
            pip install "markitdown[all]"
          '';

          postShellHook = ''
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.zlib ]}:$LD_LIBRARY_PATH"
            echo "--------------------------------------------------------"
            echo "MarkItDown environment Active!"
            echo "--------------------------------------------------------"
          '';
        };
      }
    );
}
