# C465 — mod-3 Brauer bridge: Weil constituents, cross-sheet kernels, and the Golay module

**Context:** parallel and non-blocking; promoted from the crowns discovery track (the mod-3
nullities entry and the 2026-07-21 review synthesis). C450 closed the roof's module-isomorphism
clause sharp-negative in characteristic 0, but certified that the char-3 nullities of the two
`q=11` cross matrices are `6` (shared edge) and `5` (disjoint) — exactly the Gerardin Weil degrees
`(q+1)/2` and `(q-1)/2` — and that the char-0 descent obstruction is the central scalar `-1` on the
degree-6 half. C464 certifies the char-3 disjoint span as the perfect ternary `[11,6,5]` Golay
code. The classical automorphism group of that code in `SL_6(3)` is a double cover `2.M12` — a
group in which a central `-1` lives naturally. This card decides whether the roof holds one level
down: as a Brauer/modular statement realized by the Golay code.

## Inputs

- C450 bundle (`notes/2026-07-21-c450-weil-cross-sheet.md` and certificate/JSON) — cross matrices,
  modular rank table, char-0 module identifications, descent obstruction
- C464 bundle — certified spans, parity checks, and weight data of the perfect-code incidence spans
- C406 canonical matching-orbit certificate, pinned by SHA, as consumed by C450/C452
- C454 bundle (`notes/2026-07-21-c454-klein-cubic.md`) — method reference only for the modular
  decomposition machinery; no Klein-cubic content is load-bearing

## Task

At `q=11` over `F_3`, working with the frozen `PSL_2(11)` action on the two matching sheets:

1. Decompose the char-3 kernel and row span of each cross matrix (disjoint and shared-edge) as
   modular `PSL_2(11)`-modules: composition factors, socle/radical structure where determinable by
   direct computation, and Brauer characters.
2. Compute the mod-3 reductions of the two ordinary Gerardin Weil constituents (degrees 5 and 6,
   from C450's certified char-0 data) as Brauer characters, working in the double cover
   `SL_2(11)` where the central `-1` requires it.
3. Decide by explicit comparison whether the Golay span / kernel factors are the mod-3 reductions
   of the Weil pair — i.e. whether C450's sharp negative becomes a sharp positive at the Brauer
   level, with the central `-1` obstruction absorbed by the double cover.
4. Re-examine C450's descent obstruction modularly: state exactly what survives, dies, or descends
   mod 3, with a certificate.
5. Run the `q=7` control in the same pass: the analogous modular decomposition of both cross
   matrices in the characteristic where C464's Hamming span lives (`F_2`), decomposed under the
   frozen `PSL_2(7)` action, with the same reduction comparison against C450's `q=7` char-0 data.

Deliver a C450-style atomic bundle: dated report, exact generator/checker, canonical JSON with all
Brauer characters, decomposition matrices actually computed, and comparison verdicts, checksum
manifest, and an independent replay.

## Boundaries

- `2.M12` and `M11`/`M12` maximality are framing, not load-bearing citations: every module fact
  used in a verdict is computed directly on the frozen actions (compute, never recall). Certifying
  the full automorphism group of either code is C464's pre-allocation-gated symmetry successor,
  not this card.
- No new char-0 claim: the C450 sharp negative stands as certified; this card only decides the
  modular statement.
- The verdict sentence must state its level explicitly ("as `F_3 PSL_2(11)`-modules" /
  "as Brauer characters of the double cover"), never an unqualified "the roof holds".
- The discriminator caution from the controller applies: no T2-style restriction pass may be cited
  as positive Weil evidence without the `SL_2` central-character discriminator.
- Incidental observations get one discovery-log entry each; no card expansion.
