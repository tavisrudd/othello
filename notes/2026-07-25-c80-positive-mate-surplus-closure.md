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

## `ej` follow-up — quantifier-shadow no-go and the C80→C82 interface

The mate-surplus equality is an instance of a reusable ranked-survivor
principle. Suppose

```text
F(S) ⇔ B(S)                                      at rank zero,
F(S) ⇔ ∀ opponent x, ∃ reply y, E(S,x,y) ∧ F(T)  at positive rank,
```

where every `E`-edge strictly lowers the rank. Let `Q(S)` be any property
obtained merely by forgetting information from those one-step witnesses:

```text
(∀x, ∃y, E(S,x,y)) ⇒ Q(S).
```

If `F_Q` is formed by adding `Q(S)` to the positive clause while retaining
the same recursive response condition and boundary, then rank induction gives

```text
F_Q = F.
```

Call such a `Q` a **quantifier shadow**. Positive mate surplus is the first
example: erase strictness and lower-survivor membership from the certified
reply and retain only joint legality. The same no-go automatically eliminates
minimum positive degree, absence of isolated marked fibres, and every other
binary “each opponent has some legal mate” reformulation as recursive
compressions of `F_cc`. They may diagnose failed candidate edges, but
intersecting them back with the survivor cannot strengthen or explain it.

This yields an exact release interface between C80 and C82. C80 must first
define a nonrecursive, algebraically checkable marked-edge predicate
`E_q(S,x,y,z,z')` carrying an explicit proof datum `z` to a lower-ranked datum
`z'`, and prove its soundness without `F_cc`, `K_Ω`, minimax, or a filtered
reply graph. Only then is the C82 abundance object meaningful:

```text
μ_E(S,z) = min_x |{(y,z') : E_q(S,x,y,z,z')}|.
```

The C80 coverage theorem is `μ_E≥1`; C82 may seek a stronger count. Counting
ordinary legal mates, strict-overload replies, or replies selected after
recursive survivor filtering is upstream-invalid because none carries the
missing soundness proof.

This also clarifies what “proof-producing” must mean. A scalar score on the
target is insufficient. The reply needs a transportable certificate datum
with a direct update law and a well-founded rank. The datum may have
unbounded range in `q`; the earlier finite-signature no-go excludes only a
fixed finite exact quotient, not a fixed algebraic construction with
unbounded parameters.

## `ej2` — proof-witness gauge and an anti-packing gate

There is a second circularity one layer beyond the quantifier shadow. Even
after C80 supplies proof-producing witnesses, C82 must not count witness
representations. If

```text
E_q(S,z,x,y,z')
```

means that reply `y` transports proof datum `z` to `z'`, then counting pairs
`(y,z')` is meaningless: duplicating or re-encoding `z'` can create arbitrary
“abundance” without adding a move. The invariant C82 object must project to
geometric replies:

```text
R_E(S,z,x) = {y : ∃z', E_q(S,z,x,y,z')},
μ_E(S,z)   = min_x |R_E(S,z,x)|.
```

Equivalently, successor proof data need a canonical gauge, or C82 must
quotient them before counting. Coverage is `μ_E≥1`; any stronger lower bound
counts distinct legal replies only.

The proof datum itself also needs the same anti-packing discipline that closed
the one-natural-number residual encoding. Otherwise `z` can store the whole
remaining strategy tree and make `E_q` locally checkable only by decoding the
answer. Before C82 release, a candidate must therefore satisfy all four
gates:

1. **bounded format:** a fixed algebraic schema, with a fixed number of
   field/group/integer coordinates of polynomial range or comparably explicit
   `O(log q)`-scale description;
2. **direct update:** a fixed bounded-complexity algebraic/incidence rule
   computes or verifies `z'` from `(S,z,x,y)`;
3. **nonrecursive soundness:** the update plus strict rank proves the reply
   safe without querying `F_cc`, `K_Ω`, minimax, or a stored subtree; and
4. **projected abundance:** all counts are over distinct replies `y`, after
   existentially eliminating or canonically gauging `z'`.

This sharpens the next constructive opportunity. `B_cc` already carries an
explicit pairing or one-exchange pairing shell. The q17 `4→2→0` thread
suggests lifting that object not by a scalar Tutte deficiency, but by an
**algebraically parametrized pairing-with-obligations certificate**: paired
fibres use copycat immediately, while a marked secant rewrite transports the
outstanding obligation family and lowers `Ω`. The obligations cannot be a
bounded lookup list—the earlier fixed-depth and finite-signature negatives
forbid that reading—but they may form one field-parametrized orbit family.
The cheap next scout is therefore very narrow: ask whether the five q17
repairs and the q19 control admit the same local obligation-rewrite identity,
with the Klein-four q17 copies treated as one orbit and with reply counts
projected to distinct cells. Failure kills this proof-object shape without
another global feature census; success yields the first legitimate `E_q`
candidate for C80 soundness and only then for C82 counting.

## `ej3` — intensional pairing, matching gauge, and obligation varieties

The pairing-with-obligations proposal still fails the anti-packing gate if
the datum literally lists a matching. A matching on `Θ(q)` live moves stores
`Θ(q log q)` bits and can hide an arbitrarily complicated strategy even
though it is called a “pairing certificate.” The same warning applies to an
explicit list of unmatched fibres, Gallai--Edmonds components, or alternating
paths.

A legitimate uniform datum must therefore be **intensional**. The smallest
proof-object shape consistent with all current gates is:

```text
z = (bounded algebraic parameters for σ_z, bounded equations for Z_z),
```

where:

- `σ_z` is a formula-defined partial involution on the legal-move locus;
- outside the exceptional locus `Z_z`, `σ_z(x)` is a jointly legal,
  proof-producing reply and the opponent/reply exchange has a direct update
  `z ↦ z'`;
- `Z_z` is not an enumerated defect list but a bounded-degree algebraic set
  or orbit family;
- a separate marked rewrite handles `x∈Z_z` and strictly contracts a
  well-founded obligation rank; and
- the complete rank couples `Ω` with the obligation rank without consulting
  recursive survivor membership.

This recasts the q17 `4→2→0` thread in a potentially uniform way. Its four
isolated fibres are already one Klein-four orbit, so they are compatible with
one exceptional orbit equation rather than four stored exceptions. The
deficiency-two target suggests contraction of that orbit datum, not
subtraction of a scalar matching deficiency. The q19 control supplies the
necessary state dependence: the fixed rational orbit fails, but a different
reply reaches the pairing kernel. Thus `σ_z` must be chosen from an
algebraic family parametrized by the current marked incidence, not fixed once
for the normalized six-set.

There is also a matching **gauge symmetry**. Two chosen maximum matchings can
differ by alternating cycles and paths while representing the same strategic
resource. Any update law depending on the arbitrary listed matching is
noncanonical and risks another witness-multiplicity artifact. Soundness must
be stated either directly for the formula-defined involution `σ_z`, or for a
canonical alternating-equivalence object such as an algebraically presented
factor-critical/attachment structure. C82 then counts projected replies,
never pairings or alternating representatives.

This produces a sharper cheap falsifier than “find a common pairing.” On the
five q17 repairs and marked q19 control, search only for a common
bounded-degree **partial involution schema plus exceptional-orbit equation**
whose local rewrite reproduces the certified replies. Reject the schema if
it needs an explicit edge list, coordinate-specific exception table, or a
choice of matching not invariant under alternating-cycle changes. A positive
would be the first candidate that simultaneously clears quantifier-shadow,
proof-witness gauge, and anti-packing.

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
- **[SETTLED `ej`] Is mate surplus an isolated redundant coordinate?** No.
  It is one instance of the quantifier-shadow principle, which also closes
  every recursive “no isolated opponent fibre” reformulation.
- **[SETTLED] Did `μ` explain the spoiler/repair split structurally?** It
  diagnoses it but does not certify it. The spoilers have `μ=0`, while the
  repairs have positive `μ`, yet recursive preservation merely restates the
  survivor response condition.
- **[SETTLED `ej`] What exactly may C82 count?** Only witnesses of a
  nonrecursive proof-producing edge predicate supplied by C80. Ordinary
  legal mates or recursively filtered replies do not meet the soundness gate.
- **[SETTLED `ej2`] May C82 count proof witnesses `(y,z')`?** No. It must
  count distinct geometric replies `y` after projecting or canonically
  gauging successor proof data; otherwise certificate duplication fabricates
  abundance.
- **[SETTLED `ej2`] Can the carried datum encode the complete strategy?** Not
  under the strengthened interface. It needs bounded format, direct local
  update, nonrecursive soundness, and projected reply counting.
- **[OPEN — C80 `ej2`] Does a field-parametrized
  pairing-with-obligations rewrite cover the q17 Klein-four repair orbit and
  marked q19 control by one identity?** This is the cheapest proof-object
  scout; it is not a new scalar/profile census.
- **[SETTLED `ej3`] May the proof datum store an explicit matching or defect
  list?** No. Its `Θ(q)`-scale description violates the anti-packing gate.
  Pairing and exceptional loci must be formula-defined from bounded
  algebraic parameters.
- **[SETTLED `ej3`] Is a chosen matching canonical proof structure?** No.
  Alternating cycles and paths give a gauge symmetry. The update law must use
  a formula-defined involution or an alternating-equivalence invariant, not
  an arbitrary matching representative.
- **[OPEN — C80 `ej3`] Does one bounded-degree partial-involution schema with
  an algebraic exceptional-orbit locus cover the q17 `4→2→0` thread and q19
  direct repair?** This is now the exact highest-EV scout and its stop
  condition.
- **[OPEN — C80] What nonrecursive marked incidence predicate proves a reply
  good?** The evidence gap is unchanged: construct a direct secant/orbital
  certificate datum with an algebraic transport law whose soundness does not
  call `F_cc`, `K_Ω`, minimax, or a filtered reply graph.
- **[OPEN — C80/C82 gate] Can that predicate be proved opponent-complete
  uniformly in odd q?** Unknown; C82 remains gated.

## Vibe

The finite result is cleanly positive, but mathematically it is a useful
tautology detector rather than progress on the crown. That is still valuable:
it prevents another recursive coordinate from masquerading as geometric
compression and leaves the next proof obligation much sharper.

go C80 cap construct a nonrecursive opponent-complete marked-secant edge certificate
