# C833 — global AME rounding beyond support orthogonality (2026-08-02)

**Lane**: `ame-lu`.

No statement in this report rests on a computation.  The proof replaces
support-sector aggregation by a quantitative cleaning-commutator argument on
the one-logical-qudit quantum-MDS code obtained by choosing any AME party as
the logical leg.  No certificate bundle ships.  No novelty claim is made and
no literature audit was run.

## 0. Verdict

The q-greater-than-four obstruction in C830 is a boundary of the
minimum-support energy method, not a boundary of global rounding.

Let `psi` be a stabilizer `AME(2m,q)` state, `q=p^e`, `n=2m`, and let
`U=Tensor_i U_i` have ray defect `eps`.  Choosing party `i` as the logical
leg turns the other `2m-1` parties into an exact `[[2m-1,1,m]]_q`
stabilizer code.  The product of the other local factors approximately
implements the transpose of `U_i` on that code, with normalized
Hilbert--Schmidt error exactly `eps`.

Partition the physical parties into three correctable regions of sizes
`m-1,m-1,1`.  Clean two logical Paulis away from the first two regions.
The nested commutator of the transversal physical unitary with those two
representatives is supported on the third region, so exact error correction
makes its compression to the code scalar.  Approximate implementation costs
only four copies of `eps`; replacing the compressed scalar by a phase costs
another factor two.  Hence every nested logical Pauli commutator is within
`8 eps` of a phase.

A one-site Fourier lemma then closes the proof: if all nested Weyl
commutators of a unitary are within `eta` of phases, the unitary lies within
`eta` of a Clifford once `eta < tau_p`.  Applied at every party, this gives
local Clifford frames with

```
q^(-1/2) ||U_i-K_i||_HS <= 8 eps
```

independently of `m`.  The AME second moment combines the frame errors in
`ell^2`, the stabilizer overlap gap makes the product frame an exact
symmetry, and the budget-free local theorem sharpens the residual estimate.

The resulting frame/decomposition threshold is of order `n^(-1/2)` for
fixed local dimension, in every characteristic:

```
R_clean = min {
  tau_p/8,
  1/(4 sqrt(2q)),
  1/(8 pi sqrt(n)),
  d_p/(1+4 pi sqrt(n))
},
d_p = sqrt(2-2 p^(-1/2)).
```

Below it,

```
U = g Tensor_i exp(i h_i),
g an exact product-Clifford symmetry,
spread(h_i) <= pi,
(Sum_i ||h_i||_F^2)^(1/2) <= pi sqrt(q) eps.
```

If the older global generator budget and sharper local constant are wanted,
the threshold

```
min { tau_p/8, 1/(16 pi n sqrt(q)) }
```

gives `Sum_i ||h_i||_op <= 1/2` and
`D <= sqrt(6q/5) eps`.

Thus C833 is positive, all-q, and stronger than both C830 routes.  It does
not establish an optimal defect threshold: the `n^(-1/2)` enters when the
independently recovered local frame errors are combined, and no adversarial
family is known to saturate it.

## 1. Metrics and the encoder form

For a q-dimensional unitary `A`, write

```
d_2(A,B) = q^(-1/2) min_{|z|=1} ||A-zB||_HS,
d_sc(A)  = q^(-1/2) min_{|z|=1} ||A-zI||_HS.
```

Let `V_i : C^q -> (C^q)^(Tensor (n-1))` be the encoding isometry obtained
by reshaping `psi` across party `i`:

```
|psi> = q^(-1/2) Sum_a |a> Tensor V_i|a>.
```

AME gives an `[[n-1,1,m]]_q` stabilizer code.  In particular every set of
at most `m-1` physical parties is exactly correctable.

> **Lemma 1 (state defect is implementation error).** Put
> `T_i=Tensor_{j != i} U_j`.  After optimizing the ray phase, there is a
> logical unitary `L_i`, obtained from `U_i` by transpose, inverse, and a
> scalar, such that
> ```
> q^(-1/2) ||T_i V_i - V_i L_i||_HS = eps(U).
> ```
> Transpose and inverse preserve distance from the one-qudit Clifford group.

**Proof.** This is the vectorization identity for the displayed Choi form.
Both sides use the same phase optimization, and the norm of a vectorized
map is its Hilbert--Schmidt norm divided by `sqrt(q)`.  The one-qudit
Clifford group is closed under inverse, transpose, and complex conjugation.
`square`

## 2. Quantitative cleaning commutators

The two exact code facts needed below are included for scope control.

> **Lemma 2 (cleaning and scalar compression).** Let `V` encode a
> stabilizer code of distance `d`.  If `R` has fewer than `d` parties, then:
>
> 1. every logical Pauli has a physical Pauli representative supported on
>    `R^c`;
> 2. every operator `C` supported on `R` satisfies `V^dagger C V=cI` for
>    some scalar `c`.

**Proof.** For the first statement, write the stabilizer label space as
`S` and its symplectic orthogonal as `S^perp`.  A logical Pauli is a class
in `S^perp/S`.  The symplectic orthogonal of the coordinate projection
`pi_R(S)` consists of labels on `R` whose zero extension belongs to
`S^perp`.  Distance says every such label belongs to `S`; hence every
`x in S^perp` restricts to an element of `pi_R(S)`.  Subtracting the
corresponding stabilizer cleans `x` from `R`.  For the second statement,
expand `C` in the Pauli basis on `R`.  A term in `S` compresses to a scalar,
a term outside `S^perp` has zero compression, and distance excludes a
nontrivial class in `S^perp/S` supported on `R`.  `square`

For a physical unitary `T` and a logical unitary `L`, define

```
E(T,L) = q^(-1/2) ||T V - V L||_HS.
```

The triangle inequality gives the composition rules

```
E(TS,LM) <= E(T,L)+E(S,M),
E(T^dagger,L^dagger)=E(T,L).
```

> **Lemma 3 (nested commutator test).** Suppose `T` is transversal and
> `E(T,L)<=eps` on an `[[2m-1,1,m]]_q` stabilizer code.  Then for all
> logical Weyls `P,Q`,
> ```
> d_sc([[L,P],Q]) <= 8 eps,
> ```
> where `[A,B]=ABA^dagger B^dagger`.

**Proof.** Partition the physical parties into `R_1,R_2,R_3` of sizes
`m-1,m-1,1`.  Lemma 2 supplies a representative `P_tilde` of `P` outside
`R_1` and a representative `Q_tilde` of `Q` outside `R_2`.  Transversality
makes `[T,P_tilde]` supported outside `R_1`, so
`C=[[T,P_tilde],Q_tilde]` is supported on
`R_1^c intersect R_2^c=R_3`.  The composition rules give

```
E(C,[[L,P],Q]) <= 4 eps.
```

Lemma 2 gives `V^dagger C V=cI`, hence the logical nested commutator is
within `4 eps` of `cI`.  Its normalized Hilbert--Schmidt norm is one, so
`|c|>=1-4eps`; replacing `c` by its phase costs at most another `4eps`.
`square`

## 3. The one-site Fourier lemma

Let `W_a`, `a in F_q^2`, denote the field-Weyl basis.  The argument below
works on its underlying `F_p` trace-symplectic label space.

> **Lemma 4 (nested Weyl commutators round to Clifford).** Let `L` be a
> one-qudit unitary and suppose
> ```
> d_sc([[L,W_v],W_w]) <= eta
> ```
> for all labels `v,w`.  If
> ```
> eta < tau_p = min {1/3, sin(pi/p)/(2 sqrt(2))},
> ```
> then there is a one-qudit additive Clifford `K` with
> `d_2(L,K)<=eta`.

**Proof.** Put `A_v=L W_v L^dagger`.  Since conjugating `W_w` by
`W_v` changes only its phase, the hypothesis says
`d_sc([A_v,W_w])<=eta`.

We first record a Fourier fact.  If a unitary
`A=Sum_a c_a W_a` satisfies `d_sc([A,W_w])<=eta` for every `w`, then
`A` lies within `eta` of a Weyl axis.  Indeed the commutator estimate is
equivalent to `A` lying within `eta` of a phase times
`W_w A W_w^dagger`.  With `p_a=|c_a|^2`,

```
|Sum_a p_a chi_w(a)| >= 1-eta^2/2.
```

Character orthogonality and averaging over `w` give

```
Sum_a p_a^2 >= (1-eta^2/2)^2.
```

Thus `max_a p_a >= (1-eta^2/2)^2`, which is exactly the assertion that
`A` is within normalized, phase-optimized Hilbert--Schmidt distance `eta`
of some `W_a`.

Apply this to every `A_v`; write the unique nearby axis as `W_{F(v)}`.
The identity `A_{v+u}=phase*A_v A_u` and the triangle inequality put
`W_{F(v+u)}` within `3eta` of the axis `W_{F(v)+F(u)}`.  Distinct Weyl
axes have phase-optimized distance `sqrt(2)`, so `eta<1/3` makes `F`
additive.  Comparing the exact commutator phases of `A_v,A_u` with those
of their nearby Weyls costs at most `4eta`; the least nontrivial p-th-root
chord is `2 sin(pi/p)`, so the stated bound makes `F` trace-symplectic.

Choose a Clifford `K_0` inducing `F`.  Then
`P=K_0^dagger L` approximately fixes every Weyl axis, so every
`[P,W_v]` is within `eta` of a phase.  The same Fourier fact puts `P`
within `eta` of a Weyl.  Multiplying that Weyl into `K_0` gives the
required Clifford `K`.  `square`

## 4. Global theorem

> **Theorem 5 (cleaning-based global rounding).** Let `psi` be a stabilizer
> `AME(2m,q)` state, `q=p^e`, `m>=2`, `n=2m`, and put
> ```
> d_p = sqrt(2-2p^(-1/2)),
> R_clean = min {
>   tau_p/8,
>   1/(4 sqrt(2q)),
>   1/(8 pi sqrt(n)),
>   d_p/(1+4 pi sqrt(n))
> }.
> ```
> If `eps(U)<R_clean`, then every local factor has a Clifford `K_i` with
> ```
> q^(-1/2)||U_i-K_i||_HS <= 8 eps(U),
> ```
> the product `g=Tensor_i K_i` is an exact symmetry, and, up to phase,
> ```
> U=g Tensor_i exp(i h_i),
> spread(h_i)<=pi,
> (Sum_i ||h_i||_F^2)^(1/2) <= pi sqrt(q) eps(U).
> ```

**Proof.** Apply Lemmas 1, 3, and 4 at each choice of logical party, with
`eta=8eps`.  This gives all frames.  Choose principal logarithms after
optimizing the local phases.  If
`d_i=q^(-1/2)||U_i-K_i||_HS<=8eps`, then

```
Sum_i ||h_i||_F^2 <= (pi^2 q/4) Sum_i d_i^2
                  <= 16 pi^2 q n eps^2.
```

The second clause in `R_clean` puts each spectrum in an arc of length at
most `pi`, and the third gives the preliminary bound `D<=sqrt(q)/2`.
Two-uniformity gives

```
||(g^dagger U-I)psi|| <= D/sqrt(q) <= 4 pi sqrt(n) eps.
```

The fourth clause and the triangle inequality put `g psi` less than `d_p`
from `psi`.  Stabilizer-overlap quantization forces `g` to be an exact
symmetry.  The residual has the original defect, spectral spread at most
`pi`, and preliminary `D<=sqrt(q)/2`; budget-free local stability therefore
sharpens `D` to `pi sqrt(q) eps`.  `square`

> **Corollary 6 (legacy generator budget).** Under
> ```
> eps(U) < min {tau_p/8, 1/(16 pi n sqrt(q))},
> ```
> the same factorization can be chosen with
> `Sum_i ||h_i||_op<=1/2` and
> `D<=sqrt(6q/5) eps(U)`.

**Proof.** The local frame estimates give
`Sum_i min_phase ||U_i-phase*K_i||_op<=8n sqrt(q)eps`.  The principal-log
bound multiplies this by at most `pi`.  The displayed threshold puts the
sum below `1/2`; the same small bound puts the rounded Clifford inside the
uniform stabilizer gap.  Apply the manuscript's sharp local theorem.
`square`

## 5. Comparison with C786 and C830

For fixed `q`, the new frame/decomposition radius is `Theta_q(n^(-1/2))`.
It replaces:

- C786's single-marginal radius of order `q^(-(m+2)/2)/m`;
- C830's aggregate radius of order `m^(-3/4)(2/q)^m`;
- C830's `ell^1` radius of order `m^(-5/4)(2/q)^m`.

The gain comes from using the code's exact correction structure rather than
estimating any stabilizer coefficient.  No marginal signal amplitude occurs
in Lemma 3.  Dependence on `q` remains in the local commutator resolution
`tau_p`, the spectral-arc entry condition, and the residual stability
constant; dependence on `n` enters only when all independently recovered
local frames are combined.

This theorem does not subsume C830 conceptually.  C830's support-energy
identity remains a useful exact statement and explains why minimum-support
aggregation alone changes behavior at `q=4`.  C833 shows that the right
object above that boundary is the encoded logical action, not a stronger
inequality among the same support blocks.

## 6. Adversarial pass

1. **Leakage from the code.** The implementation metric compares isometries,
   not only compressed logical matrices.  The composition estimate therefore
   tracks leakage through the commutator word; no invariant-code assumption
   is inserted silently.
2. **Cleaning representatives with overlapping support.** Only avoidance of
   `R_1` and `R_2` is used.  Transversality turns the nested commutator support
   into the intersection of those complements, exactly `R_3`; the two
   representatives need not otherwise be disjoint.
3. **A supported operator can leak even on a correctable region.** Correct.
   The proof uses only its compression `V^dagger C V=cI`, not `CV=cV`.
   The isometry error supplies the comparison to the logical unitary.
4. **The scalar `c` need not have unit modulus.** Correct.  This is the
   source of the second factor two, from `4eps` to `8eps`.
5. **Composite prime powers.** The Fourier argument uses the underlying
   `F_p` character group and trace-symplectic pairing.  The Clifford target
   is the full additive Clifford group, not a semilinear subgroup.
6. **Distributed near-identity rotations.** They are compatible with the
   theorem and explain why combining per-site frame errors naturally costs
   `sqrt(n)`.  They do not prove that the displayed defect radius is sharp.
7. **Exact non-Clifford transversal gates.** At `eps=0`, Lemma 3 makes every
   nested logical commutator scalar and Lemma 4 makes every logical factor
   Clifford, recovering the exact theorem rather than assuming it.

No structural counterfamily survives.  The only unresolved sharpness issue
is whether the `sqrt(n)` combination loss is attainable by a family of
approximate symmetries far from every exact frame.

## 7. Trust boundary and manuscript disposition

Lemmas 1--4, Theorem 5, and Corollary 6 are complete manuscript proofs.  The
imported inputs are exact AME-to-quantum-MDS reshaping, stabilizer cleaning
and correctability (proved locally in Lemma 2), the one-qudit additive
Clifford/symplectic sequence, stabilizer-overlap quantization, and the
budget-free local stability theorem.  There is no computation, certificate,
or Lean coverage.

Adopt the cleaning theorem after the aggregate theorem and before the
single-marginal theorem.  Retain both older routes as explanatory bounds,
but change every summary sentence that calls their exponential scale the
best defect-only threshold.  State the new radius as a proved lower bound,
not optimal, and keep AME existence conditional wherever asymptotics are
discussed.

## 8. Extra-juice and Tao closeout

The free upgrade is that the same proof treats every party as the logical
leg, so it produces coherent local frames directly and also gives a robust
transversal-Clifford theorem for any one-logical-qudit stabilizer code whose
physical sites admit a three-region correctable partition.  AME/QMDS is one
clean specialization; the abstract code theorem is broader and should be
considered for a later formal or literature-audit task, not claimed here as
new.

The Tao-style reformulation is that support enumeration was the wrong scale.
The discrete Clifford conclusion is a third-order commutator statement.
Three correctable regions kill that commutator on the code, and Fourier
concentration turns approximate scalarity into a nearby Weyl axis.  The
party count appears only after that finite-dimensional rigidity problem has
already been solved.

## 9. Mystery ledger

- **Why did C830 encounter a `q=4` boundary?** Settled.  It counted
  minimum-support sectors.  The cleaning proof uses all error-correction
  relations at once and has no such boundary.
- **Is `n^(-1/2)` sharp?** Open.  The exact missing evidence is an
  approximate-symmetry family whose independently rounded local frame errors
  add in `ell^2` while the global defect stays smaller.  No such family is
  known.
- **Can the threshold be independent of `n`?** Open, and not promised.  It
  would require controlling the collective frame error directly from the
  nested-commutator tests, rather than summing their one-site conclusions.
- **Does the robust three-region theorem hold beyond stabilizer codes?** The
  commutator and scalar-compression steps hold for any exact quantum code;
  the last Fourier-to-Clifford step needs a specified logical Weyl system.
  Literature and scope are unaudited.  Owner: a separately allocated
  generalization task if desired.

