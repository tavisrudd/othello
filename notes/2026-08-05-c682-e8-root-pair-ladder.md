# C682 — the optimal E8 root-pair code folds to E7 and shortens to E6

**Date:** 2026-08-05  
**Task:** C682  
**Lane:** `clebsch`  
**Status:** exact research bundle; no manuscript or Lean file changed

## Result

The next exceptional level is exact and preserves the optimal code ladder.
Let (V=mathbf F_2^8) carry the plus-type quadratic form

\[
 Q(x,y)=x\cdot y,qquad x,y\in\mathbf F_2^4.
\]

Its 120 nonsingular vectors are the mod-2 model of the 120 antipodal pairs of
(E_8) roots, and classically match the 120 tritangent/theta objects in the
(27|28|120) exceptional trinity.  Restricting affine linear functions on
(V) to this 120-point quadric gives

\[
 \boxed{C_{E_8}=[120,9,56]_2},
 \qquad
 W_{C_{E_8}}(z)=1+255z^{56}+255z^{64}+z^{120}.
\]

The current public table gives exact optimum (d=56) at ([120,9]), so this
is an unrestricted parameter-optimal code.  Unlike the (E_7) point, it is
not dimension-maximal at that distance: an exact ([120,10,56]) code is also
known.  No equivalence or novelty claim is made.

The series connection is a root link followed by an antipodal fold.  Fix a
nonsingular vector (alpha), representing one (E_8) root pair.  There are
exactly 56 nonsingular (u) with

\[
 B(\alpha,u)=1.
\]

The fixed-point-free involution

\[
 u\longmapsto u+\alpha
\]

pairs these into 28 unordered decompositions of (alpha).  Restrict
(C_{E_8}) to this 56-point link, retain the codewords constant on every
pair, and fold each pair to one coordinate.  The result is

\[
 \boxed{[28,7,12]_2}
\]

with enumerator (1+63z^{12}+63z^{16}+z^{28}): exactly the (E_7)
bitangent/Steiner code.  The checker verifies this for all 120 choices of
(alpha).

Combining this with the previous shortening theorem gives the complete
optimal finite ladder

\[
 \boxed{
 [120,9,56]_{E_8}
 \xrightarrow{\text{root link + pair fold}}
 [28,7,12]_{E_7}
 \xrightarrow{\text{shorten one bitangent}}
 [27,6,12]_{E_6}.}
\]

This replaces the earlier speculative jump from (E_6) directly to an
81-coordinate unsigned bracket-support code.  That code remains valid, but
the (120\to28\to27) chain is the natural exceptional-series ladder.

## Why the fold is structural

Choose one member (u_0) of the 56-point link.  Every decomposition pair has
the form

\[
 \{u_0+s,\ u_0+s+\alpha\},
 \qquad s\in\alpha^\perp.
\]

Passing to

\[
 W=\alpha^\perp/\langle\alpha\rangle
\]

gives a six-dimensional symplectic space.  The condition that both members
are nonsingular becomes

\[
 \bar Q(s)=Q(s)+B(u_0,s)=0.
\]

This is an odd quadratic form on (W), with exactly 28 zeros.  Affine
functions on (V) that are constant on the pairs descend precisely to affine
functions on this 28-point odd quadric.  That is the intrinsic construction
of the (E_7) bitangent code from the previous bundle.  One affine direction
vanishes identically on the link, explaining the dimension transition

\[
 9\longrightarrow8\longrightarrow7
\]

through restriction and quotient.

Thus the 28 bitangents are not inserted into (E_8) by a label lookup: they
are the 28 decompositions of a root, and their quadratic-refinement geometry
is the quotient geometry of its link.

## Shell and quantum properties

The 255 weight-56 minimum words span (C_{E_8}) and form a

\[
 2\text{-}(120,56,55)
\]

design: every coordinate occurs in 119 minimum words and every coordinate
pair in 55.  The code is doubly even and self-orthogonal.  Its dual is
([120,111,4]_2), with 32,130 weight-four affine tetrads, so the direct CSS
construction is

\[
 [[120,102,4]].
\]

As at (E_7), unsigned incidence preserves exceptional symmetry but leaves
weight-four logical operators.  Distance improvement requires signed Pauli or
(mathbf F_4) data, not another binary support lift.

The audit of the public ([[28,14,5]]) code sharpens this point.  Its 504
minimum logical supports have point incidences

\[
 82^7,\quad86^7,\quad94^7,\quad98^7,
\]

so that public code is not coordinate-transitive.  It gains the missing
distance unit by sacrificing the full transitive (E_7) organization present
in our CSS code.  This incidence distribution is invariant under monomial
equivalence, so the displayed record is not a disguised fully transitive
(E_7) phase lift.  It retains an order-seven four-block symmetry.

This does not rule out some other distance-five code with an (E_7)-monomial
action.  A bounded phase-decoration search found 30 Hermitian lifts of the
binary generator; the best left 19 dependent tetrads, and none reached
distance five.  That is exploratory evidence only, not an impossibility
theorem.  The full exact SAT gate was stopped when the stronger (E_8) root
link became available.

## SOTA context

- ([120,9]), exact (d=56):
  <https://www.codetables.de/BKLC/BKLC.php?q=2&n=120&k=9>.
- ([120,10]), exact (d=56):
  <https://www.codetables.de/BKLC/BKLC.php?q=2&n=120&k=10>.
- Public ([[28,14,5]]) generator:
  <https://www.markus-grassl.de/QECC/circuits/28_14_5.html>.

The two linear-code table pages and the complete public quantum generator page
were read in full on 2026-08-05.  These establish parameter comparisons and
the frozen displayed matrix only.  No literature audit was performed for the
orthogonal-quadric code, the root-link description, or their historical
equivalence to catalogued constructions; no novelty claim is made.

## Next levels

There are now two distinct next moves.

1. **Faster finite quantum gate.**  Use the actual 56 signed weights in the
   root link, rather than folding them unsigned, and search for a
   Freudenthal/(E_8) cocycle whose Pauli fold kills the tetrad logicals.  The
   target remains ([[28,14,5]]), but the phase variables should live on the
   root decompositions, not independently on generator entries.
2. **Stronger infinite gate.**  Treat (C_{E_8}) as the local block for the
   affine (E_9) root direction.  Boundary-transfer graph codes can then use
   the (E_8) block at each level; the overextended (E_{10}) node supplies
   the second boundary direction.  The correct order is therefore finite
   (E_8\to E_7\to E_6) first, then (E_9/E_{10}) transfer—not a direct
   (E_6\to E_{10}) jump.

## Evidence and replay

From `/home/tavis/src/othello`, run

```sh
python3 notes/2026-08-05-c682-e8-root-pair-ladder.py --check
sha256sum -c notes/2026-08-05-c682-e8-root-pair-ladder.sha256
python3 notes/2026-08-05-c682-q28-record-audit.py --check
sha256sum -c notes/2026-08-05-c682-q28-record-audit.sha256
python3 notes/2026-08-05-c682-e7-phase-search.py \
  --trials 0 --cutting-plane 6 \
  --output notes/2026-08-05-c682-e7-phase-search.json \
  --expect-no-solution
sha256sum -c notes/2026-08-05-c682-e7-phase-search.sha256
```

The (E_8) checker constructs all 120 nonsingular vectors, enumerates the
complete (2^9)-word code, verifies every minimum-shell design incidence and
all 32,130 dual tetrads, and performs all 120 root-link folds.  For a fixed
root it independently constructs (alpha^\perp/\langle\alpha\rangle), derives
the odd quotient quadratic form and its 28 zeros, builds its affine code, and
compares it word-for-word with the folded code.

The quantum-record checker freezes the seven published GF(4) rows, verifies
Hermitian self-orthogonality, enumerates all (4^7) stabilizer words, proves
dual distance five by exhausting every support of size at most five, and
computes the full minimum-support incidence distributions.  Both checkers use
only the Python standard library and no randomness.

## EJ + TT closeout and mystery ledger

- **Settled — the next exceptional carrier.**  The 120 (E_8) root pairs,
  not the 81 unsigned bracket coordinates, extend the bitangent ladder.
- **Settled — why 120 produces 28.**  The 28 objects are the unordered
  decompositions of a fixed root; the six-dimensional odd quadratic quotient
  proves the identification intrinsically.
- **Settled — optimality preservation.**  The (E_8), (E_7), and (E_6)
  codes all attain the exact unrestricted minimum-distance optimum at their
  displayed dimensions.
- **Settled — public quantum-record symmetry.**  Its nonuniform point degrees
  rigorously rule out coordinate transitivity and monomial equivalence to a
  fully transitive phase lift.
- **Open — the tenth classical dimension.**  A ([120,10,56]) code exists,
  but no (O_8^+(2))-intrinsic extra generator has been identified.  It may
  necessarily break the full root-pair symmetry.
- **Open — signed root-link phase.**  Entrywise phase decoration did not
  quickly reach five.  A cocycle derived from the 56 signed roots is the
  representation-faithful successor.
- **Open — novelty.**  The exact ladder needs a classical-code and
  minuscule-representation literature audit before manuscript promotion.

## Vibe check

This is a 96/100 series result.  It supplies the missing (E_8) member,
preserves unrestricted optimality through two exact geometric operations, and
explains why the next quantum improvement must remember root signs.  Its main
risk is novelty rather than correctness: pieces are classical, but the exact
code-and-shell ladder may already be known under different language.
