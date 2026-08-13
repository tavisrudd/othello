# C907 Jordan-biproduct extension obstruction

**Lane:** `clebsch`

**Status:** theorem-grade linear-algebra reduction of the minimal analytic
blowup gate.  Once a nilpotent operator is defined on the primitive-sixth
packet, failure of strict blowup additivity is measured by one explicit
`Ext^1` class.  Associated-grade and formal direct-sum theorems erase exactly
this class.

## The two-block calculation

Let `K=Q(zeta_6)`, and let `(V,N_V)` and `(W,N_W)` be finite-dimensional
nilpotent `K[N]`-modules.  Suppose an enriched comparison identifies the
underlying vector space of a third object with `V direct-sum W`, but its
operator has block form

\[
 N_E=
 \begin{pmatrix}
 N_V&A\\
 0&N_W
 \end{pmatrix},
 \qquad A:W\longrightarrow V.
 \tag{1}
\]

Because the diagonal blocks are nilpotent, every `K`-linear `A` makes (1)
nilpotent.  It makes `E` an extension of `W` by `V` as a `K[N]`-module:
`V` is stable and the quotient operator is `N_W`.  Change the vector-space
splitting by

\[
 P_X=\begin{pmatrix}1&X\\0&1\end{pmatrix}
 \tag{2}
\]

and use the convention `N'_E=P_XN_EP_X^{-1}`.  The off-diagonal block changes
to

\[
 A\longmapsto A+XN_W-N_VX.
 \tag{3}
\]

Consequently the invariant obstruction is

\[
 [A]\in
 \operatorname{coker}\!left(
 d:\operatorname{Hom}_K(W,V)\longrightarrow\operatorname{Hom}_K(W,V),
 \quad dX=N_VX-XN_W
 \right).
 \tag{4}
\]

Equivalently,

\[
 [A]\in\operatorname{Ext}^1_{K[N]}(W,V).
 \tag{5}
\]

The extension with its fixed inclusion of `V` and projection to `W` is a
strict biproduct

\[
 (E,N_E)\cong(V,N_V)\oplus(W,N_W)
 \tag{6}
\]

if and only if `[A]=0`.  If “biproduct” is allowed to forget the formal
component maps and mean only an abstract isomorphism of `E`, this is stronger
than necessary; the blowup comparison is intended to retain those component
maps.  Thus the desired blowup theorem is not a new rank or Jordan-form
calculation: it is the vanishing of (5) for the actual operation-operator
off-diagonal block.

## Exact Jordan obstruction spaces

For indecomposable nilpotent modules

\[
 J_a=K[N]/(N^a),\qquad J_b=K[N]/(N^b),
\]

the standard PID resolution gives

\[
 \operatorname{Ext}^1_{K[N]}(J_b,J_a)
 \cong K[N]/(N^{\min(a,b)}).
 \tag{7}
\]

In particular its `K`-dimension is `min(a,b)`.  Equal primitive-sixth formal
monodromy does not help: it is precisely what permits the two blocks to
interact, while the nilpotent extension space in (7) remains nonzero.

The smallest example is

\[
 0\longrightarrow J_1\longrightarrow J_2
 \longrightarrow J_1\longrightarrow0.
 \tag{8}
\]

Its underlying vector space and associated grades are `K direct-sum K`, but
its class is the generator of `Ext^1(J_1,J_1)=K`.  Iterating two nonzero
classes can join three formal copies into `J_3`.  This is the exact algebra
behind the Silver warning that an associated-graded blowup formula is
insufficient.

The same Ext group is obtained over the local DVR `K[N]_(N)`: localization is
an exact equivalence on finite nilpotent, hence `N`-primary, modules.

## Blowup interpretation

After choosing Iritani's formal direct-sum comparison on the generalized
`zeta_6` sector, a proposed operation operator on a codimension-`r` blowup
has one ambient block and `r-1` shifted center blocks.  For more than two
blocks, isolated pairwise off-diagonal classes are not jointly invariant:
unipotent changes of splitting alter higher blocks by cross terms.  The
correct obstruction is recursive.  For the ordered formal filtration

\[
 0=F_0\subset F_1\subset\cdots\subset F_r=E,
 \qquad F_p/F_{p-1}=M_p,
 \tag{9}
\]

split successively the classes

\[
 [E_p]\in\operatorname{Ext}^1_{K[N]}(M_p,F_{p-1}).
 \tag{10}
\]

Strict blowup additivity with its component maps is equivalent to recursive
vanishing after the preceding splitting choices.  More invariantly, the
whole filtered `K[N]`-module with formal associated graded

\[
 \mathscr J_6(Y)\oplus\bigoplus_{j=1}^{r-1}T^j\mathscr J_6(Z)
 \tag{11}
\]

must split in the abelian category of nilpotent `K[N]`-modules.

Iritani's basepoint lower-left restriction term is an off-diagonal block of a
QDM comparison **gauge**, not yet of the intrinsic operation operator `N`.
It becomes an analytic lead only after `N` is defined, the comparison is
projected to the generalized `zeta_6` sector, and the induced off-diagonal
`N` block is extracted.  Its disappearance in the double associated graded
does not say that (10) vanishes.  The correct computation is therefore:

1. define the intrinsic nilpotent `N`;
2. project the comparison to the generalized primitive-sixth sector;
3. extract the recursively filtered `K[N]` extension;
4. reduce each successive class modulo the appropriate Sylvester image; and
5. check that the filtered module splits.  Chosen splittings need not satisfy
   a separate coherence theorem for one fixed weak-factorization
   contradiction, though presentation-independent naturality requires the
   resulting objects to agree `N`-linearly across exchange diagrams.

## Toric-pilot boundary

Both `P^5` and `P^3` have empty primitive-sixth packets.  Therefore the toric
model `Bl_(P^3)P^5` projects to zero in the minimal generalized-`zeta_6`
Jordan category.  Its four residual `P^3` thimbles and `1-H` operator live in
an ordinary residual Stokes block, not in `mathscr J_6`.  The pilot can
calibrate an external geometric source of a relative operator, but it cannot
test a cyclotomic Jordan extension or even a nonzero center operator after
formal forgetting.

A genuine minimal-Silver test begins with a center having nonzero
primitive-sixth support, such as `Bl_X P^5` for a smooth cubic threefold.  To
test ambient--center interaction rather than only center normalization, both
blocks must be nonzero (or higher codimension must supply interacting shifted
copies).

This corrects the temptation to read a successful toric residual comparison
as evidence for the minimal strict blowup theorem.  It is valuable for the
stronger Stokes/Gamma programme but is invisible to the cyclotomic Jordan
packet.

## Minimal positive theorem

For the conditional Silver theorem it is sufficient to prove:

> the whole generalized primitive-sixth eigenspace has an intrinsic
> all-Tate-shifts operation operator `N`, the endpoint contains `J_3`, every
> center is `J_3`-free, and every smooth blowup comparison has a recursively
> split filtered `K[N]`-module as above.

No Euler pairing, integral lattice, or directed Stokes marking occurs in this
statement.  Such structures may provide a geometric way to define `N` and
kill `[A]`, but the logical output consumed by weak factorization is exactly
the split module (6).

## EJ/TT and mystery ledger

- **EJ:** replace “strict analytic functoriality” by the computable quotient
  class `[A] mod (N_VX-XN_W)`.  This is the one datum associated grades erase.
- **TT:** triangularity is not splitting.  When cyclotomic spectra coincide,
  the Sylvester operator is not invertible and the extension space has the
  positive dimension (7).
- **Settled:** the necessary-and-sufficient linear obstruction to a strict
  Jordan biproduct and the precise limit of the toric pilot.
- **Open:** define intrinsic `N`, compute the successive classes (10), and
  prove recursive splitting for arbitrary smooth blowups.
