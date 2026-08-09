# Paper III cold read — Nigel Hitchin persona

Date: 2026-08-09

## Sealed-review boundary

Reviewed the frozen standalone snapshot `/home/tavis/src/math-papers/clebsch-passages` at commit
`7208275e6b5f979fea487d2130943bbd979aed37`.  The rendered
`clebsch_passages.pdf` has SHA-256
`6794202d653d6908b495120c47848162a15d357c1438611e9e42f10384472622`.
Both values were verified before reading.

The only dossier material read was Extracts H1/H2, Packet H, and the neutral protocol in the
specified line slices.  The assigned cached sources were:

- Nigel Hitchin, *Spherical harmonics and the icosahedron*, cache key
  `10.1090/crmp/047/14`, SHA-256
  `33cb8b2e5b7102c0adaeb1c00af1e8d1702f5fd086fa1abfddb739c149d05eeb`;
- Nigel Hitchin, *Vector bundles and the icosahedron*, cache key
  `10.1090/conm/522/10292`, SHA-256
  `7da4fb227846551a788821d2a6f8082aa4e75088d34633934ba34c4e7f59b722`.

I read the PDF before any supplement.  No prior review or other persona report was consulted.

## Frozen PDF-only proof assessment

This section records the assessment before opening `README.md`, `ARTIFACT.md`,
`literature-boundaries.md`, manuscript sources, or the public verification surface.  Later
supplemental information may confirm or change a finding but cannot serve as a premise in the
human proof.

### Strongest theorem package I believe the PDF establishes

Independently of the incidence-cover issue below, the paper gives a convincing marked operator
package: a golden six-axis configuration yields a symmetric conference operator with square
`5I`; its triangle cubic agrees, with the stated orientation conventions, with the
middle-exterior diagonal, commutator Pfaffian, and cross-golden determinant.  The six outer
coordinates recover the classical Segre--Clebsch--Igusa models.  The balanced-exchange theorem
and the aligned-four-set reconstruction theorem are self-contained combinatorial results, and
the degree-six Petersen construction reduces its invariant cubic to one exact moment.

For the arithmetic headline, the text constructs a rational Grassmannian incidence scheme and
proves that its generic field is quadratic.  Conditional on identifying the divisorial branch
of its finite Stein normalization scheme-theoretically with the reduced sextic `J0=0`, and on
fixing the normalization of `J0`, the remaining argument correctly reduces the extension to
`Q(P(H))(sqrt(c J0))`, evaluates `c=[5]` from the complete reduced fibre at `xyz`, and derives the
anti-invariant summand `O(-3)`.  Those two conditions are not yet discharged by the PDF and the
assigned Hitchin sources.

### Causal reconstruction without supplement

1. The three rational skew forms on the rational harmonic seven-space define a rational
   Mukai--Umemura model `X` in `Gr(3,H)`.  Its complex base change is Hitchin's smooth integral
   threefold.  The incidence `I` is a projective bundle over `X`, hence normal and integral.
2. Hitchin's Chern calculation `c3(E*)=2` makes the generic field of `I -> P(H)` quadratic.
3. The paper then declares the branch divisor of that quadratic field to be exactly the
   irreducible sextic `J0=0`.  With this input, the two-torsion-free divisor class group of
   projective space forces the field to have the form `K(sqrt(cJ0))`.
4. The conjugate Clebsch charts meet at `xyz`.  Hitchin's classification identifies the two
   geometric configurations there as `I_t` and `I_{1-t}`.  If the finite cover is etale there,
   their complete reduced residue algebra is `Q(sqrt(5))`, so specialization gives `c=[5]`.
5. Normality and the involution split the finite algebra as `O plus M`; the branch degree makes
   the reflexive line `M` equal to `O(-3)`, giving `z^2=5J0` after scaling.
6. Pullback to the Clebsch chart factors as two branches.  A marked component transports the
   relative sign to the conference operator and, by the primitive pair-sum map, to the Petersen
   four-space.  The operator and harmonic sections then establish their stated identities by
   finite algebra, representation multiplicity one, and one spherical-moment evaluation.

### Earliest unsupported implication

The earliest load-bearing implication I cannot justify occurs on PDF page 7 in Section 2.3:
from Hitchin's classification and invariant calculation the paper says that the rational
quadratic extension is branched *exactly* along `J0=0`.  The assigned sources establish a
complex/real geometric count (two, one, or infinitely many isotropic planes/configurations) and
the invariant hypersurface, but they do not identify the discriminant or ramification divisor
of this rational Stein algebra scheme-theoretically, with reduced multiplicity one.  The same
missing implication is used on page 8 to shrink the finite incidence map to an etale
neighbourhood of `xyz`; without it, two distinct geometric configurations do not by themselves
prove that the complete scheme-theoretic fibre is reduced.

At this point the field and base-change conventions are otherwise coherent: the rational
equations descend, complex smoothness gives geometric smoothness in characteristic zero, and
the two chart points are Galois conjugate with no label quotient silently introduced.  The
missing checks are flatness/unramifiedness of the finite map near the generic sextic and at
`xyz`, plus the order-one ramification needed for the reduced branch divisor.  A likely repair
is short but must be written: restrict to the quasi-finite locus, use smoothness of `I` and the
regular target with finite miracle flatness, and compute the local fibre/differential (or the
discriminant) at the generic branch and at `xyz`.  The cited Chern count alone supplies none of
these scheme-theoretic conclusions.

### Ranked PDF-only findings

1. **Proof gap — headline arithmetic cover.**  The scheme-theoretic branch/ramification claim
   above is missing.  It is the premise for the global square-class form, the etale golden fibre,
   and the exact Stein algebra.  This affects Theorem 1.1 and Proposition 1.2 at their source,
   although the visible ingredients suggest a local algebraic repair rather than a change of
   theorem.
2. **Normalization ambiguity — exact sextic.**  The introduction says `J0` simultaneously has
   Hitchin's displayed analytic normalization before his main theorem and the normalization of
   his appendix's final formula.  In the source appendix Hitchin explicitly says that one may
   rescale the symmetric form to take `lambda=4` before deriving `16 sigma3^2`; the paper does
   not give the conversion from the opening surface-integral matrix to that algebraic
   normalization.  Since `z^2=5J0` is an exact arithmetic equation rather than a sign test, the
   paper must define one rational normalization internally and verify both `iota_t^*J0=16
   sigma3^2` and the claimed value at `xyz` for that same polynomial.
3. **Citation overreach — strength of Hitchin input.**  The sentence that “Hitchin identifies
   the branch hypersurface” attributes rational, finite-cover and scheme-theoretic strength to
   sources that work with the complex Mukai--Umemura model and a real counting theorem.
   Hitchin supplies the geometric locus and count; the descent, normal finite cover,
   discriminant, and reduced ramification must be proved here.
4. **Exposition friction — competing theorem scales.**  The arithmetic source, two independent
   conference/two-graph classification results, four classical cubic shadows, and the harmonic
   return are each substantial.  Figure 1 gives a useful route, but the balanced-spectrum and
   four-local reconstruction theorems do not causally enter the incidence-to-harmonic sign
   comparison.  Presenting them as independent consequences more sharply would make the
   headline proof easier to audit.

I found no definite false geometric statement beyond the unresolved normalization identity and
no exceptional-order or sign error in the portions checked.  Labels, switching, global
negation, chart scaling, Galois conjugation, and deck exchange are unusually well separated in
Appendix A.

### Neutral protocol answers, frozen before supplement

1. **Strongest theorem/package.**  The operator, reconstruction, and Petersen harmonic theorems
   are credible as stated.  The exact rational incidence equation is credible only conditional
   on the missing branch and normalization arguments above.
2. **Causal proof.**  Rational skew-form model; Chern degree two; asserted branch sextic;
   projective-space divisor argument; golden complete fibre; Stein anti-invariant line;
   normalized chart splitting; marked conference and Petersen transport.
3. **Earliest unjustified implication.**  PDF page 7, Section 2.3: geometric one/two/infinite
   counting plus `J0=0` is promoted to the exact reduced branch divisor of the rational finite
   cover.
4. **Boundary checks there.**  Rational equations and characteristic-zero base change are sound;
   normality of `I` is sound; generic degree two is sound.  Missing are finite flatness on the
   relevant neighbourhood, scheme-reduced fibres, order-one ramification, and an internally
   fixed sextic scale.  The golden labels and exceptional infinite-family case are otherwise
   stated distinctly.
5. **Categories.**  No settled false statement; one central proof gap; one citation overreach;
   one load-bearing normalization ambiguity; one hierarchy/readability friction, ranked above.
6. **Verdict.**  **MAJOR**.
7. **Contribution relative to the packet.**  The paper algebrizes Hitchin's two-configuration
   geometry into a proposed rational quadratic cover, evaluates its golden descent class, and
   transports a marked deck sign through a conference carrier to a Petersen harmonic cubic.
   The balanced-exchange and four-local reconstruction results are additional independent
   contributions; the exposition does not show that they are required by that common mechanism.
8. **Advances bar assuming repairs.**  The combined arithmetic, operator, and harmonic package
   is significant enough for *Advances in Mathematics*.  Cross-field readability is close but
   not yet at that bar: the source/marking diagram helps, while the paper still asks a reader to
   audit several independent theorem scales before the main arithmetic trust boundary is fully
   visible.

## Permitted-supplement audit

I opened the supplement only after freezing the preceding assessment.  It supplies useful trust
boundaries and exact regression checks, but no human argument for the missing branch implication.
No supplemental file changed the categorical verdict or removed a finding.

### Files that confirmed findings

- `README.md` confirms the intended arithmetic-source/operator-shadow/harmonic-return hierarchy
  and explicitly calls the two-graph theorem independent.  It confirms Finding 4 and does not
  change it.
- `ARTIFACT.md` states that the incidence degree, branch divisor, local normalization comparison,
  and Clebsch-chart identity remain human arguments.  This directly confirms Findings 1 and 3;
  it supplies no missing human proof.
- `literature-boundaries.md`, row `ARITH-1`, treats Hitchin as owning the “branch sextic” and the
  exact pullback identity.  Comparing that description with the assigned primary sources confirms
  the citation-strength problem in Finding 3 and the normalization problem in Finding 2.
- `clebsch_passages.tex`, `sections/01-introduction.tex`, and
  `sections/02-orientation-cover.tex` confirm that the source says the opening analytic
  normalization and appendix formula “match,” and that the proof's only branch-divisor premise is
  the citation to Hitchin Sections 9--10.  There is no hidden differential, discriminant, miracle-
  flatness, or local-ring calculation in the manuscript source.
- `sections/03-orientation-source.tex`, `sections/04-arithmetic-specialization.tex`, and
  `sections/07-marking-ambiguities.tex` confirm the careful separation of switching, relabelling,
  chart scaling, Galois conjugation, and deck exchange.  They confirm the positive marking
  assessment and do not alter any finding.
- `sections/08-verification.tex` expressly leaves normalization of the pulled-back incidence
  scheme, extension across the branch divisor, the global incidence/Stein identification, the
  scheme-theoretic chart correspondence, and the geometric golden-fibre identification as human
  inputs.  This confirms Finding 1.
- `release_files.json`, `verification/README.md`, `verification/trust_manifest.json`,
  `verification/statement_identity.json`, and the `ARITH-1`/`ARITH-2` portion of
  `verification/passages_formal.json` confirm the public trust surface and frozen theorem text.
  The formal map explicitly excludes Hitchin incidence geometry, the global Stein algebra, the
  branch divisor, and the geometric Clebsch-chart correspondence.
- `verification/evidence/arithmetic_cover.json` checks the displayed golden six-sets, their
  metric determinants, exchanger, and spinor specialization, while explicitly not checking the
  branch divisor, local normalization comparison, or chart invariant identity.
  `verification/evidence/orientation_source.json` checks only the scalar factorization of the
  assumed pullback equation and says so.  These files confirm, rather than repair, Finding 1.
- `verification/evidence/harmonic_clebsch.json` confirms the Petersen spectrum, normalized Gram
  data, and exact fixed-line moment.  It strengthens confidence in the independent harmonic
  theorem but does not affect the arithmetic findings.

### Files that changed findings

None.

The source comparison makes the normalization issue particularly concrete.  Hitchin's appendix
resets the scale of its symmetric form (“we may as well normalize” so that `lambda=4`) before
introducing a new matrix `M` and deriving `3 tau3 - 4 tau1 tau2 = 16 sigma3^2`.  His opening
invariant instead applies the characteristic-polynomial expression to the surface-integral matrix
with its displayed scalar subtraction.  The paper provides no conversion equating these two
normalizations.  Accordingly, the phrase “the normalization in the displayed definition ... and
the matching final formula” is false as a source attribution unless an omitted conversion is
inserted.  A clean repair is to define a rational algebraic `J0` internally by a displayed formula
and then prove separately that it is a nonzero scalar multiple of Hitchin's analytic sign
invariant and that its Clebsch pullback is exactly `16 sigma3^2`.

## Final disposition

The supplement is admirably candid about its trust boundary, and the exact bundles strongly
support the finite operator and harmonic calculations.  They do not address the two human issues
that control the headline arithmetic equation: scheme-theoretic ramification of the rational
incidence cover and a single exact rational normalization of the sextic.

**Verdict: MAJOR.**

The required repair is focused rather than architectural: prove the finite-flat local branch and
reduced-fibre statements algebraically, and define and reconcile the exact `J0` normalization.
After those repairs, the paper has an *Advances in Mathematics*-level theorem package; a sharper
separation of the independent operator classifications would then address the remaining
cross-field readability concern.
