# C909 priority/judo audit: Prym index versus orbit-axis saturation

Date: 2026-08-12  
Status: durable source audit; no manuscript, PDF, mirror, or Lean edit

## Executive verdict

There are two very different claims in the current package.

* The **Prym-axis index identity** is GO as an internal lemma, once the
  finite map of double covers, principal Prym polarizations, primitive
  inclusion, and scalar exponent are stated.  It is a clean normalization
  detector, but its ingredients are classical norm/pullback and Rosati
  functoriality.  It should not be advertised as a new Prym construction.
* The **orbit-axis finite-etale saturation theorem is not a theorem as
  presently stated** (MAJOR).  Its fixed-axis recognition step follows from
  the index identity.  Its integral all-degree conclusion does not follow
  merely from a finite-etale spectral packet or from a positive Gram matrix:
  the proof silently assumes the exact graph Néron--Severi lattice and a
  rank-one square-zero spanning statement, including the delicate dyadic
  congruences and faithfully-flat descent.  With those statements made
  explicit as a separate local lattice theorem, the orbit result becomes a
  useful and honest composition theorem.

The safe novelty sentence is therefore:

> We isolate an elementary quotient-Prym index lemma and use it to normalize
> fixed axes; the substantive new arithmetic input, if proved, is an
> all-degree integral divisor-product saturation theorem for a specifically
> marked finite-etale graph lattice.  The orbit/Prym step is the geometric
> judo that supplies the marked elliptic-power presentation; it is not itself
> a new Prym--Tyurin theory.

## 1. The index lemma: what is proved and what is classical

Let a degree-​`m` map of smooth curves commute with étale double-cover
involutions, and let

```text
  pi^*: P_0 -> P,       pi^* = i phi,
```

be the induced map on principal Pryms, factored through the primitive image
`i:A -> P`.  Suppose `P_0` and `A` have relative dimension `r`, and the
induced polarization satisfies `i^dagger i=[e]`.  The standard Jacobian
identity `Nm_pi pi^*=[m]` restricts to Pryms.  The factor two between the
Jacobian theta and the principal étale-Prym theta occurs on both sides, so
the Prym Rosati identity is

```text
                    (pi^*)^dagger pi^* = [m].
```

Consequently

```text
  [m] = phi^dagger [e] phi = [e](phi^dagger phi),
  phi^dagger phi = [m/e],
  e | m,                       deg(phi) = (m/e)^r.
```

The divisibility follows because a rational scalar acting integrally on the
first homology lattice is an integer.  If `m/e` is odd, the kernel of `phi`
has odd order and `phi[2]` is an isomorphism.  If `e=m`, `phi` has degree one.
These are valid relative statements under the usual smooth proper and
connected-base hypotheses; no period calculation is involved.

This is best labeled an “index lemma,” not a literature-priority theorem.
Beauville's Prym construction supplies the norm-kernel and the principal
polarization (and records that the Jacobian polarization restricts as twice
the Prym polarization).  Carocca--Lange--Rodríguez--Rojas record the same
quotient norm identity in their Hecke/Prym construction.  The displayed
divisibility and degree calculation are the short Rosati substitution above.

For the cubic application, `m=5` and `e=5` imply degree one, but the value
`e=5` is an additional primitive-axis calculation.  Van Geemen--Yamauchi's
source statement that the explicit elliptic Prym is *isogenous* to the
elliptic factor does not by itself state degree one.  Roulleau supplies
specific elliptic fibrations and intersection configurations, but the
relative identification of the chosen axis and the exact primitive
polarization must still be printed or proved.  Thus “degree-one VGY/Prym
identification” is conditional until that input is present.

## 2. Hostile audit of the orbit-axis theorem

The following separation is needed.

### 2.1 Fixed-axis recognition: GO under explicit hypotheses

For an odd subgroup `H` of order `m`, assume the quotient double cover is
smooth étale with elliptic Prym `E_H`, the connected `H`-fixed Prym part is
the elliptic axis `A_H`, and the primitive inclusion has
`i_H^dagger i_H=[m]`.  Pullback is nonzero and lands in `A_H`; applying the
index lemma gives degree one.  This is a correct integral recognition step.

The sum of selected axis maps is an isogeny if their rational tangent spaces
span.  A positive integral Gram matrix computes the pullback polarization.
Those are standard abelian-variety facts, and Carocca--Lange--Rodríguez--
Rojas provide the relevant Hecke/fixed-subspace framework and the identity
`Nm pi_H pi_H^*=|H|`.

### 2.2 The graph-kernel arrow is not automatic: MAJOR qualification

From a sum of elliptic axis maps one obtains a finite kernel of an isogeny.
One does **not** automatically obtain the particular self-adjoint finite-
étale graph kernel used by the local saturation calculation.  The theorem
must include an actual identification of:

1. the coefficient elliptic scheme and its integral endomorphism order;
2. the kernel as the graph/matrix kernel with the advertised block labels;
3. the polarization/Rosati pairing on that kernel; and
4. the finite étale, unramified, block-respecting lift at every bad prime.

“The actual finite flat self-dual kernel is now an output” is too strong
without these comparisons.  Self-duality, in particular, is not a formal
consequence of “positive Gram matrix”; it belongs to an explicit polarized
kernel calculation.  If the graph identification is independently proved,
then the orbit construction may feed it into the saturation theorem.  It
cannot be listed as a consequence of the axis Gram alone.

### 2.3 Finite étale does not imply integral PD saturation: MAJOR gap

The present proof jumps from a finite-etale spectral packet to:

```text
  NS_graph^1 is generated by integral rank-one square-zero classes.
```

That is precisely the nontrivial arithmetic assertion.  It requires an
explicit local statement after an unramified faithfully flat extension,
including the matrix-of-ideals valuations, unit factors, and the dyadic
rank-one hull.  At `p=2`, an abstract symmetric matrix-unit decomposition is
not enough: divided-power denominators and the extra square term can leave a
nonzero quotient.  The earlier local audits found these defects unless the
exact graph lattice contains the required rank-one forms.

The theorem therefore needs a separate hypothesis or lemma, for example:

```text
(S) After a finite unramified faithfully flat extension at every bad prime,
    the actual graph NS lattice equals the lattice generated by the displayed
    integral rank-one square-zero divisor classes, with the stated descent
    equality of image lattices.
```

Only (S), not finite étaleness by itself, gives the ordinary integral
divisor-product identity in every degree.  The conclusion should be written
for the **prescribed graph lattice** `NS_graph`, not for all of `NS(P)`,
unless equality with the full Néron--Severi lattice is separately proved.
Non-CM coefficients remove extra CM endomorphisms but do not automatically
prove that a quotient's graph sublattice is saturated; that is the claim to
be checked.  At CM fibers additional divisor classes are present and should
remain outside the assertion.

Finally, “all degree” here means ordinary integral cohomological products of
the marked divisor lattice.  It does not mean the integral Hodge conjecture,
the full Hodge ring, or a Chow-level equality.  Faithfully-flat descent of
an equality of image lattices must be stated and proved; descent of the
classes alone is not enough.

## 3. Classical core versus likely-new composition

The focused primary corpus supports the following classical components:

* Beauville, *Variétés de Prym et jacobiennes intermédiaires*, §§0.2.3 and
  0.3.2 (ASENS 10, 1977), gives relative Prym schemes, norm kernels, and the
  principal Prym polarization with the factor-two restriction from the
  Jacobian polarization.
* Carocca--Lange--Rodríguez--Rojas, *Prym-Tyurin varieties via Hecke
  algebras*, arXiv:0805.4563v2, §3 and Proposition 2.4, gives fixed-subspace/
  Hecke constructions, integral symmetric correspondences, and the quotient
  identity `Nm pi_H pi_H^*=|H|`.
* Roulleau, *Elliptic curve configurations on Fano surfaces*,
  arXiv:0804.1861v2, Theorem 27 and Lemma 30, gives a special CM Fano
  surface whose Albanese is a product of elliptic curves; Roulleau,
  *Genus 2 curve configurations on Fano surfaces*, arXiv:1002.4467v1,
  Theorem 11(D,F), gives the D5 fibration/intersections and the A5 curve
  lattice.  These are specific cubic/Fano facts, not a general integral
  saturation theorem.
* Van Geemen--Yamauchi, *On intermediate Jacobians of cubic threefolds
  admitting an automorphism of order five*, arXiv:1506.05346v3, Propositions
  2.1, 3.1, and 3.2, gives the étale Prym diagram and says that the explicit
  elliptic Prym is isogenous to the order-five elliptic factor.  The paper's
  proposition does not print the degree-one upgrade; that upgrade is the
  conditional index calculation above.
* Milne, *Lefschetz classes on abelian varieties*, Duke Math. J. 96 (1999),
  Theorem in the introduction and §3, proves a rational (`Q`-algebra)
  divisor/Lefschetz statement.  It does not prove an ordinary integral
  divisor-product lattice equality.
* Moonen--Polishchuk, *Divided powers in Chow rings and integral Fourier
  transforms*, arXiv:0904.3995v1, Theorem 1.6, gives the classical divided
  power structure in the Pontryagin setting.  Beckmann, *Integral Fourier
  transforms and the integral Hodge conjecture for one-cycles on abelian
  varieties*, arXiv:2202.05230v2, Theorems 1.1--1.3 and 1.5, relates minimal
  classes, integral Fourier transforms, and one-cycle/Hodge consequences;
  it does not identify C909's ordinary divisor-product lattice.

The focused search did not locate an exact predecessor for the conjunction

```text
  odd quotient-Prym fixed axes
  + an actual marked finite-etale self-adjoint graph kernel
  + exact all-degree ordinary integral PD(NS_graph) saturation.
```

This is a bounded absence statement only.  It is not a claim of priority or
of firstness: MathSciNet, zbMATH Open, Google Scholar, OpenAlex/Crossref,
Semantic Scholar, and a systematic citation-graph search were not covered.
The focused query strings were:

```text
"finite etale graph cofactor saturation abelian varieties"
"ordinary integral divisor-product" elliptic power
"divisor-product lattice" abelian variety
"divided powers" "finite etale" graph
"Prym" "primitive" fixed axis polarization exponent
"norm pullback" Prym quotient isogeny
"Prym" elliptic fixed subvariety quotient
"integral cohomological PD saturation" abelian variety
```

The safe priority conclusion is “no exact predecessor located in this
focused corpus/bounded search,” with the local lattice theorem—not the
Prym index identity—as the plausible new mathematical core.

## 4. Judo and venue consequence

The useful pipeline is:

```text
odd quotient of double-cover family
  -> index lemma detects primitive landing and 2-torsion transfer
  -> fixed axes give a marked elliptic-power isogeny
  -> explicit graph-kernel/local lattice theorem gives ordinary integral PD.
```

The first arrow is a normalization detector.  The last arrow is the payload.
Presenting both as one “new Prym theorem” would invite a priority objection;
presenting the second as a marked arithmetic saturation theorem with a
Prym/Hecke input is both stronger and safer.

Venue-wise, the index lemma alone is an appendix-level or short structural
observation.  A complete orbit application with a genuinely proved local
graph saturation theorem, relative descent, and at least one nontrivial
family beyond the already-known A5/Fano configuration would be a substantial
geometry/arithmetic result and could support a strong specialist or
high-level venue.  The current A5 package alone should not be sold as a new
classification or as a top-tier theorem until the actual graph kernel,
primitive relative axis, and dyadic saturation are all printed.  A quantum
or birational obstruction is an independent detector and does not increase
the priority of the Prym index step.

## 5. Source ledger and audit depth

The following cached primary artifacts were accessed; the listed SHA-256 is
for the local extracted full-text file.  The load-bearing sections/results
were checked directly.  This is section-targeted full-text work, not an
exhaustive line-by-line reading or a broad bibliographic survey.

| source | load-bearing material | local extracted-text SHA-256 |
|---|---|---|
| Beauville, ASENS 10 (1977), DOI `10.24033/asens.1329` | §§0.2.3, 0.3.2; relative Prym and polarization factor 2 | `d1530f013e4197c88de861e6b6b7120bee70c59a6ebf24b16c37dea0609d2e64` |
| Carocca--Lange--Rodríguez--Rojas, arXiv:0805.4563v2 | Prop. 2.4, §3; fixed Hecke axes and norm identity | `bf60e4d93b145c605f79ef3b04a70199c6ac6172edf0ad2e4f6d8ff5c5f2fc3e` |
| Roulleau, arXiv:0804.1861v2 | Lemma 30, Theorem 27 | `474e10a1525051e8bcaebca73567e9a2975548fe898b77556aa1b22498f94796` |
| Roulleau, arXiv:1002.4467v1 | Theorem 11(D,F) | `82bacdaf9a25f968b5bddc9b6ae8d1be2e5a3e3b413508629a73d7e56241aba9` |
| Van Geemen--Yamauchi, arXiv:1506.05346v3 | Props. 2.1, 3.1, 3.2; étale Prym and isogeny-only statement | `ce55934cf6bc92370bf912c20a1dae4627929b3123d1782b88c4bfced3d5324e` |
| Milne, Duke Math. J. 96 (1999), DOI `10.1215/S0012-7094-99-09620-5` | introduction, §3; rational Lefschetz boundary | `70876f592d9446ebb0d6558472782926e2cb6a82dc6c68428ad696151806a0e0` |
| Moonen--Polishchuk, arXiv:0904.3995v1 | Theorem 1.6; divided powers/Fourier | `9eba45192f90e9f665c8fb824b83ddeab29c6d56a493f4063231d7b606df31c5` |
| Beckmann, arXiv:2202.05230v2 | Theorems 1.1--1.3, 1.5 | `37d20b5c7a575f36aa65137a11e7965258aa603eddb9ebed9206b5af3131f67a` |

No manuscript or source file was modified by this audit.
