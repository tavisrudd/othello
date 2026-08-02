# C804: Fable red team on the recognition-group criterion

**Date:** 2026-08-02
**Lane:** `ame-lu`
**Objects attacked:** `notes/2026-08-02-c804-recognition-group-criterion.md` (the criterion
note), the C807 audit records, `notes/2026-08-02-c804-ab/version-b.tex`, against
`papers/ame_lu/sections/01-introduction.tex`, `02-geometry-ame-dictionary.tex`,
`03-lu-rigidity.tex` (read in full) and the cached sources
`arXiv:quant-ph/0411115` (Van den Nest–Dehaene–De Moor), `arXiv:2507.09416` (Wong–Jiang).
Brief: break the mathematics. Confirmed breaks are separated from suspicions throughout;
inferences marked mine are mine.

## Verdict summary

Confirmed breaks, in order of consequence:

1. **(T5) Wong–Jiang's printed stabilizer generators are not a group, and the audit
   computed from them.** Over Z₉ the labels of `X₁X₂X₃` and `Z₁Z₂Z₃` have symplectic
   pairing 3 ≢ 0 mod 9, so the printed `S = ⟨X₁X₂X₃, X₁³X₂⁶, Z₁Z₂Z₃, Z₁³Z₂⁶⟩` is
   non-abelian and stabilizes nothing; `Z₁Z₂Z₃` is verifiably not in the stabilizer of
   their explicit state. The audit's general-element formula presupposes the bad
   presentation. **The conclusion nevertheless survives**: recomputed independently from
   the state itself (equation (4) of the paper), the minimal supports are exactly the
   three two-party sets, each of label order nine, each projecting at each of its
   parties onto exactly `3Z₉×3Z₉`, and `Λ_i^max = 3Z₉×3Z₉`, index nine, at all three
   parties. Right answer, wrong derivation; repair below.
2. **(T2) Corollary B's restatement drops Van den Nest–Dehaene–De Moor's standing
   `n ≥ 3` assumption, and its proof is false at `n = 2`.** Their paper globally assumes
   `n ≥ 3` (their §II: "we will also only consider stabilizer states on n ≥ 3 qubits").
   The note's restatement omits it; at `n = 2` the EPR pair satisfies every stated
   hypothesis and the intermediate conclusion "every `U_i` Clifford" is false
   (`U ⊗ Ū` fixes the state for non-Clifford `U`). The proof step "for `N = 4` full
   entanglement forces `|ω| ≥ 4`" is the exact point of failure: at `n = 2` a pure
   two-party marginal contradicts nothing, and even at `n ≥ 3` the count "≥ 4" needs
   their parity lemma, full entanglement alone giving only `≥ 3` (which is all the axis
   lemma needs). Trivial repair: add `n ≥ 3` and attribute the exclusion correctly.
3. **(T6) version-b's closing Chang–Jing scoping is still wrong after the cold read's
   flag.** "Above local dimension two a local unitary need not preserve the Weyl span at
   all" is false under the natural reading — the span of the nonidentity Weyl operators
   is the traceless subspace, preserved by conjugation by every unitary at every local
   dimension — and "it is there that recovering the axes becomes a Clifford condition on
   the factor" contradicts the same paragraph's own q=2 story, since permuting the
   projective Weyl axes *is* the Clifford condition at q=2 and proving it there is the
   entire content of the theorem the paragraph says the criterion unifies. Repair below.
4. **(T6, minor, confirmed) Two cold-read wording defects survive unrepaired in
   version-b:** "its size is unrestricted once the local dimension exceeds two" (the
   size is a subgroup order of the local label group, so restricted; the true claim is
   that intermediate subgroups exist), and "full entanglement is what puts at least four
   parties under a four-element support" (mechanism misattributed, per break 2).

Everything else attacked survived, with the specific tests recorded per target. The
arbitrary-local-dimension claim (T1) survived a direct hunt: Lemma R, Theorem P, Lemma M
and Corollary G were re-derived over Z_d for arbitrary d including even d, and the one
genuine subtlety found — whether "permutes the projective Weyl axes" coincides with the
standard Clifford group at even d — resolves positively via an order argument, subject to
one convention obligation recorded below. The subsumption (T2) holds at their exact
hypotheses once `n ≥ 3` is restored. The proofs (T3) check line by line, including the
two probes specifically ordered (the span-onto step, the index-set bijection). The
ceiling equivalence (T4) is correct and its scope caveat is adequate.

## T1. The arbitrary-local-dimension claim — survived, with one convention obligation

What was actually tested, claim by claim, over `Z_d` with `W_{(a,b)} = X^a Z^b`, X the
shift, Z the clock, arbitrary integer `d ≥ 2`:

- **Orthogonality and additive multiplication.** `Tr(W_v† W_w) = d·δ_{vw}` holds for
  every d (direct computation; no phase convention enters, since any τ-prefactor is a
  unimodular scalar absorbed into coefficients). `W_v W_w = (phase)·W_{v+w}` with indices
  mod d holds for every d. The half-integer phase convention at even d changes only the
  scalar, never the axis, and none of the four proofs uses the scalar. **No break.**
- **Lemma R.** Closure: conjugating `W_a W_b = (phase) W_{a+b}` gives additivity of the
  induced map mod d, exactly as at prime power; a finite subset of an abelian group
  containing 0 and closed under addition is a subgroup. Injectivity: if two labels had
  proportional images, Ad U would collapse a 2-dimensional span to 1, contradicting
  invertibility. Injective-implies-bijective is finiteness of the set, not any field or
  elementary-abelian structure — the prompt's worry ("is an injective additive
  endomorphism of Z_d² really forced to be surjective") dissolves: an injection of a
  finite set into itself is a surjection, and that is the only fact used. **No break.**
- **"Permutes the projective Weyl axes" versus the standard Clifford group.** This is
  where I expected the even-d break and did not find one, but the argument is genuinely
  needed and appears nowhere in the note. Odd d: `W_v^d = I`, so if `U W_v U† = c W_w`
  then `c^d = 1`, hence U normalizes the standard Pauli group (phases μ_d) and is
  Clifford in the normalizer sense. Even d: `W_v^d = ±I` (the sign is `(-1)^{ab}`), so
  `W_v^{2d} = I` and `c^{2d} = 1`; U normalizes the Pauli group provided its phase group
  is taken as the 2d-th roots of unity, which is the standard even-d convention
  (Hostens–Dehaene–De Moor's Z_{2d} phases). **Obligation, not a break:** any adoption at
  composite d must either define Clifford projectively throughout or state the even-d
  phase-group convention, or the claimed identification with the literature's LC is
  unjustified at even d. The criterion note currently says "Clifford still means
  permuting their projective axes" as if it were automatic; the odd/even order argument
  above is the missing discharge and should be written down (it is three lines).
- **Theorem P.** Pure complex linear algebra on Hilbert–Schmidt space; the label group
  enters only through orthogonality and injectivity of the `f_i`. Checked at composite d
  verbatim. **No break.**
- **Lemma M.** The kernel argument is pure support arithmetic in an abelian group; the
  partial-trace claim (`ρ_ω` retains exactly the elements supported inside ω, unimodular
  coefficients) uses only `Tr(nonidentity Weyl) = 0` and `ρ = |S|^{-1} Σ_{g∈S} g`, both
  valid at every d given a stabilizer state in the standard sense (|S| = d^n, trivial
  phase intersection). The purity identity `Tr(ρ_ω²) = |L(ω)|/d^{|ω|}` also survives
  (Weyl orthogonality at any d). **No break.**
- **Hunt for further F_q-versus-Z_{p^e} conflations** of the kind the cold reader caught
  once. Places audited: the Wong–Jiang paragraphs in the criterion note and version-b
  (now correctly scoped to the integer-modulus system — "three-torsion subgroup of Z₉²"
  is order 9, index 9, correct in that system); the CSS corollary (prime field only, no
  conflation possible); the finiteness corollary and the `F_p`-linearity discussion
  (explicitly `F_q`-scoped, correct); the d=6 paragraph (Z₆ ≅ Z₂×Z₃, no field claimed).
  **No further instance found.** The searched domain is the criterion note, the audit
  synthesis, and version-b, in full.

## T2. Subsumption of their Theorem 1 — survives at their exact hypotheses, with the n ≥ 3 break above

Both directions instantiated at their exact hypotheses (their Theorem 1 verbatim from
the cached full text, line 371: fully entangled n-qubit stabilizer, σx, σy, σz on every
qubit in M(ψ), conclusion LU(ψ) = LC(ψ), with `n ≥ 3` standing globally per their §II,
and LU(ψ) by their definition a set of *stabilizer* states).

- **Hypothesis identification.** π_i is a homomorphism, so π_i(M(ψ)) is generated by
  ∪_ω π_i(L(ω)) over minimal supports through i (elements not through i project to 0).
  "All three Paulis occur at qubit i in M(ψ)" ⟺ π_i(M(ψ)) = F₂² ⟺ the recovered labels
  generate. The prompt asked whether this identification fails for some configuration of
  minimal supports: at q = 2 the possible L(ω) are order 2 (N = 2 branch, no arity
  condition) and order 4 (N = 4 branch, |ω| even by their parity lemma, |ω| ≠ 2 by full
  entanglement at n ≥ 3, so |ω| ≥ 4 ≥ 3); there is no third configuration, and both are
  consumed by Corollary G. **Exact, no failure configuration found.**
- **Transfer to the second state.** Legitimate and does need φ to be a stabilizer state:
  minimal supports are LU-invariant (the family {S : Tr(ρ_S²) > 2^{-|S|}} is
  LU-invariant and minimal supports are its minimal members), and the purity invariant
  transfers |L(ω)|. Their LU(ψ) is stabilizer-only by definition, so this is free on
  their domain and the criterion note says where it comes from. **Tested and holds.**
- **Full entanglement placement.** Correct and sufficient once n ≥ 3 (it exorcises
  exactly the two-party pure-marginal case); see confirmed break 2 for the n = 2 failure
  and the misattributed "≥ 4".
- **Does their theorem conclude more on its domain?** No: their stated conclusion is
  orbit equality; their own proof (equations (16) of the paper) derives per-factor
  Cliffordness, which is what Corollary G concludes; per-factor Cliffordness implies
  orbit equality. **Tested; no residue.**

## T3. The proofs — all verified; what was checked

- **Theorem P, r ≥ 3 case, the two ordered probes.** (i) Span-onto: the i-th flattening
  of R has rank N because for v ≠ w every f_j is injective (j ≠ i), so the complementary
  product vectors are distinct members of an orthonormal product basis; hence the
  minimal supporting subspace at factor i is exactly E_i, and minimal supporting
  subspaces transform covariantly under invertible product maps, so Ad U_i(E_i) = E'_i.
  Legitimate. (ii) Index bijection: the equal-size hypothesis |P| = |P'| = N is explicit
  in the statement, so nothing hidden; at r ≥ 3 it is even redundant (dim E_i = |P| and
  dim E'_i = |P'| must agree by invertibility). The bijection fixes 0 because Ad U_i(I)
  = I and I is the 0-basis vector on both sides. The manuscript's Lemma diagonal-axes
  proof was itself re-verified (contraction rank = #{j : x_j ≠ 0}; rank preserved by
  invertible flattening conjugation; r ≥ 3 needed for the flattening to exist).
- **Theorem P, N = 2 case.** Trace comparison pins λ₀ (the nonidentity factor is
  traceless at every party since f_i injective with f_i(0) = 0 forces f_i(1) ≠ 0);
  factorization of an equality of nonzero product operators is standard; unitarity makes
  each scalar a phase. Sound, at every r ≥ 1.
- **Lemma R.** See T1. Sound.
- **Corollary G.** Direct composition of Theorem P and Lemma R; the arity disjunction in
  its hypothesis matches Theorem P's exactly; the permutation is absorbed by relabelling
  as stated (the specialization-inversion note's earlier wording defect on this point
  does not recur here). Sound.
- **Lemma M.** Sound at every d (T1). One presentational note: the partial-Weyl
  conclusion needs |L(ω)| ≥ 2 to feed Theorem P, which a minimal support supplies.
- **Corollary C (corrected CSS statement).** Now right. The hypothesis is on minimal
  supports *of the stabilizer* (the earlier X-code error does not recur); a nonzero
  X-type label in L(ω₁) has support exactly ω₁ by minimality, so its i-coordinate
  (x_i, 0) has x_i ≠ 0, likewise (0, z_i); over a prime field the two generate F_q²;
  arity is supplied by the "at least three coordinates" hypothesis; the second state's
  marginals transfer by the same invariances since it is a stabilizer state. Two
  harmless slacks, noted not broken: "another such state" requires the second state CSS
  when any stabilizer second state suffices; and three coordinates are demanded even of
  a support that could run at N = 2 without them.

## T4. The ceiling proposition — equivalence confirmed; caveat adequate

Tested the equivalence both ways using the uniqueness of the Weyl expansion of a
stabilizer marginal (ρ_S determines P = L(S) and the coordinate maps up to relabelling,
so partial-Weyl diagonality is a property, not a choice of decomposition): partial-Weyl
diagonal with N ≥ 2 ⟺ L(S) ≠ 0 and every nonzero element of L(S) has support exactly S
⟺ S is a minimal support. The edge S with L(S) = 0 gives the maximally mixed marginal,
formally |P| = 1, unusable by Theorem P — consistent with the claim. Λ_i^max =
π_i(M(ψ)) follows since projection commutes with generation and minimal elements not
through i contribute 0. **Confirmed.** The scope caveat is adequate: the note bounds only
single-marginal partial-Weyl arguments, names the PARALIND/rank-based escape route
explicitly, and refuses to assert a problem-level ceiling. Nothing to break there; the
escape route itself remains untested by everyone, as the note says.

## T5. The Wong–Jiang computation — confirmed source/transcription break; conclusion independently reconfirmed

**The break.** The cached paper (arXiv:2507.09416v2, §III) prints
`S = ⟨X₁X₂X₃, X₁³X₂⁶, Z₁Z₂Z₃, Z₁³Z₂⁶⟩`. Over Z₉ the symplectic pairing of the labels of
`X₁X₂X₃` and `Z₁Z₂Z₃` is 1+1+1 = 3 ≢ 0 mod 9, so these do not commute (commutator phase
e^{2πi/3}, verified numerically) and the printed set generates a non-abelian group: it
is a misprint in the source. The C807 audit copied it and derived the label formula
"(a+3b, c+3d), (a+6b, c+6d), (a, c)" from the four printed generators, so the audit's
derivation is from an invalid presentation. The criterion note's "Computed from their
generators" inherits this.

**The reconfirmation.** I rebuilt the state directly from their equation (4) (two
three-qutrit factors, sum over a₁+a₂+a₃ ≡ 0 mod 3 tensor a GHZ₃, embedded per party as
j = 3a+b; this embedding is confirmed by three of the four printed generators fixing the
state, and the state is GHZ₉-adjacent exactly as their equation (5) requires) and
enumerated all 9⁶ Pauli labels fixing its ray. Results, all in the **integer-modulus Z₉
Weyl system**, which is the right system — it is Wong–Jiang's own Z_D-module convention
and the one version-b now names:

- Projective stabilizer label count: 729 = 9³, as required.
- `Z₁Z₂Z₃` (label ((0,0,0),(1,1,1))) is **not** in the stabilizer; `X₁X₂X₃`, `X₁³X₂⁶`,
  `Z₁³Z₂⁶` are. Valid replacement fourth generators exist, e.g. `Z₁Z₂Z₃⁷` (label
  (1,1,7): pairing 1+1+7 = 9 ≡ 0 against X₁X₂X₃ and 3+6 ≡ 0 against X₁³X₂⁶) or
  `Z₁Z₂⁴Z₃⁴`; ⟨X₁X₂X₃, X₁³X₂⁶, Z₁Z₂Z₃⁷, Z₁³Z₂⁶⟩ is abelian of order 729 (phases per
  element fixed by the state).
- Support distribution of the 729 labels: 1 trivial, 8 each on {1,2}, {1,3}, {2,3},
  704 of full support. Minimal supports: exactly the three two-party sets, each with
  |L(ω)| = 9.
- Each minimal support projects at **each** of its parties onto exactly
  {0,3,6}×{0,3,6} = 3Z₉×3Z₉ (all nine labels attained).
- Recognition ceiling: Λ_i^max = 3Z₉×3Z₉, order 9, index 9 in Z₉², at all three parties.

So the audit's headline — proper ceiling of index nine, equal to the three-torsion
subgroup, criterion correctly silent, explanatory of their three-level substructure —
is **correct**, and is here re-derived from the state rather than from the misprinted
generators. The two-party caveat also stands unchanged (these minimal supports have
r = 2, N = 9, the open case; the ceiling is proper for a reason independent of arity).

**Minimal repair.** Wherever the example is cited (criterion note, version-b, any
manuscript adoption): compute from the state of their equation (4), note the generator
misprint explicitly (or silently use a corrected generator set), and keep the
integer-modulus scoping already present in version-b. Replay: the enumeration script and
outputs are reproduced below.

```
# scratchpad wj3.py, replayed with: uv run --with numpy python3 wj3.py
# state: sum over a1+a2+a3=0 mod 3, b in Z3, of |3a1+b, 3a2+b, 3a3+b>, normalized
# enumerate (x,z) in Z9^3 x Z9^3 with X^x Z^z |v> = lambda |v>
# outputs: n labels: 729 ; support distribution {(): 1, (0,1): 8, (0,2): 8, (1,2): 8, (0,1,2): 704}
# minimal supports [(0,1),(0,2),(1,2)], each |L|=9, proj at each party = {0,3,6}^2
# Lambda_max order 9 index 9 at parties 0,1,2 ; ((0,0,0),(1,1,1)) NOT in labels
```

## T6. version-b.tex, sentence by sentence

Sentences discharged and by what; defects flagged inline. Line references are to
`notes/2026-08-02-c804-ab/version-a.tex` / `version-b.tex` as they stand today.

1. "Rains recovered the three Pauli axes … minimal-support LU-to-LC criterion" —
   **supported** (Rains Theorem 13 verified as characterized; their Lemma 2 credits
   Rains; citations placed correctly).
2. "Corollary cor:recognition-generation is a criterion of the same kind at every local
   dimension" — **conditionally supported**: the corollary, prop:partial-weyl-marginal,
   and the partial-Weyl definition exist today only in the notes, not under `sections/`.
   The paragraph is unsupported by the manuscript until the theorem package is adopted;
   this is a shipping gate, not a math defect.
3. "no stabilizer, CSS, or linearity hypothesis enters, the states are arbitrary, and
   the coefficients … unconstrained" — **loose, cold-read flag unrepaired**: "the states
   are arbitrary" glosses the real structural hypothesis that *both* states' marginals
   be partial-Weyl diagonal with equal index sizes. Not false (the corollary's
   hypothesis carries it) but a referee magnet. Name the marginal hypothesis.
4. "For fully entangled qubit stabilizer states it unifies their theorem rather than
   strengthening it" — **supported** (verified in T2), modulo the n ≥ 3 clause their
   paper carries globally and this sentence should inherit.
5. "Their hypothesis … is our generation hypothesis: the projection at a qubit of that
   subgroup is generated by the labels our marginals recover there" — **supported**,
   verified exactly (T2).
6. "Their two proof branches are the two index sizes available at q=2 … full
   entanglement is what puts at least four parties under a four-element support, as the
   axis argument requires" — first half **supported**; second half **misattributed**
   (confirmed break 4): full entanglement excludes only |ω| = 2 (and only for n ≥ 3);
   "at least four" needs their parity lemma; the axis argument requires three parties,
   not four. The conclusion survives, the stated mechanism is wrong.
7. "Their Lemma 1 finds only two possible sizes … its size is unrestricted once the
   local dimension exceeds two" — **overstated, cold-read flag unrepaired** (confirmed
   break 4): the size is a subgroup order of the local label group. Say "intermediate
   subgroups exist as soon as the local dimension exceeds two".
8. "The intermediate sizes … are the generic case for CSS states" — **suspicion,
   unverified quantifier**: plausible (a minimum-weight X-support carrying no Z-word
   gives a line of q labels, intermediate for q > 2) but "generic" is proved nowhere in
   the record. Either prove a genericity statement or write "typical" prose without the
   technical quantifier.
9. "Proposition prop:stabilizer-ame-support is what verifies the hypothesis for
   stabilizer AME states at every prime power" — **supported** (manuscript Proposition
   verified: |L(A)| = q², bijective projections).
10. "Only the additive structure of the labels is used, so the criterion applies
    verbatim to the integer-modulus Weyl system on ℂ^d for arbitrary d" — **supported
    by T1**, with the even-d Clifford-convention obligation recorded there ("verbatim"
    is fair for the engine; the identification of axis-permuting with the literature's
    Clifford group at even d deserves its three-line footnote).
11. "In that system Wong and Jiang exhibit … its minimal supports are the three
    two-party sets, each carrying nine labels, and each projects at every party into the
    index-nine subgroup 3Z₉×3Z₉, so the recovered labels do not generate and the
    criterion correctly does not apply" — **every quantitative claim independently
    verified correct** (T5), and stated in the right Weyl system. Must carry the
    generator-misprint repair in whatever it cites for the computation.
12. "The linear algebra behind the axis recovery is classical [Harshman1970,
    Kruskal1977]" — **supported**; matches the manuscript's fuller Jennrich-via-Harshman
    attribution (03-lu-rigidity.tex lines 6–16). Version-b's shorter list is acceptable
    prose provided the manuscript's Lemma retains the full chain, which it does.
13. "constraining local unitaries by tensor-decomposition uniqueness applied to a
    coefficient tensor in a discrete operator basis is due to Chang and Jing" —
    **borderline attribution, cold-read caution unrepaired**: Rains 1997 and Van den
    Nest–Dehaene–De Moor 2005 already constrained local unitaries through a diagonal
    Pauli correlation tensor; what is due to Chang and Jing is the importation of the
    general CP/Kruskal uniqueness machinery. The qualifier "by tensor-decomposition
    uniqueness" arguably scopes it, but one word ("the general machinery is due to")
    removes the exposure.
14. "Their setting is the qubit one, where that method cannot give the conclusion drawn
    here: every single-qubit unitary preserves the span of the Pauli operators … Above
    local dimension two a local unitary need not preserve the Weyl span at all, and it
    is there that recovering the axes becomes a Clifford condition on the factor" —
    **confirmed defective** (break 3). The span of the nonidentity Weyl operators is the
    traceless subspace at every local dimension, preserved by every unitary; no
    span-based contrast separates q = 2 from q > 2. And axis recovery is the Clifford
    condition at q = 2 too — the paragraph's own unification claim depends on exactly
    that. What is true and provable from the audit record: Chang and Jing treat generic
    states, whose Pauli coefficient tensors are not diagonal in the operator basis, so
    uniqueness there pins a rotation up to scaling and yields invariants; they draw no
    Clifford or stabilizer conclusion anywhere (verified keyword sweep); at q = 2 the
    Clifford conclusion for stabilizer states is Van den Nest–Dehaene–De Moor's; above
    q = 2 it is located nowhere. **Minimal repair:** replace the two sentences with that
    four-clause statement and delete every occurrence of "span".

**version-a.tex note in passing:** its line "Proposition prop:full-weyl-marginal
supplies all three Pauli axes on each minimum support" retains the wrong reference the
cold read caught; the committed manuscript (01-introduction.tex line 113) already reads
prop:stabilizer-ame-support. If version A is ever the survivor, sync it to the
manuscript's corrected pointer.

## What was not reached, stated so this does not read cleaner than it is

- The two-party intermediate-size question (r = 2, 3 ≤ N < d²) was not attacked beyond
  confirming the note's sharpness argument is internally correct; it is open exactly as
  the note says, and the Wong–Jiang example cannot decide it.
- Wong–Jiang's own claims (LU-connectedness of the pair; Clifford-invariance of their
  generator-count invariant) were checked structurally (the local qutrit-Fourier map
  carries their state to GHZ₃⊗GHZ₃ = GHZ₉ under the j = 3a+b embedding, consistent with
  LU-equivalence) but their non-LC proof was not re-derived.
- The PARALIND/Lovitz–Petrov escape route and the d = 6 computation remain unrun by
  everyone, as the note already records.
- Kruskal 1977 remains unread by anyone in this repository (bot wall); the Jennrich
  attribution rests on the Harshman reproduction and Kolda–Bader, as the audit states.
- The tail of `03-lu-rigidity.tex` (stability, thresholds, logical-image material,
  lines 886–1690) was read for context and conventions only; it was not red-teamed
  here and none of the six targets depends on it.

## Repairs, consolidated

1. Criterion note and audit synthesis: replace the Wong–Jiang generator-based
   computation with the state-based one; record the misprint in the source's printed
   generators; keep every conclusion (they all survive verbatim).
2. Criterion note, Corollary B: add `n ≥ 3`; replace "full entanglement forces
   |ω| ≥ 4" with "full entanglement (n ≥ 3) excludes |ω| = 2, and the axis lemma needs
   only |ω| ≥ 3" (parity may be cited for the sharper ≥ 4 but is not needed).
3. version-b: rewrite the two Chang–Jing sentences per T6 item 14; fix "unrestricted"
   (item 7) and the full-entanglement mechanism clause (item 6); name the both-states
   marginal hypothesis (item 3); soften "generic" (item 8) or prove it; add the n ≥ 3
   clause (item 4); optionally tighten "due to Chang and Jing" (item 13).
4. Any composite-d adoption: add the three-line odd/even-d argument identifying
   axis-permuting unitaries with the standard Clifford normalizer (2d-th-root phase
   convention at even d).

Uncommitted: this note and the scratchpad scripts; commit decision left to the lane
owner along with any of the repairs above.

---

# Coordinator follow-up: grade, incidental findings, venue

Basis for what follows: the six red-team targets above, plus a complete read of
`sections/01`–`06`, both `07` files, `08-verification-boundary.tex`,
`09-party-extensions.tex`, the abstract in `main.tex`, and the C804/C807 note stack. Read
by role only, not line-audited: `10-scalar-certificates.tex`, the `supplement/`
certificates, and the Lean aggregate. The rigidity core (Section 3 up to the atlas
theorem) was verified line by line in the red team; the stability half was read closely
with spot-checks of its key inequalities (the local-generator isometry, the budget-free
bound's coset counting, the site-contraction constant) but not adversarially exhausted.

## 1. Grade

**As committed today: B+.** Meaning, calibrated to a strong venue: technically correct
everywhere I checked, with unusually disciplined claim-scoping, but its headline theorem
sits closer to prior art than the rest of the paper deserves, and the manuscript
currently under-sells itself at exactly that point.

What is genuinely strong, in order:

- **The atlas classification.** Reducing LU classification of stabilizer AME states to
  finite symplectic linear algebra with an exact symmetry sequence, and then actually
  computing with it (the pencil's degree-eight quotient `z` as a complete LU coordinate,
  the 450-holonomy invariant with its collision analysis) has no precedent at any local
  dimension — Van den Nest–Dehaene–De Moor's LC-invariant list is a different and weaker
  kind of object. This, not the rigidity theorem, is the paper's deepest contribution.
- **The discreteness and stability half.** Finiteness of the product-unitary symmetry
  group from 2-uniformity alone — any local dimension, no stabilizer structure — with
  explicit party-count-independent constants, the uniformity-order-controlled radius,
  the quantized-overlap separation constant `(2−2p^{−1/2})^{1/2}`, and a closed-form
  decomposition threshold, is clean, self-contained, and per the C807 audit unoccupied at
  that scope. The `(3.8)` isometry is the kind of identity referees remember.
- **The logical-phase dichotomy.** Diagonal isoduality ⟺ conic/self-association deciding
  `SL₂(q)` versus the split torus for transversal logical groups is a genuinely new
  bridge from nineteenth-century association theory to transversal-gate structure, and
  the transversal Clifford no-go for the whole `[[2m−1,1,m]]_q` family is a crisp
  quotable consequence.

What is merely competent: the rigidity theorem's proof mechanics (support squeeze plus
Jennrich, correctly attributed since commit `a742efca`), the scalar-blindness section (a
first-fundamental-theorem argument, well executed), the transport divisor and
party-extension appendices (careful certificate work, appendix-grade).

What a hostile referee attacks first, in order: (i) "Theorem 1 is Rains's 1997 argument
run over `F_q` after a standard MDS support computation, and its q=2 case has been known
for twenty years — the paper says so itself." The current concession paragraph invites
this by ceding more than the mathematics requires (the entire q=2 overlap is the single
AME(6,2) family, which the manuscript never says). (ii) The missing Chang–Jing citation
(see finding 1 below) — a referee who knows the 2022 paper will read its absence as
selective citation next to the freshly added Kruskal chain. (iii) "Three papers stapled
together": rigidity/atlas, stability theory, and finite-geometry applications each have
their own introductions-in-miniature, and a 45-page referee assignment invites a
split-and-resubmit report. (iv) A Gour–Wallach-school referee probing whether
2-uniform-implies-stable-point is extractable from known GIT criteria; the manuscript
hedges this correctly but the "no statement at that scope" sentence will be tested.

To move up a band without new mathematics: settle the positioning paragraph (version-b
direction, with my repairs), cite Chang–Jing, make the three-part structure legible or
split it, and run the Tan order-5832 falsifier so the atlas is demonstrated as a
computing device on a published external count.

**With the recognition-group criterion adopted into Section 3, repairs applied: A−.**
Adoption converts the paper's weakest paragraph into its strongest claim: the first
LU-forces-LC criterion at every local dimension — prime-power and composite — subsuming
Van den Nest–Dehaene–De Moor's full Theorem 1 rather than its case (iv), with the
Wong–Jiang d=9 state as a correctly-predicted non-instance and the ceiling proposition
showing their hypothesis is the exact reach of the mechanism. That is a headline a
qubit-era expert cannot wave away, and the CSS corollary answers a listed open question.
It does not reach A/flagship: the engine remains classical tensor uniqueness plus
elementary group theory, the method has a 2022 precedent to cite, and the deep new
object (the atlas) is unchanged by adoption. The cost is length and two new citation
duties, both bounded.

## 2. Everything else noticed, ranked by what a referee finding it would cost

1. **Chang and Jing (arXiv:2205.06422) is cited nowhere in `sections/`** although the
   bib entry exists and the C807 audit's gate 0 declares the citation mandatory (method
   collision: CP/Kruskal uniqueness applied to a Pauli-basis coefficient tensor to
   constrain local unitaries, 2022). The Jennrich/Kruskal repair is in the committed
   Lemma; the nearest-neighbour quantum paper is not. Cost if a referee finds it first:
   high — it converts a citation gap into a credibility question about the whole
   attribution apparatus. One sentence in Section 3's attribution paragraph fixes it.
2. **The concession paragraph over-cedes** (current `01-introduction.tex` lines
   108–119, the committed version-a text): "is therefore already covered by their
   result" without stating that the entire overlap is AME(6,2) (four-qubit AME
   nonexistence plus the parity constraint). Whichever A/B branch wins, the quantified
   overlap should appear, with Higuchi–Sudbery and Scott cited. Cost: high, strategic
   rather than mathematical — this is the paragraph a VdN-DDM-literate referee reads
   first.
3. **`cor:full-weyl-cover` still carries the permutation ambiguity** flagged in the
   specialization-inversion note: with a relabelling in play the second marginal should
   be indexed `ρ^φ_{π(S)}`, or the statement scoped to a fixed labelling with the
   permutation absorbed first. The proof of the main theorem does absorb it, so nothing
   is wrong; but the corollary is written as a free-standing criterion and will be read
   alone. Cost: medium — a careful referee files it as a correctness query and waits a
   round for the answer.
4. **GIT-adjacent exposure of the discreteness theorem.** The manuscript's own remark
   maps 2-uniformity to stability for `SL(q,ℂ)^n` and cites the stabilizer-dimension
   literature, but does not preempt the specific question "does 2-uniform ⇒ stable
   follow from the Kempf–Ness criterion already in Bryan–Reichstein–Van Raamsdonk?" If
   it does, finiteness (though not any constant) would be extractable from prior art.
   I did not resolve this either way; the quantitative content is safe regardless.
   Cost: medium — worst case is a demanded rewrite of one novelty sentence, not a
   result loss. Cheap inoculation: one sentence acknowledging that stability-implies-
   finiteness is classical and locating the contribution in the explicit constants and
   the uniformity-order radius, which is where it actually lives.
5. **The closing sentence of `03-lu-rigidity.tex`** (lines 1685–1689) restates the
   full-Weyl-cover hypothesis with "an `F_q`-linear plane", but the corollary as proved
   needs only a `q²`-element label group with bijective projections — no
   `F_q`-linearity, which is precisely the paper's "arbitrary additive" selling point.
   Logically harmless (it is a sufficient condition) but it contradicts the paper's own
   emphasis and will confuse exactly the careful reader. Cost: low-medium.
6. **Englbrecht–Kraus (arXiv:2001.07106) uncited** in the discreteness prior-art
   remark. Their qubit-stabilizer symmetry characterization does not cover the
   theorem's scope (arbitrary 2-uniform states, any dimension), so nothing is wrong,
   but they determine every local symmetry of every qubit stabilizer state and a
   referee from that school will expect the acknowledgment. Cost: low.
7. **The Tan containment sentence in the introduction** ("that calculation contains the
   q=3, m=2 automorphism subcase above") rests on inspection of Tan's displayed
   generators, and the atlas-side reproduction of the order-5832 count — the
   specialization-inversion note's sharp falsifier, with its two independently checkable
   predictions — remains unrun. Running it is cheap, would either validate the atlas as
   a computing device on external data or catch a real problem, and upgrades a
   citation-level claim to a verified one. Cost of not doing it: low today, high in the
   unlikely event the check fails after publication.
8. **File-level oddity:** two section files numbered 07 (`07-conclusion.tex`,
   `07-transport-sheaf.tex`). Build presumably orders them correctly; purely cosmetic.
9. **Abstract length and density.** The abstract is a full paragraph-stack running
   through all three sub-papers; at Quantum or IEEE-IT it will be asked to shrink.
   Style only.

Nothing I read in sections 4, 5, 6, 8, or 9 failed a spot-check: the bracket-multiset
argument (4.3), the self-association lemma's five-row independence step, the
coset-syndrome lemma, the generic-constancy proposition with its rational-point caveat,
and the factor-set formalism in the appendix are all sound as written, and the
verification section's trust map matches what the text actually proves versus
certificates versus Lean — the scoping there is a model of its kind. The `native_decide`
carve-out and the "independent implementations within one package, not an independent
external reproduction" sentence are exactly the right level of candor.

## 3. Venue, conditional on the fixes

The tradeoff, stated plainly. A **quantum-information venue** (Quantum, PRX Quantum,
npj QI, PRA) reads the main contribution as: LU⇒LC rigidity for qudit stabilizer AME
states, the transversal Clifford no-go for quantum MDS codes, and the finiteness/
stability theory of 2-uniform states; it will find the finite-geometry half (pencil,
self-association, Clebsch syndromes, transport divisor) exotic and will not referee it
deeply — underdeveloped for them means "no operational or fault-tolerance payoff beyond
the no-go, no algorithms". A **coding/finite-geometry venue** (IEEE Trans. Inform.
Theory, Designs Codes & Cryptography, Finite Fields Appl.) reads the main contribution
as: the self-association/conic dichotomy for transversal logical groups of MDS–CSS
codes, the pencil classification, and the arc–AME dictionary; it will treat the
Lie-theoretic stability half as foreign ballast and the qudit LU⇒LC framing as a quantum
lemma — underdeveloped for them means "no general-`m` non-GRS theory, six-party
specialization carries the geometry".

Realistic ceiling as one paper, fixes applied: **Quantum**. It is the one strong venue
whose referee pool spans both halves, tolerates 45 pages, and values the
verification/Lean apparatus as a feature rather than noise. PRX Quantum is the
aspirational answer and I do not believe it: the paper is structural mathematics without
a physics-facing payoff sentence, and PRX Quantum's filter is exactly that sentence.
CMP is wrong-shaped (the applications sprawl breaks the single-theorem arc it wants).
IEEE-IT would take a re-weighted version but at the cost of burying the atlas and
stability material, which is where the depth is.

**Does adoption change the answer? Yes, materially.** Without the recognition-group
criterion, the QI-facing headline leans on AME structure and concedes the qubit case,
and the balance tilts toward the coding community, where the VdN-DDM concession is
irrelevant — a defensible IEEE-IT submission. With adoption and my repairs, the paper
owns "first LU-forces-LC criterion at every local dimension, qubit theorem subsumed,
composite dimensions included, published d=9 counterexample correctly explained" — that
is a QI headline, it makes Quantum comfortable rather than arguable, and it is the only
change on the table that moves the realistic ceiling at all.

**Split recommendation: yes, one cut, and only if adoption happens.** Cut between the
rigidity/atlas/stability body and the finite-geometry applications. Paper A ("rigidity
and recognition"): Sections 1–3 plus the adopted criterion and the stability subsection
— the recognition-group criterion, AME rigidity, atlas classification, discreteness and
thresholds; venue Quantum. Paper B ("transversal groups and the self-association
boundary"): the dictionary specialization, Sections 4–5, scalar blindness, transport,
party extensions — the `SL₂`-versus-torus phase theorem as headline, pencil `z` as the
worked classification; venue IEEE-IT or DCC, citing A for rigidity. The stability half
should NOT be cut loose on its own: its dependence on the rigidity theorem for naming
the finite group, and on overlap quantization for the explicit threshold, is the one
genuine synergy in the current bundle, and as a standalone it would be a solid but
unremarkable PRA paper. If adoption does not happen, keep it as one paper and send it to
Quantum anyway — without the criterion, Paper A alone is thinner than the sum and the
bundle's breadth is then its best argument.
