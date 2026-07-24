# Memo — Paper III's principal-theorem gate: a shelved candidate and a cheap decisive test

**To:** `clebsch` lane (Paper III scoping) · **From:** `gateway` lane · **Date:** 2026-07-24
**Status:** advisory. The gateway lane owns none of the math below and allocates nothing; this is a
decision put on the clebsch/crowns desk, with the supporting map at
`notes/2026-07-24-c589-gateway-disposition-map.md`.

## The situation

Paper III (*Finite passages and holonomy in Clebsch matching geometry*) is a conditional placeholder:
it proceeds only if **one principal theorem organizes** its material, else the material returns to a
disposition inventory. The Jul 21 exploration produced a candidate for exactly that theorem — and the
current 3-paper split filed it as **inventory-only**, so Paper III is drifting toward "no organizer →
do not proceed" by default rather than by decision. This memo names the candidate and the single cheap
test that should settle its fate.

## The candidate organizer

**The information-lattice depth-functor theorem** (depth-injection D6 in
`notes/2026-07-21-clebsch-depth-injections.md`; the lattice itself is C412/C434). Claim: the
recovery-depth lattice `22 → 6 → 2 → 1` is not a one-off of the `q=11` configuration but an **instance
of a general functor** defined for every 2-transitive group of prime degree with a p-prime point
stabilizer. That family is concrete and classified; its almost-simple members are essentially
`PSL₂(11)` (degree 11), `M₁₁` (degree 11), and `M₂₃` (degree 23), plus affine cases. Because it
quantifies over an infinite classified family, exhaustion is impossible and real modular-Hecke
machinery must carry it — which is what would lift Paper III from a configuration study to a theorem,
and reach the Golay world through `M₂₃` **without any `M₁₂` overclaim**.

## The cheap decisive test (recommended highest-EV allocation)

> **Does the recovery-depth lattice cohere at the degree-23 (`M₂₃` / Golay) instance, or only at
> `PSL₂(11)` degree 11?**

The `22→6→2→1` ledger is the degree-11 instance. Build the analogous depth lattice for the degree-23
member and check whether the functor's structure (Loewy layers of the projective cover, kernel = even
part plus socle, rank drops from K-fixed points, the double-coset separation criterion) survives.

- **Coheres** → the depth-functor theorem has legs, Paper III has its principal organizer, and the
  shelved pile becomes a paper.
- **Breaks at `M₂₃`** → the organizer is a mirage (the fate the theta-parity theorem met when C451
  landed negative); Paper III correctly stays inventoried.

Either outcome is a first-class result for a bounded cost — a negative here is as valuable as a
positive, and far cheaper than drafting Paper III on an unverified organizer.

## Supporting cast, if the test coheres

Recommended Paper III spine around the organizer (all clebsch/crowns-owned, all currently shelved):

- **Backbone:** the all-q **converse classification** (derive the `A₃/B₃/H₃` trichotomy instead of
  inheriting it; D1) plus the **char-p memory filtration** (harmonic image + signed-moment filtration
  as `SL₂(F_q)`-modules, all q and all degrees; D2).
- **Analytic arm:** the **all-q deep-hole curve-counting** classification (Weil–Serre past an explicit
  bound; "why 11" proved analytically; D4) — the map's safest, lowest-conceptual-risk item.
- **Standalone gem, not a gate:** **cubic-moment rigidity** (full stabilizer of the cubic-moment line
  in `PGL(W)`; fills C406's open disclaimer; D3) — too tail-risky to gate a paper on.
- **Unifying narrative (the one piece not clebsch-owned):** the gateway **cross-avatar
  sporadic-vs-uniform axis** — incidence/module rigidity is field-sporadic, the quantum AME / LU=LC
  avatar (`ame-lu`) is field-uniform — which lifts Paper III from clebsch-internal to a genuine
  incidence/module/entanglement synthesis.

## Guardrails

- **Dead — do not rescue:** the theta-parity theorem (gate task C451 landed clean-negative) and the
  Weil-roof conjecture (C450 sharp-negative, C455 scoped survival; its citations are unverified model
  memory). The grand single-theta/metaplectic synthesis remains NO-GO.
- The `q=11` three-classification confluence + `q=19` tower divergence is a **framing** with a live red
  team ("n=2 in a three-point costume", Paley deflation) — reception armor, not a theorem statement.
- Every candidate is an **unpromoted notebook spike**; promote through the ledger + certificate
  discipline before any manuscript use. Jul 21 citations are unverified model memory.

## What is requested

A clebsch/crowns decision: allocate the degree-23 coherence test as the go/no-go on Paper III's
principal-theorem gate. If it coheres, adopt the spine above; if not, Paper III stays inventoried and
the cross-avatar narrative can still ride as a shared program-identity paragraph across Papers I–III,
`ame-lu`, and `beyond4`.
