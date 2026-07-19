# C336: exact evaluation and conic-recovery tower on the C329 arcs

**Lane:** `crowns`

**Date:** 2026-07-18

**Status:** theorem complete on the three-distinct-carrier C329 subfamily; all five parameter rows,
minimum curves and minimum-word counts are exact. The locality mechanism is classical, while the
exact five-code tower and its `2Q+Q+Q` extremal geometry survive the literature gate.

## Theorem

Let `F=GF(Q)`, where `Q=2^n`, `n` is odd, and `Q>=2^45`, and let `E=GF(Q^2)`. On
C329's repair-conic coincidence stratum choose the collision-free arc

    A=A_0 disjoint_union A_1 disjoint_union A_2 subset PG(2,E)

with `|A_0|=2Q` and `|A_1|=|A_2|=Q`, where `A_i` lies on the nonsingular conic

    K_i: XZ+Y^2+k_i X^2=0.

There is such a C329 choice with `K_0,K_1,K_2` pairwise distinct. Indeed the heights are
`k_0=H`, `k_1=H+Gamma_alpha`, and `k_2=H+Gamma_beta`. The standing condition
`Gamma_alpha+Gamma_beta notin F` already separates the seed carriers; adjoining the two proper
deletions `Nm(Gamma_alpha) Nm(Gamma_beta)!=0` to C329's nonzero skeleton open separates both from
the repair carrier. Their total added degree is four, so C329's `Q>=2^45` existence count is
unchanged. Distinct members of this pencil meet only at `[0:0:1]`, which is not selected.

Evaluate all homogeneous degree-`d` forms at the normalized affine representatives of `A`, and
write the resulting `E`-linear code as `C_d(A)`. For `1<=d<=5` its exact parameters are

| `d` | `k=binom(d+2,2)` | maximum zeros `z_d` | minimum distance `4Q-z_d` |
|---:|---:|---:|---:|
| 1 | 3 | `2` | `4Q-2` |
| 2 | 6 | `2Q` | `2Q` |
| 3 | 10 | `2Q+2` | `2Q-2` |
| 4 | 15 | `3Q` | `Q` |
| 5 | 21 | `3Q+2` | `Q-2` |

The complete minimum-form and minimum-word classification is:

| `d` | minimum forms up to a nonzero scalar | number of minimum words |
|---:|---|---:|
| 1 | a secant of `A` | `(Q^2-1) binom(4Q,2)` |
| 2 | `K_0` | `Q^2-1` |
| 3 | `K_0 L`, where `L` is a secant of `A_1 union A_2` | `(Q^2-1) binom(2Q,2)` |
| 4 | `K_0K_1` or `K_0K_2` | `2(Q^2-1)` |
| 5 | `K_0K_1L_2` or `K_0K_2L_1`, where `L_i` is a secant of `A_i` | `2(Q^2-1) binom(Q,2)` |

Injectivity follows rather than being assumed: every displayed `z_d` is strictly below `4Q`, so
no nonzero degree-`d` form vanishes on all of `A`. Thus the code dimensions really are the full
homogeneous-polynomial dimensions.

## Component and Bezout proof

Let a degree-`d` curve contain exactly the carrier components indexed by `S`, and remove them. The
residual has degree `r=d-2|S|`, contains no remaining `K_i`, and hence meets each such `K_i` in at
most `2r` distinct selected points. For a residual line, the arc condition improves the combined
bound to two selected points. The only potentially maximal cases are therefore:

| `d` | no carrier component | carrier cases that can dominate |
|---:|---:|---|
| 1 | at most `2` by the arc property | none |
| 2 | at most `12` | `K_0` gives `2Q` |
| 3 | at most `18` | `K_0` plus a line gives at most `2Q+2` |
| 4 | at most `24` | two carriers give at most `3Q`; one carrier plus a carrier-free conic gives at most `2Q+8` |
| 5 | at most `30` | `K_0K_i` plus a line gives at most `3Q+2`; one carrier plus a carrier-free cubic gives at most `2Q+12` |

All other carrier choices replace the `2Q` layer by a `Q` layer and are smaller. Since
`Q>=2^45`, every noncomponent bound is strict. Equality forces precisely the components listed in
the classification table. A secant determines its unordered pair uniquely because `A` has no
three collinear points; injectivity then turns the projective form counts into the stated word
counts after multiplication by the `Q^2-1` nonzero scalars of `E`.

This also audits the selected carrier intersections: pairwise-distinct pencil members share only
the unselected point at infinity, so no selected point is silently credited to two components.
The excluded allowed C315--C316 coincidence rows `Gamma_gamma=0` would instead put `3Q` selected
points on `K_0` and invalidate the degree-two row. They are deliberately excluded here, not hidden
inside a generic Bezout assertion.

## Locality and availability

On `K_i`, the parametrization `[1:x:x^2+k_i]` turns a homogeneous degree-`d` form into a univariate
polynomial of degree at most `2d`. Any `2d+1` other selected points on the same carrier therefore
recover the erased value by Lagrange interpolation. Partitioning the other carrier points gives
pairwise disjoint recovery groups and proves

    locality <= 2d+1,
    t_seed >= floor((Q-1)/(2d+1)),
    t_repair >= floor((2Q-1)/(2d+1)).

These are exact counts for the displayed carrier-block construction, not claims that no additional
recovery sets exist. The recovery maps are deterministic `E`-linear combinations whose
coefficients depend only on the chosen evaluation parameters.

## Rate and tradeoff

The block length is `4Q`, while the dimensions `3,6,10,15,21` stay fixed. Hence every fixed row has
rate `binom(d+2,2)/(4Q) -> 0`. Relative distances tend respectively to `1,1/2,1/2,1/4,1/4`, and
carrier availability grows linearly in `Q` at constant locality. Degree one is MDS; the Singleton
defects for degrees two through five are respectively `2Q-5`, `2Q-7`, `3Q-14`, and `3Q-18`.

This is therefore a high-redundancy structural/storage regime with many disjoint local reads, not
an asymptotically rate-optimal LRC family. It is materially worse in rate than the projective-bundle
families below, whose finite-plane examples approach the LRC rate limit and whose higher-dimensional
families are asymptotically good. It is also a punctured, carrier-structured alternative to PRM local
correction, not an improvement over PRM in the general length/message/query tradeoff.

## Source-level literature matrix

The four pinned PDFs were read from the shared cache; exact-title and topic searches were repeated
on 2026-07-18. Exact-title queries in zbMATH Open returned no record for the May 2026 Gatti--Korchmaros--Schulte
preprint, and the public MathSciNet search surface returned no usable record for the 2026 projective-bundle
revision. Thus the verdict is a bounded source-level priority assessment, not a claim of exhaustive
subscription-database coverage.

| source | closest construction/theorem and exact overlap | verdict for a C336 headline |
|---|---|---|
| Gatti--Korchmaros--Schulte, arXiv:2605.11187v1, SHA-256 `45efc77d...4ed4c1b` | Three-dimensional linear systems of symmetric conics give reduced generalized Datta--Johnsen evaluation codes of length about `q(q-1)/2`; Theorem 1 gives a distance bound. It does not evaluate all degree `1..5` plane forms on a `2Q+Q+Q` arc and has no locality/availability theorem. | `SURVIVES` for the exact tower; `STOP` for novelty of “evaluation from conics” itself. |
| Aguilar--Alvarez--Ardila--Ocal--Rodriguez Avila--Varilly-Alvarado, arXiv:2409.04201v3, SHA-256 `708d4449...e29cca` | Affine-plane and projective-bundle evaluation codes recover along fibers, prove locality and availability, achieve optimal/high-rate finite examples, and give asymptotically good families. This is the closest operational baseline, but not the C329 arc or its extremal carrier-component classification. | `NARROW`: claim only the exact C329 tower and carrier partition; interpolation and availability are prior mechanisms. |
| Barg--Tamo--Vladuts, arXiv:1603.08876v1, SHA-256 `9e83dde2...492046` | AG LRCs recover on fibers of curve maps; Section V constructs multiple transversal recovery sets and uses Bezout for distance. Objects, dimensions, and recovery geometry differ. | `NARROW`: Bezout and multiple recovery sets are classical; the exact five-row geometry survives. |
| Lin, arXiv:1702.02671v1, SHA-256 `cf8fce8c...597e40` | PRM evaluates homogeneous degree-`d` forms on all projective points and gives a perfectly smooth `(d+1)`-query decoder by restriction to a line. C336 instead punctures to the C329 arc and restricts to conics, hence `2d+1` queries. | `SURVIVES` as a distinct exact punctured family; `STOP` for novelty of low-degree interpolation-based local correction. |
| Barg--Haymaker--Howe--Matthews--Varilly-Alvarado, arXiv:1701.05212 | LRCs from curves and surfaces extend the general evaluation/fiber framework. No source-level match to the three-carrier arc or minimum-word classification was found. | `NARROW` for the same reason as the two AG-LRC rows. |

Recent exact-topic arXiv searches for union-of-conics evaluation codes with availability found the
projective-bundle paper and general curve/surface LRC work, but no source with this carrier partition,
five exact maximum-zero formulas, or minimum-word counts. Search-engine absence is not used as the
proof of novelty: the defensible claim is the theorem conditional on the newly proved C329 family,
with every classical evaluation, Bezout, and interpolation ingredient separately credited.

## Deterministic replay and trusted boundary

The adjacent script builds `GF(64)/GF(8)` in a polynomial basis, checks the three-carrier equations,
replays one product/secant equality type for each degree, and verifies the `2d+1` Lagrange recovery
identity on every available disjoint block of its small carrier partition. The small partition is
not asserted to pass C329's arc conditions; it tests only the algebraic equality and interpolation
mechanisms. C329's large-field arc existence and the all-`Q` Bezout upper bounds remain proof inputs.
There is no second computational implementation because none of the theorem's upper bounds depends
on this replay; the displayed component proof is the independent, load-bearing cross-check.

Regenerate from `/home/tavis/src/othello` with

    python3 notes/2026-07-18-c336-c329-evaluation-lrc-tower.py \
      --output notes/2026-07-18-c336-c329-evaluation-lrc-tower.json

and independently replay the tracked output and hashes with

    python3 notes/2026-07-18-c336-c329-evaluation-lrc-tower.py --check

The trusted checker boundary is the pure-Python finite-field implementation and ordinary
integer/JSON/SHA-256 support in Python 3. The script is 9,551 bytes with SHA-256
`a2c6fd36e46df6c062590a7e80e09f73dba32ae1a780365b26303a3cb05ff8c5`; the canonical JSON is
1,564 bytes with SHA-256 `6914ab6668bae292432992589bd3d0a1e019f252d06bf935d1edb1001e2e444c`.
The adjacent `.sha256` manifest pins both.

## Vibe check

Strong result with a clean boundary: all five candidate rows pass, the extremal curves and minimum
words are completely rigid, and the doubled carrier genuinely doubles recovery availability. The
tradeoff is intentionally specialized rather than competitive on rate; the paper-facing value is
the exact geometry of the new C329 family, not a generic LRC construction.
