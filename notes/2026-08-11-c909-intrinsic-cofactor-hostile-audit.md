# C909: intrinsic etale-graph cofactor saturation — hostile audit

Date: 2026-08-11  
Status: elementary graph theorem proved at the lattice level; no manuscript,
PDF, mirror, Lean, or reviewer-dossier edit

## Verdict

The squarefree graph-slope theorem has a clean coordinate-free form, but its
intrinsic object is a **polarized elliptic-power presentation**, not the bare
ppav and not an arbitrary symplectic chart of its finite kernel.

Let `p` be prime, let `E` be non-CM, and let
`f : E^g -> (A,Theta)` be a polarized elementary `p`-isogeny: the pullback
polarization is `p q`, for a unimodular symmetric coefficient form `q` on a
rank-`g` lattice `M`, and its kernel is a maximal isotropic

\[
 K\subset V\otimes_{\mathbf F_p}M_p,\qquad
 V=H_1(E,\mathbf F_p).
\]

Put

\[
 P_A^{g-1}=\langle D_1\cdots D_{g-1}:D_i\in\operatorname{NS}(A)\rangle
 \subset H^{2g-2}(A,\mathbf Z),\qquad
 c_A=\Theta^{g-1}/(g-1)!.
\]

Call `K` an **etale elliptic graph** if there is a line `ell` in `V` for
which `K` is transverse to `ell tensor M_p`, and, after choosing a symplectic
pair `(e,f)` with `ell=<f>`,

\[
 K=\{e\otimes x+f\otimes t x:x\in M_p\}
\]

for a `q`-self-adjoint endomorphism `t` such that

\[
 \mathcal E_K:=\mathbf F_p[t]
\]

is finite etale.  Equivalently, the minimal polynomial of `t` is squarefree.

> **Intrinsic etale-graph cofactor-saturation theorem.**  If the kernel of a
> polarized elementary elliptic-power isogeny is an etale elliptic graph,
> then `c_A` belongs to `P_A^{g-1}`.  In particular the primitive minimal
> class is an integral linear combination of ordinary products of `g-1`
> divisor classes.

This is exactly the positive theorem in
`2026-08-11-c904-semisimple-graph-slope-primitivity.md`, repaired below so
that the coefficient form, the unramified descent, and the allowable
coordinate changes are explicit.

## What is, and is not, chart-independent

The etale algebra `mathcal E_K` is independent of the choice of transverse
**elliptic ruling**.  Indeed, replacing `(e,f)` by another symplectic basis
for which the graph remains transverse replaces `t` by a fractional-linear
transform; in one convention,

\[
 t'=(a t-b)(d-c t)^{-1}.
\]

The inverse transform expresses `t` rationally in `t'`, so
`F_p[t]=F_p[t']`.  Coefficient isometries merely conjugate this algebra.
Thus finite-etaleness is an invariant of the marked elliptic-power
presentation `(E,M,q;f)`.  Over a splitting field its primitive idempotents
are self-adjoint, which is the invariant content of the familiar scalar
eigenblock calculation.

It is **not** invariant under arbitrary symplectic changes of a basis of
`V tensor M_p`.  At `p=2`, take the horizontal graph `t=0` in rank three and
apply the symplectic shear that changes the displayed slope to

\[
 N=\begin{pmatrix}0&0&1\\0&0&1\\1&1&0\end{pmatrix}.
\]

This `N` is symmetric and regular nilpotent, hence has nonsquarefree minimal
polynomial, whereas `0` is squarefree.  The shear is not induced by a change
of the rank-two elliptic factor together with a coefficient isometry.  If all
such charts were allowed, every Lagrangian could be made horizontal and the
condition would falsely imply primitivity for the explicit defective
`p=3, g=4` graph of
`2026-08-11-c904-prime-gluing-divided-power-obstruction.md`.

Consequently:

- `P_A^{g-1}`, `c_A`, and the defect class in the saturation quotient are
  invariants of `(A,Theta)`;
- etale-graph is intrinsic to the *presented isogeny* and its elliptic tensor
  structure; and
- no squarefree-slope condition is intrinsic to an unmarked ppav or to a
  bare finite symplectic Lagrangian.

## Proof without trace denominators

The local statement works over every finite unramified coefficient ring:
an unramified DVR over `Z_p`, its quotient `W_n(k)`, or a finite product of
such rings.  It is enough to prove it after one finite unramified faithfully
flat extension `R -> R'` that splits `mathcal E_K` in the residue field.

Let `M_R'` be the extended coefficient module.  The squarefree hypothesis
gives

\[
 M_{k'}=\bigoplus_\lambda V_\lambda,
 \qquad t|_{V_\lambda}=\lambda.
\]

Self-adjointness gives
`(lambda-mu)q(v,w)=0`; distinct roots differ by a unit, hence these spaces
are pairwise orthogonal.  Each is nondegenerate.  Lift a basis of one
`V_lambda`; its Gram matrix remains unimodular, so its orthogonal complement
gives an exact summand.  Induction yields

\[
 M_{R'}=\mathop{\perp}_\lambda L_\lambda,
 \qquad q=\mathop{\perp}_\lambda B_\lambda,
\]

with every `B_lambda` unimodular.  This argument uses inversion only of a
unimodular Gram matrix; it is valid at two, including a block whose reduction
is alternating.

There is no need to lift or diagonalize a geometric endomorphism.  The graph
overlattice depends only on the residue slope.  After lifting the coefficient
basis, one may choose a block-scalar Teichmuller representative for that
residue slope; changing a lift by `pS` merely changes the graph basis by an
integral unipotent shear.

In a non-orthonormal block basis, the relevant coefficient matrices are
**`q`-self-adjoint endomorphisms**, equivalently symmetric bilinear forms;
they are not arbitrary transpose-symmetric matrices.  For every block
supported such endomorphism `D`, the descended coefficient `pD` satisfies
the graph integrality congruence because it commutes with the scalar residue
slope.  Thus the complete divisor lattice contains

\[
 p\bigoplus_\lambda\operatorname{Sym}_q(L_\lambda).
 \tag{1}
\]

The integral mixed-adjugate identities now fill the cofactor one target
block at a time.  Diagonal rank-one forms on each non-target block give its
determinant with coefficient one.  On a target block, products of all but
one diagonal form give the diagonal cofactor entries, and replacing one pair
by the symmetric off-diagonal form gives the off-diagonal entries, again with
coefficient `+/-1`.  Contracting with the integral entries of
`adj(B_lambda)` gives the target block of

\[
 \operatorname{cof}\!\left(\mathop{\perp}_\lambda pB_\lambda\right).
\]

Summing over targets gives the whole cofactor.  There is no factorial,
residue-degree, trace, or division by two: this is an ordinary product of
the divisor forms in (1).  The standard determinant/polarization dictionary
identifies this cofactor with the pullback of `c_A`.

For descent, write `P` for the local image of the product map and `H` for the
ambient integral Hodge lattice.  Flat base change commutes with the image of
that finite multilinear map, so the construction says

\[
 (c_A\bmod P)\otimes1=0\quad\hbox{in}\quad(H/P)\otimes_R R'.
\]

Faithful flatness reflects zero.  Hence `c_A` is already in `P`.  This is the
right descent proof even when `[R':R]` is divisible by `p`; trace averaging
would introduce precisely the forbidden residue-degree denominator.  Away
from `p` the isogeny is an integral local isomorphism, and membership in a
finitely generated lattice is local, proving the global theorem.

## Squarefree is sufficient, not necessary

Squarefree describes the zero-radical, etale stratum.  It cannot be a
necessary criterion for zero defect.  A completely structural example is

\[
 p=5,\quad g=3,\quad u=(1,2,0)^t,\quad t=uu^t\in\operatorname{Sym}_3(\mathbf F_5).
\]

Since `u^t u=1+4=0`, `t` is nonzero and `t^2=0`, so its minimal polynomial
is `X^2`.  Nevertheless `p>g-1`, so the prime-support/factorial-threshold
theorem gives `c_A in P_A^2` for every prime-five graph gluing, including
this one.  Thus nilpotence need not create a defect.

Nor does passage to primary semisimplification repair necessity: the
semisimplification of every primary block is etale, including the regular
nilpotent `p=3, g=4` block whose minimal class has exact order three.
Therefore “squarefree after semisimplification” is automatic and is not even
a sufficient test.  The missing necessary-and-sufficient invariant is the
carry-enhanced, degree-sensitive `p`-typical complex of C908; the regular
primary ghost calculation cannot yet be substituted for it.

## Best second application: a genuinely nonsplit unramified family

For every `g>=3`, at `p=2` take

\[
 t_g=
 \begin{pmatrix}0&1\\1&1\end{pmatrix}\oplus0_{g-2}
 \in\operatorname{Sym}_g(\mathbf F_2).
\]

Its minimal polynomial is
`X(X^2+X+1)`, so the intrinsic kernel algebra is

\[
 \mathcal E_K\simeq\mathbf F_2\times\mathbf F_4.
\]

The corresponding graph kernel is Lagrangian and is nonsplit over
`F_2`; it splits only after the unramified coefficient extension with residue
field `F_4`.  The theorem yields

\[
 \Theta^{g-1}/(g-1)!\in P_A^{g-1}
\]

for this infinite family.  This is the best immediate application because it
uses the multiple-eigenvalue scalar block, the nonsplit etale factor, and the
trace-free unramified descent; it is not a scalar-block restatement of the
six-axis example.

## Hostile-audit boundary

The theorem is now safe only with the following scope.

1. It concerns elementary prime-`p` graph kernels.  It does not establish the
   broader `p^a` Jordan-block theorem in
   `2026-08-11-c909-etale-jordan-kernel-saturation.md`; that untracked draft
   needs a separate normalization and kernel-integrality audit.
2. The proof requires the coefficient-form version of symmetry described
   above.  Reusing the phrase “`D` symmetric” after a non-orthonormal
   splitting is insufficient unless it means `q`-self-adjoint.
3. The conclusion is membership in the ordinary degree-`g-1` product
   lattice, not a computation of its full saturation quotient and not a
   theorem about every cohomological degree.
4. The graph-transversality condition is real.  It is not known for an
   arbitrary maximal isotropic gluing, and no all-Lagrangian conclusion is
   licensed.
5. A nilpotent radical is neither a necessary nor a sufficient defect test.
   The required converse must retain integral carries, bilinear type, and the
   cohomological degree.

## EJ/TT closeout and mystery ledger

- **Settled:** finite unramified splitting is harmless integrally; faithful
  flat descent replaces every trace argument and works when the residue degree
  is divisible by `p`.
- **Settled:** the correct invariant is the self-adjoint finite-etale slope
  algebra of a marked elliptic-power isogeny, not an arbitrary graph matrix.
- **Settled:** squarefree is strictly sufficient, with an explicit
  nonsquarefree primitive family.
- **Open:** an all-Lagrangian, presentation-independent `p`-typical defect
  complex and its full elementary divisors.
- **Open:** the open-chain/marked-cycle straightening lemma needed even for
  cyclic-primary regular blocks; see
  `2026-08-11-c904-regular-primary-ghost-bridge-reduction.md`.
- **Open:** whether natural indecomposable non-Clebsch families realize the
  same etale packet while also supplying a second geometric separation
  detector.

**Vibe:** the semisimple theorem survives the hostile audit, but it is a
sharp zero-radical criterion, not an intrinsic classification of all gluings.

## Addendum: red-team of the proposed higher-exponent extension

The separate untracked draft
`2026-08-11-c909-etale-jordan-kernel-saturation.md` proposes the same
argument for a coefficient block `p^a B` over `R_a=Z_p/p^a`.  Its conclusion
is plausible and the cofactor calculation is valid **conditional on its
blockwise graph hypotheses**, but four repairs are required before it can be
called a theorem.

### 1. Exact graph-integrality normalization

For a graph kernel over `R_a`, choose a lift `T=T^dagger` and use the graph
basis

\[
 \begin{pmatrix}p^{-a}I&p^{-a}T\\0&I\end{pmatrix}.
\]

If `D=D^dagger` is a `B`-self-adjoint endomorphism, the source coefficient
is the symmetric bilinear matrix `p^a B D`, not `p^aD`.  Direct multiplication
then has upper-left block

\[
 \frac{BDT-T^TBD}{p^a}=B\frac{[D,T]}{p^a}.
\]

Hence the exact integrality condition is

\[
 [D,T]\equiv0\pmod {p^a},\qquad D=D^\dagger.
\]

The draft writes `DT-TD` for a transpose-symmetric coefficient `D`, which is
correct only after an orthonormalization `B=I`.  This is a notation/proof
gap, not a counterexample: with the `B`-self-adjoint convention its claimed
block-supported lattice and mixed-adjugate proof go through.

The graph itself must be a maximal isotropic `R_a`-submodule, not merely a
graph after reduction mod `p`.  Equivalently, `T` must be self-adjoint modulo
`p^a`; this is what makes the overlattice generated by
`p^{-a}(x,Tx)` integral and self-dual.

### 2. Finite-etale algebra is genuinely higher-order data

For `a>1`, squarefreeness of the reduction is not equivalent to
`R_a[T]` being finite etale.  For example, in `R_2=Z/p^2`, let

\[
 T=p\begin{pmatrix}0&1\\1&0\end{pmatrix}.
\]

Then `T=T^t`, its reduction is zero and so has squarefree minimal polynomial
`X`, but

\[
 R_2[T]=\{rI+sT:r,s\in R_2\}
\]

contains the nonzero `p`-torsion summand generated by `T`; it is not flat and
therefore not etale over `R_2`.  Thus the higher theorem needs the literal
finite-etale hypothesis, or an equivalent flat monogenic separability
criterion, not merely the elementary squarefree condition.

After a finite unramified extension `R_a -> R'_a`, a finite-etale algebra
does split as a product of copies of `R'_a`, and the primitive idempotents are
self-adjoint.  The phrase “`T` acts by a scalar on each factor” is sufficient
only when those factors mean the primitive factors of `R_a[T]`; scalar action
on an arbitrarily chosen module decomposition does not itself prove that the
generated algebra is etale.

### 3. Mobius invariance is correct, with its exact domain

Let the two transverse rulings be related by `SL_2(R_a)`.  When both graph
descriptions exist, the denominator in the fractional-linear formula is an
invertible endomorphism of `M_a`.  By Cayley--Hamilton its inverse is a
polynomial in `T` (its determinant is a unit), so

\[
 R_a[T']=R_a[T].
\]

Finite-etaleness is consequently invariant under changes of transverse
**elliptic** ruling and coefficient isometries.  This proves the draft's
Mobius claim over the nonreduced ring `R_a`; no field argument is needed.
It does not extend to arbitrary symplectic charts mixing the coefficient and
elliptic factors, exactly as in the elementary counterexample above.

### 4. The root-weight paragraph is conditional as written

For

\[
 G_N=NI_{N-1}-J
\]

and `p^a || N`, the all-ones line is indeed a unit orthogonal summand and its
orthogonal complement has coefficient scale `p^a` with unimodular residual
form: division by `N-1` is integral at `p`.  Thus the local algebra supports
the proposed application.

But the sentence “every principal quotient whose defect kernel is regular
etale” assumes the decisive hypothesis rather than constructing or classifying
such kernels.  It is broader than the cubic application only as a conditional
criterion.  To obtain a genuine infinite family, the draft must additionally
specify, at every `p^a || N`, a maximal isotropic scalar (or nonscalar etale)
graph on the scaled summand, verify self-duality of the assembled global
kernel by Chinese remaindering, and identify the resulting principal quotient
with the root-weight polarization.  Scalar graphs should supply an existence
family after that check; they do not by themselves establish a new
non-scalar/root-weight classification.

### Higher-exponent verdict

With `B`-self-adjoint normalization, literal finite-etaleness over `R_a`, a
block-respecting maximal-isotropic kernel, and the stated faithful-flat
descent, the higher-exponent cofactor argument is structurally sound.  It is
not yet an unconditional root-weight theorem, nor an all-Lagrangian theorem,
and it must not be advertised as a consequence of squarefree reduction.
