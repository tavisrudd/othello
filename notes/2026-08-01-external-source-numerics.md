# Independent replay of the external session's numerics (2026-08-01)

Both numerical batteries in the external source notes reproduce here from
independent implementations. This is a spot check that de-risks C774 and the diagonal-programme
tasks; it is not their evidence bundle, because neither task has run and neither manuscript claim
has been adopted.

Source notes: `2026-08-01-external-session-notes/`. Catalogue:
`2026-08-01-external-chat-artifact-gap-review.md`.

## Bundle

| Artifact | Contents |
|---|---|
| `2026-08-01-external-source-numerics-diagonal.py` / `.json` | diagonal-rigidity note section 6 |
| `2026-08-01-external-source-numerics-quantum.py` / `.json` | 2-uniform note section 6 |
| `2026-08-01-external-source-numerics-lattice.py` / `.json` | two probes from the replay data itself |
| `2026-08-01-external-source-numerics.sha256` | hashes and byte counts for all six |

Replay, from the repository root:

```
python3 notes/2026-08-01-external-source-numerics-diagonal.py --check
uv run --with numpy --with scipy python \
    notes/2026-08-01-external-source-numerics-quantum.py --check
uv run --with numpy python \
    notes/2026-08-01-external-source-numerics-lattice.py --check
```

Each `--check` regenerates in memory, compares against the tracked certificate, re-runs the
cross-checks, leaves the worktree unchanged, and exits nonzero on any mismatch. Dropping `--check`
writes the certificate to stdout. Dependency versions are not pinned in the certificates; the
quantum run used numpy and scipy as resolved by `uv` on 2026-08-01, and its floating-point outputs
are rounded to ten decimals so the certificate is platform-stable.

## Diagonal note, section 6 — reproduced exactly

Deterministic canonical enumeration, no randomness, exact integer arithmetic throughout.

| Code | weights | d | d-perp | uniformity | dim of third Schur power | annihilator | invariant factors |
|---|---|---|---|---|---|---|---|
| `RM(1,4)` | {0, 8, 16} | 8 | 4 | 3 | 15 of 16 | all-ones only | `1^5 2^6 4^4 8^1` |
| `Hamming[7,4]` | {0, 3, 4, 7} | 3 | 4 | 2 | 7 of 7, full | empty | `1^4 2^3` |
| `Simplex[7,3]` | {0, 4} | 4 | 3 | 2 | 7 of 7, full | empty | `1^3 2^3 4^1` |

Every figure the source states is matched: the third Schur power of `RM(1,4)` falls one short of
full, its annihilator is exactly the transversal-T direction, and the lone invariant factor 8 is the
non-Clifford symmetry. The Hamming control has all factors in {1, 2, 4}, so only Clifford diagonal
symmetries, as the Schur-cube theorem requires.

Three theory-level cross-checks run inside the script rather than a second copy of the same
algorithm: an invariant factor divisible by 8 appears exactly when every codeword weight is
divisible by 8; the all-ones vector annihilates the Schur cube exactly when the code is triply even;
and the number of invariant factors is consistent with the lattice rank. All pass for all three
codes.

**`Simplex[7,3]` is in the table as a trap marker.** The four cyclic shifts `1110100`, `0111010`,
`0011101`, `1001110` are rank 3, not 4 — the fourth is the sum of the first two — so they generate
the simplex code, not the Hamming code. Using them silently changes the invariant factors to
`1^3 2^3 4^1`. The conclusion survives, since everything is still at most 4, but the certified
numbers do not. Use a systematic generator matrix.

## 2-uniform note, section 6 — reproduced, with one caveat

Local generators are drawn from a seeded generator (seed 11), so the run is reproducible but the
generators differ from the source's. Absolute defect values therefore differ; the ratio column,
which is the actual claim, agrees.

The four-qutrit stabilizer state is exactly 2-uniform: every pair marginal is maximally mixed to
machine zero. The quantum Fisher identity holds to ten decimals. The defect is computed by two
independent routes — the overlap formula and a direct phase-optimized norm — which agree at every
scale.

| scale | ratio of generator size to root-q defect | hypothesis satisfied |
|---|---|---|
| 0.3 | 1.0861 | **no** |
| 0.1 | 1.0093 | **no** |
| 0.03 | 1.0008 | yes |
| 0.01 | 1.0001 | yes |
| 0.003 | 1.00001 | yes |

The ratio converges to 1 and stays under the ceiling of `sqrt(6/5) = 1.0954` throughout.

**The caveat, which C774 owns.** The stability theorem assumes the summed operator norms of the
generators are at most one half. At the two largest scales that quantity is 2.157 and 0.719, so
those rows lie outside the theorem they illustrate. The bound holds there anyway. The source note's
table has the same shape and does not mark it. Either restrict the displayed range to the region
where the hypothesis holds, or state plainly that the top rows are shown to exhibit the approach to
the ceiling and are outside the hypothesis. A referee will otherwise circle it.

The GHZ control behaves as claimed: the continuous product symmetry has exactly zero defect, and its
pair marginal sits 0.471 from maximally mixed in Frobenius norm.

## What this does not certify

It does not certify the stability theorem, which quantifies over all generators, nor the
discreteness theorem, nor any statement about codes or states outside the three codes and two states
enumerated. The threshold below which every approximate symmetry is near an exact one is
non-explicit in the source and is not computed here, so no certification or self-testing claim
follows from this bundle. The seeded generators exercise one direction in a continuum; they are
evidence that the identity is not an artifact of the source's particular draw, not a proof that it
holds for every draw.

## Two probes from the replay data itself (added 2026-08-01)

`2026-08-01-external-source-numerics-lattice.py` / `.json`. Neither probe is in the source notes.

### The 16-qubit Reed--Muller coset state witnesses both halves at once

Built directly as a state on 65536 amplitudes. All 120 pair marginals are maximally mixed to
2.8e-17, so the state is exactly 2-uniform and the discreteness theorem applies: its
product-symmetry group is finite. The transversal-T product operator fixes it with norm difference
2.5e-16 — matching the source note's figure — and T is non-Clifford because a quarter-turn phase is
not a multiple of a half-turn. So the finite group guaranteed by discreteness demonstrably contains
a non-Clifford element.

That is the entanglement-half/algebraic-half separation exhibited in a single object: 2-uniformity
buys finiteness and nothing more, and identifying the group as Clifford genuinely needs the maximal
entanglement hypothesis that this state fails. It is the evidence for the boundary remark the C776
scope review proposes adopting.

Methodological note: the defect formula `sqrt(2 - 2|<psi|U|psi>|)` square-roots machine epsilon and
reads about 1e-8 here even though the state is fixed exactly. The norm difference is the meaningful
figure. Any table quoting defects near machine precision should say which quantity it reports.

### A lattice law, and the counterexample that explains it

Our first three-code table suggested that the lift lattice's invariant factors split as dim(C) ones
and dim(C-perp) nontrivial factors. Tested across ten codes:

**The first half holds everywhere.** The number of unit invariant factors equals dim(C) in all ten
cases, including extended Hamming, both length-32 Reed--Muller codes, the extended Golay code, the
even-weight code, and the repetition code.

**The second half is false, and fails at exactly one code: the repetition code.** There the lattice
has rank 1, so there are no nontrivial factors at all, against a dual dimension of 7.

The failure is not an anomaly, it is the continuous case. The lattice rank is what controls the
torus part of the symmetry group, and the repetition code's coset state is the GHZ state, whose
symmetry group has a 7-torus — exactly `n` minus the lattice rank. The GHZ state is also the control
in the quantum battery above, where its exact continuous product symmetry was verified numerically
by a completely different route. The two batteries touch at precisely one point and agree there.

The corrected statement is therefore: the number of unit invariant factors is dim(C); the total
number of invariant factors is the lattice rank; and the symmetry group has `n` minus that rank
torus factors, so it is finite exactly when the lattice has full rank. The finite part then has
(rank minus dim C) cyclic factors. This is a structural refinement of the classification, splitting
it into a part fixed by the code's dimension and a part carrying the actual arithmetic content.

**Scope.** Ten codes, all binary, all small. The unit-factor law is a conjecture supported by ten
instances, not a theorem; it has an obvious candidate proof (the lifted basis contributes
dim(C) unimodular directions) which nobody has written. Recorded in the lane discovery track.

### The invariant factors are the Schur filtration

Probing further: for each code, compare the number of invariant factors divisible by `2^l`, plus the
free rank `n - rank(Lambda_C)`, against the codimension of the `l`-th Schur power, for `l = 1..4`.

**They agree in every entry of every row, for all ten codes.**

| Code | invariant factors | count divisible by `2^l`, plus free rank | codim of `l`-th Schur power |
|---|---|---|---|
| `RM(1,5)` | `1^6 2^10 4^10 8^5 16^1` | 26, 16, 6, 1 | 26, 16, 6, 1 |
| `RM(1,4)` | `1^5 2^6 4^4 8^1` | 11, 5, 1, 0 | 11, 5, 1, 0 |
| `RM(2,5)` | `1^16 2^15 4^1` | 16, 1, 0, 0 | 16, 1, 0, 0 |
| `ExtHamming[8,4]` | `1^4 2^3 4^1` | 4, 1, 0, 0 | 4, 1, 0, 0 |
| `Golay[24,12]` | `1^12 2^12` | 12, 0, 0, 0 | 12, 0, 0, 0 |
| `Repetition[8,1]` | `1^1` | 7, 7, 7, 7 | 7, 7, 7, 7 |

(Remaining four codes agree likewise; see the certificate.) The repetition code is the reason the
free rank has to be in the count: its lattice has rank 1, and its seven torus directions behave as
divisible by every power of two. With that term included the correspondence is exact everywhere,
including the continuous case.

**Conjecture.** For a binary linear code `C` of length `n` with lift lattice `Lambda_C`,

```
#{ i : 2^l divides d_i }  +  ( n - rank Lambda_C )  =  codim C^(o l)      for every l >= 1.
```

If this is a theorem, the two main results of the diagonal note are one result. The classification
by Smith normal form and the Schur-cube rigidity criterion stop being separate theorems joined by a
cascade argument: the `l = 3` case reads "no invariant factor divisible by 8 exactly when the third
Schur power is full", which is precisely the Clifford criterion of the classification theorem
against the hypothesis of the rigidity theorem. The cascade lemma supplies one inclusion and the
lift identity `2(x AND y) = x + y - lift(x XOR y)` is the natural source of the other.

**Scope and caution.** Ten codes, all binary, lengths 7 to 32, levels 1 to 4. This is a conjecture
with strong numerical support, not a theorem, and characteristic two is special here — the lift
identity carries the factors of two that drive the whole correspondence, so nothing about odd
characteristic should be inferred. Owned by C790.
