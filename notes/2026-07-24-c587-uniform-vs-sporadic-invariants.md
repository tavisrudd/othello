# C587 — Which transported invariants are field-uniform vs field-sporadic

**Lane:** `gateway` · **Date:** 2026-07-24 · **Depends on:** C586 (mechanism per avatar)
**Evidence level:** REASONED for the framing and the three instance-checks; **OPEN** for the general
biconditional as a proved theorem.

Read-only task except for this file. No source paper reopened; inputs are the distilled facts in
`notes/handoffs/2026-07-24-gateway.md` and `-archive.md`.

---

## 0. The problem, and the trap to avoid

We want one statement that predicts, for an algebraic invariant transported across the avatars of the
icosahedral six-arc / `[6,3,4]` MDS code, whether its rigidity is **field-uniform** (holds for all
prime powers) or **field-sporadic** (pinned to a finite exceptional set of `q`).

The naive axis — *incidence invariants are sporadic, representation invariants are uniform* — is
**false**. The modular-carrier avatar (C474) is purely representation-theoretic (perfect codes,
endotrivial modules, `stmod(kG)`, `PSL_2(q)`) yet is sporadic: proved only at `q=7` (`F_2` Hamming)
and `q=11` (`F_3` Golay), with `q=23` a boundary. Any correct axis must therefore **cut across** the
incidence/representation divide and place the deep-hole avatar and the modular avatar on the same
(sporadic) side, with the quantum LU/LC avatar alone on the uniform side.

The claim below is that the correct axis is **flat vs coincidental**, not incidence vs
representation. Representation theory has its own coincidences; being representation-theoretic is
orthogonal to being flat.

---

## 1. Candidate general statement

### 1.1 Set-up

Let the *family* be the collection of linear `[6,3,4]_q` MDS codes as `q` ranges over prime powers in
its existence range. For each avatar, a **transport functor** `F` (deep-hole/uncovered-locus map;
cross-incidence → perfect-code → endotrivial-carrier map; MDS-shortening → `q²` stabilizer → CSS
state map) carries the family to that avatar's category.

Call a piece of the output of `F` **flat data** if its isomorphism type is *locally constant on the
arithmetic base* — i.e. the same abstract object (up to the transport's own equivalences) for all `q`
in a cofinite set. The flat data of the three transports are:

- the **MDS matroid** of `[6,3,4]` (uniform matroid `U_{3,6}`; identical for all `q ≥ 5`);
- the **abstract stabilizer / Weyl group with its commutation relations** (Weyl–Heisenberg relations
  hold over every `F_q`; MDS-shortening produces a `q²` stabilizer whose correlation tensor is
  diagonal on the local Weyl basis by relations, not by counts);
- the **abstract endotrivial-module type** (the isomorphism class of the simple stable Lagrangian
  `S` in `stmod(kG)` as an abstract brick), *before* it is required to sit inside a specific perfect
  code or a degree-`q` geometric sheet.

By contrast, an arithmetic quantity is **coincidental** if it is a *non-constant* function of `q`
naturally produced by the transport — a cardinality of the object, a bound-saturation slack, a
subgroup index — evaluated against `q`.

### 1.2 The statement

> **Candidate (C587).** A transported invariant `P` of the gateway object is
>
> - **field-uniform** — true for all but finitely many small `q` in the existence range (cofinite)
>   — **iff** `P` is entailed by the flat data alone: `P` is a structural/first-order consequence of
>   the generic fiber (matroid + commutation relations + abstract module type), requiring no equation
>   between a cardinality of the object and an arithmetic function of `q`;
>
> - **field-sporadic** — true only on a finite set of `q` — **iff** the truth of `P` is equivalent to
>   the vanishing of a non-constant arithmetic **obstruction** `Φ_P(q)` that is naturally produced by
>   the transport (a chord/secant defect factorization; a sphere-packing / perfect-code saturation; an
>   exceptional-subgroup index), and `Φ_P` is *not* entailed by the flat data.
>
> **Mechanism (the content, not the labels).** Uniform = *generic-fiber* property: it spreads out
> from the generic fiber to a cofinite set of special fibers, so its failure locus is a proper closed
> (finite) condition it never meets. Sporadic = *special-fiber / extremality* property: it asks the
> object to be **extremal for the ambient field** (saturate a packing/secant/covering bound, or hit a
> coincidence in the subgroup lattice), which is a Diophantine condition on `q` with finitely many
> solutions.

One-line form: **uniform ⟺ factors through the flat (generic) part of the transport; sporadic ⟺
detects a special `q` where the gateway object becomes extremal for its field.** The axis is
extremal-vs-generic, and it is orthogonal to incidence-vs-representation.

A structural consequence worth stating up front: **uniform/sporadic is a property of the invariant,
not of the avatar.** A single avatar can host both (see §2.3, the quantum avatar).

---

## 2. Check against the three avatars

### 2.1 Deep-hole locus — SPORADIC (coincidence in the *incidence* fiber)

Invariant `P`: "the uncovered locus `U(A)` fills a nonsingular conic ⟺ `A` is Clebsch ⟺
`Stab ⊇ A_5`."

Obstruction produced by the transport: the chord-defect identity `|U(A)| = q² − 14q + 55 − c(A)` with
`0 ≤ c ≤ 15` forces `c = (q−6)(q−9)`, and the family off-conic excess `(q−4)(q−11)` (for
`q ≡ 3 (mod 4)`) must vanish. So

  `Φ_deep(q) = (q−4)(q−11)` (with the window constraint `(q−6)(q−9) ≤ 15`).

`Φ_deep` is a non-constant polynomial → finite zero locus → sporadic; the window + Sylvester-graph
exclusion isolates `q=11` at `k=6`. This is the **coincidence part of incidence geometry**: the arc
is asked to be *extremal*, its uncovered locus maximal-and-conic (saturating Dye's Brianchon bound
`c ≤ 10`). ✔ Matches the statement: truth ⟺ `Φ_deep(q)=0` in the window; not entailed by `U_{3,6}`.

### 2.2 Modular carrier — SPORADIC *despite* being representation-theoretic (this is the crux)

Invariant `P`: the seven-gate chain `cross-design → perfect code → endotrivial core → unique
nonsplit carrier`, realized as a **degree-`q` geometric sheet**.

Why representation-theoretic ≠ flat. The transport here does **not** ride the flat module type. It
requires two *extremal* coincidences within representation/group theory:

1. **A perfect code saturating the sphere-packing bound** — binary Hamming `[7,4,3]` at `q=7`,
   ternary Golay `[11,6,5]` at `q=11`, binary Golay at the `q=23` boundary. "Perfect" is *by
   definition* equality in the Hamming bound: a Diophantine coincidence governed by Lloyd's theorem /
   van Lint–Tietäväinen (the only perfect codes are Hamming, Golay, trivial). This is an
   extremal/bound-saturating condition, i.e. a `Φ = 0`, not a generic-module property.
2. **An index-`q` subgroup of `PSL_2(q)`** so the degree-`q` permutation sheet exists. Exceptional
   low-index subgroups of `PSL_2(q)` (the `A_5, S_4, A_4` coincidences) exist only at small
   exceptional `q`; `PSL_2(23)` has **no** index-23 subgroup.

So `Φ_mod(q)` is a **conjunction** of two non-constant coincidence factors: a perfect-code slack and a
subgroup-index existence. Both are coincidences *inside* representation theory, not generic features
of it. That is precisely why the avatar is sporadic while being representation-theoretic — the
representation theory it uses is the *extremal, saturating* kind, not the flat `stmod` structure.

The `q=23` boundary is the **discriminating diagnostic** — it is what pushes this from a re-labelling
to an explanation. At `q=23` the *first* factor still holds (the binary-Golay endotrivial carrier
exists) but the *second* fails (no index-23 subgroup), so the geometric-sheet part of `P` dies while
the pure-carrier part survives. This does two things: (i) it confirms `Φ_mod` is a genuine conjunction
with a separable subgroup-index factor, exactly as the statement predicts; (ii) it refines the
invariant — the **abstract endotrivial carrier alone** is a candidate *more-uniform* sub-invariant
(flat module type), while the **geometric realization** is the sporadic part carrying `Φ_mod`. ✔

**Caveat (weakest instance).** The perfect-code factor alone is *not* sporadic: `q`-ary Hamming codes
exist for all prime powers. Sporadicity of the modular avatar comes only from the **conjunction**
(the specific extremal perfect codes that are *also* cross-codes with a simple endotrivial core *and*
a degree-`q` sheet). Pinning the exact `Φ_mod` — and deciding whether it coincides with `Φ_deep` or is
an independent coincidence overlapping at small `q` — is C585/C586 work, not settled here. Flagged in
§3.

### 2.3 Quantum AME / LU — UNIFORM, and a within-avatar sporadic companion

Uniform invariant `P`: "LU-equivalence = LC-equivalence for the equal-phase CSS state of every
`[6,3,4]_q`." Proof rides only flat data: any `[6,3,4]_q` is MDS (matroid `U_{3,6}`, all `q`);
MDS-shortening preserves MDS; the resulting `q²` stabilizer's correlation tensor is diagonal on the
full local Weyl basis by the **commutation relations**, forcing every local action to permute Weyl
axes (Clifford). No cardinality is compared to a special value; no bound is saturated; no exceptional
subgroup is invoked. Hence cofinite/uniform. ✔ Matches: `P` entailed by flat data, `Φ_P` absent.

**Same avatar, sporadic companion (a confirmation, not a falsifier).** The *existence of a non-GRS
member separated from all GRS members* (the `H_3`/Clebsch state, C374) is `q=11`-special: generic
`[6,3,4]_q` is GRS; the icosahedral non-GRS code is a coincidence. So the quantum avatar hosts a
uniform invariant (LU=LC, flat) beside a sporadic one (existence of the exceptional separated member,
a coincidence). This is exactly what the per-invariant framing predicts, and it is the sharpest
evidence that the axis is *not* per-avatar. ✔

**Boundary note.** "Uniform" here means *cofinite*: `[6,3,4]_q` needs `q` past a small floor
(size-6 arc in `PG(2,q)`; `q=4` gives the hyperoval, small-`q`/bad-characteristic edge cases). A
finite set of *excluded* small `q` is a floor, not sporadicity; sporadicity is a finite set of
*included* `q`. The real dichotomy is **cofinite (uniform) vs finite (sporadic)**, which absorbs the
MDS floor cleanly.

---

## 3. Falsifiers and where the candidate is hand-waving

**F1 — Tautology risk (the main weakness).** Any finite exceptional set `E` is the zero locus of
*some* indicator function, so "sporadic ⟺ `Φ_P(q)=0`" is vacuous unless `Φ_P` is required to be
**transport-natural and exhibited independently of `E`**: a defect polynomial, a bound slack, a
subgroup index that the *mechanism* produces before the exceptional set is known, and which then
*predicts* `E`. The three checks satisfy this (chord-defect polynomial; sphere-packing bound;
subgroup index — each derived from structure, each predicting its `q`-set). The statement is only as
strong as this naturality clause; without it, it is a re-description. **This is the primary place the
candidate could be dismissed as framing.**

**F2 — "Flat entailment exists" is not observable.** The uniform side is phrased as "`P` is entailed
by flat data." A uniform *truth* whose only known proof uses a coincidence would not falsify the
truth-set (cofinite) but would falsify the *mechanism* claim. Existence of a flat proof is not
decidable, so the biconditional's uniform direction is a statement about proof-theoretic entailment we
cannot in general verify — it must be read as a conjecture, not a checkable criterion.

**F3 — Mid-range uniform exception.** A genuinely structural invariant that nonetheless fails at one
*interior* `q` for a non-arithmetic reason (e.g. an isolated small-characteristic degeneration not at
the floor) would blur cofinite-vs-finite and directly challenge "flat ⇒ cofinite." No such case is
known here, but bad-characteristic behaviour of the CSS/stabilizer transport in char 2, 3 is the place
to look. Not yet audited.

**F4 — Modular `Φ` not pinned (§2.2 caveat).** If C585 finds that `beyond4`'s `r=5` sporadic orbits
`{7,8,9,11,13,17,19}` *do* carry the C474 perfect-code/endotrivial structure, then `Φ_deep` and
`Φ_mod` are one coincidence and sub-question Q1 (single defect identity) is supported; if they do
*not*, they are independent coincidences overlapping at small `q`. The framing survives either way,
but "one defect identity across avatars" (handoff Q1) stands or falls here, and the exact `Φ_mod` is
currently a description, not a formula.

**F5 — The perfect-code factor is not itself sporadic.** As noted, Hamming codes exist for all `q`;
only the conjunction with the subgroup-index / cross-design / endotrivial requirements is sporadic.
Any statement of the form "extremal/perfect ⇒ sporadic" must carry the conjunction, or it is false.

**F6 — Scope of "arithmetic function."** "Non-constant arithmetic function of `q`" must be pinned to a
class closed under the transports (polynomials in `q`; `q`-ary bound slacks; indices of subgroups in
a `q`-parametrized group scheme). Left as an unrestricted class, the criterion is again vacuous.

---

## 4. What a proof would require; theorem, conjecture, or framing?

**Verdict: a FRAMING with a precise conjectural core, backed by three instance-theorems.** Not a
single proved theorem; more than a slogan.

- The **sporadic side, per instance, is essentially proved**: each `Φ` is non-constant and each has a
  real finiteness theorem behind it — polynomial finiteness for `Φ_deep`; Lloyd / van Lint–Tietäväinen
  for perfect-code saturation and CFSG-level classification of exceptional `PSL_2(q)` subgroups for
  `Φ_mod`. The `q`-sets `{11}`, `{7,11}`+boundary`{23}` are established in the source lanes.

- The **uniform side, per instance, is proved** (LU=LC over all prime powers, C560/C561), and its
  proof visibly uses only flat data.

- The **general biconditional is OPEN**, because "factors through the flat data / is entailed by the
  generic fiber" is not yet a truth-evaluable predicate. A proof would require:

  1. a formal **transport 2-category** and a **flat fiber functor** — the `[6,3,4]` family as a scheme
     over an arithmetic base (its parameter space / Hilbert scheme over `Spec Z`), with the matroid,
     the stabilizer group scheme, and the endotrivial-module type as the locally constant data;
  2. a **spreading-out / constructibility theorem**: an invariant that is a section of a locally
     constant (or constructible) sheaf on the base, positively entailed by the generic fiber, holds on
     a cofinite set of special fibers — the arithmetic-geometry "generic vs special fiber" dichotomy,
     with the model-theoretic uniformity for pseudofinite fields (Ax–Kochen–Ershov / Chatzidakis–van
     den Dries–Macintyre) supplying "first-order in the flat structure ⇒ cofinite-or-finite";
  3. for the sporadic side, a theorem that an invariant **not** entailed by the flat theory but
     equivalent to a numerical coincidence has finite truth locus — i.e. its defining condition is a
     genuine cardinality equation (a `Σ`-condition on the special fiber), and non-constant such
     equations have finitely many `q`-solutions.

The deep (Tao-style) reason the dichotomy should exist: **uniform invariants are first-order in the
flat structure**, so pseudofinite-field uniformity forces cofinite-or-finite, and positive entailment
forces *cofinite*; **sporadic invariants require a cardinality coincidence not expressible in the flat
theory alone**, which is a Diophantine side-condition with finite solution set. The general theorem is
"generic flatness for the gateway family + first-order transfer" — plausible, unproved, and the
correct target for C589's paper-or-not decision.

---

## 5. One-paragraph summary for the lane

The correct axis separating the two sporadic avatars (deep-hole, modular) from the uniform one
(quantum LU/LC) is **flat vs coincidental / generic vs extremal**, *not* incidence vs representation.
A transported invariant is field-uniform iff it factors through the flat, locally-constant data of the
transport (the `U_{3,6}` matroid, the Weyl commutation relations, the abstract endotrivial type),
which spreads from the generic fiber to a cofinite set of `q`; it is field-sporadic iff its truth is
equivalent to the vanishing of a non-constant, transport-natural arithmetic obstruction `Φ(q)` — a
secant/chord-defect factorization, a perfect-code / sphere-packing saturation, an exceptional-subgroup
index — i.e. iff it asks the gateway object to be **extremal for its ambient field**. The modular
avatar is sporadic *despite* being representation-theoretic because it rides representation theory's
*own* coincidences (extremal perfect codes; exceptional low-index `PSL_2(q)` subgroups), not the flat
module structure — the `q=23` boundary, where the carrier survives but the subgroup index fails, is
the diagnostic that proves the point. The statement is a REASONED framing with a conjectural core;
proving it needs a formal transport category plus a generic-flatness / first-order-transfer theorem.

## Mystery ledger

- **Is `Φ_deep = Φ_mod` or independent overlap?** Open; owned by C585. Settling it decides handoff
  sub-question Q1 (single defect identity across avatars). The C587 framing is robust to either
  outcome; the "one identity" claim is not.
- **Why do the sporadic `q`-sets cluster at `{7,11,19}` (biplane/self-duality sequence)?** Surprising
  concentration; the framing explains *that* each avatar is sporadic but not *why the coincidence sets
  overlap*. Candidate: all three `Φ`'s are governed by low-index `PSL_2(q)` / small-biplane arithmetic.
  Evidence gap: no shared `Φ` exhibited. Owner: C586/C585.
- **Overly clean quantum uniformity.** LU=LC holds at *every* prime power with the same proof — no
  bad-characteristic exception surfaced. Unexplained why char 2, 3 CSS degeneration does not intrude
  (F3). Settled only by an explicit small-characteristic audit; currently assumed, not checked.
- No genuine mystery remains in the *axis choice itself*: the `q=23` boundary and the within-avatar
  non-GRS-existence case together fix flat-vs-coincidental over incidence-vs-representation. The open
  items above are about the shared mechanism across the sporadic sets, not the C587 dichotomy.
