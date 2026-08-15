# C912 — The three framing-compatibility checks, run against Iritani's decomposition

**Lane:** `clebsch` · **Task:** C912 · **Date:** 2026-08-15

Scope: run the three checks listed under the frame-transport item of
`clebsch-tasks/c912-cubic-stabilization-referee-foundations.md`, which ask whether the
regular decomposition gauge of Hinault–Yu–Zhang–Zhang (HYZZ) can replace the
pro-Laurent bulk gauge of `lem:formal-base-shift` in the proof of
`prop:framed-operations`.  The proposal and its motivation are in
`2026-08-15-c912-frame-transport-memo.tex`, Section 6 (`sec:hyzz`); the adversarial
check that corrected the memo is `2026-08-15-c912-frame-transport-memo-red-team.md`.
The memo has since been revised to its third version, which carries the verdicts below
in its Section 6, replaces its route list and questions accordingly, and adds Section 7
carrying out the blockwise attack on the residual gap.  A fourth version then corrects
two errors in that attack, both at the coalesced blocks; the current file is 20 pages
with PDF SHA-256
`4dccbe6d9ecfcbda59f9d0f4243d8d8e3f35bc9798743a12b5e0d8c5ae4c2402`.
No manuscript, Lean, or export change is made by this pass.

**Headline.**  Check 1 fails as posed, for three independent reasons; check 2 passes and
is cheap to write into the manuscript; check 3 confirms the separation the card asked
for and yields one useful literature precedent for divisor tagging.  The framing route
does **not** remove the frame-transport blocker.  What the pass does deliver is a much
smaller and more exactly located residual gap than the memo states, plus the finding
that the memo's diagnosis of the cause is wrong: the pro-Laurent bulk gauge is not the
draft's idiosyncratic choice, it is Iritani–Koto's own fundamental solution `M`.

## 1. Sources, versions, locators

All three were read from the shared disk cache, extraction by `pdftotext`; the cache
records fetched bytes, so every statement below was read in the extracted text at the
locator given.

| Source | arXiv | version | SHA-256 of cached PDF |
|---|---|---|---|
| Hinault–Yu–Zhang–Zhang, *Decomposition and framing of F-bundles…* | 2411.02266 | as cached 2026-08-10 | `a11a093f790890804c7d4f7559b30ed2a6da87811de46f2aa0d29026e343e6bd` |
| Iritani–Koto, *Quantum cohomology of projective bundles*          | 2307.03696 | v4 (31 Jan 2026)     | `5139f8e0c9d46f8ccb8cb415396a0fb1fb357719b7dcfbca46234a9735b57624` |
| Iritani, *Quantum cohomology of blowups*                          | 2307.13555 | v3 as pinned         | `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b` |

Locators used: HYZZ (2.10) framing normal form, (2.21) and Assumption 2.22 and
Lemma 2.24 and Example 2.25 for the A-model F-bundle, Theorem 4.2 extension of framing,
Proposition 4.31, Section 4.4 with Definition 4.33, Theorem 4.34, Corollary 4.35,
Lemma 5.8, Lemma 5.11, Theorem 5.16 with (5.17)–(5.18), Theorem 5.20, (5.21),
Theorem 5.22 with (5.23), Theorem 5.24.  Iritani–Koto Theorem 5.1(1)–(6) and
Section 5.8 with (5.11)–(5.13).  Iritani Theorem 5.18(1)–(7), Section 5.8.1,
Section 5.8.2 with (5.45)–(5.47), Remark 5.19.

## 2. Check 1 — identify the decomposition with an F-bundle isomorphism governed by
Theorem 4.34

**Verdict: negative.  The identification cannot be written down as posed.**  Four
findings, the first three fatal to the identification and the fourth fatal to the
purpose it was meant to serve.

### 1a. Domain mismatch: Theorem 4.34 lives at the large-radius limit point

Section 4.4 of HYZZ is titled *Equivalence of F-bundles over a point*, and both
applications evaluate there.  In Theorem 5.16 the objects compared are the fibres
`H|_b` and `H'|_{b'}`, where `b` is the closed point `q = t = 0` of the base
(Example 2.25 with the one-variable Novikov projection `q^β ↦ q^{β·ω}` of (2.21)), and
the proof opens by observing that at that point "the quantum product reduces to the
classical cup-product", so that `K_split` of (5.18) is a cup-product operator and hence
nilpotent.  Theorem 5.22 is stated the same way for blowups.

The manuscript's `ν_6` is not evaluated there.  It is the framed multiplicity of the
small quantum connection over the Novikov field with `Q` formal and, on the comparison
side, over the Laurent extension in `q^{-1/(c-1)}` where the eigenvalues of `c_1⋆`
genuinely separate — for the cubic threefold, the block with `r = (3q)^{1/2}` and the
indicial roots `±1/6`, `±5/6`.  At `Q = 0` that separation collapses to a nilpotent
`K`, and the exponential blocks the framed operator is built from do not exist.  So
Theorem 4.34's conclusion is a statement about a different point of the same base, and
HYZZ supply no transport from that point to the one `ν_6` uses.  (Their Theorems 5.20
and 5.24 do reconstruct the isomorphism over the whole base from its restriction at
`b`, but that is uniqueness of a map whose existence is Iritani's and Iritani–Koto's
theorem — it is not a transport of framed monodromy between base points.)

### 1b. Hypothesis mismatch: the blowup summands have unequal dimension

Section 4.4 assumes the generalized eigenspaces `H_k` of `K` "all have same dimensions",
and the whole `m × m` matrix calculus of Definition 4.33 and Theorem 4.34 rests on the
resulting splitting `iso : H_0^{⊕m} ≅ H`.  The blowup decomposition (5.21) is
`H^*(X) ⊕ ⊕_{i=1}^{m-1} H^*(Z)[-2i]`, whose summands have different dimensions whenever
`dim H^*(Z) ≠ dim H^*(X)`; HYZZ themselves write a general endomorphism there as a
matrix with `Φ_{1,1} ∈ End(H^*(X))` and `Φ_{i,i} ∈ End(H^*(Z))`, so the mismatch is
explicit in their own notation.  Theorem 5.22 does assert existence of the isomorphism,
and Theorem 5.24 gives the corresponding uniqueness; the accurate criticism is not that
it is unproved but that it is not *derived from* Theorem 4.34 — whose hypotheses do not
cover the unequal block sizes — and that its existence is referred to the earlier
decomposition work.  So the blowup half of `prop:framed-operations` — equation (4.3),
the half the headline theorem cannot do without — gains nothing from Theorem 5.22 beyond
what Iritani's own theorem already supplies.

The projective-bundle half is genuinely covered: there the eigenspaces are `m` copies of
`H^*(X)` (Lemma 5.8), matching Section 4.4, and Theorem 5.16 is proved.

### 1c. The gauge that Theorem 4.34 supplies lands at the shifted base point, not the origin

Even where Theorem 4.34 applies, its conclusion is that the source F-bundle at `b` is
gauge-equivalent to the target F-bundle *based at* `Δ(a)`, where `Δ(a)` is pinned by
(5.17) for projective bundles and (5.23) for blowups.  That shift is exactly the object
the pro-Laurent gauge of `lem:formal-base-shift` exists to undo.  The framing route
therefore relocates the bulk displacement; it does not remove it.

The two normalizations agree on where the displacement sits, which is a useful
consistency check on the manuscript's reading of Iritani–Koto.  In HYZZ's limit-point
coordinates the eigenvalue `λ_i ∈ C[c_1,…,c_m]` is cohomology-valued, so `Δ(a)` acquires
components in `H^{≥4}` from the higher Chern classes, with the `H^2` components
cancelling identically (Lemma 5.8(2) gives `mλ_i ≡ mξ^{i-1} - c_1V`, which cancels the
`c_1V` on the right of (5.17)) and the `H^2` part of `Δ(a)` left free.  In Iritani's
coordinates the same data appears as `ς_j^∘ = -(c-1)λ_j + h_{Z,j} + O(q^{-1/(c-1)})`
with `λ_j = e^{-2πi(j+r/2)/(r-1)}q^{1/(r-1)}` a *scalar* — so the `H^0` part is the
scalar term, the `H^2` part is `h_{Z,j}`, and everything of degree `≥ 4` has moved into
the `O(q^{-1/(c-1)})` tail.  Same content, different bookkeeping.  The manuscript's
split of `ς_j^∘` into "unit twist + fixed divisor + positive-filtration tail" is
therefore right, and the tail is irreducibly present: for a trivial rank-two bundle
`V = O ⊕ O` all `c_i(V)` vanish, `λ_i = ξ^{i-1}` is a pure `H^0` scalar and HYZZ's
`Δ(a)` is purely `H^0 ⊕ H^2` — but Iritani–Koto's `ς_j^∘` still carries its
`O(q^{-1/r})` tail, so even `X × P^1` does not escape the bulk gauge.

### 1d. What the check does establish, and it is worth having

The comparison isomorphisms themselves need no receiver machinery.  Iritani's `Ψ` is an
isomorphism of `C[z]((q^{-1/s}))[[Q,τ̃]]`-modules (Theorem 5.18), and Iritani–Koto's `Φ`
is induced by a `C[z,q][[Q,τ̂]]`-module map and is an isomorphism over
`C[z]((q^{-1/r}))[[Q,τ̂]]` (proof of Theorem 5.1(6)).  Both are polynomial in `z`, with
inverses in the same ring.  Hence they lie in `GL_n(F((z)))` for `F` the Laurent
coefficient field, the turn fixes them pointwise, and the memo's transport theorem
(`thm:transport`, with `Γ = 0` so that Levelt–Turrittin is available) applies to them
directly, with no Hahn field, no product `GP`, and no inequality
`e·w(Δλ) < ε`.

So the receiver problem is not a property of the comparison; it is confined entirely to
the residual bulk gauge.  This is the one place where the framing route's promise is
realized, and it is realized without HYZZ.

## 3. Check 2 — the `u = 0` map and the reconstruction coordinate

**Verdict: positive; the ambiguity is harmless, and it is independently pinned.**

HYZZ Theorem 5.20(2) and Theorem 5.24(2) state that the base map `f` of an F-bundle
isomorphism is determined by its restriction to `b` up to a multiplicative constant in
the `q` direction; the proof of Proposition 4.31 shows where this comes from — `df`
determines `f` through `Ψ(d log p_i) = d log f_i`, and integrating a logarithmic form
leaves one multiplicative constant per logarithmic direction.

That ambiguity is a character of the Novikov lattice: `q ↦ cq` is
`Q^d ↦ c^{E·d}Q^d`, which is the divisor substitution
`Q^d ↦ e^{⟨a_2^∘,d⟩}Q^d` of the manuscript's (4.1) with `a_2^∘ = (log c)` times the
class dual to the logarithmic direction.  The manuscript already proves such a
substitution is a `z`-constant coefficient automorphism and therefore does not change
`ν_6`, and it already checks that the substitution is well defined on the image monoid.
Nothing further is needed for the bundle map: Theorem 5.20(1) and 5.24(1) leave `Φ` with
no ambiguity at all once its restriction to `b` is fixed.

Independently, the ambiguity never has to be tolerated, because Iritani's and
Iritani–Koto's normalizations pin it.  Iritani–Koto (5.11) gives the initial value in
closed form, `ς_j^∘ = rλ_j + [z^{-1}] log(q^{c_1(V)/(rz)}F_j(1))`, and (5.12) gives
`Φ_j^∘`; Iritani Section 5.8.1 fixes `Ψ|_{Q=τ̃=0}` from Lemma 5.13 and the explicit
`λ_j`.  Both papers then reconstruct `Φ`, `Ψ` and the coordinate changes from those
initial conditions by Birkhoff factorization (Iritani–Koto Section 5.8; Iritani Section
5.8.2).  A manuscript sentence citing (5.11)–(5.12), respectively Section 5.8.1, as the
normalization that fixes the logarithmic constant, and noting that any residual constant
is a divisor substitution already covered by (4.1), closes this check.  That sentence is
cheap and should be written whichever repair route wins.

## 4. Check 3 — keep the center specialization separate

**Verdict: confirmed, and the separation is sharper than the card assumed.**

The framing results are not merely upstream of the noninjective numerical center map;
HYZZ's center object is itself built on a collapsed Novikov variable.  Their A-model
F-bundle uses the projection `q^β ↦ q^{β·ω}` of (2.21) throughout, and in the blowup
application (before Theorem 5.22) the center copies are the maximal A-model F-bundles of
`Z` associated to `σ^*ω_X` — that is, with the Novikov direction pulled back from the
ambient variety, which is precisely the manuscript's specialization
`Q_C^d ↦ Q^{i_*d}u^{ρ_C·d}` in a coarser form.  So no HYZZ statement can certify that a
specialized center module carries an intrinsic framed monodromy; `ν_6(C;χ_j)` must stay
defined after the specialization, as `prop:framed-operations` already states, and
`lem:divisor-tagging` remains the route, in the current manuscript, for identifying the
specialized center contribution with the intrinsic invariant.  Proving specialized
vanishing directly in low dimension bypasses that identification instead of supplying
it.

One genuine gain.  HYZZ Lemma 2.24 proves that the collapsed potential `Φ_ω` determines
the full Gromov–Witten potential `Φ`, by using the divisor axiom to expand in the `H^2`
bulk directions and separating curve classes by their intersection numbers with an
`H^2` basis.  That is the same mechanism as `lem:divisor-tagging`, published, in a
closely related setting, and under the same finiteness hypothesis (Assumption 2.22, with
Lemma 2.23 supplying it whenever `ω + εc_1(TX)` is ample).  It does not close divisor
tagging: Lemma 2.24 works at the level of the potential over a base retaining all `H^2`
directions, while the manuscript needs the separation at the level of a framed operator
at a fixed bulk point, and the manuscript's collapse is by the pair `(i_*, ρ_C·)`
rather than by a single nef class.  But it makes the shape of the argument a cited one
rather than an invention, and it is worth one sentence in the manuscript and a
bibliography entry.

## 5. The residual gap, stated exactly

After checks 1d and 2, the blocker is no longer "transport framed monodromy across the
comparison isomorphism".  It is exactly this:

> Let `T` be smooth projective, `∇` its quantum connection, `τ^•` a bulk parameter lying
> in the positive filtration — `τ^∘ = q^{-1}[Z] + O(q^{-2})` on the ambient summand
> (Iritani Theorem 5.18(6)), the `O(q^{-1/(c-1)})` tail of `ς_j^∘` plus `s_j` on a center
> summand.  Show that the framed formal monodromy of `∇|_{τ = τ^•}` has the same
> primitive-sixth multiplicity as `∇|_{τ = 0}`.

Everything else in `prop:framed-operations` is either proved or reduced to a regular
gauge.  `lem:divisor-tagging` inherits the same single gap and nothing else.

**Correction to the memo.**  Section 6 of `2026-08-15-c912-frame-transport-memo.tex`
attributes the unbounded negative loop order to "the manuscript's choice, not something
the comparison theorems impose".  That is wrong.  Iritani–Koto's own reconstruction
(Section 5.8) transports along exactly the same object: their
`M = ⊕_j e^{-ς_j^∘/z}M_B(ς_j^∘+s_j; Qq^{-c_1(V)/r})`, described in their footnote 11 as
"a fundamental solution for `QDM(B)^{⊞r}_{ext,loc}` with respect to the variables
`(Q,s_0,…,s_{r-1})` (but not for `q` and `z`)", satisfies `M = id + O(z^{-1})` and lies
in `End(H^*(B)^{⊕r})[z^{-1}]((q^{-1/r}))[[Q,s]]`.  Per bulk degree it is a *polynomial*
in `z^{-1}`, which is the manuscript's own bound `(4.1a)` — `G_α` has no power of `z`
below `-|α|` — and it is unbounded only after summing over bulk degrees.  The sources
therefore meet the same object and handle it not by an ordered receiver but by Birkhoff
factorization, splitting the `z`-regular half `Φ` from the `id + O(z^{-1})` half `M'` in
`(Φ^∘)^{-1}∘M = M'∘Φ^{-1}`.  Any repair should be measured against that, not against a
receiver.

## 6. What this opens

Recorded as leads, with their status marked; none is a claim.

1. **Birkhoff route.**  The identity `(Φ^∘)^{-1}∘M = M'∘Φ^{-1}` of Iritani–Koto
   Section 5.8 (and Iritani Section 5.8.2) already factors the bulk transport into a
   `z`-regular factor and an `id + O(z^{-1})` factor.  The `z`-regular factor transports
   framed monodromy by the memo's theorem.  What has to be shown is that the
   `id + O(z^{-1})` factor does not change the primitive-sixth multiplicity — a
   `z = ∞`-side statement about a `z = 0` invariant, so it is not automatic, but it is a
   sharply posed and standard-shaped question, unlike the receiver inequality.
2. **Blockwise route, avoiding transport entirely — now the primary attack, carried out
   in the memo's Section 7.**  With Iritani–Koto's displayed conventions,
   `∇_a = ∂_a + z^{-1}(φ_a⋆)` and `∇_{z∂z} = z∂z - z^{-1}(E⋆) + μ`, two exact relations
   hold: commutativity and associativity give `[E⋆, φ_a⋆] = 0`, and flatness gives
   `∂_a(E⋆) = φ_a⋆ + [φ_a⋆, μ]` (signs follow the displayed connection and should be
   rechecked against the manuscript's normalization before use).  The first says bulk
   displacement never mixes exponential blocks; the second identifies `∂_aλ_i` with the
   `i`-th eigenvalue of `φ_a⋆`.  In the Kato block frame the leading operator evolves
   unconditionally by `D_aU_i = C_{a,i} + [C_{a,i}, μ_i]`.  The corresponding closed form
   for the residue, `D_aμ_i = [C_{a,i}, S_i]`, holds only when the block itself is
   semisimple: the off-block projector equation is the full Sylvester equation
   `(u_j-u_i)X + N_jX - XN_i = -(∂_aU)_{ji}`, and the blocks carrying `ν_6` are exactly
   those with `N_i ≠ 0`.  Worse, a nonsemisimple block is not modelled by the compressed
   pair `(U_i, μ_i)` at all — after decoupling it is `J + zD + z²E + ⋯`, and the
   manuscript's own cubic block shows the `z²` coefficient entering the exponents:
   with the `-8/81` entry the indicial polynomial is `ρ² + ρ + 5/36` with roots
   `-1/6, -5/6`, and without it the roots are `1/18, -19/18`, i.e. `±1/18` mod `Z`,
   contributing nothing to `ν_6`.  So this route has *not* reduced the coalesced case;
   what it has delivered is item 3 below plus the corrected equations.  The live danger
   is that the displacement *splits* a coalesced block, which would drop `ν_6` by two.
3. **Where `ν_6` can live at all — now proved, see the memo's Section 7.**  Quantum
   multiplication is Frobenius, so `E⋆` is self-adjoint for the Poincaré pairing and its
   distinct generalized eigenspaces are orthogonal; `μ` is anti-self-adjoint because the
   pairing is nonzero only in complementary degrees.  Hence every block residue
   `μ_i = P_i μ P_i` is anti-self-adjoint on its block: traceless, spectrum symmetric
   about zero, and identically zero on a multiplicity-one block.  So `ν_6` is carried
   entirely by blocks with repeated `E⋆`-eigenvalue, and every route only ever has to
   control those.  This matches the manuscript's cubic computation, where `K_0` has
   eigenvalues `±6r, 0, 0`: the simple `±6r` blocks contribute the identity, and the
   indicial roots `1/6` and `5/6` are `±1/6` mod `Z`, the symmetry the argument forces.
4. **Theorem 5.22 gives the blowup half no independent support.**  Anyone later tempted
   to cite it should know that it states existence, with uniqueness in Theorem 5.24, but
   is not derived from Theorem 4.34 — whose hypotheses do not cover the unequal block
   sizes — and that its existence is referred to the earlier decomposition work
   (finding 1b).  Citing it in support of (4.3) would add nothing beyond Iritani.

## 7. Mystery ledger rows for the card

| ID | Status | Discovery | Resolution / owner |
|---|---|---|---|
| C912-M14 | resolved | The frame-transport receiver problem was attributed to the comparison isomorphism; in fact both `Ψ` and `Φ` are `z`-polynomial module maps, so the transport lemma applies to them unconditionally. | Check 1d; the gap is the residual bulk gauge alone |
| C912-M15 | confirmed | The pro-Laurent bulk gauge is Iritani–Koto's own fundamental solution `M`, not a draft-specific choice; per bulk degree it is polynomial in `z^{-1}`, unbounded only in the limit. | Section 5; corrects the memo's Section 6 |
| C912-M16 | confirmed | HYZZ Theorem 5.22 (blowup) is asserted, with uniqueness in Theorem 5.24, but is not derived from Theorem 4.34, whose hypotheses miss the unequal block sizes; existence is referred to the earlier decomposition work. | Finding 1b; it adds nothing to (4.3) beyond Iritani |
| C912-M17 | resolved | The base-map ambiguity of Theorems 5.20/5.24 is a Novikov character, hence the divisor substitution (4.1), hence `ν_6`-invariant; the sources' explicit initial conditions pin it anyway. | Check 2; one manuscript sentence owed |
| C912-M18 | confirmed | HYZZ's center F-bundle is itself built on a collapsed Novikov variable, so the framing theory can never certify intrinsic center invariants; their Lemma 2.24 is nonetheless the divisor-tagging mechanism in print. | Check 3; `lem:divisor-tagging` stays owner |

## 8. Verification notes

No computation was run and no certificate is produced; every finding above is a source
reading at a stated locator, plus one derivation (the two flatness relations in route 2)
carried out from the displayed connection of Iritani–Koto Theorem 5.1 and marked as
needing a sign recheck against the manuscript's normalization.  Cached PDFs and their
hashes are in the table of Section 1; the extracted text used is
`/tmp/persistent/tavis/lit-search/text/arXiv_{2411.02266,2307.03696,2307.13555}.txt`,
and every quoted statement was read there rather than inferred.
