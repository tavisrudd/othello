# C942 final mathematical and prose cold read

**Commit reviewed:** `d35683e81`  
**Artifact:** `papers/cubic-stabilization-m1/REVIEWER_GUIDE.md`  
**Verdict:** PASS, with two minor editorial findings  
**Confidence:** high (0.94)

## Scope and method

This was a fresh cold read. I did not consult any earlier C942 report. I read the
reviewer guide and repository README, then checked its mathematical route against
the primary manuscript statements and proofs in Sections 1--3. I checked its
source-boundary claims against `verification/imported-sources.json`, its formal
coverage counts and limitations against `lean/verification/claims.json`, and its
build/audit description against the root Makefile and the two verification
READMEs.

## Findings

### Fatal

None.

### Major

None.

### Minor

1. **The opening slightly overstates self-containment.** “The primary paper
   contains the whole proof” is understandable as “the complete written
   argument,” and the later paragraph correctly lists the imported theorems.
   Read literally, however, “whole proof” sits awkwardly beside the five classes
   of outside input. “The complete written argument is in the primary paper”
   would preserve the intended boundary more exactly.

2. **“Strict fragments” is not the inventory's classification label.** The
   primary manuscript does have exactly five `fragment`, nine
   `conditional_deduction`, and one `absent` rows, with no `complete` row. The
   guide's count is therefore right, but `claims.json` classifies the five as
   `fragment`, not “strict fragment.” This is harmless English if “strict” means
   proper rather than complete, but a referee-facing audit guide should either
   use the exact registry word “fragments” or define the adjective.

## Mathematical verdict

The six-check route is accurate and preserves the proof's logical order.

- The ledger summary correctly distinguishes generalized Euler eigenspaces from
  formal connection blocks and retains actual center occurrences.
- The comparison summary names the genuine compatibility gates: common
  coefficient spines, faithful center base change, even-carrier restriction,
  regularity in the loop variable, grading shifts, and occurrence indexing.
- The rank-two summary correctly says why the elementary modification is
  regular, why its residue varies by conjugation, and why nonzero discriminant
  alone is insufficient: resonant but unequal residue eigenvalues would pass
  that weaker test.
- The cubic values are exact: the modified zero-block residue has eigenvalues
  `-1/6` and `-5/6`, exponent-class difference `2/3`, discriminant `4/9`, and
  marker value one.
- The low-dimensional summary matches the proof's cases: points, curves,
  nef-canonical surfaces, the projective plane, ruled surfaces, and point
  blowups, followed by faithful passage to actual comparison occurrences.
- The endpoints are exact: the projective-bundle formula gives marker two on
  `X x P^1`; generic quantum multiplication on `P^4` has five distinct
  eigenvalues and marker zero; weak factorization and center nullity yield the
  contradiction.

The guide also states the trust boundary accurately. The six imported inputs it
names all have pinpoint and convention records. The headline theorem carries no
computational-evidence dependency. The Lean paragraph correctly limits the
artifact to ledger/telescope, residue-algebra fragments, and typed-premise final
deductions while excluding the geometric comparisons, weak factorization,
faithful center base change, regular-singular identification, and geometric
center nullity. The Makefile confirms that `make check` performs lint,
source-only formal correspondence, PDF construction, and warning rejection; it
does not build Lean or run the captured axiom audit.

## Strongest passage

Check 3 is the strongest passage. It gives a referee the exact point at which a
plausible shortcut fails: nonzero residue discriminant does not imply distinct
formal exponent classes modulo the integers. That sentence is mathematically
specific, changes how the proof should be checked, and avoids both exposition
for its own sake and audit boilerplate.

## First friction

The first friction occurs in the opening sentence, at “contains the whole
proof.” The phrase briefly asks the reader to decide whether cited comparison,
factorization, classification, and regular-singular theorems count as being
“contained.” The later outside-input paragraph resolves the issue, so this is a
wording hesitation rather than a trust-boundary error.

## Label and link audit

All ten mathematical identifiers cited in the guide resolve uniquely in the
primary manuscript:

`thm:every-cubic`, `prop:generic-spectral-connection-splitting`,
`thm:marker-ledger`, `lem:faithful-center-base-change`,
`prop:qdm-operation-ledgers`, `lem:A0preserve`, `prop:rank2-rigidity`,
`prop:residue-discriminant-exponents`, `prop:cubic-block-data`, and
`prop:atomic-lowdim`.

Every relative file link in the guide resolves, including the public Lean entry
point, both formal-inventory files, both verification READMEs, the imported
source registry, and the two manuscript sections named in the reading route.

## Prose verdict

PASS. The revision reads as natural referee orientation rather than generated
audit prose. The question headings give each check a real reviewing task; the
sentences vary enough in length and shape; verbs generally carry the argument;
and technical noun lists occur only where a referee genuinely needs a checklist.
There are no clusters of generic AI vocabulary, canned “Moreover/Furthermore”
transitions, participial afterthoughts, corrective mini-slogans, ornamental
groups of three, or broad claims of significance. The repeated six-item syntax
is structural rather than automatic, since the proof itself has six distinct
gates. “The paper writes out all six steps” is mildly self-certifying, but the
following paragraphs immediately replace that assertion with an exact source
and evidence boundary. Apart from the two minor points above, the guide meets
the repository style guide's standard of calm, reader-first, expert-speed prose.
