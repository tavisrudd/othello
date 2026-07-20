# C388: cubic mirror isolator and tower-value reduction

**Date:** 2026-07-19  
**Lane:** `crowns`  
**Verdict:** **THEOREM; THE REGULAR FOUR-GENERATOR SCAR HAS NIMBER ZERO; ONE QUADRATIC SCAR CONTROLS THE EVEN TOWER**

## Result

Fix any C333 mirror-family member over `k=F_q`, with `q>=5` odd.  Retain C370's
ordered projection involutions

\[
S=(s_0,s_1,s_2,s_3),
\]

base residual `B`, quadratic block `Q`, regular left-Cayley block

\[
C=\operatorname{Cay}(\operatorname{PGL}_2(q),S),
\]

and extension residual `R_n` over `K_n=F_(q^n)`.  Then

\[
\boxed{\mathcal G(C)=0}
\]

and, for every `n>=1`,

\[
\boxed{
\mathcal G(R_n)=
\begin{cases}
0,&n\text{ odd},\\
\mathcal G(Q),&n\text{ even}.
\end{cases}}
\]

Thus C370's mod-four parity of regular components disappears after taking game
values.  The entire unresolved extension tower is controlled by one quadratic
block.  This theorem does not evaluate that block.

## Odd-degree mirror lemma

For `a in k^*`, Euler's criterion in `K_n` gives

\[
\chi_{K_n}(a)
=\left(a^{(q-1)/2}\right)^{1+q+\cdots+q^{n-1}}
=\chi_k(a)^n,
\]

because `q` is odd.  When `n` is odd, the three C333 mirror inputs

\[
\delta,\qquad \delta(\delta-4),\qquad
(1+\delta b)^2-4\delta
\]

therefore remain nonsquares in `K_n`.  The first says that
`tau(t)=delta/t` has no fixed projective point.  The latter two are exactly the
discriminants of `tau(t)=s_i(t)` on the two mirror-paired generator orbits, so
no residual vertex is adjacent to its mirror.  All six-arc determinants and
all excluded-locus expressions are nonzero elements of `k`, hence remain
nonzero after scalar extension.

The C333 conjugation identities are identities of base-defined fractional
linear maps:

\[
\tau s_i\tau^{-1}=s_{\pi(i)},\qquad
\pi=(0\ 1)(2\ 3).
\]

They therefore hold over every `K_n`.  For C370's exact deleted set

\[
D_n(S)=\bigcup_{i<j}\operatorname{Fix}(s_js_i),
\]

conjugation sends each displayed fixed set to the fixed set of the
corresponding paired product.  If reordering the paired indices reverses the
product, this causes no convention mismatch: `s_as_b=(s_bs_a)^{-1}`, and a
bijection and its inverse have the same fixed points.  Hence `tau(D_n)=D_n`.
The mirror is consequently a fixed-point-free automorphism of the actual live
uncoloured residual graph, not merely of the undeleted conic.

For completeness, the standard Node--Kayles induction now applies directly.
After a move at `v`, nonadjacency ensures that `tau(v)` has not been deleted.
Playing `tau(v)` deletes the mirror of the first closed neighbourhood, so the
remaining position is again `tau`-invariant with fixed-point-free, nonadjacent
pairs.  Induction on the number of live vertices makes every such position a
P-position.  For a finite impartial normal-play game, this is equivalent to
Sprague--Grundy value zero.  Therefore

\[
\mathcal G(R_n)=0\qquad(n\text{ odd}).
\tag{1}
\]

This argument uses the uncoloured Node--Kayles graph.  The mirror permutes the
four edge colours by `pi`; it need not preserve each colour individually.

## Cubic isolation

C370 uses the left-action Cayley convention: the colour-`i` edge
`h--s_i h` maps under `h |-> hx` to `hx--s_i(hx)`.  Thus its regular orbit is
exactly the same four-generator graph `C` used here, with no right/left or
generator-order change.

In degree three, C370's coefficient is

\[
c_3=\frac{q^2-1}{q^2-1}=1,
\]

and there is no quadratic block.  Hence

\[
R_3\cong B\sqcup C.
\]

C333 proves `G(B)=0`, while (1) gives `G(R_3)=0`.  Sprague--Grundy additivity
for disjoint union therefore yields

\[
0=\mathcal G(R_3)=\mathcal G(B)\mathbin{\mathrm{xor}}\mathcal G(C)
=0\mathbin{\mathrm{xor}}\mathcal G(C),
\]

which proves `G(C)=0`.  The isolation is specific to the full `PGL_2(q)`
sheet: its exact cubic layer is one regular orbit, whereas the corresponding
`PSL_2(q)` layer has two copies and xor cancellation would not determine the
individual nimber.

## Whole-tower reduction

Applying Sprague--Grundy additivity to C370's decomposition gives

\[
\mathcal G(R_n)=
\mathcal G(B)\mathbin{\mathrm{xor}}
[2\mid n]\mathcal G(Q)\mathbin{\mathrm{xor}}
\underbrace{\mathcal G(C)\mathbin{\mathrm{xor}}\cdots
\mathbin{\mathrm{xor}}\mathcal G(C)}_{c_n\text{ copies}}.
\]

Both `G(B)` and `G(C)` vanish.  This proves the displayed odd/even formula
without using the parity of `c_n` and without making any claim about
`G(Q)`.

## Scope, prior art, and trusted boundary

The fixed-point-free/nonadjacent involution induction and Sprague--Grundy xor
law are standard.  C333 supplies the exact mirror discriminants and the base
value; C370 supplies the deleted four-colour extension decomposition and the
left-Cayley compatibility map.  The contribution packaged here is their cubic
one-orbit isolation and the resulting exact tower-value reduction.  It makes
no novelty or priority claim; C370's recorded database and forward-citation
gaps remain open.

This is a proof-level corollary and creates no new computational evidence.
The C333 checker remains the independent finite replay for the coordinate,
deletion, mirror, and full-group inputs.  Neither it nor this report computes
the quadratic scar.  C294 remains paused, and no C294 state cap, experiment,
or value computation was run.
