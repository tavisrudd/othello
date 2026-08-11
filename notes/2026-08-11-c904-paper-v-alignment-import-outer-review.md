# Paper V alignment import: specialist outer review

**Date:** 2026-08-11  
**Verdict:** **GO**  
**Reviewed commit:** `5b11e0b923ad9501950b09b9e3895a670b775414`  
**Frozen PDF:** `papers/clebsch-round-trip/golden_companion_reconstruction.pdf`  
**SHA-256:** `4a53b2c415f38bf401216be7492b78aab9255715a55706073662cadea36ee92c`

## Scope and independence

This was a cold specialist review of the alignment import only. I read the
frozen PDF, the manuscript delta from parent `88603127c6e807d4e776ee708eb254489952c59b`,
and the unchanged groupoid section. I did not read any prior report, review,
script, or certificate.

The review tested three questions:

1. whether empty alignment incorrectly singles out one of the twelve labeled
   conference switching classes;
2. whether the recovered transitive `A5` marking selects exactly the invariant
   opposite pair;
3. whether any groupoid object, morphism, fibre, or the `uq` quotient changed.

## Findings

### 1. Empty alignment recognizes the full conference locus

Lemma 3.4 is correct. For a normalized Seidel representative on six labels,
the proof gives

\[
16|A(\Delta)|=\sum_{\{x,y\}}m(xy)^2,
\qquad m(xy)=S_{xy}(S^2)_{xy}.
\]

Since the diagonal of `S^2` is five, the aligned family is empty exactly when
`S^2 = 5I`. The statement therefore recognizes conference switching classes;
it does not choose an orientation or a marked companion.

I independently exhausted all `2^10 = 1024` normalized switching classes on a
fixed labeled six-set. The identity held in every class. Exactly twelve
classes had empty alignment, exactly twelve satisfied `S^2 = 5I`, and the two
sets were equal. Thus the new abstract and introduction correctly use the
plural “conference switching classes.” There is no false identification of a
single class.

### 2. The recovered `A5` marking selects the correct opposite pair

I independently constructed the transitive action of `A5` on its six
Sylow-5 subgroups and applied it to the twelve empty-alignment switching
classes. Exactly two classes are fixed by the full action, and they are
opposite under `S \mapsto -S` after switching normalization.

This matches Lemma 3.3 and justifies the last sentence of Lemma 3.4: empty
alignment supplies the twelve-class conference locus, while the recovered
`A5` action selects its unique invariant unordered opposite pair. The import
does not replace the marking by alignment data.

### 3. The groupoids, fibres, and `uq` quotient are unchanged

The commit changes only the abstract/introduction, inserts Lemma 3.4 after the
pre-existing intrinsic-pair lemma, adds that lemma to the verification-boundary
sentence, updates the conclusion, and adds two references. It does not edit
Section 5, “Intrinsic groupoids and exact marking fibres.”

As a byte-level check, I extracted that complete TeX section from the parent
and reviewed commits. Both have SHA-256
`90471e4fc4e3bc16435f0d22b91e7ccea743eb2a94fd6ba9226b8c951346b91c`.
Consequently the definitions of all three groupoids, their objects and metric
normalizer morphisms, Proposition 5.2, every forgetful fibre, and the
fixed-point-free action

\[
uq:(L,h,c)\longmapsto(qL,-qh,c)
\]

are textually unchanged. The theorem still means the action groupoid,
including morphisms and isotropy, rather than an orbit-set quotient.

## Rendered-PDF check

The supplied hash matches the frozen 21-page PDF. I inspected the rendered
abstract, Lemmas 3.3--3.4 and their page break, and the complete groupoid and
`uq` discussion on pages 12--13. The new formulas, quantifiers, plural locus
wording, and cross-references render legibly; the insertion creates no visible
collision or ambiguity.

## Closeout: `ej` + `tt`

The useful extra check was to separate the two finite claims rather than infer
one from the other: exhaustive switching-class enumeration certifies the
twelve-class unmarked locus, and an independently constructed Sylow action
certifies the two-class marked fixed locus. This closes the only plausible
outer-review failure mode.

## Mystery ledger

No genuine mystery remains in scope. The unmarked alignment test, the marked
`A5` selection, and the pre-existing groupoid quotient occupy distinct logical
levels and agree exactly.

## Verdict

**GO.** The alignment import is mathematically correct, marking-safe, and
noninvasive with respect to the groupoid, morphism, fibre, and `uq`-quotient
surface.
