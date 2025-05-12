# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
config,
lib,
pkgs,
...
}:

let
	nixpkgsSrc = builtins.fetchTarball {
		url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.11.tar.gz";
		sha256 = "sha256:1ybhmmb9ph8ki7yicsnnvav4hxlh771zg82y642drsbbjs3f4szp";
	};
	x86pkgs = import nixpkgsSrc { system = "x86_64-linux"; };
	x86glibcLib = "${x86pkgs.glibc}/lib";
in
{
	imports = [
		# Include the results of the hardware scan.
		./hardware-configuration.nix
	];

	# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# networking.hostName = "nixos"; # Define your hostname.
	# Pick only one of the below networking options.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	# networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

	# Set your time zone.
	# time.timeZone = "Europe/Amsterdam";

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Select internationalisation properties.
	# i18n.defaultLocale = "en_US.UTF-8";
	# console = {
	#   font = "Lat2-Terminus16";
	#   keyMap = "us";
	#   useXkbConfig = true; # use xkb.options in tty.
	# };

	# Enable the X11 windowing system.
	# services.xserver.enable = true;

	# Configure keymap in X11
	# services.xserver.xkb.layout = "us";
	# services.xserver.xkb.options = "eurosign:e,caps:escape";

	# Enable CUPS to print documents.
	# services.printing.enable = true;

	# Enable sound.
	# hardware.pulseaudio.enable = true;
	# OR
	# services.pipewire = {
	#   enable = true;
	#   pulse.enable = true;
	# };

	# Enable touchpad support (enabled default in most desktopManager).
	# services.libinput.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	# users.users.alice = {
	#   isNormalUser = true;
	#   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
	#   packages = with pkgs; [
	#     tree
	#   ];
	# };

	# programs.firefox.enable = true;

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	# environment.systemPackages = with pkgs; [
	#   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
	#   wget
	# ];

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# Copy the NixOS configuration file and link it from the resulting system
	# (/run/current-system/configuration.nix). This is useful in case you
	# accidentally delete configuration.nix.
	# system.copySystemConfiguration = true;

	# This option defines the first version of NixOS you have installed on this particular machine,
	# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
	#
	# Most users should NEVER change this value after the initial install, for any reason,
	# even if you've upgraded your system to a new NixOS release.
	#
	# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
	# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
	# to actually do that.
	#
	# This value being lower than the current NixOS release does NOT mean your system is
	# out of date, out of support, or vulnerable.
	#
	# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
	# and migrated your data accordingly.
	#
	# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
	system.stateVersion = "24.11"; # Did you read the comment?

	# my config

	# enable gc
	nix = {
		settings = {
			experimental-features = [
				"nix-command"
				"flakes"
			];
		};
		gc = {
			automatic = true;
			dates = "weekly";
		};
	};

	nixpkgs.config = {
		allowUnfree = true;
	};

	# install programs
	environment.systemPackages = with pkgs; [
		# -- base packages --

		# dotfiles
		stow
		# neovim clipboard
		xclip
		# docker
		docker
		# aws
		awscli2

		# -- development packages --

		# common
		gnumake
		cmake
		# nix
		nixfmt-rfc-style
		# c
		gcc
		# java
		jdk
		# rust
		rustup
		# go
		go
		# python
		(python3.withPackages (pypkgs: with pypkgs; [
			# lsp
			python-lsp-server
			pluggy
			python-lsp-jsonrpc
			docstring-to-markdown
			jedi
			parso

			# analysis
			pwntools
			pycrypto
		]))
		# javascript
		volta
		# lua
		lua-language-server

		# -- improved packages --

		# ls
		eza
		# grep
		ripgrep
		# mysql
		mycli

		# -- analysis packages

		# shows type of files
		file
		# checksec, cyclic, pwntools-gdb etc...
		pwntools
		# edit binary
		tinyxxd
		# edit exif
		exiftool
		# execute x86_64 ELF
		# qemu
		# fhsEnv
		# operate image
		imagemagick
		# decompose file
		binwalk
		# compress executable file
		upx
		# operate bit of image
		# commented out: unable to extract plane 0
		# also following error occured
		# (java:1341): Gtk-WARNING **: 18:00:48.792: Could not load a pixbuf from /org/gtk/libgtk/theme/Adwaita/assets/bullet-symbolic.svg.
		# This may indicate that pixbuf loaders or the mime database could not be found.
		# stegsolve
		# cryptography
		openssl
	];

	# enable programs
	programs = {
		nix-ld = {
			enable = true;
		};
		zsh = {
			enable = true;
		};
		neovim = {
			enable = true;
			defaultEditor = true;
			viAlias = true;
			vimAlias = true;
		};
		git = {
			enable = true;
		};
	};

	# enable services
	services = {
		openssh = {
			enable = true;
			settings = {
				X11Forwarding = true;
				X11DisplayOffset = 10;
				X11UseLocalhost = false;
			};
		};
	};

	virtualisation.docker.enable = true;

	# add user
	users = {
		# commented out: enable root login without initialHashedPassword for root
		# mutableUsers = false;
		users."5ky12hm" = {
			isNormalUser = true;
			extraGroups = [
				"wheel"
				"docker"
			];
			shell = pkgs.zsh;
			# initialHashedPassword = "";
			openssh.authorizedKeys.keys = [
				"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJy3mLo8TJYL9i1Og79m14zl9YiOdHeR6F+tcSOtFkKo"
			];
		};
	};
	security.sudo.extraRules = [
		{
			users = [ "5ky12hm" ];
			commands = [
				{
					command = "ALL";
					options = [ "NOPASSWD" ];
				}
			];
		}
	];

	# network config
	networking = {
		hostName = "nixos";
		useDHCP = false;
		interfaces.enp0s1.ipv4.addresses = [
			{
				address = "192.168.3.111";
				prefixLength = 24;
			}
		];
		defaultGateway = "192.168.3.1";
		nameservers = [
			"1.1.1.1"
			"8.8.8.8"
		];
		firewall.enable = false;
	};

	# utm config
	services = {
		qemuGuest.enable = true;
		spice-vdagentd.enable = true;
		spice-webdavd.enable = true;
	};

	fileSystems."/mnt/share" = {
		fsType = "virtiofs";
		device = "share";
		options = [
			"rw"
			"nofail"
		];
	};
	# boot.binfmt.emulatedSystems = [
	# 	"x86_64-linux"
	# ];
	virtualisation.rosetta.enable = true;
	fileSystems."/lib64" = {
		device = x86glibcLib;
		options = [ "bind" "ro" ];
	};
}
