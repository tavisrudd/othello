# Handoff: Projective Cap Achievement Game

**Lane**: `cap`

Updated: 2026-07-29.

## Goal

Prove that `PG(2,q)` is P for every odd prime power `q`. The active
kernel is the on-conic escape statement: every legal residual
size-three grid position has a P-valued on-conic size-four extension.

## Current state

The established reduction is

```text
projective frame
→ residual q×q grid cap game
→ unique conic through the five fixed arc points
→ on-conic size-four escape
→ mixed-capacity residual game
→ growing-depth survivor and absorption.
```

The fixed-depth and local one-label routes are closed. Total
capacity-two overload `Ω` is the exact well-founded absorption
coordinate, and `B_cc` is the structural overload-zero P boundary.
The q23 defect-rank survivor `F_d` proves that growing-rank repair is
viable on the certified domain.

The latest C80 result falsifies uniform per-causal-move
certificate-exchange nonpacking already over `F_11`. For

```text
A = {(1,3),(5,2),(9,6),(10,1)}
o = (4,4)
h = (7,10),
```

both `o,h ∈ Def(A)`, while

```text
Def(A+o)   = ∅
Def(A+o+h) = {(0,5),(6,5)}.
```

The causal reply `h` was itself a shared old `B_small` certificate
for both new fibres. Selecting it consumes both certificate copies,
so one causal label necessarily branches. Primary bitmask and
independent affine-determinant replay agree.

The witness still has global cardinality surplus: seven old defect
labels disappear and only two genuinely new defects appear. Thus the
live proof object is global, not causal-local.

## Active frontier — C80

Define a projectively natural bipartite incidence relation between

```text
consumed ancestral labels ↔ genuinely new defect fibres
```

across a complete opponent/reply exchange.

Prove a Hall-type rematching with:

1. every new defect assigned a distinct consumed ancestral label;
2. strict total support descent;
3. an update described by bounded projective incidence data, not an
   explicit growing matching or strategy table;
4. hereditary compatibility with strict `Ω` descent and the `B_cc`
   boundary.

If this fails, extract the first support-deficit set with its exact
field, state, exchange, neighbourhood, and independent replay.

After the rematching theorem, prove opponent-complete entry into the
globally charged survivor from every on-conic escape root. Only then
does C82 receive a sound geometric reply family to count.

## Acceptance gate

C80 advances only with one of:

- a field-uniform Hall/rematching theorem plus strict-support descent;
- an explicit support-deficit counterexample;
- a sound replacement proof object of comparable strength that is
  projectively natural, growing-depth, nonrecursive in game value,
  and opponent-complete.

Finite selector purity, another q23 orbit sweep, a scalar potential,
or a fixed-depth shell does not pass.

## Key structural facts

- `PG(n,2)` is P for all projective dimensions `n≥1`.
- `PG(2m-1,q)` is P for odd `q` by a fixed-point-free elliptic
  projective involution.
- `PG(2,q)` is P for even `q`.
- `PG(4,3)` is computed P.
- Odd planes are Lean-proved for `q=5,7,11,13`; `q=3,9,17,19` are
  computed P. The q23 on-conic layer is rules-certified across all
  22 full-`PGL(2,23)` buckets; q25 has an all-P on-conic census.
- Odd-plane root P is equivalent to the residual size-three escape
  condition. Every size-three residual has `q²-9q+21` legal
  size-four extensions and `q-4` legal on-conic extensions.
- An off-conic intruder induces an involution on the conic. After
  intrusions, the conic residual is Node--Kayles on a union of
  involution matchings, coupled to off-conic capacity-two blocks.
- The exact residual exchange transform retains live vertices,
  load-one pair-conflict blocks, and load-zero active capacity-two
  blocks. It commutes with geometric play.
- `capOK` cannot be reached at fixed selected size uniformly:
  an `s`-cap with `capOK` forces `q≤binom(s,2)`.
- `Ω=0` is exactly `capOK`, but `capOK` alone does not imply P.
  `B_cc` supplies a direct persistent/adaptive copycat P boundary.
- The conditional causal-label theorem remains correct:
  `|U_A(h)|≤1` implies one-label injectivity. The q11 witness shows
  that this hypothesis is not uniform.

## Trust and scope

The uniform odd-plane theorem is open. Finite computations certify
only their named fields and domains.

| order/family | current trust |
| --- | --- |
| even `q`, `PG(2,q)` | Lean theorem |
| odd `q`, odd projective dimension | Lean theorem |
| `q=5,7,11,13` planes | Lean theorem |
| `q=3,9,17,19` planes | computed P |
| q23 on-conic escape layer | complete bucket census plus rules-only DAG check |
| q25 on-conic escape layer | complete all-P bucket census |
| all odd planes | conjectural; C80 open |

## Current files

- Canonical C80 truth ledger:
  `../2026-07-25-c80-status-ledger.md`
- Latest falsifier, replay script, and certificate:
  `../2026-07-29-c80-causal-one-to-many.md`,
  `../../rust/scripts/c80_causal_one_to_many.py`,
  `../2026-07-29-c80-causal-one-to-many.json`
- Search/lookup companion with the full prior handoff, historical
  attacks, and report pointers:
  `2026-07-29-projective-cap-c80-lookup.md`
- Older chronological archive:
  `done/2026-07-08-projective-cap-game-handoff-archive.md`
- Incidental discovery track:
  `../2026-07-23-cap-discovery-track.md`
- Main solver:
  `../2026-07-06-grid-cap-solver.rs`
- S4 archive/query manual:
  `../2026-07-08-s4-memo-dump-query-manual.md`

## Active queue

1. **C80 — highest-EV spine.** Prove global consumed-label Hall
   surplus and strict support descent, or extract the first
   support-deficit set.
2. **C82 / C520 — gated.** Count C80's projected geometric reply
   family only after C80 supplies one.
3. **C81.** Characteristic-5/7 Frobenius/subfield gate.
4. **C13.** q9 finite proof/certificate work.
5. **C30 engineering tail.** q17/q19 Lean certificate assembly;
   expensive launch remains separately gated.

Base-case and paper-packaging tasks do not advance the uniform crown.
Use the live queue for exact task allocation and the lookup companion
for closed C-item provenance.

## Next action

Start from the q11 one-to-many witness and formulate the global
consumed-label/new-defect neighbourhood. Test Hall surplus on the
existing q11 witness and the certified q23 replacement corpus before
attempting a field-uniform incidence proof.

go C80 cap prove global consumed-label Hall surplus and strict support descent, or extract the first support-deficit set
