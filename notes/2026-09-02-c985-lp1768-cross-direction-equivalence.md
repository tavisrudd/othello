# LP1768 X/Z exact coordinate equivalence

**Date:** 2026-09-02  
**Task:** C985  
**Status:** accepted reusable proposer, exact verifier, and independent replay

## Result

The official LP1768 X- and Z-distance instances are the same exact CSS search
problem up to a coordinate permutation. A coloured-Tanner-graph isomorphism
backend proposed a bijection of all 1,768 coordinates. Ergodis independently
verified that it transports:

1. the physical row space, of rank 772; and
2. the physical-plus-logical observable row space, of rank 996.

Consequently every zero-syndrome support, every nonzero-observable support,
every bounded-distance verdict, and every witness transports in both
directions. In particular,

\[
d_X=d_Z.
\]

The previously established interval therefore becomes one common interval
`22 <= d_X = d_Z <= 24`. Only one direction needs the remaining radius-22
exhaustion; its verdict and any witness map exactly to the other direction.

This is not an assumption from the external graph tool. The graph tool has
proposal authority only. Exact admission compares canonical binary row bases
after the proposed coordinate permutation, and independently rejects a
non-bijection, a physical-space mismatch, or an observable-space mismatch.

## Reusable implementation

Public Ergodis now exposes `verify_css_coordinate_equivalence` and the optional
`css_isomorphism_adapter` binary. The cold adapter can invoke nauty/dreadnaut on
two equally sized coloured physical Tanner presentations or consume a retained
backend-neutral proposal. It emits a create-only, source-fingerprinted
admission record only after the exact row-space checks pass. The solver hot
loop is unchanged.

The adapter is also a concrete evolve proposer pattern: an external specialist
proposes a structural transport, a bounded neutral artifact separates proposal
from proof, and a reusable exact kernel admits it. Cross-instance equivalence
is distinct from self-automorphism discovery and can eliminate an entire solve
rather than merely reducing its roots.

## Evidence

- `ergodis-private/evidence/c985-lp1768-xz-isomorphism-proposal.json` is the
  complete 1,768-coordinate backend proposal.
- `ergodis-private/evidence/c985-lp1768-xz-isomorphism-admission.json` is the
  exact Ergodis admission record.
- `ergodis-private/benchmarks/verify_css_isomorphism_admission.py` independently
  reconstructs the sparse matrices as Python integers, checks the permutation,
  computes both GF(2) row spaces with a separate eliminator, and verifies the
  recorded ranks and source fingerprints.
- `ergodis-private/evidence/c985-lp1768-xz-isomorphism-SHA256SUMS` binds the
  proposal, admission, independent checker, and public adapter source.

The source matrix SHA-256 values and pinned upstream QDistSAT revision remain
those recorded in `notes/2026-09-01-c985-qdist-lp1768-bounds.md`. The generated
inputs used here have BLAKE3 fingerprints
`99782007c5cf5e680bb4457e8b88b552a308cc7c09da9c24358d9c5014a035ad`
(X) and
`12f680e1ed04f425c99fe243ac0a7391d2f82431dcbab50260ac06a18169269f`
(Z); both fingerprints are embedded in the proposal and admission.

## Replay

Use a disk-backed work directory; `/tmp` is tmpfs on the development host.

```sh
QDIST_ROOT=/path/to/QDistSAT
WORK_ROOT=/path/to/disk-backed/lp1768-equivalence
REV=9fb224b0fa372161fb3933034016bc8dc423a5ab

git -C "$QDIST_ROOT" checkout "$REV"
cargo build --manifest-path ergodis-private/Cargo.toml --bin qdist_to_ergodis
cargo build --manifest-path papers/complete-repair-ports/ergodis/Cargo.toml \
  --bin css_isomorphism_adapter

for direction in x z; do
  ergodis-private/target/debug/qdist_to_ergodis \
    --stem "$QDIST_ROOT/data/LP2/LP_1768_224_?" \
    --direction "$direction" --maximum-weight 19 \
    --upstream-revision "$REV" --discover-symmetry \
    --out "$WORK_ROOT/lp1768-$direction.json"
done

nix shell nixpkgs#nauty --command \
  papers/complete-repair-ports/ergodis/target/debug/css_isomorphism_adapter \
  --source "$WORK_ROOT/lp1768-x.json" \
  --target "$WORK_ROOT/lp1768-z.json" \
  --proposal-out "$WORK_ROOT/xz-proposal.json" \
  --output "$WORK_ROOT/xz-admission.json"

nix shell nixpkgs#python314 nixpkgs#b3sum --command python \
  ergodis-private/benchmarks/verify_css_isomorphism_admission.py \
  "$WORK_ROOT/lp1768-x.json" "$WORK_ROOT/lp1768-z.json" \
  "$WORK_ROOT/xz-admission.json"

sha256sum -c ergodis-private/evidence/c985-lp1768-xz-isomorphism-SHA256SUMS
```

Replaying the retained proposal through `--proposal-in` produced a
byte-identical admission record without invoking nauty. The independent Python
replay returned coordinate count 1,768, physical rank 772, observable rank 996,
and status `verified`.

## Boundaries and next move

The proposer presently compares physical Tanner presentations with equal
colour-partition sizes. Exact admission is more general than discovery: it
accepts any proposed coordinate bijection whose transported physical and
observable row spaces match, regardless of how it was found. A future proposer
may therefore canonicalize or search equivalent row presentations before
calling graph isomorphism without changing proof authority.

Highest EV is to run the remaining radius-22 exhaustion in the faster of the
two transported presentations and map the complete result across. Before that
long run, compile the admitted permutation into the shard/evidence ledger so a
reviewer can replay the transport rather than trusting this memo.
