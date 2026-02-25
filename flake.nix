{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Updated daily. To pull the latest versions:
    #   nix flake update llm-agents --flake ~/.config/home-manager/nix-home
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = { nixpkgs, home-manager, llm-agents, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
      agentPkgs = llm-agents.packages.${system};
    in
    {
      homeConfigurations."justin" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          claude-code = agentPkgs.claude-code;
          codex = agentPkgs.codex;
        };
        modules = [ ./home.nix ];
      };
    };
}
