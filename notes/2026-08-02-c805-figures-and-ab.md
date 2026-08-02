# C805: explanatory figures and blind comparisons

Date: 2026-08-02

## Result

All six figures proposed by the round-two cold read were implemented, and
all six won a blinded comprehension comparison against an otherwise identical
passage without that figure.  The adopted set is:

| Figure source | Job | Placement | Blind result |
|---|---|---|---|
| `figures/01-operator-holonomy.tex` | make minimum-support transitions and loop holonomy concrete | after the definition of (M_A(i,j)) | A over B, high confidence |
| `figures/02-axis-recovery.tex` | expose the contraction-rank mechanism that recovers Weyl axes | after the diagonal-axes lemma | B over A, high confidence |
| `figures/03-symmetry-groups.tex` | separate scalar tori, finite projective quotients, atlas gauges, and party motion | after the discrete-symmetry proof | A over B, moderate confidence |
| `figures/04-defect-landscape.tex` | give a roadmap from local quadratic wells through Clifford separation to the explicit threshold | at the opening of the stability programme | B over A, high confidence |
| `figures/05-stability-radius.tex` | show the (R_k\sim k/e) generator-radius regime and its linear ceiling | after the order-three sharpness proposition | B over A, high confidence |
| `figures/06-pencil-quotient.tex` | assemble the degree-eight quotient and distinguish every special (z)-locus | after the pencil-classification theorem | A over B, high confidence |

The drawings use only black, gray, line pattern, and marker shape; every
caption defines its encoding and states the mathematical point.  TikZ and
PGFPlots keep the sources vector-native.  Per-figure switches in `main.tex`
make the A/B controls exact, and both the build dependency list and public/arXiv
exporter now include `figures/*.tex`.

## Blind protocol

The primary reader first completed the separately requested cold review
without seeing the C805 proposals, figure sources, or implementation.  The
reader then received only anonymous full-paper pairs `trial-01-A/B` through
`trial-06-A/B`, in presented order, with one figure toggled in each pair.  A/B
order was reversed across trials.  The prompt asked for a preference on
comprehension, an answer to a figure-specific mathematical probe, and any
false inference induced; aesthetics did not count.

Two first attempts were excluded rather than rationalized:

- Trial 03 initially concatenated two distinct exact sequences visually.  The
  implementation audit caught the error before adoption.  The diagram was
  corrected to display four separate exact rows, the pair was rebuilt, and a
  fresh reader who had seen neither proposal nor source judged it.
- Trial 04's first no-figure control retained an unresolved figure reference.
  The primary reader flagged it, so that preference was discarded.  The
  reference was moved inside the figure switch, both controls were rebuilt to
  equal polish, and a fresh reader judged the corrected pair.

The sealed assignment, revealed only after the reads, was figure-present in
01-A, 02-B, 03-A, 04-B, 05-B, and 06-A.  The final anonymous PDFs seen by the
readers had these SHA-256 identities:

```text
abd92f3bb7847fb7e567f409a5157a055a6845b89625c98522e8494c6bbe8bd6  trial-01-A.pdf
9c5156d2f5ea6963f640dbb8ab147f6df2d533969cdc7f221e201e788702748e  trial-01-B.pdf
1e97ba7bc314c0fb2e18e65facc8f5557043f5a75e14dae82e6bf15044f27fd8  trial-02-A.pdf
ced9e1a6c253593bd86578b014cc794197e784a107d023c759dddbeb42b98683  trial-02-B.pdf
82b52462fe1357cd999b3ccd14009ddbed6851ad3b9b097aafdbce66bd755d4  trial-03-A.pdf
ee27fb654b01911c692c594655e28c75e1fec8f86bb8337e2009c655aabd0bf7  trial-03-B.pdf
ac8ca30e2f6866c2db722b5640008c6909786ee7f8dbc327542e3675c9a09f22  trial-04-A.pdf
11746e4ab0f35eea453ff4c4eeba0c299dd0b83587209c9ed8957c745e46e2a7  trial-04-B.pdf
e7a944b2ecf04f98858c35f9a1bc7c94ca5856a65bddfb6506b9771627cc1aa6  trial-05-A.pdf
359a3cc0b718f8a18df1552333127a9debb45899571ff21cf44fe7a42af4ea5d  trial-05-B.pdf
6239e0aa5d5ceb7953c5ac7defe86d41ccb1a523ea44c948ae47ade796b796b6  trial-06-A.pdf
10c057eeec0c6fdaef5e42c520d987d22bcdd3d7c2ef0ec3d14fef2c3eb33833  trial-06-B.pdf
```

### Comprehension findings

- The holonomy reader correctly identified the atlas as the transition data
  (M_A(i,j)=p_jp_i^{-1}) and, at prime (q), identified
  (mathcal G_\psi) with the holonomy centralizer in
  (mathrm{SL}_2(q)).
- The axes reader immediately recovered the proof: contraction rank counts
  nonzero coordinates, so the rank-one locus is precisely the dual axes and a
  product equivalence must permute the Weyl axes.
- The group reader distinguished the nonfinite tuple groups (G,widetilde G),
  their identity component (T=(S^1)^{2m}), the finite quotients
  (Gamma,widetilde\Gamma), the realized permutation quotient (Pi), and
  the independent atlas sequence
  (1\to L_\psi\to\Gamma_\psi\to\mathcal G_\psi\to1).  The reader requested
  only that the float stop splitting the surrounding sentence; the final
  source fixes the figure at the end of the proof.
- The defect reader identified compactness's replacement as quantitative
  rounding to a product Clifford followed by the quantized stabilizer-overlap
  gap.  The reader also correctly denied both tempting overclaims: the drawing
  does not say that every local minimum is Clifford or that the displayed
  coordinate exhausts the group.
- The radius reader stated the correct object—generator (ell^1) radius, not a
  defect ball—derived linear growth for AME states from (k=m=n/2), and named
  the scalar-phase ceiling (2\pi(1-1/q)n).
- The pencil reader separated (z=-1/4) (excluded GRS boundary), (z=1)
  (bracket collision), (z=2,4/9) (detector-only transport divisor), and
  (z=4,12) (the (q=13) four-copy witness pair).

## Concurrent cold review of the recent upgrades

The independent reader gave the C804 recognition package a pass: no proof gap
was found in the partial-Weyl criterion, recognition subgroup, generation
argument, minimal-support realization, qubit specialization, CSS corollary,
integer-modulus extension, or atlas integration.  The trust boundary remains
accurate: the package is a manuscript proof with no Lean or certificate
coverage.

The same read found four follow-up items outside C805's figure implementation
scope:

1. The sentence asserting that an arbitrary additive code is generated by its
   minimal codewords is false at that generality.  It is unused by the
   recognition theorem and should be deleted or restricted and proved.
2. The abstract, introduction, and post-order-three discussion overstate the
   generator-coordinate stability region as a nonshrinking defect
   neighbourhood.  The admissible generator (ell^1) radius grows with
   uniformity order; the later defect-only decomposition threshold is still
   exponential.
3. The Gross--Van den Nest specialization sentence needs an exact source
   locator or removal.
4. Section 3 now spans recognition, atlases, encoder consequences, the full
   stability programme, and exact logical images.  Splitting these conceptual
   scales into numbered sections is the highest-value structural revision.

These findings are reported rather than silently edited because the added
cold-read request was review scope, not authorization for a further manuscript
revision.

## Validation and closeout

The figure gate passed a warning-free 51-page `make check`; the affected pages
for all six figures were rendered and inspected at publication scale.  The
release exporter was extended to include the vector figure sources in both
public and arXiv profiles, and the complete evidence replay and release gate
passed with public tree
`5bc5824fb8128f32725b5e6eef5280e36d5015d1b1e9089c7a6ffd8e0b76e2b0`
and formal tree
`b030f559acc08ef110f5a1bbbe29f1b84c19541fab44b191703dcc827d5b4bc9`.
The final PDF has SHA-256
`e367c7856d49f5b806f4f7fa4bcfcd0d5db842be6adb2eab5279a60787782b16`.

The standalone paper mirror passed its warning-free build and 43-artifact
paper-only verifier, with public tree
`3a7f8a493551ec223d10a82bd2692361dcce0959ca2f2865aa7d6d321239a914`.
Forward commit `4f64e7e` is synchronized and unpushed.

The extra-juice and adversarial closeout focused on the two ways an explanatory
figure could lie: combining distinct exact sequences and turning a local or
Clifford-only bound into a global landscape claim.  The first was caught and
repaired before the valid group comparison.  The defect falsehood probe and
caption settled the second: the upper markers are explicitly product
Cliffords, while the caption and adjacent roadmap give the rounding-to-Clifford
step before the overlap gap forces exact symmetry.

## Mystery ledger

- **Settled:** whether the group ladder conflated exact sequences.  The final
  diagram has four distinct exact rows and passed a fresh blind read.
- **Settled:** whether the defect schematic induced a claim about all local
  minima or all nonsymmetries.  The fresh reader denied both after the explicit
  falsehood probe.
- **Open, not a figure mystery:** the four manuscript findings from the
  concurrent cold review need a separately authorized correction pass.

No genuine explanatory-figure mystery remains.
