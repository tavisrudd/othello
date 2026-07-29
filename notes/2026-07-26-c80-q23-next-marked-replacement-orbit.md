# C80 — next marked q23 replacement orbit

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-26.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

**Correction (2026-07-28):** the advertised two-mechanism taxonomy is
superseded. This orbit remains a valid certificate-reply-deletion
instance with both endpoints surviving; the original Type I deletes
both its reply and one endpoint. See
[`2026-07-28-c80-two-mechanism-falsifier.md`](2026-07-28-c80-two-mechanism-falsifier.md).

## Verdict

The next q23 replacement edge outside the first two marked
`PGL_2(23)` orbits again has injective causal-half-move ancestry. It
creates one replacement from one consumed old-defect label, has no
ancestry collision, and drops ancestral support `23 -> 1`.

The new marked orbit occurs at:

```text
control index:       88
history reply:       (14,13)
outer exchange:      (15,2) -> (16,18)
target defect rank:  23
target Omega:        45
```

Its unique blocking obligation and sound lower-rank reply are

```text
(7,10) -> (20,17).
```

The opponent reduces defect rank `23 -> 2` without creating a defect.
The reply creates the sole new defect `(9,16)`, removes both remaining
old defects, and lands at rank one in `F_del`. The replacement inherits
the reply's old ancestral label, so support drops `23 -> 1`; branching
is one and no retained label collides with it. The other 22 root fibres
have ordinary strict-deletion witnesses.

## Third marked orbit, two local mechanisms

This marked state/opponent/reply flag is outside the two known
12,144-element projective orbits. Its local boundary failure refines,
rather than enlarges, the two-mechanism taxonomy:

1. **endpoint degradation:** the boundary reply survives and one
   endpoint is killed;
2. **certificate-reply deletion:** both endpoints survive and the
   unique boundary reply is killed on a selected secant.

The new orbit is the second mechanism with a different temporal role
for the secant pivot. Immediately before `(20,17)` is played, the new
defect has the unique certificate

```text
(9,16) -> (8,20),
Legal = {(6,14),(13,7)}.
```

Playing `(20,17)` kills `(8,20)` on line `[1:4:4]` through the already
selected point `(16,18)`. In the preceding marked orbit that pivot was
the current opponent; here it was selected by the outer exchange.
Thus the bounded projective formula should say “the causal reply
saturates the certificate-reply secant with a selected pivot,” without
requiring that pivot to be the immediately preceding move.

At the rank-one successor, `(13,7)` is the unique rank-zero reply. The
remaining legal locus

```text
{(6,14),(11,9),(22,20)}
```

has terminal-response graph a three-vertex path, with degree sequence
`1,1,2`. Hence every move has a terminal mate and the shell is P
directly, without a Grundy or minimax query.

## Exact searched domain

The deterministic sweep starts at zero-based canonical q23 control 22,
quotients the two previously certified complete marked
`PGL_2(23)` orbits, and follows the C54 canonical P-control order and
lexicographic outer-opponent, outer-reply, blocking-obligation, and
sound-reply order. It stops at the first necessary replacement witness
outside their union.

Before stopping:

```text
completed controls:                 66  (indices 22--87)
outer opponent fibres:           7,763
outer reply candidates:         515,858
outer F_d edges:                 82,118
outer F_del edges:               82,106
necessary replacement witnesses:     12
known-orbit witnesses skipped:        10
  Type I:                              6
  Type II:                             4
```

The result makes no claim about later marked orbits, other q23 roots,
extension fields, or uniform odd `q`.

## Rust backend and trust boundary

The original Python sweep accumulated unbounded recursive caches and
was killed after about eleven minutes. Cython would accelerate its
inner loops but preserve that memory architecture. The completed
certificate instead uses a standalone Rust line-load engine, fresh for
each canonical control. On control 22 it reproduces the two known
replacement witnesses and completes in about 3.4 seconds.

The Rust backend constructs all `q^2+q+1` projective lines directly,
recomputes legal moves, `B_small`, `Def`, `F_d`, and `F_del`, and emits
only necessary replacement witnesses. The Python checker independently
reconstructs the stopping target using the established normalized
bitmask engine, requires exact agreement on all witness fields, and
then uses the separate affine-determinant reference engine for the
three complete defect loci, former boundary certificate, and terminal
shell.

The certificate proves this finite root and its projective copies. A
uniform charged-survivor theorem still needs injective causal ancestry
for every replacement and an opponent-complete bounded projective
update.

## Reproduction

Working directory:

```text
/home/tavis/src/othello/rust
```

Commands:

```text
python3 scripts/c80_q23_next_marked_replacement_orbit.py
python3 scripts/c80_q23_next_marked_replacement_orbit.py --check
```

The wrapper compiles the Rust backend with
`rustc --edition 2021 -O -C target-cpu=native`.

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_next_marked_replacement_orbit.py` | 27,337 | `c18f3df9d269562d4a86e2cef5c2dd8f6acecf5943796563a89a3169c559397c` |
| `rust/scripts/c80_q23_replacement_sweep_backend.rs` | 13,613 | `54e90ad41bc16fc8b9a78cec3b07240b565e0ac8cd176c706b64eb796963629b` |
| `notes/2026-07-26-c80-q23-next-marked-replacement-orbit.json` | 31,305 | `cb2d4ebcd2105bd9c0e71285f5203785b2cfa20e963325d6f241b3be0f2cd836` |

The JSON is canonical sorted data. `--check` recompiles the Rust backend
in a temporary directory, regenerates the complete sweep and
certificate, requires byte equality, and leaves the worktree unchanged.

## `ej` + `tt` closeout

The cheap `ej` upgrade identifies the new orbit's real extra value:
projective orbit novelty does not imply a third local causal mechanism.
The certificate-reply deletion flag is stable after replacing “current
opponent pivot” by “any already selected pivot.” This is a strictly
cleaner bounded incidence formula and absorbs both reply-created
examples.

The Tao-style correction is to distinguish the transported ancestral
label from the auxiliary secant pivot. The causal reply supplies the
old label; the pivot only witnesses how its move destroys the former
certificate. Conflating those roles would incorrectly make the earlier
orbit look special and would obscure the natural projective update.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] Does causal-half-move ancestry survive the next marked
  projective orbit?** Yes. The causal reply owns an old defect label,
  and support drops `23 -> 1`.
- **[SETTLED] Does branching, collision, or an unlabelled creator first
  appear here?** No: there is one replacement, no retained old defect,
  and one surviving ancestral label.
- **[SETTLED] Is a third local certificate-failure mechanism needed?**
  No. This is certificate-reply deletion with a pre-existing selected
  secant pivot rather than the current opponent.
- **[SETTLED] Is there a bounded direct P certificate?** Yes: 22 strict
  deletion fibres plus one lineage fibre, followed by a three-move
  terminal-response path.
- **[OPEN — C80] Does injective causal ancestry survive the next marked
  orbit after quotienting all three complete projective orbits?**
- **[OPEN — C80/C82 gate] Can the two local mechanisms be assembled into
  an opponent-complete uniform charged survivor?**

## Vibe

Good momentum: the first far-out orbit arrives only at control 88 and
strengthens the bounded causal formula instead of breaking it. The
remaining risk is still delayed branching or an unlabelled creator;
finite q23 orbit passes do not yet supply the uniform update theorem.

go C80 cap quotient all three marked replacement orbits and test the next for branching or an unlabelled creator
