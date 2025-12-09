# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #------------------------------------------------------------------------------------------------------------------------------
  ##### Carregamento de boot #####

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #------------------------------------------------------------------------------------------------------------------------------
  ##### Internet #####

  networking.hostName = "teadoctor"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #------------------------------------------------------------------------------------------------------------------------------
  ##### Som #####

  # PulseAudio
  services.pipewire.enable = false;
  services.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;

  #------------------------------------------------------------------------------------------------------------------------------
  ##### Configurações gerais #####

  # links /libexec from derivations to /run/current-system/sw
  environment.pathsToLink = ["/libexec"];

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Habilitando fontes
#  fonts.fontconfig.enable = true;
#  fonts.packages = with pkgs; [ nerdfonts ];

  #------------------------------------------------------------------------------------------------------------------------------
  ##### Sistema de arquivos #####

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.flaviano = {
    isNormalUser = true;
    description = "Flaviano Williams Fernandes";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  # Habilitando autologin
#  services.getty.autologinUser = "flaviano";

  #------------------------------------------------------------------------------------------------------------------------------
  ##### Softwares #####

  # Enable networking
  networking.networkmanager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Aplicativos do ambiente gráfico
    google-chrome
    nitrogen
    # Ambiente de desenvolvimento e data science
    python312
    R
    rstudio
    rPackages.nloptr
    positron-bin
    wget
    git
    neovim
    cmake
    wget
    git
    # Demais aplicações úteis
    xfce.thunar
    mc
    texliveFull
    texstudio
    qtikz
    system-config-printer
    libreoffice
    htop
    zip
    usbutils
    udiskie
    udisks
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  #------------------------------------------------------------------------------------------------------------------------------
  #### Ambiente gráfico ####

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
	i3status
	i3blocks
	i3lock
        i3-rounded
	i3blocks-gaps
	rofi
      ];
    };
  };

  services.displayManager.defaultSession = "none+i3";
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "flaviano";

  programs.i3lock.enable = true;

  #------------------------------------------------------------------------------------------------------------------------------
  #### Serviços ####

  # Habilitando SSH
  services.openssh.enable = true;

  # Habilitando firewall
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Habilitando cups
  services.printing = {
    enable = true;
    allowFrom = [ "all" ];
    drivers = with pkgs; [
      cups-filters
      cups-browsed
      hplip
    ];
  };

  #Detectando impressoras wifi
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Instalando impressoras de rede via protocolo IPP
#  hardware.printers = {
#    ensureDefaultPrinter = "HP Laserjet MFP E42540";
#    ensurePrinters = [
#      {
#        deviceUri = "ipp://10.10.0.153/ipp";
#	location = "Sala dos professores";
#	name = "HP Laserjet MFP E42540";
#	model = "everywhere";
#	ppdOptions = {
#	  PageSize = "A4";
#	};
#      };
#    ];
#  };

  # Habilitando serviço de detecção de dispositivos USB
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  #------------------------------------------------------------------------------------------------------------------------------
  #
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
