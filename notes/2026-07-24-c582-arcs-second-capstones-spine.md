# C582 arcs-paper second-capstones spine

**Lane:** `relconic`

**Status:** complete.

## Result

The manuscript now presents two additional faces of its central defect
identity at theorem level.

1. **Terminal ten-point equality classification.**  Zero defect produces a
   rank-three `MATCH(10,5,1)` design.  Mathon's two-class abstract
   classification, C574's exact rank-three certificates, and the even-size
   conic spectrum together prove that the only ten-point conic equality case
   is the regular hyperoval \(\mathcal C\cup\{N\}\) in
   \(\operatorname{PG}(2,8)\).  The other abstract class has no rank-three
   realization over any field; the regular class is realizable exactly in
   characteristic two over fields containing \(\mathbf F_8\).
2. **Forward/inverse theorem spine.**  The introduction and abstract now pair
   the forward prescribed-hole defect identity with the exact inverse theorem:
   when \(q+1>\binom{k}{2}\), the complete uncovered locus canonically
   determines its parent arc and its full projective-semilinear automorphism
   group.  The conclusion now asks for a quantitative inverse rather than
   leaving this theorem as a secondary coding observation.

The rank-three theorem is in the equality-design subsection; its conic
specialization closes the former \(q=8\) or \(37\) alternative in the
even-size equality corollary.  The proof audit and verification trust table
state the exact imported/computational boundary.

## Paper-local evidence package

The landed C574 bundle was normalized into referee-facing paths with no task
or workflow vocabulary:

- `papers/arcs_complete_outside_conic/check_match10_rank_three.py`;
- `papers/arcs_complete_outside_conic/check_match10_rank_three.json`;
- `papers/arcs_complete_outside_conic/check_match10_rank_three.sha256`.

The generator is 21,258 bytes with SHA-256
`e19d9feee10aac64e881fedd31f6cedbb8523f6865e7210c6089ae5e84dc904a`;
the 77,767-byte JSON certificate has SHA-256
`84b9b4beb48fd309d7f7c14bdf40062ae3b0a2d78605468f08d48c602f53970d`.
`lean/RelativeConicArcs/TRUST.md` records the replay command, exact domain,
independent checks, and trusted boundary.  No Lean theorem consumes this
certificate.

Abstract completeness of the two matching designs remains Mathon's published
classification as recorded by Alspach--Heinrich.  The certificate
independently constructs both representatives and proves their rank-three
realizability spectrum; it is not represented as an independent proof that
no third abstract class exists.

## Validation

From `papers/arcs_complete_outside_conic/`:

```text
nix shell nixpkgs#singular --command \
  python3 check_match10_rank_three.py --check
sha256sum -c check_match10_rank_three.sha256
nix shell nixpkgs#texliveFull --command bash -lc \
  'xelatex -interaction=nonstopmode -halt-on-error arcs_complete_outside_conic.tex &&
   xelatex -interaction=nonstopmode -halt-on-error arcs_complete_outside_conic.tex'
```

The exact certificate replay and both checksums pass.  XeLaTeX produces a
25-page PDF with no undefined references, undefined citations, or overfull
boxes.  The sole underfull bibliography box predates C582.

## `ej` + `tt` closeout

The cheap extra value was not another finite value of
\(\rho_{\mathcal C}(q)\).  The C574 field spectrum closes the manuscript's
visible \(q=37\) equality opening, while the already-proved reconstruction
theorem supplies a second conceptual direction for the same incidence data.
Both upgrades are now in the abstract, introduction, theorem hierarchy,
conclusion, proof audit, and trust map.

The Tao-style question is whether exact inversion survives perturbation.
This exposed one bounded successor rather than a broad stability program:
C583 must first quantify recovery of a finite line union from a small
symmetric difference, test adversarial concurrency, and only then use arc
vertices or C558's bad-edge defect.  The manuscript carries a source TODO
beside the exact inverse theorem and a rendered open problem with that
boundary.

## Mystery ledger

- **Robust inversion:** open and owned by C583.  The exact missing result is a
  field-uniform line-threshold lemma converting
  \(|U(A)\mathbin{\triangle}U(B)|\) into control of the symmetric difference
  of the two secant-line sets.  No projective stability is claimed.
- **Mathon primary proof:** open source-depth gap.  The primary pages
  classifying the two abstract designs were not reached; the manuscript cites
  Mathon and explicitly records that completeness is imported through
  Alspach--Heinrich's published account.  This does not weaken the independent
  rank-three certificate, but it remains the exact attribution boundary.
- **Paper hierarchy:** settled.  The defect identity is the forward
  accounting theorem, matching-design realizability is its equality face, and
  uncovered-locus reconstruction is its inverse face.  No additional
  manuscript capstone is currently evidenced.
