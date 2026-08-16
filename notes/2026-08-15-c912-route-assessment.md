# Routes to an unconditional `m = 1` theorem — assessment

**Date:** 2026-08-15 · **Lane:** `cubic-threefolds` · **Task:** C912

**Purpose.** Record the five routes proposed in external review (Sol,
2026-08-15), with their ranking, and check the one new mathematical observation
that the ranking turns on. That observation has a gap; a repair is proposed.

Companions: `2026-08-15-c912-h47h-red-team-and-defense.md`,
`2026-08-15-c912-normalization-statement.md`,
`2026-08-15-c912-frame-transport-memo.tex`.

---

## 1. The proposed ranking

1. **Sheared-residue decoration of the cubic atom.** Replace `ν_6` by the
   characteristic polynomial of the intrinsically sheared residue, and use
   Katzarkov–Kontsevich–Pantev–Yu's existing atom ledger rather than proving
   anything about framed monodromy in general.
2. **Relative good formal structure**, in place of the bulk gauge.
3. **A finite packet polynomial** tracked through the operation formulas,
   staying inside the manuscript's weak-factorization architecture.
4. **Categorical**, via non-representability of the cubic threefold's Kuznetsov
   component by surfaces.
5. **Classical Hodge**, retaining the Lefschetz placement and its integral
   polarization rather than the intermediate Jacobian alone.

Routes 4 and 5 are ranked last by their proposer and I agree. Route 4 needs a
nonrepresentability theorem nobody appears to have proved, and the cubic's
Kuznetsov component behaves in many respects like a noncommutative surface, so
ordinary invariants will not separate it. Route 5 is pessimistic for a concrete
reason worth recording: a surface centre in a fourfold factorization can carry
exactly the abelian variety one would want to exclude, since the cubic's own
Fano surface has Albanese equal to its intermediate Jacobian.

## 2. Why route 1 is the right first try

It avoids Hypothesis 4.7H, divisor tagging, specialized centre monodromy, the
pro-Laurent receiver, and weak-factorization transport of `ν_6` — all four of
the places the current program is stuck. It does so by asking for much less: not
that framed monodromy be constant for every atom, but only that one decoration
of one atom be constant on a connected spectral component.

Three technical items are named as the whole cost: repair the pairing-compatible
spectral splitter; formulate the shear coordinate-free as the elementary
modification attached to the canonical line `L = ker N = im N`; and prove the
decoration descends through connected-component equivalence.

**The first is already done.** The isometry lemma was repaired on exactly the
suggested route — split first, then correct the transported pairing by a
block-diagonal formal square root — and independently verified, along with the
whole rank-two chain and the cubic block recomputed from scratch. See
`2026-08-15-c912-frame-transport-memo.tex`, `lem:duality-gauge`, and
`2026-08-15-c912-gauge-normalization-verification.md`.

The second is a presentational improvement and is clearly available: for a
rank-two coalesced block with `N² = 0` and `N ≠ 0`, the line `ker N = im N` is
canonical, and in a local cyclic basis the elementary modification along it is
the memo's `diag(1, z)`.

The third is where the new observation enters, and where the difficulty is.

## 3. The new observation, and why it does not yet close the gap

**The claim.** The memo's block evolution gives, on the zero block,

    D_a N = q_a N + q_a [N, μ_0],

which is *homogeneous linear in `N`*. So `N` is a horizontal section of a
modified linear connection; if it vanished at one point, uniqueness for linear
ODEs would force it to vanish on a neighbourhood, so its zero locus is open and
closed; it is nonzero at the cubic point; hence on a connected component it never
vanishes. That would remove precisely the degeneration-to-zero obstruction the
memo leaves open when trying to globalize its rank-two section.

**The gap.** The homogeneous form is available only where `N ≠ 0`, which makes
the inference circular at the one locus it needs to control.

Unwinding: `thm:block-evolution` gives `D_a U_0 = C_{a,0} + [C_{a,0}, μ_0]`
unconditionally, and taking traceless parts gives, with `C'_a` the traceless part
of `C_{a,0}`,

    D_a N = C'_a + [C'_a, μ_0],          (*)

which holds everywhere and is **not** homogeneous in `N`. The passage from `(*)`
to the displayed homogeneous equation is the commutant step: `[U, C_a] = 0` gives
`[N, C'_a] = 0`, and for a **regular** `2×2` matrix the commutant is free on `I`
and the matrix itself, whence `C'_a = q_a N`. Regularity of `U_0` is exactly the
condition `N ≠ 0`. At a point where `N = 0`, the relation `[N, C'_a] = 0` is
vacuous, `C'_a` is unconstrained, and `D_a N` need not vanish. So the linear ODE
whose uniqueness theorem is being invoked exists only on the locus where the
conclusion is already true.

This is not a quibble about rigour: the memo had independently identified this
same locus as the obstruction, recording that what its flatness route needs is
its hypotheses "at every point of the component, including the locus where the
nilpotent part degenerates to zero".

**Proposed repair A — show `q_a` extends.** On the open locus `U = {N ≠ 0}` we
have `C'_a = q_a N`. If `N → 0` at `p ∈ ∂U` while `C'_a(p) ≠ 0`, then `q_a` blows
up. So if `q_a` is regular across the degeneration locus — equivalently if
`C'_a` vanishes wherever `N` does — then `D_a N(p) = 0` by `(*)`, the ODE becomes
homogeneous at `p` after all, and the original argument runs. Whether `q_a`
extends is a concrete question about the quantum product, and it is the form in
which I would pose the problem.

**Proposed repair B — do not prove the locus is empty; prove it is thin.** What
route 1 actually needs is that the decoration `p_α(ρ) = det(ρ - R)` is constant
on the connected component, not that `N` is nowhere zero. If the degeneration
locus `Z` is a proper closed analytic subset, then `p_α` is constant on the dense
open complement by the rigidity theorem, and its coefficients are regular, so
constancy extends across `Z` by continuity. This is weaker than repair A, likely
easier, and sufficient. The residual obligation becomes: `Z` is nowhere dense on
the component carrying the cubic atom.

Repair B looks like the better target. It converts a statement about the
existence of a horizontal section into a statement about the codimension of a
degeneracy locus, which is the kind of thing that can be settled by a dimension
count.

## 3b. Outcome of repair B, after attack

Worked in `2026-08-15-c912-degeneration-locus.md` (verdict PROVED) and attacked in
`2026-08-15-c912-degeneration-locus-hostile-referee.md` (verdict MAJOR REVISION,
**no false step found**). Net: the mechanism is correct and cheaper than first
written; the unconditional verdict is not supported. Repair A is dead.

**What survives, and may be cited.**

- The central lemma. Quantum cohomology is a commutative algebra with a cyclic
  vector, so its commutant gives the ideal property for free — no atom formalism
  needed. A rank-two summand is a rank-two unital commutative algebra, which
  cannot act on itself by scalars, whether it is local (`k[ε]/ε²`, with `ε`
  non-scalar) or split (`k × k`, with an idempotent non-scalar). Hence the
  traceless part `C'_a` is nonzero at every point, including on `Z`. Spanning by
  even classes holds.
- `D_a N ≠ 0` really does give `Z` no interior: at a zero of a section the
  covariant and ordinary derivatives coincide, so the step is clean. This was the
  place I expected trouble, by analogy with the circular argument of §3, and there
  is none.
- Riemann extension applies, with boundedness genuinely proved rather than
  assumed.
- **Repair A is refuted, not merely unproved.** Since `C'_a` never vanishes, the
  coefficient `q_a` genuinely blows up at `Z` and `N` is not a horizontal section
  of anything. The horizontal-section narrative should be deleted from the
  program, not repaired.
- Independent recomputation from the cubic's small quantum cohomology confirms
  `det μ_0 = -361/324`, and finds `ν_6 = 2` on **both** isotropic branches at `Z`
  — stronger than the one-branch check the original report ran.

**What does not survive, and blocks an unconditional claim.**

- **(A1), an analyticity hypothesis, load-bearing.** The argument needs the base
  to be a connected analytic space with analytic structure operators, which means
  non-archimedean convergence of the big quantum product. This is a genuine
  mathematical input, not bookkeeping. Without it the conclusion degrades to the
  containment `int(Z) ⊆ {det μ_0 = -1/4}` and nothing more.
- **Rank-two-ness of the component is unsupported, and the report is internally
  inconsistent about it**: one section derives the rank-two hypothesis for free
  from disjointness of cover components, while another imports it from the
  literature. It cannot have both, and which one is intended changes what must be
  cited.
- **Small versus big.** The central lemma as used needs the **big** even bulk.
  The manuscript and the memo's rigidity section work with the **small** even
  quantum connection. That mismatch has to be resolved before anything is
  transplanted; it is the first thing to check, not the last.
- **The decoration is choice-dependent on `Z` itself** — `ρ² + ρ + 5/36` against
  `ρ² + ρ − 7/36` — so the constancy statement must be restated as constancy on
  the complement plus continuation across `Z`, rather than as a value assigned at
  every point.
- The two arguments offered for nowhere-density are not independent: both route
  through the identity principle, and given it the conclusion is a two-line
  triviality that needs neither of the report's headline results.

**Status.** Repair B is *conditionally* established: granted (A1) and rank-two-ness,
the degeneration locus is nowhere dense and the decoration continues across it.
Nothing is folded into the memo yet. Next obligations, in order: resolve
small-versus-big; settle (A1), which is the real mathematical content; and fix the
rank-two provenance.

## 3c. Route 1 executed: the rank-two atomic residue proof

Transcribed verbatim in `2026-08-15-c912-atom-residue-proof.tex` and verified
independently in `2026-08-15-c912-atom-residue-proof-verification.md`
(**MAJOR REVISION; no fatal flaw**). This supersedes repair B: the argument
never needs the degeneration locus to be thin.

**The mechanism.** The Poincaré pairing forces the connection's constant term to
preserve the canonical line `L = im N = ker N`. That single fact makes the
elementary modification of the lattice along `L` produce a *regular* connection
rather than a polar one, and it is obtained without any pairing-preserving
splitting gauge — so the lemma that consumed most of this lane's effort is
bypassed rather than repaired. Flatness then kills the base-direction pole and
gives `δR = [G_δ, R]`, freezing the residue's characteristic polynomial. Finite
dimensional isomonodromy, no bulk gauge anywhere. The crossing points where `N`
degenerates are handled by meromorphic continuation on an integral component
rather than by proving they do not occur.

**Verified.** The convention check passes cleanly: both the cubic and the curve
reduce to the same normal form with the same grading operator, both taken from
Cai in one convention. The verifier supplies an independent witness worth
recording — `tr R_X = tr R_C = -1`, so only the *determinant* discriminates the
two atoms, and mismatched conventions would not have matched in trace. The cubic
block reduction was recomputed from scratch with exact agreement, and its
eigenvalues independently reproduce the manuscript's indicial exponents. Steps
(7)–(11), (18)–(28), the crossing-point argument, the Chern and Betti count, the
curve residue, the surface exclusion, and the `d = 4` application of the numbered
non-rationality criterion all survive.

**The Poincaré pairing is not the deferred object** — what
Katzarkov–Kontsevich–Pantev–Yu defer is the Euler-pairing comparison and the
Serre automorphism, while their non-archimedean `F`-bundle already carries the
Poincaré Gram matrix as a constant analytic section. But they state horizontality
only after assuming convergence and passing to the complex-analytic bundle, so
step 1 is **our own lemma to prove**, not an import. It is routine over the
Novikov ring; it must be written.

**Where "unconditional" overstates it.** The parity ranks `(2, 10)`, which drive
the genus-five forcing and the surface exclusion, rest on the assertion in the
source's Example 6.21 that the zero-eigenvalue packet does not split further at
the relevant point. Its cited support has no proof and covers only a restricted
case. So the theorem does not become unconditional; it trades **our** Hypothesis
4.7H for an **unproved assertion in someone else's preprint**. That is a real
improvement in kind — the remaining gap is a finite, checkable splitting
statement about one packet rather than an invariance statement about arbitrary
centres — but it should not be described as an unconditional proof.

**Owed before it could be used.** The horizontality lemma above; that the even
part is a sub-`F`-bundle; uniqueness and gluing of the spectral splitting; the
identity principle on irreducible `k`-analytic spaces; and descent through the
blowup, projective-bundle and disjoint-union equivalences, not only the two in
the source's definition.

## 4. Route 2, and why it is worth keeping second

The philosophical statement Hypothesis 4.7H wants is in the literature: for a
meromorphic flat bundle with good formal structure along a divisor, the
characteristic polynomial of the formal monodromy of the regular part is constant
along each connected component of the smooth divisor. If the big even quantum
`F`-bundle, restricted to the reconstruction germ, has a sufficiently uniform
relative good formal structure along `z = 0`, the hypothesis should follow with
no pro-Laurent gauge constructed at all — the gauge `M = 1 + O(z^{-1})` being
merely evidence that the family is integrable.

The obstacle is coalescence: off-the-shelf statements do not cover a
nonsemisimple leading block over a non-archimedean Novikov base, and the
available coalescence results assume a diagonalizable leading matrix, which fails
here. But the memo's rank-two shearing argument is close to a hand proof of
"good formal structure with constant formal residue" in exactly the offending
coalesced case. The hybrid to aim at is therefore: **rank-two coalescence lemma,
plus a standard good-formal-structure theorem away from the coalescence locus.**
That could prove more than the cubic theorem — possibly the relevant part of the
hypothesis itself. Kedlaya's version of the theory is the one to look at, since
it extends to formal and non-archimedean analytic spaces and so is closer to the
Novikov setting than complex-analytic isomonodromy.

Note that repair B of §3 and the "away from the coalescence locus" clause here
are the same kind of statement. That is a reason to pursue routes 1 and 2
together rather than in series.

## 5. Route 3 as the conservative fallback

Track a finite packet — the rank-two regular Jordan block together with its
indicial polynomial — rather than `ν_6`, through the existing operation formulas.
The relevant information is genuinely finite: only the jet `J_0 + zD_0 + z²E_0`
enters the sheared residue, and nothing beyond it affects the indicial
polynomial. One would then prove that an ambient cubic packet persists under the
reconstruction displacement, that low-dimensional centre summands cannot contain
such a packet, and that the regular comparison isomorphism identifies the packet
on both sides. This asks much less than the full additive ledger for arbitrary
targets, and it integrates into the current manuscript without importing the atom
formalism.

## 6. Recommendation

Pursue route 1, with repair B as the concrete next obligation, and read route 2
in parallel for the coalescence-locus statement they share. Keep route 3 as the
fallback that needs no new formalism. Leave the headline theorem conditional
until one of them closes.
