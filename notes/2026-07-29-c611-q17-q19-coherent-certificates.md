# C611 — \(q=17,19\) coherent and rational certificates

**Lane**: `clebsch`

**Status**: complete; finite coherent compression earned, uniform theorem not
earned.

## Result

The \(q=17,19\) terminal maximum-six searches admit a substantially smaller
projective-orbit certificate, but not a low-order rational-dual proof.

Every passant six-arc falls into exactly

| \(q\) | rooted six-arcs met from the edge roots | projective six-arc orbits | labelled six-arcs |
|---:|---:|---:|---:|
| 17 | 441 | 22 | 50,184 |
| 19 | 2,704 | 94 | 395,124 |

Every listed orbit has zero valid seventh point.  Conversely, the listed
orbits cover every six-arc obtained from the complete 13 and 15 passant-edge
orbit transversals.  Since every six-arc contains an edge, this classifies all
six-arcs and independently recovers the maximum-six conclusion once the
existence witnesses from C605 are retained.

The coherent signatures are unexpectedly sharp.  At \(q=17\), the inner
distribution of the fifteen pairs among the thirteen passant pair orbitals
distinguishes all 22 six-arc orbits.  At \(q=19\), it distinguishes 92 of the
94 orbits: there are exactly two fibres of size two.  The distribution of the
twenty triples among the 151 triple types separates both doubled fibres and
therefore distinguishes all 94 orbits.  The first separators are represented
by
\[
 \{(1,0,1),(1,1,3),(1,2,15)\}
 \quad\hbox{and}\quad
 \{(1,0,1),(1,1,4),(1,4,6)\};
\]
in each doubled pair the relevant triple occurs twice in one orbit and not
at all in the other.

This is a coherent-configuration certificate compression, not a new uniform
maximum-six theorem.  Its completeness still enumerates all rooted six-arcs,
canonicalizes them under \(\operatorname{PGL}(2,q)\), and checks extension
point by point.  It replaces the 185 and 964 rooted-stabilizer size-six states
in C605 by 22 and 94 full projective orbits and exposes their inner
distributions, but it does not remove finite exhaustion.

## Rational-dual test

Fix one representative passant edge \(B=\{a,b\}\), and let \(V_B\) be the
off-conic points which may extend it: a point of \(V_B\) joins both \(a,b\)
by passants and does not lie on \(ab\).  The natural first-order rational
relaxation has variables \(x_v\in[0,1]\), the forbidden-pair inequalities
\[
 x_u+x_v\le1
\]
for nonpassant joins, and every projective-line inequality
\[
 \sum_{v\in V_B\cap L}x_v\le 2-|B\cap L|.
\]
To exclude a seven-arc after fixing \(B\), its dual would have to prove
\(\sum x_v\le4\).

It cannot.  Every root type has an exact uniform rational primal witness.
In fact the shape has a uniform explanation.  Through an external
off-conic point there are \((q-1)/2\) passant lines, and through an internal
point there are \((q+1)/2\).  Removing the fixed passant root line leaves
\[
 r(P)=
 \begin{cases}
 (q-3)/2,&P\text{ external},\\
 (q-1)/2,&P\text{ internal}.
 \end{cases}
\]
For \(B=\{a,b\}\), intersection gives a bijection
\[
 V_B\cong
 \bigl(\text{remaining passant pencil at }a\bigr)
 \times
 \bigl(\text{remaining passant pencil at }b\bigr).
\]
Indeed two selected passant lines meet off the conic, and their intersection
joins \(a,b\) by precisely those lines.  Hence
\(|V_B|=r(a)r(b)\).  A line through one root contains at most the other
pencil size, while a line through neither root meets each pencil line once.
Consequently the uniform assignment
\[
 x_v=\frac1{\max(r(a),r(b))}
\]
is feasible and has objective \(\min(r(a),r(b))\).  This gives a uniform
obstruction to the root-edge first-order dual, not merely the following
finite table.

It is also the exact optimum.  If \(r(a)\le r(b)\), sum the \(r(a)\)
capacity-one constraints on the remaining passant lines through \(a\).
Those fibres partition \(V_B\), giving the matching dual bound
\(\sum x_v\le r(a)\); interchange \(a,b\) otherwise.  Thus
\[
 \operatorname{LP}(B)=\min(r(a),r(b)).
\]
Every root type in both tested fields extends to a six-arc, so its integral
extension optimum is exactly four.  The exact integrality gaps are therefore
\(7/4,2\) at \(q=17\) and \(2,9/4\) at \(q=19\).  More generally, for every
odd \(q\ge13\) and every passant root edge, the relaxation has value at least
\((q-3)/2\ge5\), so no dual of this form can prove the required upper bound
four.

The complete shapes are

| \(q\) | \(|V_B|\) | maximum on a line through one root | maximum on a line through no root | uniform \(x_v\) | objective | root orbits |
|---:|---:|---:|---:|---:|---:|---:|
| 17 | 49 | 7 | 7 | \(1/7\) | 7 | 4 |
| 17 | 56 | 8 | 5 | \(1/8\) | 7 | 5 |
| 17 | 64 | 8 | 8 | \(1/8\) | 8 | 4 |
| 19 | 64 | 8 | 8 | \(1/8\) | 8 | 5 |
| 19 | 72 | 9 | 6 | \(1/9\) | 8 | 5 |
| 19 | 81 | 9 | 9 | \(1/9\) | 9 | 5 |

Thus weak duality rules out a certificate of the required strength in this
relaxation, with a large gap rather than a numerical near miss.  A pair-only
Delsarte or coherent bound fails even earlier: a passant line contains
\(q+1=18\) or \(20\) off-conic points which are pairwise passant, while an
arc contains at most two collinear points.  Passancy is binary but the arc
condition is genuinely ternary.  The first failed implication in the
rational route is therefore the passage from line capacities and forbidden
pairs to integral extension sets; in the pair-coherent route it is the loss
of the no-collinear-triple condition.

## Reproducibility and trust boundary

From the repository root, generate and check the canonical artifact with

```text
python3 notes/2026-07-29-c611-q17-q19-coherent-certificates.py
python3 notes/2026-07-29-c611-q17-q19-coherent-certificates.py --check
python3 notes/2026-07-29-c611-q17-q19-coherent-certificates-replay.py
```

The scripts use only the Python standard library, exact prime-field
arithmetic, exact integer orbit enumeration, and `fractions.Fraction`; there
is no randomness.  The generator validates that the C605 edge roots are
disjoint and exhaustive, enumerates rooted six-arcs, and canonicalizes under
the full symmetric-square \(\operatorname{PGL}(2,q)\) action.  The replay
instead expands every listed projective orbit, checks the representatives and
their empty extension sets directly, and verifies that the resulting union
covers every independently regenerated rooted six-arc.  It shares the
coordinate arithmetic and group action with the generator.  C605's separate
C++ primary search and discriminant-based Python replay remain the independent
cross-language check of the underlying maximum-six statement.

The load-bearing inputs are the already tracked C605 certificates:

| input | bytes | SHA-256 |
|---|---:|---|
| `papers/clebsch-rigidity/verification/conic_filling_q17.json` | 4,555 | `8cabfef0bc2e33b221cb2ec5909993cc52398185277863c0f6be1c133cae077a` |
| `papers/clebsch-rigidity/verification/conic_filling_q19.json` | 5,191 | `f659ad5025816cb3a1b4886b21666d7b41e8fd9f3e6dc57a520ae101ab29ece2` |

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-29-c611-q17-q19-coherent-certificates.py` | 17,206 | `0f5298402b2150f77b9d30ddb317365999bd99e8e99cc097b7310ed0cb9f9389` |
| `notes/2026-07-29-c611-q17-q19-coherent-certificates-replay.py` | 5,146 | `49858ca427a6cf79fcd73fc41e134af5ce54e41fd92d2b45497dc6ffa5a21868` |
| `notes/2026-07-29-c611-q17-q19-coherent-certificates.json` | 291,914 | `3b0429b6c136cce819a2da9f44669c4e474e366d2926ff5b757b5335ec98f53d` |

The certificate proves only the two displayed prime fields.  It neither
proves a formula for the orbit counts nor promotes the finite patterns into a
novelty claim.

## Disposition

| surface | disposition |
|---|---|
| Paper I v1 | unchanged; C605 remains its accepted terminal proof |
| Paper I v2 / computational companion | retain the 22/94 projective-orbit compression and the exact coherent signatures as a finite strengthening |
| Paper II | no dependency or natural placement |
| Paper III | no dependency or natural placement |
| uniform exterior-set theorem | not earned; pair and first-order rational routes fail at the explicit points above |

## Extra-juice and Tao-style closeout

The cheap closeout upgrade was to pass from a bare orbit list to its coherent
fingerprints.  Pair data alone completely resolves \(q=17\) and misses only
two doubled fibres at \(q=19\); one triple orbital resolves each.  This is the
smallest structural layer visible in the computation and is more informative
than another extension-search transcript.

The Tao-style pass settles the three rational-LP shapes and their exact
optima uniformly: they are
the external/external, external/internal, and internal/internal products of
the two residual passant pencils, with matching duals obtained by summing
one pencil's line constraints.  The analogous question for the two
\(q=19\) pair-signature collisions remains open.  The orbit count grows from
22 to 94, the pair layer ceases to separate, and the triple layer uses 151
field-specific types.  A genuine maximum-six theorem would have to compress
those types symbolically, not merely enumerate them.

## Mystery ledger

- **Why do only three root-LP shapes occur in each field?** Settled uniformly
  by the residual-pencil product:
  \(V_B\cong\mathcal P_a^\circ\times\mathcal P_b^\circ\), with pencil sizes
  \((q-3)/2\) or \((q-1)/2\) according as the endpoint is external or
  internal.  This yields the candidate counts, capacities, weights, exact
  primal/dual optima, and integrality gaps in one calculation.
- **Why are there exactly two doubled pair-signature fibres at \(q=19\)?**
  The triple separators settle their distinction but not the source of the
  collision.  No paper-facing claim depends on explaining it.
- **Does a uniform ternary coherent theorem exist?** Open.  This task shows
  that the binary and first-order rational layers are insufficient and that
  the finite ternary data suffice at \(q=17,19\); it does not bridge the two.
- **Certificate versus theorem boundary.** Settled: the new artifact is a
  smaller exact finite certificate, not a human or all-\(q\) theorem.

Vibe check: the mechanism search did not produce the hoped-for uniform
maximum-six proof, but it ended cleanly rather than vaguely—the low-order
routes have exact obstructions, and the surviving finite search is compressed
to a transparent coherent orbit classification.
