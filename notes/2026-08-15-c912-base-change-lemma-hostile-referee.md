# Hostile referee pass on the base-change lemma (`sec:base-change`)

Date 2026-08-15 · Lane `cubic-threefolds` · Task C912 · Purpose: hostile referee pass on the
base-change lemma.

**Target.** Section "The centre datum descends to the `J`-adic receiver" (`sec:base-change`,
lines 559–715) of `notes/2026-08-15-c912-frame-transport-memo.tex`: `lem:h0-scalar`,
`lem:descent`, `prop:base-change`, and the two closing subsections.

**Claimed purpose.** Discharge Obligation A of
`notes/2026-08-15-c912-normalization-statement.md`: make provable the manuscript's assertions at
`papers/cubic-stabilization-epilogue/sections/04-one-step.tex` l. 520–522 ("the center connection is
defined over `R_j`") and l. 532 ("The normalized connection descends to `B_j`").

**Sources actually consulted (not taken from the audit).**
`/tmp/persistent/tavis/lit-search/pdf/arXiv_2307.13555.pdf`
(sha256 `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`, 69 pp.) and
`/tmp/persistent/tavis/lit-search/pdf/arXiv_2307.03696.pdf`, re-extracted with
`pdftotext -layout` and read at the cited displays. Every quotation reproduced below was read
in the extraction, not copied from
`notes/2026-08-15-c912-h47h-source-exactness-audit.md` §11.

---

## Overall verdict

**MAJOR REVISION**, with `prop:base-change` **FATAL as stated** and `lem:descent` **refuted as
stated by its own proof**. The section does not, in its present form, discharge Obligation A.
The one part that survives is the localisation of the `u^{-1}` obstacle, and even there the proof
as written is not the proof that works.

A repair exists and is not deep, which is why the overall verdict is not FATAL: replace `R_j`
by its completion, adjoin `v = q^{-1/s_c}` (the manuscript already does this at l. 541 and the
section forgets it), delete every claim about `Ψ`, and supply the two computations the section
asserts instead of performing.

### Findings ranked by severity

| # | Locus | Claim attacked | Verdict |
|---|---|---|---|
| 1 | `prop:base-change` proof, "membership in `R_j` is decided monomial by monomial" | graded finiteness makes transport limit-free | **REFUTED** |
| 2 | `prop:base-change` statement and proof | `Ψ`'s and `Ψ^{-1}`'s entries lie in `R_j`, so their identities hold over `B_j` | **REFUTED** |
| 3 | `lem:descent` statement vs. its own proof | "every coefficient … lies in `R_j`"; "none acquires a positive power of `q`" | **REFUTED** (twice, internally) |
| 4 | `lem:h0-scalar` statement | `ς_j^0` enters (5.43) "in exactly two places" | **REFUTED** (not exhaustive) |
| 5 | `lem:h0-scalar` proof | the single twist cancels both occurrences | **UNSUPPORTED** (claim is true; I verified it, the memo's argument does not) |
| 6 | `lem:descent` proof | the Novikov sums converge `J_j`-adically | **UNSUPPORTED** |
| 7 | `lem:h0-scalar` proof, §5.8.1 citation | `M_C(σ)\|_{Q=0} = e^{σ/z}` licenses the twist | **UNSUPPORTED** (a `Q = 0` identity used for all `Q`) |
| 8 | closing caveat | the projective-bundle repair is "available and cheap", cite Remark 2.3 | **UNSUPPORTED** (the missing statement is the Remark 5.6 analogue, which Remark 2.3 does not supply) |
| 9 | `lem:h0-scalar` statement vs. proof | the twist is `exp(-(c-1)λ_j/z)` / `e^{-a/z}` with `a = -(c-1)λ_j` | **REFUTED** (the two disagree by a sign) |
| 10 | closing subsection | "his finite in `q` and infinite in `(Q, τ̃)`" | **REFUTED** (both completions are infinite in the same direction) |
| 11 | `lem:descent` proof, divisor character | `d ↦ e^{⟨h_{C,j},d⟩}` is a multiplicative character | **SURVIVES**, but only with a missing one-line descent argument |
| 12 | `lem:descent` proof, negative `ρ_C·d` | a negative `ρ_C·d` is harmless for `R_j`-membership | **SURVIVES** |
| 13 | `prop:base-change` proof, separation | `R_j ↪ B_j` | **SURVIVES** |
| 14 | `lem:h0-scalar`, coefficient of `φ_0` in `E_C` | equals 1 | **SURVIVES** (verbatim from Iritani (2.3)) |
| 15 | cross-section | the separation proof wants `L` large; §"The two rates" wants `L` minimal | consistency gap, not a refutation |

---

## Attack 1 — the `H^0` propagation claim

### 1a. Is "exactly two" exhaustive? — REFUTED

**Claim.** `lem:h0-scalar`: "It enters the centre connection (5.43) in exactly two places, in each
case as a scalar multiple of the identity and to the first power: through `E_C ⋆_{ς_j}` in
`∇_{z∂_z}`, and through `(q∂_q ς_j) ⋆_{ς_j}` in `∇_{q∂_q}`." The proof reinforces this: "the first
clause removes `ς_j^0` from `⋆_{ς_j}`, hence from `∇_{τ̃^α}`, from the `ı^*ξ⋆` term of
`∇_{ξQ∂_Q}`, and from the `ρ_C⋆` term of `∇_{q∂_q}`."

**Checked against.** Iritani (5.43), arXiv:2307.13555v3 p. 57, read verbatim in the extraction:

```
 ∇τ̃α    = ∂τ̃α  + z^{-1}(∂τ̃α ςj(τ̃)) ⋆
 ∇z∂z   = z∂z  − z^{-1}(EZ ⋆_{ςj(τ̃)}) + µZ
 ∇ξQ∂Q  = ξQ∂Q + z^{-1}(ı*ξ ⋆_{ςj(τ̃)}) + z^{-1}(ξQ∂Q ςj(τ̃)) ⋆_{ςj(τ̃)}
 ∇q∂q   = q∂q  − z^{-1}(r−1)^{-1}(ρZ ⋆_{ςj(τ̃)}) + z^{-1}(q∂q ςj(τ̃)) ⋆_{ςj(τ̃)}
```

**Verdict: REFUTED.** The enumeration is not exhaustive and the quoted proof sentence is false.
The lemma counts `(q∂_q ς_j) ⋆` as an occurrence of `ς_j^0` — correctly, because the `H^0`
component of the vector `q∂_q ς_j` multiplies as `(scalar)·id`. But `∇_{τ̃^α}` contains
`z^{-1}(∂_{τ̃^α} ς_j) ⋆` and `∇_{ξQ∂_Q}` contains `z^{-1}(ξQ∂_Q ς_j) ⋆`, which are structurally
identical clauses: the `H^0` component of `∂_{τ̃^α} ς_j` and of `ξQ∂_Q ς_j` enters exactly the same
way. There are four occurrences, not two. Remark 2.3 removes `σ^0` from the *product* `⋆_σ`; it says
nothing about `σ^0` appearing as the multiplied vector, which is precisely how it appears in three
of the four directions. The proof sentence "the first clause removes `ς_j^0` … from `∇_{τ̃^α}`"
therefore does not follow from the clause cited, and the memo silently omits the second term of
`∇_{ξQ∂_Q}` from its own enumeration while retaining the analogous second term of `∇_{q∂_q}`.

The error is harmless for the *`u^{-1}`* question — `ς_j^0 = -(c-1)λ_j + (tail)^0 + s_j^0`, and
`-(c-1)λ_j` is a function of `q` alone, so `∂_{τ̃^α}` and `Q∂_Q` annihilate it, leaving only
`q∂_q` — but the proof never makes that observation, which is the actual content of the step. As
written, the exhaustiveness argument is absent.

Consequence for the title: the two surviving occurrences (`∂_{τ̃^α}s_j^0 · id`,
`ξQ∂_Q s_j^0 · id`) are *not* removed by the twist, which is constant in `τ̃` and `Q`. So the
lemma's title, "The `H^0` coordinate is scalar and removable", over-reads its own content: the
`H^0` coordinate is not removable, only its `u^{-1}` part is.

### 1b. Is there a third occurrence outside (5.43)? — partly out of scope, partly UNSUPPORTED

The grading operator `µ_Z` and the Poincaré pairing `P_Z` (Iritani (2.3), (2.4)) are independent of
`τ`, so no occurrence there. The fundamental solution is a different matter: Iritani (5.44), p. 60,
gives `e^{ς_j(ϑ)/z} F̂_{Z,j}(c_α)|_{Q=ϑ=0} = q^{ρ_Z/((r-1)z)} F_{Z,j}(c_α)`, i.e. the initial-value
datum carries `e^{ς_j/z}` with the full `ς_j^0`, hence `u^{-1}`, in the exponent. The section
restricts the phrase "the centre datum" to the connection (5.43) without saying so. Since the
framed operator is read off a fundamental solution, that restriction is not obviously innocent and
is not defended.

### 1c. Does Remark 2.3 say what is claimed? — SURVIVES

**Checked against.** Iritani Remark 2.3, v3 p. 11, read verbatim: "Note that the quantum product
`⋆_τ` does not depend on `τ^0`, but `τ^0` appears in the Euler vector field `E_X` (while `τ^{(2)}`
does not appear in `E_X`)." The audit's §11.2 quotation of this remark is accurate, word for word,
including the surrounding sentence about the submodule `H^*(X)[z][[Qe^{τ^{(2)}}, τ']][τ^0]`.

No hypotheses are attached beyond `X` smooth projective and the ring `C[z][[Q,τ]]`. The statement
is offered without proof (it is the String and Divisor Equations), but it is unconditional. This
part of the lemma stands.

### 1d. Does `E_C`'s coefficient at `φ_0` equal 1? — SURVIVES

**Checked against.** Iritani (2.3), v3 p. 10: `E_X = c_1(X) + Σ_i (1 - deg φ_i / 2) τ^i φ_i`. With
`deg φ_0 = 0` the coefficient is `1`. Confirmed.

### 1e. Is the conjugation legitimate, and does Lemma 4.5 cover it? — UNSUPPORTED, plus a sign defect

**Claim.** "Since `a` is independent of `z` and the connection is flat, conjugating by `e^{-a/z}`
with `a = -(c-1)λ_j` cancels both occurrences at once. … its Lemma 4.5 already anticipates the case
at hand."

**What I checked.** The manuscript's Lemma 4.5 (`lem:formal-base-shift`),
`sections/04-one-step.tex` l. 270–314. Its hypotheses admit a bulk coordinate
`a_0·1 + a_2° + η` with the small connection defined over `Frac(A)`, so `a_0 = -(c-1)ζ_j u^{-1} ∈
Frac(R_j)` is within scope; and its proof does contain the sentence "When `a_0` is not
filtration-nilpotent this twist need not belong to the pro-Laurent gauge group, but a full turn on
the original `z`-disc fixes it, so its framed monodromy is trivial." So Lemma 4.5 does more than
mention the case: it disposes of the *framed-monodromy* effect of a unit-order `a_0`, correctly, by
single-valuedness in `z` (`a_0` is `z`-free, so `e^{-a_0/z}` is fixed by the turn).

**But Lemma 4.5 does not license what `lem:h0-scalar` needs**, which is the *cancellation*, i.e.
that one and the same scalar factor kills the `E_C` occurrence in `∇_{z∂_z}` and the `q∂_q ς_j`
occurrence in `∇_{q∂_q}`. That is a computation, and it is not in Lemma 4.5, nor in the memo.
I performed it. With `g = e^{f/z}` and `f` free of `z`:

- `g (z∂_z) g^{-1} = z∂_z + f/z`; the `E_C` clause contributes `-z^{-1}ς_j^0 = +z^{-1}(c-1)λ_j`, so
  cancellation forces `f = -(c-1)λ_j`.
- `g (q∂_q) g^{-1} = q∂_q - (q∂_q f)/z`; the clause `z^{-1}(q∂_q ς_j)⋆` contributes
  `z^{-1} q∂_q(-(c-1)λ_j) = -λ_j/z`, so cancellation forces `q∂_q f = -λ_j`.

These agree only because `q∂_q λ_j = λ_j/(c-1)` (from `λ_j = ζ_j q^{1/(c-1)}`, Iritani (5.30) p. 55)
exactly matches the prefactor `(c-1)` in `-(c-1)λ_j`. That numerical coincidence is the whole
content of "cancels both occurrences at once", and the memo's stated reason — `z`-independence plus
flatness — does not produce it. **The claim is true; the proof does not establish it. UNSUPPORTED.**

There is also a cleaner argument the memo does not use and should: by the String Equation the
entire `τ^0`-dependence of the quantum connection is `∇_{τ^0} = ∂_{τ^0} + z^{-1}`, so shifting the
`H^0` component of a bulk map by *any* function of the remaining variables conjugates the pulled-back
connection by `e^{shift/z}` in all four directions simultaneously. That argument is uniform, needs no
enumeration, and repairs finding 1a at the same time.

**Sign defect (finding 9).** The lemma *statement* says "Conjugation by the single rank-one factor
`exp(-(c-1)λ_j/z)`", i.e. `e^{a/z}` with `a = -(c-1)λ_j`; the *proof* says "conjugating by
`e^{-a/z}` with `a = -(c-1)λ_j`", i.e. `e^{+(c-1)λ_j/z}`. These are inverse to each other. My
computation selects the statement's factor, not the proof's. The memo never fixes a gauge
convention (`g∇g^{-1}` vs `g^{-1}∇g`), so the discrepancy cannot be resolved by the reader.

### 1f. Is `e^{-a_0/z}` inside the memo's own ground field? — not addressed

The memo's `H = Ω_V((Γ ⊕ Z e_z))` (l. 168) is a Hahn field of **well-ordered** support. The twist
`e^{-a_0/z} = Σ_k (ζ_j u^{-1})^k z^{-k}/k!` has support `{(-kγ_u, -k)}`, strictly decreasing in the
lexicographically-first coordinate, hence **not** well ordered: the twist is not an element of the
memo's own `H`, `H_e`, or `U_e`. Since the twist is a scalar, the operation is still meaningful as a
rank-one twist of the connection (it shifts the connection matrix, it does not conjugate it), but
that means the normalized connection is **not isomorphic over `R_j` or `B_j`** to the original — the
intertwiner lives outside every ring in play. The section never says this, and it is exactly the
kind of thing the residual gap discussion should distinguish.

---

## Attack 2 — the divisor-generator step

**Claim.** `lem:descent`: `(Q e^{τ^{(2)}})^d` maps under (5.15) to
`Q^{i_*d}u^{ρ_C·d} · e^{h_{C,j}·d} · e^{((tail)^{(2)} + s_j^{(2)})·d}`, first factor an `R_j`
generator, second a root of unity, third in `1 + J_j`.

**Checked against.** Iritani (5.15) v3 p. 46 (`Q_Z^d ↦ Q^{ı_*d} q^{-ρ_Z·d/(r-1)}`, explicitly "not
necessarily injective"), (5.19) v3 p. 47 (`h_{Z,j} = (2πi/(r-1))(j + 1/2)ρ_Z`), (5.30) v3 p. 55, and
Remark 2.3. All four quotations in audit §11.2/§11.3 check out verbatim.

**First factor — SURVIVES.** `u^{ρ_C·d} = q^{-ρ_C·d/(c-1)}`, so `Q^{i_*d}u^{ρ_C·d}` is character for
character Iritani's (5.15) image. Correct.

**Negative `ρ_C·d` — SURVIVES for membership, but see finding 3.** The combined monomial is the
generator, so `R_j`-membership is unaffected by the sign. This is right.

**Second factor — SURVIVES.** `e^{h_{C,j}·d} = e^{2πi(j+1/2)(ρ_C·d)/(c-1)}` is a root of unity of
order dividing `2(c-1)`. Correct.

**Well-definedness on the image monoid — SURVIVES only with an argument the lemma omits.** The
prompt's suspicion is well placed: (5.15) is *stated* to be non-injective, so a character on the
source monoid need not descend. It does descend here, but for a reason the lemma does not give:
`h_{C,j}` is a scalar multiple of `ρ_C`, and if `d, d'` have the same image monomial then
`Q^{i_*d}u^{ρ_C·d} = Q^{i_*d'}u^{ρ_C·d'}` forces `ρ_C·d = ρ_C·d'`, so `e^{h_{C,j}·d} =
e^{h_{C,j}·d'}`. Supply that sentence. Note that the *third* factor does **not** descend this way —
`e^{((tail)^{(2)}+s_j^{(2)})·d}` depends on `d` through a pairing with classes not proportional to
`ρ_C` — so the section's own framing ("the noninjective center monomial map merely replaces the
source ring by its image", manuscript l. 527–528) is doing real work and must be stated as
push-forward-only. It is not.

**Does the lemma need `e^{s_j^{(2)}·d} ∈ R_j`? — no, and it correctly disclaims it**, but see
finding 3: the disclaimer contradicts the lemma statement.

---

## Attack 3 — the transport argument (the step I was asked to suspect; it is the worst one)

**Claim.** `prop:base-change` proof: "An element of Iritani's graded completion has only finitely
many nonzero graded components, so it is a *finite* sum of homogeneous pieces and membership in
`R_j` is decided monomial by monomial rather than by a limit."

**Checked against.** Iritani §2.2, v3 p. 9, read verbatim in the extraction — the sentence
immediately after the definition of `K((x))`:

> "A homogeneous element of `K((x))` is of the form `Σ_{n=m}^{∞} a_n x^n` with `deg a_n + n deg x`
> being independent of `n`, for some `m ∈ Z`."

and Iritani–Koto Remark 5.3, v4 p. 27, read verbatim:

> "these can be defined over the 'homogeneous' completion `C[z]((q^{-1/r'}))_hom`, which consists of
> finite sums of homogeneous elements … `C[z]((q^{-1/r'}))_hom` is contained in the ring
> `C[q^{-1/r'}, q^{1/r'}][[z]]` **of formal power series in `z`**."

**Verdict: REFUTED.** A *single* homogeneous element of `C[z]((q^{-1/s}))[[Q, τ̃]]` is an infinite
series of monomials — Iritani says so in the very sentence that defines his `((·))`. Iritani–Koto
say the same thing from the other side: the homogeneous completion sits inside a ring of *formal
power series in `z`*, which is only possible because each homogeneous element carries infinitely
many `(q, z)` monomials. So "finite sum of homogeneous pieces" gives finiteness **in the grading
only**, and does not give finiteness in `q^{-1/s}`, in `Q`, or in `τ̃`.

The step therefore fails on both halves:

1. Membership in `R_j` is *not* decided monomial by monomial, because `R_j` — defined in the memo
   at l. 571–573 and in the manuscript at l. 484–486 as the subring *generated by* its listed
   elements — consists of **finite** sums. An infinite series each of whose monomials lies in `R_j`
   does not lie in `R_j`. Deciding "monomial by monomial" would at best place the element in a
   completion of `R_j`, which is exactly the limit the proposition says is not being taken.
2. Iritani's own reduced ring is a completion, not a finitely generated subring: Remark 5.6 v3 p. 47
   defines it as "the image `R` of `C[z][[Q_Z e^{σ^{(2)}}, σ']][σ^0]` under (5.15)" — **double**
   brackets. So the object the section wants to compare `R_j` with is `B_j`-like, not `R_j`-like.
   The proposition compares the wrong two rings.

The audit's §11.5 makes the identical error ("a statement 'this matrix entry lies in `R_j`' is a
statement about finitely many monomials — not a limit"), so this is not a transcription slip in the
memo; the memo inherited a false inference. **The audit's §11.5 verdict "NO OBSTRUCTION. The
identities transport; no limit has to be retaken" should be withdrawn.**

What survives: identities *do* transport along ring homomorphisms, and `R_j ↪ B_j` *is* injective
(finding 13). What is missing is a ring containing the entries and mapping to `B_j`. Establishing
that is the real content of Obligation A's second sentence, and it is untouched.

---

## Attack 2′/3′ — the `Ψ` claim (not in the prompt's list, and it is the second fatal one)

**Claim.** `prop:base-change`: "the two inverse identities for `Ψ` and the intertwining identity of
his Theorem 5.18(1) … hold over `B_j`", justified by "equalities of matrices whose entries, after
Lemma `lem:descent`, lie in `R_j`".

**Verdict: REFUTED, on three independent grounds.**

1. **`lem:descent` says nothing about `Ψ`.** Its statement covers "every coefficient of the
   normalized centre connection". `Ψ` is not a connection coefficient. The inference is a non
   sequitur on the section's own terms.
2. **`Ψ`'s entries involve variables that are not `R_j` generators.** Theorem 5.18 (v3 p. 58, read
   verbatim) makes `Ψ` an isomorphism of `C[z]((q^{-1/s}))[[Q, τ̃]]`-modules from `QDM(X̃)^{la}`;
   its entries are power series in the *ambient* bulk parameter `τ̃` and in the *ambient* Novikov
   variable `Q^{d̃}` for `d̃ ∈ NE(X̃)`. `R_j` is generated by `u`, the components of `s_j`, and the
   image monomials `Q^{i_*d}u^{ρ_C·d}` for `d ∈ NE(C)` only. Neither `τ̃` nor a general `Q^{d̃}` is
   in `R_j` or in `B_j`.
3. **`Ψ` needs `q^{-1/s}`, and `R_j`/`B_j` adjoin only `u = q^{-1/(c-1)}`.** Iritani (5.19), v3
   p. 47: `q_{Z,j} = (r-1)^{-1/2} e^{πi(jr + r/2)/(r-1)} q^{-r/(2(r-1))}`, and (5.44), v3 p. 60,
   puts `q_{Z,j} e^{h_{Z,j}/z}(1 + O(q^{-1/(r-1)}))` into the initial value of the comparison. For
   odd `c = r` that is a **half-integral power of `u`**, living in `q^{-1/s}` with `s = 2(c-1)` —
   confirmed against v3 p. 3 l. 61: "`s` equals `r - 1` or `2(r - 1)` depending on whether `r` is
   even or odd". The manuscript is aware of this and introduces `v = q^{-1/s_c}` with `v^e = u` at
   `sections/04-one-step.tex` l. 541; the memo's section does not, and asserts membership in a ring
   that provably does not contain the element.

This is the claim that would matter most downstream, since the receiver problem was supposed to
have been reduced to it. It is false as stated.

---

## Attack 4 — scope creep

### 4a. `lem:descent` statement vs. its own proof — REFUTED, twice

- The statement: "every coefficient of the normalized centre connection lies in `R_j`". The proof,
  four lines later: "The third lies in `1 + J_j`, hence converges `J_j`-adically: **it is an element
  of `B_j`, not of `R_j`**, and the lemma claims no more." The lemma does claim more; that is what
  its statement says. Independently, the coefficients of (5.43) contain `∂_{τ̃^α}ς_j(τ̃)` and
  `ξQ∂_Q ς_j(τ̃)`, which are series in `τ̃`, and `τ̃` is not an `R_j` generator. Unless the section
  first changes coordinates from `τ̃` to `s_j` — licensed by (5.47)/§5.8.2, v3 pp. 60–61, but never
  invoked here — the statement is false for the object it names.
- The statement's closing clause of the proof: "and none acquires a positive power of `q`". Three
  sentences earlier the same proof says "a negative `ρ_C·d` is harmless". If `ρ_C·d < 0` then
  `u^{ρ_C·d} = q^{|ρ_C·d|/(c-1)}` — a positive power of `q`. The two sentences cannot both hold.
  The audit §11.2 states the correct version ("an individual factor `u^{ρ_C·d}` can carry a positive
  power of `q`; this is not an obstruction"); the memo kept the reassurance and dropped the
  correction.

### 4b. `J_j`-adic convergence is asserted, not proved — UNSUPPORTED (finding 6)

The proof says the third factor and the `H^{≥4}` series "converge `J_j`-adically". For a single
factor that is immediate. But the connection coefficients are **sums over `d ∈ NE(C)`**, and
`J_j`-adic convergence of `Σ_d c_d Q^{i_*d}u^{ρ_C·d}(…)` requires that for each `N`, all but
finitely many `d` give a term in `J_j^N`. Each image monomial is a *single generator*, hence a
priori only in `J_j^1`. Getting it into `J_j^N` requires factoring `d` into `≥ N` nonzero effective
summands, which needs the effective monoid `NE_N(C)` to be finitely generated (or an equivalent
hypothesis). Nothing in the section supplies this. Note that the separation argument the section
does give proves `∩_N J_j^N = 0` — a *different* statement, which gives injectivity and no
convergence whatever.

### 4c. The closing disclaimer vs. the lemmas — mostly consistent, one over-reach

The boundary drawn in "What this settles, and what it does not" (`ν_6` still needs either the
rank-two gauge-free route of `sec:rigid` or a pro-Laurent transport theorem; `thm:transport` covers
only maps with no negative power of `z`) is consistent with `sec:hyzz`'s residual gap and with
`thm:transport`'s hypotheses. That much survives.

What does not: the same subsection asserts that Iritani's completion and `B_j` "agree on `R_j`,
which is all that is used". Given finding 3′, `R_j` is demonstrably *not* all that is used — `Ψ`
uses `τ̃`, ambient `Q^{d̃}`, and `q^{-1/s}`. And the characterisation "his finite in `q` and infinite
in `(Q, τ̃)`, the draft's `J_j`-adic and admitting infinite series in `u`" (finding 10) is wrong:
`C((q^{-1/s}))` is a Laurent-series field in `q^{-1/s}`, i.e. **infinite** in the `u`-direction —
the same direction in which `B_j` is infinite. The two completions are not "in different
directions"; they overlap, and their compatibility on that overlap is precisely the unproved point.

### 4d. The `Frac(R_j)` correction — SURVIVES and is the section's best contribution

The final caveat, that l. 520–522 should read "over `Frac(R_j)` before the strippings, over `R_j`
(with bulk completions in `B_j`) after", is correct and is a genuine improvement to the manuscript.
It matches Iritani (5.30) and the manuscript's own l. 276.

---

## Attack 5 — the projective-bundle caveat

**Claim.** "Iritani–Koto contain no analogue of Remark 2.3 or Remark 5.6 … The repair is available
and cheap — Iritani's Remark 2.3 is stated for an arbitrary smooth projective target, so it may be
cited directly for the base — but it must be written rather than assumed."

**Checked against.** I searched the v4 extraction of arXiv:2307.03696 for "smaller ring",
"preserves the submodule", and "Divisor and String": **zero hits**. The absence claim is correct.
Iritani Remark 2.3 is indeed stated for `X` smooth projective over `C[z][[Q,τ]]`, so it does apply
to `QDM(B)`.

**Verdict: UNSUPPORTED as a repair.** Remark 2.3 supplies the reduction for `QDM(B)` over
`C[z][[Q_B, σ]]` — i.e. *before* any base change. What the projective-bundle site actually needs is
the analogue of **Remark 5.6**, namely that the reduction survives the extension
`Q_B^d ↦ q^{-c_1(V)·d/r}Q^d` (Iritani–Koto (1.1), v4 p. 3) into `QDM(B)^{ext,loc}` ((5.3), v4 p. 27),
and that the pull-back along `τ̂ ↦ ς_j(τ̂)` preserves the corresponding submodule. Remark 2.3 does
not say that, and citing it "directly for the base" does not produce it. The audit itself is
explicit on this point — §11.6: "The remaining site-specific step — that the reduction survives the
base change (5.3)/(1.1) — is the same argument Iritani gives after his (5.15), and has to be written
out once." The memo's caveat drops that clause and thereby understates the outstanding work.

The memo also drops the audit's **gap two**: Iritani–Koto Theorem 5.1(4), v4 p. 28, gives only
`ς_j(τ̂)|_{Q=τ̂=0} = rλ_j - 2π√-1 j c_1(V) + O(q^{-1/r})` — big-O, not the polynomial membership that
Iritani (5.30) supplies on the blow-up site. The audit routes this through Iritani–Koto Remark 5.3;
the memo does not mention it at all, so a reader following the memo will assume the (5.30) shape by
analogy, which the source does not give.

**What does not break.** I checked for a structural difference in the twist. At the bundle site the
`H^0` term is `+rλ_j` with `λ_j = e^{2πij/r}q^{1/r}`, so `q∂_q(rλ_j) = λ_j` — the same coincidence
that makes the single-factor cancellation work on the blow-up site holds here too. The `H^2` term
`-2π√-1 j c_1(V)` is `q`-free and proportional to `c_1(V)`, so the character descends to the image
monoid by the same argument as in Attack 2. So the *shape* transfers; only the citations do not.

---

## Cross-section consistency (finding 15)

`prop:base-change` imports the manuscript's separation argument, which requires an ample-divisor
weight with `L` "so large that" `L(H·i_*d) + ρ_C·d ≥ 1`. The same memo's §"The receiver", under
"The criterion depends on a normalization the draft may choose" (l. 447–482), concludes that under
that instruction "the criterion fails at essentially every comparison with two distinct exponential
factors — including the cubic endpoint", and recommends the *minimal* admissible `L`. The
base-change section reuses the large-`L` phrasing without noting that its own memo has reversed the
recommendation. Nothing is refuted — the minimal admissible `L` also separates — but the section
should quote the corrected form.

For the record I checked the one way that argument could collapse: if some `d ≠ 0` effective on `C`
had `i_*d = 0`, then no `L` would give weight `≥ 1` and the image monomial `1` would lie in `J_j`,
forcing `B_j = 0`. This does not happen: `H·i_*d = (i^*H)·d > 0` for `i` a closed embedding, `H`
ample, `d ≠ 0` effective. **Finding 13, SURVIVES.**

---

## One source-fidelity note on the audit

Audit §11.3 quotes (5.43)'s first line as `∇_{τ̃^α} = ∂_{τ̃^α} + z^{-1}(∂_{τ̃^α}ς_j(τ̃))⋆_{ς_j(τ̃)}`.
The source, v3 p. 57, prints `⋆_{τ(τ̃)}` there — evidently a typo in Iritani, since the block is the
`ς_j` summand, but the audit corrected it silently and the memo inherits the corrected form. Flag it
so a referee is not surprised. Every other §11 quotation I re-checked (Remark 2.3, Remark 5.6,
(5.15), (5.19), (5.30), (5.44), §5.8.1, Theorem 5.18, Iritani–Koto 5.1(4), (1.1), (5.3), Remark 5.3)
reproduces the source exactly.

---

## What the section may be cited as proving, after repair

Nothing in the section may be cited as it stands. After the repairs below, the following may be:

1. **(Survives now, with a corrected proof.)** In the centre datum's connection (5.43), the unique
   carrier of `u^{-1}` is the `H^0` coordinate `ς_j^0`, whose `u^{-1}` part `-(c-1)λ_j` is a scalar
   independent of `z`, `τ̃` and `Q`; it reaches the connection only through `E_C ⋆` in `∇_{z∂_z}`
   and through `(q∂_q ς_j) ⋆` in `∇_{q∂_q}`, and the single rank-one twist `exp(-(c-1)λ_j/z)`
   cancels both. Cite Iritani Remark 2.3 (v3 p. 11) for `τ^0 ∉ ⋆_τ`, Iritani (2.3) for the
   coefficient `1` at `φ_0`, (5.30) for `λ_j = ζ_j q^{1/(c-1)}`, and supply the two-line
   `q∂_q λ_j = λ_j/(c-1)` computation. Do **not** cite §5.8.1's `M_C(σ)|_{Q=0} = e^{σ/z}`, which is
   a `Q = 0` identity; cite the String Equation instead, which also fixes the non-exhaustive
   enumeration.
2. **(Survives now.)** The manuscript's l. 520–522 must read: the centre connection is defined over
   `Frac(R_j)` before the strippings, because `λ_j = ζ_j u^{-1} ∉ R_j`.
3. **(Needs the repairs.)** After the twist and the divisor substitution, every coefficient of the
   normalized centre connection lies in the **`J_j`-adic completion `B_j`** — not in `R_j` — once
   (a) the coordinates are changed from `τ̃` to `s_j` via (5.47), (b) `v = q^{-1/s_c}` is adjoined,
   and (c) `NE_N(C)` is finitely generated (or the convergence hypothesis is stated).
4. **(Not available.)** No statement about `Ψ`, `Ψ^{-1}`, or Theorem 5.18(1) over `B_j`. That claim
   must be deleted or rebuilt over a ring that actually contains `τ̃`, ambient `Q^{d̃}`, and
   `q^{-1/s}`.

Obligation A's first sentence is discharged in corrected form (item 2 plus item 1). Its second
sentence — "the normalized connection descends to `B_j`" — is **not** discharged; it awaits items
3(a)–(c). The transport of the comparison identities is not discharged at all and is currently
claimed falsely.
