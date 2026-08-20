# C934 referee report A: modular and perverse-sheaf packet

**Frozen authority:** `53e19feff1f66e7b4b453a38fcc0f239ece007d6`

**PDF SHA-256:**
`108983c8420086abb85889c4d3eff32e1c40fc281e28d6599feacd03d21ddc6e`
(verified before reading)

**Read surface:** all 11 printed pages of *Integral Cohomology and Modular
Decomposition for the Theta Divisor of a Cubic Threefold*.

## Verdict

**B -- minor revision.** Equations (19)--(23), the integral outer splitting,
the Smith-factor-three obstruction, and the characteristic-three
indecomposable nonsemisimple factor are correct. No theorem or proof mechanism
needs to change. Two local repairs are required: spell out why derived reduction
of the integral residual object remains perverse (and why no torsion point
summand is hidden), and cite Cipriani at the precise general-categorical
boundary of the paper's concrete indecomposability argument.

## Sources actually opened

1. Juteau--Mautner--Williamson, *Parity Sheaves*, full-text cache
   `arXiv:0906.2994`, SHA-256
   `cb18832f73adb0b0ccc74d34f9f92b0ab52a9b275351c3658ee3f8f5eb88f3b4`.
   I read Sections 3.1--3.3 at full depth, including Proposition 3.2,
   Corollary 3.5, Proposition 3.10, Theorem 3.13, and the coefficient-ring
   qualifications.
2. Cipriani, *Indecomposable extensions of perverse sheaves over a closed
   stratum*, full-text cache `arXiv:2607.09379`, SHA-256
   `2d8774913c1b33c0c255e6aa67309ddffcccd1e5869f8c28da76eead524d4a77`.
   I read the introduction and the relevant full-text development in Sections
   3.1--3.5, especially Lemma 3.12, Theorem 3.21, Corollary 3.22, and
   Remark 3.24.

## Independent reconstruction of (19)--(23)

### 1. Stalk, costalk, and intersection blocks: (19)--(20)

Let `K=R sigma_* Z_M[4]`. Proper base change gives
`i^*K=R Gamma(X,Z)[4]`. Extraordinary proper base change identifies the costalk
with cohomology supported on the exceptional divisor; Thom excision for the
complex codimension-one embedding `X -> M` gives
`i^!K=R Gamma(X,Z)[2]`. Thus, in cohomological degree `r`, the natural map is

`H^(r+2)(X,Z) -> H^(r+4)(X,Z)`.

It is cup product by the Euler class of `N_(X/M)=O_X(-1)`, hence by `-h`.
On the algebraic part the only nonzero same-degree blocks are

| `r` | costalk | stalk | map |
|---:|---|---|---|
| `-2` | `H^0(X)=Z` | `H^2(X)=Zh` | `[-1]` |
| `0` | `H^2(X)=Zh` | `H^4(X)=Z ell` | `[-3]` |
| `2` | `H^4(X)=Z ell` | `H^6(X)=Z[pt]` | `[-1]` |

Here `h^2=3 ell` and `h ell=[pt]`. This reproduces (19)--(20), including all
shifts and the sign. The sign is irrelevant to splitting, but the factors
`1,3,1` are load-bearing.

### 2. The two integral point summands and residual perversity

JMW Proposition 3.2 and Corollary 3.5 identify the point-summand
inclusion--projection composite with the corresponding fibre intersection
form over a field. For the two outer rank-one blocks, the same adjunction
calculation over `Z` is sufficient: each composite is `-1`, so rescaling one
arrow gives an idempotent with identity composite. The constructible derived
category is idempotent complete, and the cross-compositions between shifts
`2` and `-2` vanish. Therefore

`K = Z_0[2] direct-sum P direct-sum Z_0[-2]`

integrally.

Before removing the outer summands, the stalk degrees are
`-4,-2,-1,0,2` and the costalk degrees are `-2,0,1,2,4`. Removing the two
unit blocks leaves

- `H^r(i^*P)` nonzero only for `r=-4,-1,0`, with groups
  `Z,Z^10,Z`;
- `H^r(i^!P)` nonzero only for `r=0,1,4`, with groups
  `Z,Z^10,Z`.

Together with `P|_U=Z_U[4]`, these are exactly the support and cosupport
bounds for a perverse sheaf on the two-stratum fourfold. The integral
perversity assertion is correct.

### 3. Central attachment and integral non-splitting: (21)

The degree-three/four portion of the circle-bundle Gysin sequence is

`H^3(K,Z) -> Zh ->^(-3) Z ell -> H^4(K,Z)`.

The first arrow is zero because multiplication
`Zh -> Z ell` is injective. The last arrow sends `ell` to the order-three
class `tau=p^*ell`. Hence

`H^3(K,Z)=Z^10`,  `H^4(K,Z)=Z^10 direct-sum Z/3`,

and (21) is exact with Smith factor three. A free central point summand would
force a unit block in the rank-one groups `A` and `B`, contradicting this
Smith factor. A torsion point summand is also impossible because both `A`
and `B` are free. Thus the claimed integral central non-splitting is correct.

### 4. Inverting three: (22)

Over `Z[1/3]`, the map `-3:A->B` is a unit. Its normalized
inclusion--projection pair splits the central point object. The complement
still restricts to `Z[1/3]_U[4]`, while its degree-zero stalk and costalk at
the point vanish; equivalently, it has no point subobject or quotient. It is
therefore the intermediate extension. This gives exactly the four summands
in (22). The argument also works over any field of characteristic different
from three.

### 5. Derived characteristic-three attachment: (23)

The integral Gysin sequence also gives `H^5(K,Z)=0`, since
`ell -> [pt]` is a unit. Derived universal coefficients therefore give

`dim_F3 H^3(K,F3)=10+dim Tor_1(Z/3,F3)=11`

and

`dim_F3 H^4(K,F3)=dim ((Z^10 direct-sum Z/3) tensor F3)=11`.

Reducing the central intersection form gives zero. Exactness of the mod-three
Gysin sequence then gives precisely

`F3^11 twoheadrightarrow F3 ->^0 F3 hookrightarrow F3^11`,

which is (23). The extra source class is the Bockstein/Tor companion of
`tau`; the first arrow has a ten-dimensional kernel and the last a
ten-dimensional cokernel.

The zero central intersection form has rank zero, so JMW Proposition 3.2
rules out a point summand. If the residual perverse sheaf decomposed, its
simple rank-one restriction to `U` could occur in only one summand; every
other summand would be supported at the point, which has just been excluded.
It is therefore indecomposable. Its nonzero degree-zero costalk and stalk,
with zero map between them, show that it is not the intermediate extension
of the simple open local system, hence is not simple. An indecomposable
semisimple object is simple, so the object is nonsemisimple. The manuscript's
conclusion follows, not merely failure of the characteristic-zero
decomposition theorem.

## Exact findings

### Major findings

None.

### Required minor finding 1: make the coefficient-change bridge explicit

**Location:** printed p. 9, between (23) and the sentence “The zero middle form
rules out a point summand”; also the integral no-point-summand sentence just
before (22).

**Issue:** derived tensor product with `F3` is not t-exact on integral perverse
sheaves in general. The manuscript contains the data that settle the issue--all
remaining stalk and costalk groups listed after the outer splitting are
free--but it does not state the inference. Likewise, the Smith-factor argument
explicitly excludes a free `Z_0` block but does not say why a torsion-supported
point summand is impossible.

**Smallest adequate remedy:** add one sentence saying that the displayed
stalk/costalk groups of `P` are free, so derived reduction preserves their
degrees and therefore the perverse support/cosupport bounds; the same freeness
excludes a torsion point summand. Then apply the zero intersection form to
exclude the remaining free point summand.

**Severity:** required local exposition/proof bridge; no theorem change.

**Confidence:** high. It follows directly from the stalk/costalk lists, derived
universal coefficients, and the two-stratum perverse bounds.

### Required minor finding 2: state the Cipriani boundary

**Location:** printed p. 9, the indecomposability paragraph after (23), and the
bibliography.

**Issue:** the direct rank-one-restriction argument is correct, but it is a
special case of the general closed-stratum framework in Cipriani. Lemma 3.12
identifies absence of a point-supported summand with smallness when the local
system category on the closed stratum is semisimple; Theorem 3.21 and
Corollary 3.22 characterize indecomposable small extensions, and Remark 3.24
covers the indecomposable open restriction used here. The manuscript currently
does not cite this closest general result.

**Smallest adequate remedy:** add Cipriani to the bibliography and one sentence
after the concrete proof: the general categorical criterion is Cipriani's,
while this paper computes the particular intersection map, the two dimensions
11, and the resulting cubic-theta extension. Keep the elementary proof.

**Severity:** required local attribution/priority repair; no proof or claim
change.

**Confidence:** high, from the cited full-text statements and their hypotheses:
the closed stratum is a point, so `Loc({0},F3)` is semisimple.

### Optional polish

After excluding the point summand, replace “Its nonzero kernel and cokernel in
(23)” by “The zero middle map in (23) has nonzero kernel and cokernel.” This
makes clear that the kernel and cokernel meant are those of `F3 ->^0 F3`, not
the outer surjection and injection. The present sentence is recoverable from
context and is not mathematically wrong.

## Literature boundary

- **JMW establishes:** over a field, point-summand multiplicity equals the rank
  of the fibre intersection form, and the costalk-to-stalk map is that form.
  It also explains decomposition failure and parity-sheaf summands in modular
  coefficients.
- **JMW does not establish:** this cubic fibre's matrices `[-1],[-3],[-1]`, the
  integral splitting of its unit blocks, the dimensions 11, or the concrete
  theta-divisor residual object. The manuscript computes all of these.
- **Cipriani establishes:** a general additive-category framework for small
  extensions over a closed stratum and a criterion for their indecomposability.
- **Cipriani does not establish:** the link cohomology, Smith factor three,
  Bockstein class, or any cubic-threefold theta-divisor example. The manuscript's
  calculation and geometric application remain its own contribution.

## Failure modes explicitly checked

- No shift reversal in (19): the stalk shift is `[4]`, the costalk shift `[2]`.
- No hidden factor in (20): the forms are exactly `-1,-3,-1`.
- The two outer projectors split simultaneously; cross-compositions vanish.
- The residual object satisfies both integral perverse bounds.
- The central integral point block cannot split; no torsion point summand is
  hidden in the free rank-one groups.
- Localization at three produces the intermediate extension, not merely an
  unspecified complement.
- Both mod-three link groups have dimension 11; `H^5(K,Z)=0` removes a possible
  additional Tor term.
- The modular conclusion is indecomposable and nonsemisimple, not just
  non-isomorphic to the rational decomposition.
- The rendered abstract has 180 whitespace tokens, below 250.

## Mystery ledger

The explicit `ej`+`tt` closeout pass settles the only initially unexplained feature: the
eleventh degree-three mod-three link class is exactly the Tor/Bockstein companion
of the integral order-three class, while the eleventh degree-four class is its
tensor reduction. No genuine mathematical mystery remains in Packet A. Whether
one concrete modular-resolution example clears the *Algebraic Geometry* breadth
threshold is an editorial judgment owned by the final synthesis, not an evidence
gap in (19)--(23).

## Overall confidence

**High** on the mathematical verdict. Equations (19)--(23) were reconstructed
from the topology of the exceptional divisor, the Gysin sequence, and derived
universal coefficients, then checked against the relevant full-text JMW and
Cipriani statements. **High** on both B findings: each is a one-sentence local
repair with no effect on the theorem.

## Venue recommendations

- **Algebraic Geometry:** plausible after the two minor repairs, but not my
  strongest recommendation from Packet A alone. The modular decomposition
  example is sound and genuinely algebraic-geometric; the editorial synthesis
  should still test whether one concrete resolution reaches this venue's
  first-class breadth threshold.
- **Mathematische Zeitschrift:** recommend after minor revision; this is the
  strongest fit. The integral and modular decomposition theorem is a complete,
  self-contained specialist result, and the repaired literature boundary will
  make its contribution clear.
- **Proceedings of the AMS:** recommend after minor revision as a safe fallback.
  The 11-page paper lies below the current 15-page limit and is correct, new,
  and focused, although this venue understates the geometric/modular upgrade.

Venue judgment is separate from correctness: the **B** verdict is caused only
by the two local repairs above, not by any weakness in (19)--(23).
