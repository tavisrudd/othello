# C904 charge-three fibre polarization: exact source audit

Date: 2026-08-11

Status: bounded claim-specific primary-source audit; no manuscript or Lean
change

Read depth: zero sources were newly read cover-to-cover. Five primary sources
were read at the claim-specific partial depths recorded in Section 7. The
negative is bounded: MathSciNet and zbMATH were not covered, and no exhaustive
forward-citation census was attempted.

## Executive verdict

**The proposed direct import from Li--Lin--Pertusi--Zhao (LLPZ) to the
charge-three fourfold fails at the identification gate.** Voisin's classical
space `M9` is nine-dimensional, with four-dimensional general Abel--Jacobi
fibre. For an elliptic sextic `C`, LLPZ's exact table gives

\[
 [\operatorname {pr}(I_C(2))]=-3\alpha,
 \qquad
 [\operatorname {pr}(I_C(3))]=-3\beta.
\]

The Serre sequence

\[
             0\longrightarrow {\cal O}_Y\longrightarrow E
              \longrightarrow I_C(2)\longrightarrow0
\]

therefore gives `[pr(E)]=-3 alpha`. This class is nonprimitive. Its categorical
moduli has expected dimension ten and its general Abel--Jacobi fibre has
dimension five, not four. LLPZ's relative Neron--Severi and primitive-canonical
theorems are stated only for primitive classes and do not apply.

The mismatch is not repaired by twisting: an exact numerical projection
calculation below shows that every `[pr(E(t))]` is divisible by three. More
abstractly, no primitive class in the cubic Kuznetsov lattice has a
nine-dimensional moduli space.

No audited source prints any of the data needed for the proposed calculation
on the classical fourfold `V`:

- `Pic(V)` or even the Picard rank of a proper generic-fibre model;
- `-K_V` in a determinant-line basis;
- a divisor/fibre class for `M9 -> J` in a compact moduli space;
- a fourth self-intersection or Verlinde number.

LLPZ Question 8.10 explicitly leaves Picard rank, cohomology and a Verlinde
formula open even for their categorical fibres. Their nonprimitive moduli can
be singular and need not admit a universal family.

Thus the polarization attack is **not pre-empted, but it is not a cheap source
import**. It first needs a proper charge-three compactification over `J`, then a
canonical/determinant-line formula, and only then a fourth-intersection
calculation.

Finally, an odd fourth intersection does not by itself imply index one: it
only makes the index odd. In C904 it would imply index one after combining it
with the independently proved `ind(V) | 2`; this second input must be stated.

## 1. Three different fourfolds must not be identified

### 1.1 Voisin's charge-three fibre

Voisin defines `M9` as the moduli space of stable rank-two bundles `E` on a
cubic threefold with

\[
             c_1(E)=2H,\qquad \deg c_2(E)=6.
\]

She proves `dim M9=9` and constructs a dominant rational map

\[
       M_{6,1}\dashrightarrow M9
\]

whose general fibre is `P(H^0(Y,E))=P^3`. The Abel--Jacobi map of elliptic
sextics factors through the second Chern class of `E`; consequently the
expected general fibre of `M9 -> J(Y)` has dimension four. The paper does not
construct a projective compactification of this general fibre or compute its
Picard group, canonical class, determinant lines, or intersections.

### 1.2 LLPZ's nonprimitive categorical fibre

LLPZ use the basis

\[
 \alpha=(2,-H,-L/2,P/2),\qquad
 \beta=(1,0,-L,0)
\]

of `K_num(Ku(Y))`. Their Euler form gives

\[
 \chi(a\alpha+b\beta,a\alpha+b\beta)
       =-(a^2+ab+b^2),
\]

so a stable moduli space of class `-3 alpha` or `-3 beta` has expected
dimension `1-chi=10`. Theorem 7.2 does apply to nonprimitive classes and gives
a surjective Abel--Jacobi map with connected fibres; the expected fibre is a
fivefold.

The data needed for the polarization attack do not carry over:

- Corollary 3.9 (smooth, projective, fine) assumes a primitive class.
- Corollary 7.7 (relative Neron--Severi rank one) assumes a primitive class.
- Theorem 7.10 (Fano general fibre with primitive canonical class) assumes a
  primitive class.
- Section 5.2 says explicitly that for a nonprimitive class the moduli may be
  singular and may not admit a universal family.

Moreover, LLPZ's elliptic-sextic table is conditional on stability of the
projected ideal sheaf. It is not an identification of `M9` with
`M_sigma(-3 alpha)`. The cited Bernardara--Macri--Mehrotra--Stellari paper
proves stability and classification for ideal sheaves of **lines**, not for
elliptic sextics.

There is also a dimension obstruction to generic stability in the proposed
factorization. The map from elliptic sextics to projected objects is constant
on the `P^3` of sections of a fixed Serre bundle, so it factors through the
nine-dimensional `M9` wherever defined. It therefore cannot dominate the
ten-dimensional categorical moduli. No audited source constructs `M9` as a
Cartier Brill--Noether divisor there.

### 1.3 Bayer et al.'s theta resolution

Bayer--Beentjes--Feyzbakhsh--Hein--Martinelli--Rezaee--Schmidt study the
rank-three class

\[
                 v=(3,-H,-H^2/2,H^3/6).
\]

Their smooth fourfold is

\[
                 M_X(v)\simeq \operatorname {Bl}_0\Theta.
\]

Its Abel--Jacobi image is the theta divisor, its exceptional divisor is the
cubic threefold `X`, and Lemma 7.3 gives the exceptional normal bundle
`O_X(-H)`. This fourfold is a resolution of a divisor in `J`; it is not a
fibre of `M9 -> J`.

The shared dimension four is accidental for the present purpose.

## 2. Exact twist/projection obstruction

Use `H^2=3L`, `H^3=3P`. From the Serre sequence of an elliptic sextic,

\[
                  \operatorname {ch}(E)=(2,2H,0,-2P).
\]

Write the numerical projection as

\[
 [E(t)]=a_t\alpha+b_t\beta+x_t[\mathcal O_Y]
                         +y_t[\mathcal O_Y(H)].
\]

Comparison of the four Chern-character coordinates gives

\[
 \boxed{
 a_t=(t-1)(t+1)(t+3),\qquad
 b_t=t(t-2)(t+2).}
\]

Each product contains one representative of every residue class modulo
three, so `3 | a_t` and `3 | b_t` for every integer `t`. The checks

\[
 (a_{-1},b_{-1})=(0,3),\qquad
 (a_0,b_0)=(-3,0),\qquad (a_1,b_1)=(0,-3)
\]

show in particular that the normalized charge-three instanton `E(-1)` projects
to `3 beta`, and recover the two LLPZ table entries exactly. Hence no standard
twist and projection of the charge-three Serre bundle has primitive numerical
class.
Any further Kuznetsov autoequivalence preserves lattice divisibility.

There is an independent dimension obstruction. A primitive categorical
moduli space could equal `M9` only if

\[
                   a^2+ab+b^2=8.
\]

Modulo three the left side is `(a-b)^2`, hence is zero or one; eight is two.
There is no such class.

## 3. Exact printed formula ledger

| Source | Printed formula or theorem | What is **not** printed |
|---|---|---|
| Voisin, Section 2 | `dim M_{6,1}=12`, `dim M9=9`, general section fibre `P^3`; `D_{3,3}` dominates `M9` | `Pic(V)`, proper fibre model, `K_V`, determinant line, fibre class, fourth intersection |
| LLPZ, Notation 5.2 and Remark 8.9 | cubic Kuznetsov lattice and Euler form; elliptic sextic gives `-3 alpha` at twist 2 and `-3 beta` at twist 3 | identification with `M9`; stability of the elliptic-sextic projections |
| LLPZ, Theorem 7.2 | nonprimitive AJ map is surjective with connected fibres | smoothness, fineness, Picard rank or Fano theorem for the `3 alpha` fibre |
| LLPZ, Corollary 7.7 and Theorem 7.10 | for **primitive** class: relative NS rank one; general fibre Fano with primitive canonical; `K.ell=-1` on an extension line | a determinant expression for `K`, a top self-intersection, or full `Pic` of the fibre |
| LLPZ, Question 8.10 | asks for Picard rank, cohomology and a Verlinde formula | precisely the numerical package sought here |
| Bayer et al., Theorem 7.1 and Lemmas 7.3--7.5 | `M_X(v)=Bl_0 Theta`, exceptional `X`, `N_{X/M}=O_X(-H)` | any identification with the charge-three AJ fibre |
| Liu--Zhang, Theorems 1.3 and 1.6 | categorical identifications for norm `-1` bundles and norm `-4` charge-two instantons | charge three / norm `-9` |

The phrase “primitive canonical class” in LLPZ means indivisibility in the
Picard group: it is proved by a curve `ell` with `K.ell=-1`. It is not a
parity formula for `(-K)^n`.

## 4. A useful normalization trap: the irrelevant odd 117

The Bayer et al. formulas do permit an elementary intersection computation,
but on the wrong fourfold. Put

\[
 h=\pi^*\Theta|_M,\qquad e=[X]\subset M=\operatorname {Bl}_0\Theta.
\]

The theta divisor has multiplicity three at the origin. Adjunction in the
blow-up of the abelian fivefold gives

\[
                  K_M=h+e.
\]

Mixed products vanish because `h|_e` is trivial,
`h^4=Theta^5=5!=120`, and the printed normal bundle gives

\[
                  e^4=(-H)^3=-3.
\]

Thus

\[
                  K_M^4=117.
\]

This derived odd number is a good convention check and a serious conflation
hazard. It says nothing about the canonical fourth intersection of the
charge-three Abel--Jacobi fibre.

## 5. What an odd fourth intersection would prove

Let `V/K` be a proper integral fourfold and `L` a `K`-line bundle. The
intersection

\[
                      c_1(L)^4\cap[V]
\]

is a `K`-zero-cycle of degree `L^4`, so `ind(V)` divides `L^4`. Therefore:

- `L^4` odd implies only that `ind(V)` is odd;
- if one also knows `ind(V)|2`, then `L^4` odd implies `ind(V)=1`;
- a degree-one intersection implies index one without another input.

C904's independent degree-fifteen/index-equivalence work supplies the
separate bound `ind(V)|2`. The intended parity implication is therefore valid
in C904, but only as a gcd argument using both results.

There is a prior definitional gate: Voisin's `M9` is a stable-bundle locus,
not the proper smooth fourfold on which `(-K_V)^4` is automatically defined.
One must choose and control a proper generic-fibre model. Boundary
discrepancies can change canonical intersections, so a number computed on an
unidentified compactification is not an index certificate for the desired
model without a birational comparison.

## 6. Priority and highest-EV next move

No predecessor was located for a charge-three `Pic(V)`, canonical-class, or
top-intersection calculation. This is a bounded negative, not a global
priority claim. The latest broad categorical source explicitly records the
nearby Picard/Verlinde problem as open, while the exact classical and theta
resolution sources stop before the charge-three fibre.

The source-backed route, if retained, is:

1. construct a projective charge-three sheaf compactification carrying the
   Abel--Jacobi morphism and identify its geometric generic fourfold with the
   C904 `V` up to a controlled birational operation;
2. determine the boundary and canonical divisor, including discrepancies;
3. construct determinant lines from a universal or quasi-universal class and
   fix their normalization despite the nonprimitive gerbe;
4. compute one fourth intersection by GRR/localization; combine oddness with
   the independent `ind(V)|2` theorem.

Trying to pass through `M_sigma(3 alpha)` before proving an explicit
codimension-one charge-three locus is lower EV: it changes the fibre dimension,
loses the primitive theorems, and introduces a non-fine singular ambient
moduli problem.

## 7. Primary-source/read-depth ledger

1. **Claire Voisin, _Abel--Jacobi map, integral Hodge classes and
   decomposition of the diagonal_, arXiv:1005.5621.** Read depth:
   **claim-specific partial**, Theorem 2.1 and the complete `M9`, `D_{3,3}`
   construction in Section 2. Cached preprint key `arXiv:1005.5621`, SHA-256
   `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.

2. **Chunyi Li, Yinbang Lin, Laura Pertusi, Xiaolei Zhao, _Higher
   dimensional moduli spaces on Kuznetsov components of Fano threefolds_,
   arXiv:2406.09124 / J. Reine Angew. Math. 832 (2026).** Read depth:
   **claim-specific partial**, Introduction, Notations 5.1--5.3, Section 5.2,
   Theorem 7.2, Corollary 7.7, Theorem 7.10, Remark 8.9 and Question 8.10;
   published HTML spot-checked. Cached preprint key `arXiv:2406.09124`,
   SHA-256
   `c1aa5d752c9c081827d0aa2cec4ab6408e3868449ef3f7e7ba11a7f936bbdb25`.

3. **Arend Bayer, Sjoerd Viktor Beentjes, Soheyla Feyzbakhsh, Georg Hein,
   Diletta Martinelli, Fatemeh Rezaee, Benjamin Schmidt, _The
   desingularization of the theta divisor of a cubic threefold as a moduli
   space_, arXiv:2011.12240 / Geometry & Topology 28 (2024).** Read depth:
   **claim-specific partial**, Introduction, Corollary 6.9, Theorem 7.1 and
   Lemmas 7.3--7.5; published metadata checked. Cached preprint key
   `arXiv:2011.12240`, SHA-256
   `ce005e812a7223208938c266281b88c2dbcfc3e125079eb98fcba76b8d365c8a`.

4. **Zhiyu Liu, Shizhuo Zhang, _A note on Bridgeland moduli spaces and
   moduli spaces of sheaves on X14 and Y3_, arXiv:2106.01961 / Math. Z. 302
   (2022).** Read depth: **claim-specific partial**, Introduction and
   Theorems 1.3 and 1.6; published HTML checked. Cached preprint key
   `arXiv:2106.01961`, SHA-256
   `0cb659ad18cbe73d7807e2a673301169f91b6b3df9180be8faf6b6a7cce00f31`.

5. **Marcello Bernardara, Emanuele Macri, Sukhendu Mehrotra, Paolo
   Stellari, _A categorical invariant for cubic threefolds_,
   arXiv:0903.4414 / Adv. Math. 229 (2012).** Read depth:
   **claim-specific partial**, Introduction and Section 4, plus a full-text
   term screen for elliptic/sextic/degree-six ideal sheaves. Its stability
   theorem concerns ideal sheaves of lines. Cached preprint key
   `arXiv:0903.4414`, SHA-256
   `22fcb02de553d5e90d3fc0e1775ed256bbf7253c0af9175b89159a6a9ed1cff9`.

## 8. Search boundary

The bounded web/title/full-text screens used:

```text
"M_9" "elliptic curves of degree 6" cubic threefold
"c1(E)=2" "c2(E)=6" cubic threefold moduli
"elliptic sextic" "Kuznetsov component" cubic threefold moduli
"charge 3" instanton cubic threefold moduli canonical Picard
"M9" cubic threefold moduli stable rank 2 bundles Picard canonical
site:arxiv.org "M_9" "cubic threefold" Abel-Jacobi
```

They located no charge-three Picard, canonical, determinant, compactification,
or intersection theorem beyond Voisin's construction. MathSciNet and zbMATH
are **NOT COVERED**. Google Scholar was not used. This licenses only the bounded
negative above.

## 9. Correction propagation

The superseded identification occurred in
`2026-08-11-c904-relative-shen-descent-and-m9-polarization-audit.md`; that note
has been patched with a prominent correction and its Section 5 replaced by a
pointer here. A targeted live-note search for the phrases “relevant primitive
Bridgeland” and “appropriate primitive Bridgeland component” found no other
surface. No manuscript, claim ledger, snapshot, public summary, or handoff was
edited by this audit.

## Mystery ledger

- **Settled:** the LLPZ `M9` identification is impossible as stated; the
  relevant numerical class is nonprimitive and has the wrong dimension.
- **Settled:** every integral twist/projection of the Serre bundle remains
  three-divisible in the cubic Kuznetsov lattice.
- **Settled:** the odd `117` belongs to the theta resolution, not the
  charge-three fibre.
- **Settled:** odd top intersection yields index one here only after adjoining
  the independent `ind(V)|2` input.
- **Open:** construct and control a proper charge-three generic-fibre model.
- **Open:** compute its canonical/determinant lattice and one fourth
  intersection.
- **Dead as stated:** import LLPZ Corollary 7.7/Theorem 7.10 directly to
  classical `M9`.
- **Dead as stated:** identify the Bayer et al. theta-resolution fourfold with
  the charge-three Abel--Jacobi fourfold because both have dimension four.
