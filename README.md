# CompatBSD

CompatBSD is a FreeBSD-native controller for running selected modern Linux
desktop applications through the FreeBSD Linuxulator, pluggable Linux
userspace runtimes, explicit host-integration bridges, and interchangeable
execution backends.

## Status

Milestone 1: repository scaffold and design contracts.

Implemented commands:

```text
compatbsd version
compatbsd help
```

No Linux runtime is created, mounted, downloaded, or executed at this stage.

## Version 0.1 target

```text
Runtime:       Ubuntu 24.04 LTS
Backend:       chroot
Application:   Spotify
Display:       X11
Audio:         one verified backend
Architecture:  amd64
```

## Governing principle

> Multi-runtime architecture from day one, single-runtime implementation for version 0.1.

## Architectural layers

- **Core controller:** generic command routing and lifecycle orchestration.
- **Runtime plugin:** distribution-specific bootstrap, package, and verification logic.
- **Backend plugin:** chroot or jail execution mechanics.
- **Application manifest:** application metadata and declared integration needs.
- **Bridge:** display, D-Bus, audio, GPU, device, and network integration.
- **State:** generated runtime files, mutable state, logs, and per-user data.

See [`docs/architecture.md`](docs/architecture.md) and
[`docs/terminology.md`](docs/terminology.md).

## Development usage

From the repository root:

```sh
./bin/compatbsd version
./bin/compatbsd help
make check
```

## Safety rules

CompatBSD must not modify `/compat/linux`, mix libraries across distributions,
run graphical applications as root, or treat a chroot as a strong security
boundary.

## Roadmap

1. Repository and design contracts.
2. Read-only host and Linuxulator inspection.
3. Minimal runtime-plugin contract.
4. Ubuntu 24.04 root filesystem.
5. Chroot backend.
6. Controlled mount manager.
7. Complete doctor command.
8. X11 bridge.
9. D-Bus bridge.
10. Audio bridge.
11. Generic application framework.
12. Spotify support.
13. Jail backend.
14. Second-runtime proof.
15. FreeBSD port.

## License

BSD 2-Clause License. See [`LICENSE`](LICENSE).
