# C528 — full residual Grundy census by overloaded-line conic type

**Lane:** `cap`. **Task:** C528. **Date:** 2026-07-23.

## Verdict

The missed invariant is real and striking:

> On every frozen q17/q19 `capOVER`-core residual child, the exact full game
> Grundy number is at most **5**, even though q19 has as many as **47**
> interacting overloaded-line gadgets of size up to **7**.

The proposed conic-type explanation is false. External gadgets do not
systematically cancel: at q19, deleting all external gadget constraints changes
the exact nimber in **31,871 / 48,074** states containing one and changes the
outcome from N to P in **8,771**. Secant and tangent gadget counts also grow
(maxima 22 and 7 per q19 state), so the value does not live in a bounded number
of non-external gadgets on this corpus.

This confirms the Tao correction to C528's original measurement: `g` and `k`
can be unbounded-looking while the game-relevant SG value remains tiny. It
rejects the cheap follow-up hypothesis that conic incidence type explains why.

## What “contribution” can mean here

An isolated `k`-gadget has Grundy value 0 for every `k >= 2`. After its first
move the `k-1` survivors form a clique; nonempty Node-Kayles cliques have
Grundy 1, so the untouched gadget has `mex {1} = 0`. In particular every
isolated overloaded gadget (`k >= 3`) is zero, independently of conic type.

But C528's gadgets overlap and are coupled through the ambient conflict graph.
They are not disjunctive summands, so there is no canonical additive
“Grundy contribution per gadget.” The census therefore uses an operational
contextual marginal:

```text
delta(line) = SG(full residual)
              XOR SG(residual with that line's triple constraint deleted).
```

It also deletes all gadget constraints of one conic type at once. `delta=0`
means exact nimber preservation; an ablated SG of 0 is the weaker but directly
game-relevant N→P outcome flip. These are ablation diagnostics, not a claimed
Sprague--Grundy decomposition.

## Exact full-state Grundy values

The residual children are responder wins by construction, so their SG values
cannot be 0. The question is magnitude.

| q | residual children | gadget range | legal-point range | exact full SG distribution |
|---:|---:|---:|---:|---|
| 13 | 0 | — | — | — |
| 17 | 349 | 1–7 | 8–17 | `1^5 2^26 3^263 4^52 5^3` |
| 19 | 48,084 | **3–47** | 14–37 | `1^20142 2^4629 4^11933 5^11380` |

Thus the observed ceiling is **5** at both nonempty orders. It does not track
gadget count monotonically: the two q19 states with `g=47` both have SG 2;
at `g=43`, SG 2 and 5 both occur. The absence of SG 3 at q19 is also sharp:
SG 3 dominates q17 (263/349) but occurs 0/48,084 at q19.

This is finite evidence, not a uniform bound. q13 contributes no residual
states, q17/q19 are the only nonempty frozen orders, and this corpus is a
late-game responder-win stratum rather than all cap positions.

## Conic-type census

### Gadget counts are not confined to a bounded secant/tangent defect

| q | type | gadget instances | states containing type | max per state |
|---:|---|---:|---:|---:|
| 17 | external | 718 | 296 | 6 |
| 17 | secant | 423 | 279 | 4 |
| 17 | tangent | 115 | 107 | 2 |
| 19 | external | 554,832 | 48,074 | 32 |
| 19 | secant | 324,195 | 47,969 | 22 |
| 19 | tangent | 45,958 | 29,823 | 7 |

All three maxima grow from q17 to q19. In particular, “external bulk plus a
bounded number of secant/tangent value carriers” is not supported.

### Single-line contextual ablation

| q | type | line instances | nonzero exact delta | N→P after deletion |
|---:|---|---:|---:|---:|
| 17 | external | 718 | 246 | 172 |
| 17 | secant | 423 | 246 | 160 |
| 17 | tangent | 115 | 24 | 10 |
| 19 | external | 554,832 | 63,422 | 15,278 |
| 19 | secant | 324,195 | 37,175 | 9,394 |
| 19 | tangent | 45,958 | 5,351 | 1,304 |

External lines therefore affect not only exact nimber but ordinary P/N value.
The detailed `(type,k,delta)` table is mixed rather than classifying. For
example, q19 external `k=3` has 436,146 zero-delta and 43,767 nonzero-delta
instances. A small-q apparent law also fails to persist: all 24 q17 tangent
`k=4` lines have delta 0, while 1,519 of 5,677 q19 tangent `k=4` lines have
nonzero delta.

### Collective type ablation

| q | type | states containing type | exact SG changed | N→P after deletion |
|---:|---|---:|---:|---:|
| 17 | external | 296 | 166 | 72 |
| 17 | secant | 279 | 218 | 140 |
| 17 | tangent | 107 | 20 | 6 |
| 19 | external | 48,074 | 31,871 | 8,771 |
| 19 | secant | 47,969 | 24,132 | 6,452 |
| 19 | tangent | 29,823 | 4,985 | 1,225 |

This decisively rejects “external gadgets contribute SG 0” under the strongest
natural contextual reading (delete all external gadget rules).

## Bearing on the C80 predecessor chain

The C80/C523 `Y_NK` proof was reviewed in full before this run. It says exactly
why the present static hypergraph model is faithful:

- load-one lines give the current pair-conflict graph;
- load-zero lines give the only missing triple constraints;
- `capOK` means there are no active triple constraints, recovering static
  Node-Kayles.

The census generalizes that model without claiming a disjunctive sum. The full
SG values were independently checked against direct recursive projective-game
SG on all 349 q17 residuals and a deterministic 100-state q19 slice, with zero
disagreements. The C524 predecessor separately certifies that every residual
child is N.

The result fits C80's repeated warning that static coarse labels are
insufficient: the same `(conic type,k)` class contains zero and nonzero
contextual influence. What survives is the defect-skeleton direction, now with
the correct target: explain the **whole residual's** tiny nimber, not assign a
standalone nimber to each gadget.

## Implications for C528

1. The original general gadget induction is still unproved, and `(Φ,|L|)`
   remains only a well-founded recursion order, not a value law.
2. The observed SG ceiling of 5 is the strongest current explanation-shaped
   fact for why depth 2 can beat `g=47`: game value stays tiny while static
   constraint count grows.
3. Conic type is not the quotient. The next proof-shaped test is Piece 3 from
   the C528 guide: recover the full SG from path/cycle/Dawson defect skeletons
   or identify the bounded non-path remainder. It must operate on the full
   coupled residual, not sum isolated gadgets.
4. No q23 claim is made. q23 lacks the frozen C20 three-intruder domain needed
   for this exact test; generating it remains the out-of-sample step after a
   candidate SG law is selected.

## Proof harvest: exact lemmas available now

The computation suggests a bounded-value theorem but is not needed for the
following q-uniform statements.

### Static rank-three residual theorem

Let `F={a,b}∪S` be any cap state and `V=L(S)` its legal moves. For every
projective line `ℓ`, put `λ_ℓ=|F∩ℓ|`. A set `T⊆V` is a legal continuation
exactly when

```text
|T∩ℓ| ≤ 2-λ_ℓ  for every line ℓ.
```

Because `F` is a cap, `λ_ℓ≤2`; when `λ_ℓ=2`, `V∩ℓ` is already empty. Thus the
minimal forbidden sets on `V` are precisely:

- pairs on load-one lines (`λ_ℓ=1`);
- triples on load-zero lines (`λ_ℓ=0`).

*Proof.* `F∪T` is a cap iff every projective line contains at most two of its
points, which is exactly the displayed family of inequalities. ∎

Consequently every cap residual is a fixed rank-at-most-three
hypergraph-building game. The C523 `Y_NK` theorem is the specialization in
which every load-zero line contains at most two legal vertices, so the
triple-forbidden family is empty and only the Node-Kayles conflict graph
remains.

### Isolated-gadget zero lemma

The game consisting only of the `k` legal vertices on one load-zero line has
SG 0 for every `k≥2`.

*Proof.* After any first move, the `k-1` survivors are pairwise conflicting:
the chosen point is now the third point on their common line. For `k≥2` this
is a nonempty clique, whose Node-Kayles SG is 1. Every root option therefore
has SG 1, so the root has `mex {1}=0`. ∎

Hence any disjoint sum of isolated overloaded-line gadgets is P. Nonzero value
must come from coupling through shared vertices or ambient load-one/triple
constraints, exactly as the ablation census observes.

### Pair-budget and overload bounds

If the overloaded lines have legal-point counts `k_ℓ≥3` among `n=|V|` legal
points, then

```text
Σ_ℓ binom(k_ℓ,2) ≤ binom(n,2).
```

*Proof.* The unordered pairs of legal points lying on distinct gadget lines
are disjoint, because two projective points determine a unique line. ∎

Therefore, q-uniformly,

```text
g ≤ binom(n,2)/3,
#{ℓ : k_ℓ≥r} ≤ binom(n,2)/binom(r,2),
Φ = Σ_ℓ(k_ℓ-2) ≤ binom(n,2)/3.
```

The last inequality uses
`k-2 ≤ binom(k,2)/3` for every `k≥3`. These bounds explain why the overload
measure is finite and constrain large gadgets, but they do not by themselves
bound SG.

### General SG-height bound

For any finite impartial position, `SG(S)≤h(S)`, where `h(S)` is the maximum
number of remaining moves.

*Proof.* Induct on `h`. Every child has height at most `h-1`, hence SG at most
`h-1`; the mex of child values is at most `h`. ∎

Using the standard odd-plane bound that a cap in `PG(2,q)` has at most `q+1`
points, a residual state with `s` selected affine points satisfies

```text
SG(S) ≤ q-1-s.
```

The C528 residual children have `s=7`, giving proved generic bounds 9 at q17
and 11 at q19. The exhaustive census improves both finite-domain bounds to 5.
Promoting 5 to a q-uniform theorem is the open defect-skeleton problem, not a
consequence of the height lemma.

### Follower-class mex bound

Suppose the legal moves from `S` fall into `m` classes such that moves in one
class have followers with the same SG value. Then

```text
SG(S) ≤ m.
```

*Proof.* The mex defining `SG(S)` sees at most `m` distinct option values, and
the mex of a set of `m` nonnegative integers is at most `m`. ∎

Game-tree-isomorphic followers give such classes; move orbits under the
stabilizer of `S` are a sufficient special case. This is an explanation-shaped
route to SG≤5 only if geometry supplies a bounded follower quotient. Ordinary
symmetry is unlikely to suffice at generic states, whose stabilizers may be
trivial; the needed equivalence must instead compress boundary behavior.

The C524 depth-2 certificate gives no such bound by itself. A Nim heap has a
one-move option to a P-position at every nonzero size but has arbitrarily large
SG. Thus C528's observed ceiling is genuinely additional information, not a
formal consequence of bounded-depth winning.

### Conditional clean-leaf truncation

The first local boundary rewrite is already proof-grade. In the static
rank-three model, let a load-zero gadget have support
`A={v}∪U`, `|A|=k≥3`, and suppose no minimal forbidden pair or triple outside
the complete triple family on `A` contains a point of `U`. Thus `v` is the
gadget's only possible attachment to the ambient game and the vertices of `U`
are private.

Then replacing `U` by exactly two private vertices—replacing the `k`-gadget by
the corresponding 3-gadget with the same boundary `v`—preserves SG under every
ambient attachment through `v`.

*Proof sketch.* Induct through ambient play and split on the next move.

- An ambient move leaving `v` legal leaves the same one-boundary problem.
- If an ambient move kills `v`, the private vertices become a disjoint isolated
  gadget with at least two vertices, hence SG 0 by the isolated-gadget lemma.
- Playing `v` turns all private survivors into a nonempty clique; its SG is 1,
  independent of their multiplicity.
- Playing a private vertex turns `v` and all remaining private vertices into
  one clique. A later private move deletes that clique without affecting the
  ambient game, while a later move at `v` has exactly the ambient follower
  caused by playing `v`. Extra private vertices only duplicate these two option
  types, and duplicate options do not change mex.

The same option-value recursion therefore results for every `k≥3`. ∎

This lemma explains why large `k` is harmless on a true leaf. Its hypothesis is
also a sharp diagnostic: projective gadget vertices generally participate in
load-one conflicts outside their gadget. If the lemma does not apply widely,
the proof must enlarge `{v}` to the minimal boundary recording those external
constraints. Identifying that boundary signature is the explanatory target
queued as C547, not another order census.

## Reproduction and trust boundary

Working directory: repository root (`/home/tavis/src/othello`).

```text
python3 rust/scripts/c528_grundy_conic_census.py
python3 rust/scripts/c528_grundy_conic_census.py --check
```

The full run uses Python 3.13.12, takes about 20 minutes, and peaks near 4.9 GB
on this machine. The canonical certificate stores exact aggregate tables plus
a SHA-256 digest of the sorted per-state rows; `--check` recomputes all 48,433
nonempty residual states and every line/type ablation byte-for-byte.

Load-bearing frozen inputs and helper-source hashes/byte counts are embedded in
the certificate's `sources` block. The checker uses no randomness or external
packages.

- `rust/scripts/c528_grundy_conic_census.py`: 12,325 bytes,
  SHA-256 `91e3cf89dae2c01e7b893030018b6dc850bf45362105a84b6a3df863f7c0323c`
- `notes/2026-07-23-c528-grundy-conic-census.json`: 54,467 bytes,
  SHA-256 `17dd3f416f8e4a4c358f5b7c6ea0116e4ef0a0b0a09d736af2f1f21845ae6138`

Independent check boundary: the full unablated SG has the direct-geometry
recursion cross-check above. There is no second engine for the counterfactual
line-deletion games; those are checked by the exact static constraint
construction and canonical replay.

## Mystery ledger (ej+tt closeout)

- **[OPEN — load-bearing] Why is full SG at most 5 while `g` reaches 47?**
  This is now the central C528 mystery. Evidence: exhaustive frozen q17/q19
  residual census; gap: only two nonempty orders and no structural formula.
  Owner: continued C528 Piece 3 (Dawson/path-cycle defect skeleton).
- **[OPEN] Why does SG 3 dominate q17 but disappear completely at q19?**
  It may reflect field/order geometry, reachable-stratum selection, or a
  component-parity law. The census distinguishes the phenomenon but does not
  explain it. Owner: the same Piece 3 component census.
- **[SETTLED negative] External gadgets do not contribute zero contextually.**
  Both exact-nimber and P/N ablations fail at scale; no conic-type-only law.
- **[SETTLED negative] Value does not live in a bounded number of
  secant/tangent gadgets on this corpus.** Their per-state maxima grow
  `4→22` and `2→7`.
- **[SETTLED correction] q19 gadget count is `3..47`, not `2..47`.** The
  original JSON always had the correct distribution; the earlier prose
  endpoint is corrected in the C528 report, guide, and live handoff.
- **[OPEN, later gate] Does the SG ceiling survive q23?** No frozen domain
  exists yet. This is the out-of-sample falsifier after a candidate law, not a
  claim of the present task.

## Vibe

Strong narrowing, not closure. C528 finally measured the right invariant and
found a surprisingly rigid signal exactly where static complexity looked
hopeless. The easiest geometric explanation failed cleanly, leaving a sharper
and more credible defect-skeleton/Grundy problem.
