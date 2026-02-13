{ config, pkgs, ... }:

{
  # --- NETWORKING & LOCALIZATION ---
  networking.networkmanager = {
    enable = true;
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };
  console.keyMap = "fr";

  # --- USER ACCOUNT ---
  programs.zsh.enable = true;
  users.users.evan = {
    isNormalUser = true;
    description = "evan";
    extraGroups = [ "networkmanager" "wheel" "video" "input" ];
    shell = pkgs.zsh;
  };

  # --- SERVICES PARTAGÉS ---
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  systemd.services.kanata = {
    description = "Kanata keyboard remapper";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kanata}/bin/kanata --cfg /home/evan/.config/kanata/kanata.kbd";
    };
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (epkgs: with epkgs; [
      vterm
      pdf-tools
    ]);
  };

  # --- PACKAGES ---
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    firefox alacritty mako wofi waybar swww pavucontrol spotify
    git gnumake gcc kanata steam nodejs fzf zoxide vlc ffmpeg
    jetbrains.idea ryubing nicotine-plus libreoffice prismlauncher
    (discord.override { withVencord = true; })
  ];

  fonts.packages = with pkgs; [
    noto-fonts nerd-fonts.jetbrains-mono iosevka fira-code
  ];

  system.stateVersion = "25.11";
}
