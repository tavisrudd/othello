# C80 — adaptive copycat boundary replaces the finite Grundy oracle

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

There is a clean structural P boundary for the strict-overload survivor:

```text
B_cc = persistent pairing
       or one opponent/reply exchange into a persistent pairing.
```

It uses only the static conflict graph at `Ω=0`, contains no P/N or Grundy
oracle, and has an explicit copycat proof. Replacing `Y_NK` by `B_cc` in the
strict-`Ω` kernel preserves the complete certified q=13/q=17 response DAG:

| q | exact P escape roots | `B_cc` survivor roots | boundary states | response edges |
| ---: | ---: | ---: | ---: | ---: |
| 13 | 5/5 | 5/5 | 279 | 446 |
| 17 | 5/10 | 5/10 | 30,909 | 59,419 |

At q=17 the five survivors are exactly the five exact P roots; all five N
roots remain outside. The boundary-mask and response-map SHA-256 digests are
identical to the earlier `Y_NK` strict-kernel artifact at both orders.

This is the requested adaptive copycat/decomposition boundary and a successful
finite construction. It does **not** prove uniform odd-q escape or release
C82: positive-overload membership is still certified by the alternating
strict-`Ω` response tree rather than by a q-independent algebraic reply law.

## 1. Persistent pairing

Let `G` be the full legal-point conflict graph of an overload-zero residual.
At `Ω=0`, no active capacity-two block contains three legal points, so later
play is exactly Node--Kayles on `G`.

A **persistent pairing** is a partition of `V(G)` into pairs
`P_i={a_i,b_i}` such that

1. `a_i` and `b_i` are nonadjacent; and
2. for every two pairs `P_i,P_j`,

```text
|P_j ∩ (N(a_i) ∪ N(b_i))| ∈ {0,2}.
```

The condition is symmetric in the two pairs because it is imposed for every
ordered choice of `i,j`. It is a finite incidence formula: in the cap
residual, adjacency means that the two cells lie with one old selected point
on a load-one line.

### Proposition 1 — persistent-pair copycat

Node--Kayles on a graph with a persistent pairing is P.

**Proof.** If the opponent selects `a_i` (or `b_i`), its mate is still legal
by nonadjacency. Reply with that mate. The two moves delete their closed
neighbourhood union. Every other pair is therefore either deleted whole or
survives whole by condition 2. The surviving pairs retain the same
conditions, so copycat continues until the opponent has no move. ∎

This strictly generalizes the rigid boundary first tested during the task.
Swapping two isomorphic connected components and a fixed-point-free nonedge
graph automorphism both induce persistent pairings, but the definition does
not require an automorphism.

## 2. One-exchange adaptive shell

Define `B_cc(G)` by the q-independent formula

```text
G has a persistent pairing
or
for every vertex x,
  there is a non-neighbour y such that
  G - (N[x] ∪ N[y]) has a persistent pairing.
```

The second clause is the adaptive shell. The pairing may depend on the marked
opponent move `x`; it is not a static mirror.

### Proposition 2 — adaptive boundary

If `B_cc(G)`, Node--Kayles on `G` is P.

**Proof.** The first case is Proposition 1. In the second, answer an opponent
move `x` with the supplied non-neighbour `y`. Their follower has a persistent
pairing and is P by Proposition 1. Thus every option from `G` has a reply to a
P follower, so `G` is P. ∎

This fixes the quantifier defect exposed by the failed even-faceted boundary:
losing maximal branches are irrelevant, and the response structure is
`∀x∃y`, not a parity assertion about every complete play.

## 3. Ranked survivor

Let `F_cc` be the states carrying a finite opponent-complete response
certificate with:

- every response target having strictly smaller `Ω`; and
- every leaf having `Ω=0` and boundary graph in `B_cc`.

Equivalently for computation, use the well-founded Bellman recursion with
base `B_cc` and rank `Ω`. This definition invokes neither cap-game minimax nor
Node--Kayles Grundy.

### Proposition 3 — soundness

`F_cc ⊆ P`.

**Proof.** Boundary leaves are P by Proposition 2. At positive rank, every
opponent move has a certified reply to a lower-`Ω` member. Induction on the
nonnegative integer `Ω` proves the state P. ∎

The certificate-tree formulation makes the algebraic content and the
remaining limitation explicit. The boundary decoder is fixed, local, and
nonrecursive. The positive layer still stores an opponent-complete response
tree; the missing uniform theorem is a direct algebraic construction of that
tree for every selected escape root.

## 4. Exact finite gate

The frozen domains are the five q=13 P escape roots and the ten mixed q=17
escape roots from the C20 corpus. The new kernel visits exactly the same
states and chooses exactly the same positive-overload replies as the original
strict kernel:

| q | kernel states | response-map SHA-256 |
| ---: | ---: | --- |
| 13 | 733 | `6741118268a2badd2f6e4b30c83128e0a78a7061fded9817bc13b9dec4917608` |
| 17 | 138,221 | `0ae6aec57d596451023ea663c179ed4b2b86da10232f0fee8f8b8a37ca326028` |

The former `Y_NK` boundary is replaced exactly, not merely in cardinality:

| q | persistent pairing (depth 0) | adaptive shell (depth 1) | boundary-mask SHA-256 |
| ---: | ---: | ---: | --- |
| 13 | 242 | 37 | `12adf6eb997d4a0e04d445fdde020aa760cc55dfbd2b8504b2fcd3d9334e2ea0` |
| 17 | 22,475 | 8,434 | `6838f260f6cdf94d6120431d04f6bfba6a20adf6c0793e23feec0d5cdb419da0` |

No depth-two shell is needed. This remains true despite 5,578 q=17 boundary
component occurrences outside the isolated/clique/path/cycle families, so the
result is not a disguised Dawson-path classification.

## 5. Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_adaptive_copycat_survivor.py
python3 rust/scripts/c80_adaptive_copycat_survivor.py --check
```

Load-bearing inputs:

- `notes/data/c20-q13-q17-states.jsonl.gz`;
- `rust/scripts/c80_strict_overload_kernel.py`;
- the normalized prime-grid engine and incidence-line constructor imported by
  that script.

The generator deterministically enumerates every legal opponent and reply in
cell-index order. Graph isomorphism and pairing searches use no randomness.
The JSON is canonical (`sort_keys=True`); `--check` regenerates it in a
temporary directory and requires byte equality.

Independent checks:

1. the new boundary predicate never calls `boundary_grundy`, but an exact
   Node--Kayles Grundy replay independently returns zero on all 279 and
   30,909 accepted boundary graphs;
2. the accepted boundary-mask digests equal those of the separately rebuilt
   original `Y_NK` boundary sets;
3. the strict response-map digests equal the previously committed C80 kernel
   digests;
4. exact cap minimax is computed separately at the roots and agrees with
   `F_cc` on all 15 q=13/q=17 records.

Artifacts:

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_adaptive_copycat_survivor.py` | 19,518 | `8948a9651b0928955ebd09041c6395cbc4f2287ba274748ce5cebf45a4dc56fd` |
| `notes/2026-07-25-c80-adaptive-copycat-survivor.json` | 8,244 | `55f8c458f53f5762dc531a7d86b9e746b9db0866b1f2bb349ad3ba49c0fd79a1` |

The artifact certifies only the stated frozen q=13/q=17 domains and the
boundary graphs reached by their strict-kernel search. It does not prove that
every `Y_NK` graph, every q=19 boundary, or every odd-q escape root lies in
`B_cc` or `F_cc`.

## `ej` + `tt` closeout

The cheap upgrade is the exact oracle elimination: every finite boundary
state used by the successful strict-`Ω` certificate has a copycat proof of
depth at most one. Thus the earlier finite computation no longer depends on
an unexplained Grundy-zero leaf, even though its positive response DAG is
unchanged.

The Tao-style formulation is the quantified incidence object

```text
∀ opponent x ∃ reply y ∃ pairing π_x
```

with polynomially checkable nonadjacency and pair-persistence equations. This
is the correct boundary shape: adaptive, q-independent, and capable of
ignoring losing maximal continuations. The next theorem should lift this same
marked quantifier order through positive overload, constructing the strict
reply and the eventual `π_x` from normalized secant data. Mining another
unmarked profile would discard exactly the mark that makes `B_cc` work.

## Mystery ledger

- **[SETTLED positive] Can the arbitrary `Y_NK` Grundy-zero boundary be
  replaced on the finite C80 gate by a structural P packet?** Yes. `B_cc`
  replaces it exactly at q=13/q=17.
- **[SETTLED positive] Is a global automorphism required?** No. Persistent
  pairings are weaker, and 8,471 boundary states require the adaptive shell
  rather than the depth-zero pairing.
- **[SETTLED positive] Does the replacement disturb the successful overload
  descent?** No. Boundary-mask and response-map digests are identical.
- **[OPEN — C80] Is `B_cc` a uniform overload-zero boundary for the escape
  family?** Unknown. The evidence stops at the exact q=13/q=17 boundary sets;
  q=19 and growing-`q` structure are not certified here.
- **[OPEN — C80] Is there a q-independent algebraic construction of the
  positive strict-`Ω` response tree?** Unknown. This is now the sole
  load-bearing survivor gap; the boundary itself is no longer an oracle.
- **[OPEN — C80/C82 gate] Can marked secant algebra count or construct the
  reply together with its eventual pairing certificate?** This is the
  highest-EV successor. C82 remains gated until the positive layer is
  uniform.

## Vibe

This is the first clean positive after the parity and finite-signature
failures: the boundary has collapsed from arbitrary Grundy zero to a tiny
explicit `∀x∃y` copycat certificate. The crown is not closed, but the unknown
is now concentrated in positive-overload lifting rather than split between
lifting and leaf value.

go C80 cap lift the marked adaptive pairing shell through positive overload
