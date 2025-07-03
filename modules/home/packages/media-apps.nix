# Media tools and applications
{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # Media processing
    ffmpeg
    imagemagick
    poppler # PDF utilities
    tesseract # OCR
    resvg # SVG rendering
    tectonic # Modern TeX engine
    
    # Applications
    slack
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    parsec-bin
  ];
}