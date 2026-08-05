# C868 — the F4 alphabet is free, and it is not enough

**Date:** 2026-08-05
**Task:** C868
**Lane:** `clebsch`
**Status:** exact research bundle; no manuscript or Lean file changed

## Result

C867 showed the Eisenstein structure hands over an \(\mathbf F_4\) alphabet on
the E8 root-pair coordinates for free.  The obvious hope was that this alphabet
is what the ladder's quantum codes were missing, since every unsigned lift
stalls at distance four against exact records of five.  It is not.  The
alphabet is genuinely canonical and the natural codes on it are genuinely
Hermitian self-orthogonal, but their dual distance is still four, and the
reason is structural rather than a search failure.

## The natural F4 code has the record parameters and the wrong distance

Coordinates are the 120 nonsingular vectors of \(E_8/2E_8=\mathbf F_4^4\).
The natural equivariant function space is

\[
 \langle 1\rangle \;\oplus\; \{v\mapsto \langle a,v\rangle\} \;\oplus\;
 \{v\mapsto h(a,v)\},
\]

the constants, the four \(\mathbf F_4\)-linear functionals, and the four
Hermitian ones.  That is exactly nine dimensions over \(\mathbf F_4\) — the
dimension the record \([[120,102,5]]\) needs.  The code is Hermitian
self-orthogonal.  Its Hermitian dual distance is **four**.

## Why, in one line

Conjugation is additive and every \(\mathbf F_4\)-linear functional is
additive.  So the column map \(v\mapsto(1,v,\bar v)\) is additive-plus-constant,
and each of the 32,130 tetrads \(u+v+w+x=0\) among the 120 points maps to

\[
 c_u+c_v+c_w+c_x=(1+1+1+1,\;0,\;0)=0,
\]

a weight-four dual word.  **Any code whose column map is additive plus a
constant has Hermitian dual distance exactly four, whatever the alphabet.**
Changing \(\mathbf F_2\) to \(\mathbf F_4\) cannot help, because the tetrads
are a property of the coordinate set, not of the field.

That also explains the whole ladder's uniform stall at distance four in one
statement, replacing four separate observed coincidences.

## The natural non-additive repairs make it worse

Distance five needs a non-additive column map.  The obvious equivariant
candidates are the products \(v_iv_j\) and the mixed products \(v_i\bar v_j\).
All are Hermitian self-orthogonal; none help.

| Function space                             | dim over F4 | dual distance | quantum parameters |
|--------------------------------------------|-------------|---------------|--------------------|
| constants + linear + Hermitian (additive)   | 9           | 4             | \([[120,102,4]]\)  |
| constants + linear + products               | 11          | 3             | \([[120,98,3]]\)   |
| constants + linear + Hermitian + products   | 15          | 4             | \([[120,90,4]]\)   |
| constants + linear + mixed products         | 17          | 3             | \([[120,86,3]]\)   |
| constants + linear + Hermitian + mixed       | 21          | 4             | \([[120,78,4]]\)   |

Adding non-additive rows either leaves the tetrads intact or introduces
weight-three dependencies, and always costs encoded dimension.  Every entry is
strictly worse than the additive one.

## There is not much else to try, and here is why

The action on the 120 coordinates is rank three, with suborbits of sizes
1, 56, and 63 — the 56 being exactly the root link that drives the ladder.  So
the coordinates carry a strongly regular graph of valency 56, and its adjacency
matrix \(A\) over \(\mathbf F_2\) has

\[
 \operatorname{rank}A=8,\qquad
 \operatorname{rank}(A+J)=9,\qquad
 \operatorname{rank}(A+I)=120,\qquad
 \operatorname{rank}J=1.
\]

The rank-8 image is the space of linear functionals and the rank-9 image is our
code.  A rank-three permutation module has a very short submodule lattice, and
these ranks say the only small invariant pieces available are the constants,
the eight linear functionals, and their sum.  Together with the C867 result
that the invariant-extension space is trivial, that leaves no other equivariant
code of the right size on this carrier to try.

## What this closes and what it does not

It closes the route C682 proposed.  That report ended with "the phase variables
should live on the root decompositions, not independently on generator entries,"
and it was right that entrywise decoration was the wrong place to look — but
moving to the canonical root-derived alphabet does not fix it either, because
the obstruction is additivity of the coordinate map rather than the source of
the phases.

It does not rule out a distance-five quantum code on 120 coordinates with
partial E8 symmetry.  What it rules out is getting one from an additive
coordinate map, which is what every construction in this series has used.  A
successor would have to place 120 points of \(\mathrm{PG}(8,4)\) in
four-general position compatibly with a large subgroup, and nothing here says
that is impossible — only that no equivariant additive construction reaches it.

## Evidence and replay

From `/home/tavis/src/othello`, run

```sh
python3 notes/2026-08-05-c868-eisenstein-hermitian-hunt.py --check
sha256sum -c notes/2026-08-05-c868-eisenstein-hermitian-hunt.sha256
```

The checker builds \(\mathbf F_4\) from its addition and multiplication tables,
constructs the 120 coordinates, verifies Hermitian self-orthogonality of each
function space by summing \(\sum_v f(v)\overline{g(v)}\) over every pair of
generators, and searches for dependent column sets of size two, three, and four
exactly by a meet-in-the-middle table over all scaled pairs.  It counts the
additive tetrads directly and exhibits one.  It rebuilds the binary model
independently to compute the suborbit sizes and the four matrix ranks.  The
dependent-column search is exact up to size four only; a reported value of five
means no dependency of size four or less exists, not that one of size five was
found.

## EJ + TT closeout and mystery ledger

- **Settled — the F4 alphabet is canonical and insufficient.**  Hermitian
  self-orthogonal at exactly the record dimension, dual distance still four.
- **Settled — the mechanism.**  Additive column maps inherit the 32,130
  tetrads.  One statement now explains the distance-four stall at every level
  of the ladder.
- **Settled — the natural repairs fail.**  All five function spaces tested are
  self-orthogonal, none exceeds distance four, two drop to three.
- **Settled — no other equivariant code of the right size exists here.**  The
  rank-three module structure and the C867 triviality leave nothing untried.
- **Open — a non-additive equivariant embedding.**  120 points of
  \(\mathrm{PG}(8,4)\) in four-general position invariant under a large proper
  subgroup of \(O_8^+(2)\).  Untested, and the only route left on this carrier.
- **Open — the four-unit gap at \([256,10]\)**, carried over from C867 and
  untouched here.

## Vibe check

A clean negative that is worth more than the positive would have been.  The
prize was not won, but a coincidence that had been showing up at every level of
the ladder for two sessions now has a one-line cause, and the cause rules out
the entire family of constructions this series has been using rather than just
the attempt in front of us.  The remaining route is narrow, specific, and
unlikely, which is useful to know before anyone spends a session on it.
