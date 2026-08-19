# C914 — The `A_5`-pencil against the Yang--Yu--Zhu locus and Voisin's components

**Lane:** `cubic-threefolds` · **Date:** 2026-08-18 · **Task:** C914

## Verdicts

1. **Yang--Yu--Zhu: no.** All but finitely many members of the nonstandard
   `A_5`-cubic pencil are not projectively equivalent to any member of the
   Yang--Yu--Zhu coprime-degree family (arXiv:2508.03623, Theorem 3.3). Every
   member of that family has an Eckardt point; all but finitely many members of
   the pencil have none. The pencil therefore meets the Yang--Yu--Zhu locus in
   at most finitely many moduli points, one of which is the Fermat member.

2. **Voisin: not by any product route, and the residual gate is one explicit
   four-dimensional factor.** Voisin's criterion (arXiv:1407.7261, proof of
   Theorem 4.5) asks for an odd-degree isogeny `mu : J(C) -> J(X)` with
   `mu^* theta_X = m theta_C` and `m` odd. For the generic member `X_b` of the
   pencil, every such isogeny with `C` reducible has exactly two components,
   whose Jacobians have dimensions one and four. In particular `J(X_b)` is
   **not** odd-degree isogenous to a product of five elliptic curves, even
   though `J(X_b) ~ E_b^5` as an abelian variety. Voisin's criterion holds for
   the pencil if and only if either the four-dimensional factor `A_b` below is
   the Jacobian of an irreducible genus-four curve, or `J(X_b)` is odd-degree
   isogenous to the Jacobian of an irreducible genus-five curve. Neither is
   established here, so the pencil is not known to lie in a Voisin component,
   and the pencil's universal `CH_0`-triviality is not pre-empted by Voisin's
   construction through any effective route.

3. **Restated contribution.** What the pencil supplies, at proved strength, is
   a positive-dimensional family of universally `CH_0`-trivial cubic threefolds
   whose proof is an integral saturation statement about the six-axis lattice,
   uniform in the parameter, and which is reached neither by the Yang--Yu--Zhu
   coprime-degree mechanism nor by an elliptic-product isogeny of the kind that
   Voisin's components are built from. It is not the first positive-dimensional
   such family: Voisin's Theorem 4.5 already gives loci of codimension at most
   three, and the pencil's own members may or may not lie in them.

## 1. The two models of the pencil

Both computations below use two independent constructions of the same pencil,
which is `P((Sym^3 W_5^*)^{A_5})` for the five-dimensional irreducible
`A_5`-module `W_5`.

*Rational model.* `A_5 = PSL(2,5)` permutes the six points of `P^1(F_5)`; the
sum-zero subspace of `Q^6` is `W_5` (permutation character `(6,2,0,1,1)` minus
the trivial character gives `(5,1,-1,0,0)`). The `A_5`-invariant cubics on that
subspace are spanned by `p_3 = sum x_i^3` and by the sum `T_1` of one of the
two `A_5`-orbits of ten squarefree monomials `x_i x_j x_k`; the invariant space
has dimension two, computed from the permutation module. The member `(a,b) =
(1,0)` is the Segre cubic threefold, and it is the singular member of this
model.

*Monomial model.* `W_5 = Ind_{A_4}^{A_5}(chi)` for a nontrivial cubic character
of a point stabilizer, realized by monomial matrices with cube-root entries.
Its invariant cubics are spanned by the Fermat form and by one further form
with cube-root coefficients; the script verifies invariance of both under all
sixty group elements. This model exhibits the Fermat member explicitly, which
the rational model does not.

## 2. Eckardt points separate the pencil from the Yang--Yu--Zhu family

**Criterion.** A point `p` of a smooth cubic threefold `X = {F = 0}` is an
Eckardt point exactly when the Hessian of `F` at `p` has rank at most two.
Writing `F = x_0^2 L + x_0 Q + C` in coordinates with `p = [1:0:0:0:0]`, the
Hessian at `p` is `[[0, 2L],[2L^t, 2Q]]`; the tangent hyperplane section is a
cone with vertex `p` exactly when `Q` vanishes on `{L = 0}`; and smoothness
makes `L` nonzero, so the rank condition and the cone condition agree.

**Every Yang--Yu--Zhu member has an Eckardt point.** In the normal form

    F' = t1 x1^2 x3 + t2 x2^3 + t3 x1 x3^2 + t4 x4^2 x5 + t5 x4 x5^2
         + t6 x1 x2 x3 + t7 x2 x4 x5,

the point `[1:0:0:0:0]` lies on `X'`, the tangent hyperplane there is
`{x_3 = 0}`, and the section is independent of `x_1`. This was already recorded
on 2026-08-14; the computation below re-checks it for two members.

**The generic pencil member has no Eckardt point.** In the rational model the
members `(1,1)`, `(1,2)`, `(1,3)`, `(2,1)` and `(0,1)` are smooth and their
Eckardt schemes are empty; in the monomial model the members `(1,1)`, `(1,2)`
and `(1,-3)` are smooth with empty Eckardt scheme. The controls behave as
expected: the Fermat cubic threefold has thirty Eckardt points in both models,
and the two Yang--Yu--Zhu members tested have nonempty Eckardt schemes.

**Consequence.** The locus of `b` in the pencil whose member carries an Eckardt
point is Zariski closed — the incidence variety in the product with `P^4` is
closed and `P^4` is proper — and it is proper, since the members above are not
in it. So it is finite. Since every Yang--Yu--Zhu member has an Eckardt point,
all but finitely many members of the pencil are not projectively equivalent to
one. The Fermat member, which lies in both families, is one of the finitely
many exceptions.

**What this does not prove.** It gives no information about the finitely many
exceptional members, and it does not identify them: the exceptional set was not
computed. It also says nothing about the closure of the Yang--Yu--Zhu locus in
moduli beyond the members themselves.

**Why the generic member is Eckardt-free, structurally.** An Eckardt point
`p` with tangent hyperplane `H` gives an involution of `X`: in coordinates
where the quadratic part vanishes, `F = x_0^2 L + C` and `x_0 -> -x_0` fixes
`X`. That involution acts on the ambient five-dimensional module with
eigenvalue multiplicities `(4,1)`, so a cubic threefold has an Eckardt point
only if its automorphism group contains such a reflection. Every involution of
`A_5` acts on `W_5` with character value `1`, hence with multiplicities
`(3,2)`, and is not a reflection. So any member whose automorphism group is
exactly `A_5` has no Eckardt point at all. The computation below is the
unconditional form of this: it does not need to know the generic automorphism
group.

**Free corollary, not used above.** Every smooth cubic threefold whose equation
is a sum of cubic forms in pairwise disjoint groups of at most three variables
has an Eckardt point. Any partition of five into parts of size at most three
has a part of size at most two; a point supported on that part and lying on `X`
exists because a binary cubic has a root, and at such a point every other
diagonal block of the Hessian vanishes, so the Hessian has rank at most two.
Combined with the computation, this reproves
Proposition~`prop:A5-nonseparated` of the epilogue — only finitely many pencil
members are of separated-variable type — in three lines, replacing the current
argument through Hartlieb's closedness and irreducibility statements. The
manuscript has not been changed here; see the successor note below.

## 3. Voisin's criterion on the pencil

### 3.1 The lattice model, from the manuscript's own data

Write `J` for the intermediate Jacobian of a geometric generic member. The
epilogue records, after Hartlieb and Roulleau:

* `H_1(J, Q) = W_5 tensor H_1(E, Q)` for an elliptic curve `E`, non-CM at the
  geometric generic point, so `J ~ E^5`;
* the six `D_5`-axes give an `A_5`-equivariant isogeny
  `f : E tensor (Z^Omega / Z 1) -> J` whose Rosati Gram matrix is
  `G_6 = 6 I_6 - J_6`; after omitting one axis the pulled-back polarization
  form on `Z^5 tensor H_1(E,Z)` is `G tensor omega` with `G = 6 I_5 - J_5`, of
  Smith type `(1,6,6,6,6)`;
* `ker f` is an `A_5`-stable maximal isotropic subgroup of the discriminant
  group, and its two-primary part is one of the two **exotic** members of the
  packet `P^1(F_4)` — the pair whose stabilizer is exactly `A_5`, not one of
  the three `F_2`-rational, `S_6`-stable kernels
  (Proposition `prop:principal-gluing-packet`).

The script rebuilds this lattice from scratch: `A_5` acts on the six axes as
`PSL(2,5)` on `P^1(F_5)`, `G` has determinant `1296` and Smith type
`(1,6,6,6,6)`, `S = G tensor omega` has Smith type `(1,1,6,...,6)`, the
two-primary discriminant is eight-dimensional over `F_2`, and there are exactly
five `A_5`-stable maximal isotropic subgroups — three of tensor type
(`x tensor v_1`, `x tensor v_2`, `x tensor (v_1+v_2)`) and two graphs of an
`F_4`-scalar of order three. That is the `P^1(F_4)` of the manuscript, computed
independently.

### 3.2 Which product decompositions are possible

Let `Lambda = Z^5` with form `G`, let `Lambda_1 = Lambda^* cap (1/2)Lambda`,
and let `H_2 = Lambda_1 / Lambda`, the four-dimensional coefficient heart. With
the exotic kernel, `H_1(J,Z)` is, two-adically,

    L = { (a,b) in Lambda_1 x Lambda_1 : class(b) = omega * class(a) },

where `omega` generates the `F_4`-scalars of `H_2` and the symplectic form is
`<(a,b),(a',b')> = q(a,b') - q(b,a')`.

Suppose `mu : J(C) -> J` is an odd-degree isogeny with
`mu^* theta = m theta_C`, `m` odd, and `C = C_1 u ... u C_k` reducible. Then
`L' = mu_*(H_1(J(C),Z))` is a sublattice of odd index that splits as an
orthogonal direct sum of sub-Hodge structures, each carrying `m` times a
unimodular form. Because `E` is non-CM, every sub-Hodge structure of
`W_5 tensor H_1(E,Q)` is `U tensor H_1(E,Q)` for a subspace `U` of `W_5`, so
the splitting comes from a `q`-orthogonal splitting of `W_5`. Odd index forces,
two-adically, `Lambda = sum_i (Lambda cap U_i)` and
`Lambda_1 = sum_i (Lambda_1 cap U_i)`, hence a decomposition
`H_2 = sum_i H_i`, and the graph description forces each `H_i` to be stable
under `omega`. So each `H_i` is an `F_4`-subspace and has even `F_2`-dimension.

The script computes the discriminant pairing on `H_2` together with its five
`F_4`-lines and finds that **every `F_4`-line is totally isotropic and equals
its own perpendicular**. A splitting with `H`-dimensions `(2,2)` would need two
complementary perpendicular `F_4`-lines, so it does not exist. The only
remaining pattern is `(4,0)`: one factor carries the whole heart, and a factor
whose discriminant needs four generators has rank at least four. Hence the only
possible shape is `(1,4)`.

That shape is realized. With `U_1 = <e_1>` (norm five) and `U_2` its
`G`-orthogonal complement, the induced sublattice has index `25` in `L` for
every one of the five kernels, the rank-two factor has Pfaffian `5`, and the
rank-eight factor has elementary divisors `(3,3,3,3,3,3,15,15)` — all odd. So
after shrinking each factor by an odd index to a common odd `m`, one gets an
odd-degree isogeny

    E' x A_b  ->  J(X_b),      pullback of theta = m (theta_{E'} + theta_{A_b}),

with `E'` an elliptic curve isogenous to `E_b` and `A_b` a four-dimensional
principally polarized abelian variety isogenous to `E_b^4`. By the paragraph
above, `A_b` admits no further orthogonal odd-index splitting, so if `A_b` is a
curve Jacobian the curve is irreducible of genus four.

For the three `F_2`-rational kernels the obstruction disappears: the splitting
with `W`-dimensions `(1,2,2)` has odd index `225` there. The verdict therefore
depends on the manuscript's identification of the geometric kernel as exotic.

**Where the argument stops.** The step "every sub-Hodge structure is
`U tensor H_1(E,Q)`" uses that `E` has no complex multiplication, which the
epilogue proves only at the geometric generic point of the pencil. At a fibre
whose elliptic factor has complex multiplication the endomorphism algebra of
the multiplicity module is an imaginary quadratic field, there are strictly
more sub-Hodge structures, and the obstruction below does not apply. The Fermat
member is such a fibre, and it is universally `CH_0`-trivial for three older
reasons. So the Voisin verdict here is about the generic member, exactly as the
Yang--Yu--Zhu verdict is.

### 3.3 What remains open

Voisin's criterion holds for the pencil exactly if one of the following does:

* `A_b` is the Jacobian of an irreducible genus-four curve. A dimension count
  is consistent with this: genus-four curves with a faithful `D_5`-action form
  a one-dimensional family, and `A_b` carries the `D_5`-stabilizer of the axis
  used to split it. The Jacobian locus is a divisor in `A_4`, so this is a
  codimension-one condition that a one-parameter family can meet identically or
  not at all.
* `J(X_b)` is odd-degree isogenous to the Jacobian of an irreducible genus-five
  curve, with no product decomposition involved. The Jacobian locus has
  codimension three in `A_5`.

Neither is decided here. Both are stated as the successor question; see the
mystery ledger.

## 4. Replay and artifacts

Working directory: the repository root.

    python3 notes/2026-08-18-c914-a5-pencil-eckardt.py --sing /tmp/eckardt.sing
    nix shell nixpkgs#singular --command Singular -q /tmp/eckardt.sing
    python3 notes/2026-08-18-c914-a5-pencil-voisin-locus.py \
        --json notes/2026-08-18-c914-a5-pencil-voisin-locus.json

The Singular run reproduces `notes/2026-08-18-c914-a5-pencil-eckardt.txt`
(Singular 4.4.1 from `nixpkgs#singular`, exact rational and `Q(w)` arithmetic,
`w^2+w+1 = 0`). The lattice script has no dependencies and uses exact integer
and rational arithmetic only; it asserts its own model checks (isometry of the
`A_5`-action, orthogonality and saturation of the pieces) and fails loudly if
any of them breaks.

Trusted boundary: Singular's Groebner engine for the dimension and degree of
the Eckardt and Jacobian cones; the Python scripts for everything else. The
`(1,4)` factorization is a statement about the lattice model recorded in the
epilogue, not an independent verification of that model; the manuscript's
Lemma `lem:relative-six-axis` and Proposition `prop:principal-gluing-packet`
are the inputs.

Independent cross-check: the Eckardt verdict is computed twice, in two models
of the pencil built by different constructions (a rational six-coordinate
permutation model over `Q`, and the induced monomial model over `Q(w)`), with
the Fermat cubic threefold as a common control returning thirty Eckardt points
in both.

SHA-256 (byte counts in parentheses):

| file | sha256 | bytes |
|---|---|---|
| `notes/2026-08-18-c914-a5-pencil-eckardt.py` | 3ffc3b8d202e39cf49798e052eebc2b069e3d9febc76f72d7dd31799f3ecd054 | 10071 |
| `notes/2026-08-18-c914-a5-pencil-eckardt.txt` | 92eda7020d2edfe6b1f397ee2b1bb27649430cbcccefcca3f0b9d7dc91051ba2 | 1210 |
| `notes/2026-08-18-c914-a5-pencil-voisin-locus.py` | c67016f21b770990052863e710ba5c894f59f95016895a1b602ebd61887fd79e | 18383 |
| `notes/2026-08-18-c914-a5-pencil-voisin-locus.json` | 546b1d4484d3b8eea5cb16e84b18c0e14e8600640148a3f6cf27db4eea98ba7c | 11474 |

## 4b. Promotion into the manuscript

The Eckardt bundle now also lives inside the paper, at
`papers/cubic-stabilization-epilogue/verification/`, as
`a5_pencil_eckardt.py` with two tracked outputs — `a5-pencil-models.txt` for
the model checks and `a5-pencil-eckardt.txt` for the Singular run — a checksum
manifest covering all three, a `--check` mode that recomputes the model checks
and compares them with the tracked file, and an entry in the paper's evidence
registry. That copy is the authority for the manuscript's statements; the files
under `notes/` are the frozen artifacts of this task's run, and the two Singular
inputs they generate are byte-identical. The manuscript statements resting on
it are `prop:A5-not-coprime` and, through the second proof recorded there,
`prop:A5-nonseparated`. An independent cold read of the manuscript change is at
`2026-08-18-c914-manuscript-cold-read.md`.

## 5. Negative results, with their exact domain

* No Eckardt point exists on the five rational-model members and the three
  monomial-model members listed in Section 2. This is exact over `Q` and over
  `Q(w)` respectively, not a sampling statement, and it is what makes the
  Eckardt locus of the pencil finite.
* No odd-index orthogonal splitting of `H_1(J,Z)` into sub-Hodge structures of
  dimension at most three exists for either exotic kernel. This is proved, not
  searched: `F_4`-stability of the summands is forced, and the discriminant
  pairing makes every `F_4`-line its own perpendicular.
* A parametrized elimination over `F_32003` for the Eckardt locus of the whole
  pencil returned the unit ideal, which contradicts the Fermat member's thirty
  Eckardt points and is therefore discarded; no conclusion is drawn from it and
  it is not part of the evidence bundle.

## Mystery ledger

| Item | Status |
|---|---|
| `J(X_b) ~ E_b^5`, yet no odd-degree isogeny from a product of five elliptic curves exists | settled: the two-primary gluing kernel is an `F_4`-graph, every `F_4`-line of the coefficient heart is its own perpendicular, and the only surviving product shape is `1 + 4` |
| Is the four-dimensional factor `A_b` a genus-four Jacobian? | open; this is now the whole Voisin question for the pencil, together with the irreducible genus-five route. The dimension count for genus-four curves with `D_5`-action matches, which makes it a real question rather than a formality |
| The pencil contains the Fermat cubic threefold (thirty Eckardt points), the Segre cubic (singular) and the Klein cubic | settled as consistent; the Eckardt locus of the pencil is finite and contains the Fermat member. Which further members are exceptional was not computed |
| Why the three `F_2`-rational kernels behave differently from the two exotic ones | settled: with a rational kernel the `(1,2,2)` splitting has odd index `225`, so the elliptic-product route would succeed; the exotic kernel is exactly what blocks it. The geometric kernel is exotic by the manuscript's own packet proposition |
