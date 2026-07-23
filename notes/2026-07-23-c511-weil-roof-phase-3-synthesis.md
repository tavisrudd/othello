# C511 — Weil-roof Phase-3 synthesis

**Lane:** `crowns`

**Date:** 2026-07-23

**Verdict:** `PAPER 2 GO, WITH A REVISED MODULAR-GATEWAY ROOF; ORIGINAL METAPLECTIC/THETA ROOF NO-GO`

## Executive decision

The frozen Weil-roof battery supports a mechanism sequel.  Its paper-level spine is

```text
pointed matching geometry
  -> cross-incidence code pair
  -> perfect-code core
  -> simple endotrivial Lagrangian
  -> unique nonsplit self-dual carrier.
```

The abstract seven-gate Modular Gateway Theorem is proved, both geometric rows at `q=7,11`
satisfy every gate, and the `q=23` binary Golay row proves that the carrier mechanism extends even
when the exceptional degree-`q` permutation-sheet bridge does not.  This is enough for a coherent
Paper 2 built around a theorem, two geometric realizations, and one sharp carrier-only boundary.

The original stronger roof does not survive.  The frozen signed six-space is not a genuine Weil
module; the invariant quadratic/Maslov-refinement route dies at its first kill-switch; and the
literal Witt/Maslov index of the signed central word is zero.  Paper 2 must not claim that the six
Rosetta incarnations are images of one proved metaplectic or theta object.

The adopted local characteristic-eleven model sharpens the first layer without repairing that dead
roof.  The divided odd Fourier operator is contracted by the depth plane and becomes projectively
rigid after adding its valency metric and ordered target flag.  C526 proves that C412's natural
source Tate pairings occupy the orthogonal flag orbit, not this rigid nonorthogonal target orbit.
Paper 2 therefore states the contraction and the exact non-isometry boundary together.

This is an internal manuscript-allocation decision, not a novelty or priority verdict.  External
claims about the modular-gateway construction, Picard-core codes, or the carrier mechanism require
a claim-specific literature audit before drafting.

## Frozen Rosetta classification

The candidate rows are exactly the six listed in the motivating conversation report.  `PROVED`
means a structural theorem now identifies the row and its relation to the common outer torsor.
`CHECKED` means the exact frozen finite cases have independent certificates, but no larger-family
theorem is claimed.  `DEAD` means the proposed row fails as a detector of the bit.

| Candidate incarnation | Phase-3 class | Exact disposition |
|:--|:--|:--|
| design polarity | **CHECKED** | At `q=7,11` the certified nonsquare-determinant outer elements swap the two matching sheets and intertwine cross-disjointness with its transpose, equivalently `D <-> -D`.  This is an exact `C2`-torsor leg in the frozen cases, not a family theorem. |
| QR perfect-code outer symmetry | **CHECKED** | The Hamming and ternary Golay flags are literally `D=<1>+S`, `S=D^perp`, and their frozen sheet swap is the same outer torsor.  At `q=23` the endotrivial carrier survives but the degree-23 `PSL_2(23)` permutation-sheet bridge is impossible; hence the frozen row is certified while the uniform-permutation reading is dead. |
| `mu_3` sign / low-degree threshold | **PROVED** | The signed moments satisfy `mu_1=mu_2=0`, `mu_3!=0`; `mu_3` is fixed by `PSL_2(q)` and negated by the outer coset, and cubic degree is minimal in the stated moment sense.  The later residue-only attempt does not give a convention-free formula at both primes, but that negative does not weaken the cubic detector theorem. |
| cocycle / advice complexity one | **PROVED** | The section obstruction, one-bit selector cost, and free orientation torsor are three functors of the single determinant-sign torsor `[T_q]`.  The cost is exactly one bit and vanishes exactly when the torsor class is trivial. |
| Frobenius / spin prime | **PROVED** | A pointed sheet canonically chooses a split prime through the trace rule; sheets, unipotent classes, period factors, split primes, and lower-Weil constituents form one free `C2` torsor.  The characteristic-zero `S3`-resolvent `Spec Q(sqrt5)` realizes the same torsor and reduces at 11 with Galois swap equal to the outer swap. |
| theta parity on the Roquette curve | **DEAD** | Arf parity is identical on the two sheets at each frozen prime, so it cannot detect their orientation.  The stronger secondary repair also fails on the frozen signed carrier: every invariant quadratic refinement is outer-even, and the central signed word has Witt/Maslov class zero. |

The paper-facing Rosetta table therefore has five live rows.  Theta parity belongs in the adjacent
failure/erasure boundary, not as a padded sixth incarnation.  The table should retain the
`PROVED`/`CHECKED` distinction; five honest rows are stronger than six rows with one dead detector.

## What the five live rows do and do not share

The surviving common object is the orientation torsor

```text
[T_q] = sgn : PGL_2(q) -> C2.
```

Design polarity and QR-sheet exchange are certified realizations of this torsor in the frozen
finite geometries.  The cubic tensor is its minimal signed moment.  The section obstruction and
one-bit selector are functorial images of the same class.  The split-prime dictionary gives its
arithmetic realization, with the `Q(sqrt5)` resolvent supplying a characteristic-zero row.

This does **not** identify the torsor with the modular carrier class

```text
alpha in Ext^1_G(S_q^*,S_q).
```

The torsor is presentation/orientation data; `alpha` is coefficient-valued group cohomology.
A pointed sheet constructs both in sequence, but projectivizing the nonzero Ext line erases the
orientation.  The unpointed carrier has one coarse nonsplit isomorphism class and cannot recover
the cubic sign, residue prime, or sheet.  The Ext carrier is consequently the roof's mechanism,
not a sixth Paper-1 Rosetta avatar of the same bit.

## Paper-2 architecture

### GO spine

1. **Odd carrier layer.**  State the abstract Modular Gateway Theorem and prove its incidence,
   local-Picard, fusion-descent, and rigidity gates.
   Immediately afterward, give C433+C526 as the local `q=11` model: square-zero divided Fourier,
   depth-selected contraction, valency/flag rigidity, and the source-Tate flag-orbit obstruction.
2. **Two geometric realizations.**  Present the binary Hamming `q=7` and ternary Golay `q=11`
   matching sheets, their distinct Sylow normal forms, and their common unique-Ext conclusion.
3. **Sharp extension boundary.**  Use `q=23` to show that the carrier-side theorem extends to the
   11-dimensional binary Golay core while the exceptional degree-`q` permutation-sheet packaging
   does not.  This also proves that `m=(q+1)/4` is decorative rather than load-bearing.
4. **Even phase layer.**  Present the order-12 Hadamard degeneration complex, Golay
   kernel/image, puncture/shorten maps, and the separately proved local-split/global-nonsplit
   signed gluing theorem.
5. **Orientation and information loss.**  Use the trace-prime torsor and the carrier moduli
   quotient to state exactly which markings survive each passage.

This odd-carrier/even-phase division keeps the two positive mechanisms adjacent without asserting
an unproved comparison class between them.

### Required no-go clauses

- No uniform `q`-family of matching-sheet carriers is asserted.
- No genuine same-space six-dimensional Weil action is asserted for the frozen signed carrier.
- No invariant quadratic/Maslov refinement recovers the outer bit on that carrier.
- No Witt index interpretation of C472's central scalar is asserted.
- No equality is asserted between the determinant-sign torsor and the Ext class.
- No novelty wording is released before the bounded literature audit.

### Editorial rank

The revised sequel is a **go** as a focused mechanism paper.  The flagship is the
perfect-code-to-endotrivial-core-to-unique-carrier theorem, with the Hadamard degeneration and
global signed gluing as a second mechanism block.  It is not a go as the originally imagined
single-theta-object paper, and it should not wait for that dead roof to be repaired.

## Evidence closure

This synthesis introduces no new computational result.  Its load-bearing claims are citations of
hash-pinned, independently replayed bundles:

- C406 for cubic minimality and outer parity;
- C451 for the theta/Arf negative;
- C465/C471 for the code flag, carrier sandwich, and integral degeneration complex;
- C472 for the signed-lift negative and global-gluing replacement;
- C473 for the arithmetic orientation torsor;
- C474 main and modular-gateway companion for the exact Ext theorem and seven-gate criterion;
- C480 for design polarity, signed Fourier compatibility, and the residue-rule falsifier;
- C486/C487 for the one-torsor assembly and characteristic-zero realization;
- C488 for the `q=23` carrier/bridge split;
- C489/C501 for the quadratic/Maslov and Witt-bridge negatives.
- C433 for the local divided-Fourier contraction, valency metric, and ordered-target rigidity;
- C526 for the complete natural source-pairing inventory and orthogonal/nonorthogonal flag-orbit
  obstruction;
- C527 for the placement-ready theorem block and the exact mixed Lean/evidence boundary.

The source reports retain their exact replay commands, hashes, trusted boundaries, and
independent checks.  C511 makes no claim beyond their frozen domains.

## Explicit `ej` closeout

The cheap extra value is the separation of three decisions that had been entangled:

1. the Paper-1 Rosetta table survives with five honest rows;
2. the Paper-2 modular-carrier mechanism is strong enough to proceed;
3. the single metaplectic/theta roof is closed negative on the frozen carrier.

The `q=23` control sharpens the sequel rather than weakening it: it proves the group-side carrier
is more portable than the exceptional permutation geometry, so the correct abstraction is the
seven-gate carrier criterion, not the numerical `m` coincidence or a degree-`q` sheet family.
No further computation is needed to make the go/no-go decision.

## Mystery ledger

- **Settled — how many Rosetta rows survive.** Five survive; theta parity is dead and is removed
  from the positive table.
- **Settled — which surviving rows are theorem-level.** Cubic minimality, the one-bit torsor
  formulation, and the Frobenius/split-prime dictionary are `PROVED`; design polarity and the QR
  outer-symmetry row remain `CHECKED` at the exact frozen cases.
- **Settled — whether Paper 2 should proceed.** Yes, as a modular-gateway mechanism sequel with
  separate odd carrier and even phase layers.
- **Settled — whether the original roof survives.** No.  The signed Weil, invariant quadratic
  refinement, and literal Witt/Maslov routes are sharply negative on the frozen carrier.
- **Open but not blocking — external novelty.** The exact evidence gap is the claim-specific
  literature audit for the gateway construction and Picard-core interpretation; this is a
  drafting/release gate, not a reason to reopen Phase 3.
- **Open but not blocking — a comparison between orientation torsor and carrier class.** No
  comparison morphism is proved.  Any successor must construct genuine secondary data rather than
  infer an equality from the common outer swap.
- **Settled — the local source/target Tate comparison.** The natural source pairing space has an
  orthogonal ordered flag, whereas the rigid target flag is nonorthogonal.  This is a negative
  boundary, not a comparison morphism between the orientation torsor and carrier class.
- **No other C511 mystery remains.** The row dispositions, table size, sequel architecture, and
  go/no-go are fixed by the frozen evidence.
