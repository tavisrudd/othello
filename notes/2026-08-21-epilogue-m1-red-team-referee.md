# Red-team referee pass on the unconditional `m=1` epilogue proof

**Lane:** `cubic-threefolds`
**Date:** 2026-08-21
**Target:** `papers/cubic-stabilization-epilogue/sections/04-categorical-one-step.tex`,
Theorem `every-cubic` (for every smooth cubic threefold `X`, `X x P^1` is irrational).

Main-agent read plus three independent cold referees (formal D-module lens, source-fidelity
lens against the Iritani and Iritani--Koto texts in the literature cache, birational-sanity
lens). The three referee reports are appended verbatim below.

## Verdict

No arithmetic error and no contradiction with an established theorem was found. Every number
in the cubic block (`K_X`, `C`, `D_0`, `E_0`, `R_X`, `delta = 4/9`, exponents `-1/6, -5/6`)
was reproduced independently by three routes, including a gauge-free indicial computation.
Both source theorems say what the paper needs (`z d/dz` direction included, pairing
intertwined, graded Laurent ring into which the blowup's Novikov ring injects). The rational
`X_{2,2} \subset P^5` (forced non-semisimple by Hertling--Manin--Teleman) carries a rank-two
nilpotent block with `delta = 0` exactly, and `X x P^1` by direct Kuenneth gives two
`delta = 4/9` blocks with no merging. The proof survives its sharpest cheap tests.

Three defects that are real as written, ranked:

1. **Marker fires on resonant blocks (design defect, computed).** `delta != 0` is the squared
   eigenvalue difference, not non-integrality of the exponent difference. For cubic
   `N`-folds the ambient rank-two piece has exponents `-1/2 +- (N-1)/6`, so the cubic
   fourfold gets `delta = 1` with integer-separated exponents `0, -1`. Since Pfaffian cubic
   fourfolds are rational and `I_at` is deformation invariant, the `d=4` theorem forces
   `I_at(cubic fourfold) = 0`. At the small point the 0-block has rank 24, so the marker is 0
   there, but nothing in the paper controls how that block refines at generic even bulk.
   Free repair: replace `delta != 0` by `rho_1 - rho_2 not in Z`. Strictly smaller, so
   center nullity is preserved; cubic threefold still marked (`2/3`); `P^4` still 0; matches
   what the introduction actually claims.
2. **Even-bulk restriction of `Psi` is asserted, not proved, and is load-bearing.** Iritani
   Thm 5.18 and Iritani--Koto Thm 5.1 are stated on full `H^*`. On full cohomology of the
   cubic, `P * alpha = 0` for `alpha in H^3`, so the 0-block has rank 12 and the marker reads
   0. The repair exists: Iritani's super-conventions (odd coefficients vanish on the even
   body) plus the parity-even initial conditions (5.44)--(5.45) and the `section 5.8`
   uniqueness. The sentence "Jacobians are invertible, hence so are their even-even blocks"
   is a non-sequitur without it.
3. **Ledger additivity silently needs disjoint Euler spectra across summands.** If an ambient
   and a center block share a generic eigenvalue, primary components merge (two marked
   rank-two blocks become one rank-four block, `2 -> 0`). Never stated. Cited to parts
   (4),(6),(7) of Thm 5.18, which say nothing about eigenvalues; Remark 5.21 does, but only
   along `Q = tau = 0`. Provable from (6)--(7) by a two-line resultant/leading-order argument;
   the Iritani--Koto side is uncited.

Secondary, all repairable by wording or one sentence:

- "`rank, primary factors ... unchanged after either field extension`" (section 4.2) is false:
  `(T^2 - q)^2` is one rank-four block over `C(q)` and two rank-two nilpotent blocks over
  `C(sqrt q)`. Fine once section 4.1 pins blocks over an algebraically closed field.
- Block type requires morphisms to preserve the grading, but `Psi`'s center component has
  degree `-r` (Iritani--Koto: `-(r-1)`). `delta` is unaffected (invariant under
  `R -> R + cI`), but `Psi` is not a morphism of the declared type.
- No "algebraic coefficient algebra" carries the connection matrix of a non-Fano fourfold;
  what is needed and true is injectivity of Iritani's (1.1) on the graded Novikov completion.
- Iritani line 4318 says the function-level pullback `sigma_j^*` "is ill-defined" because of
  `h_{Z,j}`; "faithful scalar extension of `QDM(Z)`" overstates Remarks 2.3/5.6.
- The bridge from the small point to generic even bulk is asserted; the missing line is
  `d tr(N^2) = -2 q tr(N^2)`.
- AKMW projectivity of intermediates is Theorem 0.3.1, not 0.1.1.

## Opportunities surfaced

- `I_at` satisfies Bittner's blowup relation, so it is a truncated motivic measure with
  `mu(surfaces) = 0` and `mu(L) != 0`; this explains why `m=1` is cheap and `m >= 2` leaks.
- The `d=3` instance of the ledger theorem makes `I_at` a birational invariant of threefolds
  and reproves Clemens--Griffiths; closed form for index-two Picard-rank-one Fano threefolds
  `delta = 4(N - 4a)/N` with `a` lines through a point, `N = a + b + c`. Test the rational
  `V_12, V_16, V_18` and the marked `V_2`, GM.
- No actual blowup QDM has ever been computed as a provider test; `Bl_l(cubic)` and a
  genus-three sextic blowup of `P^3` are the cheap instances.

## Appendices: referee reports (verbatim)


---

### Appendix A-formal

# Referee report A — local formal algebra of §4 (cubic-stabilization-epilogue)

Target: `papers/cubic-stabilization-epilogue/sections/04-categorical-one-step.tex`
(read in full) and `sections/01-introduction.tex` ll. 1–60.
Lens: §4.1 block definition, §4.3 rank-two residue marker, §4.4 cubic block, §4.5 center nullity.

Everything I could reduce to an explicit computation, I recomputed. Scripts:

* `cubic_block.py` — Beauville matrix, `C`, Sylvester block gauge to order `z^3`, `D_0`, `E_0`, `R_X`, `δ♯`.
* `exponents_direct.py` — Frobenius/indicial computation of the nilpotent-branch exponents
  directly from `K_X`, `G_X`, using no block gauge at all (independent of `Prop cubic-block-data`).
* `variants.py` — sensitivity of `δ♯` to the grading sign and to rescaling of the Euler matrix.

Summary verdict: **I found no arithmetic error and no false mathematical statement in the
displayed formulas of §4.3–§4.5.** Every number in §4.4 is right, and I confirmed the exponents by a
second, independent route. What I did find are (i) one *stated* justification in §4.2 that is
false as written and that is load-bearing for the ledger theorem's hypothesis, (ii) one flat
mismatch between the block *type* declared in §4.1 and the properties the cited comparison theorems
actually have, and (iii) three genuinely load-bearing steps asserted without proof, one of which
(ledger additivity over a direct sum) is the linchpin of both operation formulas and is nowhere
stated as a requirement, let alone proved.

---

## Part 0 — what verified clean (so the referee's fire can be aimed elsewhere)

**§4.4 Beauville data and the cubic block.** All of it.

* `P⋆P = P²+6q`, `P⋆P² = P³+15qP`, `P⋆P³ = 6qP²+36q²` (eq. `beauville-cubic-products`) and hence
  `K_X` in eq. `cubic-small-even-connection`: I re-derived these three products *independently* of
  the enumerative constants 15 and 36. Frobenius self-adjointness of `P⋆` for the Poincaré pairing
  (`(P^i,P^j)=3δ_{i+j,3}`) forces the coefficient of `qP²` in `P⋆P³` to equal the 6 in `P⋆P`;
  Beauville's complete-intersection relation `h^{⋆(n+1)} = (∏ d_i^{d_i}) q h^{⋆(Σd_i − r)}`, which
  for `(n,r,d)=(3,1,3)` reads `P^{⋆4}=27qP^{⋆2}`, then forces `α=15` and `γ=36` uniquely. So the
  only enumerative input actually needed is "6 lines through a general point", and the rest is
  determined. (I also checked `P^{⋆4}=27qP^{⋆2}` holds identically for the stated matrix.)
* char poly of `K_X` is `T²(T²−108q)`; `rank K_X = 3` (column 4 = `6q·`column 2), so the zero
  eigenvalue has geometric multiplicity 1 — one Jordan block of size 2, minimal = characteristic.
  Both claims of `Prop cubic-block-data` confirmed.
* `det C = −486 r⁵` and `C^{-1}K_X C = diag(6r, −6r, J_0)` with `J_0 = [[0,2],[0,0]]`: confirmed.
* Block-diagonalising gauge `A(z)=I+Σ A_n z^n`, `A_n` block-off-diagonal, with
  `Â K A_n − A_n Â K = B_n + M_n` solved blockwise: gives exactly
  `D_0 = diag(−19/18, 19/18)` and `E_0 = [[0, −14/(81r²)], [−8/81, 0]]`. Confirmed.
* `R_X = [[−19/18, 2], [−8/81, 1/18]]`, char poly `(T+1/6)(T+5/6)`, `δ♯ = 4/9`. Confirmed
  (`tr R = −1`, `det R = 5/36`, `δ = 1 − 20/36 = 4/9`).
* **Independent confirmation of the exponents.** Substituting `S = z^ρ Σ v_n z^n` into
  `z∂_z S = (z^{-1}K_X + G_X)S` directly: `v_0 ∈ ker K_X = ⟨(0,−2r²,0,1)⟩`, the left null vector is
  `w = (−1/(2r²),0,1,0)`, and *both* first-order solvability conditions `w·v_0` and `w(ρ−G)v_0`
  vanish identically (this is precisely the size-2 Jordan block showing up), so the indicial
  equation only appears at the next order and equals `(6ρ+1)(6ρ+5)/16`. Roots `−1/6, −5/6`,
  difference `2/3`, `δ♯ = 4/9`. This uses none of the Sylvester machinery of
  `Prop cubic-block-data`, so `eq:RX` and `eq:cubic-delta` are independently correct.

**§4.3 local algebra.** I redid every computation in `Lemma A0preserve` and
`Prop rank2-rigidity` and they are all correct:

* Pairing horizontality `z∂_z P + A(−z)^T P + P A(z) = 0` follows from constancy of
  `y_1(−z)^T P(z) y_2(z)`. The paper writes the transpose of this; harmless because `P_0` is the
  Poincaré pairing on even cohomology of an odd-dimensional variety, hence symmetric.
  `z^{-1}` coefficient gives `N^T P_0 = P_0 N`; `L = im N` is then isotropic
  (`(Nu,Nv) = u^T P_0 N² v = 0`); `z^0` coefficient is exactly the displayed
  `A_0^T P_0 + P_0 A_0 + N^T P_1 − P_1 N = 0`; evaluating at `x ∈ ker N` kills both `N`-terms and
  gives `(A_0x,x) = 0`, so `A_0 x ∈ L^⊥ = L`. Correct.
* Block orthogonality: the off-diagonal-block equation is
  `(u_j − u_i)P_0^{(ij)} = N_i^T P_0^{(ij)} − P_0^{(ij)} N_j`, i.e. (scalar + nilpotent) applied to
  `P_0^{(ij)}`, invertible when `u_i ≠ u_j`; induction upward in `z` kills all `P_n^{(ij)}`.
  Correct. (The cleaner reason nondegeneracy holds on each block is that `U = E⋆` is `P_0`-self-adjoint
  by the Frobenius property, so generalized eigenspaces are `P_0`-orthogonal and `P_0` restricts
  nondegenerately. The paper does not say this; see Finding 6.)
* Flatness. With `∇_{z∂_z} = z∂_z − A`, `∇_∂ = ∂ − C`, flatness is `∂A = z∂_z C − [A,C]`.
  `z^{-2}`: `[N, C_∂] = 0`. `z^{-1}`: `∂N = −C_∂ − [N,C_{∂,0}] + [C_∂, A_0]`, which with
  `C_∂ = q_∂ N` is *exactly* the displayed `∂N = −q_∂ N + [N, q_∂A_0 − C_{∂,0}]`. Correct.
* Modified base pole. `C^♯ = S^{-1}CS` (no `∂S` term, `S` depends only on `z`), so the only pole is
  `z^{-1}k E_21` with `k = (C_{∂,0})_{21}`. With `R = [[a,ν],[c,d]]`,
  `[R, kE_21] = k[[ν,0],[d−a,−ν]]`, so `kE_21 + [R,kE_21]` has diagonal `(kν, −kν)`; `ν ≠ 0` gives
  `k = 0`. Correct. Then the `z^0` flatness coefficient is `∂R = [C_0^♯, R]`, Lax. Correct.
* Modification bookkeeping. `E^♯` has frame `(e_1, z e_2)`, `S = diag(1,z)`,
  `S^{-1}z∂_z S = diag(0,1)`, `(S^{-1}AS)_{21} = z^{-1}A_{21}(z)`, so the only possible new pole is
  `(A_0)_{21}` and `R_{21} = (A_1)_{21}`, `R_{12} = ν`, `R_{22} = (A_0)_{22} − 1`. Exactly as used
  in `eq:RX`. Correct.
* **Cross-check of `Lemma A0preserve` on the cubic:** the lemma predicts `(D_0)_{21} = 0`. The
  symbolic Sylvester computation returns `D_0` diagonal, so `(D_0)_{21} = 0` on the nose. The lemma
  is doing real work and is confirmed on the one case where both sides are computable.

**§4.5 center nullity.** All four cases check out, and the grading convention is consistent with §4.4.

* Convention: `G = −μ = (dim − deg)/2`. `G_X = ½diag(3,1,−1,−3)` is `−μ` for a threefold, and
  `diag(1/2,−1/2)` is `−μ` for a curve. Same convention, as required.
* Curve, `g ≥ 2`: `E = c_1 + t^0·1 = (2−2g)p + t^0`, so centered `N = aE_21`, `A_0 = diag(1/2,−1/2)`,
  and `A_1 = 0` exactly (the even quantum product of a curve of genus ≥ 1 is the cup product for
  *every* even bulk point, since `\bar M_{0,n}(C,d) = ∅` for `d>0`). `L = ⟨e_2⟩`, `S = diag(z,1)`,
  `R = aE_21 − ½I`, `δ♯ = 1 − 4·(1/4) = 0`. Correct, and correct at every bulk point, not just
  generically.
* `K_S` nef: the dimension-axiom identity `deg(α⋆β) = a + b − 2c_1·d + Σ(e_ν − 2)` is right (I
  re-derived it from `vdim = dim S + c_1·d + n − 3`). `K_S` nef ⇒ `c_1·d ≤ 0`; nonunit even bulk
  classes have `e_ν ≥ 2`; the non-scalar part of the Euler field consists of `c_1` (degree 2) and
  `H^4`-bulk classes (degree 4, coefficient `1 − 2 = −1`), while `H^2`-bulk classes have Euler
  coefficient `1 − 1 = 0` and the `H^0` term is the scalar `t^0·I`. So the centered Euler operator
  raises cohomological degree by ≥ 2 and its cube is 0 on `H^0⊕H^2⊕H^4`: nilpotent, hence one block
  of rank `b_0+b_2+b_4 = 2 + b_2 ≥ 3`. The two worries in the brief are both answered: the `t_0`
  term is the scalar that is centered away, and the degree-2 bulk directions do not enter `E` at
  all. Nilpotency is a statement about the output *class*, so it also survives Novikov
  specialization, i.e. it holds at every bulk point, not just the generic one.
* `P^2`: `H^{⋆3}=Q` gives three distinct eigenvalues of `3H⋆` for `Q≠0`; the specialized Novikov
  monomial is never zero (it is `Q^{i_*d}q^{...}`), so semisimplicity survives. Correct.
* Ruled and nonminimal: the Enriques–Kodaira/Mori statement used ("a minimal surface with `K` not
  nef is `P^2` or a `P^1`-bundle over a curve") is correct, and the two reductions are legitimate
  uses of `eq:marker-pbundle` and `eq:marker-blowup`.
* Robustness note worth recording: the curve case is the *exact* borderline. `δ♯(C_g) = 0` because
  the two `μ`-eigenvalues `∓1/2` differ by exactly 1, cancelling the modification shift, *and*
  because `A_1 = 0`. With the opposite grading sign (`G = +μ`) one gets `R = aE_21 + diag(−3/2,1/2)`
  and `δ♯ = 4 ≠ 0`, and center nullity fails outright. It is therefore essential — and true — that
  §4.4 and §4.5 use the same sign; I checked they do. (For the cubic, `δ♯` is nonzero under both
  sign conventions, `4/9` vs `80/9`, and is invariant under rescaling `K_X → cK_X`, as it must be
  since that is a rescaling of `z`.)

**The projective endpoint.** `I_at(P^4)=0` is right (five distinct eigenvalues of `5H⋆`,
semisimplicity is open and holds at the small point). And `I_at(X×P^1)=2` can be confirmed
*without* Iritani–Koto: by Behrend's product formula `QH(X×P^1) = QH(X)⊗QH(P^1)`, and the two
idempotents `e_± = ½(1 ± p/√Q_2)` of `QH(P^1)` split `E⋆` into `c_1(X)⋆ ± 2√Q_2`. Each copy carries
one rank-2 nilpotent block with `δ♯ = 4/9` (the shift `±2√Q_2` is scalar and is centered away), and
the two copies' Euler spectra `{0,0,±6r} ± 2√Q_2` are disjoint because `Q_2` and `q` are independent
Novikov variables. This is a genuinely independent confirmation of `eq:atomic-product-value`.

**Answer to brief item 3 (Iritani's gauge).** The paper's assertion in §4.2 that the comparison
inverses use no negative powers of `z` is **correct and supported by the sources**, and I checked
the sources directly rather than the paper's paraphrase:

* Iritani, *Quantum cohomology of blowups* (arXiv:2307.13555v3), Thm 5.18: `Ψ` is an isomorphism
  **of `C[z]((q^{-1/s}))[[Q,τ̃]]`-modules**, (1) commutes with the quantum connection (which in
  §1 includes `∇_{z∂_z} = z∂_z − z^{-1}(E⋆) + μ`), (2) **intertwines the pairings**
  `P_X̃ ↔ P_X ⊕ P_Z^{⊕(r−1)}`. Remark 1.5 says the base ring is `C[q^{±1/s}][[Q,τ̃]][[z]]`, i.e.
  formal power series in `z`. Since `Ψ` is a module isomorphism over that ring, `Ψ^{-1}` is too,
  hence `Ψ(0)` is invertible and the `C[z]`-lattice — and therefore `N`, `L`, `E^♯` and the
  conjugacy class of `R` — is preserved. The theorem has no hypotheses beyond `Z ⊂ X` smooth of
  codimension `r ≥ 2`, so it does cover every weak-factorization step.
* Iritani–Koto (arXiv:2307.03696v4) Remark 5.3 makes the same point explicitly: the homogeneous
  completion is contained in `C[q^{-1/r'},q^{1/r'}][[z]]`. Their Thm 5.1 lists the pulled-back
  connection on the `j`-th summand as `ς_j^*∇_{z∂_z} = z∂_z − z^{-1}(E_B ⋆_{ς_j(τ̂)}) + μ_B`, i.e.
  literally `QDM(B)` at a shifted bulk point, and (2) intertwines the pairings. Their standing
  hypothesis is that `V^∨` is globally generated, and Remark 1.2 says this can always be arranged by
  a twist without changing `P(V)` — the paper's parenthetical is accurate. For `V = O^{⊕2}` no twist
  is needed anyway.
* The one thing that is *not* preserved is the `Z`-grading (see Finding 2), but `δ♯` is invariant
  under a common scalar shift `R → R + cI` (`tr²−4det` is), so even a constant grading shift is
  harmless for this particular marker.

**Answer to brief item 2 (does the marker need the pairing?).** Yes. Nothing else forces
`(A_0)_{21} = 0`, and without it `A^♯` has a pole and `R` does not exist. In particular the
rigidity commutant argument does not substitute for it: `A_0` is `−μ` plus gauge corrections, not a
quantum multiplication, so the "`C_∂ = q_∂N`" mechanism says nothing about it. The pairing on a
block *is* nondegenerate at `z = 0`.

---

## Findings, ranked

### Finding 1 (definite error in a load-bearing justification; repairable)
**§4.2, first adapter: "Rank, primary factors, nilpotence, regular formal gauges, and conjugacy
invariants are unchanged after either field extension." This is false for rank and primary
factors, and as a consequence `w_at` as defined in §4.1 is *not* a marker fold in the sense
required by Theorem `thm:marker-ledger`.**

§4.1 defines the blocks only as the primary components of Euler multiplication "after an algebraic
extension". A primary decomposition exists over *any* field, and it refines under extension.
Explicit counterexample, purely linear-algebraic and therefore fatal to the sentence as written:
let `F = C(q)` and let `E⋆` on a rank-4 block be the companion matrix of `(T²−q)²`. Over `F` the
polynomial `T²−q` is irreducible, so the module is primary: **one block of rank 4**, marker 0. Over
`F' = F(√q)` we get `(T−√q)²(T+√q)²`: **two blocks of rank 2**, each with minimal polynomial
`(T∓√q)²`, hence centered `N ≠ 0` with `N² = 0`; choose the block's `A_1` so that
`δ♯ = ((A_0)_{11}−(A_0)_{22}+1)² + 4ν(A_1)_{21} ≠ 0` and the marker jumps from 0 to 2.

This matters because the comparison theorems *force* exactly this kind of extension: Iritani's `Ψ`
lives over `C[z]((q^{-1/s}))[[Q,τ̃]]`, and the cubic's own block ledger is computed only after
adjoining `r = (3q)^{1/2}`. So the hypothesis of `thm:marker-ledger` ("a marker fold unchanged by
the allowed regular scalar extensions") is asserted, not established, and the supporting sentence
in §4.2 is wrong.

*Likelihood the conclusion is actually false:* low. The repair is to fix the convention that the
ledger is always taken over an algebraic closure (or a splitting field) of the generic coefficient
field. Then the ledger *is* extension-stable: eigenvalues and their multiplicities come from the
characteristic polynomial, the Jordan data from ranks of `(E⋆ − u)^k`, and `δ♯` from a field
element, all stable under further extension. Note the paper's own two computations are already
consistent with this convention (`I_at(X) = 1` and `I_at(P^4) = 0` come out the same over `C(q)`
and over its closure). But the general lawfulness claim needs the convention stated and the
stability proved, and the §4.2 sentence must be deleted or corrected.

### Finding 2 (definite mismatch between the declared block type and the cited theorems)
**§4.1 declares that a block "retains its connection, grading, pairing, and Euler endomorphism" and
that "its morphisms preserve all the typed data". Iritani Thm 5.18(3) and Iritani–Koto Thm 5.1(3)
say the comparison maps are homogeneous of degree `−r` (center part) and `−(r−1)` respectively —
they shift the grading. So the maps supplied by `Prop qdm-operation-ledgers` are not morphisms of
`Π_{T_at}` as §4.1 defines it.**

This is not a small point: the *entire* content of `Prop qdm-operation-ledgers` is that the cited
isomorphisms are morphisms of the declared type. With grading in the type, they are not.

*Likelihood of damage:* low, because `w_at` never reads the grading and because the connections
`∇_{z∂_z}` are genuinely intertwined (property (1) of both theorems), so `R` is conjugated and `δ♯`
survives; and `δ♯` is even invariant under a scalar shift `R → R+cI` should the shift materialize
as one. The repair is to drop the grading from `T_at` (the framed type of §5 may need a different
treatment), or to define the type's grading up to a constant shift. As written the hypothesis is
simply not met.

### Finding 3 (load-bearing, never stated, needed at every weak-factorization step)
**Ledger additivity over a direct sum is only valid when the summands have pairwise disjoint Euler
spectra. This requirement is nowhere stated and nowhere proved; it is only gestured at ("separated
leading branches", "separates their unit coordinates").**

The block ledger is defined by the primary decomposition of `E⋆` on the *whole* even QDM. If two of
the summands `M_a` in `QDM(Ỹ) ≅ ⊕_a M_a` share an Euler eigenvalue `u`, the primary component at
`u` of the total is the *direct sum* of the two summands' `u`-components, and the ledger of the
total is strictly coarser than `Σ_a B(M_a)`. Concretely: two rank-2 marked blocks with the same
eigenvalue merge into a rank-4 block, and the marker drops from 2 to 0. So neither
`eq:marker-pbundle` nor `eq:marker-blowup` follows from the comparison theorems alone.

What is missing is a lemma of the form: *if `E⋆` has pairwise disjoint spectra on the summands,
then `B(⊕M_a) = Σ B(M_a)`*, together with a proof that the disjointness holds. The disjointness is
provable — Iritani 5.18(6) gives unit-direction shifts `−(r−1)λ_j` with
`λ_j = e^{−2πi(j+r/2)/(r−1)} q^{1/(r−1)}` pairwise distinct and distinct from the ambient
summand's `τ|_{Q=τ̃=0} = q^{-1}[Z] + O(q^{-2})` (whose `H^0` component vanishes to this order), and
5.18(7)/IK 5.1(5) give an invertible combined bulk Jacobian, so the unit coordinates of the
summands are independent formal coordinates and shifting one moves that summand's whole spectrum;
hence generic disjointness on an irreducible formal germ. But this argument is not in the paper,
and it is used at every single step of the weak factorization, for arbitrary `Y` and `Z`.

Sanity check that it does hold in the one place the paper's conclusion depends on it numerically:
for `X×P^1` the two copies' spectra are `{0,0,±6r} ± 2√Q_2`, disjoint since `Q_2` and `q` are
independent. Good — but that is my check, not the paper's.

### Finding 4 (load-bearing, asserted without proof: small point → generic point)
**`Prop cubic-block-data` computes at the small point `τ = 0`; the ledger `B(X)` is defined at the
generic point of the even bulk. The paper never bridges the two, and `Prop rank2-rigidity` only
asserts the key step: "Thus formal bulk transport preserves the nonzero square-zero orbit and its
image line." Also, "generic point of the even bulk" is never defined.**

What is needed, and what the paper does not supply: (a) over `C[[τ]]`, Hensel lifts the factors
`T ∓ 6r` and `T²` of the characteristic polynomial of `K_X`, so the rank-2 summand exists on the
formal germ and specializes at `τ = 0` to the generalized 0-eigenspace; (b) the centered `N(τ)` must
be shown to stay *nonzero and square-zero* on the germ, since otherwise the "block" ceases to be a
rank-2 nilpotent block at the generic point and `I_at(X)` would be 0, not 1.

Step (b) is true and follows from the paper's own ODE, but the paper does not do the integration.
For traceless `2×2` `N`, `det N = −½tr(N²)` and
`∂ tr(N²) = 2 tr(N ∂N) = 2 tr(N(−q_∂N + [N,W])) = −2q_∂ tr(N²)`, because `tr(N[N,W]) = 0`. This is
a linear homogeneous ODE, so `tr(N²)(0) = 0` forces `tr(N²) ≡ 0` on the germ: `N` stays nilpotent.
Likewise `∂N = −q_∂N + [N,W]` is linear in `N`, so `N(0) ≠ 0` forces `N ≢ 0`. (The argument needs
`q_∂` regular on the germ, which follows because `N ≠ 0` near `τ=0`.) Two or three lines, but they
are the lines that make the entire §4.4 computation relevant to the ledger, and they are missing.

*Likelihood of being false:* very low, given the above. But as the manuscript stands, the step from
`eq:cubic-delta` to `I_at(X) = 1` at the generic even point is unjustified.

### Finding 5 (definitional gap in §4.1: the blocks are not yet connection summands)
**§4.1 produces blocks by primary decomposition of Euler multiplication only. That does not produce
connection summands. The formal `z`-splitting — the Sylvester/Hukuhara block-diagonalisation that
is actually carried out ad hoc inside the proof of `Prop cubic-block-data` — is missing from the
definition, as is the compatibility of the base connection with it.**

Three things are being conflated: the idempotents of `E⋆` (not flat), the formal decomposition of
the irregular connection at `z=0` by distinct leading eigenvalues (canonical, and what one actually
wants), and the compatibility of `∇_{∂_i}` with that decomposition. The last follows from
uniqueness of the formal decomposition, and the resulting block is well-defined up to a
block-diagonal regular gauge — which is harmless for `δ♯`, since such a gauge conjugates `R`. But
none of this is said. A reader cannot tell from §4.1 what object `E` in eq. `atomic-block-expansion`
is, and in particular cannot tell that it carries a `C[[z]]`-lattice, which is exactly what `E^♯`
and hence `δ♯` depend on.

Related and also unstated: §4.2's "parity adapter" ("Homogeneity ... preserves parity after odd
variables are set to zero"). This one is true and has a one-line proof — `ς_j` is homogeneous of
degree 2, all of `Q^d`, `q^{1/s}`, `z` and the even bulk coordinates have even degree, so a term of
`ς_j` along an odd class of `H^*(Z)` would need an odd-degree coefficient and must vanish — but the
paper asserts it, and it is load-bearing precisely for the main application (`X` has `b_3 = 10`, so
if `ς_j` could turn on odd directions of `X` the summands of `QDM(X×P^1)` would not be the even
generic QDM of `X`).

### Finding 6 (minor unproved steps inside §4.3, all true)
* `Prop rank2-rigidity`, "here the base equation has been scalar-centered". `tr C_∂ = 0` is *not*
  automatic; it needs a simultaneous scalar centering of the `z∂_z` and base equations, i.e. that
  `½tr(φ_i⋆|_block)` is `∂_i` of `½tr(E⋆|_block)`. That is true and follows from the trace of the
  same `z^{-1}` flatness coefficient in the *uncentered* equation (`∂ tr U = −tr V`), but the
  paper only parenthesises it. Without it one cannot pass from `[N,C_∂]=0` to `C_∂ = q_∂N`.
* `Lemma A0preserve` uses symmetry of `P_0` when it evaluates on `(x,x)`: the constant coefficient
  only gives `(A_0x,x) + (x,A_0x) = 0`. True for the Poincaré pairing on even cohomology; unstated.
* The lemma's route to nondegeneracy (Sylvester) is correct but the structural reason is that `E⋆`
  is `P_0`-self-adjoint (Frobenius), which is not mentioned and is the cleaner citation.
* `Prop residue-discriminant-exponents` is fine as stated: `S = diag(1,z)` uses integral powers so
  exponent classes mod `Z` are preserved, and residue eigenvalues of *any* lattice give the
  exponents mod `Z`. Note the proposition is essentially decorative — `δ♯` is defined directly by
  eq. `res-disc` — so the brief's worry that "`δ♯` uses exact eigenvalues, which depend on the
  lattice" is answered by canonicity of `E^♯` given `E`, plus the lattice-preservation established
  in Part 0 above, not by this proposition. Incidentally, for the cubic the modification happens
  not to shift the exponents at all: the unmodified block's indicial equation is also
  `ρ² + ρ + 5/36 = 0`.

---

## What I did not find

* No error in `eq:beauville-cubic-products`, `eq:cubic-small-even-connection`, the matrix `C`,
  `eq:cubic-shared-block-data`, `eq:RX`, or `eq:cubic-delta`.
* No error in `Lemma A0preserve` or in any displayed computation of `Prop rank2-rigidity`.
* No error in any of the four center-nullity cases, and no missing case in the surface
  classification.
* No counterexample to the birational invariance in dimension 3: center nullity in dimension ≤ 1 is
  established, so `I_at` would already be a birational invariant of threefolds, giving
  `I_at(X)=1 ≠ 0 = I_at(P^3)` and recovering Clemens–Griffiths. I looked for a rational threefold
  with a marked block and found none — the obvious candidates (`Bl_C P^3` for `C` of genus `g ≥ 2`,
  `P^1×S`, quadric threefold, `P^3`) all give 0, consistently. The machinery is not obviously broken.

## Priority for the authors

1. Fix the field convention (Finding 1) and delete/repair the §4.2 sentence about primary factors.
2. State and prove the disjoint-spectra additivity lemma (Finding 3) — this is the one that is
   invoked silently at every step of the weak factorization.
3. Add the `tr(N²)` ODE integration and the small-point specialization (Finding 4).
4. Reconcile the block type with the degree shifts in Thm 5.18(3) / Thm 5.1(3) (Finding 2).
5. Rewrite the §4.1 definition to include the formal `z`-splitting and the lattice (Finding 5).

---

### Appendix B-sources

# Referee report B — source verification of §4 of `cubic-stabilization-epilogue`

Target: `papers/cubic-stabilization-epilogue/sections/04-categorical-one-step.tex`
(read in full, lines 1–533). Sources checked line-by-line:

- Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555 —
  `/tmp/persistent/tavis/lit-search/text/arXiv_2307.13555.txt`
- Iritani–Koto, *Quantum cohomology of projective bundles*, arXiv:2307.03696 —
  `/tmp/persistent/tavis/lit-search/text/arXiv_2307.03696.txt`

All line numbers below refer to those two extraction files.

Style issues are excluded per instructions. Findings are ranked by severity.
Each is either **(E)** a definite error with the contradicting source line, or
**(G)** a load-bearing step asserted without proof, with my probability that the
step is actually false.

---

## Summary verdict

I could not break the theorem. The one hostile falsification test that the
argument invites and that is cheap enough to run — a **rational** threefold whose
even quantum connection has exactly the same block shape as the cubic — is
`X_{2,2} ⊂ P^5`, and the marker there is **0**, so the theorem survives it
(§9 below). The cubic's own numbers `δ♯ = 4/9`, `R_X`, `D_0`, `E_0` reproduce
exactly from an independent recomputation.

What I did find is that **§4.2 "The QDM operation providers" is three sentences
of assertion doing the work of three lemmas**, and two of those assertions are
cited to source items that do not state them. Every one of the gaps below looks
repairable from material that is present in the sources, but none of the repairs
is in the paper. Prop. `qdm-operation-ledgers` as written does not follow from
its stated inputs.

---

## 1. (G) **PARITY.** The whole theorem rests on one unproved sentence, and it is
## not in the cited source.

Paper, lines 140–142:

> Homogeneity and the explicit pull-push and Fourier formulas preserve parity
> after odd variables are set to zero. The combined bulk Jacobians are
> invertible, hence so are their even-even blocks.

**Source fact.** The word "parity" occurs in arXiv:2307.13555 at lines 678, 684,
686, 688, 690 — **and nowhere else in the paper**. All five occurrences are
inside the §2.2 conventions paragraph that merely declares the ambient rings to
be `Z × (Z/2Z)`-graded and supercommutative. There is **no statement anywhere in
Iritani that Ψ, τ(τ̃) or ς_j(τ̃) are equivariant for the involution acting by −1
on odd cohomology.** Theorem 5.18 (line 5645ff) is stated for the full
`H^*(X̃)`, `H^*(X)`, `H^*(Z)`; parts (1)–(7) say nothing about parity. The same
is true of Iritani–Koto Theorem 5.1 (line 2338ff).

**Why this is load-bearing and not a technicality.** Restricting the *bulk
parameters* τ̃ to even classes does not restrict the *module*. The paper's marker
for the cubic is computed on `H^even(X)`, rank 4, in the basis `(1,P,P²,P³)`
(eq. `cubic-small-even-connection`). On the full `H^*(X)` the computation gives
the opposite answer: for a cubic threefold `H^1 = H^5 = 0` and `h^3 = 10`, so for
`α ∈ H^3` the small quantum product `P ⋆ α` lands in `H^5 ⊕ q·H^1 = 0`, i.e.
`E ⋆_0` annihilates all of `H^3`. The 0-eigenvalue primary block of `E ⋆_0` on
the full `H^*(X)` therefore has rank `10 + 2 = 12`, not 2, and `w_at` (which
fires only at rank exactly 2) returns **0**, killing `I_at(X) = 1` and with it
the contradiction. So the parity restriction of the *module* is precisely what
makes the theorem nonzero, and it is exactly what Theorem 5.18 does not give.

**The repair exists in the source but is not in the paper.** Iritani §5.8.1
(lines 5720–5760) writes the initial conditions explicitly: eq. (5.44)–(5.45)
express `τ°`, `ς_j°` and `Ψ|_{Q=τ̃=0}` purely through `ı_*`, `i_Z^*`, `κ_X`,
`F_{Z,j}` and Chern classes of `N_{Z/X}` — all manifestly parity-even
operations, with `τ° ∈ H^even(X)`, `ς_j° = −(r−1)λ_j + h_{Z,j} + …`,
`h_{Z,j} = (2πi/(r−1))(j+1/2)ρ_Z ∈ H^2(Z)` (eq. (5.19), line 4306). Iritani then
proves at lines 5978–5990 that `Ψ⁻¹` and `M′` are **uniquely** determined from
these initial conditions by a Birkhoff factorization. Since genus-zero GW
invariants vanish on an odd number of odd insertions, the whole reconstruction
commutes with the parity involution, so parity equivariance follows from
*uniqueness applied to parity-even initial data*. That is a three-line argument.
The paper gives none of it and cites none of it.

**Second, separate defect in the same sentence (E).** "The combined bulk
Jacobians are invertible, hence so are their even-even blocks" is a
**non-sequitur**: invertibility of a matrix does not imply invertibility of a
principal diagonal sub-block. The inference is valid only if the Jacobian is
already block-diagonal for the parity splitting — i.e. only if the parity claim
it is supposedly a consequence of has already been established. As written the
sentence is circular.

The even-even invertibility is in fact directly readable off eq. (5.35)
(line 5340) without the parity claim, by a `q`-adic leading-term argument:
`∂τ/∂τ̃^α|_{Q=τ̃=0} = ϕ_{X,i} + O(q⁻¹)` for `c_α = c_i` and `O(q⁻¹)` for
`c_α = c_{l,m}`; `∂ς_j/∂τ̃^α|_{Q=τ̃=0} = ı*ϕ_{X,i} + O(q^{−1/(r−1)})` resp.
`(−1)^l λ_j^{l+1}(ϕ_{Z,m} + O(q^{−1/(r−1)}))`. Restricted to the even τ̃-directions
the leading matrix is the same identity-plus-Vandermonde-in-λ_j shape, hence
invertible over the `q`-adically complete ring. The paper should cite (5.35) here
and does not.

**Probability the parity claim is actually false: ~7%.** (Iritani's §2.2 remark
that `√x` has odd degree but even parity, line 688, is there precisely so that
Ψ's degree shift of `−r` — part (3) — does not force a parity shift when `r` is
odd; `q_{Z,j}` is such a square root. So the framework is built to be
parity-consistent.) **Probability the paper as written proves it: 0.**

---

## 2. (G) **EULER-EIGENVALUE SEPARATION.** Asserted, cited to three parts of
## Theorem 5.18 that do not state it; the statement that does is Remark 5.21,
## and even that only gives the degenerate limit.

Paper, lines 189–191:

> Parts (4), (6), and (7) give separated leading branches and an invertible
> combined bulk Jacobian.

**What the argument needs.** §4.1 defines the blocks as the *primary
decomposition of Euler multiplication over the generic coefficient field*
(lines 13–17). Additivity of the ledger across Ψ therefore requires that the
primary decomposition of `E_{X̃} ⋆` be the disjoint union of those of
`E_X ⋆_{τ(τ̃)}` and the `r−1` copies `E_Z ⋆_{ς_j(τ̃)}` — i.e. that no eigenvalue
of the ambient copy coincides with one of a center copy, and no two center copies
share one, **at the generic bulk point**. If any pair collided, the merged
primary block would have rank > 2 and `w_at` would return 0 instead of the sum.
This is not a side condition; it is what makes the ledger additive.

**What the cited parts say.** Part (4) (line 5665) is the asymptotics of Ψ;
part (6) (line 5680) is `τ|_{Q=τ̃=0} = q⁻¹[Z] + O(q⁻²)` and
`ς_j|_{Q=τ̃=0} = −(r−1)λ_j + h_{Z,j} + O(q^{−1/(r−1)})`; part (7) (line 5683) is
the Jacobian (5.35). None of the three is a statement about Euler eigenvalues.

**What does state it: Remark 5.21, lines 5729–5736**, verbatim:

> the eigenvalues of `E_X ⋆_{τ(τ̃)}` are all zero and those of `E_Z ⋆_{ς_j(τ̃)}`
> are all `−(r−1)λ_j` along this locus

— "this locus" being `Q = τ̃ = 0`, and the accompanying Figure 5 caption
(line 6050) adds "Here we assume the convergence of quantum cohomology and the
maps τ(τ̃), ς_j(τ̃)". So the source gives separation **only at the origin of the
formal neighbourhood**, exactly where the marker is *not* evaluated.

**The repair is short and absent.** Separation at the generic point follows from
separation at `Q = τ̃ = 0` by a resultant argument: the resultant of the two
characteristic polynomials is an element of the coefficient ring that is nonzero
at the origin (by Remark 5.21, since `λ_j = e^{−2πi(j+r/2)/(r−1)} q^{1/(r−1)}` are
pairwise distinct and nonzero), hence a nonzero element of the ring, hence
nonzero in its fraction field. Two sentences. Not present.

**IK side: nothing at all is cited.** The paper's projective-bundle sentence
(lines 180–181) is "Its invertible bulk Jacobian separates their unit
coordinates." The Jacobian (IK Thm 5.1(5), line 2360) is not what separates the
unit coordinates; IK Thm 5.1(4) (line 2358),
`ς_j(τ̂)|_{Q=τ̂=0} = rλ_j − (2πij/r)c_1(V) + O(q^{−1/r})` with
`λ_j = e^{2πij/r}q^{1/r}`, is. For the actual application `X × P^1 = P(O^{⊕2})`
this gives `r = 2`, `c_1(V) = 0`, `ς_0° = 2q^{1/2}`, `ς_1° = −2q^{1/2}`, so the
two copies' Euler spectra are `{±2q^{1/2}}` and separation holds — but the paper
cites the wrong item and runs no argument.

**Probability the separation claim is actually false: ~3%.** **Probability the
paper as written establishes it: 0.**

---

## 3. (E) **The block type retains the grading, but Ψ does not preserve it.**

Paper, lines 17–22 and 214–215: the type `T_at` "retains the connection,
grading, pairing, and Euler endomorphism", and "Its morphisms preserve all the
typed data".

**Contradicting source lines.** Iritani Theorem 5.18(3), lines 5661–5664:

> the first component of Ψ … is homogeneous of degree zero and the second
> (mapping to `⊕ ς_j^* QDM(Z)^{la}`) is homogeneous of **degree −r**

IK Theorem 5.1(3), line 2352: "`Φ` is homogeneous of degree `−(r−1)`".

So Ψ and Φ are **not** grading-preserving on the center/fibre copies. Under the
paper's own definitions they are therefore not morphisms in `Π_{T_at}`, and the
ledger equalities of Prop. `qdm-operation-ledgers` do not follow from the stated
interface.

**This one is a genuine internal inconsistency, not just a gap.** It is
repairable — the degree shift is harmless for `w_at`, because `∇_{z∂z} =
z∂_z − z⁻¹(E⋆) + µ` is itself homogeneous of degree 0 (`z∂_z` preserves degree,
`z⁻¹(E⋆)` raises by 2 and lowers by 2, `µ` preserves), so a degree-shifted
isomorphism still intertwines `∇_{z∂z}` with no shift of `µ`, and `δ♯` is
computed from `∇_{z∂z}` alone. **This settles attack point 6 in the paper's
favour**: Ψ does intertwine the `z∂_z` direction including `µ` (Thm 5.18(1)
together with (5.42)–(5.43), lines 5590–5610, which list `∇_{z∂z} = z∂_z −
z⁻¹(E_X ⋆_{τ(τ̃)}) + µ_X` and `… + µ_Z` explicitly), and the degree `−r` does not
shift `µ`. But the paper must either drop "grading" from the type or state the
shift tolerance and the reason it is harmless. As written, it does neither.

Severity: definite defect in the stated deduction; probability the underlying
mathematics is false ~2%.

---

## 4. (E) **The "generic spine" adapter is stated falsely.**

Paper, lines 124–129:

> Both receive an injective map from the algebraic coefficient algebra on which
> the finite connection matrix is defined. Its fraction field is a common
> generic spine.

For a general smooth projective fourfold in a weak-factorization zigzag there is
**no algebraic coefficient algebra on which the connection matrix is defined**.
The matrix is finite-*sized* (rank = `dim H^*`), but its entries are genuine
formal power series in the Novikov and bulk variables; for a non-Fano fourfold
(e.g. a blowup of `X × P^1` along a surface) the big quantum product is a power
series in `q_exc` with no polynomial truncation. The sentence is true only in the
two endpoint cases the paper actually computes (the cubic, where Beauville's
formulas are finite, and `P^4`).

**What the argument actually needs, and what the source actually supplies.**
Iritani eq. (1.1), lines 53–61, gives three maps with the injectivity explicitly
marked in the arrow type:

```
C[[Q]]   ↪  C((q^{-1/s}))[[Q]]           (X,  "in an obvious way")
C[[Q̃]]  ↪  C((q^{-1/s}))[[Q]]           (X̃,  Q̃^d̃ ↦ Q^{φ_*d̃} q^{-[D]·d̃})
C[[Q_Z]] →  C((q^{-1/s}))[[Q]]           (Z,   plain arrow — see §5 below)
```

So the ambient and total-space extensions are injective *by hypothesis of the
source*, which is all the marker transfer needs; there is no common algebraic
subalgebra and none is required. The paper's first adapter should be rewritten
as a citation to (1.1) rather than an invented finiteness claim.

**Related omission (G).** The paper never mentions Iritani's graded-completion
convention. Remark 1.3 (line 104) and Remark 1.5 (line 116) say the power series
rings "should be understood in the graded sense", that
`C((q^{−1/(r−1)}))[[Q]] = C[q^{±1/(r−1)}][[Q]]`, and that the Theorem 5.18 base
ring "can also be written as `C[q^{±1/s}][[Q,τ̃]][[z]]` because of our convention
on the graded completion (where `deg q = 2(r−1)`, `deg z = 2`)"; §2.2
(lines 636–676) defines it. Read ungraded, `C[z]((q_exc^{−1/s}))[[Q,τ̃]]` — which
is literally what the paper writes at lines 133–137 — is a strictly larger and
differently behaved ring, and the paper's claim that inverses are regular in `z`
depends on the graded reading (Remark 1.5's rewriting as `…[[z]]`). Add the
convention explicitly. Probability this breaks something: ~5%.

---

## 5. (G) **The faithful character adapter overstates what Iritani's reduced ring
## gives; the `h_{Z,j}` obstruction is real and is stated in the source.**

Paper, lines 144–162, ending:

> Each center summand is a faithful scalar extension and formal
> reparametrization of the intrinsic generic numerical QDM of `Z`.

Two source facts the paper has to live with.

**(a)** Iritani eq. (5.15), line 4249, is introduced as "the (**not necessarily
injective** but degree-preserving) extension of rings". The paper correctly flags
this and repairs it. The finiteness half of the repair is right: fibres of
`d ↦ (ı_*d, ρ_Z·d)` are finite because `ı^*ω` is ample on `Z`, so `ω_Z · d` is
pinned and only finitely many lattice points of `NE(Z)` lie in the slice.

**(b)** But the "scalar extension" language presupposes a ring homomorphism out
of `Z`'s coefficient ring, and Iritani states in terms that this does not exist.
Lines 4318–4322:

> Due to the constant term `h_{Z,j}` in the change of variables `σ = σ_j(θ)`, the
> pullback of functions `σ_j^*: C[z]((q^{−1/s}))[[Q,σ]] → C[z]((q^{−1/s}))[[Q,θ]]`
> **is ill-defined**. However, the pullback of connections is well-defined due to
> the Divisor Equation.

The pullback exists only on the reduced ring `R` of Remark 5.6 (line 4275: "the
image `R` of `C[z][[Q_Z e^σ, σ′]][σ^0]`"). The paper cites Remarks 2.3 and 5.6
(line 159) so it is aware, but the sentence it writes — a *faithful scalar
extension of the intrinsic QDM of Z* — asserts more than those remarks give.
What is true and sufficient is weaker and should be said: the center summand is
the pullback of `QDM(Z)`'s **connection** along the formal submersion `ς_j`,
which is what carries the block ledger.

**(c)** The paper asserts, without pointing at anything, that the divisor part of
`ς_j(τ̃)` sweeps `H^2(Z)`. It does, and the source line is (5.35), line 5343:
`∂ς_j/∂τ̃^{(0,m)}|_{Q=τ̃=0} = −λ_j(ϕ_{Z,m} + O(q^{−1/(r−1)}))`, which for `ϕ_{Z,m}`
running over a basis of `H^2(Z)` is full rank, so the formal inverse function
theorem applies. Once that is said, the paper's Vandermonde-on-derivatives
argument (lines 155–158) is not needed at all: the characters
`e^{⟨ς_j^{(2)}(τ̃),d⟩}` already separate distinct `d ∈ N_1(Z)` because
`H^2(Z) × N_1(Z) → Q` is a perfect pairing. The Vandermonde is a longer route to
the same place and is stated for "a generic one-parameter restriction" whose
existence inside the formal `τ̃`-germ is itself not argued.

**Probability the center adapter's conclusion is false: ~5%.** Probability the
paper's stated version of it is provable as stated (as a scalar extension of the
full ring): **0** — Iritani's line 4318 says otherwise.

---

## 6. (OK, verified) z-regularity, and Ψ⁻¹.

Paper line 139: "Their inverses use no negative powers of `z`". **Confirmed
directly.** Theorem 5.18 (line 5645) states Ψ is an isomorphism *of
`C[z]((q^{−1/s}))[[Q,τ̃]]`-modules*, and the reconstruction argument at
lines 5985–5988 makes it explicit: `Ψ⁻¹` is characterized as the positive
Birkhoff factor, "`Ψ⁻¹` contains no negative powers of `z`". No finding.

The Sylvester block splitting in Prop. `cubic-block-data` (lines 421–430) is
sound over the coefficient field: the three blocks have spectra `{6r}`, `{−6r}`,
`{0,0}`, pairwise disjoint, so `X ↦ K_I X − X K_J` is invertible at every order.
Gauge coefficients acquire denominators in the eigenvalue separations, i.e.
series in `z/q^{1/(r−1)}` in the general case; every such term has total degree 0
(`deg z = 2`, `deg q^{1/(r−1)} = 2`), and the completion is in `z`, so these live
in the graded ring — but this is only visible once finding 4's convention
omission is fixed. No error.

Lemma `A0preserve` and Prop. `rank2-rigidity` I checked line by line against
their own statements; both proofs are correct as given (the `z⁻¹` coefficient
identity `N^T P_0 = P_0 N` does give isotropy of `L = im N = ker N` via
`(Nu)^T P_0 (Nv) = u^T P_0 N^2 v = 0`, and the constant-coefficient identity does
give `(A_0 x, x) = 0`). No finding.

---

## 7. (OK, verified) Miscellaneous hypothesis matching.

- `r′` convention. Paper line 138: "`r′ = r` when `r−1` is even and `r′ = 2r`
  when `r−1` is odd." **Exact match** to IK eq. (5.1), lines 2283–2287.
- Global generation / tensoring. Paper lines 183–186. IK assume `V^∨` globally
  generated (line 54), and Remark 1.2 (line 84) says "By tensoring `V` with a
  sufficiently negative line bundle, we can always assume that `V^∨` is generated
  by global sections, without changing `P(V)`"; Remark 5.2 (line 2370) says the
  Novikov identification (5.2) "is intrinsic to the geometry of the projective
  bundle `P(V) → B` and is independent of the choice of the vector bundle `V` (up
  to tensoring with a line bundle)". **The paper's sentence is exactly
  supported.** (And for `X × P^1 = P(O^{⊕2})` no twist is needed anyway.)
- Base rings. Paper lines 133–137 match Thm 5.18 (line 5645) and IK
  `QDM(P(V))_loc` (line 2291) exactly, modulo finding 4's graded-completion
  omission.
- `Z` connected / `r ≥ 2`. Iritani's standing hypothesis (line 12) is only
  "`Z ⊂ X` a smooth subvariety of codimension `r ≥ 2`" — no connectedness, no
  convergence (Remark 1.5, line 118, and IK Remark 1.9, line 223, both disclaim
  convergence; the results are formal). The paper's "Disconnected centers are
  treated componentwise" is harmless belt-and-braces since AKMW centers are
  irreducible. No finding.
- AKMW. The paper cites Theorem 0.1.1 for *projective* weak factorization. I do
  not have the AKMW text in the cache and could not verify whether projectivity
  of the intermediate `V_i` is inside Theorem 0.1.1 or only in a later statement.
  I note that Theorem 0.1.1's own item on projectivity of `V_i → X_1` and
  `V_i → X_2` as *morphisms* does yield projectivity of the `V_i` when `X_1, X_2`
  are projective, so the citation is probably fine, but **this needs one check
  against the JAMS text.** Flagged, not scored.

---

## 8. (Not a finding, but the referee should be told) The paper proves more than
## it says, which raises the falsification bar.

Theorem `marker-ledger` requires center nullity only in dimension `≤ d−2`.
Prop. `atomic-lowdim` establishes nullity for **all** `Z` of dimension `≤ 2`.
Therefore the same theorem applied with `d = 3` makes `I_at` a birational
invariant of smooth projective **threefolds**, and `I_at(X) = 1 ≠ 0 = I_at(P^3)`
is then a new proof of the irrationality of the cubic threefold
(Clemens–Griffiths). The paper never states this corollary. It should, because a
referee will immediately go looking for a rational threefold with `I_at ≠ 0`.

---

## 9. Falsification attempt — and the paper survives it.

I recomputed the paper's own numbers from scratch (Sylvester block reduction of
`z²∂_z S = (K + zG)S`, elementary modification `S = diag(1,z)`, residue
discriminant), reproducing Prop. `cubic-block-data` and eq. `RX` **exactly**:
`J_0 = [[0,2],[0,0]]`, `D_0 = diag(−19/18, 19/18)`,
`E_0 = [[0, −14/(243q)],[−8/81, 0]]` (the paper writes `−14/(81r²)` with
`r² = 3q`, same thing), `R_X = [[−19/18, 2],[−8/81, 1/18]]`, char. poly
`(T+1/6)(T+5/6)`, `δ♯ = 4/9`.

I then ran the same pipeline on the one rational threefold that has the same
block shape. For an index-2, Picard-rank-1 Fano threefold `V_d` with
`H⋆H = H² + aq`, `H⋆H² = H³ + bqH`, `H⋆H³ = cqH² + eq²`, the Frobenius property
forces `c = a`, and the ambient characteristic polynomial is
`T⁴ − (a+b+c)qT² + (ac−e)q²`. Setting `N := a+b+c`, the marker comes out in
closed form:

> **`δ♯ = 4(N − 4a)/N = 4 − 16a/N`**, and always `tr R = −1`, so the exponents
> satisfy `ρ_1 + ρ_2 = −1`. Equivalently **`δ♯ = 0 ⟺ b = 2a`.**

- **Cubic threefold `V_3`.** `a = 6` (six lines through a general point),
  `b = 15`, `c = 6`, `e = 36`, `N = 27`. `δ♯ = 4·3/27 = 4/9`. Marker 1. The
  entire theorem rests on `15 ≠ 12`.
- **`X_{2,2} ⊂ P^5` (`V_4`) — rational, and `H^3 ≠ 0` (`h^{1,2} = 2`).** Lines
  through a general point: a line `p + sv` lies in both quadrics iff
  `b_1(p,v) = b_2(p,v) = 0` (two linear conditions, cutting `P^4` to `P^2`) and
  `q_1(v) = q_2(v) = 0` (two conics in `P^2`), so `a = 4`; `c = a = 4` by
  Frobenius; the Picard–Fuchs operator `D^6 − q(2D+z)²(2D+2z)²` has symbol
  `H^4(H² − 16q)`, forcing `N = 16` and `ac = e`, hence `b = 8`, `e = 16`. Then
  `R = [[−1, 2],[−1/8, 0]]`, char. poly `(T + 1/2)²`, **`δ♯ = 0`**, marker 0.

So the sharpest cheap test of Theorem `every-cubic` — the only rational complete
intersection threefold with nonvanishing `H^3` — **passes**. The marker vanishes
there because the two exponents collide at `−1/2` rather than splitting as
`−1/6, −5/6`. That is a real and non-obvious consistency check, and the paper
does not contain it. **It should.**

**Remaining falsification targets I could not run** (no quantum-product data to
hand): the rational prime Fano threefolds of genus 7, 9, 10 (`V_{12}`, `V_{16}`,
`V_{18}`), all of which are rational with `H^3 ≠ 0`. If `I_at` is nonzero for any
one of them the theorem is dead, since `V × P^1` would then be a rational
fourfold with `I_at = 2`. A referee should require these three checks before
accepting.

---

## Ranked list

| # | Type | Issue | P(actually false) |
|---|------|-------|---|
| 1 | G + E | Parity equivariance of Ψ, τ, ς_j: asserted in one sentence, absent from both sources ("parity" appears only in Iritani §2.2, lines 678–690); it is what makes `I_at(X) = 1` rather than 0. Plus the circular "hence so are their even-even blocks". | 7% |
| 2 | G | Euler-eigenvalue separation across summands: required for ledger additivity, cited to Thm 5.18(4)(6)(7) which do not state it; the actual statement is Remark 5.21 (line 5729) and it holds only at `Q = τ̃ = 0`. Nothing cited on the Iritani–Koto side. | 3% |
| 3 | E | Block type retains the grading, but Thm 5.18(3) makes Ψ's center component homogeneous of degree `−r` and IK Thm 5.1(3) makes Φ homogeneous of degree `−(r−1)`. Ψ is not a morphism of the declared type. | 2% (repairable) |
| 4 | E + G | "The algebraic coefficient algebra on which the finite connection matrix is defined" does not exist for a general non-Fano fourfold; and the graded-completion convention (Remarks 1.3, 1.5, §2.2) is never invoked although the ring identity depends on it. | 5% |
| 5 | G | Center summand called a "faithful scalar extension" of `QDM(Z)`; Iritani line 4318 states that the function-level pullback is **ill-defined** because of `h_{Z,j}`, and exists only on the reduced ring `R` of Remark 5.6. | 5% |
| 6 | — | z-regularity, Ψ⁻¹ positivity, `∇_{z∂z}`/`µ` intertwining, `r′`, global generation, `Z` hypotheses, Lemma `A0preserve`, Prop. `rank2-rigidity`: all verified correct. | — |
| 7 | ? | AKMW Theorem 0.1.1 vs 0.3.1 for projectivity of intermediates — could not verify, no source text. | unknown |

**Bottom line.** No definite mathematical error found in the chain from
Theorem 5.18 / Theorem 5.1 to Theorem `every-cubic`. But §4.2 asserts four
distinct lemmas in five sentences, two of them attached to source items that do
not contain them, one of them (parity) load-bearing to the point that the
theorem's numerical value flips without it, and one of them (the grading in the
type) inconsistent with the source on its face. In its present form
Prop. `qdm-operation-ledgers` is a statement of intent, not a proof. All four
repairs appear to be available from material already in the two sources; they
amount to roughly a page of added argument.

---

### Appendix C-birational

# Referee report C (birational geometry / derived categories)

Target: `papers/cubic-stabilization-epilogue/sections/04-categorical-one-step.tex` (read in full)
and `sections/01-introduction.tex` lines 1–60.

Theorem under attack: **every-cubic** — for every smooth complex cubic threefold `X`,
`X x P^1` is irrational — proved by showing the Boolean-count marker `I_at` is a birational
invariant of smooth projective fourfolds, `I_at(X x P^1) = 2`, `I_at(P^4) = 0`.

**Verdict: I did not find a contradiction with an established theorem.** The sharpest
available counterexample tests all pass, several of them non-trivially. I found one genuine
design defect in the marker (it fires on resonant/unipotent blocks, contrary to the
introduction's own description of what it measures), and four load-bearing steps asserted
without proof. Ranked below.

---

## 0. What I computed, and how it was validated

I reimplemented the paper's block-reduction and residue-discriminant pipeline from scratch:
given `z^2 d_z S = (K + zG)S` with `K = (E star)` and `G = -mu`, split off the generalized
`lambda_0`-eigenblock, gauge away the off-diagonal part order by order in `z` (Sylvester),
read off `D_0 = (C^-1 G C)|_block` and `E_0 = (C^-1 G C . A_1)|_block`, form
`R = nu E_12 + diag(D_0) - diag(0,1) + (E_0)_21 E_21`, and evaluate
`delta^sharp = (tr R)^2 - 4 det R`.

Validation: on the cubic threefold my pipeline reproduces the paper's
`(eq:cubic-shared-block-data)` and `(eq:RX)` exactly — `D_0 = diag(-19/18, 19/18)`,
`nu (E_0)_21 = -16/81`, `R` conjugate to the paper's, char. poly. `(T+1/6)(T+5/6)`,
`delta^sharp = 4/9`. My normalisation uses `nu = 1` where the paper uses `nu = 2`; the
product `nu (E_0)_21 = -16/81` agrees, as it must, since that product is the frame-invariant
combination.

Useful closed form, valid for any rank-2 block whose `D_0` is traceless:
`tr R = -1` always, so the exponents are `-1/2 +- s` and `delta^sharp = 4 s^2`.

Scripts: `delta_sharp.py`, `delta_general.py`, `delta_more.py`, `delta_fast.py` in this
scratchpad (sympy, exact rational arithmetic; `q = 1` by homogeneity).

---

## 1. (c) The marker fires on **resonant** blocks, so it is not the invariant the paper says it is; and the cubic-fourfold consequence is not verified

**Probability the paper is actually killed by this: ~12%. Probability the stated defect is
real: 100% (computed).**

`delta^sharp != 0` is *not* equivalent to "the block has non-unipotent formal monodromy",
which is how the introduction and the `ej`-level heuristic describe it. `delta^sharp` is the
squared difference of the residue **eigenvalues**, whereas non-unipotence is the
non-vanishing of the difference of their **classes mod Z**
(Prop. `residue-discriminant-exponents` states both facts correctly, but the marker
`(eq:atomic-fold)` is built from the wrong one). A block with `rho_1 - rho_2` a nonzero
integer has unipotent formal monodromy and yet gets marked.

This is not hypothetical. Using Beauville's quantum cohomology of complete intersections
(the paper's own `[Beauville]`) I computed the ambient sub-QDM of every Fano cubic
hypersurface. The correction coefficients are `(6, 15, 6)` in all dimensions (plus the extra
`36 q^2` term only when `N = 3`), the eigenvalue 0 of `c_1 star` has multiplicity exactly 2
with a single Jordan block in every dimension, and:

| cubic `N`-fold | exponents | `delta^sharp` | `rho_1 - rho_2` |
|----------------|-----------|---------------|-----------------|
| `N = 3`        | `-5/6, -1/6` | `4/9`      | `2/3`  (non-integral) |
| `N = 4`        | `-1, 0`      | `1`        | `1`    (**integral**) |
| `N = 5`        | `-7/6, 1/6`  | `16/9`     | `4/3`  |
| `N = 6`        | `-4/3, 1/3`  | `25/9`     | `5/3`  |
| `N = 7`        | `-3/2, 1/2`  | `4`        | `2`    (**integral**) |
| `N = 8`        | `-5/3, 2/3`  | `49/9`     | `7/3`  |

The pattern is `exponents = -1/2 +- (N-1)/6`, `delta^sharp = (N-1)^2/9`, so the separation is
integral exactly when `N == 1 (mod 3)` — precisely when the fractional Calabi–Yau dimension
`(N+2)/3` of `Ku(X_3^N)` is an integer. So the marker fires on the cubic **fourfold**'s
ambient rank-2 nilpotent piece with `delta^sharp = 1`, even though `Ku` there is a K3
category with `S = [2]` and unipotent monodromy.

Why this matters. `I_at` is a deformation invariant (genus-0 GW invariants are deformation
invariants, and the marker only depends on the isomorphism class of the QDM). Smooth cubic
fourfolds form one connected family, and **rational** smooth cubic fourfolds exist
(Fano 1943: those containing two disjoint planes; Beauville–Donagi 1985: Pfaffian cubic
fourfolds). The paper's `d = 4` theorem therefore **forces** `I_at(cubic fourfold) = 0`.
So the paper needs the resonant `delta^sharp = 1` piece never to be a genuine block.

At the small point it is not: for a cubic fourfold the small quantum product satisfies
`h star alpha = 0` for every primitive `alpha` in `H^4` (the `beta = 0` term is `h.alpha = 0`
by primitivity, and the `beta = line` term is `[Sigma_p].alpha` where `Sigma_p`, the cone of
lines through a general point, is monodromy-invariant hence a multiple of `h^2`). So the
generalized 0-eigenspace of `c_1 star_0` has rank `2 + 22 = 24`, one primary block of rank 24,
marker 0. Good. But the marker is defined at **generic even bulk**, where a rank-24 block can
only refine, and nothing in the paper controls the refinement. The Dubrovin/Gamma heuristic
(blocks <-> semiorthogonal components) predicts three rank-1 blocks plus one rank-24 `Ku`
block, hence marker 0 — which is why I put the kill probability at only ~12% — but that is a
heuristic, not an argument, and it is exactly the kind of thing a referee must see proved.

**Free hardening, costs nothing:** replace `delta^sharp != 0` in `(eq:atomic-fold)` by
`rho_1 - rho_2 not in Z`. This is still invariant under regular isomorphism (`R` is
conjugated), it is strictly smaller so **center nullity is automatically preserved**, the
cubic threefold still passes (`2/3` is not an integer), `P^4` still gives 0, and it makes the
marker literally equal to the non-unipotence statement the introduction advertises. It also
kills the cubic-fourfold false positive at the root. I recommend the authors make this change
whether or not they can settle the block-rank question.

---

## 2. (c) The block is defined at generic even bulk; every computation is done at the small point, and Prop. `rank2-rigidity` presupposes what it needs to prove

**Probability the final contradiction actually fails because of this: ~8%. Probability the
stated value `I_at(X x P^1) = 2` is not the generic-bulk value: ~25%.**

`Sec. 4.1` defines blocks after "pass to its generic coefficient field", i.e. at the generic
point of the even bulk. Every computed value — `(eq:cubic-delta)`, `(eq:atomic-product-value)`,
`(eq:atomic-projective-value)`, and the curve/surface cases — is computed at `tau = 0` with
only Novikov variables. The bridge is Prop. `rank2-rigidity`, whose proof begins "Write a
centered base equation as `d y = (z^-1 C_d + ...) y`" — that is, it works *inside a rank-2
block already assumed to exist over the formal germ*. What must be excluded is that the double
Euler eigenvalue separates as a Puiseux series in `tau`, in which case the generic
decomposition is `1+1` and the marker is 0. Specialization can only merge eigenvalues, never
split them, so the `tau = 0` computation gives an upper bound on the generic block ranks, not
the generic structure.

The argument sketched in the proof (`d N = -q_d N + [N, ...]`, hence `tr(N^2)` satisfies a
homogeneous linear ODE and stays 0) does close the gap **provided** the rank-2 summand is
`nabla`-flat over the germ. That is true (the Hukuhara–Turrittin decomposition by exponential
factors is canonical, hence horizontal), but the paper neither says it nor cites it.

**Repair that also strengthens the theorem.** Hertling–Manin–Teleman, *An update on
semisimple quantum cohomology and F-manifolds*, Proc. Steklov Inst. Math. 264 (2009) 62–69
(arXiv:0803.2769): if the **even** quantum cohomology of a projective manifold is generically
semisimple then the manifold has no odd cohomology and is of Hodge–Tate type. Since
`h^{2,1}(X x P^1) = h^{2,1}(X) = 5 != 0`, `QH^even(X x P^1)` is nowhere generically
semisimple. Combined with the refinement remark above (all generic blocks have rank <= 2,
because the `tau = 0` decomposition is `2 + 2 + 1 + 1 + 1 + 1`), at least one rank-2 block with
`N != 0` survives at generic bulk, and Prop. `rank2-rigidity` freezes its `delta^sharp` at
`4/9`. Hence `I_at(X x P^1) >= 1` unconditionally, and the contradiction with
`I_at(P^4) = 0` survives even if the exact value 2 does not. The authors should state the
theorem this way; it removes the dependence on the precise count.

Note the same HMT theorem is what makes the whole approach non-vacuous, and the same
semicontinuity remark is what creates the risk in Finding 1. It should appear explicitly.

---

## 3. (c) Ledger additivity silently requires that no ambient block and center block share an Euler eigenvalue

**Probability actually false: ~10%.**

`(eq:marker-blowup)` and `(eq:marker-pbundle)` are read off from
`QDM(Bl_Z Y) = QDM(Y) (+) QDM(Z)^{c-1}` and `QDM(P_Y(V)) = QDM(Y)^{r}`. But
`B_T(-)` is defined by the **primary decomposition of the Euler operator on the total space**.
If a block of the first summand and a block of a second summand carry the same Euler
eigenvalue they merge into one larger primary block, and `w_at` is not additive:
`w(rank 2 (+) rank 2 with equal eigenvalue) = w(rank 4) = 0 != 1 + 1`. The additivity square
`(diag:marker-fold-additivity)` is a statement about the fold, not about the decomposition,
so it does not cover this.

The entire treatment is the clause "Parts (4), (6), and (7) give separated leading branches"
in the proof of Prop. `qdm-operation-ledgers`, with no argument. This is the step on which
both displayed formulas literally rest and it deserves a proof (for the blowup the separation
should be the `q_exc^{-1/(c-1)}` asymptotics of the center branches, which is presumably why
the Laurent extension is needed at all).

I verified separation concretely in the case that matters. Direct Künneth computation for
`X x P^1` (`QDM` of a product is the tensor product): `c_1 star` has eigenvalues
`+-2 sqrt(Q_2)` (each rank 2) and `+-6r +- 2 sqrt(Q_2)` (each rank 1), all six distinct, so the
two center copies do not merge, and **both** rank-2 blocks give `R` conjugate to the paper's
`R_X`, exponents `-1/6, -5/6`, `delta^sharp = 4/9`. So `I_at(X x P^1) = 2` is confirmed
independently of Iritani–Koto. This is a non-trivial check: `mu_{P^1}` is purely
*off-diagonal* in the idempotent basis of `QH(P^1)`, so it mixes the two spectral halves at
order `z`; the mixing turns out not to perturb `D_0` or `(E_0)_21`. That answers the
Künneth-consistency question in the affirmative — the mixed bulk does not merge or split the
blocks, and the two blocks are not "the same block counted twice".

---

## 4. (c) The "generic spine" adapter is the real unproved hypothesis

**Probability false as stated: ~20%; probability it needs extra hypotheses: high.**

Adapter 1 of `Sec. 4.2` asserts that the intrinsic ample-adic completion and the Laurent
neighbourhood of the exceptional cusp "both receive an injective map from the algebraic
coefficient algebra on which the finite connection matrix is defined", and that rank, primary
factors, nilpotence, regular formal gauges and conjugacy invariants are unchanged after
either field extension. Quantum connection matrices are formal power series in Novikov
variables; that they are finite/algebraic over a *common* subalgebra is exactly the assertion
being used and is not argued anywhere. Without it, the value `delta^sharp = 4/9` computed
intrinsically for `X`, and `delta^sharp = 0` computed intrinsically for a curve or a surface,
are not known to be the values of the corresponding *center summands* in Iritani's
decomposition, which live over `C[z]((q_exc^{-1/s}))[[Q, tau]]`.

Two sub-points the authors should separate:

- **Scalar extension is safe, specialization is not.** Primary decompositions are stable
  under extension of an algebraically closed coefficient field, but the occurrence data
  includes a *numerical Novikov specialization* `chi_j`, under which eigenvalues can collide,
  merging blocks (dropping the marker) or creating nilpotents (raising it). The
  Vandermonde/character-tagging argument around `(eq:center-novikov-map-atomic)` is presented
  as establishing injectivity of the Novikov map; it should be stated as establishing that
  `chi_j` is a monomorphism of coefficient rings, i.e. a scalar extension rather than a
  specialization, since that is what the later "faithful character adapter" invocations need.
- The surface-nullity cases are in fact robust to this: `K_S` nef gives *nilpotence* of the
  centered Euler operator, a field-independent statement, hence one block of full rank
  `b_0+b_2+b_4 >= 3` over any extension. `P^2` is regular semisimple over an algebraically
  closed field and stays so. So this concern does not bite in `Sec. 4.5` — but it does bite
  for the cubic block, where the value `4/9` is a number, not a rank.

I also could not check Iritani's Theorem 5.18 hypotheses against the source. The referee's
question is whether the decomposition is unconditional for an arbitrary smooth center of
codimension `>= 2` in an arbitrary smooth projective ambient. The paper takes it as such.

---

## 5. (b) AKMW: the projectivity of the intermediate varieties is a separate clause

**Probability false: ~5%.**

The proof of Thm. `marker-ledger` cites `[AKMW, Thm 0.1.1]` for a factorization "of smooth
projective `d`-folds". AKMW's main statement produces smooth **complete** intermediates; that
they can be taken projective when the endpoints are is an additional clause of the theorem.
The marker, and both comparison theorems it invokes, are only defined for smooth projective
targets, so the clause is load-bearing and should be cited explicitly.

Two related non-issues, checked and clean: AKMW centers are irreducible, so the
"disconnected centers are treated componentwise" remark is harmless belt-and-braces (and
correct, since `QDM` of a disjoint union is the direct sum); and a blowup along a smooth
divisor is an isomorphism, so restricting to codimension `>= 2` loses nothing. Also note the
hypothesis "every actual smooth center occurrence of dimension at most `d-2`" is not a
restriction: in a `d`-fold, a codimension-`>= 2` center automatically has dimension `<= d-2`.
The theorem statement would be clearer as "every center".

---

## 6. Center nullity through dimension two: no missing case found

I checked `Prop. atomic-lowdim` line by line and found the case analysis **complete**.

- Point, `P^1`: correct.
- Curves of genus `>= 1`: the classical even connection is right
  (`K = (2-2g) E_21`, `G = diag(1/2,-1/2)`), no rational curves so the big even product is
  classical, and the bulk `H^2` direction acts only through the divisor axiom on an empty set
  of curve classes, so the block structure is genuinely bulk-independent here. `g = 1` gives
  `N = 0`; for `g >= 2` the modified residue is `a E_21 - (1/2) I`, exponents `-1/2, -1/2`,
  `delta^sharp = 0`. I reproduced both by hand and in the pipeline.
- `K_S` nef: the degree inequality `a + b - 2 c_1(S).d + sum_v (e_v - 2) >= b + 2` is correct;
  I re-derived it from the virtual dimension `dim + c_1.d + n - 3` and got the paper's formula
  exactly. The `e_v >= 2` restriction is justified by the fundamental-class axiom, `e_v = 2`
  contributes 0 by the divisor axiom, and `d = 0` is covered since `a >= 2`. Conclusion:
  one primary block of rank `2 + b_2(S) >= 3`, marker 0. **No projective surface has
  `b_even = 2`**, so the worry about a rank-2 nef case is empty.
- `K = 0` surfaces (K3, abelian, Enriques, bielliptic) fall under "nef" and have
  `b_even >= 4`. Fake projective planes have `b_even = 3`. Fine.
- Minimal non-nef: `P^2` or geometrically ruled is the correct dichotomy.
- Non-minimal: point blowups, marker 0 by `(eq:marker-blowup)` with `c = 2`. No circularity
  (the `d = 2` instance only needs dimension-0 nullity).

**Independent check of the `P_C(V)` step over a genus-`g` base, which the prompt flags.**
I computed `C x P^1` for `C` of genus 2 directly by Künneth: `c_1 star` has eigenvalues
`+- 2 sqrt(Q_2)`, each a rank-2 nilpotent block, and each gives
`R = [[-1/2, 1], [0, -1/2]]`, exponents `-1/2, -1/2`, `delta^sharp = 0`. This confirms
`(eq:marker-pbundle)` at `r = 2` over an irrational base, independently of Iritani–Koto, and
confirms that the ruled-surface case really does inherit the curve's marker.

---

## 7. Consequences test: the strongest available counterexample **passes**

The `d = 3` instance of the theorem (center nullity is only needed in dimensions 0 and 1,
both proved) says: every smooth projective threefold `Y` with `I_at(Y) >= 1` is irrational,
and `I_at` is a stable birational invariant of threefolds. To refute it I need a **rational**
smooth threefold carrying a marked rank-2 block. By HMT (Finding 2) the only candidates are
rational threefolds with `h^{p,q} != 0` off the diagonal, and among those the only one whose
quantum cohomology is computable in closed form is:

**`X_{2,2} ⊂ P^5`, the smooth intersection of two quadrics.** It is rational (it contains
lines — the Fano surface of lines is an abelian surface — and projection from a line is
birational onto `P^3`; classical, cf. Beauville 1977 §6), and `h^{2,1} = 2 != 0`, so its even
quantum cohomology is *forced* to be non-semisimple. Using Beauville's relation
`P^{*4} = 16 q P^{*2}` together with the Frobenius symmetry and the count "4 lines through a
general point" (two conics in `P^2`), I get

```
P * P = P^2 + 4q ,   P * P^2 = P^3 + 8qP ,   P * P^3 = 4qP^2 + 16q^2
```

(the same derivation reproduces Beauville's cubic-threefold numbers `6, 15, 6, 36` exactly,
which validates it). Then `c_1 star = 2 P star` has char. poly. `T^2 (T^2 - 64 q)`, minimal
polynomial equal to it, so the eigenvalue 0 is a **single 2x2 Jordan block** — exactly the
marked shape, `rank 2`, `N != 0`, `N^2 = 0`. And

```
R = [[-1, 1], [-1/4, 0]] ,  char poly (T + 1/2)^2 ,  exponents -1/2, -1/2 ,  delta^sharp = 0 .
```

So `I_at(X_{2,2}) = 0`, as rationality requires. This is a strong confirmation, not a weak
one: the marker had a rank-2 nilpotent block of exactly the right shape to fire on, and it
came out zero *on the nose*, with the residue matching the genus-2 curve residue
`a E_21 - (1/2) I` that the paper itself computes — consistent with
`Ku(X_{2,2}) = D^b(Gamma_2)`.

I extended this to the whole family: the ambient sub-QDM of a smooth `(2,2)` complete
intersection has `delta^sharp = 0` and exponents `-1/2, -1/2` in **every** dimension 3
through 8. Every smooth `(2,2)` complete intersection of dimension `>= 3` is rational, so
this is a family-wide pass of both the `d = 3` and `d = 4` corollaries.

Other consequences I checked and found consistent, not contradictory:

- `Q^3`: Beauville gives `h^{*4} = 4qh`, so the eigenvalue 0 is **simple**, block rank 1,
  marker 0 — consistent with rationality.
- `Bl_C P^3` for `C` of genus `>= 1` is rational and has `h^{2,1} = g != 0`, so HMT forces a
  non-semisimple block; the ledger predicts that block is the curve's, with `delta^sharp = 0`.
  Consistent.
- `Bl_S P^4` for `S` a K3 in `P^4` is rational with `h^{3,1} = 1 != 0`; the ledger predicts the
  offending block is the K3's, of rank 24, marker 0. Consistent.
- Rational prime Fano threefolds with nonzero `h^{2,1}` — genus 7 (`V_12`), 9 (`V_16`),
  10 (`V_18`) — all have `Ku = D^b(curve)`, so the heuristic predicts `delta^sharp = 0`.
  I could not compute these (Beauville's formula is for index `>= 2`) and **recommend the
  authors do**: `V_12` with `h^{2,1} = 5` is the single most informative unchecked test of the
  `d = 3` corollary.
- `V_14` (genus 8): birational to a cubic threefold by Fano–Iskovskikh, so
  `I_at(V_14) = I_at(X) = 1` directly, a stronger and simpler route than the `P^1`-bundle flop
  used in the introduction. Consistent with `Ku(V_14) = Ku(X)`.

**The `d = 3` instance does settle open problems.** If the quartic double solid's block and
the Gushel–Mukai threefold's block are marked (both have `S^2 = [4]`-type Kuznetsov
components, so non-integral `s`, so plausibly `delta^sharp != 0`), the theorem gives:
*every* smooth quartic double solid is irrational, and *every* smooth Gushel–Mukai threefold
is irrational. For quartic double solids the standard results (Voisin, *Sur la jacobienne
intermédiaire du double solide d'indice deux*, Duke 57 (1988) 629–646; and the later
literature, e.g. arXiv:1605.02017 "A simple proof of the non-rationality of a **general**
quartic double solid") are stated for the general member; for GM threefolds rationality is,
to my knowledge, open. Confidence ~70–80% on both. These are legitimate consequences, but
they are large enough that the authors should state them explicitly rather than let a
referee discover them — and they are the natural places where a future counterexample would
kill the paper.

---

## 8. Items explicitly checked and found **not** to be problems

- **Künneth vs. projective-bundle formula for `X x P^1`** (prompt item 4): agree exactly;
  two rank-2 blocks with eigenvalues `+-2 sqrt(Q_2)`, no merging, no splitting, both with
  `delta^sharp = 4/9`. See Finding 3.
- **`d = 2` sanity** (prompt item 5): every surface has `I_at = 0`, so the `d = 2` instance is
  vacuous, as claimed. No inconsistency.
- **Elliptic-curve center (`N = 0`) and genus `>= 2` center (`delta^sharp = 0`)**: both
  verified by hand and by pipeline.
- **`Bl_C P^3` with `I = 0`**: internally consistent, and consistent with HMT (the
  non-semisimplicity lives in the curve's block).
- **`I_at` is deformation invariant.** This is a real property, not a bug, but it is a scope
  limit worth stating: the method can only ever prove irrationality for families all of whose
  smooth members are irrational. In particular it can say nothing about cubic fourfolds or
  about the Hassett–Pirutka–Tschinkel quadric-surface-bundle family, and it forces
  `I_at = 0` on those families. That is consistent, and it is what makes Finding 1 a test
  rather than a contradiction.
- **Stable birational invariance** follows from `(eq:marker-pbundle)`
  (`Y x P^1 ~ Y' x P^1` implies `2 I(Y) = 2 I(Y')`). The Beauville–Colliot-Thélène–Sansuc–
  Swinnerton-Dyer stably-rational non-rational threefold then forces `I_at = 0` on it, which
  is consistent — its irrationality is detected by a torsion/Brauer-type invariant that the
  QDM cannot see.
- **`A_0 L ⊂ L`** (Lemma `A0preserve`) and the regularity of the modification: I re-derived
  the horizontality identity and the `z^-1` and `z^0` coefficients; correct. `(D_0)_21 = 0`
  held in every case I computed, as it must.
- **Well-definedness of `R` up to conjugation**: two normalized regular gauges differ by a
  block-diagonal `H(z)` with `H_0` preserving `L`, so `S^-1 H S` is regular and
  `R` is conjugated. `delta^sharp` is a genuine invariant of the block. Correct.

---

## 9. Ranked summary

| # | Type | Issue | P(false) |
|---|------|-------|----------|
| 1 | (c) | Marker fires on resonant (unipotent) blocks; cubic-fourfold ambient block has `delta^sharp = 1`; theorem forces `I_at(cubic 4-fold) = 0` and this is unverified at generic bulk | ~12% fatal (defect itself certain) |
| 2 | (c) | Block persistence from `tau = 0` to generic even bulk presupposed, not proved; repairable via Hertling–Manin–Teleman | ~8% fatal, ~25% for the stated value 2 |
| 3 | (c) | Ledger additivity needs eigenvalue separation between ambient and center summands; one unproved clause | ~10% |
| 4 | (c) | "Generic spine" adapter: common algebraic coefficient algebra asserted, not constructed | ~20% |
| 5 | (b) | AKMW projectivity-of-intermediates clause cited only implicitly | ~5% |

Required before acceptance, in order: harden the marker to `rho_1 - rho_2 not in Z`
(Finding 1); add HMT and the horizontality of the Hukuhara–Turrittin decomposition to close
Finding 2 and simultaneously weaken the theorem's dependence on the exact value 2; prove the
eigenvalue-separation clause (Finding 3); construct the common spine or state it as a
hypothesis (Finding 4); and compute `I_at(V_12)` and `I_at(cubic fourfold)` as published
consistency checks.
