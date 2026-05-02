# Project description

Homie is a NixOS server configuration for a home NAS server. It provides a modern, secure, and efficient setup for
managing your home data, media, and services.

## Guidelines

* Isolate complex well-defined components and features in their own files to improve readability and maintainability.
* Group attribute sets by the tool or service they belong to, and keep related configuration together to improve readability. Use `let` blocks to structure the configuration and avoid repetition where appropriate.
* Use descriptive names for configuration files to make it clear what each one is responsible for.
* Always prefer declarative configuration over imperative scripts, leveraging the power of Nix flakes to ensure reproducibility and ease of maintenance.
* Adhere to the principle of least surprise: the configuration should do what a reasonably experienced user would expect it to do, without hidden side effects or non-obvious behavior.
* Document any non-trivial configuration choices or workarounds in the code comments to aid future maintainers (including future you).

## Project structure

* `./flake.nix` — main flake that describes the entire system configuration, delegates to other files for specific components
* `./hardware.nix` — hardware-specific configuration (e.g. disk setup, network interfaces)
* `./home-manager.nix` — Home-manager configuration for the user environment (e.g. shell, editor, tools)
* `./system.nix` — system-wide configuration (e.g. NixOS modules, networking, users, security settings)
* `./services/` — a directory containing service-specific configuration files (e.g. `nextcloud.nix` for Nextcloud setup)

## Commands

You can run these commands from the project root:

* `nixfmt **/*.nix` — format all Nix files with the standard Nix formatter
* `nixos-rebuild build --flake '.#nixos' --refresh` — build the NixOS configuration without switching to it (useful for testing)
