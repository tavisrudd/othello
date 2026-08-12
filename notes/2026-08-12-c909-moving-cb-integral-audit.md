# C909 — moving conformal blocks, `T_z`, and the integral jet gate

Date: 2026-08-12
Status: focused primary-source audit; no manuscript, PDF, mirror, Lean, or
certificate edit.

## Executive verdict

The proposed moving operator is a real conformal-block construction, but the
source theorem is weaker than the C909 crown.

* Feigin–Schechtman–Varchenko (FSV) and Beauville identify genus-zero
  conformal-block fibers over **complex** configuration spaces with quotients
  by a polynomial operator
  \[
       T_z=\sum_i z_i X_\theta^{(i)},
       \qquad T_z^{\,m},
  \]
  where the root vector is written `f_θ` in FSV and `X_θ` in Beauville.  This
  is the correct moving object behind the level filtration.
* FKLMM prove characteristic-zero dimension, fusion/no-jump, and path/monomial
  basis statements.  They do not construct a Chevalley divided-power lattice
  over `Z[z_i,Delta^{-1}]` or identify its subbundles with C909's coordinate
  Hasse-jet kernels.
* Rimányi–Varchenko, Theorem 2.2 and Corollary 2.3, prove the missing
  **complex all-width identification**: for `lambda=(N,...,N)`, an
  `SL_m` invariant is in the level-`ell` space exactly when it vanishes to
  order at least `N-ell` along their moving affine plane `A(z)`.  Taking
  `m=2`, `N=n`, and `ell=n-r` gives C909's order-`r` coordinate-jet
  condition over `C` (their operators are ordinary derivatives; the
  divided/Hasse normalization remains an integral question).
* The BBM relevant here is Belkale–Brosnan–Mukhopadhyay, *Hyperplane
  arrangements and invariant theory*.  Its §9.1 gives the `T_z` cokernel
  formula, §10.6 explicitly poses the higher-level/Hodge-filtration question,
  and §11 gives the four-fundamental-`sl_2` rank-one example.  It is still a
  complex/Hodge-theoretic source, not an integral jet theorem.
* The smallest C909 case is better than the generic comparison: for four
  fundamental `sl_2` insertions at level one, the natural conformal-block
  kernel is exactly the C909 first jet line, after using a divided square.
  This is an explicit two-dimensional calculation, not an all-`n` source
  theorem.

Thus the safe result is **exact moving complex model in all widths; exact
`n=2` integral check; all-degree integral local-freeness, primitive leading
jets, and web/jet identification in every characteristic remain unproved in
the audited literature**.  This is a narrower gap than “the complex
all-width comparison is absent.”

The current pass also checked focused searches for “integral conformal
blocks,” Chevalley lattices, arbitrary-base coinvariants, Frobenius splitting
of `M_{0,n}`, and Specht/higher-order evaluation codes.  No primary theorem
was found asserting that the C909 Hasse-tail map on the coefficient-one
`(n,n)` web lattice has rank `B(n,ell)` after reduction modulo every prime
for every tuple of pairwise distinct residue roots.  This is a bounded search
statement, not a global absence claim.

## 1. What FSV actually proves

B. Feigin, V. Schechtman, and A. Varchenko, *On algebraic equations
satisfied by hypergeometric correlators in WZW models II*, arXiv:hep-th/9407010
v1, is the direct source for the moving operator.  The cached PDF has SHA-256
`53a2d6417cd2827b8a0327890285ed1ec9a396bf1dd4f0d2e66c8566141d1270`.

In §1.1 FSV set
\[
 X_n=\mathbb A^n_\mathbb C\setminus\bigcup_{i<j}\Delta_{ij}
\]
and define
\[
 z\!\cdot\!f_\theta=\sum_{i=1}^n z_i f_\theta^{(i)}.
\]
Their Theorem in §1.1 says that the conformal-block fiber is the cokernel of
the corresponding power
\[
 (z\!\cdot\!f_\theta)^{,k-(\Lambda_{n+1},\theta)+1}
\]
between the indicated weight spaces.  The same statement is recast as
Theorem 2.10: affine current-algebra coinvariants are the quotient by
`Im(T(z))`.  This is exactly a moving polynomial matrix in the marked
coordinates.

The limitations are explicit in the source.  The coefficient field is
`C`; `L_i` are finite-dimensional complex irreducibles; and the result is a
pointwise description of a holomorphic bundle on the complex configuration
space.  No Chevalley `Z`-form, divided powers, arbitrary-base construction,
or Smith/saturation assertion is made.

FSV §4.2, Theorem 4.2, constructs a map to twisted de Rham cohomology, and
§4.3, Theorem 4.3.1, proves that the image of `Im(T(z))` is exact, so the map
descends to conformal blocks.  The introduction expressly says that
injectivity and a topological description of the image are expected rather
than proved.  In particular this is not a theorem that the image or kernel
is the coordinate Hasse-jet web lattice.

## 2. Beauville gives the cleanest moving formula

A. Beauville, *Conformal blocks, fusion rules and the Verlinde formula*,
arXiv:alg-geom/9405001, Proposition 4.1, fixes a coordinate on `P^1` and
defines
\[
 T(v_1\otimes\cdots\otimes v_p)=
 \sum_i t_i,v_1\otimes\cdots\otimes X_\theta v_i\otimes\cdots\otimes v_p.
\]
The cached PDF has SHA-256
`758f6cd667d5fbfc092daf4147d4c38902623766c0aa62d69845f3b12b87bb49`.

Beauville's proposition says that the genus-zero conformal-block space is
the largest quotient of the tensor product on which `g` and `T^{ell+1}` act
trivially; dually, invariant forms are those annihilating `T^{ell+1}`.
For `sl_2`, §4.2 identifies `T` on the polynomial model with
`a*d/dx+b*d/dy+c*d/dz` for three insertions, and computes the level cutoff
directly.  This supplies the characteristic-zero moving filtration and the
correct bounded-height rank interpretation.

It does not supply a base-change theorem.  The paper works over `C`, and its
integral object in §§5–9 is the abstract fusion ring `Z(I)` used to encode
fusion *numbers*.  That ring is not an integral conformal-block bundle or a
divided-power lattice in the tensor representation.

## 3. Exact four-point check (the useful positive result)

Let `A=[12][34]` and `B=[14][23]` be the two invariant web polynomials for
four fundamental `sl_2` factors, with
`[ij]=x_i y_j-y_i x_j` and `delta_ij=z_j-z_i`.  In the polynomial dual model
the root operator is, up to the harmless sign/convention exchanging `e` and
`f`,
\[
 D_z=\sum_{i=1}^4 z_i x_i\frac{\partial}{\partial y_i}.
\]
Directly,
\[
 D_z[ij]=\delta_{ij}x_ix_j,
\]
and therefore
\[
 D_z^2A=2\delta_{12}\delta_{34}M,
 \qquad
 D_z^2B=2\delta_{14}\delta_{23}M,
 \qquad M=x_1x_2x_3x_4.
\]
Consequently
\[
 \ker(D_z^2|\langle A,B\rangle)=
 R\bigl(\delta_{14}\delta_{23}A-
        \delta_{12}\delta_{34}B\bigr),                 \tag{1}
\]
where `R` is any coefficient ring in which the displayed differences are
defined.  This is exactly the C909 `F^1 W_2` generator, up to the web sign
convention.

The integral normalization is important.  Since the two factors in `D_z`
act on distinct fundamental tensor factors, the divided square
`D_z^{[2]}=D_z^2/2` has integral coefficients and sends
`A,B` to the two coefficient-one expressions above.  Thus (1) is a genuine
integral equality after localizing at the discriminant in this smallest case,
including at `p=2`.  This calculation proves neither local freeness in all
widths nor compatibility of the entire C909 Hasse-jet filtration with the
Chevalley divided-power conformal-block quotient.

It also corrects an overly strong blanket no-go formulation: the natural
moving conformal-block kernel does match the first C909 jet line for `n=2`.
What fails in general is the existence of a cited all-degree integral
comparison theorem, not this smallest-width identification.

## 4. BBM §§9.1, 10.6, and 11: the decisive source boundary

P. Belkale, P. Brosnan, and S. Mukhopadhyay, *Hyperplane arrangements and
invariant theory*, arXiv:1611.01861, is the relevant “BBM”.  The full arXiv
PDF was read and is cached with SHA-256
`5ae2bf1609841b32841b38a0cd438ad5bbdafd6dfb5a1c5950b33401140bd84d`.

Section 9.1 gives exactly the desired complex moving formula.  For distinct
`z_i` it defines
\[
 T_{\bf z}=\sum_i z_i e_\theta^{(i)},\qquad
 C_{\bf z}=\operatorname{im}T_{\bf z}^{\ell+1},
\]
and states that the dual conformal-block quotient is
`A(~lambda)/C_z`, with the dual vector space called conformal blocks.  The
source attributes this description to Beauville and FSV.

The same paper then makes the status of the proposed all-level filtration
explicit.  Proposition 120 (numbering in arXiv:1611.01861; Proposition 117
in the earlier author-PDF extraction) identifies the top Hodge step with the
conformal-block subspace for classical groups and `G_2`.  Section 10.6 asks
whether the other Hodge steps are the higher-level conformal-block spaces:
its Question 123(2) asks, after quotienting the weight part, whether
`F^{M-p}` equals the level `ell+p+1` conformal blocks.  The paper says the
only justification is compatibility of the KZ connection.  This is an
explicit open-question boundary, not a proof of the all-level identity.

Section 11 is the useful four-insertion check, not a separate `n=2`
integral theorem.  For four fundamental `sl_2` representations it writes the
level-one relation
\[
 [v]=-
 \frac{(z_1-z_2)(z_3-z_4)}{(z_1-z_3)(z_2-z_4)}[w]
\]
and the kernel generator
\[
 \Phi({\bf z})=(z_1-z_3)(z_2-z_4)v
 +(z_1-z_2)(z_3-z_4)w.
\]
After the standard change from the coinvariant basis `[v],[w]` to the two
matching webs, this is the C909 first-jet generator (1), up to signs and
which matching is called `A` or `B`.  BBM therefore confirms the smallest
moving identification over `C`; its Question 123 confirms that no cited
all-degree theorem should be claimed from BBM.

The paper works with complex local systems, mixed Hodge structures, and
complex configuration points.  It does not define an integral Chevalley
divided-power sheaf, prove arbitrary-base local freeness, or identify the
higher Hodge/conformal-block filtration with C909's coefficient-one Hasse
jets.

## 5. Rimányi–Varchenko close the complex all-`n` jet comparison

R. Rimányi and A. Varchenko, *Conformal blocks in the tensor product of
vector representations and localization formulas*, Annales de la Faculté des
sciences de Toulouse 20 (2011), DOI `10.5802/afst.1286`, is the exact source
for the comparison that is sometimes attributed only heuristically to the
`T_z` construction.  The official article is
`https://afst.centre-mersenne.org/articles/10.5802/afst.1286/`; the cached
PDF has SHA-256
`c11058fdfa41f675eaddae4c6f94aad85c859a8c862d2a11c5a1eb6c4b3103bf`.

Their §2.1–2.2 works in the polynomial model for `V^{\otimes |lambda|}` and
defines
\[
 e_{z,i,j}=\sum_a z_a y_a^{(i)}\,\partial/\partial y_a^{(j)}
\]
and the level-`ell` conformal-block space by
`e_{z,1,m}^{ell-d(lambda)+1}p=0` inside the singular subspace.  They state
explicitly that throughout the paper `z` is a collection of distinct complex
numbers.

For `lambda=(N,...,N)`, §2.3 defines the affine plane
\[
 A(z)=\{y_a^{(m)}=z_a y_a^{(1)}\}_{a=1}^{|lambda|}
\]
and the coordinate operators
`partial_{B_k}=prod_{i=1}^k y_{b_i}^{(1)} partial/partial y_{b_i}^{(m)}`.
**Theorem 2.2** says an `SL_m`-invariant polynomial is in the level-`ell`
space iff all these operators vanish on `A(z)` for `k <= N-ell-1`, i.e. iff
it vanishes there to order at least `N-ell`.  Corollary 2.3 gives the
equivalent `SL_m`-orbit formulation.

For C909, put `m=2`, `|lambda|=2n`, `N=n`, and `ell=n-r`.  In the affine
chart `y_a^(1)=1`, `y_a^(2)=z_a`, the operators in Theorem 2.2 are exactly
the coordinate partial/Hasse tails defining `F^r` (the source uses ordinary
derivatives, so factorial denominators must still be handled separately).
Consequently the all-`n` equality
\[
       F^r(W_n\otimes\mathbb C)=CB_{z,\,n-r}(n,n)
\]
is source-backed over `C`.  Since the source is explicitly complex and uses
ordinary derivatives, it does **not** prove the C909 integral statement,
primitive image, or any mod-`p` rank theorem.

## 6. FKLMM: rank and fusion, not the integral kernel

B. Feigin, R. Kedem, S. Loktev, T. Miwa, and E. Mukhin, *Combinatorics of
the `sl_2` spaces of coinvariants II*, arXiv:math/0009198v2, cached with SHA
`cac871a85b3bf3316cb4a2b33465e157cca46b525fbb561dec67c28479b8762f`, prove:

* Theorem 2.1.2: at distinct complex points the dimension is the Verlinde
  number.
* Theorem 5.4.4: the same dimension holds for the coincident/fusion
  configurations.
* Corollary 5.4.6: the relevant map to the associated graded `Gr^E` is an
  isomorphism.
* Corollary 5.4.10: monomial bases are indexed by the admissible fusion
  paths for every complex point configuration.

These are the source-backed reason the C909 cumulative ranks are bounded-height
Dyck counts.  They are statements about complex vector spaces and their
dimensions/bases.  No result there constructs a module over
`Z[z_i,Delta^{-1}]`, proves saturated divided-power images, or says that
coordinate Hasse jets in the web pairing equal the fusion filtration.

## 7. Adjacent Specht literature does not close the mod-`p` gate

Lafay–Peltola–Roussillon, *Fused Specht polynomials and `c=1` degenerate
conformal blocks*, arXiv:2410.09798 / Trans. AMS Ser. B 12 (2025),
constructs explicit fused-Specht bases and proves a two-column linear
independence theorem (Theorem 2.16).  This is a useful neighboring
combinatorial source: its formulas are polynomial/Vandermonde formulas and
its unit-valence case uses rectangular two-row tableaux.  But the paper
works with complex polynomial representations and `q=-1` fused Hecke/CFT
spaces; it does not formulate a `Z`-lattice, arbitrary-field Hasse jets, or a
constant-rank theorem for pairwise-distinct residue roots.  In particular it
cannot be cited as the missing primitive-minor result.

## 8. The exact missing theorem

Let
\[
 R_\mathbb Z=\mathbb Z[z_1,\ldots,z_m,\Delta^{-1}],
 \qquad \Delta=\prod_{i<j}(z_i-z_j),
\]
and choose Chevalley divided-power forms of the tensor representations.  A
theorem sufficient for C909 would have to:

1. define the divided-power current operator `T_z^[q]` over `R_Z` (with a
   normalization that is integral at every prime);
2. prove that the corresponding coinvariant cokernel, or its dual kernel, is
   locally free on `Conf_RZ` and commutes with arbitrary base change;
3. identify its image under the invariant/web pairing with the C909
   coordinate Hasse-jet kernel, not just after tensoring with `Q`; and
4. prove saturation of every adjacent level/depth quotient, including the
   dyadic case.

FSV, Beauville, BBM, FKLMM, and Rimányi–Varchenko provide none of (1)–(4) in
this integral/all-characteristic form.  The `n=2` computation above proves
the first nontrivial instance after the divided-square normalization.  The
all-degree C909 gate remains the integral unimodular osculating-web theorem.

There is one safe derived statement.  Over characteristic zero, the C909
jet matrix is defined over `Q`; Rimányi–Varchenko plus the
characteristic-zero Verlinde rank show that its rank is `B(n,ell)` at every
complex point with distinct coordinates.  Therefore the rank-drop locus over
`Q[t_i,Delta^{-1}]` is empty after the faithfully flat extension `Q -> C`,
hence it is empty over every characteristic-zero field.  This is not a
positive-characteristic or saturation result: reduction modulo `p` can still
acquire rank loss unless the missing integral unit-minor theorem is proved.

## Coverage and source discipline

This is a bounded source audit, not a global novelty claim.  Full texts read:
FSV II, Beauville, BBM, FKLMM, and Rimányi–Varchenko; the cache keys and hashes are recorded
above.  FSV I was checked through the FSV II references/statement that its
`sl_2` proof is the predecessor, but its publisher copy was not obtained as a
valid PDF in this pass.  No claim here depends on an unverified FSV I lemma.
MathSciNet/zbMATH citation closure and an exhaustive search of all integral
conformal-block lattices were not performed.
