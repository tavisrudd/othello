# C694 — Paper II v2 theorem-arc integration

**Lane:** `clebsch`

**Date:** 2026-07-30

## Verdict

Paper II v2 now presents C665, C688, C689, and C692 as one theorem arc.
The paper title is now *Quadratic trade rigidity and cubic orientation in
conic matching quotients*.  The frozen v1 baseline is unchanged.

The principal classification no longer assumes that the two quadratic-trade
fibres are one-factorizations.  A two-valued one-dimensional strength-two
trade first gives two special-projective sheets.  The projective--trade bridge,
the uniform Frobenius-digit first-wall obstruction, the characteristic-three
axis trade, and the exhaustive q=9 endpoint close every sheet multiplicity
\(\lambda>1\).  Thus the theorem derives the \(q+q\) one-factorization split
and then leaves exactly \(B_3/\mathbb F_7\) and
\(H_3/\mathbb F_{11}\).

The two former radial endings are now one proof.  An endpoint edge selects a
unique cross-sheet matching pair; deleting the edge gives one alternating
cycle, and the common \(c\leftrightarrow c^{-1}\) torus normal form reduces
both cycle lengths to one Dickson recurrence.  The old radial scalars \(4\)
and \(10\) are stated only as coordinate cross-checks.

The Gorenstein proof now uses the signed coordinate form directly.
The quadratic identity makes the affine evaluation space maximal isotropic,
so quotient duality gives the perfect degree-\(1\)-by-degree-\(2\) Artinian
pairing.  The Paley cross-sheet matrix is retained only as an explanatory
carrier; it is not presented as the Gorenstein pairing.

## Trust surface

The standalone paper bundle now contains thirteen evidence bundles and
twenty-six statement identities.  The new paper-owned bundles are:

- `generic_first_wall.py` and its independent closed-form replay, constructing
  only \(S,T,R,Y\);
- the historical q=121 and q=169 invariants, admitted as corroboration rather
  than the canonical path;
- `shared_radial.py` and its independent one-variable Dickson replay;
- the exhaustive q=9 small-field trade check and its independent
  generator-based replay.

The vendored evidence uses scholarly filenames and contains no task or lane
identifiers.  The aggregate runner was also repaired in two places exposed by
the fresh replay: external formal commands now run from the monorepo root,
and guarded Lean axiom audits read the exact disk-backed stdout logs rather
than a truncated console tail.

## Acceptance

From `papers/clebsch-factorization`:

```text
python3 verification/verify_release.py
```

The aggregate gate passed:

- all thirteen evidence bundles and their independent replays;
- all twenty-six statement identities and exact trust coverage;
- arithmetic-gluing, Hilbert-arithmetic, and hyperplane-square Lean gates
  with the existing axiom allowlist;
- a forced PDF rebuild; and
- the manuscript warning scan.

The terminal line was:

```text
clebsch factorization release: CHECK OK
```

The authoritative integration is commit `cac1fddf`.  The identical public
paper subtree was applied to the existing standalone history as forward
commit `c4230f3`, where the standalone aggregate gate also ended with the
same `CHECK OK` line.

The fresh cold read checked the title, abstract, main theorem, proof-mode
paragraphs, conclusion, verification table, and trust boundary against v1.
It found and removed the old open question about deriving
one-factorizations, the claim that the radial witnesses remained
type-specific, the external Gorenstein-criterion dependency, stale statement
counts, and workflow-named evidence files.  No Paper III theorem or artifact
enters the proof; its orientation lift remains a one-sentence cliffhanger.

## Extra-juice and Tao closeout

The cheap upgrade was to make the theorem arc self-contained rather than
merely paste four results into the prose.  The local first-wall certificate
now exposes the exact evidence seam: the checker verifies the normalized
row and its consequences, while the Lucas-socle and adjacent-wall
identifications remain human theorems.  The q=9 row is now explicitly
exhaustive and separate from the bounded q=13,17,19 cross-checks.

The decisive structural simplification is that two pairings of similar
ambient size have different mathematical roles.  The Paley matrix transports
the two top sheet quotients, of dimension \(q-2\); the Artinian pairing keeps
the radial/common-sum pair and has dimension \(q-1\).  Writing the exact
quotients prevents the former from being mistaken for the latter.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| extension-field case growth | settled by one occurrence parity bit and the local \(S,T,R,Y\) spill | none |
| separate q=7 and q=11 radial scalars | settled as two specializations of the edge-selected Dickson recurrence | none |
| cross-sheet incidence as Gorenstein pairing | settled negatively by the missing radial/common-sum dimension | none |
| Gorenstein perfectness | settled directly by maximal isotropy and quotient duality | none |
| Paley middle-layer differential versus cubic orientation | not identified and not used | an exact graded filtration map with the quadratic twist would be required; this lies outside C694 and no successor is allocated |
| Paper III arithmetic lift | deliberately excluded from the proof | companion-paper cliffhanger only |

No genuine mystery remains in the Paper II v2 theorem arc itself.

Vibe check: the v2 paper now has one causal proof rather than four adjacent
upgrades.  The strongest gain is the removal of both artificial hypotheses:
one-factorization is derived, and Gorenstein duality no longer depends on an
external criterion.
