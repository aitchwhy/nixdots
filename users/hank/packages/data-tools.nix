# Data processing and API tools
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # JSON/YAML/XML processing
    yq # YAML/JSON/XML processor
    jo # JSON generator
    fx # Interactive JSON viewer
    jtbl # JSON to tables converter

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
