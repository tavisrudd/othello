# C80 — the strict-overload response kernel

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-24.

## Verdict

There is a canonical value-independent survivor family for the overload
induction.  Let `K_Ω` be defined recursively from incidence, legal moves, and
the proved `Y_NK` boundary:

```text
S ∈ K_Ω, Ω(S)=0
    iff S ∈ Y_NK;

S ∈ K_Ω, Ω(S)>0
    iff for every legal opponent move o there is a legal reply p
        with Ω(S+o+p)<Ω(S) and S+o+p ∈ K_Ω.
```

This definition does not mention the cap game's P/N value.  It is
well-founded because every certified response strictly lowers the
nonnegative integer `Ω`.

`K_Ω` has exactly the required boundary and response closure, so induction
proves every state in `K_Ω` is P.  Moreover it is the **largest** family with
those properties: every other proposed strict-overload survivor family is
contained in `K_Ω`.

The important finite gate passes.  Exact structural replay proves:

- exhaustively for every reachable fixed-pair residual state at `q=5,7`,
  `K_Ω` equals the set of exact P states (`301/726` and `11,467/19,160`);
- on all 210 raw q=11 size-four on-conic roots, `K_Ω` selects exactly the
  135 P roots;
- all five frozen q=13 size-four on-conic P escape roots lie in `K_Ω`;
- at q=17, `K_Ω` selects exactly the five P roots among the ten frozen
  size-four on-conic escape roots.

Thus strict-overload descent itself survives the available escape-family
falsification gate, including roots with initial overload as large as 844.
The q=17 certificates contain 59,419 explicit opponent/reply edges and
terminate at 30,909 `Y_NK` boundary states.

This does **not** finish the uniform odd-q crown.  The definition above is a
canonical response kernel, not yet an incidence/algebraic closed form whose
membership can be counted by C82.  The remaining C80 theorem is now sharper:

> Prove uniformly that the chosen odd-q escape child belongs to `K_Ω`, by an
> algebraic or residual-hypergraph response rule that avoids evaluating the
> recursive kernel.

That is a real reduction, but promoting the recursive definition itself as
the desired uniform mechanism would only rename the remaining membership
proof.

## 1. Definition and noncircularity

For a valid cap state `S`, write `Ω(S)` for the total capacity-two overload
from the preceding C80 report.  At overload zero, `capOK` holds, so C523
identifies the continuation with static Node--Kayles on the full legal-point
conflict graph.  Define layers `K_k` by induction on `k`:

```text
K_0 = {S : Ω(S)=0 and Grundy(G_S)=0},

K_k = {S : Ω(S)=k and
             ∀ legal o, ∃ legal p,
               Ω(S+o+p)<k and S+o+p ∈ ⋃_{j<k} K_j}.
```

Then

```text
K_Ω = ⋃_{k≥0} K_k.
```

Only the base invokes a game value, and that value is the independently
proved static Node--Kayles boundary value, not the original cap minimax.
Every recursive call is to a smaller overload layer.  This is therefore a
finite structural certificate: a rooted AND/OR response DAG whose leaves are
labelled by checkable `Y_NK` graphs.

### Theorem 1 — guard boundary and strict response closure

If `S∈K_Ω` and `Ω(S)=0`, then `S∈Y_NK`.  If `S∈K_Ω` and `Ω(S)>0`, then after
every legal opponent move there is a legal reply into `K_Ω` with overload
strictly smaller than `Ω(S)`.

**Proof.** Both statements are the corresponding clauses of the
well-founded definition.  In the second clause the target belongs to some
strictly lower layer `K_j`, `j<Ω(S)`. ∎

### Theorem 2 — every kernel state is P

Every `S∈K_Ω` is a cap-game P-position.

**Proof.** Induct on `Ω(S)`.  At zero, `S∈Y_NK`, so the C523 static
Node--Kayles theorem gives P.  At positive overload, every opponent option
has a reply in a lower kernel layer; that reply state is P by induction.
Hence every option from `S` is N, and `S` is P. ∎

### Theorem 3 — maximality

Let `F` be any family satisfying the corrected C80 guard-boundary and
strict-response clauses.  Then `F⊆K_Ω`.

**Proof.** Again induct on `Ω(S)` for `S∈F`.  At zero the guard clause puts
`S` in `K_0`.  At positive overload, the response clause sends every
opponent move to a state in `F` of smaller overload.  By induction all those
targets are in lower `K` layers, which is exactly the membership condition
for `S∈K_Ω`. ∎

Maximality makes `K_Ω` useful even before it is compressed: a candidate
incidence family can only succeed inside this kernel, and a single escape
root outside it would kill the entire strict-`Ω` plan, not merely one
selector.

## 2. Exact finite gate

The committed checker constructs `K_Ω` without calling cap minimax.  At an
overload-zero leaf it explicitly builds the full legal-point conflict graph
and computes its static Node--Kayles Grundy value.  At positive overload it
records the first legal response whose target is already certified in a
smaller layer.

Exact cap minimax is run separately as a consistency cross-check.

| domain | states/roots | exact P | `K_Ω` | disagreement |
|---|---:|---:|---:|---:|
| q=5, every reachable fixed-pair residual state | 726 | 301 | 301 | 0 |
| q=7, every reachable fixed-pair residual state | 19,160 | 11,467 | 11,467 | 0 |
| q=11, every raw on-conic size-four root | 210 | 135 | 135 | 0 |
| q=13, frozen size-four escape roots | 5 | 5 | 5 | 0 |
| q=17, frozen size-four escape roots | 10 | 5 | 5 | 0 |

The q=13 escape-root overload range is `72..108`; q=17 is `772..844`.
Consequently this is not a disguised bounded-depth certificate.  The
response DAG is well-founded by overload, while its exchange depth may grow.

At q=17 the five kernel roots are

```text
{3,4,5,8}, {4,5,7,15}, {6,7,8,14},
{11,13,14,15}, {13,14,15,16}.
```

The five rejected roots are exactly the five exact N roots in the frozen
domain.  This P/N comparison is a cross-check, not an input to membership.

## 3. Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Generate and check:

```text
python3 rust/scripts/c80_strict_overload_kernel.py
python3 rust/scripts/c80_strict_overload_kernel.py --check
```

Evidence bundle:

- script: `rust/scripts/c80_strict_overload_kernel.py`,
  10,813 bytes,
  SHA-256 `444ee995dd84cd6c8702a16688e133cea46c0ae10e65511c9f2fc1db68a5e206`;
- output: `notes/2026-07-24-c80-strict-overload-kernel.json`,
  6,174 bytes,
  SHA-256 `6b0f4b834d3d956a096530be47097d9795cc89f72ea9b529c0bc485d4c54ab35`;
- frozen input: `notes/data/c20-q13-q17-states.jsonl.gz`,
  654,965 bytes,
  SHA-256
  `952f189cc37bac36026238d75bccffb7feb560644582bf8c6373789a98f43f4d`.

The JSON records every tested escape label, initial overload, kernel
membership, exact cross-check value, response-map digest, boundary count,
and searched-domain size.  `--check` reconstructs the complete result and
requires byte-for-byte equality.

There is no second independent implementation of the recursive kernel.
The independent checks available here are:

1. static Node--Kayles Grundy is computed by a graph recursion separate from
   cap minimax;
2. cap minimax is not consulted by kernel membership and agrees exactly on
   every stated domain;
3. q=5 and q=7 are exhaustive over every reachable residual state, rather
   than sampled roots; q=11 is exhaustive over all 210 raw on-conic
   size-four roots.

The certificate proves only the listed finite domains.  It neither proves
`K_Ω=P` in general nor proves uniform odd-q escape-root membership.

## `ej` + `tt` closeout

The cheap extra value is maximality.  The corrected C80 target did not merely
ask for one possible family: it implicitly defines a unique largest
strict-overload kernel.  Every future algebraic family must embed into it,
so finite kernel membership is now a decisive falsifier for proposed
selectors and packets.

The explicit `ej` mixed-order upgrade is q=11.  Its full 210-root raw
on-conic domain is value-mixed, yet `K_Ω` again separates P from N exactly
(`135/210`).  The q=17 agreement is therefore not an artifact of testing
only recorded P labels or of working at an all-P order.

The Tao-style reformulation is to separate **semantic normalization** from
**geometric compression**:

```text
semantic object: K_Ω, the maximal well-founded response kernel;
geometric crown: a q-uniform, countable certificate that the escape child lies in K_Ω.
```

This prevents two opposite errors.  We should not call the recursive
definition a uniform proof, but we also should not keep guessing survivor
families without first checking whether they land inside the canonical
kernel.  C82 can be released only after the response witnesses admit an
algebraic packet description; the raw AND/OR kernel is not yet countable by
Weil or orbit intersection numbers.

No free closed-form selector emerged from the current proof.  The kernel's
large q=17 response DAG and its exact separation of the mixed escape roots
make response-label mining the next justified operation, but another
unstructured classifier sweep is not.

## Mystery ledger

- **[SETTLED] Does a noncircular strict-overload survivor family exist as a
  mathematical object?** Yes: `K_Ω` is well-founded from `Y_NK`, uses no cap
  value in its definition, and is maximal.
- **[SETTLED finite] Does the strict-overload plan already fail on the known
  escape roots?** No.  It certifies every exact P root in the frozen
  q=13/q=17 domains and rejects exactly the q=17 N roots.
- **[SETTLED finite] Is this only a q=13/q=17 artifact at arbitrary
  descendants or at one mixed escape order?** The exhaustive q=5/q=7 checks
  find `K_Ω=P` on all 19,886 reachable states combined, and the all-raw q=11
  escape sweep agrees on 210/210 mixed roots.  This is stronger evidence,
  not a uniform theorem.
- **[OPEN — owner C80] What incidence or residual-hypergraph predicate
  compresses `K_Ω` membership?** Exact gap: extract an algebraic
  opponent-marked response packet from the certified q=17 response map and
  prove it remains in a lower kernel layer.
- **[OPEN — owner C80] Is `K_Ω=P` for every projective-cap residual?** The
  finite data say yes through exhaustive q=7 and on the frozen higher-order
  escape domains.  An isolated overload gadget has Grundy zero, so a general
  proof cannot follow from monotonicity alone; external coupling must be
  used or a geometric counterexample may exist.
- **[OPEN — owner C82 after compression] Can the response packet be counted
  uniformly?** Still gated.  Recursive kernel membership is not an
  algebraic membership test.

## Vibe

This is a strong positive gate, not a completed crown.  The feared failure
mode—a known P escape root with no strictly overload-decreasing strategy—does
not occur.  The strategy now has a canonical semantic home and exact finite
certificates.  The remaining risk is compression: the response kernel may
be real but too context-sensitive for one uniform algebraic packet.

go C80 cap compress the q17 strict-overload response kernel into an
opponent-marked incidence packet and prove uniform escape-root membership
