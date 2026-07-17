# C245 — pointed repair-profile ordinary log-concavity

**Lane:** `rp-next`

**Date:** 2026-07-17

**Status:** COMPLETE — no ordinary-LC counterexample in three exhaustive represented ranges; the
matroid-morphism theorems do not specialize to the all-subset repair profile. Retain a precisely
bounded representable-matroid conjecture. ULC remains false and out of scope.

## Decision

For a matroid `M` on `V union {x}`, with `x` a nonloop and noncoloop, define

```text
a_k(M,x) = #{S subset V : |S|=k and x in cl_M(S)}.
```

The C240 random scout found no failure of

```text
a_k(M,x)^2 >= a_(k-1)(M,x) a_(k+1)(M,x),                (LC)
```

but did falsify ultra-log-concavity. C245 materially strengthens the positive finite boundary:
ordinary LC holds throughout three complete represented ranges totaling 30,638 pointed noncoloop
types. The focused specialization audit does not turn this into a theorem by citation.

**Retain the representable pointed-profile LC conjecture:** `(LC)` holds for every finite matroid
representable over a field and every distinguished nonloop/noncoloop `x`.

This is intentionally narrower than an all-matroid conjecture. The present sweep covers two small
fields, and the cited morphism theory is field-independent but misses the enumerator. There is no
evidence here for a nonrepresentable extension.

## Exhaustive represented ranges

The certificate fixes the target using projective transitivity. For each possible helper
restriction `H`, it computes all coefficients simultaneously by cardinality-graded subset zeta
transforms and checks exact integer inequalities.

| Range | Complete universe | Pointed noncoloop cases | Result |
|---|---:|---:|---|
| simple binary, rank at most four | all `2^14 = 16,384` helper restrictions of `PG(3,2)` with one fixed target; hence every simple binary pointed matroid of rank at most four, up to 15 ground elements | 15,521 | LC |
| simple ternary, rank at most three | all `2^12 = 4,096` helper restrictions of `PG(2,3)` with one fixed target; hence every simple ternary pointed matroid of rank at most three, up to 13 ground elements | 3,984 | LC |
| binary with loops and parallels, rank at most three | every weak composition of at most eight helpers among the zero vector and the seven points of `PG(2,2)`; hence every pointed binary representation of rank at most three and ground size at most nine | 11,133 of 12,870 multiplicity types | LC |

The last range closes a limitation of the simple-matrix C240 sample: repeated and zero helper
columns are included. A multiplicity type represents all labeled copies with those vector
multiplicities, since relabeling does not alter `a_k`.

The restriction counts by total ground size are preserved in the JSON certificate. No random
sampling, floating-point comparison, graph-isomorphism classification, or assumption of full
ambient rank enters these checks.

## Exact matroid-perspective specialization

Put

```text
D = M\x,              C = M/x.
```

For every `S subset V`, contraction gives

```text
r_D(S)-r_C(S) = 1  iff  x in cl_M(S),
r_D(S)-r_C(S) = 0  otherwise.                             (1)
```

Thus `sum_k a_k u^k` is exactly the rank-drop-one, all-subset slice of the elementary
perspective `D -> C`. This is the one-element pointed/Las Vergnas home identified in C227.
Las Vergnas's corank-nullity expansion records the slice and supplies deletion--contraction and
duality, but the 1999 paper's universal coefficient result concerns linear relations, not
log-concavity ([authoritative PDF](https://www.numdam.org/article/AIF_1999__49_3_973_0.pdf), cached
as `10.5802/aif.1702`, SHA-256
`645aeb2c003aecefc4f7ccec9e771bb287a9bbf5d79182fda2e848b8b235d19d`).

Eur--Huh's theorem is close but not the desired statement. A basis of a morphism `D -> C` is a set
that is **independent in `D` and spanning in `C`**. Their cardinality sequence is ultra-log-concave
([Theorem 1.3](https://web.math.princeton.edu/~huh/MatroidMorphism.pdf)), whereas (1) counts every
rank-drop-one set, including sets dependent in `D` and sets not spanning `C`.

The mismatch can be seen directly in their two-parameter Tutte polynomial

```text
Z_(p,q)(w) = sum_S p^(-r_D(S)) q^(-r_C(S)) w^S.
```

Their Lorentzian theorem assumes `0 < p,q <= 1`. To isolate the success indicator in (1), one
would set `p=t`, `q=t^(-1)`, multiply by `t`, and take `t -> 0`; this weights a term by
`t^(-(r_D-r_C))`. But then `q>1`, outside the proved parameter cone. Their valid two-parameter
boundary limit instead isolates the independent-and-spanning morphism bases. The later bimatroid
result likewise enumerates morphism bases, not this all-subset slice
([Röhrle--Ulirsch](https://arxiv.org/abs/2402.15317)).

The 2026 characterization of Lorentzian homogeneous set-function enumerators also does not fill
the gap: it characterizes the full `q`-family by `M^natural`-concavity, while C240's explicit ULC
counterexample already shows that the successful-set indicator need not have the corresponding
Lorentzian/ULC conclusion
([Ardila-Mantilla et al.](https://arxiv.org/abs/2601.02547)). Ordinary LC is weaker and remains
untouched.

## Boundary and stop condition

This task therefore ends at the intended third success condition: a materially stronger finite
boundary supporting a precise conjecture.

- It is not theorem-by-citation: the available theorems impose independence and spanning.
- It is not a counterexample: all three exhaustive ranges pass.
- It does not reopen ULC; C240's seven-column binary counterexample remains decisive.
- It does not justify a bespoke Hodge/Lorentzian proof. The concrete missing step would be a new
  preservation theorem for the rank-drop-one all-subset slice outside the known parameter cone.

A future promotion should require either a counterexample beyond these ranges or that exact
preservation lemma. Merely enlarging another random sample is below the promotion gate.

## Reproducibility

[`2026-07-17-c245-pointed-profile-log-concavity.py`](2026-07-17-c245-pointed-profile-log-concavity.py)
performs the three exhaustive sweeps and asserts that no LC failure occurs. Its exact output is
[`2026-07-17-c245-pointed-profile-log-concavity.json`](2026-07-17-c245-pointed-profile-log-concavity.json).

Run from `rust/`:

```bash
python3 ../notes/2026-07-17-c245-pointed-profile-log-concavity.py
```

