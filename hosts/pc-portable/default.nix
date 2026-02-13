{ config, pkgs, ... }:

{
  imports = [ 
    ../../common.nix 
    ./hardware-configuration.nix 
  ];

  # --- Système et Boot ---
  networking.hostName = "zypad"; 
  boot.loader.systemd-boot.enable = true; 
  boot.loader.systemd-boot.configurationLimit = 1; 
  boot.loader.efi.canTouchEfiVariables = true; 
  system.nixos.label = "retard-os"; 

  fileSystems."/home" = { 
    device = "/dev/disk/by-uuid/04df797d-edc2-45c0-b1a3-7d3ea58b0d95"; 
    fsType = "ext4"; 
  };

  # --- Services ---
  services.displayManager.ly.enable = true; 
  services.dbus.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  
# --- Serveur X11 et DWM ---
  services.xserver = {
    enable = true;
    
    xkb = {
      layout = "fr";
      variant = "dvorak";
    };

    displayManager.setupCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output eDP1 --primary --auto --output HDMI1 --auto --above eDP1
    '';

    displayManager.sessionCommands = ''
      ${pkgs.feh}/bin/feh --bg-scale ~/Pictures/wpp/ca.webp &
      ${pkgs.xorg.xset}/bin/xset s off -dpms
      ${pkgs.xorg.xset}/bin/xset s noblank
    '';
  };

security.polkit.extraConfig = ''
  polkit.addRule(function(action, subject) {
    if (action.id == "org.xfce.power.backlight-helper" &&
        subject.isInGroup("wheel")) {
      return polkit.Result.YES;
    }
  });
''; 
  
  # --- Touchpad (Correction des avertissements) ---
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      accelSpeed = "0.5";
    };
  };

  # --- Gestion de l'énergie ---
  services.logind.settings = {
    Login = {
      HandlePowerKey = "ignore"; 
      HandlePowerKeyLongPress = "ignore"; 
    }; 
  };

services.tlp = {
  enable = true;
  settings = {

    START_CHARGE_THRESH_BAT0 = 96;
    STOP_CHARGE_THRESH_BAT0 = 100;

    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  };
};
  # --- Paquets Système ---
  environment.systemPackages = with pkgs; [
    dmenu 
    
    feh
    picom
    xorg.xset 
    xorg.xrandr 
    
    pywal 
    imagemagick
    polybar


    wireshark
    tcpdump
    tree
    gemini-cli
    brightnessctl
    obsidian
    fastfetch
    unzip
    unrar
    htop
    btop
    
  ];
}
