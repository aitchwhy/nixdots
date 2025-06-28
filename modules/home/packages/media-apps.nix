# Media tools and applications
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Media processing
    ffmpeg
    imagemagick
    poppler # PDF utilities
    tesseract # OCR
    
    # Applications
    parsec-bin
    slack
  ];
}