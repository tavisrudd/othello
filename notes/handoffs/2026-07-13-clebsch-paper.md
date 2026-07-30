# Clebsch three-paper program

**Lane:** `clebsch`

**Date:** 2026-07-29

> **LIVE MAP ONLY.** This is the routing and state surface for the active
> three-paper program. Detailed live task internals belong in C-task cards;
> completed and superseded detail belongs in the archives linked below.
>
> **ROUTING AUTHORITY.** No dated planning note, fallback-paper verdict, task
> report, or archive overrides the order and boundaries stated here.

## Program state

| surface | root | current state | owning task |
|---|---|---|---|
| Paper I — *Reconstructing the Clebsch code from its deep-hole syndrome locus* | `papers/clebsch-rigidity/` | final independent `GO`; local release surface green | [C182](../clebsch-tasks/c182-paper-i-release.md) |
| Paper II — *Quadratic recovery and cubic orientation in conic matching quotients* | `papers/clebsch-factorization/` | v1 theorem, editorial, cold-read, and replay gates green; public packaging remains; C665 uniform C1 is closed for v2 | [C577](../clebsch-tasks/c577-factorization-paper.md) |
| Paper III — *The Clebsch orientation cubic: arithmetic covers and icosahedral harmonics* | `papers/clebsch-covers/` | pre-release `GO`; immutable locator and author metadata remain | [C680](../clebsch-tasks/c680-paper-iii-release.md) |
| 37-page mega-paper | `papers/clebsch-code/` | preserved unchanged as fallback only | C552 if explicitly reactivated |

## Active and queued task cards

| task | state | next gate |
|---|---|---|
| [C182 — Paper I release](../clebsch-tasks/c182-paper-i-release.md) | queued on external publication authority | publish and independently replay one immutable approved package |
| [C577 — Paper II](../clebsch-tasks/c577-factorization-paper.md) | active under the C182 external-wait exception | obtain immutable locator, isolate replay, run release pass |
| [C611 — exterior-set mechanism](../clebsch-tasks/c611-exterior-set-v2.md) | queued after C182; v2 only | conceptual terminal-field theorem or sharp negative disposition |
| [C680 — Paper III release](../clebsch-tasks/c680-paper-iii-release.md) | pre-release `GO` | add immutable locator and author metadata, rebuild, replay |
| [C682 — Hitchin--Clebsch exploration](../clebsch-tasks/c682-hitchin-structural-exploration.md) | active open exploration; integral frontier closed | user selects the next frontier |

C321 remains conditional and is not triggered: the final Paper I review found
no missing proof obligation. C552 remains fallback-only and must not displace
the split-paper route without an explicit user decision.

## Paper I

Paper I and its companion *Computational strengthenings of Clebsch syndrome
rigidity* form one warning-free, nineteen-row release surface with sixteen
checks. C320 is complete with final `GO`. C182 owns every remaining release
action; C611 cannot reopen or delay v1.

The load-bearing theorem package reconstructs the Clebsch code from the
weight-six deep-hole syndrome locus and closes the terminal fields
q=13,17,19 by exact passant-edge-orbit searches. The shared
`deep_holes = conic` fact remains pinned to the standalone Lean repository;
the paper does not inherit trust from the fallback mega-paper gate.

Local aggregate replay:

```sh
cd papers/clebsch-rigidity
./scripts/verify-all.sh
```

## Paper II

Paper II is standalone: no proof dependency on Papers I or III. Its frozen
v1 spine is the matching-secant quotient, the A3/B3/H3 configurations,
quadratic balanced-sheet recovery, cubic-first orientation,
self-association/Schur/Gorenstein structure, and the paper-owned trust
surface. C577 owns packaging and release.

C665 is complete as a strictly v2 theorem.  The q=121
`L(6) in Sym^59 L(2)` rank-\(1\)-to-\(2\) witness is the first instance of
the uniform first-wall spill
\[
L(p-2-s,1)\otimes L(p-2,1)
\longrightarrow L(0,2)\otimes L(p-2-s,1).
\]
The affine-socle criterion
\(e(p-1)/2\equiv1+s/2\pmod2\), together with the spill scalar
\(p-2-s\ne0\), closes every extension-field exceptional C1 row.  It also
shows that the \(A_4\) occurrence and the \(S_4/A_5\) occurrences occupy
opposite values of one parity bit and never coexist.  The result is
recorded in
`notes/2026-07-29-c665-frobenius-digit-spill.md`; the retired
non-equivariant Hasse pairing remains non-evidence.  This does not change
or hold frozen v1. C682 characteristic-zero work is inventory unless
explicitly promoted.

Local aggregate replay:

```sh
cd papers/clebsch-factorization
./scripts/verify-all.sh
```

## Paper III

Paper III's corrected arithmetic statement has global square class `5J_0`;
the fixed Clebsch chart lives over `Q(sqrt(5))`, and the displayed golden
configurations are the complete reduced local fibre. The degree-six
Gaunt/Steinhardt comparison and paper-owned trust surface are integrated.
C680 owns the frozen release surface.

C682 is independent exploration. Its current crown includes the
third-transvectant inverse descriptions, the corrected mod-11 operator and
1+5+6+10 kernel section, the characteristic-zero maximal-subgroup mates and
Schlaefli double-six, and the golden D5--S3 complementary incidence fibres.
The frozen common marking identifies the stored mod-11 matrix with the
lambda-plus fibre.
The cross-Gram separator extends over both Mukai--Umemura boundary orbits
on the normalized saturated graph, but provably not as a scalar on the
coarse kernel-pair boundary.
The normalized-graph deck exchange is exactly the global extension of the
Schläfli apolar-polar row swap: inside each \(D_5\), the two five-cycle
classes give complementary pentagon-side and pentagram-diagonal relations
on the ten \(S_3\) labels.
The combined normalized operator/polar/incidence package has minimal base
\(\mathbf Z[1/30]\) and structural bad primes exactly \(2,3,5\).
An \(11\)-elementary dodecic lattice removes the apparent operator failures
at \(7,11\); the cross-Gram scalar image, but not the normalized golden
cover, has collision primes \(11,23\).
At \(23\) that scalar image is the conductor-\(23\) suborder of the inert
golden algebra: its special fibre is a dual-number point, and the divided
separator is the Frobenius-odd normalization generator over
\(\mathbf F_{529}\), not a new rational incidence sheet.  Globally the
scalar image is the conductor-\(253\) order over \(\mathbf Z[1/30]\), whose
only normalization defects are the split prime \(11\) and inert prime \(23\).
Independently, the Klein \(E_8\) cubic is now intrinsic: it is the radial
third-transvectant symbol, and on every McKay covariant block the full
principal symbol is \(10p\) times multiplication by the odd invariant
\(t\), uniformly selecting the classical \(E_8\) matrix factorizations.
Through degree \(72\), every later apparent short-return deficit is repaired
by the nearest downward return; degree \(22\) is the sole certified
full-corner failure in that bounded range.  The all-weight gate remains
open.  The fourteen strict peaks through degree \(112\) also saturate,
completing one base representative of every eventual \(60\)-periodic peak
family; only the \(1,2,3,3'\) free modules remain in the symbolic
nonvanishing gate.  The global two-sided defect is now classified in all
weights: it vanishes for every \(n>52\), and its thirteen exact exceptional
degrees are
\(0,1,2,6,10,11,12,20,21,22,32,40,52\).  Degree \(22\) is uniquely
compatible with a repeated isotypic summand.  Five exact local
four-by-four determinants prove unique continuation on the five
coefficient chains.  A noncircular lower-hyperplane propagation lemma
reduces the remaining full-corner proof to upper-support mixing at
codimension-two peaks plus off-peak propagation.
The attempted maximal-rank/multiplicity induction is now sharply audited.
Every McKay block is maximal-rank through degree \(300\) at two primary and
one replay prime, and full supported algebras on spanning nonorthogonal
subspaces generate the full matrix corner.  However the trivial module has
a recurring unanchored plateau \(1\to2^6\to3\), first in degrees
\(118,\ldots,160\); equal-rank edges only transport the unknown corner, so
bare induction is circular.  The first exact remaining family is
trivial-module plateau-entry mixing at \(n=64+60q\).
Its detailed, reorganizable lookup surface is the
[C682 working archive](2026-07-13-clebsch-c682-archive.md); none of it reopens
Paper III automatically.

Local aggregate replay:

```sh
cd papers/clebsch-covers
./scripts/verify-all.sh
```

## Release and verification policy

Each split paper owns its statement identity, claim manifest, aggregate gate,
replay entry point, toolchain pins, adequacy appendix, and AI/provenance
disclosure. Shared Lean sources stay in the pinned standalone Lean
repository. An immutable public locator and fresh isolated replay are release
requirements, not substitutes for the paper's local gates.

Paper I ships only as the C320-approved C182 surface. Paper II requires its
own release pass. Paper III's local pass is complete; C680's two metadata
items are the only remaining planned edits.

## Lane boundaries

This lane owns the three Clebsch paper roots, the preserved mega-paper
fallback, Clebsch checkers/reports, and exact Clebsch queue rows. It does not
own Baer, alternate-orbit, gem-mining, or crowns work. Cross-lane results are
read-only until an owning split-paper task explicitly admits them.

The companion discovery log is
`notes/2026-07-14-clebsch-discovery-track.md`. Logging an observation neither
allocates work nor adds it to a paper.

## Working and historical indexes

- Live task detail: `notes/clebsch-tasks/`.
- C682 thematic lookup and chronology:
  `notes/handoffs/2026-07-13-clebsch-c682-archive.md`.
- Full accumulated handoff history:
  `notes/handoffs/done/2026-07-13-clebsch-paper-archive.md`.
- Retired mega-paper planning redirect:
  `notes/2026-07-20-clebsch-paper-planning.md`; full superseded record:
  `notes/2026-07-20-clebsch-paper-planning-archive.md`.
- Mega-paper independent cold read:
  `notes/2026-07-23-c320-independent-cold-read.md` — fallback only.
