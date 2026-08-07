# C834 — the association algebra's three native decisions, closed symbolically

**Lane:** `clebsch` · **Task:** C834 (Paper IV full Lean release closure) · **Date:** 2026-08-06

## What was closed

`PassantCodeQ13.AssociationAlgebra` carried the last three native decisions of the Paper IV package
that the association-transport packet had already made redundant: the binary ranks 42, 36, 36, 36 of
the four elliptic relation matrices, the square of the relation of polar invariant zero as
`I + A9 + A10 + A12`, and the squaring cycle `A9² = A10`, `A10² = A12`, `A12² = A9`. All three now
carry only the foundational axioms.

None of the three needed a new finite search over the polar invariant. The packet had already
identified each relation's displayed row masks with its semantic Boolean adjacency matrix by
exhaustive kernel reduction over the 6084 ordered pairs of internal points, and had already
kernel-reduced the squaring identities on those masks. What was missing was the identification of the
algebra module's own executable presentation — relation rows computed by a bit-setting fold, and the
triple-loop matrix product — with the mask presentation. Both identifications are symbolic here.

## The two bridges

The reusable step is that a list of 78 masks whose set bits all lie below 78 is determined by the
Boolean matrix it presents. Given that, an executable list is identified with a displayed one by
showing that the two present the same matrix, which is a statement about entries rather than a
computation over lists.

- **Relation rows.** The bits of a fold that sets bit `index` for each index below `count` at which a
  predicate holds are exactly that predicate below `count` and zero above it. Applied to
  `relationRow`, this says the computed row masks present `relationBooleanMatrix`, which the packet's
  kernel-reduced entry certificates already identify with the displayed masks. Hence
  `relationMatrix v = relationRowsRho…` for each of the four invariants, with no evaluation of the
  polar invariant.
- **The product.** The same fold description gives the bits of a triple-loop product row, and
  tabulating a function of a bounded index is mapping it over the list of those indices, so the
  triple-loop product presents the Boolean parity product that `maskMatrix_maskProduct` already
  identifies with the word-parallel product of row masks. The rows of a word-parallel product vanish
  wherever every row of the right-hand factor vanishes, which supplies the bit bound on that side.

Entrywise addition needed no bridge at all: `xorFour` is iterated `maskXor` and `identityMatrix` is
`identityMasks 78`, both by definitional unfolding, so the two squaring theorems reduce literally to
the packet's kernel-reduced mask certificates.

Only the ranks are computed here, by kernel reduction of the echelon insertion on the displayed
masks — the same shape and scale as the four minimum-word orbit ranks, and far below the measured
per-module ceiling.

## Where the declarations live

The three theorems keep their names and their `PassantCodeQ13.AssociationAlgebra` namespace, so the
tracked axiom audit is unchanged, but they moved to a new module
`PassantCodeQ13.AssociationAlgebraIdentities`. The definitions module sits upstream of
`PassantCodeQ13.AssociationTransport.Base`, so a proof consuming the mask presentation cannot live in
it. `PassantCodeQ13.Gates.Main` imports the identities module in place of the definitions module,
which it reaches transitively.

`PassantCodeQ13.AssociationTransport`'s header no longer discloses native evaluation in its import
closure, because there is none: the three leaves it named were the only ones, and they are gone.

## Validation

Both gates are green under

```sh
lean/scripts/lean-build-queue.py build PassantCodeQ13.Gates.Main PassantCodeQ13.Gates.AxiomAudit \
  --lean-root /home/tavis/src/othello/papers/q13-passant-code/lean-certificates \
  --profile single --threads 1 --cores 20-23
```

`PassantCodeQ13.Gates.Main` rebuilt in 16 minutes at a 3.0 GB peak — the whole
association-transport packet and everything downstream of the definitions module re-elaborated —
and `PassantCodeQ13.Gates.AxiomAudit` in five seconds on top of it.

The audit reports 94 terminals: 56 carry only `propext`, `Classical.choice` and `Quot.sound`,
against 53 before this round, and 38 still carry a declaration-local native-evaluation axiom,
against 41. The three that moved are exactly
`PassantCodeQ13.AssociationAlgebra.relation_matrix_ranks`, `…rhoZero_square` and
`…rankThirtySix_squaring_cycle`.

`papers/q13-passant-code/verification/verify_evidence.py` passes, with the manifest digest of
`Gates/Main.lean` refreshed for its changed import.

## Package state after this round

The paper package's remaining native decisions are the weight-ten profile certificates, the
row-uniqueness transport, the structural upgrade, the automorphism anchors, and the fixed-point
exhaustion. The association algebra is off that list.
