# C1089 — Paper I: marginal certification, parent Hamiltonian, and stochastic conversion

**Lane:** `ame-lu`
**Status:** complete (see closing sections for the cold read, export, and mystery ledger)
**Source review:** `2026-09-06-astra-review-ame-lu-clebsch-quantum.md`
**Literature:** `2026-09-06-c1089-literature-ame-marginals-slocc.md`

## What was added to *Robust Local-Unitary Rigidity of Stabilizer AME States*

New subsection "Marginal certification and stochastic conversion"
(`subsec:marginal-certification`) at the end of the atlas section, before the encoder
consequences.

**Proposition `prop:marginal-certification`** (stabilizer `AME(2m,q)`, `m ≥ 2`, `B` an
`m`-set, `A_j = B ∪ {j}`, `Π_j = q^{m-1} ρ_{A_j} ⊗ I`):

1. `Π_j` is the projector onto the joint `+1` space of the lifts of `L(A_j)`; the `Π_j`
   commute; `∏ Π_j = |ψ><ψ|` (half-set direct sum plus (2.2)).
2. The `m` reductions `ρ_{A_j}` determine `ψ` among all density operators.  In general a
   family of `(m+1)`-party reductions determines `ψ` iff the supported subgroups span `L`;
   hence at least `m` are needed (the direct sum's optimality clause).
3. Reductions to `≤ m` parties are maximally mixed, so carry no information.
4. `H = Σ (I − Π_j)` is `(m+1)`-local, commuting-projector, kernel `Cψ`, gap exactly one,
   and `1 − <ψ|σ|ψ> ≤ Tr(Hσ) ≤ Σ_j ½‖σ_{A_j} − ρ_{A_j}‖_1` for every density operator `σ`.
5. No nonscalar `m`-local Hamiltonian has `ψ` as a ground state.

**Corollary `cor:stochastic-conversion`**: if `(⊗A_i)ψ = cφ`, `c ≠ 0`, between stabilizer
`AME(2m,q)` states, every `A_i` is a scalar multiple of a Clifford unitary.  SLOCC, LU, and LC
equivalence coincide; exact single-copy conversion succeeds with probability one or zero;
`cor:finite-recognition` decides which.  Proof: invertibility from full-rank one-party
reductions, polar decomposition `A_i = c_i U_i e^{H_i}` with traceless `H_i`, convexity of
`f(t) = log‖e^{tH}ψ‖²` with `f'(0) = f'(1) = 0` from one-party maximal mixing, so
`Var_ψ(H) = 0`, and the two-uniform expansion `<H²> = q^{-1} Σ Tr H_i²` forces `H_i = 0`.

Literature paragraphs cite Wu–Yang–Wang–Wen–Qin–Gao (PRA 92, 012305, Theorem 2) as the
generator-support predecessor, Jones–Linden for the generic `n/2+1` locality, Tóth–Gühne for
the witness, Kempf–Ness and Gour–Wallach (NJP 13, 073013) for SLOCC = LU on critical states,
Burchardt–Raissi (PRA 102, 022413, Corollary 1) for AME states, the AME review for the
conversion dichotomy, and Englbrecht–Kraus for the qubit stabilizer comparison.  Five
bibliography entries were added; authors and DOIs were verified against arXiv and Crossref.

Abstract, contribution paragraph, organization sentence, conclusion, README, theorem map,
claim/proof/novelty ledger, and the trust-boundary table were updated.  No Lean coverage
is claimed; both statements are "manuscript only".

## Cold read

An Opus cold reader (`2026-09-07-c1089-cold-read.md`) confirmed both proofs correct with no
gap and returned `MAJOR` for two literature sentences plus sixteen minor/nit items.  All
were repaired in the second commit:

- Jones–Linden now says "determined among pure states"; the new result is "among all
  density operators".
- The Kempf–Ness sentence now speaks of pairs of critical states, not of SLOCC classes.
- The corollary carries the party permutation of Theorem 1.1, restricts the three relations
  to the set of stabilizer AME states, states the optimal conversion probability, and names
  where `m ≥ 2` enters; the proof spells out invertibility, analyticity at the endpoint,
  and the Kraus output-space convention.
- The projector symbol collision with the label spaces `P_j` is removed (`Π_{C_i}`, and the
  on-`A_j` projector is written out), `Tr σ = 1` is used explicitly, the gap-attainment
  sentence is expanded, `Tr h_k` is disambiguated, and (v) says "scalar multiple of the
  identity" for a Hermitian operator.
- The "neither number can be reduced" sentence now states exactly what is proved: no
  `≤ m`-party family suffices, and at support size `m+1` fewer than `m` never suffice.

## Validation

- `make check` (warning-free) passes; the paper grows from 34 to 38 A4 pages.
- `release/verify_release.py --write` then `--require-formal` pass (18 public artifacts,
  83 formal companion artifacts); the manifest is committed with the PDF.
- Rendered pages 14–16 were inspected; no overfull boxes or float problems.
- Authority commits: `d90915b26` (first version), `99440160f` (cold-read repairs), and
  `c96ac488e` (spanning criterion stated for every stabilizer state, from the closeout pass).

## Closeout pass (`ej` + `tt`)

Done now, free: the spanning criterion in (ii) needs nothing AME-specific, so the literature
paragraph states it for every stabilizer state (a prime-power, additive, iff form of the
Wu–Yang–Wang–Wen–Qin–Gao generator-support criterion).  The portfolio summary's quoted
abstract and standout results were refreshed.

## Mystery ledger

1. **Pure-state determination (UDP) count.**  The lower bound "fewer than `m` reductions of
   size `m+1` never suffice" is proved among mixed states.  Whether fewer suffice among pure
   states is open; the construction would need a *pure* state in the joint `+1` space of a
   proper subgroup with the same reductions.  Evidence gap: no computation.  Not queued.
2. **Which `m`-families span.**  The families `B ∪ {j}` span `L`; whether every family of
   `m` sets of size `m+1` with independent supported subgroups spans, and how the spanning
   families sit combinatorially, is untested.  Logged to the discovery track.
3. **Non-stabilizer AME states.**  Nothing here covers them; the projector identity is the
   stabilizer input.  Whether `m` reductions determine a general AME state among mixed
   states is open and out of this paper's scope.
4. **Certificate constant.**  `1 − F ≤ Σ_j δ_j` has coefficient one per marginal; no
   optimality is claimed and none was tested.

No other unexplained feature was found.

## Export

- Paper repository `~/src/math-papers/ame-lu`: forward commits `cad3857` (after the
  cold-read repairs) and `f5eb6b2` (final); authority and repository PDFs are
  byte-identical and the release public-tree hashes agree; the repository's
  `make release-check` passes with the 83-artifact formal companion recorded by tree hash.
- Portfolio summary: authority `papers/summary/README.md` updated and copied one way to
  `~/src/math-papers/math-papers-summary` as a forward commit.
- Nothing was pushed, deposited, tagged, uploaded, or submitted.
