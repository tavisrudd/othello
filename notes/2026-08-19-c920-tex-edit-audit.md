# 2026-08-19 — Audit of the C920 manuscript edits (cubic-stabilization-epilogue)

**Lane:** `cubic-threefolds`

**Subject:** every TeX edit made under C920, "Removing the divisor-tagging hypothesis
for rational geometrically ruled centers", closed 2026-08-18 and archived. Net TeX
diff audited: `eb9b34622..f06c3da38` restricted to
`papers/cubic-stabilization-epilogue/**/*.tex` — 450 insertions, 50 deletions across
`cubic_stabilization_epilogue.tex`, `sections/01-introduction.tex`,
`sections/05-framed-monodromy.tex`, `sections/06-synthesis.tex`. C920's Lean, evidence
and registry edits were read where a manuscript claim depends on them.

Sources read in full: the task report `2026-08-18-c920-minimal-ruled-tagging-removal.md`,
the task card `cubic-threefolds-tasks/c920-minimal-ruled-tagging-removal.md`, all nine
referee reports (`2026-08-18-c920-referee-{mathematics,prose,lean-prose}[-round-{two,three}].md`),
the whole of the new Section 5 passage in its committed state, and the statements it
consumes (`def:strict-novikov-admissible`, `eq:center-novikov-specialization`,
`prop:direct-specialized-lowdim`, `lem:simple-euler-block`,
`prop:projective-product-nu`, `prop:framed-operations`, `rem:tagging-scope`,
`prop:low-dimensional-vanishing`, `thm:nu6-birational-invariance`).

## Verdict

The mathematics is correct. I re-derived every displayed object from scratch and found
no error: both quantum presentations, both Euler multiplication matrices, both
characteristic polynomials, both discriminants, both degenerate factorizations, the
spectral-cover discriminant, the truncation bound, the transport of the deformation, and
both base cases all check. The hypothesis bookkeeping is exactly what is proved. The
three round-three referee blockers were repaired. The paper builds warning-free, the
annotation gate passes, and the evidence bundle replays.

Two things are wrong or missing, and neither is a mathematical defect:

1. One accepted round-three repair was never applied, and the artifact now contradicts
   the manuscript in the single place that records which centers still need
   Hypothesis 5.7T (finding 1).
2. The two ring presentations, and the deformation route used to obtain them, are
   already in the published literature, uncited (finding 2).

## What I verified independently

Recomputed symbolically, without reading the certificate first, and matched afterwards
against the tracked one:

- Even presentation `A[S♭,F]/(S♭²-u, F²-w)` with Euler class `2S♭+2F`, basis
  `1,F,S♭,S♭F`: the displayed matrix is right, the characteristic polynomial is
  `X⁴-8(u+w)X²+16(u-w)²`, discriminant `2²⁴u²w²(u-w)²`.
- Odd presentation `A[S♭,F]/(S♭²+S♭F-u, F²-wS♭)` with Euler class `2S♭+3F`: the
  displayed matrix is right, the characteristic polynomial is
  `X⁴+wX³-8uX²-36uwX+16u²-27uw²`, discriminant `-u²w²(256u+27w²)³`.
- Degenerate factorizations: `X²(X²-16u)` at `u=w`; `(X+18σ)²(X²-20σX+612σ²)` at
  `w=16σ`, `u=-27σ²`, with quadratic roots `10σ±16ε`, `ε²=-2σ²`, distinct from `-18σ`.
- Spectral cover: `t⁴+wt³-uw²` has discriminant `-u²w⁶(256u+27w²)`, so the Euler
  spectrum degenerates exactly when the cover does. This confirms the discovery-track
  entry of 2026-08-18.
- Truncation: `c₁·β = 2m+(2-a)n` reduces to `2(m-nk)+2n` and `2(m-nk)+n`; with
  `1 ≤ c₁·β ≤ 2` and `ψ(β)` effective the surviving classes are exactly `f, s+kf`
  (even) and `f, s+kf, 2(s+kf)` (odd).
- Deformation transport: `ψ(f)=f`, `ψ(s)=s₀-kf` from `ψ(s)·f=1` and `ψ(s)²=-a`, hence
  `ψ(s+kf)=s₀` and `S♭↦S₀`. `k=⌊a/2⌋∈[1,a-1]` for `a≥2`, so the extension is nonsplit
  and `P(O(k)⊕O(a-k))≅F_{a-2k}=F_{a mod 2}`.
- Both base cases from the genus-zero invariants: on `F₀` the product formula gives
  `S₀⋆S₀=Q^f`, `F⋆F=Q^{s₀}`; on `F₁` the divisor axiom with `⟨⟩_{s₀}=1`,
  `⟨pt⟩_f=1`, `⟨pt⟩_{2s₀}=0` gives `S₀⋆S₀=-pt+Q^{s₀}S₀+Q^f`, `S₀⋆F=pt-Q^{s₀}S₀`,
  `F⋆F=Q^{s₀}S₀`, hence the displayed presentation.
- Direct check of the transported presentation on `F_a` itself: computing
  `S♭⋆S♭`, `S♭⋆F`, `F⋆F` from the surviving classes reproduces both presentations,
  and `S♭⋆F` supplies the point class, so the rank-four surjection is surjective and
  therefore an isomorphism.
- Valuation arithmetic: `v(u)=p`, `v(w)=r+kp` with `p,r>0`; `r+kp>p` for `k≥1` settles
  the even locus, `2r+2kp>p` the odd locus for `k≥1`, and at `a=1` with `p=2r` the
  degree-`p` symbol of `256u+27w²` is a combination of two members of the
  graded-monomial basis with `283≠0`.
- `lem:simple-euler-block` is applied within its stated hypotheses; the rank-two
  branch is correctly left open.

Gates, run at `HEAD=7f07332c6`:

- `make lint` — CHECK OK.
- `make manuscript warnings` — up to date, exit 0, 56 pages, no warning line.
- `lean/verification/check_formal_artifact.py --source-only` — PASS on a clean export
  of `HEAD` once C910's missing docstrings are patched (see foreign issues below):
  132 sources, 268 terminals, 59 manuscript claims, 18 imported sources, 2 evidence
  entries, coverage `absent 9, fragment 24, conditional 25, complete 1`.
- `sha256sum -c hirzebruch-euler-spectrum.sha256` from `verification/` — both files OK.
- `uv run --with sympy python3 verification/hirzebruch_euler_spectrum.py --check` —
  "certificate and digests agree".
- The certificate's `gromov_witten` cross-check is sound as written: for `F₂` it uses
  `c₁·(mf+ns)=2m`, the point invariants `⟨pt⟩_f=⟨pt⟩_{f+s}=1` and `⟨pt⟩_{f+ns}=0` for
  `n≥2`, and reproduces `S♭⋆S♭=q^f`, `F⋆F=q^{f+s}`, `S♭⋆F=pt`. It is the one
  independent confirmation of the deformation reduction and it does confirm it.

## Findings

### 1. MAJOR — the gated claim map still records the superseded scope, and it is now false

`lean/verification/claims.json`, row `prop:low-dimensional-vanishing`, cautions:

> "The manuscript now uses divisor tagging only for **nonminimal** surface centers;
> **minimal rational ruled** targets are covered by the direct specialized argument,
> whose formal content is recorded under prop:hirzebruch-specialized-vanishing."

Both clauses are wrong after C920. The manuscript uses tagging only for surface centers
that are *neither minimal nor geometrically ruled*, a strictly smaller class:
`F₁` is nonminimal and is covered directly. And the class covered directly is every
Hirzebruch surface, not the minimal rational ruled ones — this is the exact terminology
collision the pass renamed away everywhere else. This is the only surviving occurrence
of "minimal rational ruled" in the artifact, and the three sibling rows edited alongside
it say the correct thing, so the file contradicts itself.

This was raised as a blocker by the round-three Lean-prose referee (item 4) with an
exact replacement string, reported in the C920 report as applied, and never applied:
the final commit `f06c3da38` touched only the `lem:ruled-degeneracy-dichotomy` row.

Cost of repair: one string, no digest change (cautions are not hashed into
`statement_digest`), no rebuild.

### 2. MAJOR — the two presentations and the deformation route are published, and uncited

`lem:hirzebruch-euler-spectrum` derives the small quantum cohomology of every
Hirzebruch surface by transporting `F₀` and `F₁` along one deformation. That result,
by that route, is published:

> G. Cotti, *Cyclic Stratum of Frobenius Manifolds, Borel–Laplace (α,β)-Multitransforms,
> and Integral Representations of Solutions of Quantum Differential Equations*,
> Memoirs of the European Mathematical Society (EMS Press, 2022), DOI 10.4171/MEMS/2;
> listed at `ems.press/books/mems/241`. Chapter 9, "Quantum cohomology of Hirzebruch
> surfaces", §9.3.

Chapter 9 §9.3 does the following, in this order: notes that there are exactly two
deformation classes of Hirzebruch surfaces, `(F_{2k})` and `(F_{2k+1})`; invokes the
deformation axiom of Gromov–Witten invariants to identify `QH*(F_{2k})` with `QH*(F₀)`
and `QH*(F_{2k+1})` with `QH*(F₁)`; records that `QH*(F₀)` and `QH*(F₁)` agree with
their Batyrev rings and that this fails for every other `F_k`, because those are not
Fano; and then states

- Theorem 9.3.1: `QH*(F_{2k}) ≅ C[T₁,T₂,q₁,q₂] / (T₂∘² − q₁^k q₂, (T₁ − kT₂)∘² − q₁)`,
- Theorem 9.3.3: `QH*(F_{2k+1}) ≅ C[T₁,T₂,q₁,q₂] / A_k` with
  `A_k = (T₂∘² − (T₁ − (k+1)T₂)q₁^k q₂, (T₁ − kT₂)∘(T₁ − (k+1)T₂) − q₁)`.

Theorem 9.3.1 is the paper's even presentation verbatim under `S♭ = T₁ − kT₂`,
`F = T₂`, `u = q₁`, `w = q₁^k q₂` — the same `S + kF` shift, the same change of
Novikov variables. Theorem 9.3.3 is the paper's odd presentation verbatim under
`S♭ = T₁ − (k+1)T₂`, `F = T₂`: substituting gives `S♭² + S♭F = q₁` and
`F² = w S♭`, which is the manuscript's `(S♭²+S♭F−u, F²−wS♭)`. I checked both
substitutions by hand.

Consequences for the manuscript:

- The four labelled steps of the proof — the family, the transport, the two base cases,
  the truncation — reprove a published theorem. They can stay as a self-contained
  derivation, but the theorem needs a citation, and the paper's own convention is to
  gate imported statements through `\imports{}` and `imported-sources.json`. As it
  stands the passage reads as new.
- The paper's contribution here is narrower than the report presents it: an explicit
  algebraic family realizing the deformation (Cotti asserts the identification from
  deformation equivalence and a diffeomorphism, without constructing a family), and
  the specialized objects — the Euler quartic, its discriminant, the degeneracy
  dichotomy and the valuation/symbol arithmetic. Those I found no prior art for.
- The mystery-ledger item "Settled by this pass: the toric quantum Stanley–Reisner
  presentation cannot be used for a Hirzebruch surface of index at least two" overstates
  a published fact. Cotti states it in one sentence with a citation; the standard
  reference for the positive half is Qin–Ruan, *Quantum cohomology of projective bundles
  over `P^n`*, Trans. Amer. Math. Soc. 350 (1998), 3615–3638, arXiv:math/9607223, who
  prove Batyrev's formula for Fano splitting bundles. The pass rediscovered this rather
  than settling it.
- No literature audit was run for C920. The report has no literature section and there
  is no cached-source record for the quantum cohomology of Hirzebruch surfaces. Given
  `notes/literature-audit-conventions.md`, a pass that lands a new lemma of exactly this
  shape should have searched; the search that finds Cotti Chapter 9 is one query.

Cotti's monograph is also adjacent in a way that matters beyond the citation: it studies
the *quantum differential equation* and monodromy data of Hirzebruch surfaces, which is
the same object Section 5 builds `ν₆` from. It is worth a look for whether the
unspecialized Euler spectrum, or its collision locus, is already recorded there.

### 3. MINOR — `claim-proof-novelty-ledger.md` was not updated

The paper's own ledger still reads "STATUS: CONDITIONAL — depends on Hypotheses 5.7R and
5.7T" for the birational-invariance row and "CONDITIONAL on Hypotheses 5.7R and 5.7T"
for the `V₁₄` count row, with the preamble naming both hypotheses without qualification.
The manuscript now narrows 5.7T to surface centers that are neither minimal nor
geometrically ruled in eight places. The ledger is not read by
`check_formal_artifact.py`, so nothing caught the drift.

### 4. MINOR — one inference in `lem:ruled-degeneracy-dichotomy` is not fully cited

The closing sentence reads "By Lemma~\ref{lem:center-specialization-nondegenerate},
case (b) does not arise for a center specialization when `a≥1`". That lemma requires
`χ` graded-monomial when `a=1`, which for center specializations holds by
`lem:center-maps-monomial`. The round-three prose referee's replacement string cited
both lemmas; the applied text cites only the first, so at `a=1` the premise is
discharged only later, in `thm:nu6-birational-invariance`. One `\ref` closes it.

### 5. MINOR — one Lean docstring keeps the removed terminology

`Quantum/MonomialSpecializationSeparation.lean`,
`oddCombination_ne_zero_of_monomialLeadingTerms`, still opens "The odd degeneracy locus
is not met by a monomial specialization, whatever the shift" and says "a specialization
with monomial associated graded image", where the structure, the two interface
docstrings and `def:monomial-specialization` now say graded-monomial, and where the
sibling declaration was reworded to condition on its premise. Round-three Lean-prose
item 5; the other three places were fixed.

### 6. MINOR — two prose leftovers in the deformation passage

- "One family is used rather than `k` successive ones, which keeps the transport
  explicit" states an editorial choice against a superseded draft the reader never saw.
  The style guide asks for the mathematics alone.
- "The extension is nonsplit, since `O(k)⊕O(a-k)` is not `O⊕O(a)`; and its
  projectivization is a smooth projective family with …" still runs two independent
  claims through "; and", which is the sentence the round-three prose referee (item 15)
  asked to split. The split landed for the two preceding sentences only.

### 7. MINOR, pre-existing lane pattern — the Lean README inventory is stale

`lean/README.md` and `verification/README.md` enumerate what the companion proves,
area by area, including Section 5 items. C920 added four modules and twenty-three
terminals and bumped only the count line. C910's comparable addition (`cbbdfefc9`)
did the same, so this is a lane-wide pattern rather than a C920 defect, but a referee
reading the trust boundary now finds twenty-three terminals with no description.
The round-three prose referee's item 18 — one README sentence saying that the
graded-monomiality of the center maps is argued in the text only — was also not applied;
it is disclosed in the `absent` claims row instead.

## Foreign issues at HEAD, raised not fixed

- **The source-only formal gate is RED at `HEAD`.** `make formal-static` fails on
  `Quantum/BlockSylvesterSolvability.lean:133`. Five public declarations across
  `BlockSylvesterSolvability.lean` (lines 133, 140, 353) and `SylvesterOperator.lean`
  (lines 64, 69, 207) have no immediately preceding docstring. Both files are C910's,
  from `7f07332c6` and `c883adf40`. The checker is fail-fast, so this masks any later
  error in the tree.
- `lean/TavisRuddFiniteGeom/Papers/CubicStabilizationEpilogue/Quantum/NormalizedSylvesterGauge.lean`
  is untracked (C910).

## Mystery ledger

- **Settled.** Whether the C920 mathematics is sound: it is, in every displayed object,
  independently recomputed. The nine referee reports were accurate about what they found
  and about what they left; three round-three items went unapplied, listed above.
- **Settled, and the reason the pass looked novel.** The presentations were derived
  rather than cited because no literature search was run. The route the pass invented
  is the published route, down to the `S+kF` change of variables.
- **Open.** Whether Cotti's monograph, or the Dubrovin-conjecture literature it sits in,
  already records the collision locus of Euler multiplication on `F_a` — the paper's
  actual new object. Evidence gap: Chapter 9 was read; the monodromy-data chapters were
  not. Owner: whoever lands the citation for finding 2.
- **Open, inherited from C920 and correctly disclosed.** The rank-two Euler block has no
  primitive-sixth conclusion, only `N²=0`; and nonminimal, non-geometrically-ruled
  surface centers still need Hypothesis 5.7T for want of a support or base-change
  statement for Iritani's blowup comparison after coefficient specialization.

## Replay

```text
git diff eb9b34622 f06c3da38 -- 'papers/cubic-stabilization-epilogue/**/*.tex' \
  'papers/cubic-stabilization-epilogue/*.tex'
cd papers/cubic-stabilization-epilogue
make lint
make manuscript warnings
(cd verification && sha256sum -c hirzebruch-euler-spectrum.sha256)
uv run --with sympy python3 verification/hirzebruch_euler_spectrum.py --check
python3 lean/verification/check_formal_artifact.py --source-only   # RED, see above
```
