# C61: finite-state reply automaton

Date: 2026-07-10.

## Verdict

**NEGATIVE for the declared defect/interface/zone quotient.** The coarse finite state table has
many forced-reply conflicts, and six conflicts survive the strongest tested refinement: the full
normalized-coordinate state used by C36. Each conflicting row is a genuinely forced N node
(exactly one Grundy-zero child), not merely a different choice among several winning replies.

The six strict collisions are all q=17 versus q=19. Thus the current q-blind state alphabet cannot
emit one common reply-action class at those states. The missing coordinate is order-sensitive
interface/zone arithmetic: the conflict set includes both live-conic and conic-empty states, so
adding only `Psi`, conic xor, or a conic-emptying flag cannot repair the table.

This does **not** prove that every finite-state uniform strategy is impossible. It refutes this
specific state/action quotient and localizes exactly where a successor must refine it. A successor
may use a q-dependent realization rule or a richer incidence type; it cannot be the requested plain
lookup table on the tested defect/interface/zone summaries.

Because the conflict branch fired, C61's adversarial-replay gate was not applicable. Replay is
required only for a conflict-free automaton. Exact solver values already certify the stronger fact
used here: every C38 node in the obstruction table has exactly one winning reply.

## Corpora and semantics

- C63 steering rows: one exact selected P reply for every `(P parent, opponent move)` obligation in
  all five q=13 and all ten q=17 full-PGL Grundy roots (`3,144 + 1,052,204` rows). Collisions here
  measure variation of that fixed tablebase/Z selector; they are not impossibility certificates,
  because unrecorded alternative P replies may exist.
- C38 forced rows: every exact N node with exactly one P child in q=9 `[1,2,3,4]`, q=13
  `[1,2,3,4]`, all ten q=17 full-PGL roots, and q=19 `[1,2,3,4]`
  (`5 + 353 + 487,302 + 815,846` rows). The two extra q=17 C31 score-9 roots are deliberately
  excluded so overlapping states are not double-weighted. Collisions in this corpus are genuine.
- q=23 has no complete exact Grundy/forced-node artifact. Its existing early-break `s4xormine`
  witnesses do not establish uniqueness and therefore cannot strengthen or repair the forced
  contradiction. No new q=23 solve was launched.

The state map has four nested refinements:

```text
L0  conic xor-zero; defect component/path/odd/max/sum-square summaries;
    intruder/end-point/isolate interface summaries; zone parity and q-bucketed slack
L1  L0 + ply + live-on-conic count
L2  L1 + normalized root t4
L3  L2 + full C36-style normalized selected-cell signature
    (C<t> for an on-conic parameter, O<r>:<c> for an intruder)
```

For C63 obligations the opponent geometry is included and the L3 cell signature is the parent plus
the opponent move. For C38 the row already is the post-opponent forced N state.

The reply action records reply geometry, coarse changes to the conic defect/interface, live-conic
change, zone-change bucket, conic-emptying, and (where available) whether C63's `Psi` decreases.
The state alphabet permits the observed transient `Z ~= 40` regime: it makes no small-Z assumption
and buckets reservoir slack by q rather than imposing a fixed zone ceiling.

## Conflict census (verbatim)

```text
C61 corpus=steering level=0 rows={13: 3144, 17: 1052204} states=502 conflicts=461 cross_q_states=41 cross_q_conflicts=36 max_actions=20
C61 corpus=steering level=1 rows={13: 3144, 17: 1052204} states=652 conflicts=579 cross_q_states=6 cross_q_conflicts=5 max_actions=20
C61 corpus=steering level=2 rows={13: 3144, 17: 1052204} states=3950 conflicts=3406 cross_q_states=7 cross_q_conflicts=6 max_actions=16
C61 corpus=steering level=3 rows={13: 3144, 17: 1052204} states=957987 conflicts=0 cross_q_states=0 cross_q_conflicts=0 max_actions=1
C61 corpus=forced level=0 rows={9: 5, 13: 353, 17: 487302, 19: 815846} states=197 conflicts=156 cross_q_states=131 cross_q_conflicts=120 max_actions=11
C61 corpus=forced level=1 rows={9: 5, 13: 353, 17: 487302, 19: 815846} states=383 conflicts=273 cross_q_states=181 cross_q_conflicts=164 max_actions=11
C61 corpus=forced level=2 rows={9: 5, 13: 353, 17: 487302, 19: 815846} states=1822 conflicts=1170 cross_q_states=134 cross_q_conflicts=123 max_actions=10
C61 corpus=forced level=3 rows={9: 5, 13: 353, 17: 487302, 19: 815846} states=1303486 conflicts=6 cross_q_states=20 cross_q_conflicts=6 max_actions=2
C61-DONE out=s4-dumps/2026-07-10/c61/quotient.json
```

L3 has 20 forced states shared across orders; six (30%) demand different forced action classes.
There are no within-q L3 collisions.

## Six minimal strict conflicts

All roots are `t4=1,2,3,4`. `live a->b` is the live-conic change under the unique winning move.

| ply | normalized selected state beyond the root | q=17 unique reply | q=19 unique reply |
|---:|---|---|---|
| 8 | `O0:8 O9:7 O12:15 O15:16` | `(16,4)` internal, live `1->0` | `(7,11)` on-conic, live `1->0` |
| 8 | `C15 O0:16 O8:3 O12:0` | `(11,15)` internal, live `2->0` | `(13,8)` external, live `2->2` |
| 8 | `C6 C16 O9:15 O10:7` | `(11,14)` on-conic, live `1->0` | `(5,2)` internal, live `1->0` |
| 8 | `O9:7 O10:11 O11:3 O14:0` | `(8,14)` external, live `1->0` | `(7,12)` internal, live `1->0` |
| 8 | `C11 C13 O10:0 O15:15` | `(7,3)` internal, live `0->0` | `(8,16)` external, live `0->0` |
| 9 | `O0:3 O7:4 O8:2 O11:12 O16:7` | `(9,10)` external, live `0->0` | `(17,14)` internal, live `0->0` |

Representative exact keys, in table order:

```text
q17 025dd4a00b28e326c7951a3c7ff898da  q19 00c263ec46e510b5f501f45a828cdbbb
q17 0166459ef18bc610b94ac7c9550ad7fb  q19 03b521c1be96d752d44482fe55cbcb60
q17 00ba2ab8ea5d38de7d7ade04c544eb8c  q19 000b0424a44dfda5f71a1dc1d7c0375b
q17 047840f9b4450098855df0f96febfd83  q19 03f56b48f65fd811b7fc7a7e3532c9b2
q17 02f9a6ee42d66964e127dc5141da9c4c  q19 02e81497a4ed5ef1ee31be2bf0a9dc1e
q17 020854e72a4e0d9b795fb0e98e730526  q19 01b604d7fcaf844bf07747fed3d8b202
```

The second row is the sharpest obstruction: the same normalized state needs a conic-emptying
internal reply at q=17 but a non-emptying external reply at q=19. This cannot be fixed by treating
all three geometries as interchangeable or by requiring every reply to decrease live conic.

## Reproduce

```bash
python3 -m py_compile rust/scripts/c61_reply_automaton.py
cd rust
python3 scripts/c61_reply_automaton.py
```

The machine-readable output is
`rust/s4-dumps/2026-07-10/c61/quotient.json` (ignored bulk-data tree, reproducible from the exact
C38/C63 artifacts). The durable analyzer is `rust/scripts/c61_reply_automaton.py`.

## Route consequence

Do not promote the tested quotient to a Good-closure lemma. Keep `Psi` as the target charge—every
recorded C63 selected transition still decreases it—but refine the *selector state* at the six
forced q=17/q=19 collisions. The smallest honest next question is whether one order-sensitive
interface coordinate (for example the actual zone conflict orbit of the forced reply, rather than
row/column summaries) separates all six. A conflict-free refinement would then re-enter C61's
adversarial replay gate; the current table does not.
