# C80 — strict-overload positive-mate-surplus closure

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

The proposed positive-mate-surplus closure passes every requested finite
gate:

| domain | accepted roots | exact P roots | positive states | certified response edges | `B_cc` states visited |
| --- | ---: | ---: | ---: | ---: | ---: |
| frozen q13 escape roots | 5/5 | 5/5 | 32 | 355 | 241 |
| frozen q17 escape roots | 5/10 | 5/10 | 1,839 | 23,284 | 29,903 |
| marked q19 control `{15,16,17,18}` | 1/1 | 1/1 | 2,501 | 31,210 | 22,895 |

At q17 the new survivor again accepts exactly the five P roots and rejects
all five N roots. The q19 control remains certified.

The pass does **not** advance the uniform crown. The `tt` closeout exposes a
general redundancy: positive mate surplus is already forced by the defining
quantifiers of the strict-overload survivor. Thus this test was guaranteed to
pass wherever the existing `F_cc` certificate passes. It is a useful
implementation regression and closes the proposed `μ` refinement, but it is
not the missing nonrecursive marked-edge predicate.

## Definition and exact redundancy

For a position `S`, let

```text
μ(S) = min_x |Legal(S+x)|,
```

where `x` ranges over legal moves. At overload zero, retain the structural
copycat boundary `B_cc`. At positive overload, define `F_μ` recursively by:

```text
μ(S) > 0
and
for every legal opponent x
there is a legal reply y with Ω(S+x+y) < Ω(S) and S+x+y in F_μ.
```

Terminal `B_cc` positions remain admissible; no `μ` condition is imposed on
the boundary.

This apparently strengthens `F_cc`, but in fact

```text
F_μ = F_cc
```

at every order and on every residual game, not merely on the finite
certificates. The reverse inclusion `F_μ⊆F_cc` is immediate. For the forward
inclusion, induct on `Ω`. If `S∈F_cc` and `Ω(S)>0`, the `F_cc` response clause
already supplies a legal reply after every legal opponent move. Therefore
`μ(S)≥1`; its strict targets lie in `F_μ` by the induction hypothesis. The
overload-zero clauses are identical.

Equivalently, every nonterminal P-position has positive mate surplus: after
any move, the resulting N-position must have a move back to P. Here the
stronger direct observation is enough—the survivor's own `∀x∃y` clause
already contains the mate.

## Finite certificate

The generator independently reconstructs `F_μ` rather than copying the old
response map. It uses `B_cc` at `Ω=0`, enforces `μ>0` at every accepted
positive state, and recursively searches every marked opponent fibre for a
strict lower accepted reply.

The accepted positive-state `μ` minima are:

```text
q13: 1
q17: 1
q19: 1
```

The deterministic certificates use positive targets of mate surplus one
22 times at q13, 620 times at q17, and 2,106 times at q19. Most chosen edges
absorb directly into `B_cc` (324, 21,834, and 27,752 respectively). Hence
even as finite evidence the result supplies no quantitative surplus margin:
the closure repeatedly runs at the exact integer floor.

The search also evaluates many rejected speculative fibres (5,799 at q17
and 5,993 at q19). Those are not counterexamples to the accepted survivor;
they show only that arbitrary strict replies need not preserve the
certificate. The result remains existential in the reply.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_positive_mate_surplus_closure.py
python3 rust/scripts/c80_positive_mate_surplus_closure.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_positive_mate_surplus_closure.py` | 13,617 | `937b4a292faa5366585806f37f7903f284f42a19fc5cdb9f2caeaf0387b74f58` |
| `notes/2026-07-25-c80-positive-mate-surplus-closure.json` | 10,928 | `6ee6e27194ab2e640204bda1edda0445da3317c05e3ab0fecef2a5b21729dffe` |

The output is canonical sorted JSON. `--check` regenerates it in a temporary
directory and requires byte equality. Inputs are the committed q13/q17 frozen
row corpus and the committed adaptive-copycat survivor implementation; their
hashes are embedded in the certificate.

The mate-count implementation is cross-checked at a minimum-surplus state at
each order by direct projective determinant tests, independently of the
cached `legal_mask` count. All three checks give `1=1`. Exact root values use
the established normalized grid solver. `Ω`, `B_cc`, and the fixed q19 root
retain their earlier trust boundary; there is no second full projective-plane
implementation.

The finite computation certifies only the listed domains. The equality
`F_μ=F_cc`, by contrast, is a direct induction from the two definitions and
does not depend on those domains.

## `ej` + `tt` closeout

The cheap `ej` upgrade records the whole chosen-target surplus histogram and
adds determinant-level checks at the exact `μ=1` bottleneck in every tested
order. This rules out a hidden positive quantitative margin in the finite
pass: the certificate genuinely uses the weakest possible positive surplus.

The Tao-style correction is more important. `μ>0` looked like a new
geometric reservoir coordinate because it separates the five repairs from
the 106 spoilers. But once the target family is already defined by
`∀ opponent ∃ certified reply`, positive mate surplus is a logical shadow of
that quantifier, not an independent incidence invariant. Recursive closure
therefore prices the desired answer into the definition exactly as the
earlier filtered Tutte excess did.

The next admissible target must be a proof-producing edge predicate stated
without lower-survivor membership. It must explain why a marked secant reply
is good using direct incidence and then prove opponent-complete coverage.
Neither `μ>0` alone nor `μ>0` recursively intersected with `F_cc` can do
that.

No incidental discovery-track item arose. The redundancy and its exact proof
are direct C80 deliverables.

## Mystery ledger

- **[SETTLED] Does strict-overload positive-mate-surplus closure pass the
  certified DAG gates?** Yes: 5/5 q13 roots, exactly 5/10 q17 roots, and the
  marked q19 root.
- **[SETTLED `tt`] Is this a stronger survivor than `F_cc`?** No.
  `F_μ=F_cc` by induction on `Ω`; the positive-surplus clause is already
  implied by the existing opponent-complete response clause.
- **[SETTLED `ej`] Is there a hidden quantitative surplus margin?** No in the
  tested certificates. Every order uses accepted positive states and chosen
  targets with `μ=1`.
- **[SETTLED] Did `μ` explain the spoiler/repair split structurally?** It
  diagnoses it but does not certify it. The spoilers have `μ=0`, while the
  repairs have positive `μ`, yet recursive preservation merely restates the
  survivor response condition.
- **[OPEN — C80] What nonrecursive marked incidence predicate proves a reply
  good?** The evidence gap is unchanged: construct a direct secant/orbital
  certificate whose soundness does not call `F_cc`, `K_Ω`, minimax, or a
  filtered reply graph.
- **[OPEN — C80/C82 gate] Can that predicate be proved opponent-complete
  uniformly in odd q?** Unknown; C82 remains gated.

## Vibe

The finite result is cleanly positive, but mathematically it is a useful
tautology detector rather than progress on the crown. That is still valuable:
it prevents another recursive coordinate from masquerading as geometric
compression and leaves the next proof obligation much sharper.

go C80 cap construct a nonrecursive opponent-complete marked-secant edge certificate
