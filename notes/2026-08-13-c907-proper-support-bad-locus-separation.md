# C907 proper-support bad-locus separation

**Lane:** `clebsch`

**Status:** theorem-grade compression of the whole-proper-fibre gate.  Several
proper modifications may be used simultaneously: the downstairs
vanishing-cycle support is contained in the intersection of the proper images
of their bad loci.  For the C907 exterior and two ratio models, the remaining
analytic audit is therefore one closed-set inclusion, not a common fan and not
an all-chart gluing theorem.

## The separation lemma

Let `j:U -> X` be an open immersion, let `f:X -> C` be a regular or
holomorphic function, and put

\[
 K=j_!A_U,
 \qquad A=\mathbf Z[1/6].
 \tag{1}
\]

For a finite index set `I`, suppose

\[
 p_i:Y_i\longrightarrow X
 \tag{2}
\]

is proper over the target of `f`, with `p_i^{-1}(U) -> U` an isomorphism.
Write `j_i:U -> Y_i`, `K_i=j_{i!}A_U`, and

\[
 \Phi=\phi_f K,
 \qquad
 \Phi_i=\phi_{f\circ p_i}K_i.
 \tag{3}
\]

Then proper-modification descent and proper pushforward for vanishing cycles
give

\[
 Rp_{i*}K_i\simeq K,
 \qquad
 Rp_{i*}\Phi_i\simeq\Phi.
 \tag{4}
\]

Let `S_i=Supp(Phi_i)`.  Since a proper direct image is supported on the
proper image of the source support,

\[
 \boxed{
 \operatorname{Supp}(\Phi)
 \subseteq
 \bigcap_{i\in I}p_i(S_i).}
 \tag{5}
\]

In particular, if a prescribed closed core `C subset X` satisfies

\[
 \bigcap_{i\in I}p_i(S_i)\subseteq C,
 \tag{6}
\]

then the displayed vanishing-cycle stalks vanish on `X setminus C`.  If the
same statement is run uniformly for every translated function `f-u`, then
`K` is `f`-locally acyclic there.

The useful chartwise version replaces `S_i` by any closed bad locus `B_i`
known to contain it.  If `Q_i=Y_i setminus B_i` is open and
`Phi_i|Q_i=0`, then

\[
 \bigcap_{i\in I}p_i(B_i)\subseteq C
 \quad\Longrightarrow\quad
 \operatorname{Supp}(\Phi)\subseteq C.
 \tag{7}
\]

### Proof

The first identity in (4) is the usual extension-by-zero identity for a
proper modification which is an isomorphism on `U`.  The second is the proper
pushforward theorem for vanishing cycles.  For every complex `E` and proper
map `p`,

\[
 \operatorname{Supp}(Rp_*E)\subseteq p(\operatorname{Supp}E).
 \tag{8}
\]

Applying (8) to each expression for `Phi` in (4) and intersecting proves
(5).  Since `S_i subset B_i`, (7) follows.  Properness makes each `p_i(B_i)`
closed.  Thus, at a point outside that image, the entire inverse image of a
small neighborhood lies in `Q_i`; this is exactly the whole-fibre
local-acyclicity quantifier.  \(\square\)

The same proof applies to the iterated object used in C907, for example

\[
 \Psi=\psi_\delta\phi_{L-u}(j_!A),
 \tag{9}
\]

provided the maps are proper over the two parameter coordinates and `B_i` is
defined from the support of this iterated complex.  Alternatively, it is
enough that `phi_(L-u)(K_i)` vanish on an open `Q_i` across `delta=0`, because
open restriction then makes its nearby cycles vanish there.  The controlled
constructibility/noncharacteristicity certificate must concern the actual
extension-by-zero complex.  A unit derivative on a selected boundary stratum
is only an input to that certification, not a substitute for it.

## Exact C907 target

Let `X_0` be the coarse multihomogeneous Cartier closure.  The minimum proposed
construction uses the direct exterior model and one simultaneous projective
ratio graph recording both residual ends and their product:

\[
 p_{\rm ext}:H_{\rm ext}\to X_0,
 \qquad
 p_{\rm rat}:H_{\rm rat}\to X_0
 \tag{10}
\]

These maps still have to be serialized against the same `X_0`; diagonal
strict closure supplies them if no direct morphism is already present.  They
are proper and become isomorphisms on the same dense graph.  Choose closed bad
loci containing the support of the relevant iterated value-cycle complexes.
The whole analytic coverage gate is the single inclusion

\[
 \boxed{
 p_{\rm ext}(B_{\rm ext})
 \cap p_{\rm rat}(B_{\rm rat})
 \subseteq C_{\rm Morse},}
 \tag{11}
\]

where `C_Morse` is the four protected residual sections.

This formulation allows different models to fail over different coarse
subsets.  No one model must be controlled everywhere, and no common toroidal
refinement is required.  It also permits replacing a coarse complement
`B_i=H_i setminus Q_i` by the smaller actual support `S_i`; derived
cancellation on a forced exceptional divisor can only help (11).

The already proved pointwise image cover

\[
 X_0\setminus C_{\rm Morse}
 \subset p_{\rm ext}(Q_{\rm ext})\cup p_{\rm rat}(Q_{\rm rat})
 \tag{12}
\]

does not imply (11).  Formula (12) says that one good lift exists.  Formula
(11) says that, in at least one fixed model, no bad lift exists anywhere in
the proper fibre.  The forced `(h,v)` exceptional is the concrete witness to
the difference.

The next finite computation is therefore sharply delimited:

1. describe `B_ext` and `B_rat` as closed unions of unresolved ratio,
   exterior, and noncharacteristic strata;
2. compute their images in the coarse coordinates of `X_0`;
3. prove (11), or exhibit a coarse point outside the four sections lying in
   both images.

Only after (11) is proved do the compact-support-to-rapid-decay comparison,
four-thimble labels/pairing, and Gamma seed become the live analytic steps.

## EJ/TT and mystery ledger

- **EJ:** proper descent can be run through several modifications at once.
  The intrinsic bad support lies in the intersection, not the union, of their
  proper bad images.
- **TT:** good-chart coverage has the wrong quantifier.  The invariant object
  asks whether every model can be bad over the same coarse point; this is a
  closed-image intersection problem.
- **Settled:** the exact multi-model descent lemma and the minimum sufficient
  C907 inclusion (11).
- **Open:** compute the two bad images and their intersection; verify the
  actual-boundary microsupport/control hypotheses on the chosen good loci;
  then carry labels and pairing through the tame comparison.  No further fan
  enumeration is called for.
