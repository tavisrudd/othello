# C969 literature boundary and PRS-paper upgrade

**Audit date:** 2026-08-25  
**Claim policy:** absence claims below are bounded by the named searches and
read depths. They are not universal priority claims.

## Adopted scope extension

The structural result is no longer confined to the paper's R5--R10 coding
registry. For every full-length projective Reed--Solomon syndrome with
`r>=5`, `q>=r`, the implementation now provides two dimension-independent
operations:

1. exact lexicographic canonicalization under
   `PGL(2,q) x Gal(F_q/F_p)`, with a replayable transporter; and
2. exact syndrome distance and a replayable nearest-error certificate, within
   the explicit candidate budget.

The decoding proof is elementary but important for scope. Hankel-kernel
locators are exhausted in increasing degree through `r-1`. If none splits with
nonzero recovered magnitudes, any fixed `r` finite NRC columns form a basis of
the syndrome space. Their unique coefficients must all be nonzero, since a
zero coefficient would contradict the completed lower-degree search. Thus the
fallback has exact distance `r`. No covering-radius theorem enters this
argument.

Locator candidates are streamed. Peak locator-search storage is the current
locator, its coefficient vector, and the Hankel-kernel basis, rather than all
candidates allowed by the budget. This is the concrete C962-derived
implementation improvement.

General `classify` intentionally remains R5--R10-only. One exact imported
exception is now enabled: for even `q` and `r=q-1`, the distinguished tangent
normal-form orbit has exact distance and covering radius `r`. In particular,
exact distance `r-1` at R11+ is still not promoted without an independent
covering-radius result. At GF(8)/R7, combining that radius with exhaustive
distance extraction closes the entire classification: exactly the
nine-direction diagonal tangent orbit and fixed central nucleus are deep.

## Closest binary-form algorithmic literature

- Kaipa--Patanker--Pradhan classify binary quartics into `PGL(2,q)` orbits in
  characteristic different from two and three while solving the line-orbit
  problem for the twisted cubic. Kaipa--Pradhan complete the characteristic
  three quartic case and list the nonsingular orbit representatives and
  stabilizers. These are direct fixed-degree predecessors, not predecessors
  for an arbitrary-degree canonical transporter.
  ([arXiv:2312.07118](https://arxiv.org/abs/2312.07118),
  [arXiv:2508.11229](https://arxiv.org/abs/2508.11229))
- Lercier--Ritzenthaler--Sijsling compute isomorphisms of hyperelliptic curves
  by covariants. This is highly relevant binary-form equivalence machinery,
  but its stated setting is characteristic different from two and smooth
  hyperelliptic forms; it does not provide the lexicographically least
  semilinear representative for every degenerate form.
  ([arXiv:1203.5440](https://arxiv.org/abs/1203.5440))
- Howe enumerates `PGL(2,q)` representatives of degree-`n` places of the
  projective line, hence irreducible homogeneous polynomials, in
  quasilinear-in-output time and logarithmic space. This is a stronger result
  for the irreducible enumeration problem, but it does not cover arbitrary
  reducible/multiple-root binary forms or map one supplied form to the
  coefficientwise lexicographic minimum of its semilinear orbit.
  ([arXiv:2407.05534](https://arxiv.org/abs/2407.05534))

The qualified C969 novelty claim is therefore the conjunction:

> an implemented, exact, coefficientwise-lex canonical form and transporter
> for every nonzero binary form of every degree `n>=4` over every represented
> finite field, including rootless, simple-root, multiple-root, pure-power,
> characteristic-two successor-degenerate, and Lucas-degenerate strata, under
> the semilinear `PGL(2,q)` action, using `O(m n q^2)` retained transports.

The audit does **not** support “first binary-form canonicalization,” “first
finite-field `PGL_2` orbit algorithm,” or a superiority claim over specialized
irreducible/smooth-form algorithms.

## Closest PRS literature

Zhang--Wan establish PRS covering-radius and deep-hole results in stated
ranges, and Zhang--Wan--Kaipa report complete deep-hole classification through
redundancy four. There is an important diagonal exception to the otherwise
missing R11+ radius input: Wu--Ding--Chen Theorem 17 proves radius `q-1` for
even-field `PRS(2)`, and Xu gives the associated explicit deep family. C969 now
imports that theorem through its intrinsic `e_(r-2)` syndrome orbit and exact
locator certificate. These sources do not promote general distance `r-1`
strata at R11+.
([arXiv:1605.02423](https://arxiv.org/abs/1605.02423),
[arXiv:1901.05445](https://arxiv.org/abs/1901.05445),
[arXiv:2312.05534](https://arxiv.org/abs/2312.05534),
[Xu 2023](https://doi.org/10.1051/wujns/2023281015))

Consequently the paper upgrade has two levels:

- **main fixed-level headline unchanged:** exact classifications remain those
  proved through R10 in the manuscript's field ranges, while the imported
  even diagonal family supplies an arbitrary-redundancy deep orbit;
- **artifact and algorithm scope substantially enlarged:** exact semilinear
  orbit canonicalization and exact nearest-error decoding now work at R11 and
  every higher admissible redundancy, with R11--R17 structural regression
  evidence already frozen.

This is a meaningful algorithmic/supplementary upgrade, not an R11 deep-hole
classification theorem. A true headline theorem upgrade now has a precise
remaining gate: prove a covering-radius row (and an exhaustive family theorem)
at R11+, rather than extending the software validator again.

## C949 and C962 transfer ledger

| Source | Relevant result | Adopted here | What it does not supply |
|---|---|---|---|
| C949 | moment identities, Frobenius-orbit compression, Prony-style recurrence ideas, and shell-defect accounting for higher arcs in `PG(2,q)` | conceptual leads only; none is needed by the current C969 theorem or code | no PRS covering radius, no R11 split-free/deep-hole classification, and no binary-form canonical transporter |
| C962 | exact syndrome-state search, projective deduplication, trellis/DP representations, and witness-preserving reconstruction | the search-layer principle is adopted concretely by streaming locator candidates; its packed/trellis backend is the natural next optimization if terminal searches dominate | no new PRS geometry, no covering-radius promotion, and no proof that a C969 family is exhaustive |

Thus C962 is directly relevant to the implementation dimension of this task;
C949 is only indirectly relevant to possible future geometric attacks. Neither
changes the current deep-hole theorem boundary.

## Paper-facing wording

The safe addition to a software/supplement paragraph is:

> Independently of the fixed-redundancy covering-radius theorems, the companion
> implementation computes exact semilinear canonical forms and replayable exact
> nearest-error certificates for every `r>=5` with `q>=r`. This does not promote
> an R11+ syndrome to a deep hole: that step remains conditional on an
> independently proved covering radius and family exhaustion.

Do not move R11 into the title, abstract, or main classification table until
that final sentence's two gates are closed.
