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

## Transported shard-cover control

The public `css_distance_shard_ledger` now optionally transports a complete
raw-shard cover across an exact coordinate admission. It does not trust a
coverage JSON alone: it first replays every raw shard, reconstructs every
frontier commitment, and emits the ordinary source coverage. It then rechecks
both input fingerprints and both transported row spaces, independently replays
and maps any witness, and creates a separate target-bound transport record.

The retained LP1768 control uses four X shards through radius 14. Their exact
complete cover visits 109,087,599 candidates. The transport record maps the
negative verdict to Z with ranks 772/996 and no Z search. The independent
Python implementation separately reconstructs the four frontier commitments,
checks every evidence-file digest, recomputes both GF(2) row spaces, and returns
`status: verified`. Evidence is under
`ergodis-private/evidence/c985-lp1768-transport-control/`; its independent
checker is `ergodis-private/benchmarks/verify_css_transport.py`.

Evidence schema v7 also records a canonical semantic BLAKE3 over the coordinate
order, physical row space, and observable row space. It is independent of JSON
formatting, row order, and redundant checks. The control independently agrees
on X digest `7601a191...` and Z digest `95b5a696...`; the transport record binds
both. Raw input hashes remain alongside them for exact file replay. Legacy v6
shards remain readable but do not acquire semantic provenance retroactively.

To replay the transport control, regenerate both inputs with
`--maximum-weight 21`, build `css_distance_native` and
`css_distance_shard_ledger` with `--features large-css,parallel`, and create
four X records with `--maximum-weight 14 --shard-count 4`. Then run:

```sh
css_distance_shard_ledger "$WORK_ROOT"/x-[0-3].jsonl \
  --output "$WORK_ROOT/x-coverage.json" \
  --transport-source "$WORK_ROOT/lp1768-x.json" \
  --transport-target "$WORK_ROOT/lp1768-z.json" \
  --transport-admission \
    ergodis-private/evidence/c985-lp1768-transport-control/xz-admission.json \
  --transport-output "$WORK_ROOT/x-to-z-transport.json"

nix shell nixpkgs#python314 nixpkgs#b3sum --command python \
  ergodis-private/benchmarks/verify_css_transport.py \
  --source "$WORK_ROOT/lp1768-x.json" \
  --target "$WORK_ROOT/lp1768-z.json" \
  --admission \
    ergodis-private/evidence/c985-lp1768-transport-control/xz-admission.json \
  --coverage "$WORK_ROOT/x-coverage.json" \
  --transport "$WORK_ROOT/x-to-z-transport.json" \
  "$WORK_ROOT"/x-[0-3].jsonl

sha256sum -c \
  ergodis-private/evidence/c985-lp1768-transport-control/SHA256SUMS
```

This control also exposed an important historical provenance boundary. The
retained 32-shard radius-20 X cover is bound to input BLAKE3 `c94dc815...`,
whereas regenerating the documented maximum-weight-19 input from the pinned
QDistSAT revision and the committed importer produces `99782007...`. The old
input bytes were not retained, so exact source-bound transport correctly
rejects that historical cover. The raw shards and their coverage ledger remain
self-consistent, and this observation does not exhibit a wrong search verdict,
but the documented command does not reproduce their input byte identity.
Therefore no retroactive X-to-Z transport claim is made for the old radius-20
cover. The next radius-22 campaign will carry the new canonical semantic digest
and retain its exact generated input when licensing permits; it will supersede
the radius-20 cover.

## Boundaries and next move

The proposer presently compares physical Tanner presentations with equal
colour-partition sizes. Exact admission is more general than discovery: it
accepts any proposed coordinate bijection whose transported physical and
observable row spaces match, regardless of how it was found. A future proposer
may therefore canonicalize or search equivalent row presentations before
calling graph isomorphism without changing proof authority.

Highest EV is to run the remaining radius-22 exhaustion in the faster of the
two transported presentations and map the complete result across. The
transport ledger gate is now complete; the campaign must additionally retain
the exact generated input or semantic-input certificate so its source binding
survives future importer or serialization changes.
