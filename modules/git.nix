{ config, pkgs, ... }:
{
	programs.git = {
    enable = true;
    
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };

  };
  programs.delta.enable = true;
}
