# C497 — double-coset stratum-constancy pre-diagnostic (q17 bulk-descent crown)

**Lane:** `cap` (C80 consumer). C434/crowns artifacts are read-only method inputs.

**Date:** 2026-07-22

**Verdict:** `NON-CONSTANT — the (prior-triple stabilizer, reply) double-coset partition does NOT
refine Y_NK0-membership. Stratification is refuted as the bulk-descent mechanism; the full P/N
sweep is skipped per the queued pre-diagnostic.`

## Question (transfer note Transfer 3; sharpened by C495 ej2)

C434's method is: intrinsic cheap statistic + orbit coordinate → prove the joint fibres are the
`K`-orbits → evaluate once per stratum. Applied to C80's open sparse-coverage item: stratify the
frozen q17 three-intruder census by the double-coset label of the (prior-triple stabilizer, reply)
pair and test whether `Y_NK0`-membership (and P-purity) are stratum-constant. Constancy would
reduce bulk descent into `Y_NK0` to one representative per stratum; non-constancy refutes
stratification as the bulk mechanism before C82 counts anything.

Per the queued task and C495 ej2, the **cheap pre-diagnostic runs first**: does the double-coset
partition even *refine* `Y_NK0`-membership? If not, stratum-constancy fails immediately and the
full P/N sweep is skipped.

This was run as an **independent** stratification test, **not** a transport of C434's q=11 fibre
identity. C495 falsified that identification (the q=11 packet symmetry is `C5`; the double-coset
label is additive/incidence data orthogonal to the multiplicative `Legendre(u)` value sort), and
C434's Borel/Bruhat domain does not even exist at q=17 (no subgroup of order `(q²−1)/2`). The
method is borrowed; the group structure is not.

## Method (group-structure-independent)

The intruder centres are off-conic grid cells; each induces a conic involution in
`G = PGL_2(17)` acting on the `q+1 = 18` conic parameters (verified: `|G| = 4896`, and all 273
off-conic-centre involutions lie in `G`). For a three-intruder transition the prior triple has
stabiliser `K = Stab_G({σ₁,σ₂,σ₃})`; the **double-coset label** of the `(K, reply)` pair is
exactly the `G`-orbit of the marked configuration `({σ₁,σ₂,σ₃}, σ_reply)` under simultaneous
conjugation. Two `Y_0` objects share a double-coset label **iff an explicit `g ∈ PGL_2(17)`
conjugates one marked configuration onto the other** — this is what makes a claimed split airtight.

`Y_0` / `Y_NK0` are reproduced verbatim from the committed C80 census
(`rust/scripts/c80_response_fibre_census.py`); the reproduction matches the frozen census
exactly: **59,153** three-intruder transitions, **17,954** `Y_0` members, **3,048** `Y_NK0`
members. `Y_NK0`-membership is computed without the full game recursion (empty conic + graph-exact
+ zone Grundy zero), which the census proves equivalent to the P-value on that domain.

## Result

The pre-diagnostic decides the crown negatively.

| quantity | value |
|:--|--:|
| `Y_0` objects (marked configurations) | 17,954 |
| `Y_NK0` members among them | 3,048 |
| double-coset strata (a strong `G`-invariant partition) | 1,266 |
| strata mixed by `Y_NK0`-membership | 368 |
| `Y_0` objects living in a mixed stratum | 9,943 |
| strata with an **explicit `PGL_2(17)`-verified** `Y_NK0`/non-`Y_NK0` split | 249 |

The invariant partition used to group objects (individual + pairwise + reply fixed-point counts and
product orders) is `G`-invariant, so each *true* double-coset orbit lies inside one bucket; a
homogeneous bucket therefore certifies orbit-level constancy. **368 buckets are already mixed**, and
in **249** of them an explicit conjugator confirms a genuine *same-orbit* `Y_NK0`/non-`Y_NK0` pair.
One such pair suffices; 249 is overwhelming.

Canonical witness (least stratum, least conjugator):

```text
Y_NK0 object:      intruders (7,4),(12,8),(15,11)   reply (0,10)    ∈ Y_NK0
non-Y_NK0 object:  intruders (4,2),(5,15),(11,16)   reply (7,10)    ∉ Y_NK0
same double-coset label; conjugated by an explicit g ∈ PGL_2(17).
```

Both configurations have identical additive/incidence data — triple product orders `{2,3,9}`,
reply product orders `{2,16,18}`, reply involution with 2 conic fixed points — yet opposite
`Y_NK0`-membership.

## Why (the structural reason, confirming C495 ej2 at q17)

The double-coset label sees only the four intruder centres (an additive/incidence-sort datum).
`Y_NK0`-membership is a value-sort datum: it depends on the grandchild's **live conic being empty**,
graph-exact, and Grundy-zero, which is governed by the *conic points already selected in the
residual state* — data the (prior-triple, reply) label does not carry. Two states with
`G`-equivalent centre configurations but different conic residuals fall in the same stratum with
opposite membership. This is the concrete q17 realization of C495 ej2's split: sort 1 =
additive/incidence (the double-coset label), sort 2 = multiplicative/value (`Y_NK0`-membership),
and they are orthogonal.

Consequently stratum-constancy fails, the "one representative per stratum" bulk-descent shortcut is
unavailable, and the full P/N (P-purity) sweep is moot — skipped exactly as the queued
pre-diagnostic directs.

## Bearing on C80's ledger

- **C80(a) sparse-coverage item is unchanged and its shortcut is closed.** The double-coset label
  is refuted as the bulk-descent mechanism into `Y_NK0`. A viable successor still needs a genuine
  state-class/descent guard that carries the residual conic content — not a centre-configuration
  double coset.
- **Consistent across C495 → C497.** The whole C434 → C80 transfer collapses to a single faithful
  residue: the governing `C2` (det-square class) is shared (C495 ej closeout), but every value-sort
  identification fails. C495 killed the q11 fibre-identity transport; C497 kills the q17
  stratification transport. C496 (bi-Hecke bimodule) remains the last probe, now with a sharpened
  target: the coupling must bridge additive and multiplicative structure (a Gauss/Jacobi-sum-shaped
  pairing), not a permutation-module map.

## `ej` closeout

Three cheap task-owned upgrades, all folded into the certificate `ej_closeout` block and
independently re-verified in the replay.

**1. Exact non-constancy measure (sharper than the coarse 368).** Refining every mixed coarse
stratum into *true* double-coset orbits by explicit conjugacy: **304 true double-coset orbits are
`Y_NK0`-mixed**, holding 5,649 `Y_0` objects, of which **1,772 of the 3,048 `Y_NK0` members** live
in a genuinely mixed orbit. So even at the finest centre-configuration double-coset level a
**majority (58%)** of `Y_NK0` members share their orbit with a non-`Y_NK0` object. This is the
honest headline: the negative is not a coarse-invariant artefact — it survives to the full `G`-orbit
(the canonical witness pair already shares *all* centre-configuration invariants).

**2. A clean pure sub-domain the global negative conceals.** The coarse strata split
**166 pure-`Y_NK0` / 732 pure-non-`Y_NK0` / 368 mixed**; the 166 pure-`Y_NK0` strata hold 559
members that are *uniformly* `Y_NK0`. Counting at the true-orbit level, **1,276 of 3,048 `Y_NK0`
members (42%) sit in a pure double-coset orbit** where the label *does* determine membership. So
C497 is a global negative that simultaneously isolates a sizeable sub-domain on which the
double-coset label is a valid `Y_NK0` guard — a concrete door for a residual-refined successor (see
below), not merely a dead end.

**3. Exact reply-involution-type balance — C495's `C2` at q17.** Cross-tabulating `Y_NK0`-membership
against the reply involution's conic fixed-point count gives an exact symmetry:

```text
reply fixed points   non-Y_NK0   Y_NK0
        0               7453       1524
        2               7453       1524
```

The two reply types (0 fixed = exterior/elliptic, 2 fixed = secant/hyperbolic — the q17 analogue of
C80's `u` square class at q11) carry *identical* counts to the digit. The incidence datum is
therefore not merely insufficient but **exactly independent** of `Y_NK0`-membership, the clean q17
realization of C495's governing det-square `C2`: it moves objects between reply types while
preserving value, forcing equal fibres. The 91 distinct triple-product-order signatures are
similarly non-determining (only 12 are pure-by-`Y_NK0`).

### `ej2` — the exact balance is an external value-preserving `C2` (equalization)

The reply-type balance in finding 3 is deeper than "independent." The underlying pool of off-conic
intruder centres is **unequal by involution type**: 145 have 2 conic fixed points (secant/exterior),
128 have 0 (elliptic/interior). Yet `Y_0` selects **exactly 8,977 of each type** (7,453 + 1,524),
and each type splits into an **identical** 1,524 `Y_NK0` / 7,453 non-`Y_NK0`. `Y_0` equalizes an
unequal `145:128` pool to a perfect `1:1` and preserves the value split to the digit.

An exact value-preserving map that swaps the two reply types cannot be internal to `PGL_2(17)`:
conjugation preserves cycle type, so it never changes an involution's fixed-point count. The balance
is therefore evidence of an **external** value-preserving involution on the `Y_0` census exchanging
the secant and elliptic reply classes — precisely the shape C495 found at q11, where the governing
`C2` (det-square class) was the **external** endpoint swap that "moves the packet off itself while
preserving `u`/value." C497 exhibits the same `C2` at q17: value-preserving, acting externally, now
visible as an exact 2-colouring balance of the census rather than a pointed-state endpoint swap.

This also explains, quantitatively, *why q17 is hard*. At q11 the reply's square-class coordinate
`u` **is** the value (`u=8`→P, `u=9`→N). The q17 analogue — the reply involution's fixed-point
type — is instead **exactly orthogonal** to value (`7453/1524` in both classes). The value-carrying
square-class coordinate at q11 has become value-blind at q17; the exact balance is the sharp
statement of that transition, and it sits squarely inside the depleted set `{11,17}`.

The strengthening this points to (not yet run, a bounded door): exhibit the explicit external
involution `J` (a conic polarity / det-nonsquare correlation candidate) and verify it pairs the
17,954 `Y_0` objects, swapping reply type while preserving `Y_NK0`. Marginal equality is necessary,
not sufficient; the per-stratum matching test is the decisive next check.

### Doors (unallocated successors)

- **Residual-refined double coset.** The mechanism pins the failure on residual conic content the
  centre-configuration label omits. The natural next label is the joint stabiliser of the intruder
  configuration **and** the selected conic points, `Stab_G({σ_i}) ∩ Stab_G(residual conic)` — does
  *that* refine `Y_NK0`-membership, and does the pure sub-domain of finding 2 extend to a full guard?
  Bounded; route through normal allocation if pursued.

### Mystery ledger

- **Settled — stratification is non-constant, exactly measured.** 304 `Y_NK0`-mixed true
  double-coset orbits; 1,772/3,048 `Y_NK0` members in a mixed orbit (249 explicit conjugator
  witnesses at the coarse level). The double-coset partition does not refine `Y_NK0`-membership.
- **Settled — the mechanism of failure.** `Y_NK0`-membership depends on the residual conic content
  the centre-configuration label cannot see; additive/incidence and value sorts are orthogonal at
  q17, exactly as C495 ej2 predicted, and the reply-type crosstab shows the independence is *exact*
  (`7453/7453`, `1524/1524`).
- **Settled by `ej` — the concealed pure sub-domain.** 1,276/3,048 (42%) `Y_NK0` members lie in
  pure double-coset orbits; the label is a valid guard there. Not a global mechanism, but a real
  bounded sub-structure and a queued door.
- **No residual mystery.** The pre-diagnostic was bounded and returned a clean, witnessed, exactly
  quantified negative; the P-purity sweep is correctly moot. The open C80 sparse-coverage /
  two-sorted-coupling items are unchanged and owned by C80's descent theorem / C496.

## Reproduction

Run from `/home/tavis/src/othello`:

```bash
python3 rust/scripts/c497_double_coset_stratum_constancy.py --check
python3 rust/scripts/c497_double_coset_stratum_constancy_replay.py
sha256sum -c notes/2026-07-22-c497-double-coset-stratum-constancy.sha256
```

Intentional regeneration:

```bash
python3 rust/scripts/c497_double_coset_stratum_constancy.py
```

The primary checker builds `PGL_2(17)` from standard Möbius generators, reproduces the C80 `Y_0`
census and `Y_NK0` flags, partitions the marked configurations by a strong `G`-invariant, verifies
same-orbit `Y_NK0`/non-`Y_NK0` splits by explicit conjugator, cross-checks the reproduced counts
against the frozen census JSON, and emits the certificate with hard asserts on the verdict. The
independent replay rebuilds `PGL_2(17)` a different way (closure of the intruder involutions),
re-runs the enumeration and the partition with its own permutation arithmetic, recomputes the
mixed-bucket and verified-split counts, and re-confirms the committed canonical witness. Shared
trust boundary: the committed game/geometry modules (residual legality, `sigma` involutions,
`state_features`, and the census `Y_0` / node-Kayles definitions) — the same boundary as the C80
census; no second full P/N engine is used, and none is needed (`Y_NK0` is computed structurally).

### Load-bearing inputs (hashed into the certificate `inputs`)

- `rust/scripts/c80_response_fibre_census.py`
- `notes/2026-07-08-zone-repair-geometry.py`
- `notes/2026-07-22-c80-response-fibre-census.json` (frozen census; reproduced counts asserted equal)
- `notes/data/c20-q13-q17-states.jsonl.gz`

Trust boundary: exact `F_17` integer arithmetic. C497 makes no general-`q` claim and no
novelty/priority claim; it is the stated finite structural test at q=17.
