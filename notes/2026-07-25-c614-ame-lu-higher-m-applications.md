# C614 — higher-\(m\) AME-LU applications

**Lane:** `ame-lu`

**Date:** 2026-07-25

**Status:** complete

## Result

The uniform LU-to-LC theorem now has three higher-\(m\) consequences in
version 1.

1. If a product physical unitary converts either of the associated
   \([[2m-1,1,m]]_q\) encoders into another, then every physical factor and
   the logical intertwiner are Clifford.
2. The product-unitary automorphism group of every equal-phase MDS--CSS state
   is finite modulo one-site scalar phases.  Before quotienting, its identity
   component consists only of those phases; party permutations give a finite
   extension.
3. For odd prime \(q\), every length-\(2m\) generalized or extended
   generalized Reed--Solomon code with \(2m\le q+1\) gives a quantum MDS code
   whose projective transversal logical group is exactly
   \[
     \mathbb F_q^2\rtimes\mathrm{SL}_2(q),
   \]
   the full projective one-qudit Clifford group.

The concrete first case beyond six parties is the extended
\([8,4,5]_7\) code:
\[
  \operatorname{AME}(8,7)
  \longleftrightarrow [[7,1,4]]_7,
  \qquad
  |\mathbb F_7^2\rtimes\mathrm{SL}_2(7)|=16464.
\]
No transversal non-Clifford gate enlarges this group.

## Proof

For two encoders, the normalized Choi convention turns
\(U_{\rm phys}V_C=V_DL\) into
\[
 \bigl((L^T)^{-1}\otimes U_{\rm phys}\bigr)|\Psi_C\rangle
   =|\Psi_D\rangle .
\]
The general rigidity theorem makes every displayed factor Clifford, and
transpose preserves the finite-field Clifford normalizer.

For a half-dimensional GRS code, standard dual multipliers give a nonsingular
diagonal matrix \(S=\operatorname{diag}(s_i)\) with \(SC=C^\perp\).  The
coordinatewise symplectic blocks
\[
 \begin{pmatrix}1&0\\ \lambda s_i&1\end{pmatrix},
 \qquad
 \begin{pmatrix}1&\mu s_i^{-1}\\0&1\end{pmatrix}
\]
preserve \(C\oplus C^\perp\).  Product-Pauli corrections repair stabilizer
phases without changing these blocks.  On any chosen input leg they realize
all lower and upper elementary unipotents, hence all of
\(\mathrm{SL}_2(q)\).  The Choi correspondence sends an input block \(A\) to
the logical block \(A^{-T}\), an automorphism of \(\mathrm{SL}_2(q)\).
Physical Pauli representatives supply \(\mathbb F_q^2\), while the general
transversal no-go excludes every product-unitary action outside the
projective Clifford group.

## Editorial review

The new material received a claim-sensitive copy edit.  In particular:

- the projective transversal group is defined operationally at its first
  theorem statement;
- the abstract names the exact GRS range \(2m\le q+1\), rather than referring
  vaguely to a tower;
- the proof mechanism is described using \((m+1)\)-party marginals in the
  plural, since a retained-set cover is needed to recover every site; and
- the Choi action is written concretely as \(A\mapsto A^{-T}\).

A Milnor-style abstract pass reorganized the front matter as question,
theorem, operational consequence, proof mechanism, and six-party
application.  Repetition and table-of-contents phrasing were removed.  The
title is now

> *Local-Unitary Rigidity of MDS--CSS AME States: Exact Transversal Clifford
> Groups and Six-Qudit Moduli*.

This is stronger and more faithful than the previous title: it leads with the
general theorem, names the new exact operational result, and retains the
six-party classification without suggesting that every MDS code has the GRS
group.

## Lean queue

C612 now owns the general marginal expansion, LU-to-LC terminal, and
projective-finiteness/identity-component corollary.  C613 owns the two-encoder
Choi theorem, factorwise no-go, length-generic GRS dual-multiplier
construction, exact projective group, and the \([8,4,5]_7\) specialization.
C602 remains the final aggregate trust and prose audit.

## Validation

- `make check`: warning-free 18-page XeLaTeX build.
- The title page, abstract, opening exact-group statement, and both pages of
  the new proof were visually inspected.
- `make release-check`: all seven exact-evidence bundles replayed; 35 public
  artifacts and 12 formal-companion artifacts verified.
- PDF SHA-256:
  `65676080cb6e3d40d55ad504f7b8459a9a2ef1eca7dd328b4d1575f8945c393f`.
- Public-tree SHA-256:
  `ac016aadea4003340446dc2ca97966358dd830dc3e6a788fe62a513739f508b0`.
- Formal-tree SHA-256:
  `c738a7141b9b854cdd1cd5a96fd4bba0a2fda06072f5e181dca685ec9e24745e`.

## `ej` and Tao closeout

The free strengthening was exactness.  Once the diagonal GRS duality
\(SC=C^\perp\) is written down, its two shear families give the whole logical
\(\mathrm{SL}_2(q)\), not merely a nontrivial subgroup or a list of gates.
Combining that construction with the general LU rigidity theorem closes the
opposite containment at no additional computational cost.

The stress test separated three different group statements that are easy to
blur: finiteness of the general product-unitary symmetry group, exactness of
the GRS transversal logical group, and the six-party
\(\mathrm{SL}_2\)-versus-torus phase.  Their hypotheses and quotients are now
stated separately.  The proof does not extrapolate the six-party propagation
argument to higher \(m\).

## Mystery ledger

| Feature | Closeout status | Remaining gap or owner |
|---|---|---|
| Transversal conversion between distinct MDS--CSS encoders | **Settled:** Clifford on every physical and logical factor | C613 formalization |
| Continuous local symmetry of the general family | **Settled:** only scalar phases survive in the identity component | C612 formalization |
| Exact higher-\(m\) GRS transversal logical group | **Settled over odd prime fields:** full projective one-qudit Clifford group | C613 formalization |
| First explicit \(m>3\) instance | **Settled:** `AME(8,7)` / `[[7,1,4]]_7`, group order 16464 | C613 specialization |
| Extension-field exact group | **Not claimed:** the full local Clifford quotient is larger than `SL_2(q)` in the paper's convention | C581 may clarify the phase-space reconstruction |
| Exact groups for non-GRS codes when \(m>3\) | Open | version 2 or a separate classification task |

**Vibe check:** the paper now has a general rigidity theorem, a general
fault-tolerance no-go, and an infinite family attaining the exact allowed
group.  The six-party moduli no longer carry the operational significance
alone.
