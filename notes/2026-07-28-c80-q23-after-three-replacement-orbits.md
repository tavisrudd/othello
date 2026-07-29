# C80 — q23 replacement exhaustion after three marked orbits

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-28.
Canonical status: `2026-07-25-c80-status-ledger.md`.

## Verdict

There is no fourth marked replacement orbit in the remaining canonical
q23 P-control corpus. After quotienting the three complete
12,144-element marked `PGL_2(23)` orbits, the deterministic sweep
exhausts controls 88 through 162 without finding a necessary
replacement witness outside their disjoint 36,432-key union.

The remaining-domain counts are:

```text
canonical controls:                 75  (indices 88--162)
outer opponent fibres:           8,703
outer reply candidates:        579,404
outer F_d edges:                92,110
outer F_del edges:              92,100
necessary replacement witnesses:    10
Type I witnesses:                     0
Type II witnesses:                    4
Type III witnesses:                   6
new marked orbits:                     0
```

Every one of the ten replacement witnesses was independently
reconstructed by the Python bitmask engine, its three defect loci were
replayed by the separate affine-determinant reference, and its marked
key lay in exactly one known orbit. All ten therefore inherit the
previously certified injective causal ancestry: no half-move creates
two defects, no creator lacks an old defect label, and no transported
label collides with a retained label.

Together with the cumulative predecessor sweeps, this closes the finite
q23 orbit census for necessary replacement witnesses: exactly three
marked projective orbits occur, governed by two local boundary-failure
mechanisms. It does not prove the same classification for another
field or a uniform odd-q charged-survivor theorem.

## Structural consequence

The q23 data no longer support searching for another local replacement
type. The finite mechanism dictionary is complete:

1. **endpoint degradation:** the opponent-created replacement inherits
   the opponent's old label after one endpoint of its former
   `B_small` certificate is killed;
2. **certificate-reply deletion:** the reply-created replacement
   inherits the reply's old label after the certificate reply is killed
   on a secant through a selected pivot. The pivot may be the current
   opponent or an earlier outer-exchange point.

The next theorem-shaped target should therefore forget the three orbit
representatives and prove this causal dichotomy directly from the
unique former `B_small` certificate. It must show that the causal
half-move carries an old defect label, creates at most one replacement,
and does not reuse a retained label. Combined with ordinary strict
deletion, that would make ancestral support a genuine well-founded
charge. Opponent-complete entry into the charged family is still
required before C82 can count reply fibres.

## Exact searched domain

The search uses the C54 canonical q23 P-reply order. It starts at the
third orbit's first representative, zero-based control 88, and
exhausts the final control, index 162. Within each control the Rust
backend enumerates every outer opponent, every legal outer reply, and
every necessary `F_d` replacement witness in lexicographic order.

The stop condition was the first necessary replacement witness outside
the first three marked orbits, or exhaustion of all remaining controls.
Exhaustion occurred. The conclusion is restricted to this normalized
q23 control domain and the established `F_d`/`F_del` conventions.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello/rust
```

Commands:

```text
python3 scripts/c80_q23_after_three_replacement_orbits.py
python3 scripts/c80_q23_after_three_replacement_orbits.py --check
```

The wrapper recompiles
`scripts/c80_q23_replacement_sweep_backend.rs` with
`rustc --edition 2021 -O -C target-cpu=native`. The Rust engine
constructs the q23 projective lines and performs the bounded-memory
line-load sweep. Python independently reconstructs every emitted
replacement witness, replays the defect loci with the affine
determinant reference, constructs all three marked `PGL_2(23)` orbit
sets, asserts their pairwise disjointness, and requires the ten
witnesses to partition into their union. `--check` regenerates the
certificate in a temporary directory and requires byte equality.

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_after_three_replacement_orbits.py` | 13,592 | `553e58ecd3af76ad488f57633e027f1f0b22f471472afae79add4ee68d840f70` |
| `rust/scripts/c80_q23_replacement_sweep_backend.rs` | 13,613 | `54e90ad41bc16fc8b9a78cec3b07240b565e0ac8cd176c706b64eb796963629b` |
| `notes/2026-07-28-c80-q23-after-three-replacement-orbits.json` | 29,619 | `1f4f2d54dd35c796655d3c18087d1af4750cd32355012eb8da9779be1408d5f9` |

The certificate proves only the stated finite exhaustion. The
correctness boundary still includes the established normalized grid
model and the prior certificates defining the three orbit
representatives.

## `ej` + `tt` closeout

The cheap extra value is stronger than another passing orbit: q23 has
no later orbit at all. Three geometric orbits collapse to two causal
mechanisms, so the next proof should classify how one half-move can
destroy a unique `B_small` certificate rather than reproduce the orbit
census symbolically.

The Tao-style correction is to preserve the quantifier and ownership
structure. A selected secant pivot explains certificate destruction,
but it does not own the transported charge; the causal half-move does.
The uniform lemma must define the new-defect-to-old-label map first and
prove it injective, then use incidence to classify endpoint loss versus
reply loss. Orbit finiteness at q23 is evidence for that lemma, not a
substitute for it.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] Does a fourth marked replacement orbit occur later in the
  canonical q23 corpus?** No. Controls 88--162 are exhausted.
- **[SETTLED] Does delayed branching, collision, or an unlabelled
  creator occur at q23?** No. Every remaining witness belongs to a
  previously certified injective orbit.
- **[SETTLED] Is a third local boundary-failure mechanism needed at
  q23?** No. The complete three-orbit corpus uses endpoint degradation
  or certificate-reply deletion.
- **[OPEN — C80] Why must certificate destruction create at most one
  replacement and inherit a consumed old label over arbitrary odd
  q?** The finite incidence flags suggest the causal dichotomy, but no
  uniform proof exists.
- **[OPEN — C80/C82 gate] Does the charged survivor have
  opponent-complete entry and update fibres uniformly?** The q23
  census certifies the local replacements, not global coverage.

## Vibe

Excellent finite closure: the anticipated fourth-orbit falsifier never
appears, and the entire remaining q23 corpus compresses to the two
known causal mechanisms. The route is now cleaner but also at its real
proof boundary—more q23 enumeration has essentially no value unless it
is used to prove the incidence-level charge lemma.

go C80 cap prove the two-mechanism injective causal-charge update uniformly
