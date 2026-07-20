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

## Direct Cayley-normalizer proof

The regular scar has a second proof that removes the cubic layer from its value
calculation and exposes the group-theoretic mechanism.

Let `H` be a finite group, let `S subset H setminus {1}` be inverse-closed, and
use the left-Cayley convention with edges `h--s h`.  Suppose that an involution
`u in H` satisfies

\[
uSu^{-1}=S,\qquad u\notin S.
\tag{2}
\]

Then left multiplication `L_u(h)=u h` is a graph involution: an edge
`h--s h` maps to

\[
u h\;--\;u s h=(u s u^{-1})(u h).
\]

It has no fixed vertex because `u h=h` would imply `u=1`, and it pairs no
adjacent vertices because `u h=s h` would imply `u=s in S`.  The standard
Node--Kayles involution theorem therefore gives

\[
\mathcal G(\operatorname{Cay}_L(H,S))=0.
\tag{3}
\]

For C333, `H=PGL_2(q)`, `u=tau`, and
`tau S tau^{-1}=S` with colour permutation `(0 1)(2 3)`.  The exact
nonadjacency discriminants in C333 in particular exclude `tau=s_i` for every
generator.  Thus (3) proves `G(C)=0` directly.  Because the four distinct
involutions generate `H`, these are connected four-regular Cayley graphs of
order `q(q^2-1)`.  The direct regular-block statement is characteristic-free;
odd characteristic enters the C333 geometric family and its full residuals,
not the Cayley lemma.

## Cubic isolation and cross-check

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

which independently proves `G(C)=0` and checks that C370's abstract regular
block uses the same Cayley convention as (3).  The isolation argument is
specific to the full `PGL_2(q)` sheet: its exact cubic layer is one regular
orbit, whereas the corresponding `PSL_2(q)` layer has two copies and xor
cancellation would not determine the individual nimber.  The direct
normalizer proof does not need cubic uniqueness.

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

## Arc--Kayles transfer

The same normalizer gives a free result for Arc--Kayles, where a move chooses
an edge and deletes its two endpoints.  If `e={h,s h}`, then

\[
L_u(e)=\{u h,u s h\}.
\]

An intersection between these two edges would force `u` to be `1`, `s`, or
`s^{-1}`.  All three possibilities are excluded by (2) and inverse-closure.
Thus every edge is paired with a vertex-disjoint edge.  Responding to `e` with
`L_u(e)` is legal, and deleting both endpoint pairs preserves the involution.
Induction gives

\[
\mathcal G_{\rm Arc}(\operatorname{Cay}_L(H,S))=0.
\tag{4}
\]

More generally, the fixed-point-free/nonadjacent involution on every odd-degree
`R_n` pairs each edge with a vertex-disjoint mirror edge: an endpoint shared by
`e` and `tau(e)` would give either a fixed vertex or a vertex adjacent to its
mirror.  Hence

\[
\mathcal G_{\rm Arc}(R_n)=0\qquad(n\text{ odd}).
\tag{5}
\]

This supplies an explicit algebraically certified infinite Arc--Kayles
P-family, but it does not decide the computational complexity of Arc--Kayles
or recognize arbitrary symmetry certificates.

## Scope, prior art, and trusted boundary

The fixed-point-free/nonadjacent Node--Kayles involution theorem is standard.
Brown, Fiorini, Manzano-Ruiz, Waechter, Daugherty, Maldonado, Rainville, and
Wong, *Nimber Sequences of Node-Kayles Games*, Journal of Integer Sequences 23
(2020), Theorem 4, state exactly this graph lemma and credit an earlier
appearance to Duchene--Gravier--Mhalla.  The inspected source portions were the
game conventions on page 1, Theorem 4 and proof on page 11, and the future-work
discussion on pages 41--42:

`https://par.nsf.gov/servlets/purl/10141270`.

Burke, Dailly, and Oijid, *Complexity and algorithms for Arc-Kayles and
Non-Disconnecting Arc-Kayles*, arXiv:2404.10390v2 (2025), record that the
general Arc--Kayles complexity remains open and that recognizing their general
symmetry-based sufficient condition is GI-hard.  The inspected portions were
the abstract, introduction, symmetry section, and conclusion:

`https://arxiv.org/abs/2404.10390`.

C333 supplies the exact mirror discriminants and base value; C370 supplies the
deleted four-colour extension decomposition and left-Cayley compatibility map.
The contribution packaged here is their cubic one-orbit isolation, the direct
Cayley-normalizer specialization, the Arc--Kayles transfer, and the exact
tower-value reduction.  No ownership search for the Cayley or Arc specialization
has been closed, and this report makes no novelty or priority claim.  C393 owns
the bounded post-Clebsch recognition and external-boundary gate; it must stop if
the result is only the standard involution theorem in Cayley notation.

This is a proof-level corollary and creates no new computational evidence.
The C333 checker remains the independent finite replay for the coordinate,
deletion, mirror, and full-group inputs.  Neither it nor this report computes
the quadratic scar.  C294 remains paused, and no C294 state cap, experiment,
or value computation was run.
