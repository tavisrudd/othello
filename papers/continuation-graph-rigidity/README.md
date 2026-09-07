# Reconstructing projective frames from their continuation graphs

Tavis Rudd — first draft, September 2026.

For a four-point projective frame over a finite field of order at least 13,
its uncoloured conflict graph determines the field order and the plane/frame
up to semilinear equivalence. Every graph isomorphism extends uniquely.
The written proof also gives polynomial recognition over a supplied field and
an independently checkable coordinate transport.

An exact finite census settles orders 5, 7, 8, 9 and 11. Orders 5 and 8 each
have two four-pencil resolutions and an ambient subgroup of index two;
orders 7, 9 and 11 have a unique resolution and only ambient automorphisms.
The stable-range proof does not depend on the census.

## Read and check

- [Manuscript PDF](continuation_graph_rigidity.pdf)
- [LaTeX source](continuation_graph_rigidity.tex)
- [Verification scope and commands](verification/README.md)
- [Citation metadata](CITATION.cff)

With Nix installed, from this directory:

```sh
nix develop --command make check
nix develop --command python3 verification/check_manuscript_build.py
```

`make pdf` in the development shell refreshes the PDF through two deterministic
builds. The finite census can also be regenerated with `make boundary`.

## Scope and trust

This is a first draft, not a claim of completed external referee review.
No theorem is claimed to be Lean-formalized. The small-order census is
independently replayed exact computation, with Python/Sage/nauty in its trust
base. The reference recognition tests cover relabelled prime-field examples
at orders 13, 17 and 19; the written algorithm accepts any supplied finite field.
Full continuation-complex reconstruction is discussed only as background.
The paper makes no game-value or generic solver-speedup claim.

The manuscript and accompanying software are distributed under the MIT license.
No DOI is assigned in this draft's citation metadata.
