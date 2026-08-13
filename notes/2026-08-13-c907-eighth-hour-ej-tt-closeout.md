# C907 eighth-hour EJ/TT closeout

**Lane:** `clebsch`

**Status:** eight-hour stopping report.  The unconditional `m=2` theorem is
not landed.  The work did land a minimal conditional Silver theorem, exact
rank and extension obstructions, a codimension-two/higher-codimension
dichotomy, and a new line-bundle-framed mechanism that would close both
Silver gates after one precise cyclotomic realization and base-ideal
transport theorem.

## Human structural compression

The endpoint is no longer best viewed as three formal cubic copies.  It is a
single nilpotent Jordan string

\[
 J_3=K[N]/(N^3),\qquad K=\mathbf Q(\zeta _6).
\]

Silver needs only three statements:

1. the whole generalized \(\zeta _6\)-packet has an intrinsic \(N\);
2. \(X\times\mathbf P^2\) contains \(J_3\), while no smooth threefold center
   does; and
3. blowup comparisons are split \(K[N]\)-biproducts.

Finite nilpotent \(K[N]\)-modules are Krull--Schmidt, so those statements feed
positive weak factorization directly.  Pairings, Gamma markings, and directed
Stokes flags are possible construction tools but are not consumed by the
final cancellation.

## High-value theorems landed

1. **Cyclotomic admission.**  A \(J_3\) requires three dimensions in one
   generalized \(\zeta _6\)-space, hence \(\nu _6\ge6\).  Every computed
   \(\nu _6\le2\) carrier class is conditionally discharged; a rank-six
   hard-Lefschetz/self-dual countermodel proves the threshold sharp from
   formal data.
2. **Exact strictness obstruction.**  A two-block comparison is split exactly
   when its off-diagonal class vanishes in
   \(\operatorname{Ext}^1_{K[N]}(W,V)\); multi-block comparisons split by
   successive classes in \(\operatorname{Ext}^1(M_p,F_{p-1})\).  Formal
   associated grades erase precisely this datum.
3. **Pilot ladder.**  The toric \(\mathbf P^3\subset\mathbf P^5\) example is
   zero after cyclotomic projection.  \(\operatorname{Bl}_X\mathbf P^5\) is
   nonzero but one-dimensional, so (N=0) is forced.  The first possible
   ungraded extension is
   \(\operatorname{Bl}_{X\times p}(X\times\mathbf P^2)=X\times\mathbb F_1\).
4. **Codimension-two exchange.**  Under the proposed relative-projective
   Kronecker-sum rule,
   \(J_2\otimes J_2=J_3\oplus\mathsf T J_1\), including the correct Tate
   degrees.  This is an algebraic compatibility, not yet the geometric
   component-map theorem.
5. **Silver/Gold separation.**  For \(m\ge3\), the two presentations of
   \(X\times\operatorname{Bl}_p\mathbf P^m\) give
   \(J_{m+1}\oplus J_1^{m-1}\) versus
   \(J_m\otimes J_2=J_{m+1}\oplus J_{m-1}\).  Thus a naive ungraded strict
   all-codimension sum is incompatible with that projective rule.  Silver's
   only nonzero fivefold center has codimension two; Gold needs a non-split
   exceptional-string functor or a different projective operator.
6. **Line-bundle-framed mechanism.**  For \(f:Y\to\mathbf P^2\), tensor by
   \(L=f^*\mathcal O(1)\) gives \(N_L=1-\tau_L\).  Projection formula makes
   \(N_L\) exactly block diagonal under Orlov blowups over \(\mathbf P^2\),
   and its endpoint is \(J_3\).  On a threefold center,
   \(N_L^2=i_*\mathbb Li^*\) through a generic curve fibre, or is zero when
   the image has dimension at most one.  Therefore an exact cyclotomic
   projector compatible with Orlov maps, products, and Gysin support would
   close strictness and carrier exclusion simultaneously on every relative
   arrow.

## EJ: what became newly reachable

- The likely operator is elementary after framing: tensor by the pulled-back
  base hyperplane.  The hard analytic datum is no longer “recover all Stokes
  matrices,” but construct an exact Gamma/cyclotomic projector preserving
  Orlov idempotents and support maps.
- Once a model maps to \(\mathbf P^2\), its later relative arrows and centers
  are governed by the
  same projection-formula/Koszul mechanism.  The uncontrolled information is
  localized to resolving the three-section base ideal of the rational map
  \(\mathbf P^5\dashrightarrow\mathbf P^2\).
- The higher-codimension exchange predicts the correct Gold repair: shifted
  exceptional copies must be joined by a relative Lefschetz operator before
  forgetting the grading.

## TT: what must not be inferred

- A stable subquotient of block-diagonal \(K_0\) can mix the blocks.  The
  cyclotomic bridge must be an exact additive projector/functor preserving
  the Orlov component maps.
- Ordinary projective-bundle QDM additivity does not prove the
  Kronecker-sum operator for a twisted bundle; Chern classes may alter the
  extension.
- The base-ideal localization is not smaller.  Linear projection from
  \(\mathbf P^2\subset\mathbf P^5\) resolves to a \(\mathbf P^3\)-bundle
  whose raw hyperplane operator already has \(N^2\ne0\), although its surface
  center has zero packet.  The exceptional correction \(\mathcal O(-E)\)
  moves Orlov's \(j=-1\) block into \(j=0\).  Moreover a three-section base
  ideal can contain repeated infinitely-near cubic-threefold centers.  A true
  ungraded moving-frame splitting/no-cross-stage-extension theorem remains.
- The line-bundle lemma is exact on rational \(K_0\), not by itself on the
  quantum packet or an arbitrary numerical quotient.
- The four toric residual Morse germs determine rank, not the directed
  \((4,10,20)\) matrix.  The separate toric leaf still needs a full tame
  compact/ordinary pairing excision.

## Mystery ledger

- **Settled:** minimal Silver category and cancellation; \(\nu _6\ge6\)
  admission; exact extension obstruction; meaningful pilot hierarchy;
  codimension-two algebraic exchange; higher-codimension no-go; exact
  \(K_0\) line-bundle strictness and curve-supported square.
- **Open, owning next pass:** exact Gamma/cyclotomic projector compatible with
  Orlov and Gysin maps; projective/Kunneth endpoint compatibility; transport
  of the movable hyperplane through the base-ideal Rees resolution; universal
  threefold support-local square vanishing; presentation independence.
- **Separate high-value leaf:** oriented tame residual-pair identification for
  the toric \(\mathbf P^3\) theorem.
- **No finite bookkeeping mystery remains:** further mask enumeration, Fano
  tables, formal rank counts, Euler Grams, or root permutations cannot supply
  the missing projector or Rees transport.

## Highest-EV next theorem

Construct an exact cyclotomic moving-frame packet for principalizations of
three-section linear systems.  Prove its successive codimension-two Orlov
extensions split as ungraded \(K[N]\)-modules with no cross-stage joining,
and that every threefold base-center term is \(J_3\)-free.  Combined with
relative weak factorization and the line-bundle lemma, this is the shortest
visible route to the actual `m=2` theorem.  The cubic base-ideal example shows
that the theorem genuinely contains the universal carrier problem: it is a
precise localization, not a shortcut.
