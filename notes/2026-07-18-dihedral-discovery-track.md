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

### 2026-07-18 — how are the zeros of Dawson's chess (A002187) distributed, especially on primes?

**Provenance:** C283 wild-case spike, §4 "genuinely open / harder" item (a) — backfilled from 2026-07-17 work; corroborated by C282 OEIS byproducts, §1.4/§3.
**Was I looking for this?:** no — C283 was scoping the wild `p | 2m` residual (goal: identify what breaks vs. the tame case and propose a §15 remark), and C282 was checking whether the cycle Node-Kayles sequence collides with an existing OEIS entry. Neither task set out to study the Dawson sequence itself.
**Observed / musing:** Both tasks bumped into the same object from opposite sides. C283 found that the wild game `D_{2p}` has value `A002187(p)` (Dawson's chess at a prime index), so whether the wild game is a P- or N-position reduces to whether `p` is a *Dawson-zero index* — and over `p ∈ {3,5,7,11,13}` only `p=7` gives a zero-adjacent small value, so "how often is a prime a Dawson zero?" controls the wild P/N split. C283 explicitly flags this as "a question about the Dawson sequence on primes, outside this framework." Independently, C282's collision check searched the Dawson-zero index set `0,4,8,14,20,24,28,34,38,42` in OEIS and got **no results** — the zero-index set of A002187 is itself uncatalogued. A002187 is eventually periodic (period 34), so the zero set is eventually a union of residue classes mod 34; the "distribution on primes" question is then essentially which of those residue classes mod 34 contain infinitely many primes (Dirichlet gives a clean answer) and with what density.
**Why it may matter / strongest question:** it turns the wild-case P/N law into an arithmetic-progression statement: is "wild `D_{2p}` is a P-position" equivalent to `p` lying in one of the Dawson-zero residue classes mod 34 (past the pre-periodic tail), and is that class set nonempty on primes? If so, the wild boundary gets a clean density statement paralleling the tame `1/2` — and the Dawson-zero index set would deserve its own OEIS entry (a byproduct C282 did not propose because it fell outside the cycle-sequence submission).
**Evidence:** OPEN
**Status:** open lead

### 2026-07-18 — does the wild `m = p ⇒ D_{2p}` collapse survive over prime-power fields `q = p^k`?

**Provenance:** C283 wild-case spike, §4 "genuinely open / harder" item (c) — backfilled from 2026-07-17 work.
**Was I looking for this?:** no — the spike deliberately enumerated only odd *prime* fields `q = p ∈ {3,5,7,11,13}` to characterize the wild pair residual; extending to non-prime `q` was not part of the checked domain.
**Observed / musing:** the single controlling fact the spike leans on — a cyclic subgroup of `PGL₂(q)` whose order is divisible by `p = char` has order exactly `p` (nonsemisimple ⇒ unipotent) — holds over any finite field `F_q`, not just prime fields. So the element-order argument *predicts* that over `q = p^k` a wild pair still forces `m = p`, the rotor is still unipotent, the group is still `D_{2p}` inside a Borel, the deleted set is still a single point, and the residual is still the path `P_p` with value `A002187(p)`. The spike states this as "a prediction, not a checked claim" and did not enumerate any prime-power field. Note this is distinct from the already-tracked promotable wild-*pair* lemma (dihedral handoff, prime-field structural classification) and from queued C292 (which is the wild *polyhedral* `S₄/A₅` characteristic spike, not the dihedral prime-power case) — the prime-power dihedral extension is not covered by either.
**Why it may matter / strongest question:** if the prediction holds, the whole wild dihedral phenomenon is `q`-uniform (depends only on `p`, not on `k`), which would let the promotable wild lemma be stated for all `q` at once rather than re-checked per field family. The falsifier: enumerate wild pairs over one small `q = p^k` (e.g. `q = 9`, `p = 3`) and confirm `m = p`, `|Fix(r)| = 1`, residual `P_p` — or find an orbit shape the prime-field enumeration never saw (the extra field automorphisms of `F_{p^k}` could in principle enlarge the relevant point-stabilizer/orbit structure).
**Evidence:** REASONED
**Status:** open lead
