# C294 B3 E1: relevance and parity ledger

**Date:** 2026-07-18  
**Lane:** `crowns`  
**Status:** E1 passes the preregistered headroom gate for a typed-square E2 pilot; E1-P closes as a bounded parity negative

## Result

The frozen q=3 control and q=5 type-0 prefix have been replayed without increasing either state
cap. The instrumented solver reproduces every predecessor traversal invariant:

| domain | started connected evaluations | completed evaluations audited | incomplete ancestors at stop | decompositions | absolute quotient classes | follower nimber |
|:--|--:|--:|--:|--:|--:|--:|
| q=3 `(2,3,4)` | 108 | 108 | 0 | 680 | 49 | 1 |
| q=5 `(2,4,5)` | 100,000 | 99,981 | 19 | 1,946,240 | 84,964 | unknown |

The distinction between started and completed q=5 evaluations is load-bearing. The fixed exception
is raised after the 100,000th evaluation starts; it unwinds through 19 incomplete ancestors. E1
assigns no value, outcome, or parity record to those ancestors.

The typed-square word coordinate has sufficient **maximum possible** q=5 headroom to justify E2.
After splitting every candidate class by all known exact nimbers, its 84,964 absolute classes leave
55,883 value-refined classes. This permits at most 29,081 removals, or 28,138 beyond the 943 known
labelled-core isomorphism removals. The q=3 control is exact at this static layer: 49 classes remain
49 with no value conflict.

The static q=5 coordinate is not itself a quotient. Its raw 28,505 classes contain value conflicts;
the first emitted witness has nimbers 4 and 2. E2 must start from the typed square words and refine
by the scar transition grammar independently of value labels. The displayed 28,138 is only
headroom, not a predicted reduction or replacement theorem. It nevertheless clears the fixed 850
preflight gate by a wide margin, so `R` remains open and routes next to E2 rather than E3.

Two deliberately coarser controls delimit that decision. The local-defect motif has enormous
value-refined headroom but already conflicts on q=3 and is too coarse to select. The sweep-boundary
profile has 5,300 genuine-removal headroom on q=5 but also conflicts on q=3. The typed-square word
histogram is therefore the only preregistered candidate that combines a clean q=3 control with
adequate q=5 headroom.

## Search-DAG and xor relevance

Across the 99,981 completed q=5 evaluations, E1 audits 2,642,325 legal move requests. They produce
579,837 distinct option nimbers, so 2,062,488 moves add no new mex bit at their parent. The exact
children themselves are all distinct in the fixed Cayley labelling; the redundancy is in option
values and transposed/component evaluation, not duplicate one-ply residual masks.

Component splitting occurs in 1,946,130 audited options and emits 5,423,680 exact xor terms.
Among them, 854,566 are zero-nimber garbage and 2,031,594 nonzero terms cancel in equal-value pairs;
380,551 emitted banks xor to zero. These figures explain why the exact separator/component kernel
remains relevant as garbage collection even though its global quotient stalled. They do not imply
that P/N labels compose: every displayed cancellation uses exact nimbers.

The 84,964 completed absolute classes contain 11,031 high-cycle classes still handed to the generic
exact kernel. Spatially, no completed residual uses more than 13 of the 16 certified E0 ports. The
audit sees 9,535 distinct nonempty `(cut, live-port-word)` records. Thus the width-16 transfer
direction has nontrivial repeated boundary data, but E1 does not promote transfer ahead of the
typed quotient.

## E1-P bounded negative

The move-labelled and distinct-exact-child ledgers agree at the first transition of every completed
state: no two legal vertices emit the same labelled child mask. This removes duplicate moves as the
source of the observed first-step parity.

For the full move-labelled terminal polynomial, every terminal independent set of cardinality
`k` contributes all `k!` move orders. Over `F_2`, every coefficient of degree at least two therefore
vanishes by factorial pairing. Only the one-move coefficient can survive; exactly one completed
state in each domain has odd one-ply terminal count. This is the preregistered trivial cancellation,
not a game-value law.

Parity of P-children also fails to characterize outcome. In q=5, 43,708 N-states have an odd
number of P-children, but another 36,640 N-states have an even number, while all 19,633 P-states
have zero P-children. The q=3 control has the same obstruction: 29 of 56 N-states have even
P-child count. No local charge, odd-reply theorem, or response involution emerges from the frozen
features. E1-P therefore closes at this feature set; it does not promote a parity algebra or expand
the feature palette.

## Exact conventions and trusted boundary

The input generator independently reconstructs generator colours, determinant sheets, the `02`
pair blocks, alternating positions, and the same deterministic greedy block order used by E0. The
primary C++ solver is the recursive-separator kernel with one added completed-evaluation hook and a
post-run audit. Postprocessing is required to leave connected-state and quotient-class counts
unchanged.
The source also exposes a compile-time no-main guard for the E2 offline checker; the standalone E1
entry point and every emitted E1 computation are unchanged.

Candidate headroom is defined as

```text
84,964 - number of distinct (candidate coordinate, exact nimber) pairs,
```

then reduced by the 943 already known isomorphism removals. This is the strongest possible
class reduction compatible with observed values; transition closure can only split it further.

The independent Python replay rebuilds the coloured graph and greedy `02` order without importing
the primary canonicalizer. It checks the fixed-prefix counts and the 19-state stop convention,
recomputes the first repeated boundary word, independently evaluates every component in the first
small xor witness by direct Node--Kayles recursion, and checks the 850 headroom decision. It does
not independently reproduce all 2.64 million option requests or the full candidate partitions;
those aggregate counts remain inside the exact C++ traversal/canonicalization trusted boundary.

The computation is deterministic and uses no random seed. It does not prove typed-grammar closure,
an exact quotient, a q=5 follower value, a response strategy, or a transfer theorem. It generates
no state beyond the existing q=3 completion and q=5 100,000-state prefix.

## Replay

From `/home/tavis/src/othello` with GCC 14.3.0 and Python 3.13.12:

```sh
g++ -O3 -std=c++20 -Wall -Wextra -Werror -fno-access-control \
  notes/2026-07-17-c294-b3-relevance-ledger.cpp \
  -o /tmp/c294-b3-relevance-ledger
python3 notes/2026-07-17-c294-b3-relevance-ledger-input.py --q 3 --type 0 \
  | /tmp/c294-b3-relevance-ledger 1000000 1000000 \
      /tmp/c294-b3-relevance-ledger-q3.json
cmp /tmp/c294-b3-relevance-ledger-q3.json \
  notes/2026-07-17-c294-b3-relevance-ledger-q3.json
python3 notes/2026-07-17-c294-b3-relevance-ledger-input.py --q 5 --type 0 \
  | /tmp/c294-b3-relevance-ledger 100000 1000000 \
      /tmp/c294-b3-relevance-ledger-q5.json
cmp /tmp/c294-b3-relevance-ledger-q5.json \
  notes/2026-07-17-c294-b3-relevance-ledger-q5-100k.json
python3 notes/2026-07-17-c294-b3-relevance-ledger-replay.py \
  notes/2026-07-17-c294-b3-relevance-ledger-q3.json \
  notes/2026-07-17-c294-b3-relevance-ledger-q5-100k.json \
  /tmp/c294-b3-relevance-ledger-replay.json
cmp /tmp/c294-b3-relevance-ledger-replay.json \
  notes/2026-07-17-c294-b3-relevance-ledger-replay.json
sha256sum -c notes/2026-07-17-c294-b3-relevance-ledger.sha256
```

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-b3-relevance-ledger.cpp` | 28,806 | `126f73d3a199a5b84256d5d25106cde9803cf9ee862faddc97bd39f00f412010` |
| `2026-07-17-c294-b3-relevance-ledger-input.py` | 2,068 | `429ab182531aa86da5427d6b0d670b2060d540f66c4a1c17b4f33443059a5221` |
| `2026-07-17-c294-b3-relevance-ledger-replay.py` | 7,180 | `97cf9dfb7b14fe5f5559ce4d53bca7c0cee95befe4c637cc5ec4aac539732329` |
| `2026-07-17-c294-b3-relevance-ledger-q3.json` | 2,737 | `9947297b9e1e166ba6c393c27b1e0f8799e55d56fe56ad6a26c660ad9d4baedc` |
| `2026-07-17-c294-b3-relevance-ledger-q5-100k.json` | 3,154 | `fd039a4964de7288e31cf712e7844e88ad9b4af48d0d21eda29242a7e3c94ed4` |
| `2026-07-17-c294-b3-relevance-ledger-replay.json` | 529 | `9d0bc18a420b861338efb151770d13b004ba40cd347d05bc00a3535b9a8ebdec` |

## Next gate

Proceed to E2 with the typed `02` square-word coordinate, exact detached xor bank, generator colour,
determinant sheet, square orientation, and third-colour port incidence. Construct the least
transition-stable partition without using nimber labels. Stop on the first value conflict after
closure, and promote to live integration only if at least 850 removals beyond known isomorphisms
survive. E3 remains queued behind that decision; the transfer solver, larger cap, and all-seven run
remain closed.
