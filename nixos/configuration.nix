
{ config, pkgs, inputs, ... }:

{
 # Nix Network
 imports = [
 ./hardware-configuration.nix
 ];

 # Bootloader
 boot.loader = {
  systemd-boot.enable = true;
  efi.canTouchEfiVariables = true;
 };

# Networking
 networking = {
  hostName = "nixos";
  firewall = {
   enable = true;
  };
  networkmanager = {
   enable = true;
  };
 };

 # Vietnamese
 time.timeZone = "Asia/Ho_Chi_Minh";
 i18n = {
  defaultLocale = "en_US.UTF-8";
  inputMethod = {
   type = "fcitx5";
   enable = true;
   fcitx5.addons = with pkgs; [
    kdePackages.fcitx5-qt
    fcitx5-mozc
    fcitx5-unikey
    fcitx5-bamboo
   ];
  };
  extraLocaleSettings = {
   LC_ADDRESS = "vi_VN";
   LC_IDENTIFICATION = "vi_VN";
   LC_MEASUREMENT = "vi_VN";
   LC_MONETARY = "vi_VN";
   LC_NAME = "vi_VN";
   LC_NUMERIC = "vi_VN";
   LC_PAPER = "vi_VN";
   LC_TELEPHONE = "vi_VN";
   LC_TIME = "vi_VN";
  };
 };

 # X11
 services.xserver= {
  enable = true;
  videoDrivers = ["amdgpu"];
  xkb = {
   layout = "us";
  };
 };

 # WM
 services.displayManager.sddm.enable = true;
 services.desktopManager.plasma6.enable = true;
 programs = {
  hyprland = {
   enable = true;
   xwayland.enable = true;
  };
  waybar.enable = true;
 };

 # Audio
 security.rtkit.enable = true;
 services.pipewire = {
  enable = true;
  pulse.enable = true;
  jack.enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
 };

 # User
 users.users.cirno = {
  isNormalUser = true;
  description = "Cirno";
  shell = pkgs.zsh;
  extraGroups = [ "networkmanager" "wheel" ];
  packages = with pkgs; [
   kdePackages.kate
   kdePackages.dolphin
  ];
 };

 # Hardware
 hardware.graphics = {
  enable = true;
  enable32Bit = true;
 };

 # Power Management
 services = {
  power-profiles-daemon.enable = false;
  tlp = {
   enable = true;
   settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 100;
    CPU_MIN_PERF_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 20;
   };
  };
 };

 # Special Programs
 programs = {
  firefox.enable = true;
  zsh.enable = true;
  neovim = {
   enable = true;
   defaultEditor = true;
  };
  gamemode.enable = true;
  steam = {
   enable = true;
   gamescopeSession.enable = true;
   remotePlay.openFirewall = true;
   localNetworkGameTransfers.openFirewall = true;
   dedicatedServer.openFirewall = true;
  };
 };

 # Packages
 nixpkgs.config.allowUnfree = true;
 environment.systemPackages = with pkgs; [
  home-manager git kitty waybar hyprcursor dunst hyprshot wl-clipboard starship pwvucontrol microfetch btop p7zip unrar
  tor-browser protonvpn-gui vesktop element-desktop gwenview mpv libreoffice obsidian gimp krita prismlauncher mangohud
  obs-studio xclicker home-manager catppuccin-cursors papirus-nord
 ];

 # Fonts & Icons
 fonts.packages = with pkgs; [
  nerdfonts
  font-awesome
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-emoji
 ];

 # Features & Optimization
 nix = {
  settings.experimental-features = [ "nix-command" "flakes" ];
  optimise.automatic = true;
  settings.auto-optimise-store = true;
  gc = {
   automatic = true;
   dates = "weekly";
   options = "--delete-older-than 5d";
  };
 };

# Version
system.stateVersion = "24.11";
}
