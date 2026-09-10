{
  description = "Development shell for vscord";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
      forAllSystems = function:
        nixpkgs.lib.genAttrs systems (system: function (import nixpkgs { inherit system; }));
    in {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [ pkgs.nodejs_22 ];

          shellHook = ''
            project_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
            export PATH="$project_root/node_modules/.bin:$PATH"
            if [ ! -x "$project_root/node_modules/.bin/rspack" ]; then
              npm --prefix "$project_root" ci --ignore-scripts
            fi
          '';
        };
      });
    };
}
