# C909 — hostile audit of the fixed-dimension finite-etale Hecke tower

Date: 2026-08-11

Status: theorem survives after stated coordinate and localization repairs; no
manuscript, PDF, mirror, Lean, or certificate change

## Verdict

**GO, with three required wording/proof repairs.**  For every fixed `g>=2`
and odd `p`, one integral unramified order, trace-form isometry, and monogenic
generator give compatible finite-etale graph kernels at all exponents.  The
full C909 cohomological PD saturation and polarized indecomposability follow.
The local endomorphism orders have strictly growing reduced-trace
discriminants, so the fibers for one fixed non-CM elliptic curve are pairwise
nonisomorphic even without their polarizations.

The candidate note must repair:

1. the Tate-coordinate inclusion is multiplication by `p`, not literal
   equality of the coordinate vectors;
2. the equality with `End(A_a) tensor Z_p` needs the standard local-global
   order lemma, not only a `p`-adic lattice calculation; and
3. modular non-isotriviality should be proved by the rational weight-one VHS,
   not by the informal countability sentence.

No counterexample was found in the requested finite-etale scope.

## 1. The odd trace-form construction is valid in every dimension

Let `O/Z_p` be the unramified extension of degree `g`.  For a unit `c`, the
transfer of the rank-one form `h_c(x,y)=cxy` has determinant squareclass

\[
 \det(\operatorname{Tr}_{O/Z_p}h_c)
 =\operatorname{disc}(O/Z_p)N_{O/Z_p}(c)
 \quad\bmod (Z_p^\times)^2.
\tag{1}
\]

The norm on unit squareclasses is surjective for an unramified odd-local
extension.  Choose `c` to make (1) the squareclass of `1`.  Unimodular
symmetric forms over `Z_p`, `p` odd, are classified by rank and determinant
squareclass, including when `p` divides `g`.  Therefore

\[
 (O,\operatorname{Tr}(cxy))\simeq(Z_p^g,I_g).
\tag{2}
\]

Multiplication by every element of `O` is self-adjoint for the transferred
form.  Under (2), choose a generator `theta` whose reduction has degree `g`
over `F_p`; its multiplication matrix `T` is literally transpose-symmetric
and `Z_p[T]=O`.  Reduction gives

\[
 (Z/p^a)[T\bmod p^a]=O/p^aO,
\tag{3}
\]

which is finite etale (an unramified local etale algebra, not a field when
`a>1`).  This checks the claimed slope at every level.

## 2. Exact Tate-coordinate compatibility

Fix a symplectic `p`-adic Tate basis `(e,f)` of `E`.  The compatible
identification is

\[
 E[p^a]^g\simeq p^{-a}(T_pE)^g/(T_pE)^g
 \simeq (Z/p^a)^{2g}.
\tag{4}
\]

Under the natural subgroup inclusion `E[p^a]\subset E[p^{a+1}]`, a
coordinate pair `(x,y)` maps to `(px,py)`, not to the same displayed pair.
For

\[
 K_a=\{(x,T_ax):x\in(Z/p^a)^g\},
\tag{5}
\]

its image is `(px,pT_ax)`.  Taking `u=px` and using the common integral lift
`T`,

\[
 T_{a+1}u=pT_{a+1}x\equiv pT_ax\pmod {p^{a+1}}.
\tag{6}
\]

Thus `K_a\subset K_{a+1}` exactly.  The quotient map is

\[
 q_a:A_a=E^g/K_a\longrightarrow A_{a+1}=E^g/K_{a+1},
\tag{7}
\]

of degree `p^g`, and its polarization normalization is

\[
                         q_a^*\Theta_{a+1}=p\Theta_a.
\tag{8}
\]

This is a genuine compatible tower of `p`-polarized isogenies.  The claimed
inclusion is correct only with the calculation (4)--(6); replace the current
literal-coordinate explanation accordingly.

## 3. Local endomorphism order and nonisomorphism

On the `p`-adic homology lattice, a coefficient matrix `U` preserves the
graph overlattice exactly when

\[
 U\in M_g(Z_p),\qquad [U,T]\equiv0\pmod {p^a}.
\tag{9}
\]

The reduction of `T` has irreducible degree-`g` minimal polynomial, so its
centralizer over `Z/p^a` is `O_a=O/p^aO`.  Hence the local stabilizer is

\[
 \mathcal O_{a,p}=O+p^aM_g(Z_p).
\tag{10}
\]

For `End(E)=Z`, every rational endomorphism is a coefficient matrix in
`M_g(Q)`.  Away from `p`, the isogeny lattice is the literal elliptic-power
lattice.  Intersecting its integral stabilizers at all primes with (10), then
localizing back at `p`, gives the required local-global order identity

\[
 \operatorname{End}(A_a)\otimes Z_p=\mathcal O_{a,p}.
\tag{11}
\]

This sentence is required: a `p`-adic lattice stabilizer alone does not
automatically identify the completion of the global endomorphism order.

Modulo `p^a`, (10) has rank `g` inside the rank-`g^2` matrix algebra.  Thus

\[
 [M_g(Z_p):\mathcal O_{a,p}]=p^{a(g^2-g)},
\qquad
 v_p(\operatorname{disc}\mathcal O_{a,p})=2a(g^2-g),
\tag{12}
\]

for the standard reduced-trace normalization.  The global order has the same
`p`-valuation.  An isomorphism of unpolarized abelian varieties identifies
their endomorphism orders and their rational semisimple algebras, hence
preserves the reduced-trace discriminant.  Therefore `A_a` and `A_b` are
nonisomorphic for `a!=b`.

## 4. Indecomposability is valid

A polarized product decomposition gives a Rosati-self-adjoint integral
idempotent.  Its reduction in the local order (10) lies in the local ring
`O/pO`, hence is `0` or `1`.  If `e` reduces to zero, regard `e` in the
maximal order `M_g(Z_p)`: write `e=pX`.  The equation `e^2=e` gives
`X=pX^2`, so `X` is divisible by `p`; iteration gives `e=0`.  Apply this to
`1-e` for the other residue.  Thus the local order has no nontrivial
idempotent at all, which is stronger than required for polarized
indecomposability.

The argument uses `End(E)=Z`; it establishes polarized indecomposability,
not absolute simplicity.

## 5. Full PD saturation and modular spreading

Each source is the single depth-`a` block `p^aI_g` and (3) is literal finite
etaleness.  The arbitrary-depth finite-etale graph theorem therefore gives
full cohomological

\[
 \operatorname{DP}\langle\operatorname{NS}(A_a)\rangle^k
 =\operatorname{im}(\operatorname{Sym}^k\operatorname{NS}(A_a))
 \quad(0\leq k\leq g)
\tag{13}
\]

on non-CM fibers.  The ordinary product conclusion is cohomological; no
Chow or integral-Hodge enlargement is involved.

On the fine full-level modular curve `Y(p^a)`, the fixed matrix `T_a` defines
a finite flat graph subgroup of the universal elliptic curve's `p^a`-torsion.
The quotient and its principal polarization therefore form an abelian scheme
with polarization.  To prove that this family is non-isotrivial, use the
isogeny to identify rational variations of Hodge structure

\[
 R^1(A_a)_Q\simeq R^1(E^g)_Q
 \simeq (R^1E_Q)^{\oplus g}.
\tag{14}
\]

The elliptic variation on the modular curve is nonconstant, so (14) rules
out an isotrivial `A_a` family.  At CM fibers, the full Neron--Severi and
endomorphism claims must remain excluded exactly as in the candidate note.

## Exact repairs to the candidate theorem

1. In its kernel paragraph, replace the claimed coordinate inclusion by
   (4)--(6), and call the maps in (7) `p`-polarized using (8).
2. Replace the derivation of equation (10) by the local stabilizer statement,
   then insert the local-global order step (11) before discussing the global
   endomorphism ring and its discriminant.
3. Replace the countable-isogeny explanation of non-isotriviality by the VHS
   proof (14).  Do not call Neron--Severi groups a single local system across
   CM fibers; state the matrix calculation fiberwise on the non-CM locus.
4. Replace every occurrence of “unramified field at level `a`” by
   “unramified finite-etale local algebra” for `a>1`.

## Mystery ledger

* **Settled:** one integral trace/self-adjoint generator realizes compatible
  finite-etale slopes for all `a`, all odd `p`, and every fixed `g>=2`.
* **Settled:** the Tate-coordinate scaling proves the actual kernel tower.
* **Settled:** endomorphism-order discriminants distinguish the levels after
  the local-global order lemma is supplied.
* **Settled:** the construction gives non-isotrivial modular families and
  full cohomological PD saturation on non-CM fibers.
* **Boundary:** the result supplies neither a global field action, a special
  subvariety statement, nor a Chow/Hodge-class upgrade.
