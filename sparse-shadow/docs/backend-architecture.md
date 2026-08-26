# Canonical backend architecture

## Policy

The native Rust engine is mandatory and authoritative. It owns canonical IDs,
transporters, reconstruction output, exhaustive certificates, and independent
replay. An external engine can add cross-check evidence but cannot replace or
validate a native certificate by assertion.

The backend order is:

1. the adapter-specific native proof system: always available and authoritative;
2. nauty 2.9.3: implemented as an optional external baseline;
3. bliss: reserved in the backend-neutral schema for a later adapter.

The nauty crate is excluded from the main Cargo workspace and has its own lock.
Consequently the main locked/offline build remains pure Rust and self-contained.

## Colored-incidence v1

`sparse-shadow-colored-incidence/v1` encodes enabled Paper-I inputs as an
undirected vertex-colored graph:

- nodes `0..n` represent shadow vertices;
- their colors encode the exact `(color, weight, sign, calibrated-membership)`
  tuple;
- every relation edge becomes one new node;
- an edge-node's color identifies its relation by frozen semantic order;
- each edge-node is adjacent to exactly its two original endpoints.

The two endpoint incidences make each edge-node uniquely determined, so a
color-preserving automorphism of the encoding restricts exactly to an
automorphism of the relational shadow and conversely. The Paper-I fixture has
78 encoded vertices and 132 incidence edges. Directed relation ports are not
defined in v1 and therefore fail closed.

For Paper II, the encoding has 12 endpoint nodes, 22 sheet-colored matching
nodes, and 132 secant nodes. Each secant node is joined to its two endpoints
and its matching node. Its color-preserving automorphism group is therefore the
cubic-oriented trade stabilizer; nauty 2.9.3 independently returns order 660.
Paper IV uses one colored node per weighted pair.

For Paper V, 15 sign-colored edge nodes encode the conference matrix. Six
three-node directed gadgets encode the outer lift with distinct source and
target port colors. The resulting 39-node, 54-edge graph has the same trivial
marked automorphism group as the native certificate.

## Comparison contract

`sparse-shadow-backend-comparison/v1` records an engine descriptor and two
observations: one for the raw input and one for the native canonical payload.
The comparison succeeds only when:

1. both external canonical-graph digests are identical; and
2. both external automorphism orders equal the native certified order.

This avoids requiring different engines to choose the same canonical vertex
numbering. Search-node counts are evidence tied to the recorded engine version
and options, not correctness criteria. The native canonical ID remains the only
project canonical identity.

The external canonical digest hashes compact JSON for the three-element array
`[encoding_schema, canonical_colors, canonical_edges]`. Colors are listed in
the backend's canonical vertex order; undirected edges are `[min,max]`, sorted
lexicographically. This byte contract is backend-neutral even though different
engines may select different canonical orders; agreement is required only
between two inputs observed by the same recorded engine/configuration.

The interface names both `nauty` and `bliss`, but only the optional nauty crate
currently constructs an observation. A bliss adapter must reuse this exact
encoding and comparison contract or introduce an explicitly reviewed new schema.
