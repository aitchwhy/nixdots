# Media tools and applications
{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # Media processing
    ffmpeg
    imagemagick
    poppler # PDF utilities
    tesseract # OCR
    
    # Applications
    slack
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    parsec-bin
  ];
}