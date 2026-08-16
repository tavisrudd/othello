# C912 — the block residue from the Poincaré pairing, and what its determinant is

**Date:** 2026-08-15
**Lane:** `clebsch`
**Task:** C912 (analysis only; no manuscript edit, no change to Hypothesis 4.7H)
**Follows:** `2026-08-15-c912-m1-ambiguity-computation.md`, item 2 of its addendum

The addendum proposed the collection's own compression move: since the trace of
the sheared block residue is already pinned at `-1`, the whole primitive-sixth
count rests on the single scalar `det R`, and the target is a pairing formula
for it. This report carries that out. It has three outcomes, one of them a
strengthening of the frame-transport memo, one a no-go that redirects effort,
and one an identification of what the scalar is.

## Verdicts

1. **Standing hypothesis (H2) of the rigidity theorem is a theorem, not a
   hypothesis.** The Frobenius property of quantum multiplication, transported
   through the unique decoupling gauge, forces the entry that (H2) assumes to
   vanish — at every base point, not only at the origin. The rigidity theorem
   therefore holds under (H1) alone.
2. **No purely formal pairing argument can pin `det R`, and the reason is
   dimensional.** After the shearing, the Poincaré pairing becomes `z` times a
   symplectic form, and in rank two the symplectic constraint on the residue is
   exactly `tr R = -1` and nothing further, because `sp(2)` and `sl(2)`
   coincide. So the pairing gives one of the two coefficients for free and
   cannot give the other. Item 2 of the addendum is answered in the negative in
   its literal form.
3. **`det R = 5/36` is the Euler-pairing signature of the Kuznetsov component.**
   The Serre operator on the numerical Grothendieck group of the Kuznetsov
   component of a smooth cubic threefold has characteristic polynomial exactly
   the sixth cyclotomic polynomial `lam^2 - lam + 1`, and cube `-I`. Its two
   eigenvalues are the two primitive sixth roots of unity, which is the count
   `nu_6 = 2` on the nose. So the pairing formula the addendum asked for does
   exist, but the pairing is the Euler form on a K-group, not the Poincaré form
   on cohomology — and being a lattice invariant it is discrete, which is
   exactly the property the transport problem lacks.

## 1. The duality is preserved by the decoupling gauge

Conventions are the frame-transport memo's: `z d_z Y = (z^{-1}U - mu)Y` and
`d_a Y = -z^{-1}C_a Y`, with `U = E star`, `C_a = phi_a star` and `mu` the
constant grading operator.

Let `G` be the Poincaré pairing, symmetric and nondegenerate on the even part.
Quantum multiplication is Frobenius, so `U` is `G`-self-adjoint, and `mu` is
`G`-anti-self-adjoint. Writing `A(z) = z^{-1}U - mu`, those two facts are
exactly the statement

```
A(-z)^T G + G A(z) = 0.                                            (D)
```

**Lemma 1.** The unique decoupling gauge `g = I + O(z)` of the memo's
Lemma 8.1 satisfies `g(-z)^T G g(z) = G`. Hence the decoupled connection
satisfies (D) with the *same constant* pairing, and so does each block with the
restriction of `G` to it, before and after the twist by `exp(u_0/z)`.

*Proof.* Let `sigma` be the involution `A |-> -G^{-1}A(-z)^T G` on connection
matrices; (D) says `A^sigma = A`. A direct computation with the gauge action
`g . A = g^{-1}Ag - g^{-1}z d_z g` gives

```
(g . A)^sigma = h . (A^sigma),        h := G^{-1} g(-z)^{-T} G,
```

the two terms matching separately: the conjugation term because
`h^{-1} = G^{-1}g(-z)^T G`, and the logarithmic-derivative term because
`h^{-1} z d_z h = -G^{-1}(z d_z g(-z))^T g(-z)^{-T} G`. Now let `g` be the
decoupling gauge and `A~ = g . A`. The generalized eigenspaces of a
`G`-self-adjoint operator are `G`-orthogonal, so `G` is block diagonal and
`A~^sigma` is block diagonal whenever `A~` is; and `h = I + O(z)` because
`g = I + O(z)`. So `h` is a second gauge of the normalized form carrying `A` to
block-diagonal form, and uniqueness gives `h = g`, which is the claim.
Restriction to a block is legitimate because `G` restricts nondegenerately to
each block. The twist by `exp(u_0/z)` subtracts `z^{-1}u_0 I`, a scalar, from
the block connection, and (D) is insensitive to that because the added term is
odd in `z` and self-adjoint. ∎

Expanding (D) for the twisted decoupled block connection
`z^{-1}N + A_0' + zA_1' + ...` coefficient by coefficient gives the parity rule

```
N^T G_0 = G_0 N,      (A_0')^T G_0 = -G_0 A_0',      (A_1')^T G_0 = G_0 A_1',
```

that is, the coefficient of `z^k` is `G_0`-self-adjoint for `k` odd in the
`z^{-1}`-indexed sense and anti-self-adjoint for `k` even. The middle relation
is the memo's tracelessness statement, now with the gauge correction included
rather than only for `P_i mu P_i`.

## 2. Hypothesis (H2) is automatic

**Theorem 2.** Let a block satisfy (H1): rank two, nilpotent part `N` nonzero.
Then in the shearing frame `(e_1, e_2)` with `N e_1 = 0` and `N e_2 = nu e_1`,

```
f := (A_0')_{21} = 0
```

identically. Hence the sheared block is regular singular, and the memo's
standing hypothesis (H2) may be deleted from Theorems 8.4, 8.6 and
Corollary 8.7.

*Proof.* `N` is `G_0`-self-adjoint by Lemma 1 and `N^2 = 0` by rank two, so for
all `x, y` we get `(Nx, Ny) = (x, N^2 y) = 0`: the image of `N` is isotropic. In
particular `(e_1, e_1) = 0`, and nondegeneracy then forces `(e_1, e_2) != 0`.
`A_0'` is `G_0`-anti-self-adjoint, and for a symmetric form that gives
`(A_0' x, x) = 0` for every `x`. Taking `x = e_1` and expanding
`A_0' e_1 = alpha e_1 + f e_2` gives `f (e_2, e_1) = 0`, hence `f = 0`. ∎

This explains an observation the memo recorded as an accident. It verified
(H2) for the cubic by noting that the draft's `D_0` is diagonal; Theorem 2 shows
the vanishing of that entry is forced by the Frobenius structure for every
rank-two coalesced block of every smooth projective target. It also improves the
memo's Theorem 8.4, which derived `f == 0` on the germ from `f(0) = 0` by a
differential argument: the vanishing now holds pointwise, with no germ and no
differential equation, which is what a statement outside the germ needs.

The same argument should extend to a single Jordan block of size `m` using the
isotropy of the image of `N^{m-1}` and the shearing `diag(1, z, ..., z^{m-1})`;
that is the extension the memo's scope remark asks for, and it is now a
pairing computation rather than an open problem.

## 3. Why the pairing cannot give the determinant

**Proposition 3.** After the shearing `S = diag(1,z)` the pairing becomes
`G^(z) = S(-z)^T G_0 S(z) = z c J + O(z^2)` with `J` the standard antisymmetric
matrix and `c = (e_1,e_2) != 0`. The duality relation at leading order reads
`R^T J + J R = -J`, that is, `R + I/2` lies in `sp(2)`. Since `sp(2) = sl(2)`,
this is exactly `tr R = -1` and imposes no condition on `det R`.

So the shear converts the symmetric Poincaré pairing into a symplectic one, and
in rank two a symplectic constraint is a trace constraint. This is a clean
reason why the count reduces to one scalar and simultaneously why that scalar
cannot be recovered from the pairing: it is a genuine modulus of the connection
at rank two. Any formula for it must import something beyond the flat structure.

## 4. What the scalar is: the Serre operator on the Kuznetsov component

The cubic threefold has `D^b(X) = <Ku(X), O, O(1)>`, so the residual component
has numerical Grothendieck group of rank two — matching the rank-two block —
while the two exceptional objects match the two simple blocks at the nonzero
eigenvalues `+-6r`, which by the simple-block theorem carry nothing. The Serre
functor of `Ku(X)` satisfies the fractional Calabi--Yau relation `S^3 = [5]`, so
on the K-group, where a shift by one acts by `-1`, the Serre operator satisfies
`S^3 = -I`.

Computed from the Euler form `E = [[-1,-1],[0,-1]]` through
`chi(a,b) = chi(b, Sa)`, that is `S = E^{-1}E^T`:

```
S = [[0,-1],[1,1]],   char poly  lam^2 - lam + 1 = Phi_6(lam),   S^3 = -I.
```

Its eigenvalues are `exp(+- i pi/3)`, the two primitive sixth roots of unity.
That is `nu_6 = 2` exactly, and it agrees with the manuscript's own value
derived from Cai's connection through the indicial polynomial
`rho^2 + rho + 5/36`, whose roots `-1/6, -5/6` exponentiate to the same pair.
The conclusion does not depend on the Euler matrix: rank two, integrality and
`S^3 = -I` leave only `{-1,-1}` or the conjugate pair, and the trace excludes
the first. Script and output:
`2026-08-15-c912-serre-lattice-check.py` and `.out`.

**Status of the identification.** That the formal monodromy of an atom matches
the Serre operator of the corresponding semiorthogonal component is the expected
correspondence in the Katzarkov--Kontsevich--Pantev--Yu programme, not something
proved here or in the manuscript. What is established here is the exact
numerical match, plus the checks below. The ambient category is a useful
contrast and a warning: the Serre functor of `D^b(X)` itself is tensor by the
canonical bundle followed by a shift, which acts on the K-group as `-1` times a
unipotent, so every ambient eigenvalue is `-1` and none is a primitive sixth
root. The count is a property of the residual component, and — consistently with
the recorded negative in the previous report — it is not visible in the ambient
topological monodromy.

**Checks that pass.** The manuscript proves its genus-eight corollary by its own
route; on this reading it is Kuznetsov's equivalence between the Kuznetsov
components of a cubic threefold and of a prime Fano threefold of genus eight,
which forces the same count. Varieties with full exceptional collections —
projective spaces, projective bundles over them, point blowups of those, and the
quintic del Pezzo threefold — have zero residual component and hence count zero,
which is the manuscript's low-dimensional vanishing and the lane's own `V_5`
computation.

**The sharpest available test, and it may refute the identification.** The
lane's provisional calculation gives count zero for the prime Fano threefold of
genus six, the Gushel--Mukai threefold. Its Kuznetsov component is not zero, and
if it is fractional Calabi--Yau of dimension `5/3` like the cubic's, the
identification predicts a nonzero count there. One of the two is wrong. Settling
this is cheap — it is a K-group computation of the same shape as the one above —
and it is the first thing to do before anything is built on Section 4.

## 5. A normalization discrepancy worth resolving

The frame-transport memo records Katzarkov--Kontsevich--Pantev--Yu's Example 6.21
as giving the graded minimal polynomial `S^5 = [3]` for the cubic threefold's
zero atom. Kuznetsov's fractional Calabi--Yau relation for the same category is
`S^3 = [5]`. The two are not interchangeable here: `S^3 = [5]` gives `lam^3 = -1`
and primitive sixth roots, which is the manuscript's count, whereas `S^5 = [3]`
gives `lam^5 = -1` and primitive tenth roots, which is not. Since the memo's
shorter endpoint route leans on that sentence, the exact statement should be
read at the source before it is used. This is a transcription question, not a
mathematical objection to either source.

## 6. Consequence for the blocker, and what to do next

The transport problem needs the count to be locally constant along a connected
family, and the obstruction is that the exponent is a priori a continuously
varying complex number. Under the Section 4 reading it is not: it is read off an
integral lattice with a finite-order operator, hence takes values in a discrete
set, and any continuous family of such values is constant. That is the lightest
possible use of the categorical side — only the eigenvalue constraint, not the
enhanced-atom formalism, and none of the integral-structure definition the
sources defer.

Note what this does and does not say about the framing memo's three-axis trade.
It supports the trade at the level of decorations: discreteness came from the
categorical side, exactly as the trade predicts, and the previous report's
recorded negative shows the formal side cannot supply it. But it also suggests
that only a fragment of the integral structure is needed, which is a weaker
import than the trade's phrasing implies.

Next, in order.

1. Run the genus-six test of Section 4. It either confirms the identification or
   refutes it, and it is a small K-group computation.
2. Resolve the `S^3 = [5]` versus `S^5 = [3]` reading at the source.
3. If the identification survives, restate step (iii) of the atom route in its
   terms: no atom of a smooth projective surface carries a primitive-sixth Serre
   eigenvalue. That is the same question the memo already isolated from
   Katzarkov--Kontsevich--Pantev--Yu's Example 6.21, so the two routes' remaining
   obligations coincide at step (iii) even though the previous report showed they
   differ at step (ii).
4. Delete (H2) from the memo's rigidity section and record Theorem 2 there, and
   carry out the size-`m` extension the scope remark asks for.

## Mystery ledger additions

| ID | Status | Discovery | Owner |
|---|---|---|---|
| C912-M23 | resolved | Standing hypothesis (H2) of the rigidity theorem is forced by the Frobenius structure: the image of the nilpotent part is isotropic and the `z^0` coefficient is anti-self-adjoint, so the entry (H2) assumes to vanish does vanish, pointwise rather than on a germ. | Theorem 2 here; the memo's Section 8 should be updated |
| C912-M24 | confirmed | After the shearing the Poincaré pairing is `z` times a symplectic form, and in rank two `sp(2) = sl(2)`, so the pairing gives exactly `tr R = -1` and can never determine `det R`. | Proposition 3 here; closes the literal form of the pairing-formula proposal |
| C912-M25 | open | The count equals the number of primitive-sixth eigenvalues of the Serre operator on the numerical K-group of the Kuznetsov component: for the cubic threefold that operator has characteristic polynomial `Phi_6` and cube `-I`, giving two. The identification is expected, not proved; the genus-six Gushel--Mukai threefold is a test that may refute either it or the lane's provisional zero. | Section 4 here |
| C912-M26 | open | The memo records `S^5 = [3]` where Kuznetsov's relation for the same category is `S^3 = [5]`; only the latter yields primitive sixth roots. | Section 5 here |

## Replay

```sh
uv run --with sympy python notes/2026-08-15-c912-serre-lattice-check.py
```

```
ac6e9c30a0d73755878c0963afe62c9c2328435f18e749086274409065c05350  notes/2026-08-15-c912-serre-lattice-check.py
81569e4cfde41cd78a8565e0a8e4fdc924c92509fce22be0e3a818ac3a861db1  notes/2026-08-15-c912-serre-lattice-check.out
```

Sections 1 to 3 are proofs and need no replay. Section 4's script takes the
Euler form of the Kuznetsov component as an external input and derives the
Serre operator, its characteristic polynomial and its order; the basis-free
argument in the same script shows the conclusion does not depend on that matrix.
