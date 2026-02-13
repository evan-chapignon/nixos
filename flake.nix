{
  description = "en gros j'ai nix sur deux ordis donc je sync comme ça";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  };

  # Correction ici : ajout de la virgule avant les points de suspension
  outputs = { self, nixpkgs, ... }: 
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        pc-fixe = nixpkgs.lib.nixosSystem {
          inherit system;
          # Si vous voulez suckless aussi sur le fixe, ajoutez specialArgs ici
          modules = [ ./hosts/pc-fixe/default.nix ];
        };
        
        pc-portable = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/pc-portable/default.nix ];
        };
      };
    };
}
