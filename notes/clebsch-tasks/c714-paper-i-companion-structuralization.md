# C714 — Paper I companion structuralization and formal trust alignment

**Lane:** `clebsch`

**Opened:** 2026-07-31

**Status:** active umbrella; C721--C724 complete, with the surviving finite
boundary frozen for C725. C713 is complete, so the Paper I statement surface
is fixed.

## Objective

Replace finite leaves in the Paper I computational companion by structural
arguments exactly where the existing incidence, association-algebra, or cyclic
symmetry already contains the proof, while retaining honest certificates for
the irreducibly finite classifications.

## Work package

1. Prove structurally that each of the four (q=13) minimum-word orbits spans
   the full code: identify the orbit Gram operators as
   (A_9,A_9,A_{12},A_{10}) and derive rank (36) from the mod-two elliptic
   association algebra.
2. Seek a geometric derivation of the minimum-layer automorphism group after
   reconstruction of the full passant/internal incidence structure. Use a
   pinpoint theorem for the elliptic scheme or prove conic-incidence rigidity;
   retain the order-(2184) stabilizer-chain computation as a check.
3. Test two bounded certificate-to-structure conversions:
   - exclude a six-clique in the (q=9) Sylvester distance-two graph by an
     equality-case obstruction beyond the easy spectral bound of six;
   - diagonalize the (q=13) three-orbit block-circulant tangent graph over
     (mathbf Z/14) and test whether a Fourier/inertia bound proves clique
     number five.
   A negative result must state the exact failed bound and stop condition.
4. Reassess both (q=13) weight-ten profiles for a tangent-product,
   association-algebra, or low-degree polynomial obstruction. Do not replace
   the meet-in-the-middle certificate unless the argument proves both profiles.
5. Preserve the fifteen-class census, low-degree rigidity, and (q=17,19)
   terminal classifications as computations unless a stronger mechanism is
   proved. Record the exact failure of the first-order rational LP so it is not
   proposed again as a structural proof.
6. Formalize every adopted structural lemma at the granularity claimed by the
   prose, or state precisely why a finite certificate remains the proof surface.
   Refresh the companion trust ledger, q11 aggregate gate, axiom audit,
   statement identity, authoritative PDF, and standalone mirror.

## Execution graph

```text
C721 q13 association-scheme spine
  |\
  | +--> C724 q11/finite-census certificate compression --+
  v                                                       |
C722 q9/q13 clique equality cases                         |
  |                                                       |
  v                                                       v
C723 q13 weight-ten profiles --------------------------> C725 terminal orbit DAG
                                                           |
                                                           v
                                              C726 integration and trust closure
```

- C721 is the common vocabulary and must land first.
- C722 is complete with neither bounded clique argument promoted: q9
  Delsarte equality remains scheme-feasible, and q13 Fourier/inertia stops at
  an exact six-color bound.  Its exact q13 character blocks pass to C723.
- C723 is complete with no common structural weight-ten exclusion promoted.
  The two exhaustive profiles are compressed to canonical XOR-disjointness
  certificates with an independent dynamic-programming replay and pass to
  C725 as the frozen q13 finite boundary.
- C723 consumes any useful C721/C722 identities but is successful even if it
  proves that the two-profile meet-in-the-middle certificate is irreducible.
- C724 is complete: the q11 census and q11/q13 seven-arc leaves are compressed
  to orbit masses, concurrence data, and local determinant witnesses, with the
  full normalized enumerations retained as audits.
- C725 begins only after C723 and C724 have frozen the surviving finite
  boundary.
- C726 is the only closeout card: it integrates adopted arguments, formalizes
  the claimed granularity, refreshes trust surfaces, and closes C714.

## Acceptance

Every promoted argument exposes a mathematical invariant rather than merely
moving a search into another program. The companion distinguishes structural
proof, published input, Lean theorem, certificate check, and trusted execution
claim by claim. All unchanged finite leaves retain complete domains and replay
commands. The authoritative and standalone release gates pass against the same
pinned formal surface.

## Boundaries

Do not reopen Papers II or III, infer a uniform exterior-set theorem from the
failed first-order LP, or turn a bounded experiment into a paper claim.
External publication remains under C182.
