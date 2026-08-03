# CompatBSD Architecture

## 1. Purpose

CompatBSD separates Linux distribution concerns, execution mechanics,
desktop integration, and application definitions so that adding a runtime or
backend does not require rewriting the controller.

Version 0.1 implements one vertical path only:

```text
Spotify -> Ubuntu 24.04 userspace -> chroot backend -> Linuxulator -> FreeBSD
```

The contracts are multi-runtime from the start, but implementation remains
minimal until this path works.

## 2. Execution stack

```text
Linux desktop application
        |
Selected Linux userspace runtime
        |
FreeBSD Linuxulator
        |
FreeBSD kernel
        |
Hardware
```

The Linuxulator is a kernel ABI compatibility subsystem. It is not a Linux
kernel and it does not supply a complete Linux userspace. The selected runtime
supplies the dynamic loader, glibc, libraries, package database, certificates,
and application dependencies.

## 3. Layer boundaries

### 3.1 Core controller

The native controller owns command parsing, configuration resolution,
validation order, orchestration, diagnostics, and stable user-facing behavior.
It may request generic operations such as creating a runtime, mounting a
backend, preparing a bridge, or launching an application.

The core must not contain direct assumptions about Ubuntu, apt, Spotify, X11,
PulseAudio, or chroot.

### 3.2 Runtime plugins

A runtime plugin owns distribution-specific facts and actions:

- runtime identity and release;
- bootstrap mechanism and mirror;
- package manager and repositories;
- dynamic loader path;
- libc implementation and expected version;
- base package set;
- distribution-specific configuration and verification.

The initial metadata format is line-oriented `key=value`. Values are data, not
shell code. Future parsers must reject duplicate keys, unknown mandatory fields,
and unsafe syntax rather than sourcing manifests directly.

### 3.3 Backend plugins

A backend controls how commands see and enter a runtime filesystem.

The initial backend is chroot. It changes pathname resolution but does not
provide a strong security boundary. The intended production backend is a
FreeBSD jail, which adds process and resource isolation.

Backend operations will eventually include prepare, mount, enter, run, stop,
unmount, status, and destroy. Runtime and application definitions must remain
unchanged when switching from chroot to jail.

### 3.4 Application manifests

An application manifest describes an application independently of the
controller and backend. It declares identity, source type, expected runtime,
architecture, installation path, executable, required bridges, home policy,
and compatibility limitations.

Application-specific download, installation, verification, and launch behavior
belongs under `applications/<id>/`, not in the core dispatcher.

### 3.5 Host-integration bridges

Bridges connect a Linux process to selected host facilities:

- display;
- D-Bus;
- audio;
- GPU;
- devices;
- networking.

Each bridge will expose detection, preparation, verification, cleanup, and
clear failure reporting. Sharing a socket or device is an explicit policy
decision, not an incidental mount.

### 3.6 Persistent state and generated files

Source-controlled definitions live in the repository and, after packaging,
under `/usr/local/etc/compatbsd/` or installed program directories.

Generated and mutable data must remain outside the source tree:

```text
/compat/compatbsd/       generated runtime root filesystems
/var/db/compatbsd/       controller and mount state
/var/log/compatbsd/      controller and application logs
~/.local/share/compatbsd per-user application data
```

`/compat/linux` is owned by FreeBSD's packaged Linux compatibility base and is
outside CompatBSD's control.

## 4. Dependency direction

The controller may load definitions and call generic interfaces. Runtime,
backend, bridge, and application components may use shared helpers, but they
must not reach into one another's private implementation.

```text
CLI -> core orchestration -> declared interfaces
                          -> runtime plugin
                          -> backend plugin
                          -> selected bridges
                          -> application definition
```

No runtime plugin should know that Spotify exists. No Spotify definition should
implement mount mechanics. No backend should contain apt commands.

## 5. Configuration precedence

A later milestone will define exact configuration parsing. The intended
precedence is:

```text
built-in safe defaults
< system configuration
< runtime/application definitions
< explicit command-line selection
```

Secrets and mutable state are not stored in manifests.

## 6. Privilege model

The controller should separate privileged preparation from unprivileged
application execution.

Privileged operations include package installation, runtime creation, mounts,
jail management, and restricted device setup. They use `sudo`.

Graphical applications run as the numeric UID and GID of `opMin0`, never as
root. A future privileged helper must expose narrow operations rather than
turning the whole controller into an unrestricted root process.

## 7. Milestone 1 contract

Milestone 1 creates only source files and a native shell dispatcher supporting:

```text
compatbsd version
compatbsd help
```

It performs no host inspection and makes no privileged or persistent system
changes.

## 8. Deferred decisions

The following are deliberately deferred until evidence from the first working
runtime exists:

- final plugin function-loading mechanism;
- final manifest parser implementation;
- jail networking policy;
- audio backend choice;
- GPU device policy;
- Wayland support;
- bhyve fallback;
- compatibility override semantics.

Deferring these is not architectural neglect. It prevents speculative APIs from
becoming permanent before their requirements are understood.
