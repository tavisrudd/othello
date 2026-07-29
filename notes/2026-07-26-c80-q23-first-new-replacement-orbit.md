# C80 — first projectively new q23 replacement orbit

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-26.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

**Correction (2026-07-28):** the first marked orbit used for contrast
below also deletes its certificate reply; it additionally deletes one
boundary endpoint. Thus this orbit is a pure reply-deletion instance,
while the first orbit is simultaneous reply and endpoint deletion.
The charge and terminal-shell certificates here remain valid. See
[`2026-07-28-c80-two-mechanism-falsifier.md`](2026-07-28-c80-two-mechanism-falsifier.md).

## Verdict

The first q23 replacement edge outside the known marked
`PGL_2(23)` orbit still has injective ancestral charge and a bounded
projective causality flag. It is genuinely new: the replacement is created
by the reply half-move, not the opponent half-move, and it destroys the
unique boundary reply rather than a boundary endpoint.

The first new marked orbit occurs at:

```text
control index:       22
history reply:       (7,10)
outer exchange:      (14,13) -> (15,2)
target defect rank:  34
target Omega:        69
```

Its unique blocking obligation and sound lower-rank reply are

```text
(16,18) -> (20,17).
```

The opponent move reduces defect rank `34 -> 2` without creating a defect.
The reply creates the sole new defect `(9,16)`, removes both remaining old
defects, and leaves rank one. The successor is in `F_del`.

Assign the new defect the old label of its causal reply `(20,17)`. That
reply was itself one of the 34 old defects. Ancestral support drops
`34 -> 1`; branching is one, there is no retained-label collision, and the
other 33 root fibres have ordinary deletion witnesses. Thus the charged
root closes `34/34`.

## New bounded causality flag

Immediately before `(20,17)` is played, `(9,16)` has exactly one
`B_small` certificate:

```text
(9,16) -> (8,20),
Legal = {(6,14),(13,7)}.
```

The reply `(20,17)` kills the certificate reply `(8,20)` on the newly
saturated secant through the opponent `(16,18)`:

```text
(16,18), (20,17), (8,20) are collinear,
line = [1:4:4].
```

Both boundary endpoints remain legal. This contrasts with the first marked
orbit, where the boundary reply survived but one endpoint was killed.

At the rank-one successor, the replacement defect has the unique rank-zero
reply `(13,7)`, one of the old boundary endpoints. The resulting legal
locus is

```text
{(6,14),(11,9),(22,20)}.
```

It has a direct terminal-response star:

```text
(6,14)  <-> (22,20) <-> (11,9).
```

The two leaves conflict because they are collinear with the selected old
endpoint `(13,7)`. Hence every move has a terminal mate, proving the shell
P without a Grundy or minimax query.

This supplies a second bounded lineage type:

1. **endpoint degradation** — the boundary reply survives but its
   two-point boundary loses an endpoint;
2. **certificate-reply deletion** — the boundary endpoints survive but the
   unique boundary reply is killed.

For a unique certificate these are the two elementary ways the certificate
can fail after a half-move. The computation has one projective type of each;
it does not prove that later replacements always have a unique certificate.

## Exact searched domain

The deterministic sweep resumes immediately after the second reported
replacement edge on zero-based control index 20. It follows the C54
canonical P-control order and lexicographic outer-opponent, outer-reply,
blocking-obligation, and sound-reply order.

Each necessary replacement witness is encoded by its selected projective
state, marked opponent and reply, new-defect set, and retained-defect set.
The full 12,144-element marked orbit of the first replacement type is
precomputed and skipped. The search stops at the first key outside it.

Before stopping:

```text
outer opponent fibres:                288
outer reply candidates:            18,821
outer F_d edges:                     2,688
outer F_del edges:                   2,685
necessary replacement witnesses:         3
known-orbit witnesses skipped:           2
```

The result makes no claim about later marked orbits, other q23 roots,
extension fields, or uniform odd q.

## Soundness and trust boundary

The primary checker reconstructs the canonical target with the normalized
q23 bitmask engine, verifies the marked-orbit exclusion, complete defect
evolution, unique causal certificate, secant incidence, rank-zero response,
terminal three-move shell, and all 34 root fibres.

An independent affine-determinant implementation recomputes legality,
`Omega`, `B_small`, and `Def`. It agrees on all three complete defect loci,
the former boundary certificate, the three-move legal locus, and every
terminal response edge.

The certificate proves this finite root and its projective copies. A
uniform charged-survivor theorem still needs a bounded causal update for
every replacement edge and injectivity when several replacements coexist.

## Reproduction

Working directory:

```text
/home/tavis/src/othello/rust
```

Commands:

```text
python3 scripts/c80_q23_first_new_replacement_orbit.py
python3 scripts/c80_q23_first_new_replacement_orbit.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_first_new_replacement_orbit.py` | 22,137 | `0d62a09dfa17d15e4edf56f173bf9fad0e60fc2b2073b2400271c97ab8582e45` |
| `notes/2026-07-26-c80-q23-first-new-replacement-orbit.json` | 12,873 | `276103c81c898e32699089636459035944ed95f1ea881815417092aed8cfcc2a` |

The JSON is canonical sorted data. `--check` regenerates the full sweep and
certificate in a temporary directory and requires byte equality.

## `ej` + `tt` closeout

The cheap `ej` upgrade extracted more than a pass/fail ancestry verdict.
The new edge exposes the complementary local failure mode of a unique
`B_small` certificate and closes through a three-move terminal shell. This
turns two isolated examples into a proof-shaped two-case causality
taxonomy.

The Tao-style correction is to label a replacement by the causal
half-move—the first selected old defect after which it appears—not always
by the opponent. The first orbit transports the opponent label; this orbit
transports the reply label. The next falsifier should therefore test the
general causal-half-move rule, especially whether one causal old label can
create several new defects or whether a new defect can appear without a
consumed old-defect parent.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] Does ancestry survive the first new marked projective orbit?**
  Yes. The reply-created replacement inherits the reply's old label and
  support drops `34 -> 1`.
- **[SETTLED] Does branching or collision first appear here?** No: there is
  one new defect, no retained defects, and one surviving label.
- **[SETTLED] Does the original endpoint-transport flag recur unchanged?**
  No. The unique boundary reply is killed while both endpoints survive.
- **[SETTLED] Is there still a bounded direct P certificate?** Yes: a
  selected secant explains certificate deletion and a three-move terminal
  shell closes the successor.
- **[OPEN — C80] Does the causal-half-move ancestry rule survive the next
  marked projective orbit?**
- **[OPEN — C80] Can a later half-move create multiple replacement defects
  from one old label, causing branching?**
- **[OPEN — C80/C82 gate] Can the finite causality types be expressed as an
  opponent-complete bounded correspondence and counted uniformly?**

## Vibe

This is a stronger positive than another copy of the first flag: the route
survives a genuinely different projective type and reveals a coherent
second local mechanism. The main risk is now delayed branching, not the
absence of bounded causal geometry.

go C80 cap test causal-half-move ancestry on the next marked q23 replacement orbit
