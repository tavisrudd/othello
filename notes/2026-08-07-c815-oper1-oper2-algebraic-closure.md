# C815 — the algebraic residues of gap class B rows OPER-1 and OPER-2

**Date:** 2026-08-07
**Task:** C815
**Lane:** `clebsch`
**Status:** landed and validated; every residue of rows OPER-1 and OPER-2 is
closed except one deliberately unformalized basis comparison, stated below

## What was closed

Row OPER-1 had two residues open — coherence of the outer six-family, and the
cross-golden determinant comparison — and row OPER-2 had four: the outer
matching-frame identification, the coefficientwise identification of the six
signed translates with the coloured-triangle coordinates, the diagonal Clebsch
section, and the Segre–Igusa polar map. All six are now kernel-checked.

### Coherence of the outer six-family

`RelativeConicArcs.ClebschOuterJoubertFrame` attaches to each of the six
reorderings of the labels `3`, `4`, `5` the conference matrix
`C.submatrix σ⁻¹ σ⁻¹`. Each is symmetric (`outerConference_transpose`), has
vanishing diagonal (`outerConference_apply_self`), has off-diagonal entries
squaring to one (`outerConference_apply_sq`) and satisfies the same conference
equation `C² = 5 • 1` (`outerConference_sq`). The square is not re-decided: it
is transported along the relabelling, which is a ring map on matrices.

The twenty triangle products of each representative, weighted by the sign of its
reordering, are recorded as an explicit twenty-term sign word. `outerColouring`
is that table; `outerColouring_eq_smul_triangleSign` proves it is exactly what
the reordering rule `ε_{pT}(S) = sgn(p) ε_T(p⁻¹S)` produces,
`outerColouring_injective` proves the six words are pairwise distinct, so the
family has six members and not fewer, and `outerColouring_four_point` proves
each word obeys the four-point two-graph identity — the global sign of a row is
a fourth power and drops out, so this is the four-point identity for the
representative's triangle products.

### Cross-golden determinant comparison

`RelativeConicArcs.CrossGoldenDeterminant` works over a commutative ring in
which two is invertible and which carries an invertible `s` with `s * s = 5`.
The golden projectors `P± = (1 ± s⁻¹C)/2` are symmetric, sum to the identity and
are idempotent, the last because `C * C = 5 • 1`.

The load-bearing step is `bracketMatrix_eq_smul_sub_transpose`: the commutator
`Dₓ C - C Dₓ` is `2 s (B - Bᵀ)` for `B = P₋ Dₓ P₊`. Its proof uses only the
symmetry of `C`: in the expansion of `P₋ Dₓ P₊ - P₊ Dₓ P₋` the two triple
products in which the conference matrix appears twice cancel, and twice the
commutator survives. Since the commutator has order six, taking determinants
multiplies by `(2s)⁶ = 8000`, and the earlier `det = 16 Z²` then gives
`Z² = 500 det(B - Bᵀ)` after cancelling the invertible factor sixteen
(`triangleCubic_sq_eq_five_hundred_mul_det`).

`B - Bᵀ` is skew-symmetric with vanishing diagonal, so the determinant-square
theorem of 2026-08-05 applies and the identity becomes a comparison of squares,
`Z² = (10 s · Pf(B - Bᵀ))²` (`triangleCubic_sq_eq_pfaffian_sq`); over an
integral domain, `Z = ± 10 s · Pf(B - Bᵀ)`
(`triangleCubic_eq_or_eq_neg`). That is the manuscript's `Z_T = ±10√5 det B_T`,
and the proof also explains its sign: replacing `s` by `-s` exchanges the two
projectors and negates the Pfaffian, so the sign is an orientation of the two
spectral spaces rather than a property of `C`.

### Outer matching-frame identification

`RelativeConicArcs.ClebschOuterMatchingFrame` defines a one-factorization of the
six labels as a family of five fixed-point-free involutions in which every
unordered pair of distinct labels lies in exactly one, and defines the
complementary triangle colouring without a choice function. For a triple `S`
and its complement, the incidence matrix whose `(k,l)` entry is one exactly when
the edge of `S` omitting its `k`-th label and the edge of `Sᶜ` omitting its
`l`-th label lie in a common matching is a permutation matrix; its determinant,
times the sign of the listing of `S` before `Sᶜ`, is the colouring.

Six explicit one-factorizations are verified as such
(`isOneFactorization_oneFactorization`) and their colourings are exactly the six
coefficient words, in order (`matchingColouring_oneFactorization`); since the
words are pairwise distinct so are the factorizations
(`oneFactorization_injective`).

The converse is proved rather than cited:
`exists_outerColouring_of_isOneFactorization` shows every one-factorization
gives one of the six words, so there are exactly six such colourings. The
colours are first renamed to be listed by the label each matching uses at the
root — the colouring does not see colour names
(`matchingColouring_comp`) — and each normalized matching is then one of the
three through its root edge (`exists_eq_matchingThrough`, decided over all
six-tuples of labels). Among the two hundred and forty-three normalized
candidates the partitioning condition selects exactly the six listed families.

### Diagonal Clebsch section and Segre–Igusa polar map

`RelativeConicArcs.SegreIgusaPolar` proves both constructions on a point of the
Segre cubic, that is, a six-tuple with vanishing sum and vanishing cube sum.

The section is `sum_erase_eq_zero_of_apply_eq_zero` and
`sum_pow_three_erase_eq_zero_of_apply_eq_zero`: if one coordinate vanishes the
remaining five again have vanishing sum and vanishing cube sum, which is the
diagonal cubic surface inside the projective three-space that the linear
relation cuts out. `outerCubic_diagonal_section` is the same statement for the
six outer cubics.

The polar map uses the denominator-free normalization `V = 6 z² - Σ z²`, six
times the manuscript's centered square; both sides of the quartic relation are
homogeneous of degree four, so the common factor is immaterial. The six always
sum to zero (`sum_centeredSquare`), and on the Segre cubic they satisfy the
Igusa relation `(Σ V²)² = 4 Σ V⁴` (`igusa_relation_of_segre`,
`igusa_relation_outerCubic`).

That relation is proved structurally, not by a certificate. Each of the six
coordinates is a root of the monic degree-six polynomial whose coefficients are
their elementary symmetric functions; multiplying that vanishing by `z²` and
summing expresses the eighth power sum through the lower ones, and Newton's
identities in degrees two, three and four remove the symmetric functions,
consuming the two Segre relations exactly where the first and third power sums
appear. What is left is the power-sum identity

  `48 p₈ = 12 p₄² - 12 p₂² p₄ + p₂⁴ + 32 p₂ p₆`   (`powerSum_eight_of_segre`),

and the Igusa relation is `-108` times it. Every step is a small `ring` check;
no cofactor certificate in six variables appears.

`det_bracket_outerReindex` and `sixteen_mul_centeredSquare_outerCubic` return the
map to the operator picture: the commutator-bracket determinant at the reordered
coordinates is sixteen times the square of the corresponding outer cubic, so
sixteen times the centered square of the six outer cubics is the centered family
of those six determinants, which is the manuscript's centered determinant.

## What is deliberately not formalized

The manuscript writes the cross-golden comparison with `det B_T(x)` for the map
induced between the two spectral spaces, a determinant defined only after
choosing bases and orienting the two determinant lines. The Lean statements
avoid that choice: `Pf(B - Bᵀ)` is the basis-free stand-in, and the `±` is
exactly the orientation the manuscript also leaves free. The comparison of that
Pfaffian with the determinant of a three-by-three matrix representing the
induced map in a chosen pair of orthonormal frames is not formalized; it would
need block-determinant machinery for a six-by-six matrix split as three plus
three, and it adds no mathematical content to the identity. This is a
restriction on the form of the statement, not a gap in it.

## A correction the manuscript needs

**Row `r = 2` of the displayed table (5.1) in
`papers/clebsch-passages/sections/05-golden-operator.tex` is wrong.** Its last
six signs — those on the triples `135`, `145`, `234`, `235`, `245` and `345` —
are each the negative of the correct value. The printed row is

  `+-+-+---++--++-+-+-+`

and the correct row is

  `+-+-+---++--+++-+-+-`.

Three independent checks agree on the correction, and each of them refutes the
printed row on its own:

1. the rule the manuscript itself states two lines below the table,
   `ε_{pT₀}(S) = sgn(p) ε_{T₀}(p⁻¹S)` with `p = 012435`, gives the corrected row;
2. the printed row violates the four-point two-graph identity on eight of the
   fifteen four-element label sets, so it is not the triangle-sign function of
   any signed graph and cannot be a coloured-triangle coordinate at all;
3. the printed table's columns do not sum to zero on those same six triples, so
   it contradicts the paper's own first Segre relation `Σ_T J_T = 0`; with the
   corrected row every column sums to zero.

The corrected row is also what the Lean table `outerColouring` contains, and
what the complementary triangle colouring of the corresponding one-factorization
produces.

No theorem changes. The table is displayed to fix signs, and the sentence it
supports — that table (5.1) identifies the six operator cubics with the signed
Joubert coordinates — is true of the corrected table. The manuscript edit is
queued for C816, which owns manuscript promotion; Paper III's public versions 1
and 2 carry the defective row, so a forward version should correct it.

## Validation

- `lean/scripts/guarded-lean` on each of the four new modules — no errors, no
  warnings.
- `lean/scripts/lean-build-queue.py build RelativeConicArcs.Gates.ClebschGoldenReturn`
  — success, 1:25 wall, 7.0 GB peak.
- The golden-return gate now audits 119 terminals. Every one depends only on
  `propext`, `Classical.choice` and `Quot.sound`, several on strictly fewer;
  `native_decide` occurs nowhere in the pinned closure and the replay refuses it.
- `golden_return_axioms.txt`, `golden_return_source_closure.json` (29 modules)
  and the tracked gate stdout regenerated by their committed generators from
  that build; `golden_return_formal.json` and `passages_formal.json` updated.
- Paper-local replays pass: golden return in both source-only and axiom-log
  modes, passages, four shadow. `verify_scaffold.py` passes.
- `verify_release.py --lean-root ../../lean` passes every check — allowlist,
  public vocabulary, statement identity, trust manifest, formal companion pin,
  the arithmetic-cover and harmonic-bridge replays, all three Lean gates, and the
  spacing lint — except the manuscript build, which reports that the tracked PDF
  differs from a deterministic rebuild of the tracked source. That check is
  untouched by this work: no manuscript source, no PDF and no build input
  changed here. The rebuild used `nixpkgs#texlive.combined.scheme-full` from the
  mutable registry rather than the pinned environment the Makefile names, and
  this repository root has no `flake.nix`, so as on 2026-08-05 the run cannot
  separate a genuinely stale tracked PDF from an unpinned TeX. No PDF was
  rebuilt or committed.

Replay, from the paper root:

```text
python3 verification/verify_golden_return_lean.py --lean-root ../../lean --source-only
python3 verification/verify_golden_return_lean.py --lean-root ../../lean \
  --axiom-log verification/evidence/gate_stdout/golden_return.stdout.txt
python3 verification/verify_scaffold.py
```

## Ledger state after the round

Both rows' `coverage` tokens in the claim maps still read
`partial mechanism; no full row claim`, and the manifest's global
formal-coverage status still says that no complete manuscript row is claimed.
Those strings are hard-coded for all nine rows in `verify_scaffold.py`, so
promoting them is a change to the release contract and belongs with the
coordinated trust and release pass, not to a single row's closure. The same
applies to the `status` field of the trust rows.

What was corrected here is factual drift. The trust manifest's OPER-2 row
recorded no formal mode and no formal evidence at all, although its Segre
equations had been kernel-checked since 2026-08-05, and neither operator row's
`proof_role` named the formalized route. Both rows now describe the surface that
exists, and the frozen trust-row identity was regenerated by its own extractor;
only the trust rows changed, no theorem text moved, and every release check
except the manuscript build passes.

## Extra juice and Tao pass

Taken now, because it was cheap:

- The classification of one-factorizations was proved rather than attributed.
  The first plan was to list six and cite the classical count; the normalization
  by the root label made the converse a two-hundred-and-forty-three-case
  decision behind one tuple-level classification of matchings, so the count is a
  theorem.
- The Igusa relation was going to be a cofactor certificate in six variables.
  Routing it through the characteristic polynomial and Newton's identities
  replaced a several-hundred-term cofactor with five small `ring` checks and
  produced a statement of independent interest, that on the Segre cubic the
  eighth power sum is determined by the second, fourth and sixth.
- The `±` in the manuscript's cross-golden formula is now explained rather than
  merely permitted: it is the sign ambiguity of the square root of five, and the
  proof exhibits the involution `s ↦ -s` that realizes it.

## Mystery ledger

- **Settled.** The naive sign of the cross bijection from a triple to its
  complement is *not* a two-graph: it fails the four-point identity. The
  complementary triangle colouring needs the extra factor `(-1)^{σ(S)-3}`, the
  same Hodge sign the manuscript uses for the middle exterior power, and with
  that factor every one-factorization gives a two-graph. That the orientation
  sign of the middle-degree Hodge star is exactly the correction turning a
  matching bijection into a two-graph was not anticipated; it is measured here
  and logged on the discovery track.
- **Settled.** Why the six one-factorizations land on the six reordering
  translates in the same order was a coincidence of enumeration, not a fact;
  the tables here are ordered to make the correspondence the identity, and
  nothing depends on the order.
- **Open, with an owner.** Whether the printed table (5.1) error entered at
  typesetting or at computation is not determined, and the same question applies
  to any other displayed sign table in the released paper. The bounded check is
  cheap — the four-point identity and the column sums refute a wrong row without
  recomputing anything — and belongs with the C816 manuscript pass.
- **Open, deliberately.** The frame comparison of `Pf(B - Bᵀ)` with a
  three-by-three determinant, as described above. It is a statement-form
  restriction with a named route, not an evidence gap.

No other genuine mystery remains in these two rows.
