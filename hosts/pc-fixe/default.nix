{ config, pkgs, ... }:

{
  imports = [ 
    ../../common.nix 
    ./hardware-configuration.nix 
  ];

  networking.hostName = "pc-fixe";

  # Bootloader spécifique (Grub avec Windows)
  boot.loader.grub = {
    enable = true; 
    device = "nodev"; 
    efiSupport = true; 
    useOSProber = true; 
  };
  boot.loader.efi.canTouchEfiVariables = true; 

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ]; 
  boot.initrd.kernelModules = [ "nvidia" ]; 
  hardware.nvidia = {
    modesetting.enable = true; 
    open = false; 
    package = config.boot.kernelPackages.nvidiaPackages.stable; 
  };

  # Interfaces
  services.displayManager.ly.enable = true; 
  services.desktopManager.plasma6.enable = true; 
  programs.hyprland.enable = true; 

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia"; 
    GBM_BACKEND = "nvidia-drm"; 
    __GLX_VENDOR_LIBRARY_NAME = "nvidia"; 
  };
}
