# C528 (cap) — alternative-witness probe on the 1,104 q19 pairing failures

**Lane:** `cap`. **Task:** C528 (gadget-Node-Kayles route,
`notes/2026-07-23-c80-gadget-nk-plan.md`, "Reshaped route" cheap de-risking probe). **Date:** 2026-07-23.

## Question

The C528 pairing probe (`c528_pairing_probe.py`) found that at q19, **1,104 even-`|O|` residual
`capOVER`-core children** admit **no single-level perfect matching** on their **first** depth-2
witness `r0` — the clean "even-`|O|` copycat involution" law of q17 (132/132) breaks. That probe is
explicitly witness-choice dependent. The plan's decision gate before reserving a proof C-ID:

> Does an **alternative** depth-2 witness `r` restore a perfect matching for the 1,104 q19 failures?
> If yes → the route is a cheap **witness-selection lemma**; if no → it needs **multi-level
> (persistent) copycat** or is dead.

## Verdict: NO — 724 of the 1,104 have no matchable alternative witness

Under the correct single-level copycat test (legal-reply `H`, below), searching **every** legal
responder move `r` for each failure child:

| q19 failure set | alt-witness **restored** | alt-witness **still failing** | all restored? |
|-----------------|--------------------------|-------------------------------|---------------|
| 1,104           | **380** (34%)            | **724** (66%)                 | **no**        |

**Single-level copycat is genuinely insufficient at q19**, even allowing free choice of the depth-2
witness. Two-thirds of the first-witness failures have **no** valid depth-2 witness whose legal-reply
pairing graph admits a perfect matching. The pairing route is therefore **not** a cheap
witness-selection lemma. It survives only with a **multi-level (persistent) copycat** argument (or the
gadget Grundy calculus fallback), plus the odd-`|O|` pairing-plus-one-free-move handling — no longer a
two-line win. This confirms the plan's "if no" branch.

The restoring witnesses (for the 380 that are rescued) are found at legal-move indices up to 30 — they
are genuinely deep alternatives, not near-first ones — which further argues against a clean selection
rule.

## The legal-reply `H` (correctness fix over the pairing probe)

A single-level copycat on witness `G = C ∪ {r}` (opponent to move, `O = legal(G)`) is a
fixed-point-free involution `τ` on `O` answering **every** opponent move `o` with a **legal** reply
`τ(o) = p` reaching a `Y_NK`(=P) state — a perfect matching in

```text
H = (O, {o,p} : p is a legal reply to o  AND  G ∪ {o,p} ∈ Y_NK).
```

`G ∪ {o,p}` is a legal cap ⟺ `p` legal after `o` ⟺ `o` legal after `p`, so the edge is a **mutual**
legal reply and the matching is a genuine involution. A perfect matching automatically certifies `G` as
a valid depth-2 witness (every `o` is answered by its matched legal reply), so no separate
witness-validity gate is needed.

**Why the legal-reply check is load-bearing.** `is_ynk(mask) = capOK(mask) ∧ Grundy0(mask)` is a
predicate on the *legal-move structure*; it does **not** reject a `mask` that is itself a non-cap
(`node_kayles_exact` only checks that every capacity-two line carries ≤2 legal points). So the pairing
probe's `H = {o,p} : is_ynk(G∪{o,p})` (no legality check) admits **illegal-reply edges** — matchings
that pair `o` with a `p` that is not a legal reply to `o`. Measured cost of that looseness on this
exact question:

| alt-witness search over the 1,104 failures | restored | still failing |
|--------------------------------------------|----------|---------------|
| loose `H` (pairing-probe convention)       | 1,104    | 0             |
| **legal-reply `H` (this report)**          | **380**  | **724**       |

The loose `H` reports a spurious "all restored" because 724 children are "rescued" only by matchings
that use illegal replies. The legal-reply count is the sound one and drives the verdict.

**The inflation also corrects a prior POSITIVE claim (certified, `c528_q17_legal_h_audit.py`).** The
loose `H` has a *superset* of the legal `H`'s edges, so "no matching under loose `H`" ⟹ "no matching
under legal `H`": the pairing probe's **negative** counts (the 1,104 q19 failures, the q17 failures)
are unaffected. But its **positive** matched counts were inflated. Re-running the q17 first-witness
matching under both graphs:

| q17 even-`\|O\|` first-witnesses | matched (loose `H`) | matched (legal `H`) | inflated |
|----------------------------------|---------------------|---------------------|----------|
| 132                              | 132                 | **126**             | **6**    |

So the pairing report's headline **"depth-2 IS a literal copycat involution on the even-`|O|` q17 core
(132/132, parity-clean)"** — the observation that *reframed* the crown route toward pairing — **does not
survive**: under the correct legal-reply `H` it is **126/132**, and `legal_H_parity_clean = False`. The
clean copycat law breaks already at q17, not only at q19. This strengthens the verdict: single-level
copycat was never the clean small-`q` law it appeared to be, at *any* tested prime.

## Cross-check with the pairing certificate

This run reproduces the pairing probe's failure set independently, using the pairing-probe `H`
**verbatim** for the first-witness pass:

- residual `capOVER`-core children: **48,084** (matches C524/C528);
- first-witness matched (loose `H`): **22,932**;
- first-witness even-`|O|` failures: **1,104** — byte-identical to
  `2026-07-23-c528-pairing-probe.json` (`even_parity_without_matching = 1104`).

So the failure set this probe operates on is exactly the pairing probe's, confirmed by re-derivation
rather than trust.

## Mystery ledger (ej+tt closeout)

- **[SETTLED here — the probe's target] Single-level copycat does not generalise by witness
  selection.** 724/1,104 q19 failures have no matchable alternative witness under the legal-reply `H`.
  The clean q17 pairing law is a small-`q` phenomenon that witness choice cannot repair.
- **[OPEN — inherited, load-bearing] Why does depth-2 close 100% at q13/17/19 despite this?** Depth-2
  (C524) still certifies every residual child, yet the responder's winning move is provably **not** a
  single-level copycat for 724 q19 states. So the depth-2 win is a genuinely richer object than a
  one-level involution — either a **multi-level** (persistent) copycat or a non-pairing strategy. This
  is the same load-bearing gap the C528 report flagged; the probe **sharpens** it (single-level pairing
  is now excluded, not merely un-demonstrated) but does not close it. Owner: the C528 proof successor.
- **[SETTLED here — correction] Legal-reply vs `is_ynk`-only `H`, and the q17 "132/132" claim.**
  `is_ynk = capOK∧Grundy0` accepts non-cap masks, so the pairing probe's `H` admits illegal-reply
  edges. Consequence, certified (`c528_q17_legal_h_audit.py`): the pairing report's positive
  **"132/132 literal copycat, parity-clean"** at q17 is actually **126/132** under the correct
  legal-reply `H` (`legal_H_parity_clean = False`) — the clean copycat law fails at q17 too. Prior
  *negative* counts are unaffected (loose `H` edge-superset). Any pairing/Grundy **proof** must use the
  legal-reply edge condition. Owner: whoever formalises the pairing route.
- **[SETTLED] The 1,104 failure set is exactly the pairing probe's.** Re-derived here (48,084 / 22,932
  / 1,104), not trusted.

## What this changes for the crown route

- The cheap "witness-selection lemma" hope is **dead**. Reserving a proof C-ID for a single-level
  copycat is not warranted.
- The pairing route is **not abandoned** but demoted to the same difficulty tier as the multi-gadget
  Grundy calculus: it needs a **multi-level / persistent** copycat construction (track the copycat
  across the ≥2 plies, not one witness) plus odd-`|O|` free-move handling. Whether that is cleaner than
  the gadget Grundy induction is now an open modelling choice, not a settled advantage.
- Depth-2's uniformity remains a three-prime conjecture (C524); this probe removes one candidate
  *mechanism* (single-level pairing) for explaining it.

## Reproduction

Generator + certificate (canonical JSON, `--check` recomputes and compares byte-for-byte):

```text
uv run --with networkx python3 rust/scripts/c528_alt_witness_probe.py           # emit (q19, ~40 min)
uv run --with networkx python3 rust/scripts/c528_alt_witness_probe.py --check   # verify (recomputes)
```

The default order is `--q 19` (q17 has 0 failures, so nothing to restore; run `--q 17` to confirm the
trivial pass). `--check` recomputes the full q19 pass — the cost of the replay — because the certificate
stores aggregates, not the intermediate graphs.

Load-bearing input (frozen; hash in the JSON `sources` block):

- `notes/data/c20-q19-states.jsonl.gz`
  (`5ddea78f59898c194b2fdedda9871d7787dac577bef0aa44e5483e5109589e8a`).

Helper modules imported at runtime (unchanged, shared with the pairing/overload probes):
`rust/scripts/c80_response_fibre_census.py` (`projective_lines`, `node_kayles_exact`),
`notes/2026-07-08-zone-repair-geometry.py`, and the C31/C20 chain it loads.

Independent replay: the residual-child and 1,104-failure identification reproduces the pairing
probe's certificate (`2026-07-23-c528-pairing-probe.json`) exactly; that probe is the cross-witness.

Certificate: `notes/2026-07-23-c528-alt-witness-probe.json`.

Companion q17 correctness audit (loose vs legal-reply `H` on the q17 first-witnesses; ~1 min):

```text
uv run --with networkx python3 rust/scripts/c528_q17_legal_h_audit.py           # emit
uv run --with networkx python3 rust/scripts/c528_q17_legal_h_audit.py --check   # verify
```

Certificate: `notes/2026-07-23-c528-q17-legal-h-audit.json`
(input `notes/data/c20-q13-q17-states.jsonl.gz`).

SHA-256:

- `notes/2026-07-23-c528-alt-witness-probe.json`:
  `e4602e1d9e2bfab6975754a6f4550efc7f5785f0568a175cef05c146a8bc899e`
- `rust/scripts/c528_alt_witness_probe.py`:
  `5866b0b5f036b251385b4c0d5b9199711cfe317b1b2db9f9b40abb840947c462`
- `notes/2026-07-23-c528-q17-legal-h-audit.json`:
  `2341b2375a3ea727d59d42a1d1e3ad60d8d07ca50bde399d5d0036b38bf8f22e`
- `rust/scripts/c528_q17_legal_h_audit.py`:
  `f519c54ea26f10abb729761ce831cbe81675dbe916b469cfa0281b7874fbf6a1`
