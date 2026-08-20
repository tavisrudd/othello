# C934 priority audit: integral and modular decomposition of the cubic-theta resolution

**Date:** 2026-08-20

**Verdict:** partial framework overlap, with a surviving example-specific
theorem.  The rational decomposition is Krämer's.  General intersection-form
and modular-perverse frameworks explain what one should compute.  No checked
source computes the integral matrices `[-1],[-3],[-1]` for the resolution of
the cubic-threefold theta divisor, splits its two outer point objects over
`Z`, identifies its characteristic-three indecomposable perverse factor, or
constructs the degree-four Fano lift of the link's order-three class.

## Exact prior ownership

1. **Krämer owns the characteristic-zero formula.**  Corollary 6 of
   arXiv:1501.00226 gives
   `R sigma_* C_M[4] = IC_Theta + C_0[2] + C_0 + C_0[-2]` and computes the
   Euler characteristics.  It does not discuss integral or modular
   coefficients.
2. **de Cataldo--Migliorini own the rational intersection-form mechanism.**
   Their fourfold isolated-resolution discussion and perverse decomposition
   explain the rational pieces, but all relevant splitting statements in the
   checked text use rational coefficients.
3. **Juteau--Mautner--Williamson own the modular rank criterion.**
   Proposition 3.2 and Corollary 3.5 identify point-summand multiplicities and
   costalk-to-stalk maps with fibre intersection forms over a field.  Theorem
   3.13 explains modular direct images under parity hypotheses.  The cubic
   fibre here has odd middle cohomology, so that parity theorem is not itself
   the calculation; Proposition 3.2 still predicts the central rank drop.
4. **MacPherson--Vilonen own the field-coefficient gluing language.**  The
   convenient exact zig-zag is classical.  The manuscript proves its actual
   integral attachment directly and does not attribute a `Z`-linear
   classification theorem to that source.
5. **Cipriani owns a 2026 general classification of small and indecomposable
   extensions over a closed stratum.**  This supplies a modern categorical
   home for the characteristic-three object.  It contains no cubic, theta,
   intersection-form, or Smith-factor example.
6. **Rahman's 2026 paper concerns normal surface singularities.**  It relates
   ordinary and dual integral middle extensions to link torsion and resolution
   determinants in complex dimension two.  It neither covers the present
   fourfold resolution nor computes its direct image.

## Surviving claim package

- `R sigma_* Z_M[4]` splits as the two outer point objects plus a central
  perverse object whose costalk-to-stalk map is multiplication by three.
- The central rational point object has no integral lift as a direct summand.
- After derived reduction mod three the exact attachment is
  `F_3^11 ->> F_3 ->0 F_3 -> F_3^11`; the residual object is indecomposable
  and nonsemisimple.
- A point-class input to the resolved Fano difference map produces an
  infinite-order class restricting to the order-three link generator.  Hence
  the local class gives an index-three global attachment rather than a
  surviving global torsion class.
- Together with C928, the resolution exhibits distinct global mod-two
  Lefschetz glue and local mod-three decomposition failure.

## Full-text evidence

| source | cache key and SHA-256 | read depth | boundary |
|---|---|---|---|
| Krämer, *Cubic threefolds, Fano surfaces and the monodromy of the Gauss map* | `arXiv:1501.00226`, `bad27e7b9eee618e83259d392d706e0738756fa57cd33f021641c2f1b4fed9f6` | full, inherited and re-searched | rational formula only |
| de Cataldo--Migliorini, *Intersection forms, topology of maps and motivic decomposition for resolutions of threefolds* | `arXiv:math/0504554`, `f02d2127019d02e87934e1bcb2e5101dc909600d8c6b702ad7401619a95f20a6` | Sections 2.4, 4.2, 4.4 and intersection-form index searched | rational framework |
| Juteau--Mautner--Williamson, *Parity sheaves* | `arXiv:0906.2994`, `cb18832f73adb0b0ccc74d34f9f92b0ab52a9b275351c3658ee3f8f5eb88f3b4` | Sections 3.1--3.3 in full | field-coefficient general criterion; no example |
| Banagl--Budur--Maxim, *Intersection spaces, perverse sheaves and type IIB string theory* | `arXiv:1212.2196`, `8f8e1062395b04d39ce2afb8e97e623f2304bb405a45f023a060695b36a2a1aa` | Section 2.5 in full | rational zig-zag exposition |
| Cipriani, *Indecomposable extensions of perverse sheaves over a closed stratum* | `arXiv:2607.09379`, `2d8774913c1b33c0c255e6aa67309ddffcccd1e5869f8c28da76eead524d4a77` | full 15-page text | general field-coefficient classification; no cubic/theta example |
| Rahman, *Integral Perverse Obstructions for Normal Surface Singularities* | `arXiv:2604.22132`, `d8b93ed5ee08256307cbb3d1ab2cb132a79cf46827cb58ac44e20798840167fe` | introduction and Sections 2--5 | complex surfaces only |
| Bayer et al., *The desingularization of the theta divisor of a cubic threefold as a moduli space* | `arXiv:2011.12240`, `ce005e812a7223208938c266281b88c2dbcfc3e125079eb98fcba76b8d365c8a` | full-text keyword screen plus inherited geometry read | identifies the resolution; no topological direct image |

## Bounded search log

Web searches were run for the exact combinations

- `cubic threefold parity sheaves theta divisor`,
- `cubic threefold characteristic three theta divisor perverse`,
- `integral decomposition theorem theta divisor`,
- `modular decomposition theta divisor perverse`, and
- `cubic threefold theta divisor integral decomposition Smith form`.

The hits were either the sources above, unrelated uses of modular/theta, or
general decomposition-theorem references.  Full-text searches of Krämer,
Bayer et al., and de Cataldo--Migliorini for `integral`, `modular`,
`characteristic three`, `Smith`, and `intersection form` found no
example-specific pre-emption.

## Venue effect

The eight-page C928 version was a natural Proceedings paper.  The new
11-page manuscript has a broader sheaf-theoretic spine, an explicit modular
counterexample, and a geometric realization of the bad-prime class.  This
raises the credible target from Proceedings to a specialist geometry/topology
journal such as *Algebraic Geometry* or *Mathematische Zeitschrift*.  It does
not by itself make the paper an Annals-tier cubic-threefold result: the
rational decomposition and general modular mechanism are prior, and the new
theorem is a sharp computation for one distinguished resolution.

## Confidence and remaining risk

Priority confidence is medium-high.  The exact cubic-theta modular statement
was not found in the bounded full-text corpus.  The main residual risk is an
uncatalogued example in the modular decomposition literature, not overlap
with any identified cubic-threefold paper.  The manuscript should retain its
example-specific wording and explicit attribution to Krämer and
Juteau--Mautner--Williamson.
