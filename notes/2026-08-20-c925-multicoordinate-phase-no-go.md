# Module 50. No ordinary multi-coordinate completion preserves the pilot phase

**Packet part:** Module 50.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** the one-coordinate phase failure of Module 49 is forced by a
general convex-geometric obstruction.  In any of the three admissible pilot
chambers, every independently adjoined affine coordinate that preserves the
old semistable locus must have weight in the cone opposite the chamber.
Their total character therefore also lies in that opposite cone.  The
required canonical correction \(c=(1,-1)\) does not.  Thus no finite ordinary
affine multi-coordinate completion can simultaneously cancel the canonical
character and preserve the intended total-space phase.

## 50.1 Phase-safe added weights

Let \(M_\mathbf R\) be a two-dimensional real character space.  Let

\[
                         C=\operatorname{Cone}(u,v)             \tag{50.1}
\]

be a strictly convex cone with linearly independent boundary generators
\(u,v\), and fix \(\theta\in\operatorname{int}(C)\).  Assume the raw torus
representation \(W\) contains nonzero weights on both boundary rays
\(\mathbf R_{>0}u\) and \(\mathbf R_{>0}v\).

For weights \(d_1,\ldots,d_r\), put

\[
                 W'=W\oplus\bigoplus_{j=1}^r\mathbf C_{d_j}.   \tag{50.2}
\]

Call this completion **phase-safe at \(\theta\)** if

\[
                 (W')^{\mathrm{ss}}_\theta
                   =W^{\mathrm{ss}}_\theta
                      \oplus\bigoplus_{j=1}^r\mathbf C_{d_j}.  \tag{50.3}
\]

Thus every point made semistable using added coordinates was already
semistable from its raw \(W\)-support.

### Proposition 50.1 -- opposite-cone necessity

If (50.2) is phase-safe at \(\theta\), then

\[
                              d_j\in-C                        \tag{50.4}
\]

for every \(j\).  Consequently

\[
                         \sum_{j=1}^r d_j\in-C.               \tag{50.5}
\]

#### Proof

Choose coordinates in which \(u=(1,0)\), \(v=(0,1)\), and
\(\theta=(a,b)\) with \(a,b>0\).  Fix one added weight
\(d=(x,y)\).  If \(d\notin-C\), then \(x>0\) or \(y>0\).

If \(x>0\) and \(b x\ge a y\), then

\[
             \theta=\frac a x d+
                    \left(b-\frac{a y}{x}\right)v.           \tag{50.6}
\]

The coefficients are nonnegative, so a point supported on the added
\(d\)-coordinate and a raw \(v\)-ray coordinate is semistable.  Its raw
support is only the \(v\)-ray and hence does not span the interior point
\(\theta\).

Otherwise either \(y>0\) and \(a y\ge b x\), or the preceding case already
applies.  In the former case

\[
             \theta=\frac b y d+
                    \left(a-\frac{b x}{y}\right)u,            \tag{50.7}
\]

and the same argument uses a raw \(u\)-ray coordinate.  Equality in the two
cross-product inequalities is harmless: one of the second coefficients is
zero, and the raw one-ray support still does not span \(\theta\).  Hence any
\(d\notin-C\) creates a new semistable point, contradicting phase safety.

Therefore every \(d_j\in-C\).  Since \(-C\) is a convex cone, their sum also
lies in \(-C\).  \(\square\)

Only necessity is asserted.  We do not claim that arbitrary weights in
\(-C\) are sufficient for phase safety: several added coordinates or other
raw rays can create further supports.

## 50.2 Canonical-character obstruction for all five pilots

For the five quasi-symmetric genuine unit signatures of Module 41, the raw
weights contain both signs on both coordinate axes by (41.15f).  The three
admissible chambers and their opposite cones are

\[
\begin{array}{c|c}
 C & -C\\ \hline
 \mathrm{NE} & \mathrm{SW}\\
 \mathrm{SE} & \mathrm{NW}\\
 \mathrm{SW} & \mathrm{NE}.
\end{array}                                                     \tag{50.8}
\]

The total character that must be added to cancel the raw discrepancy is

\[
                              c=(1,-1).                         \tag{50.9}
\]

It lies in none of the three opposite cones in (50.8).

### Theorem 50.2 -- no ordinary affine phase-safe completion

Fix any of the five signatures and its chamber selected by Corollary 41.4A.
There is no finite list of added coordinate weights \(d_1,\ldots,d_r\) such
that both

\[
                       \sum_{j=1}^r d_j=c                     \tag{50.10}
\]

and the ordinary affine completion (50.2) is phase-safe at the selected
linearization.

#### Proof

If it were phase-safe, Proposition 50.1 would put the sum (50.10) in the
opposite cone.  Equation (50.9) and the table (50.8) rule this out.  \(\square\)

### Corollary 50.2A -- the repair menu narrows

Module 49's proposed repair by merely replacing the canonical coordinate
with finitely many ordinary affine coordinates cannot work while retaining
the same torus, the same linearization, the same raw semistable locus, and
total added character \(c\).  Any successful completion must change at least
one of those features.

In particular, the remaining completion-side possibilities are genuinely
different constructions: an enlarged torus/master space, a relative or
\(p\)-field stability condition, or a restriction theorem from the completed
quotient to the intended open.  The independent normal-jet adapter remains
unaffected.

## 50.3 Categorical reading

The added affine coordinates form a free commutative monoid of possible
supports.  The support-cone consumer sends a support to the cone it spans and
then asks whether it contains \(\theta\).  Proposition 50.1 says that the
kernel congruence required to forget each added generator forces every such
generator into \(-C\).  The total-character Writer map is additive, so its
value is trapped in the same cone.  The desired value \(c\) lies outside.

Thus the obstruction is compositional: splitting the bad coordinate into
more generators cannot help because the forgotten generators retain an
additive cone-valued trace.

## 50.4 Scope and hostile edges

The theorem concerns ordinary affine GIT for the same torus and the same
linearization, with independently variable added coordinates.  It does not
cover:

1. added equations or a superpotential restricting which supports occur;
2. an enlarged group with a different character lattice;
3. relative stability that ignores fibre coordinates;
4. a non-affine master space; or
5. restriction of a comparison already constructed on a larger quotient.

The boundary-ray hypothesis is load-bearing.  A raw representation that
contains only one sign on an axis need not satisfy Proposition 50.1; this is
why Module 49 and the present theorem import the full five-signature
quasi-symmetric classification rather than only the genuine-wall span
condition.

## 50.5 EJ/TT and mystery ledger

**EJ.** The finite Module 49 counterexamples reveal an additive obstruction:
the phase-safe weights form a subset of the opposite chamber cone, so no
finite refinement of the canonical character can evade the failure.

**TT.** The right invariant is not the number of completion coordinates but
the cone containing every individually forgettable support generator.  Test
that cone before attempting any derived or quantum comparison.

| question | status | exact evidence or gate |
|---|---|---|
| Can several ordinary coordinates repair the one-coordinate failure? | **no** | Theorem 50.2 |
| Does this depend on total unimodularity? | **no** | only the signed boundary rays from (41.15f) are used |
| Can an enlarged group or relative stability evade it? | **open** | outside Proposition 50.1's fixed-torus support syntax |
| Does the natural completed equivalence descend to the intended opens? | **no** | Module 51 mixed-support theorem |
| Is the boundary invisible to the sparse rank row? | **yes conditionally** | Module 51 under the completed-rank/Thom realization |
| Is the normal-jet route affected? | **no** | it does not require phase equality |

## Boundary

Module 50 rules out every finite ordinary multi-coordinate canonical
completion of the five pilot overlaps that keeps the original torus,
linearization, and semistable base locus.  It does not rule out relative,
master-space, open-restriction, or normal-jet constructions, and it does not
produce the missing fixed-phase QDM adapter.

**Successor.**  Module 51 rules out Verdier descent of the natural completed
kernel to the intended opens, while proving that the generic/divided rank
consumer remains boundary-null.  Thus the surviving sparse route is the
same occurrence-level fixed-phase row adapter as the normal-jet route.
