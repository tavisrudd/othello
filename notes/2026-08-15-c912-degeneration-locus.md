# The degeneration locus `Z = {N = 0}` is nowhere dense (repair B)

date 2026-08-15, lane cubic-threefolds, task C912

**Verdict: PROVED**, on a base carrying the framework KKPY already assume (an
analytic base, connected, with the atom idempotent). Two independent arguments
are given, one algebraic and pointwise, one analytic. The algebraic one also
settles repair A in the negative: `C'_a` does **not** vanish on `Z`; some
`C'_a` is nonzero at *every* point of the base, so `q_a` really does blow up at
`Z` and `N` is not a horizontal section of anything.

The second step (does the decoration extend across `Z`?) is answered too, with
a correction to how it should be formulated: the coefficients of `p` are **not**
regular on the nose, but they are *bounded*, and boundedness plus the
Riemann-extension theorem for normal rigid spaces is what makes the extension
work. A bonus check: `ν_6 = 2` at the points of `Z` as well, for a reason that
is a nontrivial consistency test rather than a tautology.

Companions: `2026-08-15-c912-route-assessment.md` (§3 is the assignment),
`2026-08-15-c912-frame-transport-memo.tex` (`sec:rigid`, `sec:endpoint`),
`2026-08-15-c912-gauge-normalization-verification.md`.

---

## 0. Statement of what is proved

Write `B` for the base of the A-model `F`-bundle (the even bulk, an analytic
space over the Novikov field `Λ`), `e_α ∈ QH^even(B)` for the idempotent of the
connected component `Σ_α` of the spectral cover carrying the cubic atom,
`H_α = e_α H` the rank-two summand, `u_0 = (1/2) tr(U|_{H_α})`,
`N = U|_{H_α} - u_0 I`, `μ_0 = e_α μ e_α|_{H_α}`, `Z = {N = 0} ⊂ B`.

**Theorem A (pointwise, no analytic input).** At every point `b ∈ B` there is a
bulk direction `a` with `C'_a(b) ≠ 0`. Consequently, at every `b` with
`det μ_0(b) ≠ -1/4` there is a direction `a` with `(D_a N)(b) ≠ 0`.

**Corollary A1.** `Z ∩ {det μ_0 ≠ -1/4}` has empty interior, and along it `N`
vanishes to first order in some bulk direction.

**Corollary A2 (repair A is false).** There is no point of `B` at which all
`C'_a` vanish. In particular `C'_a` does not vanish on `Z`, `q_a = C'_a/N`
genuinely blows up at `Z`, and `D_a N ≠ 0` there off the resonant locus. The
"`N` is horizontal, so its zero locus is open and closed" picture is not merely
unproved; it is wrong.

**Theorem B (analytic).** If `B` is connected and normal (it is smooth), then
`Z` is a proper closed analytic subset, hence nowhere dense, and `det N ≡ 0` on
all of `B`.

**Theorem C (the second step).** `tr R = -1` identically. `det R` is bounded on
`W = B ∖ Z`, locally constant there, and equals `-α² - α - tr(N A'_1)` with
`α² = -det A'_0` and `tr(N A'_1)` both analytic on `B`; so it extends across `Z`
and is constant on the whole of `B`, hence on `Σ_α`.

The resonance exception `det μ_0 = -1/4` in Theorem A is real, not an artifact:
it is exactly the condition that the two exponents of `μ_0` differ by `1`. At
the cubic point `μ_0 = diag(19/18, -19/18)`, so `det μ_0 = -361/324 ≠ -81/324`,
and the exception is off by a definite amount there.

---

## 1. The critical issue: what space is this on?

The assignment is right that "nowhere dense" is not a formal-germ notion, and
that repair B is ill-posed unless the identities live on a genuine space. They
do. Item by item.

**`[U, C_a] = 0`.** Commutativity and associativity of the quantum product.
This is a pointwise identity among the structure constants, valid wherever the
big quantum product is defined. Global on `B`.

**`∂_a U = C_a + [C_a, μ]`.** Flatness of the quantum connection together with
the Euler field and the grading. Again an identity among structure constants and
their first derivatives, valid at every point of `B`. Global.

**Frobenius.** `(a ⋆ b, c) = (a, b ⋆ c)` is pointwise. So `U` and every
`C_a` are `G`-self-adjoint and `μ` is `G`-anti-self-adjoint at every point.
Global. Since `e_α` is an idempotent *of the algebra*, it is `G`-self-adjoint
too, so `G` restricts nondegenerately to `H_α`, `μ_0` is `G_0`-anti-self-adjoint
(hence traceless), and `N`, `C'_a` are `G_0`-self-adjoint. Global.

**`thm:block-evolution`, first identity.** Its proof uses only
`[U, C_a] = 0`, `∂_a U = C_a + [C_a, μ]`, an idempotent commuting with `U` and
with every `C_a`, and the Kato rule `D_a A_0 = P_0(∂_a A)P_0 + P_0[A, T_a]P_0`.
No perturbation formula, no eigenvalue separation, no formal completion. It
therefore holds globally on `B` for **any** analytic family of idempotents
commuting with `U` and the `C_a` — in particular for `e_α`. So

    D_a U_0 = C_{a,0} + [C_{a,0}, μ_0]                                  (1)

is a global identity of analytic sections. Taking traces in (1) gives
`2 ∂_a u_0 = tr C_{a,0}`, so with `C_{a,0} = p_a I + C'_a` one has
`p_a = ∂_a u_0` **unconditionally** (this does not need `lem:commutant`, which
is where regularity of `U_0` would have entered), and the traceless part of (1)
is

    D_a N = C'_a + [C'_a, μ_0].                                          (2)

Global, unconditional, and not homogeneous in `N`. This is the assignment's
`(*)`.

**Why `e_α` and not `P_0`.** The memo carries hypothesis (H1) — the other
eigenvalues differ from `u_0` by units — because it uses the spectral projector
of the eigenvalue `u_0`. That projector is local. The atom idempotent is not: it
is the idempotent of a connected component of the spectral cover, it is a global
section of `QH^even(B)`, and `e_α H` is a locally free summand of constant rank
over connected `B`. Two consequences worth recording:

1. Working with `e_α` makes (1) and (2) global with no separation hypothesis at
   all, which is what a statement "on the component" needs.
2. If the spectral cover is the eigenvalue cover — a closed subscheme of
   `A^1 × B` finite over `B` — then distinct connected components are *disjoint*
   as subsets of `A^1 × B`, so the eigenvalues of `Σ_α` and `Σ_β` differ at
   **every** point of `B`. That is (H1), globally, for free. This is the correct
   global form of (H1) and it is stronger than what the memo assumes.

Point 2 carries a caveat that a referee will press and that I could not settle
from the material here: KKPY present the spectral cover of a maximal `F`-bundle
inside `T*B`, i.e. as the cover by *characters of the whole algebra*, not by
`E`-eigenvalues alone. Two distinct characters can agree on `E`. If the atom
indexing is by components of the character cover, then two components can share
an `E`-eigenvalue at some locus `Y ⊂ B`, and there the block-splitting gauge of
`lem:decouple` fails, because its Sylvester operators are invertible only when
the `E`-eigenvalues are separated. **Theorem A and Theorem B below do not use
the splitting gauge and are unaffected.** Only Theorem C and the memo's rigidity
chain need it, and they need `Y = ∅`. Someone should check against KKPY which
cover indexes atoms; if it is the character cover, the memo owes a treatment of
`Y`, which is a second thin locus of exactly the same flavour as `Z`.

**Applying the germ theorems pointwise.** `sec:rigid` is proved over
`B = Λ[[τ]]`. That is not a defect once the inputs are global: `Λ[[τ]]` is the
completed local ring of `B` at a point, `U`, `C_a`, `μ`, `G` restrict to it as
Taylor expansions, and every hypothesis the section uses is checkable at the
point. So `sec:rigid` may be applied at the germ of **each** point of
`W = B ∖ Z`, and what it delivers is `∂_a R = [R, G_a]` at each such germ, i.e.
**local constancy of `char(R)` on `W`**. Local constancy is exactly what a germ
theorem can give and exactly what the globalization needs as input. Repair B is
therefore well posed. The remaining work is the two topological steps: `Z`
nowhere dense, and passage from locally constant on `W` to constant on `B`.

---

## 2. The pointwise algebra input

This is the observation the whole thing turns on, and it is elementary.

For quantum cohomology the state space *is* the algebra: `H = QH` as a module
over itself, with cyclic vector `1`. Hence

    H_α^even = e_α H^even = e_α QH^even =: A_α,

and `A_α` is a rank-two commutative unital `O_B`-algebra acting on `H_α^even` by
its own regular representation, which is faithful. The bulk directions are a
basis `φ_a` of `H^even` (this is the *big* even connection; the argument would
not run on a base of divisor directions only), and

    C_{a,0} = multiplication by e_α φ_a on A_α.

The map `H^even → A_α`, `φ ↦ e_α φ`, is surjective, since `A_α` is by
definition its image.

**Lemma 2.1.** At every point `b ∈ B` there is an `a` with `C'_a(b) ≠ 0`.

*Proof.* If every `C_{a,0}(b)` were scalar, then every element of `A_α(b)`
would act on `A_α(b)` by a scalar (surjectivity), so `A_α(b) ⊆ Λ · 1` by
faithfulness of the regular representation, contradicting rank two. ∎

Concretely at the cubic point: `A_α = Λ[x]/(x²)` with `x = e_0 P ≠ 0`, so the
divisor direction `φ_a = P` already gives `C'_a ≠ 0`, matching `lem:commutant`'s
`C_{a,0} = p_a I + q_a N` with `q_a ≠ 0`.

Lemma 2.1 is the whole of route 2 of the assignment, but with the opposite sign
to the one hoped for. Route 2 wanted `C'_a` to vanish on `Z`. It cannot: it
vanishes nowhere, in the sense that the family `{C'_a}_a` spans a
one-dimensional space of traceless operators at every point and never the zero
space. Repair A, in the form "`C'_a` vanishes wherever `N` does", is refuted
outright.

---

## 3. Theorem A and the resonance exception

**Theorem A.** Let `b ∈ B` with `det μ_0(b) ≠ -1/4`. Then `(D_a N)(b) ≠ 0` for
some bulk direction `a`.

*Proof.* Suppose `(D_a N)(b) = 0` for every `a`. By (2), `C'_a = -[C'_a, μ_0]`,
i.e. `ad(μ_0)(C'_a) = C'_a`, at `b`, for every `a`. By Lemma 2.1 some
`K := C'_a(b)` is nonzero, so `ad(μ_0(b))` has eigenvalue `1` on the traceless
`2×2` matrices. `μ_0` is traceless (§1), so its eigenvalues are `±m` with
`m² = -det μ_0`, and the eigenvalues of `ad(μ_0)` on `sl_2` are `0, ±2m`. Hence
`2m = ±1`, i.e. `det μ_0(b) = -1/4`. ∎

**Corollary A1.** `Z` has no interior point outside `{det μ_0 = -1/4}`: at an
interior point `N ≡ 0` on a neighbourhood, so `D_a N = ∂_a N - [T_a, N]` vanishes
there for every `a`.

Two remarks on the exception.

*It is a resonance.* `det μ_0 = -1/4` says the eigenvalues of `μ_0` are `±1/2`,
i.e. the two exponents of the block differ by exactly `1`. That is the standard
resonance condition, and its appearance here is a good sign rather than a bad
one — this is what the degeneration of a rank-two coalesced block *should* cost.

*In the exceptional case the structure is rigid too.* If `det μ_0 = -1/4` on an
open set `V ⊂ Z`, then for every `a`, `C'_a` lies in the `+1` eigenline of
`ad(μ_0)` in `sl_2`, which is spanned by a nilpotent `K` with `K² = 0`. So
`A_α = Λ ⊕ Λ K` is local (`≅ Λ[ε]/(ε²)`), the spectral point stays fat, and the
image of `E` in it is the scalar `u_0`. Concretely, in a frame where `G_0` is
antidiagonal, `μ_0 = diag(1/2, -1/2)` and `C'_a = q_a E_{12}` for all `a` (or
the transposed alternative). This is a very tight configuration, and one further
input would kill it; I did not find that input, and I do not need it, because
`{det μ_0 = -1/4}` is itself nowhere dense by §4.

**On route 1 (dimension count).** It gives the expected codimension but not the
theorem, and it is worth recording what the right count is. `N` is traceless and
`G_0`-self-adjoint, so it is a section of a rank-**two** bundle (traceless
`G_0`-self-adjoint endomorphisms of a rank-two space form a rank-two bundle),
not of a rank-three one. It additionally satisfies `det N = 0` (§4), so it takes
values in the discriminant cone of that rank-two bundle, which is the union of
the two isotropic line subbundles; on the branch selected by `im N`, `Z` is cut
out by the single equation `ν = 0`. So the expected codimension of `Z` is **one**,
not two: `Z` should be a divisor, and Corollary A1 says `N` vanishes on it to
first order. A pure dimension count therefore cannot exclude `Z` from having
interior — it only says `Z` is not expected to. The exclusion has to come from
Theorem A or from §4.

---

## 4. Theorem B: `Z` is nowhere dense, and `det N ≡ 0` globally

Both statements come from one analytic mechanism, applied to two different
functions. The mechanism is the identity principle, and the point to notice is
that the correct open-and-closed argument is about **infinite-order vanishing**,
not about vanishing. That version is unconditional — it holds for any analytic
section on any connected analytic manifold, with no differential equation
whatever — which is precisely why it escapes the circularity that killed the
argument in §3 of the route assessment.

**Analytic inputs.** (A1) `B` is a connected smooth (hence normal, hence
irreducible) non-archimedean analytic space over `Λ`, and `U`, `C_a`, `μ`, `G`,
`e_α` are analytic on it. (A2) Identity principle: on an irreducible rigid
space, an analytic subset with nonempty interior is the whole space; equivalently
a function vanishing on a nonempty admissible open vanishes identically. (A3)
Riemann extension: on a normal rigid space, a bounded analytic function on the
complement of a nowhere dense analytic subset extends analytically across it
(Bartenwerfer/Lütkebohmert). (A1) is KKPY's own framework — atoms are connected
components of an analytic spectral cover, so the base is analytic by
construction, and it is a domain in `H^even ⊗ Λ`, so smooth and connected. (A2)
follows from Conrad's theory of irreducible components of rigid spaces together
with "connected + normal ⟹ irreducible". (A3) is used only in §5.

**Theorem B(i): `det N ≡ 0` on `B`.** Let `d = det N`, an analytic function.
Fix any `b` with `d(b) = 0` — the cubic point qualifies. On the germ at `b`,
`N ≠ 0` (cubic point) so `U_0` is regular over the local ring, `lem:commutant`
applies, `C'_a = q_a N`, and the memo's `thm:no-splitting` computation gives
`∂_a d = 2 q_a d`. Its lowest-order argument then forces every homogeneous part
of `d` at `b` to vanish: `d` vanishes to infinite order at `b`, hence `d ≡ 0` on
a neighbourhood, hence `d ≡ 0` on `B` by (A2). So the block never splits its
eigenvalue anywhere on the component, `N² = 0` everywhere, and `im N = ker N` is
a line wherever `N ≠ 0`. This is the global form of `thm:no-splitting`, which the
memo needs anyway and which its formal statement does not by itself supply.

**Theorem B(ii): `Z` is nowhere dense.** `Z = {N = 0}` is a closed analytic
subset (zero locus of an analytic section of `End(H_α)`). It does not contain the
cubic point, where `N = 2 E_{12} ≠ 0`. By (A2) an analytic subset of the
irreducible `B` is either all of `B` or nowhere dense. Hence `Z` is nowhere
dense and `W = B ∖ Z` is dense open. ∎

Two independent confirmations, in case a referee disputes one input:

- *Via Theorem A.* `{det μ_0 = -1/4}` is an analytic subset not containing the
  cubic point (`det μ_0 = -361/324` there), hence nowhere dense by (A2). By
  Corollary A1, `int(Z)` is contained in it; an open set inside a nowhere dense
  set is empty; so `int(Z) = ∅`. This route never uses `N ≠ 0` at the cubic
  point — only `det μ_0 ≠ -1/4` there — and never uses `det N ≡ 0`.
- *Route 4 of the assignment.* `Z` cannot be the whole component, since the
  component is by definition the one carrying the cubic atom and `N ≠ 0` at the
  cubic point. So the fatal case is excluded for free; the only question ever
  was interior, which is Theorem A / B(ii).

**What breaks if (A1) fails.** If the base were reducible — a connected union of
two irreducible pieces meeting along a locus — then `Z` could contain one whole
piece while missing the cubic point, and it would have interior. Nothing in
Theorem B survives that, and repair B would have to be re-posed on the piece
containing the cubic point plus a separate argument for crossing the seam.
Theorem A, being pointwise, does survive: even then, `int(Z)` stays inside the
resonant locus `{det μ_0 = -1/4}`.

---

## 5. The second step: does the decoration extend across `Z`?

The assignment is right to be suspicious. The coefficients of `p(ρ)` are **not**
regular functions on `B` on the nose, because `R` is built from a frame
(`N e_1 = 0`, `N e_2 = ν e_1`) and a shear that exist only where `N ≠ 0`. But
they are bounded, and that is enough. Here is the accounting.

Choose a local analytic frame of `H_α` adapted as in Step 4 on `W`, and write the
twisted decoupled block connection as `z^{-1}N + A'_0 + z A'_1 + ⋯`. Since a
`z`-independent frame change acts on the `A'_p` by conjugation alone, traces of
products of the `A'_p` with `N` are frame independent.

**Trace.** By `eq:parity`, `A'_0` is `G_0`-anti-self-adjoint, hence traceless, so
from `eq:sheared-data`

    tr R = (A'_0)_{11} + (A'_0)_{22} - 1 = -1

identically on `W`. Constant, no extension needed. (At the cubic point this is
the memo's `tr R = -1`.)

**Determinant.** Put `α := (A'_0)_{11}`. Writing `G_0` in the Step-4 frame as
`[[0, g], [g, h]]` — the `(1,1)` entry vanishes because `im N` is isotropic —
anti-self-adjointness forces `A'_0 = [[α, αh/g], [0, -α]]`, upper triangular. So
`α` is the eigenvalue of `A'_0` on the canonical line `L = im N = ker N`,
`α² = -det A'_0`, and `(A'_0)_{21} = 0`, which is `thm:h2-automatic` read off the
same normal form. Then

    det R = α(-α - 1) - ν (A'_1)_{21} = -α² - α - tr(N A'_1),

since `N = ν E_{12}` gives `tr(N A'_1) = ν (A'_1)_{21}`. Check at the cubic
point: `α = -19/18`, `-α² - α = -19/324`; `tr(N A'_1) = 2·(-8/81) = -64/324`;
`det R = 45/324 = 5/36`. ✓ Matches `cor:cubic-closed`.

Now the regularity audit of the three pieces:

| piece | status on `B` |
|--------------------|--------------------------------------------------------|
| `tr(N A'_1)`       | analytic; `N` and `A'_1` are analytic sections, and the trace of their product is frame independent. Vanishes on `Z`. |
| `α² = -det A'_0`   | analytic; `A'_0` is analytic. |
| `α`                | **not** analytic on `B`: it is the branch of `±√(α²)` selected by `L = im N`, which is undefined on `Z`. Analytic on `W`, and *bounded* near `Z` since `α²` is. |

So `det R` is a locally constant (by `thm:rigidity` applied at each germ of `W`,
§1) and bounded function on the dense open `W`. By (A3) it extends analytically
across the nowhere dense analytic `Z`; its partial derivatives are analytic on
`B` and vanish on the dense `W`, hence vanish on `B`; hence `det R` is locally
constant on the connected `B`, hence constant, equal to `5/36`. Together with
`tr R = -1`, the decoration `p(ρ) = ρ² + ρ + 5/36` is constant on `B`, hence on
`Σ_α`, since `Σ_α → B` is finite flat surjective and `p` is pulled back from `B`.

This route deliberately does not need `W` to be connected; the extension does the
work that connectedness of `W` would otherwise have to do. (If one prefers, `W`
*is* connected, by the same extension theorem applied to a locally constant
`{0,1}`-valued function, `B` irreducible having no nontrivial analytic
idempotents. Either way (A3) is the one analytic import beyond the identity
principle, and it is the one a referee should be pointed at explicitly.)

**Correct formulation, in one sentence.** The decoration is not a regular
function on the base; it is a bounded locally constant function on the complement
of a nowhere dense analytic set, which is exactly the hypothesis of the rigid
Riemann extension theorem, and that is the form in which the statement should be
written in the memo.

**Bonus: `ν_6 = 2` at the points of `Z` too.** This is not needed for repair B —
`Z` is nowhere dense, so the atom-equivalence comparison can be made on `W` —
but it is a sharp consistency check, and it passes. At `b ∈ Z` the block
connection is `A'_0 + z A'_1 + ⋯` with no pole at all: it is regular singular
already, no shear is applied, and its exponents are the eigenvalues `±α` of
`A'_0` (which is gauge independent there, since `A'_0 → A'_0 + [N, k_1] = A'_0`
when `N = 0`). Approaching `b` from `W`, `tr(N A'_1) → 0` and `det R → 5/36`
forces `α² + α + 5/36 = 0`, i.e. `α ∈ {-1/6, -5/6}`. Either way the exponent
classes at `b` are `{α, -α} ≡ {1/6, -1/6} mod Z`, and
`e^{±2πi/6} = e^{±πi/3}` are primitive sixth roots: `ν_6(b) = 2`. Note this had
to come out right and could have failed: the `W`-side exponents are the roots
`{-1/6, -5/6}` of the sheared residue, the `Z`-side exponents are `{±α}`, and
they agree modulo `Z` only because `-5/6 ≡ 1/6`. The invariant is genuinely
continuous across the degeneration locus.

---

## 6. What a hostile referee attacks

1. **(A1), the base.** "Is the base of the A-model `F`-bundle really a connected
   smooth analytic space?" Answer: it is KKPY's own framework — atoms are
   connected components of an analytic spectral cover over it — and the base is a
   domain in `H^even ⊗ Λ`. But this should be *cited*, not assumed, and the
   convergence statement that makes the big quantum product analytic over `Λ`
   should be cited with it. This is the single most exposed point.
2. **Which cover indexes atoms.** §1, point 2 and its caveat. If atoms are
   indexed by components of the character cover in `T*B` rather than the
   `E`-eigenvalue cover in `A^1 × B`, there is a second thin locus `Y` where the
   `E`-eigenvalues of two components collide and `lem:decouple` fails. Theorems A
   and B are untouched; Theorem C and the memo's whole rigidity chain need
   `Y = ∅` or a separate treatment. **This is an open check, and it should be
   run before the memo claims the component-level statement.**
3. **Rank of the component.** The argument assumes `rank H_α = 2`, i.e. that the
   component carrying the coalesced sheet at the cubic point does not also
   contain the `±6r` sheets somewhere over the base. This is imported from KKPY
   Example 6.21, which identifies `α(X)` as an atom. If the rank were larger the
   rank-two mechanism would be about a sub-block and the globalization would have
   to be redone.
4. **Big versus small base.** Lemma 2.1 needs the bulk directions to span
   `H^even`. On a base of divisor directions only, the image of
   `H^2 → A_α` could be `Λ·I` and Lemma 2.1 fails. The memo's base is the full
   even bulk, so this is satisfied, but it is a real hypothesis and should be
   stated.
5. **(A3), Riemann extension.** Needs a citation for the rigid-analytic case with
   `Z` of codimension one and the function merely bounded. Bartenwerfer's
   Hebbarkeitssatz for normal rigid spaces is the right reference shape.
6. **The resonance exception.** Theorem A is not exception-free. If someone
   disputes (A2) they can still ask what happens on `{det μ_0 = -1/4}`. I did not
   close that case algebraically; §3 records how tight the configuration is
   (`A_α ≅ Λ[ε]/(ε²)`, all `C'_a` proportional to one nilpotent of
   `ad(μ_0)`-weight one), which is where an algebraic closure of the exception
   would start.

---

## 7. What this does and does not buy

**Buys.** Repair B closes: `Z` is nowhere dense on the component, the decoration
is constant on the dense complement by the rigidity theorem applied germwise, and
it extends across `Z` — so `char(R) = ρ² + ρ + 5/36` on the whole component, and
`ν_6 = 2` there, including at the points of `Z`. That is the statement
`thm:endpoint` assumes; with it, `sec:endpoint`'s conditionality on "`ν_6`
constant on connected components" is discharged **for the cubic atom**, which is
the only atom the endpoint theorem needs it for. Two further by-products: the
memo's `thm:no-splitting` is globalized off the formal germ, and (H1) is shown to
be automatic globally in the eigenvalue-cover formulation rather than assumed.

**Does not buy.** (a) Repair A is refuted rather than proved, so the "horizontal
section" narrative should be deleted from the assessment, not repaired.
(b) Nothing here touches the collision locus `Y` of §1/§6.2, which is a genuinely
open check of the same shape. (c) Nothing here extends to Jordan blocks of size
`m ≥ 3`; `sec:jordan-size` is unaffected. (d) The endpoint theorem still imports
strong factorization or an independent treatment of upward blowups
(`sec:unconditional`), which is a separate conditionality entirely.

**Vibe check.** Good — better than expected. The obligation turned out to have a
short pointwise proof (Lemma 2.1, three lines, from the fact that quantum
cohomology is a cyclic module over itself) plus a standard analytic globalization,
and the same pointwise proof kills the alternative repair the assessment
preferred. The exposure is not in the mathematics but in the framework citations,
items 1-3 of §6.

