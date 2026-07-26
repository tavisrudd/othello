# C619: GRS lift coherence and the Heisenberg obstruction

**Lane:** `ame-lu`

**Status:** complete

## Result

The odd-prime generalized and extended generalized Reed--Solomon lift
boundary is exact.

Fix an input coordinate \(j\) and a diagonal duality
\(S=\operatorname{diag}(s_i)\) with \(SC=C^\perp\).  If
\[
 A=\begin{pmatrix}a&b\\c&d\end{pmatrix}\in\operatorname{SL}_2(q),
 \qquad t_i=s_i/s_j,
\]
then propagation to coordinate \(i\) is
\[
 \phi_i(A)=
 \begin{pmatrix}a&t_i^{-1}b\\t_i c&d\end{pmatrix}
 =
 \begin{pmatrix}1&0\\0&t_i\end{pmatrix}
 A
 \begin{pmatrix}1&0\\0&t_i^{-1}\end{pmatrix}.
\]
Thus \(\phi_i\) is a homomorphism and \(\phi_j\) is the identity.  C613's
upper and lower elementary matrices therefore satisfy every defining
\(\operatorname{SL}_2(q)\) relation coordinatewise, for both ordinary and
extended GRS codes.  The calculation uses only diagonal duality, so there is
no code-dependent projective defect at the symplectic-label level.

Over an odd finite field, the finite Stone--von Neumann representation of
the Heisenberg group extends to a genuine representation of
\(\operatorname{SL}_2(q)\ltimes H_q\).  Composing the Weil factor with each
\(\phi_i\) gives multiplicative local lifts.  Exact Egorov covariance
preserves the CSS stabilizer line.  Hence the scalar extension restricted to
the linear \(\operatorname{SL}_2(q)\) factor splits.  The \(q=3\) uniqueness
exception in the cited extension theorem does not affect existence.

The full affine one-qudit extension does not split.  Choose \(a,b\) with
\(\chi(ab)\ne1\).  The projective Weyl classes of \(X(a)\) and \(Z(b)\)
commute, but all unitary representatives satisfy
\[
 Z(b)X(a)=\chi(ab)X(a)Z(b).
\]
Scalar rephasing does not change this commutator.  A homomorphic section of
\(\mathbb F_q^2\) would make the representatives commute, so no such section
exists.  The coherent lift of the projective affine group is the
Heisenberg--Weil group \(H_q\rtimes\operatorname{SL}_2(q)\), not a copy of
\(\mathbb F_q^2\rtimes\operatorname{SL}_2(q)\) inside the unitary Clifford
group.

Accordingly, there is no remaining metaplectic or Schur-multiplier
obstruction on the \(\operatorname{SL}_2(q)\) factor in odd characteristic.
The surviving obstruction is the Heisenberg central extension on
translations.

## Three extensions that must not be conflated

| Extension | C619 verdict |
|---|---|
| Heisenberg extension over Weyl translations | non-split, detected by the Weyl commutator |
| one-qudit Clifford scalar extension over the linear \(\operatorname{SL}_2(q)\) factor | split by the finite-field Weil representation |
| realized party-permutation extension \(1\to\Gamma\to\widetilde\Gamma\to\Pi\to1\) | independent of both preceding statements; its exact criterion remains C618's nonabelian factor-set triviality |

The third quotient depends on the chosen evaluation set through its realized
permutation group \(\Pi\), and its kernel is the full fixed-party projective
group \(\Gamma\), not scalar phases.  C613's fixed-party GRS generators
therefore neither prove nor obstruct a party-permutation splitting.

## Manuscript and formal boundary

Section 3 now gives the propagation formula, the coherent odd-field Weil
lift, the Weyl-commutator non-splitting proof, and the separation from the
party-permutation factor set.  The introduction states the same boundary
immediately after the exact projective GRS-group corollary.  The theorem,
claim/proof/novelty, verification, formalization, and statement-adequacy
ledgers agree.

No finite check was adopted: the relation audit is symbolic, and the
Heisenberg obstruction is a two-generator proof.  Consequently no new
computational evidence bundle is required.  The existing Lean interface
still proves the projective carrier equality conditionally and the abstract
party-permutation obstruction unconditionally.  It does not formalize the
complex Weil representation, so the phase-level split/non-split result is
identified as manuscript proof rather than kernel-checked coverage.

## Literature record

One source was read at full text.

- Paul Gérardin, *Three Weil Representations Associated to Finite Fields*,
  published version, 1976, Theorem 1 and its properties on pp. 268--269.
  **Read depth:** `full text`, all three pages, from the shared cache key
  `10.1090/S0002-9904-1976-14017-7`, SHA-256
  `010d33d76214ba58404847f4bfba39f3a469b80ceb68a41e012b65e42f5c59e3`.
  The load-bearing statement is existence of a genuine extension of the
  finite Heisenberg representation to the odd-characteristic symplectic
  semidirect product.  C619 does not infer a novelty or priority negative
  from this source.

## Validation

- `make -C papers/ame_lu check`: warning-free, 20 pages, 186,711 bytes.
- PDF SHA-256:
  `bf13a3bbcdca461e87e8cb4b9495a3f312a5b034a9f84feb02d847f0446cc538`.
- Pages 6--8 were rendered; the exact sequences, GRS construction, new lift
  audit, equations, and section transition are legible with no bad break.
- All seven evidence bundles replayed.  The refreshed release manifest verifies
  35 public artifacts and 73 formal companion artifacts; their tree hashes are
  `354f5d902ea7b79a2b8e4f2afeab603778caa1f78c1eb96a1a4459faa3112bbe`
  and
  `7d8578e0e585a3d62559c058e0cf8769a90e5405c11340045a12d4046b023f29`.
- No Lean source changed, so the existing aggregate artifacts remain the
  formal boundary rather than a validation claim for the new phase-level
  proof.

## `ej` and Tao closeout

The first cheap strengthening extracted the conjugation formula for every
propagated block, replacing a generator-by-generator plausibility argument by
a group homomorphism.  It shows that the relation audit depends only on
diagonal self-duality, not on the GRS evaluation formula.

The second strengthening tested the tempting claim that odd-field Weil
linearity splits the full projective Clifford group.  Restriction to the
translation subgroup disproves it immediately: the invariant scalar
commutator survives every phase choice.  The correct coherent object is the
Heisenberg--Weil semidirect product.

The final stress test asked whether this conclusion also trivializes C618's
factor set.  It does not: that extension has a different kernel and quotient,
and arbitrary GRS evaluation sets have different realized permutation groups.
The manuscript now keeps the two questions adjacent but logically separate.

## Mystery ledger

| Feature | Closeout status | Evidence gap or owner |
|---|---|---|
| Do the propagated elementary lifts satisfy all `SL_2(q)` relations? | **Settled:** every coordinate map is conjugation by \(\operatorname{diag}(1,t_i)\). | none |
| Is there a metaplectic obstruction on the odd-field linear factor? | **Settled negatively:** the finite Heisenberg representation has a genuine Weil extension. | none |
| Does the full affine one-qudit scalar extension split? | **Settled negatively:** its Weyl translation subgroup has a nontrivial scalar commutator. | none |
| Does this decide the party-permutation extension? | **Settled as independent:** the relevant quotient and kernel are different, and C618 gives its exact code-specific criterion. | no uniform split claim is licensed without a chosen evaluation-set factor-set computation |
| Is the phase-level result kernel checked in Lean? | **Settled boundary:** no; the current formal API stops at projective carrier equality and abstract extension theory. | a future formal Weil-representation library, not required for the manuscript proof |

No unexplained mathematical feature remains in the GRS scalar lift audit.

**Vibe check:** the apparent metaplectic risk disappears cleanly on the
linear factor, but the stronger affine splitting is decisively false for the
simplest possible reason.  The resulting statement is both sharper and less
fragile than a finite relation table.
