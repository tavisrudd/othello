# C620 — Clebsch graded evaluation algebra

**Lane:** `clebsch`

**Date:** 2026-07-25

**Status:** `COMPLETE; PAPER II COROLLARY ADOPTED`

## Result

Let \(L\subseteq\mathbb F_q^{\Omega_T}\) be the affine evaluation
space of the balanced \(B_3\) or \(H_3\) quotient configuration.  Paper II
already proves
\[
(L^{\circ2})^\perp=\mathbb F_q\epsilon,\qquad
\dim L^{\circ2}=2q-1,
\]
and certifies that the signed cubic tensor
\(\mu_3=\sum_M\epsilon(M)x_M^{\odot3}\) is nonzero.  The new symbolic
corollary proves
\[
L^{\circ3}=\mathbb F_q^{\Omega_T}
\]
and hence
\[
\dim L^{\circ d}=
\begin{cases}
1,&d=0,\\
q,&d=1,\\
2q-1,&d=2,\\
2q,&d\ge3.
\end{cases}
\]
For
\(\widehat X_T=\{[1:x_M]:M\in\Omega_T\}\subseteq\mathbb P^{q-1}\),
this is the Hilbert function
\[
1,\ q,\ 2q-1,\ 2q,\ 2q,\ldots
\]
with \(h\)-vector \((1,q-1,q-1,1)\).

## Proof and characteristic boundary

Pair functions with the sheet sign.  The quadratic result says that
\(L^{\circ2}\) is exactly the kernel of this pairing.  In characteristics
\(7\) and \(11\), degree-three polarization identifies
\(\operatorname{Sym}^3(W_T^*)\) with
\(\operatorname{Sym}^3(W_T)^*\).  Thus \(\mu_3\ne0\) supplies a cubic in
the linear coordinates whose evaluation pairs nontrivially with
\(\epsilon\).  This evaluation lies in \(L^{\circ3}\).  Since \(1\in L\),
\(L^{\circ2}\subseteq L^{\circ3}\); the latter therefore contains the
quadratic hyperplane and one direction outside it, so it is the full
function space.  Multiplication by \(1\) settles every higher degree.
Homogenization identifies degree-\(d\) restrictions with
\(L^{\circ d}\), giving the Hilbert function and its first difference.

This is also the precise join with C417.  Changing the reference matching
translates every quotient point, so it preserves \(L\), every
\(L^{\circ d}\), and the projective equivalence class of \(\widehat X_T\).
C417 proves that the translation cocycle is nontrivial for both the inner
and full groups: the affine quotient has no equivariant origin, and its
homogeneous lift retains the corresponding nonsplit extension.  Thus the
graded algebra descends despite the origin obstruction; “independent of
the reference matching up to translation” cannot be strengthened to a
canonical equivariant centering.  The nontriviality and extension
identification remain on C417's primary/replay/checksum evidence surface
rather than being imported as a new Paper II theorem or seventh evidence
bundle.

The polarization hypothesis is load-bearing as stated.  The argument makes
no Gorenstein, self-association, Cayley--Bacharach, or inverse-system claim.
Those remain behind C621's separate falsifier-first gate.

## Paper and trust disposition

The result is adopted immediately after the balanced cubic theorem in
`papers/clebsch-factorization/clebsch_factorization.tex`.  It belongs in
Paper II because it converts the paper's quadratic recovery and cubic
orientation inputs into the complete graded evaluation algebra with no new
finite search and no new evidence bundle.

The statement identity and trust manifest now contain seventeen exact
theorem-like statements.  The new corollary is marked conceptual plus
certificate-backed: the implication is symbolic, while its two premises
remain the existing `matching-module` and `balanced-sheet` inputs.

From `/home/tavis/src/othello`, the aggregate command

```bash
python3 papers/clebsch-factorization/verification/verify_release.py
```

passed on 2026-07-25.  It checked the seventeen-row statement partition,
six evidence bundles, primary and independent replays, and the manuscript
build.  The resulting twenty-page PDF has no LaTeX warning, overfull-box,
or underfull-box diagnostic.

## `ej` + `tt` closeout and mystery ledger

The `ej` pass found that the full higher-degree filtration costs no extra
argument: once degree three is the full function space, the constant
function propagates fullness to every degree.  Recording the homogenized
configuration then turns the same statement into the exact Hilbert
function and \(h\)-vector.

The `tt` pass isolated the only subtle bridge.  A nonzero element of
\(\operatorname{Sym}^3(W_T)\) does not by notation alone produce a cubic
functional in arbitrary characteristic; the proof now states the
degree-three polarization isomorphism and the valid characteristics
explicitly.  It also checks that the \(h\)-vector symmetry is reported only
as numerical data.

| mystery | status | exact remaining gap or owner |
|---|---|---|
| Why does the cubic tensor escape the quadratic hyperplane? | settled | Degree-three polarization turns \(\mu_3\ne0\) into an evaluated cubic pairing nontrivially with the unique quadratic annihilator \(\epsilon\). |
| Does degree-three fullness persist? | settled | \(1\in L\) propagates the full function space to every higher pointwise power. |
| Does reference independence come from a canonical equivariant origin? | settled negatively by C417 | No. The base-choice cocycle is nontrivial and the homogeneous lift is nonsplit. Translation nevertheless preserves \(L\), its Schur powers, and the projective Hilbert function. |
| Does the symmetric \(h\)-vector imply a Gorenstein or self-associated point set? | open by design | C621 owns the saturated-ideal, Betti, type, Cayley--Bacharach, and inverse-system falsifier gate. C620 makes no such inference. |

The discovery-track discriminator found no incidental result outside these
task-owned conclusions.
