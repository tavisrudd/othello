# C372 — Fourier self-duality of the Clebsch syndrome scheme

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `THEOREM; EXACT FOURIER SELF-DUALITY; PRIMITIVE RANK-EIGHT A5 FISSION`

## Theorem

Let `V=F_11^3`, let `A5` be C341's reduced projective `H3` group, and let

```text
H = F_11^* x A5.
```

The eight orbitals of `V semidirect H`, ordered as

```text
0, column_D5, triple_S3, deep_hole_C5, double_V4,
single_secant_C2_1, single_secant_C2_2, single_secant_C2_3,
```

form a primitive Fourier-self-dual translation association scheme.  The reduced `H3` form is the
ordinary dot product in C341's coordinates.  Its projective matrices satisfy
`g^T g = lambda_g I`; hence the contragredient action of `a g` is the action of another scalar
multiple of `g`.  The induced identification `V -> V*` therefore carries every primal orbit to the
dual orbit with the same label.

In the displayed ordering the first and second eigenmatrices are equal:

```text
P = Q =
  1  60  100  120  150  300  300  300
  1  -6  -10   10   40  -30   25  -30
  1  -6  -10  -12   18   36  -30    3
  1   5  -10   -1  -15   25   25  -30
  1  16   12  -12    7   -8   -8   -8
  1  -6   12   10   -4    3   -8   -8
  1   5  -10   10   -4   -8   -8   14
  1  -6    1  -12   -4   -8   14   14.
```

Thus the multiplicities equal the valencies

```text
1, 60, 100, 120, 150, 300, 300, 300,
```

and `P^2=1331 I` in these self-dual conventions.  The entire Krein tensor equals C341's entire
intersection tensor in the same ordering.  This is formal self-duality and an explicit Fourier
self-duality, not merely equality of unordered parameter lists.

## Conceptual character sum

Every nonzero relation is a union of full scalar lines.  If `L` is such a projective line and
`chi_y(x)=zeta_11^(y dot x)`, then

```text
sum_{a in F_11^*} chi_y(a x) = 10  if y dot x = 0,
                              -1  otherwise.
```

Consequently an orbit containing `ell` projective lines, exactly `z` of them perpendicular to `y`,
has Fourier eigenvalue `11z-ell`.  Exhausting the eight-by-eight table of these integer hyperplane
counts gives the matrix above without numerical cyclotomic approximation.  Independently, the
checker verifies that these rows simultaneously diagonalize all eight multiplication matrices from
C341's intersection tensor, computes `Q=1331 P^(-1)` over exact rationals, and reconstructs every
Krein parameter from `P,Q`.

## Primitivity and every fusion

An exhaustive test of all `2^7` unions of nonidentity relations finds only `{0}` and all of `V` as
additive subgroups.  The scheme is therefore primitive.

The Bannai--Muzychuk row-sum test was applied to all `Bell(7)=877` partitions of the nonidentity
relations.  Exactly four fusions exist when the original rank-eight scheme and trivial rank-two
fusion are included:

| rank | relation blocks (indices in the theorem ordering) | dual idempotent blocks |
|---:|:---|:---|
| 2 | `0 | 1234567` | `0 | 1234567` |
| 4 | `0 | 3 | 156 | 247` | `0 | 156 | 247 | 3` |
| 6 | `0 | 2 | 13 | 45 | 6 | 7` | `0 | 13 | 2 | 45 | 6 | 7` |
| 8 | `0 | 1 | 2 | 3 | 4 | 5 | 6 | 7` | the same singleton partition |

The rank-four fusion is the standard quadratic-form fusion: relation 3 is isotropic; `1,5,6` are
nonsquare norm; and `2,4,7` are square norm.  Thus the rank-eight object is precisely an
`A5`-Schurian fission of the three-class affine orthogonal translation scheme.  The rank-six fusion
is an additional exact algebraic fusion; this report makes no unproved Schurian or catalogue-family
identification for it.

## Catalogue and isomorphism boundary

The result is separated exactly from several tempting identifications:

- it is not a one-dimensional cyclotomic scheme on `F_1331`, whose nonzero cyclotomic classes have
  equal size, because its nonzero valencies are unequal;
- it is not pseudocyclic, because its seven nonprincipal multiplicities are unequal;
- it is not the standard affine orthogonal scheme itself, but a proper rank-eight fission of its
  rank-four fusion; and
- the Hanaki--Miyamoto small-scheme catalogue cannot test this object: its public classified data
  cover small orders (the main table through 30), whereas this scheme has order 1331.

The exact intersection tensor fixes the **algebraic-isomorphism class as a based Bose--Mesner
algebra** and is now accompanied by its complete spectral, dual, and fusion invariants.  That does
not decide whether some differently constructed scheme has the same tensor, whether every algebraic
isomorphism is induced by a vertex bijection, or whether the scheme is separable.  Full algebraic
and color-preserving automorphism groups belong to C373.  No combinatorial-isomorphism or
separability conclusion is inferred here.

Accordingly the safe catalogue statement is:

> C341's object is a primitive formally and Fourier self-dual rank-eight `A5`-Schurian fission of
> the standard three-dimensional affine orthogonal scheme at q=11, with exactly two proper
> nontrivial fusions.

This task releases no claim that the fission is new.  A bounded invariant-fingerprint search found
no direct catalogue match, but MathSciNet was not covered and no forward-citation closure was run.

## Literature/read-depth boundary

This task read **zero external papers in full**.  It read one external paper **partially**, one
official catalogue page **partially**, and reused C371's explicitly depth-marked bounded audit.

- Feng, Wen, Xiang, and Yin, *Partial difference sets from quadratic forms and p-ary weakly regular
  bent functions*: **partial**, arXiv `1002.2797`, cached PDF SHA-256
  `9eb10c1321554880d3856e4f4592a4a37aa7fe4b058a40d8fa32dca2027d8f1b`; abstract/introduction,
  extracted lines 80--165 and 245--330.  Used only to place quadratic-form Cayley graphs and their
  association-scheme fusions in prior art; its stated main construction assumes even dimension and
  is not asserted to identify the present rank-eight fission.
- Hanaki--Miyamoto, *Classification of association schemes with small vertices*: **partial web
  page**, official current data page read for its order table, links, and stated partial-results
  boundary.  Used only to establish that order 1331 lies outside that catalogue, never as absence
  evidence for all catalogues.
- C371, `notes/2026-07-19-c371-clebsch-cross-field-literature-audit.md`: **local report, full report
  read**; reused its Q3 ledger and exact `F_11^3/A5` search boundary without upgrading its zero-full-
  text or no-forward-citation limitations.

The added web screen used twelve exact queries (four for the eigenvalue/valency fingerprint, four
for Hanaki--Miyamoto catalogue coverage, and four for affine orthogonal/quadratic-form families) and
screened the 30 displayed title/snippet cards.  It found the official small-order catalogue and the
quadratic-form prior-art source above, but no exact rank-eight fingerprint match.  This is bounded
screening, not a priority verdict.  Google Scholar and MathSciNet remain **NOT COVERED**.

## Reproduction and trusted boundary

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-19-c372-clebsch-scheme-fourier.py --check
sha256sum -c notes/2026-07-19-c372-clebsch-scheme-fourier.sha256
```

The standard-library-only checker pins and imports C341's checker by SHA-256.  It independently
checks conformal preservation of the reduced form, all Fourier hyperplane counts, `PQ=1331I`,
simultaneous diagonalization, the rational Krein formula, every additive imprimitivity union, and
all 877 candidate fusions.  The JSON is canonical and contains the full `P,Q`, hyperplane counts,
Krein matrices, quadratic types, and fusion partitions.

The trusted boundary is Python 3 exact integer/rational arithmetic, exhaustive finite enumeration,
the elementary scalar-line character sum, and C341's pinned orbit construction.  The bundle does
not compute C373's automorphism groups, establish separability, search all association schemes of
order 1331, or prove a novelty/priority claim.
