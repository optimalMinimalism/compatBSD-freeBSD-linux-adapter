# CompatBSD architecture diagrams

These Mermaid diagrams document CompatBSD without exposing developer-specific
usernames, hostnames, or home-directory paths.

## Diagram responsibilities

- `system-context.mmd`: external actors and system boundary.
- `components.mmd`: primary software architecture and dependency boundaries.
- `app-run-sequence.mmd`: runtime behavior of an application launch.
- `runtime-lifecycle.mmd`: legal runtime states and transitions.
- `deployment.mmd`: logical installation, generated state, runtime storage, and
  execution placement.

The component diagram is the primary architecture diagram because CompatBSD is
currently a systems-orchestration platform, not an object-oriented class model.

A class diagram should be added only if the implementation later contains real
classes, structs, interfaces, or domain types that benefit from structural
modeling.
