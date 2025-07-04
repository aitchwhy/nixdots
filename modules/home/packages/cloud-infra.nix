# Cloud platforms and infrastructure tools
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Cloud platforms
    awscli2
    flyctl
    claude-code

    # Infrastructure as Code
    terraform
    pulumi

    # Container tools
    skopeo
    podman
    trivy # Container scanning

    # Kubernetes tools
    # talosctl # Commented: verify package name

    # Secrets and security
    sops
    gitleaks # Secret scanner

    # Networking
    caddy
    speedtest-cli
    rustscan
  ];
}
