# C466 — Dickson mechanism for the mod-40 fusion law and the q=31 convergence checks

**Context:** parallel and non-blocking; promoted from the crowns discovery track (the Dickson `S4`
entry, the `(2/q)` mechanism entry, and the 2026-07-21 review synthesis). C453 certified the exact
mod-40 fusion law (visible split classes `11,19,21,29`; fused `1,9,31,39`), and the fused classes
are exactly `(2/q)=+1`. C445 certified that the sheet-gluing hinge is an `S4` with determinant
kernel the common `A4`. Dickson's classical criterion places `S4` inside `PSL_2(q)` iff
`q = ±1 mod 8`, i.e. iff `(2/q)=+1`. Candidate mechanism: the sheets fuse exactly when the hinge
`S4` descends into `PSL_2(q)`. Since mod 40 is the conductor of the biquadratic field
`Q(sqrt2, sqrt5)`, a positive verdict upgrades the certified law to a splitting-law statement:
visibility of the golden sheets at `q` is the Frobenius class of `q` in
`Gal(Q(sqrt2, sqrt5)/Q)` — split in `Q(sqrt5)` governs sheet existence, split in `Q(sqrt2)`
(the octahedral spin field; C444's cubic scalar is `2 sqrt2`) governs their fusion.

## Inputs

- C445 bundle — the certified gluing hinge `S4`, its `A4` determinant kernel, and frozen sheet
  data at `q=11`
- C453 bundle (`notes/2026-07-21-c453-continuation-laws` report/certificate) — the mod-40 law,
  the 19/31 split data, and the forced `12+20` marker-shadow orbit split at 31
- C442/C444 frozen conventions for sheet construction at new split primes
- C451 bundle — only if acceptance item 4 is attempted: the theta/Arf machinery and its frozen
  definitions
- C395 bundle — only for acceptance item 5: the certified `A5` stabilizer of the `t=-1` six-arc
  in characteristic 31

## Task

1. **Visible primes (`q=11` and `q=19`):** construct the hinge `S4` at each prime under the frozen
   conventions and certify that its image meets `PSL_2(q)` exactly in the common `A4` — i.e. the
   full hinge does not descend — and that no `PSL_2(q)` element conjugates one sheet to the other
   (re-deriving C453's PSL-distinctness through the mechanism, not merely citing it).
2. **Fused prime (`q=31`):** certify that the hinge `S4` lies inside `PSL_2(31)` and exhibit an
   explicit hinge element of `PSL_2(31)` conjugating one sheet to the other, so the certified
   fusion is realized by the hinge itself. Optional replication at `q=41` (class 1 mod 40) if
   cheap; state explicitly if skipped.
3. **Mechanism verdict and framing:** state whether sheet fusion is equivalent to hinge-`S4`
   descent at every tested prime. Dickson's criterion is consumed as a computed check (subgroup
   presence/absence certified directly), not a citation. On a positive verdict, record the
   biquadratic reading — fusion law = Frobenius in `Gal(Q(sqrt2, sqrt5)/Q)`, conductor 40 — as the
   framing statement for Phase 3, including the already-certified aligned faces (C451 Arf parity =
   parity of `(q+1)/4` = `(2/q)`; C450's `det Rz = 2` outer swap).
4. **Secondary — Arf face at 19 and 31:** if the C451 machinery transfers directly to the new
   split primes, compute the invariant-origin Arf parity (predicted odd at 19, even at 31). If it
   does not transfer without new conventions, stop and record the blocker; do not improvise.
5. **Secondary — the two characteristic-31 `A5` controls:** compare the conjugacy/orbit data of
   C453's golden marker shadow in `PSL_2(31)` with the `A5` induced by C395's six-arc in
   `PGL_3(31)` (via its conic/dual action). "Order-level coincidence only, no natural map found
   within the tested comparisons" is a valid close; state the exact comparisons run.
6. **Tertiary — Weil-normalization Gauss-sum face:** at any new split prime this card constructs
   (preferring one `q = 1 mod 4` case: 29 visible or 41 fused), compute the T8 Weil--Weyl
   normalization scalar in C455's frozen sense and test the prediction `rho(w) = gamma(q) F` with
   `gamma(q) = +1` for `q = 1 mod 4` and `i` for `q = 3 mod 4` (Gauss-sum/Weil-index reading; see
   the discovery-track entry). Bounded: reuse the C455 machinery as-is; if it does not transfer
   without new conventions, record the blocker and stop.

Deliver an atomic bundle: dated report, exact generator/checker, canonical JSON with all subgroup
certificates, conjugators, and verdicts, checksum manifest, and an independent replay.

## Boundaries

- A failed mechanism check at any prime kills the mechanism reading only; the certified C453 law
  is untouched and must not be re-litigated.
- No construction or continuation claim beyond C453's scope; no `H4` parent claims. The
  `H4`/600-cell/`q=31` gateway probe (C417 sibling forecast) requires its own conventions freeze
  and stays a named pre-allocation-gated successor of this card.
- The biquadratic statement is framing over certified endpoint checks; no class-field-theoretic
  machinery is load-bearing and none is cited as proof.
- Manuscript and `papers/` are read-only; incidental observations get one discovery-log entry
  each, no card expansion.
