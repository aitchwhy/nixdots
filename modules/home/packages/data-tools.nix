# Data processing and API tools
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # JSON/YAML/XML processing
    jq # JSON processor
    yq # YAML/JSON/XML processor
    jo # JSON generator
    fx # Interactive JSON viewer
    
    # Data formats
    miller # CSV processing
    pandoc # Document converter
    
    # HTTP clients
    httpie
    hurl # HTTP testing
    xh # Modern HTTP client
    
    # Database tools
    usql # Universal SQL client
    datasette # SQLite explorer
    
    # Text processing
    glow # Markdown viewer
    goaccess # Web log analyzer
  ];
}