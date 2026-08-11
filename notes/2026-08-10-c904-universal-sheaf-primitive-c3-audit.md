# C904 universal-sheaf primitive-`c3` audit

> **Superseded mathematical status (2026-08-10).**  This source audit found
> the primitive integral candidate below, but the later exact invariant-ring
> and Wu calculation in
> `2026-08-10-c904-universal-sheaf-tautological-parity-wall.md` proves that
> its theta degree is even and closes the whole formal twist-invariant
> lambda/Chern route through codimension three.  Retain this note for the
> literature boundary and construction of the candidate; do not retain its
> “open and promising” verdict.

Date: 2026-08-10
Status: quarantined Annals research; no manuscript or Lean edits
Scope: the universal family on
`M=M_X(v)=Bl_0 Theta`, integral twist-invariant codimension-three
tautological classes, and whether the literature computes their pushforward
to the intermediate Jacobian

## Executive verdict

This bounded audit used three primary sources, all read partially at the
load-bearing sections and none read end-to-end in this pass.  It also screened
the largest of three forward-citation sets (27 citing works; 27 titles and 26
abstracts).  No source located computes the universal family, its tautological
Kunneth components, or a codimension-three pushforward for this fourfold.

The first correction is bibliographic and must propagate everywhere:
arXiv:`2011.12240` is by **Arend Bayer, Sjoerd Viktor Beentjes, Soheyla
Feyzbakhsh, Georg Hein, Diletta Martinelli, Fatemeh Rezaee, and Benjamin
Schmidt**.  It is not a Lahoz--Macri--Stellari paper.  The arXiv record, the
published Geometry & Topology paper, and the cached PDF agree.  The cache
metadata and the stale C904 notes carrying the contrary attribution were
corrected in this pass.

The mathematical verdict is more positive than the previous blanket
gamma-filtration warning.

1. The moduli space is fine.  If `p` lies on a line `ell` in `X`, then

   ```text
   u = [O_p]-[O_ell] = -[O_ell(-1)] in K_0(X)
   ```

   and `chi(v tensor u)=3-2=1`.  Huybrechts--Lehn Theorem 4.6.5 therefore
   gives an honest universal sheaf on `X x M`.

2. Let `E` be any such universal sheaf, let `pi:X x M -> M`, and set

   ```text
   W_u = R pi_*(E tensor^L u) in K_0(M).
   ```

   It has virtual rank one.  Replacing `E` by `E tensor pi^*L` replaces
   `W_u` by `W_u tensor L`.  If `lambda_u=det(W_u)`, then

   ```text
   E^(u) = E tensor pi^*(lambda_u^(-1))
   ```

   is independent of the initial choice of `E`, once `u` is fixed, and its
   associated `W_u^(u)` has trivial determinant.

3. There is an integral, denominator-free, twist-invariant curve class

   ```text
   gamma_u = c_3(W_u)+c_1(W_u)c_2(W_u) in CH^3(M).
   ```

   Indeed, for a virtual rank-one class `W` and a line bundle with first
   Chern class `l`,

   ```text
   c_1(W tensor L)=c_1(W)+l,
   c_2(W tensor L)=c_2(W),
   c_3(W tensor L)=c_3(W)-l c_2(W).
   ```

   Hence `c_3+c_1 c_2` is unchanged.  Equivalently,

   ```text
   gamma_u = c_3(W_u^(u)).
   ```

   This is a genuine integral candidate and does not pass through a Chern
   character or divide by the codimension-three factor `2`.

4. Nothing read computes `gamma_u`.  In particular, no source proves that
   its proper pushforward to `J(X)` is an odd multiple of
   `Theta^4/4!`, or even that its primitive component is nonzero.  Thus the
   route is **open and sharply testable**, not closed.

The next exact gate is

```text
b_*(gamma_u) ?= m Theta^4/4! in H^8(J,Z), with m odd,
```

where `b:M -> Theta -> J`.  On the special `A_5` cubic, one must compute the
full invariant component, not merely one intersection number, because the
relevant Hodge space is larger than the generic rank-one line.

## 1. What Bayer et al. actually construct

Bayer--Beentjes--Feyzbakhsh--Hein--Martinelli--Rezaee--Schmidt prove that
the stable-sheaf moduli space for

```text
v=(3,-H,-H^2/2,H^3/6)
```

is the smooth fourfold `Bl_0 Theta`.  Their paper does **not** print a global
universal sheaf on `X x M`, an explicit global K-class, determinant-of-
cohomology classes, or tautological Kunneth components.

The only occurrence of a universal family in the cached full text is the
family inducing the exceptional embedding `i:X -> M`.  Lemma 7.3 gives on
`X x X`

```text
0 -> K -> p_1^*(Omega_{P^4}|_X(H)) -> I_Delta(0,H) -> 0.
```

Thus the restriction of a global universal class to the exceptional divisor
is explicit up to the usual parameter-line twist:

```text
[K]=[p_1^*(Omega_{P^4}|_X(H))]-[I_Delta(0,H)].
```

This is useful boundary data, but it does not determine a codimension-three
class on the whole fourfold `M`.

The paper's bibliography cites Huybrechts--Lehn for general moduli theory.  It
does not invoke their universal-family criterion, presumably because the main
theorem needs only the coarse moduli space and its Abel--Jacobi morphism.

## 2. Fine-moduli criterion and the explicit weight-one normalization

Huybrechts--Lehn Section 4.6 works for a smooth projective variety of arbitrary
dimension.  For a fixed numerical class `c`, the determinant line

```text
lambda(B)=det p_!(F tensor q^*B)
```

on the stable GIT parameter space has central scalar weight `chi(c.B)`.
Their Theorem 4.6.5 says that a finite integral combination of such weights
equal to one produces a universal family on the stable moduli space.

For the present `v`,

```text
chi(v.O_p)=3,
chi(v.O_ell)=2.
```

The first is the rank.  For the second, derived restriction to
`ell=P^1` has rank three and degree `c_1(v).ell=-1`, hence Euler
characteristic `3-1=2`.  Therefore

```text
lambda(O_p) tensor lambda(O_ell)^(-1)
```

has scalar weight one.  This gives an explicit **descent procedure** for a
universal sheaf, but not a closed formula for its class in `K_0(X x M)`.

Taking `p in ell` exposes a useful geometric form of the same class.  The
sequence

```text
0 -> O_ell(-1) -> O_ell -> O_p -> 0
```

gives `u=-O_ell(-1)`, so

```text
W_u = -R pi_*(E|_(ell x M)(-1)).
```

The source's explicit presentation makes the generic balance exact.  A
vector bundle in the open locus has

```text
0 -> E_D -> O_X^3 -> O_Y(D) -> 0.
```

If `ell` is not contained in `Y`, derived restriction has no Tor and the
last term becomes the one-point sheaf at `ell intersect Y`.  Hence

```text
E_D|_ell = O_ell(-1) plus O_ell plus O_ell.
```

Similarly, for the exceptional sheaf
`0 -> K_P -> O_X^4 -> I_P(1) -> 0`, one gets the same balanced splitting
when `P` is not on `ell`.  Consequently `gamma_u` is supported by the
failure of this fixed-line restriction complex to remain a line bundle:
on the vector-bundle locus this can occur only when `ell` is contained in
the presentation hyperplane `Y`, while on the exceptional divisor it can
occur only along the curve `P in ell`.  The latter curve is contracted by
`b:M -> J`, so any nonzero `b_*(gamma_u)` must come from the first locus.
This converts the abstract `c_3` problem into a deeper degeneracy
calculation over the plane of hyperplanes containing `ell`, naturally
adjacent to the theta Gauss map.

This last geometric sentence is a derivation, not a statement found in the
sources.  It also supplies a cheap possible no-go: if the derived restriction
is a line bundle on all of `M`, then `gamma_u=0`.

## 3. Integral twist-invariant `c_3` formulas

Let `W` be a perfect class of virtual rank `r`.  Under tensoring by a line
bundle of first Chern class `l`, the splitting principle gives

```text
c_1' = c_1+r l,
c_2' = c_2+(r-1)l c_1+binom(r,2)l^2,
c_3' = c_3+(r-2)l c_2+binom(r-1,2)l^2 c_1+binom(r,3)l^3.
```

Markman Lemma 9 records the corresponding excess-Chern transformation in
the surface-moduli setting.  The formulas themselves are lambda-ring
identities and do not depend on the dimension of `X`.

For rank one they immediately give

```text
gamma(W)=c_3(W)+c_1(W)c_2(W).
```

For comparison, a rank-three class has the integral centered invariant

```text
kappa_3(V)=27c_3(V)-9c_1(V)c_2(V)+2c_1(V)^3.
```

This is `27` times the third elementary symmetric function in the formally
centered Chern roots.  It is also invariant under `V -> V tensor L` and can
be applied directly to the derived restriction of the universal sheaf at a
point.  The rank-one class `gamma_u` is better for the present gate: it is
primitive as an integral polynomial and is exactly the third Chern class
after determinant normalization.

These formulas correct only the *formal-integrality* diagnosis.  They do not
invalidate the previous statement that the published Markman/Buelles
diagonal-factorization route uses Chern characters and retains the
codimension-three factorial two.  They exhibit a different integral class
whose primitive coefficient has not been computed.

## 4. What remains to compute

Let `b:M -> J` be the Abel--Jacobi blowdown followed by the theta inclusion.
The desired class is

```text
Gamma_u=b_*(gamma_u) in CH^4(J).
```

There are four independent obligations.

1. **Nonvanishing/jumping locus.**  Determine the cohomology sheaves of
   `R pi_*(E|_ell(-1))` and express `gamma_u` as a Porteous class of its
   jumping strata.  The explicit exceptional family in Bayer et al. gives a
   boundary condition, not the global answer.

2. **Primitive projection.**  Compute the complete cohomology class of
   `Gamma_u`.  If it is already known to lie on the minimal-class line, then
   its scalar is

   ```text
   m=(1/5) integral_M gamma_u b^*Theta,
   ```

   because `(Theta^4/4!).Theta=5`.  On the `A_5` fibre, membership in that
   line must itself be proved.

3. **Choice dependence.**  The Chow class may depend on the chosen
   `p in ell`.  Its cohomology depends only on the topological K-class of
   `u`; this is the level relevant to the minimal Hodge class, but a relative
   Chow construction must control the dependence rather than silently
   choose a line.

4. **Relative descent.**  Fine moduli for each fixed cubic does not by itself
   produce a universal sheaf over the family of cubics.  The weight-one
   witness uses a point and a line.  A relative version requires a relative
   K-class of weight one or a descent argument for the resulting Brauer
   class.  The cited sources do not provide it on the exotic marked base.

No formula in the audited sources evaluates any of these four items.

## 5. Priority and pre-emption verdict

### Source-backed

- `M=Bl_0 Theta`, its exceptional family, and the Abel--Jacobi morphism:
  Bayer et al.
- Gcd-one determinant weights imply an honest universal family on a stable
  sheaf moduli space over an arbitrary smooth projective variety:
  Huybrechts--Lehn Theorem 4.6.5.
- The line-twist formulas for excess Chern classes and the use of universal
  Kunneth factors to generate cohomology in the Poisson-surface setting:
  Markman.

### New elementary derivations in this audit

- the weight-one representative `u=-O_ell(-1)`;
- the canonical determinant normalization `E^(u)`;
- the primitive integral invariant
  `gamma_u=c_3(W_u)+c_1(W_u)c_2(W_u)=c_3(W_u^(u))`;
- the jumping-line interpretation and the exact odd-pushforward gate.

No priority claim should be made for these formal identities.  They are
short consequences of standard determinant and splitting-principle
machinery.  The potentially new theorem would be the **computed odd primitive
pushforward on this cubic-threefold moduli space**.

### Not located

- a global explicit universal K-class on `X x M`;
- tautological Kunneth components for this `M`;
- formulas for `c_i(R pi_*(E tensor u))` on this `M`;
- a calculation of `b_*(gamma_u)`;
- a relative universal-family/descent theorem on the marked `A_5` base.

## 6. Forward-citation screen

Seed: DOI `10.2140/gt.2024.28.127`, resolved independently by all three
services to the seven-author Bayer et al. paper.

Counts on 2026-08-10:

- OpenAlex work `W3109189020`: 19 citing works;
- Crossref: `is-referenced-by-count=9`;
- Semantic Scholar corpus `227151174`: 27 citing works.

The largest set, Semantic Scholar's 27 records, was screened over all 27
titles and the 26 available abstracts with the case-insensitive
discriminator

```text
universal (sheaf|family|class)|Chern|Chow|tautological|Kunneth|Künneth|
determinant of cohomology|cohomology ring|K-theor|intersection theor|
algebraic cycle
```

Three records were promoted.  Their titles/abstracts concern a stronger
Bogomolov--Gieseker inequality on a quintic threefold, a different
eight-dimensional sheaf moduli on a cubic threefold (arXiv:`2406.10104`),
and stable sheaves on a quadric threefold.  None computes the present
fourfold's universal classes.  These three were read at
`abstract/metadata only`.  The API returned a nonempty 27-record data array,
so the zero direct matches were distinguished from a service error.

Query endpoints:

```text
https://api.openalex.org/works/https://doi.org/10.2140/gt.2024.28.127
https://api.crossref.org/works/10.2140%2Fgt.2024.28.127
https://api.semanticscholar.org/graph/v1/paper/DOI:10.2140/gt.2024.28.127
https://api.semanticscholar.org/graph/v1/paper/CorpusId:227151174/citations
```

MathSciNet was not accessible and is **NOT COVERED**.  zbMATH Open was used
only to corroborate the published author list, not as a full-text source.
Accordingly any absence statement remains bounded and qualified.

## 7. Primary sources and read depth

1. **Arend Bayer, Sjoerd Viktor Beentjes, Soheyla Feyzbakhsh, Georg Hein,
   Diletta Martinelli, Fatemeh Rezaee, and Benjamin Schmidt**, *The
   desingularization of the theta divisor of a cubic threefold as a moduli
   space*, Geometry & Topology 28 (2024), 127--160, DOI
   `10.2140/gt.2024.28.127`.  Read depth: `partial`, arXiv v2, Sections
   5--7, especially Corollary 6.9, Theorem 7.1, and Lemma 7.3, plus the
   bibliography and full-text searches for `universal`, `determinant`,
   `Kunneth`, and `tautological`.  Cache key arXiv:`2011.12240`, SHA-256
   `ce005e812a7223208938c266281b88c2dbcfc3e125079eb98fcba76b8d365c8a`.

2. **Daniel Huybrechts and Manfred Lehn**, *The Geometry of Moduli Spaces
   of Sheaves*, second edition, Cambridge University Press, 2010.  Read
   depth: `partial`, Section 4.6, especially the determinant-weight
   construction preceding Theorem 4.6.5 and Theorem 4.6.5 itself.  Access:
   online PDF; not added to the shared cache.  This theorem is stated for a
   smooth projective variety, not only for surfaces.

3. **Eyal Markman**, *Integral generators for the cohomology ring of moduli
   spaces of sheaves over Poisson surfaces*.  Read depth: `partial`, arXiv
   v3, Introduction, Section 2.2 (Theorem 8 and Lemma 9), and Section 3.1
   (Definitions 26--27 and the determinant-weight gcd).  Cache key
   arXiv:`math/0406016`, SHA-256
   `7e92ef402f3aa3a9bc87e5970afdaa8e4a8348ec36029590d7633e9b587ac0ea`.
   Its cohomology-generation theorem is surface-specific and is not a
   theorem about the present cubic-threefold moduli.

## 8. EJ + TT closeout

The highest-value cheap upgrade is the identity `u=-O_ell(-1)`: it turns an
abstract universal-Chern question into the geometry of one fixed-line
restriction complex.  The first computation should therefore be the
cohomology-and-jumping stratification of
`R pi_*(E|_ell(-1))`, not a general GRR expansion of the unknown global
universal class.

The strongest red-team checks are:

1. prove or disprove that this restriction complex is globally a shifted
   line bundle (which would force `gamma_u=0`);
2. do not infer a relative universal family from fibrewise fine moduli;
3. do not certify the minimal class from one theta degree on the special
   `A_5` fibre;
4. do not describe the formal invariant `gamma_u` as new -- only a computed
   odd primitive pushforward could carry novelty.

## Mystery ledger

- **Settled:** the source and author attribution; the cached metadata and
  stale C904 corrections now agree with the paper.
- **Settled:** fixed-fibre fine moduli and an explicit determinant
  normalization exist with no division by two or three.
- **Settled:** the standard Chern-character factorial does not formally bar
  every integral universal-sheaf attack; `gamma_u` is a primitive integral
  alternative.
- **Open:** whether the fixed-line complex has a nontrivial jumping locus of
  the required codimension.  Evidence gap: no global universal resolution or
  restriction-stratification theorem was located.
- **Open:** the complete cohomology class and parity of `b_*(gamma_u)`.
  Owning gate: a direct Porteous/GRR computation after the restriction
  complex is made explicit.
- **Open:** relative weight-one descent on the exotic marked base.  Evidence
  gap: the point--line normalization is fibrewise and no source spreads it.

Vibe at the time of this source audit: the class was a genuine integral
candidate.  Later status: **closed negatively** by the mod-two invariant-ring
and Wu parity theorem cited in the supersession banner.
