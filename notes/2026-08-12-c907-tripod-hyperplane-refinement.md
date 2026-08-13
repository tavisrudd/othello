# C907 exact tripod hyperplane refinement

**Lane:** `clebsch`

`2026-08-12-c907-tripod-hyperplane-refinement.py` is an exact deterministic
serialization of the six-weight hyperplane complex asserted in
`2026-08-12-c907-tripod-common-prefan.md`.  It uses Polymake 4.15 with the
exact rational Parma Polyhedra Library backend, not floating point arithmetic.
It is the possibly nonsimplicial, nonregular rational hyperplane complex
itself; no regular or integral refinement is asserted.

For each ordered stratum in
`{g,0,1,infinity}^2`, the generator substitutes the relevant ray coefficients
in the six homogeneous weights

```text
0, p1, p2, p3, -p1-p2-p3+rB+rC, 2t-sB-sC
```

and enumerates all fifteen equality hyperplanes `w_i=w_j` over the rational
support cone.  The resulting JSON records every nonempty slice cell through
its generating rays and complete fifteen-character `+/-/0` sign vector.  The
zero entries are exactly its tie hyperplanes; ray containment reconstructs
the face incidence, while the stored cover-incidence counts give a compact
audit of every adjacent pair of dimensions.  Each ordered cone is linked to
its local support report.

The computation is deliberately the finite support refinement only.  It does
not identify normalized saturated graphs or Fitting ideals across the
nonmonomial pair-of-pants transitions, and it does not prove collar topology.

## Upper-envelope compression

The full arrangement has many cells because it remembers the complete order
and every tie among all six weights.  The graph initial form uses only the
maximal-weight tie support.  The certificate therefore includes, for each
ordered cone, an `upper_envelope` table of feasible nonempty maximal-weight
masks and the number of full slice cells mapping to each.  This is a checked
normal-complex/upper-envelope compression: every serialized cell is assigned
to exactly one mask, and the aggregate total equals its cone's complete cell
count.  It does not regularize the modification or replace the full
hyperplane-complex incidence data.

## Replay

From the repository root:

```sh
nix shell nixpkgs#python3 --command python3 \
  notes/2026-08-12-c907-tripod-hyperplane-refinement.py --check
```

The replay invokes `nixpkgs#polymake` itself.  It performs sixteen exact
rational cone enumerations serially, prints one bounded completion milestone
per cone, regenerates the canonical JSON in memory, and checks both its bytes
and the two SHA-256 entries.  `--write` is the deliberate regeneration mode.

`2026-08-12-c907-tripod-hyperplane-refinement.sha256` covers the generator and
the JSON certificate.  The JSON's `checks` field additionally refuses an
inconsistent sign assignment, so a purported face crossing one equality
hyperplane cannot be serialized.
