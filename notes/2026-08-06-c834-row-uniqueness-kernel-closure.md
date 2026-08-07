# C834 — kernel closure of the row-uniqueness transport

**Date:** 2026-08-06 · **Lane:** `clebsch` · **Task:** C834 (Paper IV full Lean release closure)

## What this round settles

Stage 5 item 10 of the execution plan is closed. The row-uniqueness layer of the Paper IV package
carried nine compiled evaluations: seven residue shards of the seed-extension search, the geometric
rows' zero-triple-concurrence statement, and the agreement of the executable passant-join test with
the semantic one. All nine are now kernel-checked, and the whole search runs on displayed indices
and bit sets rather than on the internal-point subtype.

The plan's expectation for this stage was tabulation over the existing seven-way residue shard. What
the round actually needed was a change of representation, and with it a different search: the
certificate is no longer a check about finite sets of internal points but a check about increasing
lists of indices below `78`, and the enumeration it runs is a passant-clique search rather than a
scan of four-element extensions of a seed.

## The certificate

`PassantCodeQ13.MinimumWords.RowUniqueness.IndexCertificate` is the new module. It carries three
constructions, each a bit set packed into a natural number:

* `passantRowMask line`, the internal points of one displayed passant, read from the packed
  incidence table, together with `passantRowPoints line`, the same row as an increasing list;
* `passantJoinMask point`, the indices joined to a point by some passant, obtained as the union of
  the rows through that point — so it costs one pass over the `78` row masks, not a scan of the
  coordinate lists;
* `pairSupportUnion first second`, the union of the displayed minimum-word supports containing both
  indices. Its bit at a third index is set exactly when some support contains all three, so a
  vanishing bit is exactly zero triple concurrence. This is what replaces a concurrence count in
  every guard of the search.

An admissible seven-set, listed in increasing index order, is determined by its three least elements
together with four further elements, each above the previous one and joined to all the earlier ones.
`rowExtensionCheckAt` runs that search at one first index: the second and third elements range over
the join masks, a triple whose pair-support union already contains the third index is discarded, and
`extensionCheck` then extends four times, restricting the remaining pool at each step to the indices
joined to the index just chosen and discarding any index the pair-support union of the first two
selects. At depth four it requires a list on which no support carries three indices to be one of the
displayed rows.

`rowExtensionCheckAt_sound` states the implication in the form the semantic layer needs: for an
arbitrary increasing list of seven indices below `78` that is pairwise joined and has zero triple
concurrence on distinct triples, if every first index passes the check then the list is the point
list of a displayed passant row. Every guard of the search is implied by those hypotheses, which is
the whole content of the soundness proof; the search never enumerates seven-subsets of the index
range.

## Why the previous shape could not be reduced

The former certificate was stated over `Finset InternalPoint`. Deciding it in the kernel re-derives
the subtype universe, locates each point by scanning the displayed coordinate list through
`internalPointIndex`, and filters the powerset-like extension pool over that universe — the three
operations the package's own levers forbid inside a finite terminal. Restating the same search on
`Fin 78` and natural-number bit sets removes all three, and the semantic content moves into a
transport proof that runs once rather than once per candidate.

## Sizing, and where the memory goes

The search is small: over all `78` first indices it visits about `8500` extension nodes and reaches
exactly `78` leaves, one per passant row. Two measurements shaped the module layout.

Replacing the mask-valued pool by a list-valued one — each level filters the parent's list instead
of testing all `78` indices against a mask — cut both time and memory by about a third, because the
deep levels then range over at most six candidates.

Kernel memory is per declaration and is released between declarations, but it is not released
inside one. A single declaration covering a whole residue class exceeded the memory guard and was
killed, while the same eleven or twelve checks as separate declarations peak at the cost of one.
Each residue module therefore states one theorem per first index and combines them; the class
summary theorems keep their names, so the tracked axiom-audit surface is unchanged.

## The two transports

`geometric_rows_have_zero_triple_concurrence` is now proved from the blockwise kernel check that
already existed, `geometric_rows_have_zero_triple_signatures`, rather than recomputed. Two
elementary facts carry it: an increasing list contained in an increasing list is a sublist of it,
which puts three increasing indices of a row into the three-element sublists the check ranges over;
and the concurrence count is invariant under permuting its three arguments, which reduces an
arbitrary distinct triple to an increasing one.

`indexedPassantJoin_eq_true_iff` is proved from the displayed incidence dictionary and the
surjectivity of the displayed passant indexing. It is not a finite check at all: the executable test
scans the displayed passant indices and evaluates the same incidence form the relation uses.

## Validation

All modules elaborate without errors or warnings. The seven residue modules build in about a minute
each at a peak of 3.6 GB, well inside the serial profile's envelope. Both package gates are green
under

```sh
lean/scripts/lean-build-queue.py build PassantCodeQ13.Gates.Main PassantCodeQ13.Gates.AxiomAudit \
  --lean-root /home/tavis/src/othello/papers/q13-passant-code/lean-certificates \
  --profile single --threads 1 --cores 20-23
```

The axiom audit's 94 terminals now report 83 clean against 11 carrying a declaration-local
native-evaluation axiom, up from 69 clean. The fourteen that moved are the seven residue
certificates, the combined index check, the two transports, the new soundness theorem, the
admissible-seven-set theorem, the reconstructed-rows theorem, and the minimum-layer terminal of the
package gate that consumes them. The eleven that remain are the two weight-ten profile aggregates,
the two fixed-point exhaustion leaves, the three automorphism anchor leaves, and the four gate
terminals that consume them.

The paper's evidence verifier passes, with the manifest record for the axiom audit refreshed.

## Mystery ledger

* **An admissible triple is either collinear or has no admissible fourth point.** Of the 4186
  triples that are pairwise joined with zero triple concurrence, exactly 2730 — the collinear ones,
  seven points choose three per row — extend at all, and each extends by exactly the four remaining
  points of its row; the other 1456 have an empty pool. These counts come from the independent
  enumeration that sized the certificate, not from Lean, which proves only the conclusion that the
  admissible seven-sets are the rows. A structural proof of the two halves would remove the finite
  search from this layer altogether, so this is a lead worth an owner rather than a curiosity: it is
  settled numerically and open as mathematics.
* **The 78× reduction the equivariance layer would give is not taken.** The symmetric-square action
  is transitive on the internal points, so a single first index would suffice if the passant rows
  were known in Lean to be carried to passant rows. That statement — equivariance of the line and
  incidence structure, as opposed to the support family, which
  `PassantCodeQ13.Equivariance.SupportInvariance` already covers — is not formalized. The gap is
  exactly one missing transport, and the same transport would shrink other remaining leaves.
* Nothing else in this round is unexplained. Every other statement is either a bit-level identity, a
  consequence of the incidence dictionary, or a kernel-reduced check on displayed data.

## Two levers for the remaining leaves

* Kernel memory is released between declarations but not inside one. A check that exceeds the guard
  as a single declaration can fit as several declarations in one module at the peak of the largest.
  This is what made the residue shards viable without splitting them into 78 modules.
* A pool carried as a list, filtered from its parent at each level, is markedly cheaper than a pool
  carried as a bit mask tested against the whole index range, once the levels are narrow.
