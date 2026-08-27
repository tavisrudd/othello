# High-Weight Cosets of Generalized and Extended Reed--Solomon Codes

[![Concept DOI](https://img.shields.io/badge/Concept_DOI-10.5281%2Fzenodo.21682069-blue.svg)](https://doi.org/10.5281/zenodo.21682069)

## Read the paper

[**Open the archival paper (PDF) →**](high-weight-grs-cosets.pdf)

[**Open the IEEE TIT version (PDF) →**](high-weight-grs-cosets-tit.pdf)

**Title:** *High-Weight Cosets of Generalized and Extended Reed--Solomon
Codes*

The weight of a coset is the minimum Hamming weight of a vector in it. Let a
redundancy-`r` generalized Reed--Solomon code have evaluation set

```text
S = P¹(F_q) \ A,              |A| = s,
```

and arbitrary nonzero coordinate multipliers. The paper classifies every
coset of weight at least `r−1` for arbitrary redundancy `r ≥ 6` under the
explicit bound

```text
q ≥ 6(r+s) − 16 + floor(2 sqrt(6(r+s) − 18)),
char F_q > r−1.
```

The support may therefore be the full projective line or may have any
prescribed finite set of points deleted; the answer depends on the size of the
deleted set, not its placement or the column multipliers.

## The two high-weight shells

Write `d_S(f)` for the weight of the coset with projective syndrome direction
`f`. The classification is:

| Support | Covering radius | Weight `r` | Weight `r−1` |
|---|---:|---|---|
| `s=0` | `r−1` | none | tangent and conjugate-secant directions |
| `s>0` | `r` | the `s` omitted curve points | tangents, conjugate secants, and interiors of rational secants incident with `A` |

The numbers of projective directions are

```text
N_r     = s,
N_{r−1} = q(q+1)²/2 + (q−1)s(2q+1−s)/2.
```

For full support, the second formula reduces to `q(q+1)²/2`. Literal nonzero
coset counts are obtained by multiplying by `q−1`.

Appending `f` as a parity-check column gives

```text
d(ker[H_S | f]) = d_S(f) + 1.
```

Consequently, the weight-`r` shell gives exactly the MDS one-column
extensions, the weight-`r−1` shell gives exactly the NMDS extensions, and all
other columns have Singleton defect at least two. Exact family-wise
minimum-support counts determine the complete aggregate weight enumerator of
each NMDS family.

## Why the classification closes

The syndrome kernel is a two-row Hankel system. A weight-`r−2`
representation is equivalent to a split squarefree binary form in that
kernel. The proof constructs such a form in three stages:

1. **Recursive carrier theorem.** Coherent polar contraction reduces all
   redundancies to a terminal pencil of binary cubics. Every contraction
   trapped in the terminal bad locus comes from the catalecticant rank-two
   scheme or one explicit characteristic-dependent Lucas carrier.
2. **Simultaneous finite-field selection.** A degree-six selector chooses all
   `r−5` contraction roots at once while avoiding the deleted set and marker
   collisions. In characteristic two the selector has degree four and gives
   the sharper bound
   `6(r+s)−22+floor(2 sqrt(6(r+s)−24))`.
3. **Terminal cubic count.** An exact genus-one count supplies a split cubic
   avoiding the selected roots and `A`. Multiplying it by the marker form
   produces the required degree-`r−2` locator.

In every characteristic, before the tame-characteristic shell arithmetic is
used, the proof gives the structural containment

```text
d_S(f) ≥ r−1  =>  f lies in the rank-two locus or the maximal Lucas carrier.
```

Exact redundancy-five through redundancy-seven results provide sharper
small-field and modular refinements. The R8--R10 calculations are retained as
companion records but are not included in the paper's theorem set.

## Main consequences

- Complete top-two-shell and covering-radius descriptions for the stated
  point-deleted GRS/EGRS family.
- Exact projective and literal-coset counts for both shells.
- Classification of every MDS and NMDS one-column extension in the family.
- Family-wise minimum-support counts and complete aggregate NMDS weight
  enumerators.
- An all-characteristic arbitrary-redundancy carrier theorem with an explicit
  Lucas description.
- A deterministic fixed-`r` construction of shallow locator witnesses outside
  the two carriers, plus a quantitative abundance bound.
- Exact R5 cubic-pencil splitting counts in every characteristic and sharp
  R5--R7 fixed-level refinements.

## Proof and evidence boundary

The manuscript contains the mathematical proof from the explicit terminal
scheme to the coding-theoretic classification. Its sole computer-algebra
input to the uniform theorem is the reduced terminal decomposition in
Proposition IV.2: the ordered-pair equation, elimination ideal, Hankel--Plücker
pullback, saturation, and resulting characteristic-wise primes are printed in
the paper. Certificate SC supplies deterministic Python and Singular
elimination replays. Recursive component selection, simultaneous marker
selection, the genus-one count, shell transfer, and the enumerative double
counts are mathematical arguments.

The covering-radius and MDS-extension inputs use pinpointed results of
Seroussi--Roth and Dür. Every imported result and convention match is recorded
in [`verification/imported-sources.json`](verification/imported-sources.json).
The electronic supplement maps every manuscript claim to its human proof,
formal fragment, imported source, or exact computational evidence.

The Lean companion checks coordinate algebra, contraction and budget
identities, density and closure interfaces, component selection, and
conditional synthesis statements. It does not formalize the terminal
component geometry, finite-field covering theorems, or certificate semantics.
Exact declarations and hypotheses are listed in
[`supplement/LEAN-STATEMENTS.md`](supplement/LEAN-STATEMENTS.md).

## Verification

From this directory, run

```text
make check
make tit-check
make software-check
make supplement-check
```

These commands lint and rebuild both manuscripts, reject TeX warnings, run the
companion software's formatting, Clippy, unit, CLI, and property tests, and
verify the classification records, evidence and software manifests, manuscript
annotations, release-local hashes, and formal-scope map. Add `--replay` to

```text
python3 supplement/verify.py --replay
```

to execute every paper-local Python replay. The two Singular replays and the
heavier software regressions have separate commands in
[`supplement/REPRODUCING.md`](supplement/REPRODUCING.md). No verification
command uploads, publishes, or deposits an artifact.

## Companion software

[`software/projective-reed-solomon/`](software/projective-reed-solomon/)
contains a proof-carrying structural decoder. Its `projective-reed-solomon`
executable provides `canonicalize`, `distance`, `decode`, `classify`, `verify`,
and `simultaneous-locator` commands. It uses versioned JSON requests and
returns exact canonical forms, nearest-error data, or replayable locator
certificates.

Canonicalization and budgeted decoding work beyond the paper's fixed-level
refinements. The theorem registry remains fail-closed: computation outside a
proved classification domain cannot create a positive deep-hole claim. See
the [software README](software/projective-reed-solomon/README.md) for runnable
examples and exact trust semantics.

## Files

- `high-weight-grs-cosets.pdf` is the 43-page archival paper.
- `high-weight-grs-cosets.tex` is its manuscript driver.
- `high-weight-grs-cosets-tit.pdf` is the 31-page IEEE TIT version.
- `high-weight-grs-cosets-tit.tex` is the corresponding submission driver.
- `sections/` contains the common theorem spine and fixed R5--R7 refinements.
- `supplement/companion-source/` preserves the R8--R10 companion record; its
  `README.md` records the status of archival branches not used by this paper.
- `verification/` contains the claim, evidence, and imported-source maps.
- `supplement/` contains reproducibility instructions, manifests, exact
  records, replays, and toolchain locks.
- `software/projective-reed-solomon/` is the separately MIT-licensed toolkit.
- `.zenodo.json` contains deposit metadata.

## Scope

The complete shell classification assumes `char F_q > r−1`. In smaller
characteristic the paper proves carrier containment but does not classify
every high-weight point inside later Lucas carriers. It does not claim an
optimal field threshold, equality of individual NMDS extension enumerators,
nilpotent structure for an integral terminal model, or the general
Reed--Solomon deep-hole conjecture.

## Citation

The concept DOI for all versions is
[`10.5281/zenodo.21682069`](https://doi.org/10.5281/zenodo.21682069). The
immutable Version 1 release, `v0.1.0`, has version DOI
[`10.5281/zenodo.21682216`](https://doi.org/10.5281/zenodo.21682216). The
current revision will receive its own version DOI when deposited.

## License

The manuscript and scholarly supplement are licensed under the Creative
Commons Attribution 4.0 International License; see [`LICENSE`](LICENSE).
The companion software is separately licensed under the MIT License.
