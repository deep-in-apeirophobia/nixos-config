{ nixpkgs, conf, lib, pkgs, hostname, username, ...}: 
{
	imports = [
		./hardware-configuration.nix
		./modules/proxychains.nix
	];

	boot.loader.grub.enable = true;

	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.nvidia.powerManagement.enable = true;
	hardware.opengl.enable = true;

	networking.networkmanager.enable = true;
	networking.hostName = hostname;

	services.pipewire = {
		enable = true;
		alsa.enable = true;
		pulse.enable = true;
		wireplumber.enable = true;
	};

	services.upower.enable = true;

	services.printing.enable = true;

	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-hyprland
		];
	};

	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-cjk-sans
		noto-fonts-emoji
		liberation_ttf
		fira-code
		(nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
	];

	users.users.${username} = {
		isNormalUser = true;
		extraGroups = [ "wheel" ];

	};


	services.openssh.enable = true;
	services.power-profiles-daemon.enable = true;
	services.blueman.enable = true;
	hardware.bluetooth.enable = true;
	programs.mtr.enable = true;
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};

	nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

	programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };
	programs.chromium = {
    enable = true;
  };

	environment.systemPackages = [
		vim
		neovim

		vlc

		wget
		curl

		git

		tar

		btop
		tree
		file
		unzip
		pciutils
		usbutils
		lsof
		killall
		tmux
		
		ntfs3g
		parted
		gptfdisk

		smartmontools
		lm_sensors

		nix-index
		nh

		gcc
		gnumake
		python3
		nodejs
	];

	# Maybe change?
	networking.firewall.enable = false;

	system.stateVersion = "25.11";
}
