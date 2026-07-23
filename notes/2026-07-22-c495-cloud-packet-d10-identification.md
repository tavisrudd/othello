# C495 — q=11 identification falsifier: C80 cloud packet vs C434 D10 two-sheet coset space

**Lane:** `cap` (C80 consumer). C434/crowns artifacts are read-only, hashed inputs.

**Date:** 2026-07-22

**Verdict:** `FALSIFIER NO — clean structural refutation, with a precise C5-level partial match.`

## Question (Fable transfer note `2026-07-22-c434-c80-cross-lane-transfers.md`, Transfer 1)

Is C80's C447/C460 22-move opponent set — with its square-`C5`-kernel orbit structure
`[1,1,5,5,5,5]` and intrinsic edge coordinate `u = XZ/Y²` — `G`-equivariantly the C434 `D10`
J-class two-sheet coset space, with the `C5` orbits refining the double-coset strata and `u`'s
square/nonsquare class equal to the sheet sign?

The motivation is a genuine coincidence: C434's `D10` J-class (`|K|=10`, the Pan–Wu–Yin incident
stabilizer) has `K`-orbit sizes exactly `[1,1,5,5,5,5]` on its 22-point two-sheet space, matching
C80's cloud-packet `C5`-orbit sizes.

## Answer: NO, at three independent layers

Consumed at each of the four pointed states (both P-edge endpoints of both q=11 knife-edge classes);
all four are identical.

1. **Group level (airtight).** The full setwise stabilizer of C80's single-state 22-move set inside
   the whole conic group `PGL_2(11)` (order 1320) is **exactly `C5` (order 5), with zero
   determinant-nonsquare elements.** There is no `D10` — indeed no element outside `C5` — anywhere
   in the conic group that preserves the packet. So C80's packet is **not a `D10`-set at all**,
   hence cannot be the C434 `D10` two-sheet coset space. By contrast C434's `Ω` is a genuine
   internal-`D10` orbit (all ten elements of `K` preserve `Ω`), with two `D10`-fixed points
   `M0, JM0`, one on each sheet.

2. **The two-fold symmetry sits at different levels.** C80's cap-frame `D10` = `C5 ⋊ ⟨reflection⟩`,
   but the nonsquare coset does **not** preserve a single state's 22-move set: it is the
   **inter-state endpoint swap** (state0 ≠ state1, overlap 16 of 22). So C80 carries **two** distinct
   22-move objects related **externally** by the reflection, whereas C434 carries **one** 22-point
   object with an **internal** 11+11 sheet structure swapped by the outer `J`. Cardinality makes the
   mismatch precise: one C80 state (22 moves) has the size of all of `Ω` (22), not of one sheet (11);
   the C5-level `[1,1,5,5,5,5]` therefore cannot be "one state ↔ one sheet."

3. **`u`'s square class is not the sheet sign — and not even the `D′` analogue.** The C434 sheet
   coordinate 2-colors the four `K`-orbits of size 5 **2–2** (`{1,5,5}` per sheet). C80's `u` on its
   four 5-orbits is `{1,8,9,∞}` with square classes `{sq, nonsq, sq, ∞}` — a **2–1–1** split, not
   2–2. Going further: C434 labels its four 5-orbits by `(sheet ∈ {0,1}) × (D′-type ∈ {generic,
   (0,0)})`, a clean **2×2** (per sheet, `D′` takes a nonzero value and `(0,0)`); C80's four 5-orbits
   carry **four distinct** `u`-values with asymmetric game roles `{forced 1[5], good/P 8[5], bad/N
   9[5], boundary ∞[5]}` — a **1+1+1+1**, not a 2×2. So `u` matches neither the sheet sign nor `D′`.

## Partial match that survives

The two objects **are isomorphic as `C5`-sets**: both are two fixed points plus four regular
`C5`-orbits (`[1,1,5,5,5,5]`), and for a cyclic group of prime order the orbit profile determines the
isomorphism type. This is exactly — and only — the coincidence that motivated the probe.

## tt pass — what Tao would see

- **The `[1,1,5,5,5,5]` match is a fingerprint collision, not a structural identity.** Equal
  orbit-size profiles are weak evidence: they are a coarse shadow of the permutation character, and
  many inequivalent actions share one. The load-bearing invariant is the acting group and the
  permutation character, which C495 separates cleanly (`C5`-set with 2 fixed + 4 regular vs internal-
  `D10` set). This is the same failure mode as the lane's dead residue-class laws (the mod-3
  prediction refuted at q=23): a numeric coincidence mistaken for a mechanism. Record it as a caution
  before any C497 stratification is read as "the same object as the q=11 packet."

- **The reflection is the tell.** The one genuinely informative structural fact recovered is
  *where* the extra involution lives: in C434 it sheets a single object; in C80 it swaps two objects.
  This is why the correct C434-analogue of "sheet sign" on C80's side is the **endpoint label**
  (which P-edge endpoint you pointed at), an **inter-state** datum — not `u`, which is an
  **intra-state** coordinate. Any future attempt to import C434's `(sheet, D′)` fibre identity must
  respect that `u` is a within-`C5`-object coordinate; it has no sheet role.

- **`u` vs `D′` is the sharper defect.** Even discarding the sheet question, `u` (four distinct
  values) cannot be the `D′` analogue (three distinct values, one collision resolved by sheet). The
  cloud packet's four 5-orbits are game-role-asymmetric (forced / good / bad / boundary), whereas
  C434's are group-symmetric (2×2). The cloud packet's structure is carrying *game value* (P/N), which
  `D′` — a pure edge-incidence statistic — does not see. This is the real reason the transfer fails:
  C434's object is value-blind, C80's is not.

## Consequences for the remaining probes

- **C497 (bulk-descent crown, next).** Do not expect the q17 double-coset (`D10`/`K`) stratification
  to coincide with C80's frozen packet symmetry: C495 shows the q=11 packet's genuine symmetry is
  `C5`, and its four generic strata are game-role-asymmetric. C497 must be run as an *independent*
  stratification-constancy hypothesis on the q17 census — not as a transport of C434's certified
  fibre identity. Its value is undiminished (constancy/non-constancy is still decisive), but the
  prior probability that the double-coset label is the bulk mechanism drops.
- **C496 (bi-Hecke bimodule).** The `e_K F[G] e_H ≅ F[K\G/H]` candidate is a value-blind linear
  object; C495's layer-3 finding (the cloud packet's strata carry P/N, which `D′` does not) is direct
  evidence for the C411 caveat that any realized coupling is set-faithful with a rank-dropping linear
  shadow. Seek the coupling as a set-level labeling with a small linear shadow, as Transfer 2 already
  anticipated.

## Mystery ledger

- **Settled — the orbit-size coincidence is `C5`-level only.** `[1,1,5,5,5,5]` is a genuine `C5`-set
  isomorphism and nothing more; the `D10` completions are structurally incomparable (internal
  sheeting of one object vs external pairing of two).
- **Settled — `u` is neither sheet sign nor `D′`.** 2–1–1 vs 2–2 for the sheet; four distinct values
  vs three for `D′`. `u` is an intra-`C5`-object coordinate that additionally sees game value.
- **No residual mystery.** The falsifier was bounded and returned a clean negative with an explicit
  partial match; no unexplained numeric residue remains.

## Reproduction

Run from `/home/tavis/src/othello`:

```bash
python3 rust/scripts/c495_cloud_packet_d10_identification.py --check
python3 rust/scripts/c495_cloud_packet_d10_identification_replay.py
sha256sum -c notes/2026-07-22-c495-cloud-packet-d10-identification.sha256
```

Intentional regeneration:

```bash
python3 rust/scripts/c495_cloud_packet_d10_identification.py --write
```

The primary checker reconstructs both frozen objects (C80's four pointed states via the committed
cloud-packet constructors; C434's `D10` J-class via the committed lattice constructors), computes the
setwise stabilizer, the `C5`/`D10` orbit profiles, and the `u`/sheet/`D′` comparisons, and emits the
certificate with hard asserts on the verdict. The independent replay regenerates `PGL_2(11)` by
generator closure, reimplements the conic cell action, `u`, and the determinant-square test from
scratch, recomputes the setwise stabilizer and both orbit profiles by union-find, and asserts
agreement with the committed certificate. The underlying residual-grid legality and the C434 matching
geometry are each independently replayed by their own committed bundles
(`rust/scripts/c80_c447_cloud_packet_replay.py`,
`notes/2026-07-22-c434-double-coset-information-lattice-replay.py`), which C495 consumes and hashes.

Trust boundary: exact `F_11` integer arithmetic; the frozen C447/C460 cloud-packet bundle and the
frozen C434 lattice bundle (consumed by path + SHA-256). C495 makes no general-`q` claim and no
novelty/priority claim; it is the stated finite structural comparison at q=11.

### Load-bearing inputs (hashed into the certificate `inputs`)

- `rust/scripts/c80_c447_cloud_packet.py`
- `notes/2026-07-22-c434-double-coset-information-lattice.py`
- `notes/2026-07-21-c447-cap-knife-edge.json`
- `notes/2026-07-08-intrusion-census.py`
- `notes/2026-07-20-c406-matching-orbit-scout.json`
