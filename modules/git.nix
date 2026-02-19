{ config, pkgs, ... }:
{
	programs.git = {
    enable = true;
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };

    delta.enable = true;
  };
}
