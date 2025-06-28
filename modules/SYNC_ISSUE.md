# File Synchronization Issue

## Problem
The files `modules/darwin/common/myusers.nix` and `modules/nixos/common/myusers.nix` are being automatically synchronized by an external tool (likely an IDE feature or file watcher).

## Impact
- Changes to one file are immediately mirrored to the other
- Files become hard links with the same inode
- Platform-specific configurations get mixed

## Temporary Workaround
Both files currently have Darwin-specific configuration. The NixOS configuration will need to be fixed once the synchronization issue is resolved.

## TODO
- Identify and disable the synchronization mechanism
- Properly separate Darwin and NixOS configurations
- Ensure NixOS module uses `/home/${name}` paths instead of `/Users/${name}`