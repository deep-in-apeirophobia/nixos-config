{ nixpkgs, conf, lib, pkgs, hostname, username, ...}: 
{
	nixpkgs.config.allowUnfree = true;

	imports = [
		./hardware-configuration.nix
		./modules/proxychains.nix
		# ./modules/gaming.nix
	];

	###################
	# bad conneciton  #
	###################
	# Add nix mirrors
	nix.settings = {
		substituters = [
			"https://cache.nixos.org"
			"https://nix-community.cachix.org"
			"https://cache.nixos.org?priority=10"
			"https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  # China mirror
			"https://mirrors.ustc.edu.cn/nix-channels/store"           # Another China mirror
		]; 
		connect-timeout = 30;        # Default is often too low
		stalled-download-timeout = 90;

		# Retry settings
		max-jobs = "auto";
		cores = 0;                   # Use all cores

		# Download settings
		http-connections = 4;        # Reduce parallel connections if unstable
		max-substitution-jobs = 2;   # Limit concurrent downloads

		# Keep failed downloads for resume (if supported)
		keep-failed = false;

		download-redirect-executable = true;

		fallback = true;             # Build from source if substituter fails
		max-build-jobs = 4;          # Adjust based on your CPU

		# proxy = "http://your-proxy:port";
	};

	# Create a wrapper script for nix to use aria2
	environment.etc."nix/nix.conf".text = ''
		download-redirect-executable = true
	'';

	systemd.services.nix-daemon.serviceConfig = {
		LimitNOFILE = 65536;
		TimeoutStartSec = "infinity";
	};
	###################

	# boot.loader.grub.enable = true;
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.plymouth.enable = true;

	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.nvidia.powerManagement.enable = true;
	hardware.nvidia.open = true;
	# hardware.opengl.enable = true;
	hardware.graphics.enable = true;

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
		noto-fonts-color-emoji
		liberation_ttf
		fira-code
		nerd-fonts.fira-code
		nerd-fonts.jetbrains-mono
		nerd-fonts.noto
		nerd-fonts.mononoki
		nerd-fonts.fantasque-sans-mono
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
	nix.settings.experimental-features = "nix-command flakes";

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
		# for unstable connections
		aria2

		kitty
		vim
		# neovim
		docker
		qemu_kvm
		virtiofsd
		libvirt
		dnsmasq
		bridge-utils

		vlc

		wget
		curl

		git

		gnutar

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

		# tor
		obfs4
		webtunnel
		nyx
	];
	
	# tor
	
	services.tor = {
		enable = true;
		settings = {
			# UseBridges = true;
			# ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/lyrebird";
			# Bridge = "obfs4 IP:ORPort [fingerprint]";
		};
	};


	# Maybe change?
	networking.firewall.enable = false;

	system.stateVersion = "25.11";
}
