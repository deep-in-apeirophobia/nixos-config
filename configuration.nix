{ nixpkgs, conf, config, lib, pkgs, hostname, username, ...}: 
{
	nixpkgs.config.allowUnfree = true;

	imports = [
		./hardware-configuration.nix
		./modules/proxychains.nix

		# ./modules/gaming.nix

		./services/tor.nix
		./services/udisks2.nix
	];

	nix.settings = {
		###################
		# bad conneciton  #
		###################
		# Add nix mirrors
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
		# max-substitution-jobs = 2;   # Limit concurrent downloads

		# Keep failed downloads for resume (if supported)
		keep-failed = false;

		# download-redirect-executable = true;

		fallback = true;             # Build from source if substituter fails
		# max-build-jobs = 4;          # Adjust based on your CPU

		# proxy = "http://your-proxy:port";
		###################

		auto-optimise-store = true;
		eval-cache = true; # for direnv

		experimental-features = ["nix-command" "flakes"];
	};
	nix.optimise = {
		# automatic = true;
		automatic = false;
	};
	nix.gc = {
		automatic = false;
		dates = "weekly";
		options = "--delete-older-than 90d";
	};

	###################
	# bad conneciton  #
	###################
	systemd.services.nix-daemon.serviceConfig = {
		LimitNOFILE = 65536;
		TimeoutStartSec = "infinity";
	};
	###################

	# boot.loader.grub.enable = true;
	# boot.loader.grub.useOSProber = true;
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	# boot.loader.systemd-boot.edk2-uefi-shell.enable = true;	
	boot.loader.systemd-boot.windows = {
		"Windows" = {
			efiDeviceHandle = "HD0b";
		};
	};
	boot.plymouth.enable = true;

	# Increase max_file watches, otherwise yarn errors
	boot.kernel.sysctl = {
		"fs.inotify.max_user_watches" = 524288;
	};

	# ZFS config
	# boot.kernelPackages = latestKernelPackage;
	boot.supportedFilesystems = [ "zfs" ];
	boot.zfs.devNodes = "/dev/disk/by-partuuid";
	boot.zfs.forceImportRoot = false;
	boot.zfs.extraPools = [ "zpool" ];
	# fileSystems."/".options = [ "zfsutil" ];
	fileSystems."/".neededForBoot = true;
	# fileSystems."/nix".options = [ "zfsutil" ];
	fileSystems."/nix".neededForBoot = true;
	# fileSystems."/home".options = [ "zfsutil" ];
	# fileSystems."/var".options = [ "zfsutil" ];

	services.zfs.autoScrub.enable = true;
	services.zfs.trim.enable = true;

	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.nvidia.powerManagement.enable = true;
	hardware.nvidia.open = true;
	# hardware.opengl.enable = true;
	hardware.graphics.enable = true;
	# hardware.opengl = {
	# 	enable = true;
	# };
	# programs.steam = {
	# 	enable = true;
	# 	remotePlay.openFirewall = true;
	# 	dedicatedServer.openFirewall = true;
	# };

	networking.hostId = "1592fec2";
	networking.hostName = hostname;

	networking.networkmanager = {
		enable = true;
		plugins = [
			pkgs.networkmanager-l2tp
			pkgs.networkmanager-openvpn
			pkgs.networkmanager-openconnect

			pkgs.networkmanager-strongswan
		];
	};
  services.xl2tpd.enable = true;

	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		wireplumber.enable = true;
		jack.enable = true;
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
		vazir-fonts # persian
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

	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			fish_vi_key_bindings
			'';
	};
	users.users.${username} = {
		isNormalUser = true;
		extraGroups = [ "wheel" "docker" "wireshark" "libvirtd" "kvm" ];

		shell = pkgs.fish;

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

	environment.variables = {
		NPM_CONFIG_PREFIX = "$HOME/.local/share/npm";
    PNPM_HOME = "$HOME/.local/share/pnpm";
    CARGO_HOME = "$HOME/.cargo";

		PATH = [
			"$NPM_CONFIG_PREFIX/bin"
      "$PNPM_HOME/bin"
      "$CARGO_HOME/bin"
		];
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
		openssl

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
		nodejs_22

		home-manager

		# FS
		ntfs3g          # FUSE driver with full read/write support
    ntfsprogs       # Additional NTFS utilities (mkntfs, ntfsfix, etc.)
    # HFS+ tools  
    hfsprogs        # HFS+ filesystem utilities (mkfs.hfsplus, fsck.hfsplus)
    # APFS tools
    apfs-fuse

		networkmanagerapplet
		# L2TP/PPP
		ppp
	];
	
	programs.direnv = {
		enable = true;
		enableBashIntegration = true; # Needed if you use Bash
		enableZshIntegration = true;  # Needed if you use Zsh
		nix-direnv.enable = true;
	};

	# nekoray/throne
	programs.throne = {
		enable = true;
		tunMode.enable = true;
	};

	# Maybe change?
	networking.firewall.enable = false;
	# networking.firewall = rec {
	# 	allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
	# 	allowedUDPPortRanges = allowedTCPPortRanges;
	# };

	system.stateVersion = "25.11";
}
