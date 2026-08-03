# CompatBSD Terminology

## Host

The FreeBSD installation that owns the kernel, hardware, native services,
filesystems, and CompatBSD controller.

## Guest

Avoid this term for Linuxulator runtimes when possible. There is no separate
Linux kernel. Use **runtime** or **Linux userspace** instead. “Guest” is more
appropriate for a future bhyve virtual machine.

## Linuxulator

FreeBSD's Linux ABI compatibility subsystem. It recognizes supported Linux ELF
binaries and translates supported Linux-facing kernel interfaces into FreeBSD
kernel behavior. It does not provide a complete Linux distribution.

## ABI

Application Binary Interface. The machine-level contract covering executable
format, calling conventions, system calls, data layouts, dynamic loader rules,
and symbol interfaces. Linuxulator compatibility is primarily an ABI concern.

## API

Application Programming Interface. A source-level interface used by software
when it is compiled. Compatible source APIs do not guarantee compatible Linux
binaries.

## Runtime

A selected Linux userspace root filesystem plus its metadata and
distribution-specific management logic. It supplies the Linux dynamic loader,
libc, shared libraries, certificates, package tools, and supporting files.

## Root filesystem / rootfs

The directory tree that appears as `/` to a process entered through a backend.
A rootfs is generated state and must not be committed to Git.

## Runtime plugin

The distribution-specific definition and implementation used to bootstrap,
configure, update, verify, and destroy one runtime family and release.

## Backend

The mechanism used to expose and execute inside a runtime rootfs. CompatBSD
starts with chroot and later adds a FreeBSD jail backend.

## chroot

A filesystem-view mechanism that changes the apparent root directory used for
pathname resolution. It is useful for bring-up and debugging but is not a
strong process-isolation or security boundary.

## Jail

A FreeBSD operating-system-level isolation mechanism that can restrict process,
filesystem, network, identity, and resource visibility. It remains based on the
host FreeBSD kernel.

## Bridge

A controlled integration mechanism that gives a runtime process access to a
specific host facility, usually through environment variables, sockets,
mounts, devices, or proxy processes.

## Application manifest

Declarative metadata describing an application, its source and executable,
compatible runtime, architecture, required bridges, data policy, and known
compatibility limitations.

## Dynamic loader / ELF interpreter

The executable named by an ELF binary's `PT_INTERP` segment. It starts before
the application, loads required shared objects, resolves symbols, and transfers
control to the program. On amd64 glibc systems this is commonly
`/lib64/ld-linux-x86-64.so.2`.

## glibc

The GNU C Library used by Ubuntu and many Linux distributions. A matching
library filename is insufficient: applications can require symbol versions
that only newer glibc releases provide.

## Symbol versioning

A dynamic-linking mechanism that lets an ELF object require a specific version
of a function or data symbol, such as a `GLIBC_2.xx` requirement. CompatBSD must
inspect version requirements, not merely filenames.

## Mount state

The recorded relationship between a mount operation, its source, destination,
filesystem type, and CompatBSD ownership. Safe cleanup must not unmount a
resource CompatBSD did not create.

## Private application home

An application-specific directory presented as the user's Linux home inside the
runtime. It prevents unnecessary exposure of the complete FreeBSD home and
separates application configuration and cache data.

## Generated state

Runtime root filesystems, package databases, application payloads, mount
records, logs, caches, and other mutable files produced during operation. These
belong outside Git.

## Definition versus implementation

A definition declares facts and requirements. An implementation performs
operations. `runtime.conf` and `app.conf` are definitions; future bootstrap,
mount, bridge, and launch scripts are implementations.
