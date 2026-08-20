# C934 referee Packet G: cubic geometry and global attachment

**Frozen surface.** Authority commit
`53e19feff1f66e7b4b453a38fcc0f239ece007d6`; frozen PDF
`papers/blown-up-theta-lattice/blown_up_theta_lattice.pdf`; independently verified
SHA-256 `108983c8420086abb85889c4d3eff32e1c40fc281e28d6599feacd03d21ddc6e`;
11 A4 pages, read in full.

## Verdict

**A -- accept / ready to submit on Packet G.** Equations (24)--(26) reconstruct
integrally from Lemma 4.1, the pair and truncation sequences, the rational
decomposition, and the constant-to-IC triangle. No excess multiplicity, sign,
degree, or index error remains. The degree-three theorem is unchanged apart from
the valid all-degree extension of Lemma 4.1.

## Claim reconstruction and findings

### 1. Degree-four Fano lift, equation (24): verified

**Location:** Section 4, Lemma 4.1 and (12), printed p. 6; Section 7 immediately
before (24), printed p. 10.

Take `T=[pt] tensor 1` in `H^4(F x F,Z)` and
`u_4=q_*mu^*T`. The proof of Lemma 4.1 is degree-independent. Its only possible
excess term would come from a failure of clean pullback along `X`, but
`q^{-1}(X)=P` and the fibre-degree calculation gives `q^*X=P` with multiplicity
one as Cartier divisors. Hence the two normal line bundles agree and the excess
bundle is zero. Complex Thom orientations make

`e^*q_*mu^*T = p_*pi^*Delta^*T`

an integral identity with positive sign. Here `Delta^*T=[pt]`; `pi^*[pt]` is the
class of a fibre of `P=P(T_F)->F`, and `p` maps that fibre isomorphically and
holomorphically to the corresponding line in `X`. Therefore `e^*u_4=ell` with
no factor and no sign ambiguity.

For the global pushforward, `bq=psi mu` and `mu_*mu^*=1` give
`b_*u_4=psi_*T`. On the cycle Poincare-dual to `T`, the first Fano factor is
fixed and `psi(r,s)=a(s)-a(r)` is a translate of the Albanese-embedded Fano
surface. It follows with the complex orientation that
`psi_*T=[F]=theta^[3]`. Thus (24) is exact as printed.

**Failure modes checked:** no hidden degree-six factor (the restricted map is a
degree-one embedding of one Fano factor), no exceptional multiplicity, no
excess class, and no orientation sign.

### 2. Infinite order and the rational boundary map: verified

**Location:** the two paragraphs between (24) and (25), printed p. 10.

The boundary restriction of `u_4|_U` is the pullback of `ell` to the circle
bundle `K`, namely the generator `tau` of the `Z/3` torsion summand of
`H^4(K,Z)`. The class asserted to have infinite order is `u_4|_U`, not `tau`.
Indeed, if `u_4|_U` vanished over `Q`, the pair sequence for `(M,U)` would put
`u_4` in the image of `e_*:H^2(X,Q)->H^4(M,Q)`. Its pushforward to `J` would
then factor through the constant map `X->0->J` and vanish in degree six,
contradicting `b_*u_4=[F]=theta^[3] != 0` from (24).

The manuscript's rational rank argument also closes. The pair sequence contains

`H^2(X,Q) -> H^4(M,Q) -> H^4(U,Q) -> H^3(X,Q) -> H^5(M,Q)`.

The first exceptional map is injective because its self-intersection is
multiplication by `-h`, taking `h` to `-3ell`. The last map is injective by
Theorem 1.2. Krämer's rational decomposition (18) gives
`dim H^4(M,Q)=dim IH^4(Theta,Q)+1`; hence the pair sequence gives
`dim H^4(U,Q)=dim IH^4(Theta,Q)`. The Deligne truncation map
`IH^4(Theta,Q)->H^4(U,Q)` is injective, so it is an isomorphism and the following
boundary `H^4(U,Q)->H^4(K,Q)` is zero.

**Failure modes checked:** the argument proves infinite order of the global
restriction rather than of the torsion link class; both end maps in the pair
sequence are genuinely injective; the dimension count uses exactly one rational
degree-four skyscraper.

### 3. Index-three attachment, equation (25): verified

**Location:** final paragraph before (25), printed p. 10.

Since the rational boundary vanishes, the integral image of
`H^4(U,Z)->H^4(K,Z)` is torsion. Lemma 2.1 identifies the entire torsion subgroup
as `<tau> = Z/3`, and (24) supplies a preimage of `tau`. The degree-four part of
the truncation triangle is therefore exactly

`0 -> IH^4(Theta,Z) -> H^4(U,Z) -> Z/3 -> 0`.

This establishes both surjectivity and exact index three; it does not infer the
index merely from rational ranks.

### 4. Constant-to-IC comparison, equation (26): verified

**Location:** final paragraph of Section 7, printed p. 10.

For the normal isolated complex fourfold, the unshifted Deligne model is
`tau_{<=3}Rj_*Z_U`. Since the link has `H^1=H^2=0`, comparison with the constant
sheaf and shifting by four gives the displayed triangle

`Z_Theta[4] -> IC_Theta(Z) -> H^3(K,Z)_0[1] -> +1`.

Its long exact sequence contains

`H^3(Theta,Z) -> IH^3(Theta,Z) -> H^3(K,Z) -> H^4(Theta,Z) -> IH^4(Theta,Z)`.

Section 6 identifies `IH^3(Theta,Z)=H^3(U,Z)`, while the Mayer--Vietoris
argument in Proposition 2.2 identifies `H^3(U,Z)` with `H^3(M,Z)`.
Proposition 4.3 makes its map to `H^3(K,Z)` surjective through the integral
exceptional restrictions. The connecting map to `H^4(Theta,Z)` is therefore
zero. The triangle has no further cohomology sheaf, so
`H^k(Theta,Z)->IH^k(Theta,Z)` is an isomorphism for every `k>=4`, proving (26).

**Failure modes checked:** the `[1]` shift is correct after the ambient `[4]`
shift, surjectivity is integral rather than rational, and the conclusion includes
the endpoint `k=4`.

### 5. Degree-three theorem: no regression

**Location:** Theorems 1.1--1.2, printed pp. 2--3; Sections 2--5, printed
pp. 3--8.

The degree-three chain remains
`Proposition 2.2 -> Lemma 4.1 -> Proposition 4.3 -> Theorem 3.1`, with the same
integral cylinder isomorphism, ten endpoint lifts, and mod-two fibre product.
Lemma 4.1 now states (12) for `H^*(F x F,Z)` rather than only degree three, but
its Cartier/Thom/adjunction proof never uses the degree. The new degree-four
application therefore extends rather than changes the old mechanism. Section 7
uses Theorem 1.2 only for the already-proved injectivity of
`H^3(X,Q)->H^5(M,Q)`.

## Minor and presentation findings

No required repair. One optional clarity edit would replace “This class has
infinite order” after (24) by “The class `u_4|_U` has infinite order.” The proof
immediately forces that reading, and the surrounding text repeatedly calls
`tau` order three, so this is not a mathematical ambiguity warranting revision.
Equations (24)--(26) and their triangles render cleanly on printed p. 10.

## Source verification and literature boundary

- **Beauville, theta singularity paper:** public PDF SHA-256
  `4596f46edfdf9b69fd295581119faf814ad67a1e3d87592aa0146aaf225ea90a`,
  read in full (19 pages). Theorem/Propositions on printed pp. 197--208 verify
  the unique triple point, tangent cone, blow-up lift of the Fano difference map,
  universal-line exceptional map, Albanese embedding, degree six, and
  `[F]=theta^3/3!`.
- **Clemens--Griffiths, Sections 2 and 11:** public PDF SHA-256
  `6cfe96ecb81179ce2756cb114414d3db1eab46274665c96c582d7f42c7a60a60`,
  read at the assigned depth. Section 2 gives the integral correspondence and
  adjunction formalism; Theorem 11.19 identifies `Alb(F)` with `J(X)`.
- **Krämer, Corollary 6 and proof:** public PDF SHA-256
  `bad27e7b9eee618e83259d392d706e0738756fa57cd33f021641c2f1b4fed9f6`,
  targeted read through printed pp. 4--5. It gives the complex decomposition
  with point shifts `[2], [0], [-2]`; the same decomposition-theorem argument is
  available over `Q`, supplying the single rational degree-four correction used
  above.
- **Bayer et al., Theorem 7.1 and context:** public PDF SHA-256
  `ce005e812a7223208938c266281b88c2dbcfc3e125079eb98fcba76b8d365c8a`,
  targeted read in Section 7. It independently confirms that the smooth
  four-dimensional moduli space maps onto the theta divisor and is its blow-up
  at the unique singular point, with exceptional divisor `X`. It is
  corroborative here; (24) still depends on the classical Fano difference model.

The sources establish the resolution geometry, Fano class/correspondence, and
rational three-skyscraper boundary. They do not state the manuscript's integral
index-three global attachment or equation (26); those follow from the manuscript's
new degree-four lift and integral truncation argument.

## Confidence

- Equation (24), multiplicity, signs, and degrees: **high**.
- Infinite-order and rational rank arguments: **high**.
- Exact sequence (25) and triangle/endpoint (26): **high**.
- No degree-three regression: **high**.
- Optional pronoun clarification only: **high** that no required repair is needed.

**Remaining findings:** none. No Packet G verification debt remains.

## Venue recommendations

Correctness is separated from venue fit:

- **Algebraic Geometry:** favorable / submit, conditional on the independent
  modular and editorial packets. The Fano globalization of the local mod-three
  class is a genuine specialist-geometry contribution and is proved at the
  advertised integral level.
- **Mathematische Zeitschrift:** favorable / submit. The theorem package and
  proof length fit comfortably, with no Packet G obstacle.
- **Proceedings of the AMS:** mathematically acceptable but no longer the best
  fit. The combined lattice, integral-decomposition, and modular theorem is
  broader than the earlier short-note spine; a specialist geometry venue better
  reflects the upgraded result.

## Mystery ledger

The closeout pass tested the only two plausible residual mysteries: whether the
point input could pick up degree six or an excess factor, and whether the order-three
link class might force global torsion. The clean Cartesian calculation and the
nonzero Fano pushforward settle both. **No genuine Packet G mystery remains.**
