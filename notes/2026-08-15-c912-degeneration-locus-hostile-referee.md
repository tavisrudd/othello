# Hostile referee report on the degeneration-locus claim (repair B)

**Date:** 2026-08-15 · **Lane:** `cubic-threefolds` · **Task:** C912

**Target:** `2026-08-15-c912-degeneration-locus.md` (verdict there: PROVED).
**Also read:** `2026-08-15-c912-route-assessment.md` §3;
`2026-08-15-c912-frame-transport-memo.tex`, `sec:blockwise` (`thm:block-evolution`)
and `sec:rigid` in full.

**Overall verdict: MAJOR REVISION.** No false step was found in the new
mathematics. The central algebra lemma is correct, and is in fact provable under
weaker hypotheses than the report uses. Two of the report's own admitted
framework imports are load-bearing for the headline sentence, and one of them
(rank-two-ness of the component) is in direct tension with the argument the
report uses to make (H1) free. The verdict "PROVED" is not supportable as
written; "proved modulo three named framework facts, two of them load-bearing"
is.

---

## 0. What I verified independently

Before the item-by-item verdicts, two checks that were run from scratch rather
than taken from the target or the memo.

**(a) `det μ_0 = -361/324` at the cubic point is correct.** The report asserts
`μ_0 = diag(19/18, -19/18)`, and a reader may reasonably suspect that this
number was read off the memo's `A'_0 = D_0 = diag(-19/18, 19/18)`, which is a
*different* object (see §5 below). It was recomputed here directly from the
small quantum cohomology of a smooth cubic threefold, with no reference to the
memo's block data.

In the basis `(1, H, L, pt)` with `H·H = 3L`, `H·L = pt`, small quantum
corrections `H⋆H = 3L + aq`, `H⋆L = pt + bqH`, `H⋆pt = cqL + eq²`: Frobenius
gives `a = c`; associativity of `(H⋆H)⋆L = H⋆(H⋆L)` gives the relation used
below; `a = ⟨H,H,pt⟩_1 = ⟨pt⟩_1 = 6` (six lines through a general point);
imposing the spectrum `{0,0,±6r}`, `r = (3q)^{1/2}`, on `E⋆ = 2H⋆` forces
`2a + 3b = 27` and `a² = 3e`, hence `b = 5`, `e = 12`. The value `b = 5` is
independently the classical intersection number `C_ℓ · C_{ℓ'} = 5` of two
incidence curves on the Fano surface of lines, so the system is
over-determined and consistent.

With those values `charpoly(H⋆) = x²(x² - 27q)`, and the generalized
zero-eigenspace is `H_0 = span(v, w)` with

    v = L - 7q·1,   w = pt - 2q·H,   (H⋆)v = w,   (H⋆)w = 0.

So `U = E⋆ = 2H⋆` has `Nv = 2w`, `Nw = 0`: the memo's `ν = 2` and `N ≠ 0` at
the cubic point are confirmed. Compressing the grading operator
`μ = diag(-3/2, -1/2, 1/2, 3/2)`: `P_0 μ v = (-19/18)v` and
`P_0 μ w = (19/18)w`. In the shear frame `(e_1, e_2) = (w, v)` (which is the
frame forced by `Ne_1 = 0`, `Ne_2 = ν e_1`) this is exactly
`μ_0 = diag(19/18, -19/18)`, so `det μ_0 = -361/324`, versus the resonance
threshold `-81/324`. **The report's numeric claim stands, verified.** It also
happens that `A'_0 = -μ_0` exactly at the cubic point, which explains the
coincidence of numerals — but see §5, that is an accident of the gauge at that
point, not an identity, and the report should say so.

**(b) The `ν_6 = 2` bonus is more robust than the report's own argument.** See
§5(c): I checked the second branch, which the report does not, and the count is
still two.

---

## 1. Is the spectral decomposition a decomposition into ideals? — **SURVIVES**

It is, and the report's proof of this is unnecessarily expensive. The report
routes through the KKPY atom idempotent `e_α`, importing the framework in order
to get the ideal property. That import is not needed.

*The clean statement.* Let `A` be a commutative unital algebra acting on itself
by the regular representation, with cyclic vector `1`. If an operator `T`
commutes with every multiplication operator, then `T(x) = T(x ⋆ 1) = x ⋆ T(1)`,
so `T` *is* multiplication by `T(1)`; the commutant of the regular
representation is `A` itself. Now `P_0`, the spectral projector of `U = E⋆` for
the eigenvalue `u_0`, is a polynomial in `U` (primary decomposition over the
residue field at the point), and every `C_a` commutes with `U` by
`lem:flatness-ids`. Hence `P_0` commutes with every `C_a`, so `P_0 = e_0 ⋆ (·)`
with `e_0 := P_0(1)`, and `P_0² = P_0` gives `e_0 ⋆ e_0 = e_0`.

Consequences, all of which strengthen the report:

- `H_0 = e_0 QH^even` is an ideal and a unital subalgebra with unit `e_0`,
  **pointwise, with no atom formalism and no global cover**.
- Therefore `P_0 C_a P_0` is genuinely multiplication by `e_0 φ_a` on `H_0`:
  for `x ∈ H_0`, `φ_a ⋆ x = φ_a ⋆ e_0 ⋆ x = (e_0 φ_a) ⋆ x ∈ H_0`.
- The "several local factors sharing an `E`-eigenvalue" scenario is harmless.
  Whatever the factor structure, `e_0 QH^even` is a rank-two commutative unital
  algebra, which is all Lemma 2.1 consumes. Both degenerate shapes are covered,
  as the assignment already noted.
- `e_0` is `G`-self-adjoint because it is an algebra element and the pairing is
  Frobenius, so `G` restricts nondegenerately to `H_0`, and `μ_0 = e_0 μ e_0` is
  `G_0`-anti-self-adjoint, hence traceless. Tracelessness of `μ_0` is used twice
  downstream and it is correctly established.

The lemma does not collapse. **Revision required:** state the lemma with the
local spectral projector, and use `e_α` only where globality is actually needed
(Theorems B and C). As written, the report makes Theorem A hostage to a
framework citation it does not need.

I also checked the identity the whole argument rests on. With `P` any analytic
idempotent commuting with `U` and every `C_a`, Kato's `T_a = (∂_aP)(2P - 1)`
satisfies `∂_aP = [T_a, P]` and `P T_a P = 0` (differentiate `P² = P` and
compress; needs char ≠ 2), and

    D_a U_0 = P(∂_aU)P + P[U, T_a]P = C_{a,0} + [C_{a,0}, μ_0],

the second term dying because `U` commutes with `P`. Taking traces gives
`p_a = ∂_a u_0` and the traceless part gives `D_a N = C'_a + [C'_a, μ_0]`
unconditionally, using `D_a` of the identity section `= 0`. **Correct.** The
report's §1 reading of `thm:block-evolution` — that its first identity needs no
eigenvalue separation and no perturbation formula — is accurate.

## 2. Do the `C_{a,0}` span the multiplications of `A_α`? — **SURVIVES**

Yes, and the even part is enough. The worry about odd classes is misplaced
because the module in play is not `QH`: it is `A_α = e_α QH^even`, an ideal of
the *even subalgebra* `QH^even` (even ⋆ even ⊂ even, and `e_α ∈ QH^even`), with
unit `e_α`. `H_α` is a summand of `H^even` by construction, so `QH^odd` never
enters. The map `H^even → A_α`, `φ ↦ e_α ⋆_τ φ`, is surjective by definition of
`A_α` as its image, and `{φ_a ⋆_τ}` over a basis `φ_a` of `H^even` spans all
multiplication operators because `QH^even_τ = H^even ⊗ Λ` as a module. Lemma 2.1
then reads: if every multiplication on a rank-two unital algebra were scalar,
then `a = a ⋆ e_α = λ(a) e_α` for all `a`, so the algebra is rank one.
**Correct.**

The report's phrase "for quantum cohomology the state space *is* the algebra,
with cyclic vector `1`" is loose — it should say the even subalgebra — but
nothing turns on it.

**One scope error that must be fixed.** Lemma 2.1 requires the bulk directions
to span `H^even`; the report flags this itself (§6.4). The claim as circulated
in the assignment says "the **small** even quantum connection". That is wrong:
over a base of divisor directions only, the image of `H^2 → A_α` may be `Λ·e_α`
and Lemma 2.1 fails. Everything in the report is a statement about the **big**
even bulk. For the cubic *at the cubic point* the divisor direction happens to
suffice (`e_0 H` is non-scalar there: `H⋆|_{H_0} = N/2 ≠ 0`), but that is a
point check, not the theorem. Nothing here may be cited for the small
connection.

## 3. The resonance locus — **SURVIVES with narrowing**

The algebra is right. `X ↦ X + [X, μ_0] = (I - ad μ_0)X` on `sl_2` has
determinant `∏(1 - λ)` over the `ad μ_0`-eigenvalues `0, ±2m`, i.e.
`1 - 4m² = 1 - (m_1 - m_2)²`, singular exactly when the exponents differ by
`±1`, i.e. `det μ_0 = -m² = -1/4` for traceless `μ_0`. The assignment's own
determinant `-(m_1-m_2-1)(m_1-m_2+1)` is the same polynomial, and its value
`-280/81` at `m_1 - m_2 = 19/9` is correct. The degenerate cases are covered:
if `μ_0` is a nonzero nilpotent, `ad μ_0` is nilpotent and never has eigenvalue
one, consistent with `det μ_0 = 0 ≠ -1/4`. The numeric non-resonance at the
cubic point is confirmed independently in §0(a).

**The narrowing.** The report's claim of "two independent arguments, one
algebraic and pointwise, one analytic" is an overstatement, and the second of
its "two independent confirmations" in §4 is not independent of the first. The
pointwise argument delivers only

    int(Z) ⊆ {det μ_0 = -1/4},

which is not the theorem. To convert it one must know the resonance locus is
nowhere dense, and the report's proof of that is (A2) — the identity principle
on an irreducible base — which is the *same and only* analytic input that makes
Theorem B(ii) work. Given (A2), Theorem B(ii) is a two-line triviality (`Z` is a
proper closed analytic subset of an irreducible space), and Lemma 2.1 and
Theorem A are not needed for nowhere-density at all. So:

- If (A1)/(A2) hold, `Z` cannot have interior anywhere, inside the resonance
  locus or outside it, and the interaction the assignment worries about does not
  arise.
- If (A1)/(A2) fail, nothing rules out `Z` having interior inside
  `{det μ_0 = -1/4}`. The report says as much ("I did not close that case
  algebraically") and the configuration it records there (`A_α ≅ Λ[ε]/(ε²)`, all
  `C'_a` proportional to one `ad(μ_0)`-weight-one nilpotent) is suggestive but
  is not an argument.

**Revision required:** delete the "two independent arguments" framing from §0
and §4. There is one analytic argument with two decorations, plus an
unconditional pointwise statement that localizes any hypothetical interior.

## 4. Does `D_a N ≠ 0` give empty interior? — **SURVIVES**

This is the step the assignment was right to single out, and it is clean here,
unlike the refuted horizontal-section argument. `D_a = ∂_a - [T_a, ·]` is a
genuine covariant derivative on `End(H_α)` in the Kato frame, and:

- at an *interior* point of `Z`, `N ≡ 0` on a neighbourhood, so `∂_a N = 0` and
  `[T_a, N] = 0` separately, hence `D_a N = 0`. Contrapositive of Theorem A then
  puts the point in the resonance locus. Valid.
- at any point `p ∈ Z`, the connection term dies because `N(p) = 0`, so
  `D_a N(p) = ∂_a N(p)` **exactly**. There is no possibility of confusing a
  covariant with an ordinary derivative at a zero of the section: they coincide
  there. Corollary A1's "vanishes to first order in some bulk direction" is
  therefore a genuine statement about the ordinary derivative.

No misinterpretation. The differentiation-under-`≡0` step is sound provided
"interior" means interior for the admissible (G-)topology, where an admissible
open is positive-dimensional and supports the derivations `∂_a`; the report
never says which topology it means, and it should.

## 5. The extension step — **SURVIVES with narrowing; one UNSUPPORTED sub-claim**

Three separate things to grade.

**(a) The tool and its hypotheses — correct, citation still owed.** The rigid
first Riemann extension theorem (Bartenwerfer's Hebbarkeitssatz; also
Lütkebohmert) is the right instrument for a *bounded* function on the complement
of a nowhere-dense analytic subset of a *normal* rigid space, in codimension
one, where the unconditional codimension-two statement is unavailable. Normality
holds (smooth base), `Z` is analytic (zero locus of an analytic section of
`End(H_α)`), and the theorem is local, so local boundedness near `Z` suffices.

Boundedness is **proved, not hoped**: `α` is the eigenvalue of `A'_0` on the
canonical line `L = im N = ker N`; `α² = -det A'_0` is analytic on `B` because
`A'_0` is traceless (from `eq:parity`) and analytic; hence `|α| = |α²|^{1/2}` is
locally bounded near `Z` even though the branch selection degenerates there.
That is a valid non-archimedean boundedness argument. The report deserves credit
for correcting the assignment's "the coefficients are regular" to "bounded":
the assignment's version was false.

I re-derived the determinant formula and it is right. In the shear frame
`R = [[α, ν], [(A'_1)_{21}, -α-1]]`, so `tr R = -1` identically and
`det R = -α² - α - ν(A'_1)_{21} = -α² - α - tr(N A'_1)`. Cubic point:
`α = -19/18` gives `-α² - α = -19/324`; `tr(N A'_1) = 2·(-8/81) = -64/324`;
`det R = 45/324 = 5/36`. Confirmed.

**(b) UNSUPPORTED: `A'_0` and `A'_1` are global analytic sections only if a
global splitting gauge exists, and the regularity audit is gauge-relative.** The
report's table asserts `α² = -det A'_0` and `tr(N A'_1)` are "analytic on `B`"
with the justification that "a `z`-independent frame change acts on the `A'_p`
by conjugation alone". That justification covers the choice of frame within the
block; it does *not* cover the block-splitting gauge freedom of `lem:decouple`,
which is `z`-dependent. Under `k = I + zk_1 + ⋯` block-diagonal,

    A'_0 ↦ A'_0 + [k_1, N],    A'_1 ↦ A'_1 + [k_1, A'_0] + [k_2, N] + k_1,

and with `N = νE_12` one has `[k_1, N] = ν·[[-k_{1,21}, k_{1,11}-k_{1,22}], [0, k_{1,21}]]`,
so **`α` shifts by `-ν k_{1,21}` and `tr(N A'_1)` shifts correspondingly**.
Neither piece of the report's three-row audit is gauge invariant; only their
combination `det R` is, by the memo's `rem:gauge-independence` (the conjugated
shear `S^{-1}kS` is regular and invertible at `z = 0`, hence conjugates the
residue). The audit is therefore an audit *relative to one globally fixed
splitting gauge*, and the existence of such a gauge on all of `B` is exactly
what needs (H1) globally — which is the open `Y`-locus question of §6.2. The
report's own caveat says Theorem C needs `Y = ∅`; it does not notice that the
same condition is what makes its regularity table meaningful. **Revision
required:** state the audit after fixing a global isometric splitting gauge, and
cite `rem:gauge-independence` for the invariance of the combination.

This same point explains, and should be used to defuse, the numeral coincidence
in §0(a): `A'_0 = -μ_0 + [g_{1,0}, N]`, so `A'_0` and `-μ_0` agree only up to a
gauge shift whose diagonal is `(∓ν k_{21})`. They happen to agree exactly at the
cubic point (verified in §0(a)), which is why `19/18` serves both the resonance
check and `α`. A reader will otherwise conclude the report has conflated two
different objects. It has not, but it does not say why.

**(c) Narrowing: at points of `Z` the sheared residue does not exist, and the
"decoration" there is choice-dependent.** The shear is the elementary
modification along `L = ker N = im N`, which is undefined when `N = 0`. So
"`char(R) = ρ² + ρ + 5/36` on the whole component" (§0 Theorem C, §7 "Buys")
means the characteristic polynomial of the *analytic continuation from* `W`, not
of any residue intrinsically attached to a point of `Z`. Three computations make
the gap concrete. Let `ᾱ` be the continuation of `α`, so `ᾱ² + ᾱ + 5/36 = 0` at
`b ∈ Z`, i.e. `ᾱ ∈ {-1/6, -5/6}`.

- No shear at `b`: the block is already regular singular with residue `A'_0(b)`,
  whose characteristic polynomial is `ρ² - ᾱ² ∈ {ρ² - 1/36, ρ² - 25/36}`.
  **Not** `ρ² + ρ + 5/36`.
- Shear at `b` along the isotropic line with `(A'_0)_{11} = ᾱ`:
  `R = [[ᾱ,0],[(A'_1)_{21}, -ᾱ-1]]`, char `= ρ² + ρ - ᾱ² - ᾱ = ρ² + ρ + 5/36`.
  Matches.
- Shear along the *other* isotropic line, `(A'_0)_{11} = -ᾱ`: char
  `= ρ² + ρ - ᾱ² + ᾱ`, i.e. `ρ² + ρ - 7/36` for `ᾱ = -1/6` and
  `ρ² + ρ - 55/36` for `ᾱ = -5/6`. **Different polynomial.**

So the decoration is not a well-defined function on the component; it is
well-defined on `W` and its value on `Z` is fixed only by continuation. Since
route 1's whole plan is to use `char(R)` as an *atom* decoration compared
against KKPY's ledger, this well-definedness gap sits exactly where the
comparison would need it. The report is aware in §5 ("the comparison can be made
on `W`") but its §0 and §7 headline sentences elide it. **Revision required:**
Theorem C must be stated as constancy on `W` plus continuation, not as a
pointwise identity on `B`.

The good news, and this is stronger than the report's own claim: **`ν_6 = 2` at
points of `Z` for every branch.** Exponents are `{ᾱ, -ᾱ-1}` on the first branch
and `{-ᾱ, ᾱ-1}` on the second; for `ᾱ = -1/6` these are `{-1/6, -5/6}` and
`{1/6, -7/6}`, for `ᾱ = -5/6` they are `{-5/6, -1/6}` and `{5/6, -11/6}`. All
four sets are `{1/6, -1/6}` mod `Z`, and all give two primitive sixth roots. The
report checks one branch and calls the agreement "a nontrivial consistency
test"; it is nontrivial and it passes on both branches, so the count-two
conclusion at `Z` does not depend on the continuation at all. Non-resonance
holds too (exponent differences `2/3`, `4/3`, `-8/3`, none integral), so
`exp(2πiR)` really does compute the framed monodromy there and `rem:no-levelt`'s
caution is not triggered.

## 6. Framework exposure — **two UNSUPPORTED and load-bearing, one UNSUPPORTED and fatal-if-false**

The report lists these itself; the referee's job is to say which are cosmetic.
None are cosmetic.

**(a) (A1): the base is a connected smooth analytic space and `U`, `C_a`, `μ`,
`e_α` are analytic on it. UNSUPPORTED, load-bearing.** No citation is given, and
the substantive content — non-archimedean convergence of the *big* quantum
product over the Novikov field, so that the A-model `F`-bundle has an analytic
rather than merely formal base — is asserted, not established. The report calls
this "the single most exposed point" and is right. If it fails: Theorem B(i)
(`det N ≡ 0` globally), Theorem B(ii) (`Z` nowhere dense) and Theorem C all
collapse; the surviving statement is the pointwise `int(Z) ⊆ {det μ_0 = -1/4}`,
plus formal-germ statements, which is not the claim. **This alone forbids the
verdict "PROVED".** Sub-points also owed: which topology "nowhere dense" and
"interior" refer to, and a citation for (A2) in the form used (Conrad's
irreducible components, plus connected + normal ⟹ irreducible).

**(b) Which cover indexes atoms — the `Y` collision locus. UNSUPPORTED,
load-bearing for the extension half of the claim.** If atoms are indexed by
components of the character cover in `T*B` rather than the `E`-eigenvalue cover,
two components may share an `E`-eigenvalue on a locus `Y`, `lem:decouple`'s
Sylvester operators fail there, and there is no global splitting gauge. Then
`A'_0` and `A'_1` are not defined on `B`, §5's regularity audit has no subject,
and Theorem C is void. Theorems A and B are untouched, as the report says. So
the first half of the claim (`Z` nowhere dense) survives `Y ≠ ∅` and the second
half (the decoration extends) does not. The report calls this an open check; it
is, and it is not a side issue.

**(c) Rank-two-ness of the component. UNSUPPORTED, load-bearing everywhere, and
in tension with the report's own §1 point 2.** Every downstream step uses
`rank H_α = 2`: `u_0 = ½ tr U|_{H_α}`, the `sl_2` spectrum of `ad μ_0`,
`N² = -det N·I`, `adj(N) = -N`, the two-isotropic-line normal form. The report's
§1 point 2 argues that distinct components of the eigenvalue cover are disjoint
in `A¹ × B`, so their eigenvalues differ at every point of `B`, giving (H1)
globally "for free". That argument is correct as far as it goes, but it
*presupposes* what §6.3 admits is imported: that the component carrying the
coalesced sheet is a rank-two component over all of `B`. If the eigenvalue cover
of the big bulk is irreducible of degree four — and over a full polydisc of
topologically nilpotent `τ` with `|6r| = |3q|^{1/2}` possibly small, this is not
excluded by any estimate in the report — then the component *is* the whole
cover, `rank H_α = 4`, and there is no global rank-two summand at all. The rank
two summand then exists only on the sub-locus where the `0` and `±6r` sheets
separate, and "nowhere dense on the component" becomes a statement about a
different, smaller space than the one named. **The report cannot have both §1.2
and §6.3 for free: they are the same fact stated from two sides.**

## 7. The refutation of repair A — **SURVIVES**

This negative claim is correct and is the most robust part of the report. Repair
A needed `C'_a` to vanish wherever `N` does; Lemma 2.1 says some `C'_a` is
nonzero at *every* point of the base, so at `p ∈ Z` some `C'_a(p) ≠ 0` while
`N → 0`, and the corresponding `q_a = C'_a/N` on `W` is unbounded near `p`.
Combined with `(2)`, `D_a N(p) = C'_a(p) + [C'_a(p), μ_0(p)] ≠ 0` off the
resonance locus, so `N` satisfies no homogeneous linear equation there and the
"horizontal section, so the zero locus is open and closed" picture is not merely
unproved but false. This needs no analytic framework, only the pointwise algebra
lemma and the unconditional identity `(2)`, both of which check out above.

Two narrowings, neither serious: the refutation is vacuous if `Z = ∅` (in which
case repair A's conclusion holds trivially by other means), and it refutes
repair A's *hypothesis*, so a reader should not read it as "the zero locus is
nonempty".

---

## 8. What may be cited, and at what strength

**Unconditional (may be cited as proved, for the big even bulk of any smooth
projective target, at a point where the summand has rank two):**

- Lemma 2.1 — at every point of the base some `C'_a ≠ 0`. Needs only: quantum
  cohomology commutative unital Frobenius, the summand an ideal of rank ≥ 2,
  bulk directions spanning `H^even`. Prove it with the local spectral projector,
  not the atom idempotent.
- The identity `D_a N = C'_a + [C'_a, μ_0]`, global and unconditional, and
  `p_a = ∂_a u_0`.
- Theorem A — `D_a N ≠ 0` for some `a` at every point with `det μ_0 ≠ -1/4`;
  equivalently off the locus where the two exponents of `μ_0` differ by one.
- Corollary A1 — `int(Z) ⊆ {det μ_0 = -1/4}`, and `N` vanishes to genuine first
  order at every point of `Z` off that locus.
- Corollary A2 — repair A is false; `q_a` does not extend across `Z`; `N` is not
  a horizontal section.
- `det μ_0 = -361/324` at the cubic point (independently verified here).
- `ν_6 = 2` at points of `Z`, for either choice of isotropic line — stronger
  than the report's one-branch version.

**Conditional on the analytic framework (A1)+(A2), citation owed:**

- Theorem B(i) — `det N ≡ 0` on the whole base, globalizing `thm:no-splitting`.
- Theorem B(ii) — `Z` is nowhere dense. Note this follows from (A1)+(A2) alone
  and does not need Lemma 2.1 or Theorem A; do not advertise it as a consequence
  of the algebra lemma.

**Conditional on (A1)+(A2) *and* `Y = ∅` *and* rank-two-ness of the component:**

- Theorem C — `tr R = -1` and `det R = 5/36` on `W`, extending across `Z` by
  bounded Riemann extension, hence constant. Must be stated as constancy on `W`
  plus continuation; the pointwise decoration on `Z` is choice-dependent.

**May not be cited at all:** any version of this for the small quantum
connection; "the decoration equals `ρ² + ρ + 5/36` at every point of the
component" read as a statement about an intrinsically defined residue on `Z`;
"two independent arguments for nowhere-density".

## 9. Required revisions, in order

1. Downgrade the verdict from PROVED to conditional, naming (A1), `Y = ∅`, and
   rank-two-ness, and say which conclusion each one kills.
2. Reprove Lemma 2.1 and Theorem A with the local spectral projector, and record
   that the ideal property is automatic from the commutant of a commutative
   algebra with cyclic vector. This decouples the unconditional half of the
   report from the framework citations entirely.
3. Resolve or acknowledge the §1.2 / §6.3 tension: the disjointness argument for
   free (H1) presupposes the rank-two-ness that §6.3 imports.
4. Restate the §5 regularity audit relative to one globally fixed isometric
   splitting gauge, note that `α` and `tr(N A'_1)` are individually
   gauge-dependent, and cite `rem:gauge-independence` for the invariance of
   `det R`.
5. Explain the `19/18` coincidence: `A'_0 = -μ_0 + [g_{1,0}, N]` in general, and
   the two agree at the cubic point but not by an identity.
6. Restate Theorem C as constancy on `W` plus continuation, and add the
   two-branch `ν_6` check, which is a real strengthening.
7. Delete "two independent arguments" and replace with the accurate accounting:
   one unconditional pointwise localization, one analytic argument used twice.
8. Cite Bartenwerfer for (A3) and Conrad for (A2), and fix the topology in which
   "interior" and "nowhere dense" are meant.

**Vibe check.** Better than the two refuted arguments, and the core lemma is
right — but the report is claiming a rank of certainty its own §6 contradicts,
and the second half of the headline (the decoration extends) rests on an open
check the report itself flags.
