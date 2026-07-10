# Minimal-counterexample constraints for the odd projective-plane cap game

Date: 2026-07-09.

This note packages what is presently known about a counterexample to

```text
PG(2,q) is P for every odd prime power q.
```

The tags distinguish proof from computation.  `[LEAN]` means the project endpoint is proved in
Lean (subject only to the ordinary specification-match caveat).  `[PROVEN-PROSE]` means the claim
below has a direct mathematical proof but is not yet a Lean theorem.  `[COMPUTED]` records an
exhaustive or orbit-reduced solver result at its stated trust tier.  `[CONDITIONAL]` makes its
hypothesis explicit.

## The constraint package

### 1. The current lower frontier

**[LEAN]** An odd-plane counterexample has

```text
q not in {5, 7, 11, 13}.
```

These four exclusions are Lean-unconditional project results:
`initialPStatement_of_card_eq_five_finrank`,
`initialPStatement_of_card_eq_seven_finrank`,
`CertData.Q11.initialPStatement_finrank`, and
`CertData.Q13.initialPStatement_finrank`.

**[COMPUTED]** Under the current computed-result trust chain, an odd-plane counterexample has

```text
q >= 25.
```

Indeed, the odd prime-power orders below 25 are `3,5,7,9,11,13,17,19,23`, and every one is P at
its present evidence tier.  The tiers must not be collapsed:

| q | result | exact evidence tier |
|---:|:------:|---------------------|
| 3 | P | exhaustive solve; not Lean-closed |
| 5, 7 | P | Lean mechanism theorems |
| 9 | P | exhaustive solve; terminal-reply kernel isolated, Lean certificate open |
| 11, 13 | P | Lean certificate assemblies |
| 17, 19 | P | full `esc` campaigns; C30 anchored reply books pass the independent rules checker, but the generated Lean data path has not elaborated |
| 23 | P | C29: all 22 full-`PGL(2,23)` on-conic buckets P; C53 proves the orbit bridge in Lean; C37 finds zero disagreements on shared raw keys; C54 rules-only bucket-label certification remains open |

Thus `q >= 25` is a **computed frontier**, not a Lean theorem.  In particular, C30's rules-checker
PASS for q=17/19 does not justify calling those two rows Lean-unconditional, and q=23 still trusts
the solver-produced bucket labels.

### 2. A counterexample is totally depleted on the conic

**[LEAN + PROVEN-PROSE]** By the Lean escape/trap equivalence
`GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank`, a counterexample at `q`
contains a trapped normalized size-3 class.  For such a class,

```text
onP = 0,
onN = q - 4,
dep = q - 4.
```

Here `onP` and `onN` count P- and N-valued on-conic size-4 children, and

```text
dep(q, class) := (q - 4) - onP(q, class) = onN(q, class).
```

Proof: the normalized affine conic has `q-1` cells, three of which are already selected in the
size-3 residual, so it supplies exactly `q-4` legal on-conic children.  A trapped class has every
legal size-4 child N by definition.  In particular every one of those `q-4` on-conic children is N.

This is a P-value depletion statement.  It is distinct from `live_on`, which counts geometrically
legal conic cells at a later position without regard to their P/N value.

### 3. No census-propagation constraint is available

**[COMPUTED NEGATIVE]** C42 refutes the proposed value-blind, fixed-q census propagation
mechanism.  At the clean all-P orders q=13 and q=19, all size-3 classes already have different
full stabilizer-census vectors (`12/12` and `27/27` distinct).  At q=11 and q=17, the onP
variation is spread across all observed P-valued stabilizer orbits.

Therefore there is presently **no propagation constraint available** that turns one totally
depleted class into a global bound on `mu_on(q)`.  The conditional statement remains logically
valid—if a future theorem bounds class-to-class onP variation by `C`, then one class with `onP=0`
forces `mu_on(q) <= C`—but C42 supplies no such theorem and its proposed value-blind mechanism is
false.

### 4. The t-ply conic-depth constraint

**[PROVEN-PROSE]** C46 proves that after `t` further legal plies from an on-conic S4 root,

```text
live_on >= max(0, q - (t^2 + 5t + 5)).
```

More sharply, if `a` of those moves are on-conic and `b` are off-conic, `a+b=t`, then

```text
live_on >= max(0, q - 5 - (a + 5b + ab + b^2)).
```

The first depth at which the q-only bound no longer excludes conic-emptying is

```text
T(q) = ceil((sqrt(4q+5)-5)/2).
```

Thus a counterexample's on-conic S4 followers must retain a live conic at every depth `t<T(q)`.
Over q in `{11,13,17,19,23,25,27,29,31}`, the values are respectively
`1,2,2,2,3,3,3,3,4`.  This is a move-availability constraint, not a P-value or strategy theorem.
At `t=2` it recovers the old off/off, mixed, and on/on constants `q-19`, `q-13`, and `q-7` exactly.

### 5. Every play has length Omega(sqrt(q))

**[PROVEN-PROSE]** Every terminal cap-game position is a complete arc.  Let `k` be its size.  Each
of its `binom(k,2)` secants contains at most `q-1` points outside the cap, while completeness
requires the secants to cover all `q^2+q+1-k` outside points.  Hence

```text
(q - 1) * binom(k, 2) >= q^2 + q + 1 - k.
```

Equivalently, with

```text
b2(q) = ((q - 3) + sqrt((q - 3)^2 + 8(q - 1)(q^2 + q + 1))) / (2(q - 1)),
```

every terminal position satisfies

```text
k >= floor(b2(q)) + 1 = Omega(sqrt(q)).
```

This applies to every play, and therefore to optimal play under any tie-breaking convention.  It
is the `n=2` specialization of Alabdullah--Hirschfeld, Theorem 2.1, in
[A new lower bound for the smallest complete (k,n)-arc in PG(2,q)](https://doi.org/10.1007/s10623-018-00592-8).
The direct secant-cover proof above is included so the game-length corollary does not depend on a
notation convention for the smallest-complete-arc number.

Selected numerical lower bounds are:

| q | `b2(q)` | terminal moves at least |
|---:|--------:|------------------------:|
| 11 | 5.573 | 6 |
| 13 | 5.955 | 6 |
| 17 | 6.648 | 7 |
| 19 | 6.966 | 7 |
| 23 | 7.559 | 8 |
| 25 | 7.838 | 8 |
| 27 | 8.106 | 9 |
| 29 | 8.366 | 9 |
| 31 | 8.616 | 9 |

### 6. Large terminals are the full conic

**[PROVEN-PROSE + primary-source transcription]** C59 imports the exact verified
Ball--Lavrauw/Voloch arc-to-conic thresholds.  Let `B(q)` be the strongest applicable integer
upper bound for a non-conic arc (also capped by Segre's `q`).  Every terminal position has
projective size

```text
k = q+1 (the full conic), or k <= B(q).
```

Indeed, a terminal is a complete arc by Section 5.  Above the applicable threshold it is contained
in a conic; a proper subset of a conic is extendable by a missing conic point, so a complete arc
contained in a conic is the full conic.  For prime `q`, Ball--Lavrauw Theorem 3 gives

```text
B(q) <= ceil(q - sqrt(q) + 7/2) - 1.
```

For odd square `q=p^(2h)`, their Theorem 2 gives

```text
B(q) <= ceil(q - sqrt(q) + sqrt(q)/p + 3) - 1.
```

For odd non-square `q`, Voloch's strict threshold gives

```text
B(q) <= min(q, floor(q - (1/4)sqrt(pq) + (29/16)p - 1)).
```

This combines with Sections 4--5 as follows: C46 keeps a conic cell live at every depth `t<T(q)`;
the eventual terminal has size at least `floor(b2(q))+1`; and C59 says it is either no larger than
`B(q)` or is exactly the conic.  This constrains the early and terminal layers but supplies no
winning reply or P/N-value closure.  At odd square orders, Kestenband's verified construction gives
a non-conic arc of size `q-sqrt(q)+1`; completing it produces some non-conic complete arc between
that size and `B(q)`, not necessarily a complete arc at the construction size itself.

## Data appendix: candidate sequences, not submissions

To make `dep(q)` unambiguous and integer-valued, this table uses the **worst-class on-conic
P-value depletion**

```text
dep(q) := max_class onN = (q - 4) - min_class onP.
```

`mu_on(q)` is the mean onP count over canonical size-3 classes.  `N_canon(q)` is that class count.
`Z(q)` is much narrower: it is the maximum recursive steering ceiling over the sampled C20 P
reply-state corpus, not a theorem or a whole-game invariant.  A dash means that corpus statistic
was not computed.  q=3 is omitted because the normalized size-3 residual layer is absent there.

| q | `dep(q)` | `Z(q)` | `mu_on(q)` | `N_canon(q)` | source/tier |
|---:|---------:|-------:|-----------:|-------------:|-------------|
| 5  | 0 | — | 1 | 1 | full feat census; Lean outcome |
| 7  | 0 | — | 3 | 3 | full feat census; Lean outcome |
| 9  | 0 | — | 5 | 5 | full GF(9) feat census; computed outcome |
| 11 | 5 | — | `17/4 = 4.25` | 8 | full feat census; Lean outcome |
| 13 | 0 | 2 | 9 | 12 | full feat census; C31 steering corpus; Lean outcome |
| 17 | 12 | 9 | `19/7 ~= 2.714286` | 21 | full feat census; C31 steering corpus; rules-checked computed outcome |
| 19 | 0 | 16 | 15 | 27 | full feat census; C31 addendum; rules-checked computed outcome |
| 23 | 0 | — | 19 | 40 | C29 all-22-bucket P result + C53 bridge; size-3 class enumeration; computed only |

For q=23, `mu_on=19` and `dep=0` follow from all full-PGL on-conic buckets being P, not from a
completed size-3 feat run.  That distinction matters because the old q=23 size-3-rooted solve hit
its memo cap.  The tuple columns are prepared for later sequence comparison, but `Z(q)`'s changing
corpus domain and the mixed proof/computation tiers make the combined table unsuitable for an OEIS
submission as it stands.  No submission has been made.

## What remains open

The package constrains but does not eliminate a counterexample.  C46 now supplies the honest
`t`-ply depletion ladder, but it guarantees only live legal conic cells, not P-valued replies or
`Good` closure.  The next trust upgrade at the computed frontier is C54's rules-only verification
of the 22 q=23 bucket labels.  Neither result should be upgraded beyond its stated scope.
