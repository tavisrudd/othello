# C462 — `Z/4` Galois torsor and the `kappa` descent obstruction

**Lane:** `crowns`

**Date:** 2026-07-21

**Verdict:** `GREEN — THE FOUR H3 COMPANIONS FORM A CANONICAL Z/4 GALOIS TORSOR; THE M3A DESCENT FAILURE IS EXACTLY THE FREE KAPPA SELECTOR OBSTRUCTION`

## Theorem

Let `E = Z[zeta_5,1/10]`, `O = Z[phi,1/10]`, and let
`sigma(zeta_5)=zeta_5^2`, so `sigma^2=kappa` is complex conjugation.  On C443's frozen golden
12-point conic configuration, the `sigma`-image is projectively equivalent to the original.  There
are exactly 60 correcting conic projectivities, forming one torsor under the frozen order-60 golden
`A5` normalizer.  Although the correcting projectivity is not unique, all 60 induce the same
permutation on the four one-factorizing companion orbits:

```text
sigma = (0 2 3 1),             sigma^2 = (0 3)(1 2) = kappa.
```

Thus the four companions are a free transitive `Gal(Q(zeta_5)/Q) = Z/4`-set under the frozen
labeling.  This is canonical at the orbit level: changing the correction by a golden `A5` element
does not change a companion orbit.

The companion-to-special-fibre bijection is

| companion | `zeta_5 mod 11` | golden prime | frozen sheet |
|:--:|:--:|:--:|:--:|
| `c0` | 4 | `pi` (`phi=8`) | base |
| `c1` | 5 | `pibar` (`phi=4`) | outer |
| `c2` | 9 | `pibar` (`phi=4`) | outer |
| `c3` | 3 | `pi` (`phi=8`) | base |

It sends the `kappa`-pairs `{c0,c3}` and `{c1,c2}` to `{3,4}` and `{5,9}`.  The residue action
`z -> z^2` induces the inverse orientation `(0 1 3 2)` of the displayed companion 4-cycle; these
are the two square roots of the same frozen `kappa`.  The orientation depends on whether the
correcting identification is read from the original configuration to its `sigma`-image or back,
while the `Z/4` torsor and its square do not.

Finally, the degree-one pair-average discrepancy is identical on both `kappa`-pairs:

```text
[0,0,0,0,2,0,0,7,0,2,0,0,0,0,0] in F_11^15,
sha256 = 5369f349c2c6a15004769fa5b6466bbd2ecbdcdb18ef45ca40358649709d115c.
```

The checker recomputes both vectors and verifies that each hash is exactly the C443 certificate's
degree-one `mu_at_pi` hash.  The lower-moment obstruction is therefore Galois-invariant, not a
labeling artifact.

## Exact descent statement

The base-changed object is the four companion one-factorizations together with their equivariant
map to the two golden primes above 11 and the frozen base/outer sheet labels.  It is defined over
`E = Z[zeta_5,1/10]`.  Here 2 is inverted because a displayed correcting projectivity has
determinant norm `16` (and the pair averages use `1/2`), while 5 is inverted because
`Z[zeta_5]/Z[phi]` is ramified above 5; after this localization the `kappa` extension is finite
etale.  Crucially, 11 is not inverted, so all four certified special fibres remain available.

Over either `O`-prime above 11, the decomposition group is `<kappa>`.  It swaps the two companions
in that fibre:

```text
pi:    {c0,c3},       pibar: {c1,c2}.
```

Hence its character `<kappa> -> C2` is surjective.  C448's selector lemma applies literally: there
is no equivariant point-valued companion section.  This is precisely the M3a descent obstruction.
The unordered four-object family does descend as an orbit-valued object; what does not descend is
a chosen companion in each prime fibre.  This distinction prevents the torsor theorem from being
misread as a revival of C443's tensor construction.

## Paper-facing recommendation and boundary

Phase 3/C445 may replace paper 1's cut tensor clause by the base-changed equivariant companion-sheet
family together with the proved `kappa` selector obstruction.  It must not claim that this family
supplies an M3a tensor, that a rank-four companion module satisfies any M3a acceptance item, or that
CRT interpolation repairs the failure.  C461's zero lower-moment kernel still rules out every
linear weighting of the four companion moment sums.

This result is H3-only.  It makes no cross-Coxeter law, novelty, or priority claim and does not edit
either manuscript.

## Reproducibility

From `/home/tavis/src/othello`:

```bash
uv run python3 notes/2026-07-21-c462-torsor-descent.py --check
uv run python3 notes/2026-07-21-c462-torsor-descent-replay.py
```

Intentional regeneration is the primary script without `--check`.  It reconstructs C443/C461's
four companions and all four reductions, exhaustively enumerates the conic projectivities, checks
the golden normalizer, recomputes both degree-one discrepancy vectors, and writes timestamp-free
canonical JSON.  The independent replay does not import the C462 checker: it rebuilds the golden
geometry and companions, checks the recorded correcting witness, recounts the 60 corrections using
a different source frame, and rechecks the torsor, residue, and discrepancy invariants.
The primary `--check` command also verifies every SHA-256 hash and byte count in the adjacent
manifest.

The trusted boundary is exact rational arithmetic in `Q(zeta_5)`, exact `F_11` arithmetic,
exhaustive enumeration of 10,395 perfect matchings and the conic projectivities determined by
ordered triples, and the hash-pinned frozen inputs listed in the JSON.  There is no randomness,
floating point, literature claim, or scratch artifact in the evidence boundary.
