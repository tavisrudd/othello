# C1134 — AME-LU Astra/ChatGPT referee revision

**Lane:** `ame-lu`
**Status:** COMPLETED (2026-09-10). All referee items disposed; authority and standalone validated.
**Request:** queue a new C item to review and work on the referee feedback
supplied by the user on 2026-09-10. All conclusions below are referee
proposals pending independent checking against the authoritative manuscript.

## Source and judgment

The user supplied an Astra/ChatGPT mathematical source review of public
`tavisrudd/ame-lu` main, identified by the reviewer as `f5eb6b2`, dated
2026-09-07. The reviewer did not inspect the rendered PDF or independently
rerun Lean. Recommendation: accept after focused revision for a specialist
quantum-information or mathematical-physics journal; no fatal gap found in
the principal rigidity theorems. Strength: the combination of arbitrary
additive prime-power rigidity, constructive finite invariants, and explicit
robustness. Main reservations: precision, exposition, and avoidable losses
in the quantitative bounds. Do not treat this assessment as verification.

Source locators supplied with the review:

- https://github.com/tavisrudd/ame-lu/commits/main/
- https://raw.githubusercontent.com/tavisrudd/ame-lu/main/sections/01-introduction.tex
- https://raw.githubusercontent.com/tavisrudd/ame-lu/main/sections/05-quantitative-rounding.tex
- https://raw.githubusercontent.com/tavisrudd/ame-lu/main/sections/03-exact-rigidity-atlas.tex
- https://raw.githubusercontent.com/tavisrudd/ame-lu/main/figures/01-operator-holonomy.tex
- https://arxiv.org/html/quant-ph/0411115

Use local `papers/ame_lu/` as authority. Resolve the review's numbers to
current semantic labels before editing. These moving URLs are provenance,
not a frozen source snapshot.

## Required correction audit

1. **Lemma 6.1: Pauli-compatible encoding.** A stabilizer image alone is
   insufficient: with `V=V0 R`, a physical Pauli `T` satisfying `TV0=V0 P`
   implements `R† P R` relative to `V`, which can be non-Clifford despite
   zero implementation error. Require physical Pauli representatives for
   every input Weyl relative to the specified encoder. Explain why the AME
   Choi encoders meet this condition.
2. **Section 4.2: logical-frame output.** Distinguish a reference Clifford
   lift `C` from its symplectic label action `F`. The logical unitary is
   `(C^T)^(-1)=conj(C)`; with `X(a)Z(b)` and `tau(a,b)=(a,-b)`, its label
   action is proposed to be `tau F tau`, generally not `F^(-T)`.
   Odd-prime diagnostic: `F=[[1,0],[1,1]]` gives respectively
   `[[1,0],[-1,1]]` and `[[1,-1],[0,1]]`. Check phase/tableau conventions.
3. **Unitarity.** Corollary 1.2 must say `U_i in U(q)` (then `L` is unitary
   by the isometry relation). Lemma 6.1 must say transversal unitary `T`
   and `L in U(q)`. Qualify the preceding composition identities for `E`.
   Nonunit scalar rescaling is the diagnostic for the bare intertwiner
   statement. Check the introduction's one-site-operator terminology.
4. **Theorem 6.7: optimizing phase.** For `z` attaining
   `epsilon(U)=||U psi-z psi||`, use `L_i=z(U_i^T)^(-1)` to obtain the
   non-phase-optimized identity `E(T_i,L_i)=epsilon(U)`, or explicitly
   rephase first. Diagnostic: one factor `exp(i theta) I`, all others `I`.
5. **Bell boundary.** Repeat `m>=2` in Corollary 1.2, Proposition 3.5,
   and Proposition 6.9, or supply an unmistakable standing convention.
   At `m=1`, arbitrary `U tensor conj(U)` preserves the Bell state.

Preserve the review's two non-errors: linear atlas recovery does not control
the affine stabilizer character or ensure a nearby exact symmetry; the
separate overlap gap supplies the latter. Relative-intertwiner stability
assumes an exact base intertwiner and does not create exact equivalence
from approximate proximity.

## Quantitative improvements: prove before adopting

1. **Remove the characteristic loss in Lemma 6.2.** After proving
   additivity of `F`, put `d(v,u)=[Fv,Fu]-[v,u] in F_p`. The existing
   bound `|1-omega^d|<=4 eta` also holds for `(tv,u)` for every `t in F_p`.
   If `d!=0`, character orthogonality gives
   `p^(-1) sum_t |1-omega^(t d)|^2=2`, contradicting
   `16 eta^2<16/9<2` when `eta<1/3`. Check every earlier use of the old
   characteristic threshold, additivity, and all-label quantification.
   Proposed main radius:
   `R*_(n,q)=min{1/(4 sqrt(2q)), 1/(8 pi sqrt(n))}`.
   Retain local `8 epsilon` and collective `pi sqrt(q) epsilon` estimates.
   Check `n>=4` implies `8 epsilon<1/3` and verify the claimed redundant
   overlap clause via
   `epsilon(K)<1/2+1/(8 pi sqrt(n))<d_2<=d_p`.
   If valid, propagate the sufficient scaling
   `Theta(min{q^(-1/2),n^(-1/2)})` through all manuscript and trust surfaces,
   removing the superseded prime-versus-extension distinction.
2. **Dimension-independent transition compatibility (Proposition 6.9).**
   For two-site support `S={i,j}`, use maximal mixedness directly:
   `||(C-C_K)psi||=q^(-1)||C-C_K||_HS`.
   With phase-chosen normalized local errors `delta_s<=8 epsilon`, check
   the one-site commutator replacement cost `4 delta_s`; telescoping
   gives `64 epsilon`, then `|1-zeta|<=68 epsilon` including the original
   `4 epsilon`. Scale the stabilizer label by every `t in F_p`; justify
   that the resulting phase is `zeta^t` for the same rounded frames.
   Character averaging proposes exact compatibility for
   `epsilon<sqrt(2)/68`, inside the proposed local threshold `1/24`.
   This is only transition-map compatibility, not a dimension-independent
   nearby-exact-product-symmetry radius. Keep the character obstruction.

## Exposition and artifact requests

3. Work one example throughout the constructions:
   `psi=(1/3) sum_(x,y in F_3) |x,y,x+y,x+2y>`.
   Show why any two coordinates determine `(x,y)`, give stabilizer
   generators, a half-set systematic matrix, a minimum-support subgroup,
   a transition map, a cycle matrix, and one character repair. Add a brief
   extension-field example explaining `Sp_(2e)(F_p)` versus `SL_2(F_q)`.
4. Center abstract/introduction on exact and robust rigidity; collect
   classification and operational consequences in a compact subordinate
   paragraph. Preserve substantive results while improving reading order.
5. Make the novelty comparison explicit: prior qubit minimal-support work
   already concludes that the actual LU factors are Clifford; cleaning
   already supplies the three-region logical Clifford mechanism. Attribute
   the broader additive prime-power scope, conversions, finite invariants,
   and robustness accurately. Follow the literature-audit/cache rules
   before adding source-dependent or novelty claims.
6. Collect recognition input/output: promised stabilizer-AME check
   matrices, fixed party labels unless separately searching permutations;
   compact symplectic witnesses, with actual Clifford–Pauli conversions
   when phase/tableau data is supplied. State dependence on `q`, AME promise,
   and compact output versus dense unitary matrices beside fixed-`q`
   polynomial complexity.
7. Preserve the partial-formalization boundary in Appendix C. Supply an
   immutable public revision, exact supported build command, and statement
   to declaration correspondence where available; otherwise shorten the
   appendix to an honest disclosure. Full formalization is not required.
   No new kernel-checking claim without its actual gate. Any Lean work
   requires its own allocation and the canonical nested instructions.

The review's subjective percentile estimates (not correctness probabilities)
were: overall 80, intended-assumption correctness 85, precision 70, exact
mechanism originality 65, package originality 80, specialist significance
85, quantitative sharpness 60, organization 55, direct-specialist access
75, adjacent-specialist access 55, generalist access 35, formalization
transparency 85. These are context, not acceptance metrics.

## Execution and acceptance gates

- First read the paper style guide and applicable task-routed instructions;
  freeze the authoritative baseline and record a disposition for every item
  above: accepted/repaired, already satisfied, or rejected with evidence.
- Prioritize statement repairs and the two quantitative proof audits, then
  the worked example, recognition contract, framing, and reproducibility.
- Validate all constants and edge cases, synchronize affected paper-local
  maps under annotation rules, run the existing manuscript/release checks,
  and inspect the rendered changes. Do not weaken gates.
- Preserve C979 and Paper II. Synchronize intended public changes only
  after authority validation and the full export/mirror conventions.
  No push, deposit, or submission is authorized by this queue request.
- Before mathematical closeout, run the required explicit `ej`+`tt` pass
  and add a Mystery ledger with settled points and precise remaining gaps.
  Archive the row only when the task has actually completed.

## Allocation-session record

Only this card, allocation ledger, live queue, and lane handoff were changed.
No mathematical proposal was verified or adopted during queuing.
Command-shaping failure: the initial handoff read exceeded the output limit;
the full handoff was subsequently read in bounded chunks. An aggregate chunk
display also truncated, and was replaced by individual bounded displays.


## Execution record — authority revision

Baseline: `4ffd0546e0d0df957946b6836ba359883451cfcb`; the pre-edit PDF is
preserved at `/tmp/persistent/tavis/c1134/before.pdf` for visual comparison.

All five proposed corrections are accepted and applied. The same unitary
hypothesis omission in `prop:full-weyl-marginal` was repaired, and the
relative-rounding corollary now explicitly takes a product unitary.
Both quantitative improvements reconstruct from the existing inequalities:
additivity plus averaging gives the characteristic-free Fourier threshold,
and two-site maximal mixing gives the normalized commutator bound. The
constant `3/4<d_2` provides a simple exact overlap-gap comparison. The
local-rounding threshold is `1/24`; the universal transition radius is
`sqrt(2)/68`; the global radius remains the two-clause minimum. These are
sufficient bounds, with no optimality claim.

The example is a manuscript calculation, not computational evidence. Its
systematic blocks are `[[2I,2I],[2I,I]]`, its cycle is `2I`, its character
repair is `Z_1(-1)`, and the F9 variant supplies a genuine Frobenius
symmetry. A sentence marks the scalar cycle as a simple propagation example
rather than a model for restrictive holonomy. A forward reference supplies
an early route through the definitions.

Recognition now explicitly states the AME promise, fixed labels, compact
symplectic output, and tableau/lift requirements for a Clifford–Pauli
conversion. Abstract/introduction prioritize exact and robust rigidity;
secondary results remain in the body and are signposted. Appendix C takes
the referee's disclosure-only option: the table of partial formal coverage
remains, but internal gate/count/toolchain narration no longer masquerades
as an independently replayable formal artifact. No Lean theorem was edited,
built, or promoted to stronger coverage.

The new prior-work sentence was checked against the proof of Theorem 1 in
Van den Nest–Dehaene–De Moor, arXiv:quant-ph/0411115v2 (PDF p. 4): it
explicitly proves that each factor of the given LU is Clifford. Cached
source SHA-256: `c0f8e192552369d5af9304ebf08995f59b6917e243a570f37ff1b29f3b4cb735`.
Read depth: Theorem 1 and its proof, not a new exhaustive literature audit.
The primary arXiv HTML was also opened; no new absence-of-prior-work claim
was introduced. Existing quantitative and recognition ledgers are updated.

### Independent reviews

A fresh Astra bounded source referee read covered the quantitative proofs,
new example, encoder bridge, and headline statements. Recommendation:
minor revision, no mathematical blocker. It independently checked Fourier
concentration, additivity/character averaging, the m=2 residual bound,
logarithm and overlap constants, universal transition compatibility,
qutrit arithmetic, F9 Frobenius, and logical frame conventions. Its four
exposition findings are repaired: even-party scope, prime-field dimension
gloss, explanation of the deliberate `5H/16` to `H/4` weakening, and the
correct role of second moments versus balanced-cut coercivity. Its scope
excluded the unchanged endomorphism classification, external-source audit,
Lean replay, and PDF layout.

Two fresh anonymous source comparisons (primary QI specialist and adjacent
mathematical-physics reader) both prefer B, the revision, decisively/high
confidence. They independently highlight the example, encoder distinction,
recognition promise/output, and formalization disclosure. Both name reduced
early visibility of the algebra consequences and loss of internal toolchain
information as tradeoffs. The former is intentional hierarchy; the latter
follows the chosen disclosure-only option. They explicitly do not validate
the stronger quantitative assertions, which the separate mathematical read
does. Packets: `/tmp/persistent/tavis/c1134/version-A.tex` and
`version-B.tex` (source comparisons, not PDF comparisons).

### Validation in progress

Spacing lint passes. The first `make check` acquired a large TeX distribution
through Nix and was interrupted by this agent before TeX began; it was not a
mathematical/source failure. The same gate is running with the offline
cached Nix invocation. Its final PDF, warnings, release identity, visual
comparison, and downstream synchronization remain outstanding.
The task-owned manuscript/README/ledger changes remain uncommitted while
that source/PDF validation bundle is incomplete; no foreign work is staged.


### Explicit ej + tt closeout pass (after the mathematical acceptance gate)

The free upgrades are already incorporated: the logical-rounding corollary
inherits the universal transition radius; explicit unitary hypotheses are
also supplied in the reusable full-Weyl marginal and relative-intertwiner
statements; the example demonstrates both scalar-cycle propagation and the
affine character ambiguity. No additional theorem or numerical tightening
is needed. The useful structural distinction is now three separate steps:
local Clifford recovery, exact symplectic compatibility, and nearby exact
state symmetry. Only the last retains the dimension/party entry cost.

### Mystery ledger

- **Settled: apparent characteristic dependence.** It came from testing
  a smallest individual root-of-unity chord, although all scalar multiples
  were available. Character orthogonality removes it in both arguments.
- **Settled: local-dimension loss in the atlas commutator.** The two-site
  reduced state is maximally mixed, so normalized Hilbert–Schmidt control
  is exact on the state and operator-norm conversion was unnecessary.
- **Settled: why the example has unrestricted base frames.** Its unique
  fundamental cycle is scalar `2I`; the text now says this explicitly.
- **Open: character control at a universal radius.** Localized commutators
  are exactly invariant under local Pauli changes; the missing evidence is
  an estimate controlling the character discrepancy or a collective
  pre-branch frame estimate. C1134 does not prove that such a radius is
  impossible and does not allocate a speculative successor.
- **Open: optimal order of the global radius.** The current q and n factors
  enter through logarithm selection and pre-branch accumulation. There is
  no matching obstruction family in this task. Keep this as the paper's
  existing open problem, not a sharpness claim.
- **Disclosure boundary, not a mathematical mystery:** no pinned public
  statement-to-declaration replay contract is supplied here. Appendix C is
  explicitly a partial-formalization disclosure; constructing the formal
  release artifact would require its own allocated work.

These are task-owned findings; no incidental discovery-track entry is
manufactured.


### Authority acceptance gate

The warning-free 40-page `make check` passes with the same Makefile gate
and `LATEXMK="nix shell --offline nixpkgs#texlive.combined.scheme-full -c latexmk"`.
The final cached rerun confirmed that all source targets were current.
The first visual helper failed because the persistent cache mount forbids
executable shared-object mappings; moving only the uv package cache under
`~/.cache/c1134-uv` fixed it. Rendered outputs remain on persistent storage.

All 38 baseline and 40 revised pages were visually compared in paired
contact sheets; the six affected pages 14, 18, 23, 26, 29, and 36 were also
inspected at reading resolution. Equations, example blocks, diagrams,
references, and the trust table are legible without clipping or collisions.
PDF text confirms the final source glosses are present. The example occupies
one complete page. The total two-page growth is accepted for the added
example, precise hypotheses, and expanded quantitative proof.

The release verifier passes: 18 public artifacts and 83 formal companion
artifacts. Final PDF SHA-256:
`3618593bf9f1cffacac897b0b6f21ebcaf0dc3f9a25d412034d3e45a144f1f03`.
Public release tree:
`4ee700f38f5a11f2148e5a4e77cebf1739a7b4f68200105ebd621a8b5a39e7b5`.
The formal tree remains exactly
`8edfd61de5701e231d09f897f668bdeac82889d49dd787087e3847f4b9434434`.
This is hash verification, not a new Lean elaboration or axiom audit.

Post-build `ej`+`tt` recheck confirms the earlier Mystery ledger: the cheap
logical-radius and hypothesis clarifications are adopted, the remaining
character/optimal-radius questions remain open, and no further scope is
added. Authority changes are ready for their forward commit; mirror
synchronization is the remaining release step.


## Completion and downstream identity

All five required corrections and all seven ranked suggestions are handled.
The two quantitative suggestions were independently proved before adoption;
formal reproducibility uses the explicitly offered shorter-disclosure option.
Authority revision: `f6f342e24ae21ab2fdb6f1aef6fb4c006ebc1a5d`.
Standalone forward commit: `55e70c4` in `~/src/math-papers/ame-lu`.
Exporter plan/audit: 25 scholarly source files, zero findings. The final
export verification covers 28 tracked files including provenance metadata;
content SHA-256:
`d28e862005353d762336eafe4b6bb1130716879601540a6d85ef572d483a1359`.
The standalone warning-free build regenerates the same 40-page PDF byte for
byte; its public release hash equals the authority hash above. The standalone
correctly reports that the 83 formal artifacts are absent and not checked
there. This task neither altered nor reran Lean.

No push, deposit, tag, submission, or external message was made. C979,
Paper II, other manuscripts, and the portfolio summary were untouched.
There is no further required C1134 work. The optional next mathematical
question is the already identified character-control bound; it requires a
separate allocation, not an implied optimality claim or an invented C id.
The discovery-track discriminator was reviewed at closeout; no incidental
entry was warranted.
