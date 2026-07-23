# C528 (cap) — decisive step: q13/q17/q19 overload-profile tabulation

**Lane:** `cap`. **Task:** C528 (gadget-Node-Kayles route, decisive first step of
`notes/2026-07-23-c80-gadget-nk-plan.md`). **Date:** 2026-07-23.

## What this settles

The gadget-Node-Kayles plan modelled the C523/C524 `capOVER`-core residual children as
`NK⁺(G, gadgets)` — Node-Kayles on the legal-point graph plus one **gadget** per overloaded
capacity-two line (a line with no selected point carrying ≥3 legal points: an independent
`k`-set that collapses to a clique the instant one of its points is played). The plan's
Step 1 was the decisive branch: tabulate the overload profile and choose

- **(a)** all `g=1`, `k≤4` → prove exactly a single-gadget law, depth-2 as a corollary; or
- **(b)** any `g≥2` or `k≥5` → the general multi-gadget induction is mandatory.

**Verdict: branch (b), sharpened — gadget complexity is unbounded in `q` on both axes.**

## Deduction used (no minimax)

Every residual child is itself `capOVER`. A `capOK` child would, by the proven `Y_NK`
theorem (C523), be static Node-Kayles; being a responder-win (`N`, asserted throughout
C524) it would then have Grundy ≠ 0, hence a Grundy-0 = `Y_NK` reply — contradicting
"no `Y_NK` reply". So the residual children are exactly the gadget-bearing states, and
their overload profiles decide the branch directly.

## Results (frozen three-intruder domains)

| q  | residual children | gadget count `g`          | max overload `k` | states with `k≥5` |
|----|-------------------|---------------------------|------------------|-------------------|
| 13 | 0                 | — (`Y_NK` closes depth-0) | —                | —                 |
| 17 | 349               | 1 … 7 (258/349 have g≥2)  | 4                | 0                 |
| 19 | 48,084            | 2 … **47** (mean 19.2)    | **7**            | 8,189             |

At q19, **100% of residual children have `g ≥ 2`** — not a single `g=1` case — and the
per-gadget overload magnitude `k` itself reaches 7. Both the number of gadgets and their
size **grow with `q`** (g: 7→47, k: 4→7 across q17→q19).

Gadget interaction (q19, over all overloaded-line pairs): 68% vertex-disjoint, 32% share
exactly one legal vertex (never two — two projective lines meet in a single point, so this
is forced geometry, not a mystery). Overloaded-line conic type (q19): mostly external, then
secant, tangent rare — no single-type law (the Fable §4.5 "always external/secant" handle
does not hold).

## Correction to the plan's premise

The plan's "First real case: `g=1, k∈{3,4}` covers ~93% of the observed q17 residual"
conflated two different measures in the C523 report. C523's "323/349 (93%) at minimal
overload 3" refers to the **overload magnitude** `k` (the winning-reply line has exactly 3
legal points), **not** the **number of gadgets** `g`. The two are independent: `k` is small
and slow-growing, but `g` is emphatically not 1. Only 91/349 = 26% of q17 residual children
are single-gadget, and 0/48,084 at q19.

## Implications for the crown route

- **The "g=1 gadget law + depth-2 corollary" is dead** — `g=1` never occurs at q19.
- **There is no finite bounded-gadget base family** to induct into: both `g` and `k` grow
  with `q`, so a fixed small-configuration enumeration cannot terminate the induction. The
  well-founded measure `(Φ, |L|)` is still valid, but the step must handle arbitrary `g`
  and interacting gadgets — a genuinely general argument, not a small-case calculus.
- **Depth-2 (C524) is not explained by small gadget count.** Depth-2 still closes 100% at
  q13/17/19 despite an average of ~19 (max 47) interacting gadgets per q19 residual child.
  A bounded two-ply responder strategy neutralises unbounded static gadget complexity — this
  reinforces (does not resolve) the C524 caution that depth-2 is likely a small-`q`
  phenomenon, and reframes the real question (see Mystery ledger).

## Mystery ledger (ej+tt closeout)

- **[OPEN — sharpest] Why does depth-2 suffice despite unbounded gadgets?** The static
  gadget structure is unbounded in `q` (g→47, k→7 at q19) yet the responder wins in ≤2
  plies at all three orders. The game value is far simpler than the static complexity. This
  is the load-bearing gap; it is owned by the C528 successor and is *not* closed here.
  Evidence gap: no proof of depth-2 coverage, boundedness, or uniformity beyond three primes.
- **[tt alt-attack, unallocated] Pairing/response, not Grundy calculus.** The 68% disjoint /
  32% single-shared gadget-pair structure is a near-matching. The lane already owns
  copycat/mirror pairing lemmas (q5 octahedral antipodal copycat, q11 icosahedral matchings).
  A pairing/involution responder strategy would make the gadget *count* irrelevant and could
  explain depth-2 directly — a cleaner attack than a multi-gadget Grundy induction. Reserve a
  C-ID before pursuing.
- **[SETTLED] Pairwise gadget overlap is 0 or 1, always.** Forced: distinct projective lines
  meet in one point. Not a mystery.
- **[SETTLED] `k` and `g` both grow with `q`.** Consistent with more lines / more overload
  opportunity as `q` grows; matches the growing residual `capOVER` fraction (0%→0.7%→4.2%).
- **[OPEN, minor] Overloaded lines are mostly external, some secant, few tangent.** No clean
  single-type law; not load-bearing for the value question. Owner: whoever formalises the
  gadget census, if ever.

## Reproduction

Generator + certificate (canonical JSON, `--check` recomputes and compares byte-for-byte):

```text
python3 rust/scripts/c528_overload_profile.py           # emit
python3 rust/scripts/c528_overload_profile.py --check    # verify
```

Load-bearing inputs (frozen; hashes recorded in the JSON `sources` block):

- `notes/data/c20-q13-q17-states.jsonl.gz` (q13, q17)
- `notes/data/c20-q19-states.jsonl.gz` (q19)

Helper modules imported at runtime (unchanged): `rust/scripts/c80_response_fibre_census.py`
(`projective_lines`, `maximum_capacity_two_line`, `node_kayles_exact`),
`notes/2026-07-08-zone-repair-geometry.py`, and the C31/C20 chain it loads.

Certificate: `notes/2026-07-23-c528-overload-profile.json`.

Independent replay: the residual-child identification reuses the exact C524 pass
(`c524_capover_core_depth2.py`), whose residual counts (q17: 349, q19: 48,084) this run
reproduces independently before profiling; that script's own `--check` is the cross-witness.

SHA-256 (filled at commit):

- `notes/2026-07-23-c528-overload-profile.json`:
  `006e22af4d71ce69b20897be019c799299c9e5c3fb511f3c657635f3df537287`
- `rust/scripts/c528_overload_profile.py`:
  `73a66e23638d34819f04fecccaf58b395fea3465db27fd092366a92f562e9358`
