# C80 — q23 obligation-deletion sweep

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-26.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

Strict obligation deletion is false beyond the first q23
`F_d \ R0` target.

In the canonical C54 P-control order, `F_del=F_d` on every outer reply
target of controls 12 through 20 (zero-based indices 11 through 19). The
first disagreement occurs on control 21 (index 20):

```text
history reply:       (7,5)
outer exchange:      (8,4) -> (13,7)
target defect rank:  27
target Omega:        63
```

The target lies in `F_d` but not in `F_del`. Its blocking obligation is
`(12,15)`. There is exactly one sound lower-rank `F_d` reply:

```text
(12,15) -> (22,14)
```

It sends the defect locus from rank 27 to rank 2, removing 26 old
obligations and retaining the old obligation `(17,19)`, but it creates the
new obligation `(21,17)`. The successor itself lies in both `F_d` and
`F_del`. Thus the failure is exactly one replacement at the current edge,
not unresolved recursive complexity below it.

This settles the requested falsifier. Set inclusion is too rigid to be the
uniform C80 proof object; cardinality descent survives this test.

## Exact searched domain

The deterministic sweep starts immediately after the previously certified
rank-30 target, at zero-based canonical control index 11. It orders controls
by the C54 canonical P-reply order and orders opponent/reply cells
lexicographically. It stops at the first outer reply target in `F_d` but not
in hereditary `F_del`.

Before and including the stopping candidate it checked:

```text
completed controls with exact equality:   9  (indices 11..19)
opponent fibres entered:               1065
legal outer reply candidates:         70973
F_d edges:                             11076
F_del edges:                           11075
```

The sole discrepancy is the displayed control-20 edge. The computation
makes no claim about later canonical controls, other q23 roots, or uniform
odd q.

## Why the failure is decisive

`F_del` strengthened the defect-cardinality survivor by demanding

```text
Def(S+x+y) strictly contained in Def(S).
```

At the blocking obligation, every deletion reply fails because the only
sound lower-rank reply creates `(21,17)`, which was not in the old defect
locus. Since the reply is unique inside `F_d`, no witness choice can restore
strict inclusion.

The successor is nevertheless an `F_del` state. The obstruction therefore
has the minimal logical shape

```text
27 old obligations
  -- unique sound exchange -->
1 retained old obligation + 1 replacement obligation
  -- deletion survivor continues -->
boundary.
```

The next proof object must transport or discharge replacement obligations,
not forbid them. A promising formulation would attach lineage or a
projectively natural charge to a replacement and prove that the charged
obligation system decreases well-foundedly. Merely allowing “at most one
replacement” is finite evidence, not yet a theorem or a sufficient rank.

## Soundness and trust boundary

The checker reconstructs every target from the normalized q23 prime-grid
game, computes `Def`, `Omega`, `F_d`, and hereditary `F_del`, and compares
the two edge sets in canonical order. At the mismatch it enumerates every
legal reply to the blocking obligation and verifies:

- the displayed reply is the unique strict-rank `F_d` witness;
- its successor is in `F_d` and `F_del`;
- the next defect set consists exactly of retained `(17,19)` and new
  `(21,17)`; and
- no strict-locus-deletion witness exists.

The generator and replay use the same normalized q23 incidence engine and
the prior C80 survivor implementations. There is no independent second
geometry or survivor engine for this sweep; exact regeneration and the
stored edge-set comparison are the computational cross-check. The
well-founded soundness proofs for `F_d` and `F_del` are mathematical and do
not depend on a C54 minimax label.

## Reproduction

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_q23_obligation_deletion_sweep.py
python3 rust/scripts/c80_q23_obligation_deletion_sweep.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_obligation_deletion_sweep.py` | 10,413 | `71147cef27db6f9a73df7913044cbdef66514dc97da8573fea9f0af2fa76bbd9` |
| `notes/2026-07-26-c80-q23-obligation-deletion-sweep.json` | 8,253 | `f62d5f89c5b413cfd763fd29735d96aec4a6876d3571e47650b794f07fa32736` |

The JSON is canonical sorted data. `--check` regenerates the complete sweep
in a temporary directory and requires byte equality with the committed
certificate.

## `ej` + `tt` closeout

The cheap upgrade is stronger than merely locating a mismatch: it isolates
the complete local quantifier failure. There is one and only one `F_d`
witness, it removes 26 of 27 old obligations, and the successor is already
inside `F_del`. This rules out witness-selection repair while showing that
the deletion mechanism fails by the smallest possible replacement count.

The Tao-style correction is to stop ordering obligations only by literal
set inclusion. The game performs a highly contracting rewrite that changes
one obligation's identity. The next useful invariant should explain that
identity change—by lineage, charge, or an incidence-defined transport—not
add another static profile or bounded shell.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] Does strict obligation deletion continue to equal `F_d` on
  later q23 controls?** No. The first mismatch is at canonical control index
  20 after nine complete passing controls.
- **[SETTLED] Can a different `F_d` witness avoid replacement at the first
  failure?** No. The blocking obligation has exactly one `F_d` witness.
- **[SETTLED] Is the failure caused by a complicated non-deletion subtree?**
  No. The unique successor itself lies in `F_del`.
- **[OPEN — C80] What projectively natural lineage or charge makes the
  replacement rewrite well-founded without reducing back to defect
  cardinality alone?**
- **[OPEN — C80/C82 gate] Can that enriched rewrite be made
  opponent-complete and then counted uniformly in q?**

## Vibe

This is a clean, useful negative: the elegant inclusion-ranked mechanism
dies early and for one irreducible reason, while the underlying rank descent
remains strong. The frontier is narrower now—explain one-for-many
obligation replacement, rather than search for another shell.

go C80 cap extract a projective lineage/charge for the first q23 replacement edge
