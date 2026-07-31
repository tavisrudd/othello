# C680 — Paper III orientation-source integration

**Lane:** `clebsch`

**Status:** focused integration and mechanical local/isolated release gates
complete; a later stricter cold read reopened the canonical orientation bridge,
now owned by C733.  Submission also remains blocked by the immutable artifact
locator and the author's affiliation/contact metadata.

## Result

The manuscript now states and proves the arithmetic--harmonic orientation
source at the normalized-cover level.  Over the golden Clebsch chart, the
normalization of the pulled-back incidence cover is \(B_+\amalg B_-\), with
the literal two-configuration interpretation exactly on
\(D(\sigma_3)\).  The fixed-plane component carries the oriented source
\([C,Z_C]_{\rm or}\); the other component carries its deck-opposite.  The
golden exchanger identifies that opposite with \((-C,-Z_C)\) at the fibre
over \([xyz]\), while no global marking of the varying second configuration
is asserted.  The primitive pair-sum map transports the source sign to the
Petersen four-space and the exact degree-six Gaunt cubic.

The paper defines

\[
 Z_C\in\operatorname{Sym}^3((\mathbf Q^6/\mathbf Q\mathbf1)^*)
\]

and separates it explicitly from the cubic \(\sigma_3\) on the
four-dimensional five-letter module.  The theorem compares their orientation
source, not their polynomial domains or ambient harmonic representations.
The proof now derives \(C^2=5I\) from the tight-frame identity, derives
translation invariance from pair balance, and treats the golden-fibre
calculation as the normalization of the source convention rather than as a
monodromy argument.

No outer-six, middle-exterior, Pfaffian, determinant, Segre--Igusa, Cartan,
physical, exceptional-parent, or lattice shadow enters the manuscript.

## Paper-owned trust surface

The release surface now has five theorem-like statements and five trust rows.
The new orientation row distinguishes:

- the human normalization and extension argument using Hitchin's branch and
  chart theorems;
- the exact scalar factorization, conference, exchanger, triangle, and
  Petersen audit;
- an independent paper-local replay; and
- the unspecified geometric integral localization.

The new deterministic evidence bundle is
`verification/evidence/orientation_source.{py,json,sha256}` with
`orientation_source_replay.py`.  It reads only the paper-local harmonic
certificate.  It does not claim to prove scheme normalization, extension
across the branch divisor, or the geometric bad-prime set.

The formal boundary remains `none claimed`.  The supplemental pinned Lean
package covers the conference square, switching, triangle reversal,
augmentation descent, and related exact finite mechanisms, but no manuscript
theorem depends on it.  A source/toolchain/hash replay passed; no new Lean
build was warranted because the scheme-theoretic normalization is the new
load-bearing step and is not formalized.

## Release gates

From `papers/clebsch-passages/`:

```text
python3 verification/verify_release.py
```

passed the packaging vocabulary and allowlist checks, five-statement/five-row
identity, all three primary/checksum/independent evidence bundles, and the
warning-free manuscript build.  The same aggregate passed from a fresh
temporary tree containing only the paper directory.  Visual inspection of
the source-theorem pages and page 12 found no clipping or layout defect.  The
final fourteen-page PDF has SHA-256
`b4b4e710caae47bcb494e079f90078d0c191b9821b9635df3f6d1192e3e925e6`.

A first context-free PDF-only referee returned `REVISE` because the draft
used the golden fibre to infer a globally marked conference family on the
second component.  The manuscript now defines the deck-opposite source
directly and uses the golden exchanger only at \([xyz]\).  A fresh
context-free referee on the repaired PDF returned `GO`, with no blocker.  Its
remaining notation minor was absorbed by the exact
\(\operatorname{Sym}^3((\mathbf Q^6/\mathbf Q\mathbf1)^*)\) declaration and
the ordered-marking definition.  Its reported page-12 clipping was checked
against a 144-dpi render; the complete word and line are present.

A subsequent stricter context-free review accepted the arithmetic theorem,
harmonic theorem, trust boundaries, and layout, but returned `MAJOR REVISION`
on the bridge itself.  The fixed incidence plane supplies an unordered
configuration, whereas \([C,Z_C]_{\rm or}\) also uses an axis ordering,
representatives, lattice orientation, five plane-triple labels, and a
normalized chart lift.  The current deck-opposite convention does not prove
that the sheet canonically determines these choices or that the construction
is independent of them.  C733 now owns the exact disposition: prove descent
through the full ambiguity group, or weaken the theorem to retain the marking
and lift as hypotheses.

The same review found two bounded defects, repaired in commit `2274d095`:
the complete Hitchin-fibre assertion is now characteristic-zero only, with
coordinate reduction explicitly separated from the unspecified spread-out
range, and the finite-field fibre is defined as \(\mathcal Q_f\) rather than
the undefined and conflicting \(X_f\).  The full ordinary and isolated
release aggregates pass after this repair.

The integration commits are `53dd13b5` and `84c828df`.

## Extra-juice and Tao closeout

The `ej` pass promoted three free clarifications into the paper: the exact
five-dimensional domain of \(Z_C\), a two-line human derivation of the
conference square, and the pair-balance proof of translation invariance.
The `tt` pass tested whether the fibre calculation really controlled the
whole second component.  It did not; replacing that inference by the
deck-opposite source convention removed the only substantive cold-read
blocker without weakening the normalized-cover theorem.

No incidental observation met the discovery-track discriminator.

## Mystery ledger

| feature | status | evidence gap or boundary |
|---|---|---|
| common sign of the incidence and Gaunt cubics | reopened under C733 | prove marking/lift independence, or retain those data as explicit hypotheses |
| global marking of the varying second configuration | settled negatively | neither needed nor asserted; the golden calculation is fibre-local |
| domain and switching meaning of \(Z_C\) | settled | explicit quotient-dual symmetric cube and ordered-marking equivalence |
| behavior on \(\sigma_3=0\) | settled | unnormalized branches meet; normalization and source labels remain disjoint |
| full geometric bad-prime set | open | requires an integral incidence model with flatness, normality, and Stein comparison; no successor is allocated |
| Lean coverage of global incidence normalization | settled negatively | formal coverage remains `none claimed`; scalar formalization would not prove the scheme theorem |
| canonical sheet-to-source bridge | open under C733 | classify the ambiguity action and prove descent, or state a relative marked theorem |
| submission readiness | blocked | C733 first; then immutable artifact locator plus author affiliation/contact metadata |

Vibe check: the arithmetic and harmonic halves remain strong, but the bridge
is not release-ready.  C733 isolates the exact choice-independence theorem or
relative reformulation needed to recover a defensible submission surface.
