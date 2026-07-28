# Paper: Local-unitary rigidity of stabilizer AME states

**Title:** *Local-Unitary Rigidity of Stabilizer AME States and
Transversal Clifford Groups of MDS--CSS Codes.*

**Lane:** `ame-lu`

**Status:** post-version-1 general-theorem revision. Every local-unitary
intertwiner between arbitrary additive stabilizer `AME(2m,q)` states is
local Clifford, for every prime power and \(m\geq2\).  Transversal
conversions between the associated stabilizer `[[2m-1,1,m]]_q` quantum-MDS
encoders are Clifford factor by factor; over odd prime fields the MDS--CSS
specialization has exact projective
transversal logical group `F_q^2 ⋊ SL_2(q)`, and diagonal isoduality is the
exact all-length condition for that group rather than the split-torus
alternative.  The six-party pencil and logical-phase applications retain
their existing scopes. Public identifiers,
author metadata, license choice, and submission authorization remain author
gates.

The formal companion distinguishes the kernel-checked
finite-coordinate, minimum-support, diagonal-axis, and Choi cores from the
remaining stabilizer-state/reduced-density composition.  The previous
release is superseded; the current content-addressed manifest pins this
revision.
Its version-independent archival locator is the Zenodo concept DOI
[`10.5281/zenodo.21650878`](https://doi.org/10.5281/zenodo.21650878).

## Build

From this directory:

```text
make check
```

The build driver is `main.tex`; section units are under `sections/`.

The `supplement/` directory contains the paper-local report, exact generators,
compact certificates, load-bearing input, SHA-256 manifest, and deterministic
replay driver for every adopted computation.  Run `make evidence` for the
integrity gate or `python3 supplement/verify.py --replay` for full regeneration.

The `release/` directory contains the immutable release manifest and its
verifier. Run `make release-check` for the warning-free manuscript build, full
evidence replay, and release-manifest verification.

## Mathematical scope

The headline theorem studies arbitrary additive stabilizer `AME(2m,q)`
tensors.  Linear `[2m,m,m+1]_q` MDS--CSS states supply the exact-group and
geometric specialization; the detailed applications use `AME(6,q)` tensors
from six-point projective arcs.  Its proved core is:

1. uniform LU-to-LC rigidity and factorwise rigidity of transversal encoder
   conversions;
2. the field-generic one-dimensional diagonal-multiplier/nullity test and
   the resulting exact full-Clifford versus split-torus transversal
   dichotomy over odd prime fields;
3. exact local-Clifford classification of the admitted non-GRS pencil by one
   bracket scalar `z`;
4. the `SL_2(q)` versus split-torus logical-Clifford phase on and off the GRS
   locus;
5. exact splitting of twelve concrete party-permutation extensions, with odd
   motion enlarging `T` to `N(T)` on the listed non-GRS/H3 rows;
6. uniform arbitrary-LU separation of good H3 reductions from every GRS
   class;
7. an exact four-copy separator for the difficult `q=13` pair; and
8. a transport-sheaf explanation of the exceptional contraction divisor and
   its multiplicities.

Fixed-copy permutation contractions cannot supply a generic pencil
coordinate: on an equal-phase linear-code state each is a power of `q`
determined by a linear-system rank.  Their maximal minors detect special
rank-jump divisors, but their values are generically constant.

For the admitted odd non-GRS pencil, equal-phase MDS stabilizer rigidity and
the pencil-classification theorem give `LU iff LC iff z equality`.  The
additive-stabilizer theorem is stronger: every LU intertwiner between
stabilizer AME states is factorwise Clifford.  This is a theorem for the
stabilizer-AME class, not a revival of the false global LU--LC conjecture
for arbitrary stabilizer states.

## Evidence

The claim-level artifact map, exact replay commands, and trust boundaries are
recorded in `supplement/EVIDENCE.md`.
