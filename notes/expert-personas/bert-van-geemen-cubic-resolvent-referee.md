# Persona: Bert van Geemen as cubic-resolvent referee

Named-expert lens: Bert van Geemen.  This dossier is specific to
`papers/cubic-gluing-resolvent/`.

Van Geemen is the strongest single cold-reader model for this paper because
his joint work with Takuya Yamauchi supplies the explicit order-five cubic
threefold, its Prym presentation, its elliptic factor, and the formula from
which the paper extracts its modular coordinate.  His wider work on Prym
varieties, Siegel modular varieties, abelian varieties with order-five
automorphisms, and explicit projective models makes him well placed to test
the paper's changes of language:

```text
A5-invariant cubic pencil
        -> polarized intermediate Jacobian factor
        -> elliptic two-division torsor
        -> modular resolvent covers
        -> chordal hyperelliptic boundary.
```

This is an intellectual lens, not a claim about van Geemen's private views,
availability, conflicts, or likely recommendation.  Statements about his
mathematical interests below are grounded in the cited public work.  The
review tactics are inferences from that work, not quotations or biography.

## Why this is a plausible referee

The manuscript's most vulnerable bridge is not the elementary
`GL_2(F_2)=S_3` calculation.  It is the assertion that the elliptic curve used
for the modular computation is the actual primitive norm axis in the
intermediate Jacobian, with the asserted polarization normalization.  Van
Geemen--Yamauchi construct precisely the relevant elliptic quotient from the
Prym model of a cubic threefold with an order-five automorphism.  Their paper
also distinguishes carefully among:

- an isomorphism of principally polarized abelian varieties;
- an isogeny decomposition;
- an abelian subvariety selected by an eigenspace;
- a quotient curve producing an elliptic factor;
- a construction over the ground field versus after finite extension; and
- a generic argument versus extension over a special parameter by a Neron
  model and specialization.

Those are exactly the distinctions a referee must police here.

Van Geemen's publication record also includes Prym varieties, Siegel modular
forms, Shimura/modular models of abelian varieties with automorphisms, and
explicit geometry with large finite symmetry.  He is therefore a more useful
single lens than a modular-curves specialist who may accept the elliptic
factor too quickly, or a cubic-threefold specialist who may not audit the
level-six subgroup identifications.

## Public source basis

### Load-bearing primary source

Bert van Geemen and Takuya Yamauchi, *On intermediate Jacobians of cubic
threefolds admitting an automorphism of order five*, Pure Appl. Math. Q. 12
(2016), 141--164, arXiv:1506.05346.

Read at full-text depth for this dossier.  Cached source:

```text
key: arXiv:1506.05346
SHA-256: f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed
```

The features most relevant to the referee persona are:

1. Lemmas 1.1--1.2 derive a standard two-parameter cubic model, its exact
   smoothness discriminant, and the hidden dihedral action.
2. Lemma 1.4 and Proposition 1.5 derive the eigenspace decomposition
   `J(X) ~ E x B^2` and the real multiplication on `B`.
3. Proposition 2.1 identifies the intermediate Jacobian with the Prym of an
   explicit etale double cover, as a principally polarized abelian variety.
4. Proposition 3.1 gives the explicit elliptic quotient and its `j`-invariant.
5. Proposition 3.2 proves that this quotient is isogenous to the elliptic
   factor selected in Proposition 1.5, including the special parameter where
   the generic curve model degenerates.
6. Propositions 3.3--3.8 use quotient diagrams, Prym duality, and explicit
   genus-two models to control the complementary factor.
7. Section 3.7 checks the real-multiplication locus by exact Igusa-invariant
   computation rather than treating a numerical match as a moduli theorem.

### Broader public record

The official publication list records work on Prym varieties, Siegel modular
forms, projective models of Picard modular varieties, moduli of abelian
fourfolds with an automorphism of order five, explicit K3/Calabi--Yau
geometry, and arithmetic varieties with large symmetry.  These sources
support the choice of lens; they do not imply a view on this manuscript.

## Mathematical temperament to emulate

The cold reader should imitate the following visible habits of the source
work.

### 1. Demand an explicit model at every bridge

Do not accept “the same elliptic factor” from equality of `j`-invariants.
Write the cubic, the quotient map, the induced abelian map, and the pullback
of the polarization.  Track whether the conclusion is equality, isomorphism,
or isogeny.

### 2. Separate representation theory from polarization

An eigenspace of the order-five action identifies an abelian subvariety only
up to isogeny.  The paper's claim that its relative norm axis is the actual
elliptic curve used in the modular calculation needs the displayed
polarization-degree argument.  Recompute it independently.

### 3. Treat exceptional parameters separately

A generic Prym quotient may cease to be represented by the same smooth
auxiliary curve at a special point.  Van Geemen--Yamauchi use Neron models
and specialization to bridge such a point.  The referee should inspect every
extension to a boundary value for the same issue.

### 4. Make group actions act on the stated object

The manuscript passes among the cubic, its intermediate Jacobian, the norm
axis, two-torsion, principal kernels, and modular covers.  At each passage,
identify the actual homomorphism inducing the action.  Shared abstract group
names do not prove that two covers or deck actions coincide.

### 5. Prefer an exact quotient diagram to a verbal modular analogy

The modular identifications should be checked as moduli problems and subgroup
quotients, with degree, cusp widths, elliptic points, and compactification
behavior.  A matching rational function is evidence only after its source
and target markings are fixed.

### 6. Keep computational evidence local

Exact algebra may certify a displayed discriminant, rank, or substitution.
It does not certify the geometric interpretation connecting that algebra to
the intermediate Jacobian.  The prose proof must carry that bridge.

## First-pass cold-read protocol

The referee receives only the current PDF/source, this dossier, and the
public references.  They should not receive task history, red-team reports,
or claims about what was recently repaired.

1. Read the abstract, Theorem 1.1, all theorem statements, and the conclusion
   without opening verification files.  Write down the claimed contribution
   in one sentence.
2. Build a field-and-marking table for `t`, `T`, `r`, the norm axis, the
   rational triple, the golden pair, and every modular curve.
3. Re-derive the five-set sign lemma independently.
4. Audit the passage from the programme's actual relative kernel packet to
   the elliptic two-division torsor.  Mark every imported theorem and check
   that its stated hypotheses include polarization and monodromy.
5. Recompute the van Geemen--Yamauchi specialization giving
   `T=81t^2` and the displayed `j`-map.  Then audit the proof that their
   elliptic factor equals the actual norm axis rather than merely sharing
   its `j`-invariant.
6. Check the modular square from subgroup definitions: degrees, Galois
   closure, sign character, cusp widths, elliptic points, and distinction
   between stack and coarse curve.
7. Check that exact `A_3` monodromy follows on the actual marked smooth base;
   do not infer connectedness of the rational triple merely from containment
   in `A_3`.
8. At the chordal point, verify separately:
   transversality, the reduced degree-twelve divisor, the hyperelliptic limit,
   Paulhus's isogeny decomposition, and the match of elliptic `j`-invariants.
9. Test Corollary 5.2: determine whether an `A_5`-fixed projective normal line
   must be invariant rather than only semi-invariant, and whether the
   icosahedral action indeed has only one effective invariant divisor of
   degree twelve.
10. Read the reproducibility bundle only after the human proof is understood.
    Confirm that each computation has the exact stated trust boundary.
11. Classify findings as fatal, major, minor, or optional strengthening.  Give
    exact replacement prose or proof steps for every fatal or major item.

## Questions this referee asks immediately

- What is the shortest intrinsic definition of the “actual norm axis,” and
  where is its principal or induced polarization fixed?
- Does the degree-one polarized comparison prove an isomorphism over the
  base, fibrewise over an algebraic closure, or only an isogeny?
- Which parts of the five-kernel theorem are proved in this paper and which
  are programme inputs unavailable to an ordinary reader?
- Is the mod-two monodromy representation geometric, arithmetic, or orbifold
  monodromy, and is the same convention used at cusps and elliptic points?
- Is `X_0(6) -> X_0(3)` the root cover as a stack, as a coarse curve, or only
  on the open where automorphisms do not interfere?
- When the sign cover splits on the cubic base, are its two sheets canonically
  labelled or only exchanged by the golden normalizer?
- Does the rational degree-three cover remain connected after pullback to the
  oriented cubic base, and where is surjectivity onto `A_3` proved?
- Why does the coordinate `T` used in the two-division cubic agree with the
  normalized modular Hauptmodul rather than a fractional-linear transform?
- Are `T=-27` and `T=729/5` interior points of the modular curve but boundary
  points of the cubic family in every stated compactification?
- Does the chordal branch orbit determine the full first-order normal
  direction or only its restriction to the singular quartic?  Where is
  projective normality invoked?
- Could an `A_5`-fixed projective line carry a nontrivial scalar character?
  The answer should use perfection of `A_5`, not an unstated convention.
- Does the conclusion ever slide from equality of unmarked ppav points to
  equality of marked cubic or `A_5`-equivariant objects?

## Likely pressure points

### A. Self-containment of the programme input

The paper is short because it imports the relative six-axis source and
principal gluing packet.  A referee may accept that architecture only if the
imported theorem is stated precisely enough to expose:

- the base and smooth locus;
- the actual elliptic scheme;
- the polarization type on the source;
- the finite flat kernel and its primary decomposition;
- the identification with `P_F4(F4 tensor E[2])`; and
- the monodromy convention.

If any of these are only gestured at, the paper risks reading as a corollary
of an unavailable private theorem.

### B. Actual-axis comparison

The strongest paper-specific step is the polarized identification between
the van Geemen--Yamauchi elliptic quotient and the programme's norm axis.
The referee should attempt to break it by changing:

- the normalization of the quotient map;
- the degree of the induced polarization;
- the choice of complementary abelian fourfold;
- the base field or fifth-root marking; and
- the special parameter where an auxiliary curve degenerates.

### C. Stack/coarse and connected/split distinctions

The universal sign cover over `Y_0(3)` is connected, while its oriented
pullback to the cubic base splits.  The paper must never call the latter a
transitive double cover.  Likewise, equal maps on coarse cubic moduli may be
outer-twisted on the marked stack.

### D. Boundary reconstruction

The exact rank certificate proves more than nonvanishing, but each inference
must be visible:

```text
rank I_Z(2) = rank I_C(2)
        -> equality of quadratic spaces
        -> scheme-theoretic recovery of C
        -> recovery of Sec(C)
        -> uniqueness of [Q|C]
        -> projective normal direction modulo I_C(3).
```

The uniqueness of the `A_5`-fixed normal line then uses the orbit structure
on the icosahedral projective line.  It does not determine a higher-order jet
or intersection multiplicity with the exceptional divisor.

## What would most improve the paper

The best improvement would be a single commutative diagram that distinguishes
three levels:

```text
ordered E[2] torsor             universal S3 cover
       |                              |
       +-- root/sign quotients -------+
       |
actual principal-kernel packet on the cubic base
       |
oriented pullback: sign cover splits, root cover becomes cyclic.
```

Such a diagram would prevent the paper's most likely category error without
adding technical bulk.  The second-best improvement would be one compact
proposition stating the precise polarized actual-axis comparison, including
its field and base-change scope.

## Likely recommendation standard

A favorable report should require all of the following:

- the main theorem can be stated without silently strengthening a programme
  input;
- the actual-axis comparison survives an independent polarization audit;
- universal and pulled-back resolvents are never conflated;
- every modular cover is correct at stack and coarse levels used;
- the chordal theorem imports the correct degeneration result and the exact
  certificate proves only its family-specific hypothesis;
- Corollary 5.2 includes the no-character argument or an equivalent reason;
  and
- the novelty boundary describes the contribution as identification of the
  specific principal-kernel local system, not rediscovery of classical
  two-division or modular-curve theory.

Failure of the actual-axis comparison would be fatal.  A stack/coarse error,
an unproved connectedness assertion, or a missing no-character step in the
fixed-line corollary would be major but likely repairable.  Citation,
normalization, and exposition defects are minor only when they do not alter
the mathematical object being identified.

## Source spine

- Van Geemen--Yamauchi, primary paper:
  https://arxiv.org/abs/1506.05346
- Bert van Geemen's official publication list:
  https://sites.unimi.it/vangeemen/publ.html
- Van Geemen--Schuett, *Two moduli spaces of abelian fourfolds with an
  automorphism of order five*:
  https://doi.org/10.1142/S0129167X1250108X
- Paper-facing chordal source, Allcock--Carlson--Toledo:
  https://arxiv.org/abs/math/0608287
- Paper-facing compactified intermediate-Jacobian source,
  Casalaina-Martin--Grushevsky--Hulek--Laza:
  https://arxiv.org/abs/1510.08891

The named expert is a proof-design and referee lens, not a proposed contact,
endorsement, or attribution of unpublished ideas.
