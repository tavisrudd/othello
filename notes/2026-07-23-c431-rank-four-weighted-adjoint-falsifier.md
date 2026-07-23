# C431 — rank-four weighted-adjoint enumerator falsifier

**Lane:** `crowns`

**Date:** 2026-07-23

**Disposition:** REFUTED for the literal C403 weight `w(X)=m(X)-1`.

## Decision

The finite-field punctured weighted `(r-1)`-adjoint depth spectrum does **not** determine the
rank-`r` arrangement-complement code enumerator in rank four when the C403 weight is continued
literally as

```text
w(X) = number of arrangement mirrors through the rank-three flat X - 1.
```

Two essential eight-mirror arrangements in `PG(3,5)` have the same punctured weighted
3-adjoint depth spectrum and spanning complements of the same length `25`, but different Hamming
weight enumerators. This is an aggregate cospectral pair, not merely two test hyperplanes of equal
depth inside one arrangement.

The counterexample does not touch C403's rank-three theorem. It is also distinct from C403's
higher-*degree* failure: the present failure already concerns the ordinary rank-four linear code,
and is caused by a new restriction-line multiplicity layer rather than a Veronese moment barrier.

## Exact witness

Use normalized projective coordinates over `F_5`; each row is a mirror normal. The first
arrangement is

```text
(0,0,0,1) (0,0,1,0) (0,0,1,1) (0,1,0,0)
(0,1,1,2) (1,0,0,0) (1,1,3,0) (1,4,3,4).
```

The second is

```text
(0,0,0,1) (0,0,1,0) (0,0,1,1) (0,1,0,0)
(0,1,2,1) (1,0,0,0) (1,2,3,0) (1,3,4,4).
```

Both punctured depth spectra are

```text
7:1, 8:5, 9:6, 10:13, 11:19, 12:19, 13:11,
14:16, 15:14, 16:19, 17:16, 18:4, 19:3, 20:2.
```

Their code weight enumerators are respectively

```text
1 + 4z^14 + 4z^16 + 36z^17 + 64z^18 + 124z^19
  + 160z^20 + 144z^21 + 52z^22 + 4z^23 + 32z^25
```

and

```text
1 + 4z^14 + 4z^16 + 40z^17 + 48z^18 + 148z^19
  + 144z^20 + 148z^21 + 52z^22 + 4z^23 + 32z^25.
```

Each coefficient sum is `5^4=625`. Both codes retain minimum distance `14`; the falsifier splits
the full enumerator rather than length or minimum distance. More sharply, with the second witness
minus the first,

```text
W_2(z)-W_1(z) = 4z^17(1-z)^4.
```

Thus the zeroth through third falling-factorial weight moments also agree. The first loss is
fourth-order even though the geometric cause is the rank-four restriction-line layer.

## Why rank three does not port

Fix a nonmirror test hyperplane `U`. Restrict the arrangement mirrors to projective lines in
`PG(U)`. Let the distinct restriction lines be `ell`, let `a_ell` be their multiplicities, let
`k_P` be the number of distinct restriction lines through `P`, and put

```text
t_ell = number of points P on ell with k_P >= 2,
E(U) = sum_P (k_P - 1).
```

The rank-three flats of the original arrangement contained in `U` are exactly the points with
`k_P >= 2`. Therefore the literal weighted-adjoint depth is

```text
D(U) = E(U) + sum_ell (a_ell - 1)t_ell.
```

Counting the union of the distinct restriction lines gives the exact section identity

```text
|B cap U|
 = q^2+q+1 - N(q+1) + D(U)
   + sum_ell (a_ell-1)(q+1-t_ell).
```

The final term counts unhit points on duplicated restriction lines. It is invisible to `D(U)`.
The certificate checks this identity for every nonmirror test in both aggregate witnesses.

The cheaper mechanism witness already occurs for five mirrors: two nonmirror tests have the same
depth `6` but complement-section sizes `16` and `12`. That local failure kills the direct C403
pointwise transform; the eight-mirror pair above closes the stronger aggregate-spectrum claim.

## Exact search boundary

The deterministic search fixes the four coordinate normals as a projective basis. It exhausts all
`152` normalized five-mirror extensions and all `11,476` normalized six-mirror extensions over
`F_5`. It then generates `300,000` distinct size-eight residual four-sets with Python's
`random.Random(431)`, sorts them canonically, and stops at sample `2,056`, where the first searched
aggregate pair appears. In total it checks `13,684` normalized arrangements, of which `13,678`
have spanning complements.

This is not a minimality claim: size seven was not part of the final certificate, and the
size-eight sample is not exhaustive. Only the displayed pair and the stated completed domains are
claimed.

## Evidence and replay

Artifacts:

- `notes/2026-07-23-c431-rank-four-weighted-adjoint-falsifier.py` — deterministic generator and
  checker, `18,787` bytes;
- `notes/2026-07-23-c431-rank-four-weighted-adjoint-falsifier.json` — canonical certificate,
  `18,848` bytes;
- `notes/2026-07-23-c431-rank-four-weighted-adjoint-falsifier.sha256` — hashes.

From the repository's `rust/` directory:

```text
python3 ../notes/2026-07-23-c431-rank-four-weighted-adjoint-falsifier.py \
  --check ../notes/2026-07-23-c431-rank-four-weighted-adjoint-falsifier.json
```

The finder uses projective-incidence bitsets. On a hit, a separate coordinate implementation
recomputes the rank-three flats and both depth spectra, enumerates all `625` coefficient vectors
directly, checks the projective enumerator independently, and verifies the restriction-line
identity above for every nonmirror. The trusted boundary is Python integer arithmetic, the
explicit `F_5` row reduction and projective normalization, and the standard library. No external
package, random oracle, or untracked input is used.

## Scope and hand-back

The exact pair refutes the literal positive-weight continuation `w(X)=m(X)-1`. The certificate
also records the alternative spectra with `w(X)=|mu_A(X)|`; those spectra distinguish this pair,
so the Möbius-weighted variant is neither proved nor refuted here. C431 stops at the first exact
aggregate counterexample as required.

No literature-priority or novelty claim is made. The only external mathematical boundary retained
from C403 is that Liang--Wang--Zhao's general adjoint construction does not by itself supply the
missing finite-field restriction-line correction.

## Extra-juice closeout and mystery ledger

The free closeout upgrades are:

1. the five-mirror local witness isolates the exact pointwise failure before the aggregate pair;
2. the restriction-line identity identifies the missing statistic rather than reporting a black-box
   census failure;
3. direct enumeration shows that the shared depth spectrum still leaves length and minimum distance
   unchanged in this pair, so the first loss is genuinely inside the weight distribution;
4. the exact difference factors as `4z^17(1-z)^4`, proving for free that all weight moments below
   order four agree.

Mysteries:

- **Settled:** why the rank-three incidence proof does not port — duplicated restriction lines
  contribute the explicit unhit-point correction.
- **Settled:** how shallow the enumerator split is — its exact fourth-difference factor shows that
  orders zero through three are silent.
- **Open but outside C431:** whether `|mu_A(X)|` weighting, a signed finite-field Möbius transform,
  or an augmented spectrum carrying the correction term restores a rank-four theorem. This witness
  does not decide those variants.
- **No hidden minimality claim:** the least field and least mirror count for an aggregate pair remain
  unsearched; C431's stop gate did not require them.

No incidental discovery-track entry is warranted: every observation above was sought in order to
explain or delimit the C431 falsifier.
