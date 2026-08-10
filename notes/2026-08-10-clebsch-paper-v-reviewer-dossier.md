# Clebsch Paper V reviewer dossier

**Lane:** clebsch  
**Date:** 2026-08-10  
**Task:** C904  
**Scope:** human-proof, invariant-theory, and exposition referees for
*The Golden Companion Correspondence*. Formalization, software engineering,
release mechanics, and the optional icosahedral tower are out of scope.

> **REVIEW-SUB-AGENT MATERIAL ONLY.** Do not list or load this dossier in a
> handoff, startup context, named-expert routing table, ordinary Paper V work,
> or any Lean task. A parent may pass one selected packet directly to a Paper
> V cold-review sub-agent. Remediation receives frozen findings, not this
> dossier.

## Frozen review surface

Commit: 62cd52eecedb536077e2ac7852d8fcfac917100b.

- source: papers/clebsch-round-trip/golden_companion_reconstruction.tex;
  SHA-256 baa8fbbffd1b46efbae4ab08e7179897b8de824f059ed2e879cf7758c8b2dcc9;
- PDF: papers/clebsch-round-trip/golden_companion_reconstruction.pdf;
  SHA-256 7e0d6ca7c6b13861cc36175a81d12015f362e3c4e1dbb69ddbeb0d19b72e563c;
- visible length: eleven pages.

Cold coordination must recheck both hashes. A changed source or PDF is a new
review surface and may not be mixed silently with this freeze.

### First batch and remediation

The first frozen batch returned GO from the invariant-pencil reader and MINOR
from the marking and singular-geometry readers.  The marking reader found that
Proposition~\texttt{prop:outer-pencil-action} projectivized before recording
the sign of the conference generator.  The revised proposition now prints the
linear action before its projectivization.  The geometry reader found that the
stabilizer count used the inclusion (A_5\subset\operatorname{PSL}_2(11))
without proving it.  The revised proof inserts the determinant-class argument
from the simplicity of (A_5).  The surface above is the resulting second
freeze; it requires a fresh sealed re-review of both repaired causal chains.

## Likely referees and critics

The highest-value personas are:

1. **Antoine Pinardin** — closest-prior invariant-pencil and priority reader;
   exact placement of the Paper-II tensor, characteristic-eleven reduction,
   chordal conventions, and normalized outer action.
2. **Andrew Snowden** — outer-\(S_6\), six-point invariant, and marking
   critic; direct versus outer-twisted modules, equivariance, and silently
   forgotten labels or scalars.
3. **Lisa Marquand** — singular-cubic geometry critic; chordal Hankel form,
   scheme-theoretic singular quartic, automorphism boundary, and what the
   \(A_5\) marking adds.
4. **A conference-matrix/two-graph specialist in the
   Goethals--Seidel/Bussemaker--Mathon--Seidel tradition** — switching,
   opposite orientation, pentagon normalization, and the conference cubic.
5. **A modular-representation or finite-invariant-theory reader** — the
   \(V_5\) projection, absolute irreducibility over \(\F_{11}\), unique
   intertwiner, polynomialization factors, and inverse tensor formula.

Zhijia Zhang is especially plausible because he coauthored both closest
geometric sources, but a simulated batch should not count him twice.
Howard, Millson, Snowden, or Vakil are alternates for the outer-six-point
packet. Cheltsov or Tschinkel are alternates for singular cubic geometry.

JCTA is a coherent combinatorial route; its public page currently names
Michel Lavrauw as editor-in-chief. Algebraic Combinatorics or an
invariant/equivariant-geometry journal is also plausible. This is a forecast
from subject overlap and citation proximity, not inside information.

First full batch: **Pinardin + Snowden + Marquand + conference-matrix
critic**. Add the modular persona for a focused algebra/normalization read.

## Packet P — Pinardin: invariant pencil and priority

### Source conventions

Pinardin--Zhang, *\(A_5\)-equivariant geometry of quadric threefolds*,
arXiv:2508.11496v1:

- §6.2, equations (6.3)--(6.5), prints the relevant two-dimensional
  invariant cubic pencil and its two chordal members;
- the chordal members are singular along rational normal quartics;
- §8.2 supplies the nonstandard \(S_5\)-extension and an involution
  exchanging the quartics.

These are background. Paper V owns the exact placement of the frozen
Paper-II tensor after reduction at eleven, recovery of its original axes,
the normalized action
\[
 q(C)=-C,\qquad q(H)=8C+H,
\]
and compatibility with the signed Paper-II tensor return.

### Critical questions

- Is the outer precomposition convention explicit and correct?
- Is the direct intertwiner rejected geometrically, and is the twisted
  intertwiner unique up to scalar?
- Are pivot \(3\), polynomialization, \(B=I+J\), and \(T\) undone exactly?
- Is the known projective involution separated from the exact
  characteristic-eleven matrix and Paper-II marking?
- Is \(q\) independent of the odd normalizer representative?
- Does the conference package determine only the unordered chordal pair?
- Does any sentence still imply literal equality of the two cubic lines?

## Packet S — Snowden: outer \(S_6\) and markings

### Source conventions

Howard--Millson--Snowden--Vakil, *A description of the outer automorphism of
\(S_6\), and the invariants of six points in projective space*, JCTA 115
(2008), §§1.1--1.6 and 2.1--2.4:

- the exceptional six-point actions and outer identification are
  label-sensitive;
- the five-dimensional realizations agree only after the outer twist;
- Joubert/Segre coordinates and matchings require a dictionary;
- equivariance concerns transported markings, not unlabelled coordinate
  equality.

### Critical questions

- Is the axis augmentation \(A_X\) retained throughout?
- Are arbitrary scalar intertwiners excluded, preserving sign/orientation?
- Do relabellings transport \(X,L,h,c,T\), and the Paper-III datum together?
- Is simultaneous negation an involution rather than an isomorphism?
- Is the source return claimed only for decorated packages in the image?
- Are stable result titles used instead of theorem numbers?
- Does the objectwise formulation state exactly what is returned?

## Packet M — Marquand: chordal singular geometry

### Source conventions

Cheltsov--Marquand--Tschinkel--Zhang, *Equivariant geometry of cubic
threefolds with non-isolated singularities*, arXiv:2505.03986, §5:

- the chordal cubic is the Hankel determinant;
- its singular locus is a rational normal quartic;
- the unmarked chordal cubic has automorphism group \(\PGL_2\).

Axes must therefore come from the marked \(A_5\)-action and exact
stabilizers, not from the unmarked cubic.

### Critical questions

- Does the Jacobian proof establish saturated-ideal equality?
- Do the three affine opens cover the projective Jacobian scheme?
- Is the stabilizer argument restricted to \(R(\F_{11})\)?
- Why do rational points have exact stabilizer \(C_5\), in disjoint pairs?
- Is \(A_5/C_5\to A_5/D_5\) intrinsic and equivariant?
- Why does each recovered \(D_5\) fix a unique original matching pair?
- Is the larger unmarked automorphism group respected?
- Are base-changed fixed loci reduced split degree-two schemes?

## Packet C — conference matrices and two-graphs

### Source conventions

Goethals--Seidel, *Orthogonal matrices with zero diagonal* (1967), §§1--3,
and Bussemaker--Mathon--Seidel, *Tables of two-graphs* (1979), pp. 12, 21,
and Table 9:

- conference matrices are compared up to permutation and switching;
- a normalized symmetric order-six signing is a pentagon on five vertices;
- complement/opposite reverses the oriented triangle cubic;
- projective cubic lines forget sign, while the round trip retains it.

### Critical questions

- Does first-row normalization yield a simple two-regular five-vertex graph?
- Is the classical automorphism claim separated from that elementary proof?
- Why does \(N_{S_6}(A_5)/A_5\) exchange the opposite classes?
- Does the six-set determine only a projective conference line before sign?
- Are switching, relabelling, negation, scaling, and sheet reversal distinct?

## Packet R — modular representation and tensor normalization

Paper II's stable results *The \(3,6,10\) quotient ranks* and *Balanced
sheets and cubic-first orientation* supply the quotient and signed cubic.
Paper V adds
\[
 W|_{A_5}\cong\mathbf1\oplus V_4\oplus V_5
\]
and the exact bridge
\[
 h=3^{-1}\operatorname{Pol}(\operatorname{Sym}^3(BT^{-1})\nu),\qquad
 \nu=\operatorname{Sym}^3(TB^{-1})\operatorname{Pol}^{-1}(3h).
\]

Critical questions:

- Is \(\F_{11}\) a splitting field and are summands absolutely irreducible?
- Does the central-character projector use the correct scalar convention?
- Is normalization fixed before sheet reversal, giving \(-h\)?
- Is the pullback convention \(U(h)(z)=h(Uz)\) explicit?
- Does the inverse undo every operation in the right order?
- Are matrix identities isolated as exact proof leaves?

## Cross-persona criticals

1. The literal-equality correction must remain visible.
2. The outer twist is a single-point failure mode.
3. The round trip is marked, oriented, and image-restricted.
4. The singular quartic must recover the original axes, not only an abstract
   six-set.
5. Classical pencil/chordal facts need exact credit; the forward-citation
   search does not license a negative novelty assertion.
6. Pivot \(3\), output scalar \(8\), \(B=I+J\), and pullback convention are
   linked.
7. Switching, relabelling, projectivization, and orientation reversal must
   not collapse.
8. Base change covers the companion core and Paper-II tensor maps, not the
   characteristic-zero Paper-I/III source packages.

Items 1--4 can produce a major mathematical finding. Items 5--8 are likely
minor unless they expose a mismatch.

## Cold-read protocol

Each reader receives only this dossier or one named packet, the frozen PDF
and hashes, and an instruction to judge the current manuscript independently.
The reader identifies the earliest unsupported implication, distinguishes
mathematical defects from editorial improvements, and returns GO, MINOR, or
MAJOR. Numerical grades are chat-only.

After any fix, rebuild and refreeze. Re-reviewers must be told that the
surface changed and must read repaired passages in the full causal chain.
