# C80 — first uncompensated one-to-many causal replacement

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-29.
Canonical status: `2026-07-25-c80-status-ledger.md`.

## Verdict

The proposed field-uniform certificate-exchange nonpacking lemma is
false. The first deterministic scout at the first unexhausted prime
order produces an exact `q=11` counterexample: one old-labelled causal
reply creates two uncompensated defect fibres.

In residual `F_11^2` coordinates, let

```text
A = {(1,3),(5,2),(9,6),(10,1)},
o = (4,4),
h = (7,10).
```

Both `o` and `h` are distinct members of `Def(A)`. After the opponent
plays `o`,

```text
Def(A+o) = empty.
```

The reply `h` is legal, but

```text
Def(A+o+h) = {(0,5),(6,5)}.
```

Both points are genuinely new relative to the old and intermediate
defect loci. Thus the causal half-move `h` has two uncompensated
fibres, violating `|U_(A+o)(h)| <= 1`. A single causal label cannot be
transported injectively to both.

This is an explicit falsifier, not a finite negative or a value/minimax
classification. The conditional theorem from the preceding report
remains true: exchange nonpacking would imply injectivity. Its proposed
uniform hypothesis is what fails.

## Exact certificate exchange

Before `h` is selected, the two future defects have the following
`B_small` certificate fibres:

```text
z=(0,5): Cert_(A+o)(z) = {(2,9),(7,10)}
z=(6,5): Cert_(A+o)(z) = {(7,10)}.
```

After selecting `h=(7,10)`, both certificate fibres are empty.

The mechanism exposes an omitted local alternative in the preceding
secant-carrier statement. The same move `h` is itself an old
`B_small` certificate reply for both fibres. Selecting `h` consumes
that shared certificate in both fibres simultaneously. The remaining
certificate `(2,9)` for `(0,5)` is deleted on the secant through
`h`, `(2,9)`, and the selected pivot `(9,6)`. Hence this is not a
failure of immediate certificate repair after several unrelated
secant attacks; it is a two-to-one certificate-incidence collision
centred at the causal move itself.

The corrected local failure alternatives for an old certificate
`r in Cert_C(z)` after selecting `h` are therefore:

1. `r=h`, so the certificate reply is already selected;
2. `r!=h` becomes illegal on a new secant through `h`;
3. `r` survives legally, but `h` consumes a live endpoint of its
   two-point `B_small` boundary.

The earlier carrier lemma omitted alternative 1. The q23 replacement
representatives did not expose it.

## Independent replay

The primary normalized bitmask engine and the independent affine
determinant implementation agree exactly on

```text
Def(A)       = {(3,7),(4,4),(4,10),(6,0),(7,0),(7,10),(8,9)}
Def(A+o)     = empty
Def(A+o+h)   = {(0,5),(6,5)}.
```

Both implementations independently recompute legality, `Omega`,
`B_small`, every certificate reply in the two affected fibres, and
the empty replacement fibres. The determinant replay additionally
classifies the selected-reply collision and the secant deletion.

The witness was found on the first deterministic seeded legal path at
residual selected size four, with seed `80011`:

```text
(5,2), (9,6), (1,3), (10,1).
```

This provenance does not claim lexicographic minimality over all
`q=11` states or exclude a `q=9` witness. It certifies the displayed
counterexample over the prime field `F_11`.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello/rust
```

Commands:

```text
python3 scripts/c80_causal_one_to_many.py
python3 scripts/c80_causal_one_to_many.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_causal_one_to_many.py` | 9,641 | `3c324153e02c9ee92881f6815d8fe6727578204d4b09ab51497d8a6860cce67c` |
| `notes/2026-07-29-c80-causal-one-to-many.json` | 4,174 | `42501fea4df64a737bb3b0a234e1896a1b03fb41954fd90a2a28543b4ed924bc` |

The JSON is canonical sorted data. `--check` regenerates it in a
temporary directory and requires byte equality. The new script hashes
the load-bearing prior C80 implementation it imports.

The certificate proves only the displayed incidence/game-domain
counterexample. It does not determine the value of the surrounding
state, prove or disprove a global rematching survivor, search `GF(9)`,
or release C82.

## `ej` + `tt` closeout

The cheap `ej` gain is that strict cardinality surplus and causal
one-label transport are now visibly different. Across the full
exchange, seven old defect labels disappear and only two new defects
appear, so this witness has ample global label surplus even though the
local causal-label update branches. The failed theorem was too local,
not obviously too weak in total resources.

The Tao-style replacement object is the bipartite incidence graph

```text
old labelled moves  --  B_small certificate fibres,
```

with newly emerged certificates supplying exchange edges. A causal
move may have certificate codegree greater than one—the witness has
codegree exactly two—so per-move nonpacking is unavailable. The
remaining plausible theorem is a global Hall-type rematching or
ancestral-support surplus across a complete opponent/reply exchange:
match every genuinely new defect to a distinct consumed ancestral
label, with strict total support descent. Its update must be
projectively natural and must not list a growing matching explicitly.

This is a real reshaping, not a proof of that successor. The immediate
next discriminator is to formulate the global consumed-label/new-defect
incidence relation and either prove its Hall surplus from certificate
exchange or extract the first support-deficit set.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED negative] Is `|U_C(h)|<=1` field-uniform?** No. The
  displayed `q=11` causal reply has two uncompensated fibres.
- **[SETTLED] What creates the first branching?** The causal move is
  itself a shared old certificate reply for both fibres; its selection
  consumes both copies, and one fibre's other reply is killed on a
  secant.
- **[SETTLED correction] Was the previous certificate-failure
  trichotomy complete?** No. It omitted the self-consumption case
  `r=h`.
- **[SETTLED for this witness] Does total ancestral cardinality still
  have surplus?** Yes: seven old defects versus two genuinely new
  defects across the exchange.
- **[OPEN — C80] Does a global, projectively natural Hall/rematching
  surplus hold uniformly?** Not proved or disproved.
- **[OPEN — C80/C82 gate] Can such a rematching datum be entered
  opponent-completely from every escape root?** Not proved.

## Vibe

This is a clean and useful falsifier. It kills the local one-label
repair crown much earlier than expected, at `q=11`, while preserving a
credible global-surplus route. The next move should change the proof
object, not patch the false nonpacking bound.

go C80 cap prove global consumed-label Hall surplus and strict support descent, or extract the first support-deficit set
