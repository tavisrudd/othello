# C80 — scale-aware positive-overload survivor families

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-24.

## Verdict

There is a clean scale-aware family between the uncompressed strict-overload
kernel `K_Ω` and the failed extremal packets.

For `0≤α≤1`, define the **boundary-or-retention packet** after state `S`
and opponent move `o` by

```text
M(S,o) = max { Ω(S+o+p) : p legal and Ω(S+o+p)<Ω(S) },

R_α(S,o) =
  { p : S+o+p∈Y_NK }
  ∪
  { p : 0<Ω(S+o+p)<Ω(S) and Ω(S+o+p)≥α M(S,o) }.
```

Let `F_α` be the well-founded survivor family with `Y_NK` boundary and
replies restricted to `R_α`.  Then

```text
F_α ⊆ K_Ω ⊆ P,
β≤α  =>  F_α⊆F_β,
F_0=K_Ω.
```

Its selected-size slices `F_{q,s,α}` are the requested growing family: they
permit arbitrarily many positive-overload exchanges and do not invoke
`Y_NK` at a fixed cap size.  The explicit `Y_NK` union is load-bearing.
Without it, “retain overload” incorrectly rejects valid early absorption.

Exact replay gives a genuine positive finite gate:

- every tested q=11/q=13/q=17 kernel escape root belongs to `F_{1/4}`;
- the minimum exact q=17 retention strength is `20/51`;
- the single out-of-sample q=19 root belongs to the explicitly checked
  retention families listed below.

The natural sharper families are falsified:

- fastest total overload descent: `0/5` q17 roots;
- lower weak-majorization of the full overload vector: `0/5`;
- slowest total descent, even with free `Y_NK` absorption: `0/5`;
- upper weak-majorization: `1/5`;
- the Pareto frontier of total overload, overloaded-line support, maximum
  line overload, and legal-reservoir size: `0/5`.

So value lives in a broad middle band, not at either load-profile extreme.
This is real compression of the reply relation, but not yet the uniform
odd-q proof: `F_α` membership remains recursive, and no q-independent
positive lower bound on retention strength is proved.  C82 remains gated.

## 1. Definition

For a valid cap state `S`, let the overload contribution of a capacity-two
line `ℓ` be

```text
λ_S(ℓ)=max(0, |L(S)∩ℓ|-2).
```

Write `Λ(S)` for the decreasing vector of its positive `λ_S(ℓ)` and
`Ω(S)=ΣΛ(S)`.  Every packet below uses only incidence, cap legality, `Ω`,
`Λ`, and the already proved static `Y_NK` boundary.

Define `F_α` by induction on `Ω`:

```text
Ω(S)=0:
  S∈F_α  iff  S∈Y_NK;

Ω(S)>0:
  S∈F_α  iff  for every legal opponent move o,
               some p∈R_α(S,o) has S+o+p∈F_α.
```

The packet always contains a `Y_NK` target when one exists, regardless of
its zero retention ratio.  Among positive targets it forbids replies that
discard more than the allowed fraction of the best available overload
reservoir.

### Proposition 1 — soundness and nesting

For every `α∈[0,1]`, `F_α⊆K_Ω`, hence every state in `F_α` is P.
If `β≤α`, then `F_α⊆F_β`; and `F_0=K_Ω`.

**Proof.**  Induct on `Ω`.  The boundary clauses agree.  Every positive
`F_α` reply is a legal strict-overload reply into a lower `F_α` layer, hence
by induction into `K_Ω`.  Packet inclusion
`R_α⊆R_β` gives nesting.  At `α=0`, every positive strict target is admitted
and every successful zero target must recursively be in `Y_NK`, which is
exactly the definition of `K_Ω`. ∎

### Proposition 2 — exact retention strength

Define

```text
ρ(S)=sup { α∈[0,1] : S∈F_α }.
```

At a `Y_NK` boundary state, `ρ(S)=1`.  At positive overload it satisfies the
exact Bellman recursion

```text
ρ(S)
 = min_o max_p
     if S+o+p∈Y_NK then 1
     else min( Ω(S+o+p)/M(S,o), ρ(S+o+p) ),
```

where the maximum ranges over strict-overload replies that lie in `K_Ω`.
All recursions go to smaller integer overload, so `ρ` is an exact rational
number.  This is a diagnostic and a theorem target, not a new appeal to cap
minimax.

## 2. Falsified families

The checker forms restricted kernels with the same `Y_NK` boundary.
Consequently a rejected root is a counterexample to the complete recursive
family, not merely to one selected response DAG.

The tested packets are:

1. **fastest total:** minimize target `Ω`;
2. **lower majorization:** retain every target not weakly
   prefix-sum-dominated by a smaller overload vector;
3. **slowest total:** maximize positive target `Ω`, plus every `Y_NK`
   target;
4. **upper majorization:** the reverse weak-majorization frontier, plus
   `Y_NK`;
5. **reservoir Pareto:** maximize the four coordinates
   `(Ω, |supp Λ|, max Λ, |L|)` componentwise, plus `Y_NK`;
6. **retention:** the boundary-or-`α` packet above.

Root membership:

| packet family | q=11 | q=13 | q=17 |
| --- | ---: | ---: | ---: |
| unrestricted `K_Ω` | 135/135 | 5/5 | 5/5 |
| fastest total | 135/135 | 5/5 | 0/5 |
| lower majorization | 135/135 | 5/5 | 0/5 |
| slowest total + boundary | 135/135 | 5/5 | 0/5 |
| upper majorization + boundary | 135/135 | 5/5 | 1/5 |
| reservoir Pareto + boundary | 135/135 | 5/5 | 0/5 |
| `F_0.90` | 135/135 | 5/5 | 0/5 |
| `F_0.75` | 135/135 | 5/5 | 1/5 |
| `F_0.50` | 135/135 | 5/5 | 4/5 |
| `F_0.40` | 135/135 | 5/5 | 4/5 |
| `F_0.25` | 135/135 | 5/5 | 5/5 |

The q11 domain is all 210 raw on-conic roots, of which 135 are in `K_Ω`;
the table asks how many of those 135 survive each restriction.  The q13 and
q17 domains are the five and ten frozen escape roots, with five kernel roots
at each order.

### Positive-survival fibre audit

Across the complete chosen q17 `K_Ω` certificate DAG, 3,046 marked
opponent fibres have at least one positive-overload lower-kernel reply.
Packet coverage is:

| packet | fibres containing a positive lower-kernel reply |
| --- | ---: |
| fastest total | 112/3,046 |
| lower majorization | 152/3,046 |
| reservoir Pareto | 2,502/3,046 |
| slowest total | 2,613/3,046 |
| upper majorization | 2,860/3,046 |
| retain 90% | 2,694/3,046 |
| retain 75% | 2,886/3,046 |
| retain 50% | 3,044/3,046 |
| retain 40% | 3,044/3,046 |
| retain 25% | 3,046/3,046 |

The sharp one-step retention ratio over these fibres is `20/51`.  The
recursive root strength can be smaller because every later marked fibre
must also remain in the restricted family.

The full unmarked load profile is still not a `K_Ω` certificate.  Among the
strict positive targets, 48 of 57 `(selected size,Ω)` signatures and 120 of
690 complete `(selected size,Λ)` profiles are kernel-membership-mixed.  Only
527 of the 3,046 positive-survival fibres contain a lower-kernel reply with
a globally kernel-pure full profile.  Thus the positive `F_α` result is an
existential packet statement.  It does not promote `Λ(S)` to a static
`K_Ω`-membership classifier, much less establish a P/N classifier.

## 3. q=19 out-of-sample test

The previously certified q=19 root `{15,16,17,18}` was tested independently
of the q=17 threshold choice.  Exact restricted-kernel results:

```text
retain 25%: yes
retain 40%: yes
retain 50%: yes
retain 75%: yes
retain 90%: no
```

This root exercises one positive-overload exchange before boundary
absorption.  It is therefore a useful out-of-sample packet test, not evidence
for the `sqrt(q)` many positive layers forced at large q.

## 4. What this says beyond the twelve-cap ceiling

For `q≥67`, no twelve-cap can be `capOK`; more generally a uniform strategy
must certify at least

```text
max(0, (s_even(q)-8)/2)
```

positive-overload response targets before its first possible `Y_NK`
absorption.  The family `F_α` has the correct logical shape for that regime:
its selected size grows by two, it permits positive overload at every layer,
and its proof is still well-founded on strict `Ω` descent.

The finite evidence does not reach that regime.  It establishes only that a
nontrivial constant (`α=1/4`) survives every listed root and that both
load-extremal alternatives already fail at q=17.  The uniform crown is now
the statement

```text
there exists a q-independent α>0 such that every chosen odd-q
escape root lies in F_α,
```

or a marked-algebraic refinement if that statement is false.  Proving only
`α=0` recovers `K_Ω` and adds no compression.

## 5. Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_scale_survivor_falsifiers.py
python3 rust/scripts/c80_scale_survivor_falsifiers.py --check
```

Evidence:

- `rust/scripts/c80_scale_survivor_falsifiers.py`, 18,836 bytes,
  SHA-256
  `11488f316b94ad10f311cf489f6aa4d85a7a06aece3f97661baae8af2aec0c2e`;
- `notes/2026-07-24-c80-scale-survivor-falsifiers.json`,
  390,103 bytes,
  SHA-256
  `12a6147fcbee0bec737ef66407e40f85956184e74c421ea3bea6a616eac2fe70`.

The output records the exact root labels, restricted-kernel membership,
response-map digests, exact q11/q13/q17 retention strengths, q17 fibre
counts, and the bounded q19 threshold probe.  `--check` regenerates the
complete canonical JSON and requires byte-for-byte equality.

The checker imports the committed strict-kernel implementation and inherits
its geometry, legality, overload, and `Y_NK` boundary.  It does not call cap
minimax.  As internal cross-checks, the exact Bellman strength agrees with
seven separately evaluated percentage kernels at q=11/q=13/q=17, and the
unrestricted packet reproduces every input `K_Ω` root.  There is no second
implementation of the restricted kernels; the claim is bounded to the
listed domains and the upstream strict-kernel trust boundary.

## `aa` + `ej` + `tt` closeout

The alternative-attacks pass compared both directions of load extremality,
not merely more variants of `Rmax`.  Both directions fail.  The surviving
object is a broad retention envelope with free boundary absorption.

The `ej` correction was decisive: unioning `Y_NK` into every reservoir
packet restores legitimate early absorption and changes q13 from a false
negative to 5/5.  The second cheap upgrade is exact retention strength `ρ`;
it replaces arbitrary percentage sweeps by one rational bottleneck.

The Tao-style quantifier order is:

```text
find α>0;
for every q and every chosen escape root S;
for every opponent move o;
find a boundary-or-retaining reply p;
then recurse at strictly smaller Ω.
```

The finite data address the inner two quantifiers only at stated orders.
The next proof attack should derive a q-uniform lower bound for `ρ` from
opponent-marked secant algebra.  Another unmarked scalar or load-profile
optimization is closed by the mixed profiles and extremal failures above.

## Mystery ledger

- **[SETTLED negative] Does fastest overload absorption define the growing
  family?** No: fastest total and the full lower-majorization frontier lose
  all five q17 kernel roots.
- **[SETTLED negative] Does deliberate maximum reservoir retention define
  it?** No: slowest total loses all five q17 roots; upper majorization keeps
  only one.
- **[SETTLED negative] Do the four basic unmarked reservoir coordinates
  suffice?** No: their Pareto family loses all five q17 roots.
- **[SETTLED finite] Is there any nonzero scale-aware restriction that keeps
  the known escape roots?** Yes: `F_{1/4}` keeps every tested
  q11/q13/q17 kernel root and passes the stated q19 probe.
- **[OPEN — C80] Is `inf_q ρ(S_q)>0` for the selected odd-q escape
  family?** Exact evidence stops at the listed orders; the square-root-depth
  regime begins beyond the current certificates.
- **[OPEN — C80] What marked algebra proves a positive lower bound?**
  Unmarked overload vectors are kernel-membership-mixed; the next candidate must retain
  the original conic/frame and opponent–reply secant data.
- **[OPEN — C82, still gated] Can the retaining packet be counted
  uniformly?** Even abundance of `R_α` does not by itself prove that a
  member lies in the recursive survivor family.

## Vibe

This is the first scale-aware family that survives the finite gate, but it
is a semantic compression rather than the crown.  The encouraging part is
that a positive constant remains after q19; the risk is that its infimum
decays only when the forced positive-overload depth begins to grow.

go C80 cap prove or falsify a q-uniform positive lower bound for retention
strength using opponent-marked secant algebra
