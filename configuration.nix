{ nixpkgs, conf, lib, pkgs, hostname, username, ...}: 
{
	nixpkgs.config.allowUnfree = true;

	imports = [
		./hardware-configuration.nix
		./modules/proxychains.nix
		# ./modules/gaming.nix
	];

	# boot.loader.grub.enable = true;
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

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
	programs.hyprland.enable = true;

	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-cjk-sans
		noto-fonts-emoji
		liberation_ttf
		fira-code
		(nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Noto" "Mononoki" "FantasqueSansMono" ]; })
	];

	users.users.${username} = {
		isNormalUser = true;
		extraGroups = [ "wheel" "docker" "wireshark" "libvirtd" "kvm" ];

	};


	services.openssh.enable = true;
	services.power-profiles-daemon.enable = true;
	services.blueman.enable = true;
	hardware.bluetooth.enable = true;
	programs.wireshark.enable = true;
	virtualisation.docker.enable = true;
	virtualisation.libvirtd.enable = true;
	programs.virt-manager.enable = true;
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

	environment.systemPackages = with pkgs; [
		kitty
		vim
		# neovim
		docker
		docker-desktop
		qemu_kvm
		virtiofsd
		libvirt
		dnsmasq
		bridge-utils

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
