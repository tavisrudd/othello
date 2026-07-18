# Dihedral discovery track

**Lane:** `dihedral`
**Started:** 2026-07-18

Append-only companion for incidental observations and musings encountered while pursuing the
dihedral Schreier Node-Kayles paper. Planned C-task results belong in their task reports and the
live handoff, not here. Entries follow `notes/discovery-track-conventions.md`.

### 2026-07-18 — the mirror lemma is a general Cayley Node-Kayles zero-criterion

**Provenance:** C289 (`notes/2026-07-17-c289-a5-triple-split.md`, Lemma 3), found while explaining
the `A₅ (3,5,5)` split.
**Was I looking for this?:** no — the task was to explain why nonregular templates separate the
`ρ` classes; the lemma emerged as the proof device for one direction.
**Observed / musing:** for any finite group `G` and involution generating set `T`, an involution
`w ∈ G \ T` with `wTw⁻¹ = T` makes left-multiplication a free non-adjacent pairing, forcing
Node-Kayles value 0 on `Cay(G,T)`. Nothing is polyhedral-specific: it applies to arbitrary groups,
arbitrary involution generating sets, and (with the same proof) to any `L_w`-invariant induced
subgraph. Within the paper it proved six regular zeros; its reach beyond the paper is untested.
**Why it may matter / strongest question:** could organize zeros across the whole Schreier/Cayley
game program — e.g. the C84 `[cap]` escape residuals, C291 strategy extraction (the mirror IS the
strategy/certificate), and the dormant kayles lane. Strongest question: for which families is the
converse usable — when does absence of a normalizing involution certify a nonzero value, given the
one known counterexample pattern (`ρ=3`, value 0 with no color-group mirror)?
**Evidence:** CHECKED (proved in C289; exhaustive mirror search over all 10 polyhedral classes).
**Status:** open lead

### 2026-07-18 — the `ρ=3` regular zero has no symmetry explanation

**Provenance:** C289 §4.1, exhaustive pairing search.
**Was I looking for this?:** no — the search was run to prove the `ρ=5` zero; the `ρ=3` outcome
was the surprise remainder.
**Observed / musing:** the `ρ=3` `A₅ (3,5,5)` Cayley graph has Node-Kayles value 0 but admits no
free non-adjacent involution in its order-120 color-respecting automorphism group; whether one
exists in the full color-forgetting automorphism group is undetermined. Same situation for
`S₄ (2,3,4)`. These are the only two polyhedral zeros without a mirror proof.
**Why it may matter / strongest question:** either a larger-symmetry pairing exists (compute the
full automorphism group; 60 vertices is nothing) or these zeros need a genuinely different
mechanism — which would sharpen what a "strategy certificate" must look like in C291. Cheap first
probe: nauty/hand computation of `Aut` of the two graphs and a pairing search there.
**Evidence:** CHECKED (negative, exhaustive) on the color group; OPEN beyond it.
**Status:** open lead

### 2026-07-18 — `ρ` is the Petrie invariant; the split is a hypermap phenomenon

**Provenance:** C289 §3 terminological remark.
**Was I looking for this?:** no — surfaced while naming the structural interpretation.
**Observed / musing:** a generating involution triple presents `G` as a quotient of an extended
triangle group, `abc` is the Petrie element, `ρ` its order; the `(3,5,5)` split with equal
signature but different `ρ` is the classical phenomenon of regular hypermaps of the same type
differing in Petrie length. The regular-maps/hypermaps literature (Conder's census, Petrie duality)
may already classify these objects under other names.
**Why it may matter / strongest question:** literature link for the paper's novelty framing (does
the `(σ,ρ)` completeness result for `S₄/A₅` already exist as a hypermap classification?) and a
potential import channel: Petrie duality as an operation on our triple classes. Worth one bounded
literature pass before C264's novelty wording is finalized.
**Evidence:** REASONED (dictionary is exact; the literature side unexplored).
**Status:** open lead

### 2026-07-18 — value-level validation can mask orbit-level errors by parity coincidence

**Provenance:** C281 census finding (second `D_{4n}` conjugacy class breaking §9's `a₀ = 1`).
**Was I looking for this?:** no — the census was built to tabulate configurations, not to audit
C263's validation design.
**Observed / musing:** C263's end-to-end check verified 241,344 pair values and still missed the
second conjugacy class, because the wrong orbit multiplicities happened to preserve the value
(`t ≡ 1+δ (mod 2)` always). 20,196 pairs had a wrong structural parameter `ρ` with a right value.
The gap only became visible when triples made the parity coincidence break (odd `d`).
**Why it may matter / strongest question:** methodological: cross-checks that compare only the
final game value are blind to compensating structural errors. Future evidence bundles in this
program should assert intermediate structure (orbit multisets, stabilizer types, deletion
patterns) per configuration, as C281/C288 now do. Candidate for a one-line validation convention
in the perf/evidence playbooks if it recurs.
**Evidence:** CHECKED (the coincidence and the deviating counts are certified in the C281 JSON).
**Status:** open lead
