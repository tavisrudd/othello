# C77 continuation — the game-semantic residue is C74 pencil N-absorption

**2026-07-11 (Codex).**  This continuation starts after the reservoir-free DROP ledger was proved
root-peak-bounded and found to carry no P/N information.  The generic C61 reply quotient remains
closed-negative: six exact q=17/q=19 forced states with identical normalized geometry require
different replies.  The surviving game-semantic target is therefore the explicit C74
one-intruder pencil, not another global potential or static selector.

## Verdict

There is one new proof target and one exact base certificate.

1. **Computed N-absorption target.**  On every maximum-capacity C74 pencil in the exact
   q=11/13/17/19 corpus,

   ```text
   number of N-valued legal off-conic centers <= q - 8.
   ```

   The bound is tight at q=17.  A maximum pencil has product-collision count `d<=5` and hence
   `q-1-d` legal off-conic centers, so the bound leaves at least

   ```text
   (q-1-d) - (q-8) = 7-d >= 2
   ```

   P centers.  If proved uniformly, this bypasses the stronger (ON) route and proves the actual
   odd-escape obligation directly: every residual size-3 class has a P-valued size-4 child.

2. **Exact q=11 base compression.**  The two knife-edge q=11 classes have 32 distinct P-valued
   off-conic centers across their tied maximum pencils.  For each P root, form the winning-reply
   graph whose vertices are legal opponent moves and whose edges `{x,y}` satisfy
   `root union {x,y}` P.  All 32 graphs have perfect matchings.  They collapse to exactly four
   abstract isomorphism types:

   ```text
   roots  vertices  edges
      10        18     15
       2        12      6
      10        18     30
      10        20     40
   ```

   This turns the mandatory q=11 4P/2N obstruction into a four-type first-reply certificate target.
   It is not yet a uniform proof: the graph edges use exact game values, and every matched P
   follower still needs its recursive reply book.

## Exact pencil census

For every minimum-`d` line in every recorded class, the table gives
`(d, number of P off-conic centers, number of N off-conic centers) : number of pencils`.

| q | maximum-pencil histogram | max N centers | `q-8` | min P centers |
|---:|---|---:|---:|---:|
| 11 | `(4,4,2):16` | 2 | 3 | 4 |
| 13 | `(4,6,2):6`, `(4,7,1):9`, `(4,8,0):3` | 2 | 5 | 6 |
| 17 | `(4,3,9):6`, `(4,4,8):3`, `(4,5,7):6`, `(4,6,6):6` | **9** | **9** | 3 |
| 19 | `(4,14,0):31`, `(5,13,0):150` | 0 | 11 | 13 |

This is exact computed evidence, not an extrapolated theorem.  In particular, the constant eight
is named because q=17 realizes equality, not because a proof mechanism for it is known.

## Static pencil signatures do not supply the theorem

For a legal center `z_a`, after normalizing the pencil endpoints to `(0,infinity)`, the probe
recovers the involution parameter `a` from the common transformed product of every conic chord
through `z_a`.  It then computes three scale-invariant, value-blind signatures:

- the quadratic character of `a`;
- the character multiset of `a-b` over the forbidden product set `B=P2(U)`;
- the multiplicative-order multiset of `a/b`, `b in B`.

At the q=11 knife edge, the gap signature with three nonsquares and one square is P on all ten tied
pencils.  It does **not** generalize: at the q=17 knife edge the same signature is N.  Even the
combined character/order signature finds a globally P-pure choice on only 28 of the 37 depleted-order
maximum pencils; the nine uncovered pencils are q=17 controls.  This is another selector failure,
not an N-absorption proof.

## Reply-graph interpretation and limits

For a P root `S`, the root game equation makes the winning-reply graph undirected: `{x,y}` is an
edge exactly when the common two-move follower `S union {x,y}` is P.  No isolated vertices is merely
the P equation.  A perfect matching is stronger: it supplies a fixed first-response pairing at that
root.  The exhaustive q=11 result shows that every P center needed to defeat the knife-edge pencil
has such a pairing, and the four graph types show this is structured rather than 32 unrelated rows.

It is still only the first response layer.  A representative root has several moves with no
symmetric P reply, so the finding does not resurrect the adaptive-symmetry route.  Nor does a
value-aware matching explain why its edges are P.  The theorem-level continuation must derive an
N-absorption or recursive reply-book closure from the one-intruder geometry.

## Updated frontier

- **Primary:** prove or refute `Ncenters(A,F,w) <= q-8` for a C74 maximum pencil.  The q=17 equality
  cases are the mandatory sharp examples.
- **Base formalization:** identify the four q=11 reply-graph types geometrically and emit rules-only
  books for one representative of each type.  This compresses the small-order obstruction but does
  not replace the uniform absorption theorem.
- **Closed:** more DROP-envelope computation; generic C61/C75/C76 feature refinement; a uniform
  character/order selector on `a`.

## Follow-up: a value-blind two-stage packet isolates the absorption signal

The raw bound `Ncenters<=q-8` now has a concrete candidate mechanism.  For a maximum pencil `L`,
let `zone_v(z)` be the number of legal **off-conic** moves remaining after selecting its center `z`.
Let `Low4(L)` contain every center whose `zone_v` is at most the fourth order statistic (include the
whole tie at the boundary).  Both stages are value-blind:

```text
choose L by minimum product-collision d (maximum legal capacity);
choose Low4(L) by minimum remaining off-conic support.
```

Exact scores on every maximum pencil:

| q | `(packet size, P, N) : pencils` |
|---:|---|
| 11 | `(5,4,1):6`, `(6,4,2):10` |
| 13 | `(4,4,0):12`, `(5,3,2):6` |
| 17 | `(4,4,0):3`, `(5,3,2):6`, `(7,4,3):6`, `(7,5,2):6` |
| 19 | all packet members P |

Thus every `Low4(L)` contains at least three P centers, exactly the strength needed for
`Ncenters<=q-8` when `d=4` (and stronger when `d=5`).  At the six tight q=17 pencils the packet is
`5=3P+2N`; the remaining seven centers are N.

The non-maximum-line control shows this is not a generic small-q correlation:

| q | non-maximum candidate lines | Low4 failures (`<3 P`) |
|---:|---:|---:|
| 11 | 264 | **264** |
| 13 | 522 | 78 |
| 17 | 1,344 | **1,332** |
| 19 | 1,844 | 0 (all size-4 positions are P at this order) |

So maximum capacity and low-zone selection are both load-bearing.  Pointwise minimization is false:
the unique minimum-zone center is N on six q=13 and six q=17 maximum pencils.  The candidate theorem
must be set-valued (`Low4` contains P), not a deterministic minimum selector.

This remains computed, not proved.  It is nevertheless a substantially narrower proof target than
unqualified N-absorption: derive the maximum-pencil geometry of `zone_v`, then prove that the tied
fourth-order packet cannot be entirely N (observed strength: at least three P).

The new solver mode

```text
fanmoves q r,c r,c r,c
```

solves one size-3 fan once and emits the exact P children of every size-4 extension.  On a tight
q=17 pencil, its nine N centers have 4–16 P children each; hence the mechanism is not a unique or
forced one-ply escape.  `s4potentialprobecells` was also generalized so cells after the three conic
fit points may be off-conic intruders.

### Exact five-spoke collision formula

`zone_v` on the pencil has a closed incidence formula.  Before choosing a center, the legal
off-conic size-4 extensions of the size-3 root number

```text
(q^2 - 9q + 21) - (q - 4) = (q - 5)^2.
```

Fix a legal center `z`.  For each of the five selected conic-frame points `e`, let `s_e(z)` be the
number of legal off-conic extensions on the spoke `ze`, including `z`.  The five spokes meet only at
`z`; after selecting `z`, each kills its other `s_e-1` off-conic points.  Therefore

```text
zone_v(z) = (q-5)^2 - 1 - sum_e (s_e(z)-1)
          = (q-5)^2 + 4 - sum_e s_e(z).                 (1)
```

Each spoke has its own product-collision count:

- if `ze` is a secant with second conic point `tau_a(e) != e`, C74 gives
  `s_e = q-1-d_e`, where `d_e in {4,5,6}`;
- if `ze` is tangent at `e`, let `delta_e` count the distinct intersections with the six chords
  among the other four frame points; then `s_e=q-delta_e`, again `delta_e in {4,5,6}`.

Writing `delta_e=d_e` on secants and letting `t(z)` count tangent spokes gives the uniform formula

```text
zone_v(z) = q^2 - 15q + 34 + sum_e delta_e(z) - t(z).   (2)
```

The script checks (1) and (2) exactly on all 2,876 maximum-pencil centers at q=11/13/17/19.  Thus
`Low4` is equivalently the fourth-order packet for the finite five-term collision score

```text
K(z) = sum_e delta_e(z) - t(z),    delta_e in {4,5,6},  0 <= t <= 2.
```

At each of the six tight q=17 pencils the score layers are

```text
K=24: 1 P
K=26: 2 non-tangent P + 2 tangent N
K=28: 7 N
```

so `Low4={K<=26}` is exactly `3P+2N`.  This explains the packet geometrically but also exposes the
remaining barrier: collision score and tangency do not determine value globally.  The corpus has
both P and N at identical `(K,t)` (for example q=17 has both at `(24,0)` and `(28,0)`).  The open
lemma is therefore genuinely game-semantic:

> Among the centers with the four smallest five-spoke collision scores on a maximum C74 pencil,
> at least one is P (observed strength: at least three).

The geometry has now been reduced to a bounded collision vocabulary; the missing step must compare
the recursive games of several packet centers, not classify one center by a scalar.

### Balanced-center refinement and the Baer exception

The full five-spoke defect vector exposes a sharper value-blind candidate. If the primary maximum
pencil has collision count `d`, call a legal center **balanced** when its sorted spoke defects are

```text
(d,5,5,6,6).
```

Every maximum pencil in the exact q=11/13/17/19 corpus has balanced centers, and all 760 recorded
center occurrences are P (32, 42, 72, and 614 respectively). This is strictly stronger evidence
than the scalar `K` score: the vector identifies a P-pure subtype in the available value data.

The geometry-only orbit census, which reads no game labels, finds a balanced center on every maximum
pencil at the tested prime orders q=11,13,17,19,23,29,31. It also finds the first extension-field
obstruction at GF(25). For the five-set `A={0,1,2,3,4}` and each of its five maximum pencils with endpoint
`w=infinity`, every legal
center has type `(4,6,6,6,6)`, so the balanced type does not exist. The six-set
`A union {infinity}=P^1(F_5)` has PGL stabilizer 120: this is the embedded subfield/Baer-subline
exception, not a game-value counterexample. (The existing q=25 census labels all on-conic buckets
P, but supplies no uniform proof of that endpoint.)

The first honest theorem target was therefore a disjunction, not unconditional balanced-center
existence:

1. in the generic branch, prove geometrically that a maximum pencil has a balanced center and prove
   game-semantically that every such center is P; or
2. in a subfield exceptional configuration, prove the pencil endpoint or another legal center P by
   a separate argument.

`Low4` remains the uniform fallback while this split is unproved. The balanced-center claim should
not yet be formalized in Lean: its original universal form is false, and its P-purity is presently a
finite exact observation rather than a recursive game theorem. The stable five-spoke incidence
identity (1)--(2) is suitable for later formalization once this branch theorem is settled.

### Exact `d=4` normal form and the second subfield exception

The GF(25) obstruction is not the whole exceptional branch. Every `d=4` pencil can be normalized to

```text
(e,w)=(0,infinity),    A={0,+-1,+-x},
B=P2({+-1,+-x})={-1,-x^2,+-x}.
```

Write `tau_a(t)=a/t`; legal parameters are `a in F* \ B`. Factoring the three opposite-edge product
equalities at the spoke `+1` and transporting by `t -> t/x` gives one common collision parameter

```text
c0 = -2x^2/(1+x^2)
```

and four side parameters

```text
c1 =  x(x-1)/(1+3x)       c2 = -x(x+1)/(3x-1)
d1 = -x(x-1)/(x+3)        d2 =  x(x+1)/(x-3),
```

with a zero denominator interpreted as a missing parameter. The defects at `+1,-1` agree, as do
those at `+x,-x`, because `t -> -t` preserves both A and `tau_a`. A legal parameter is balanced
exactly when it occurs with multiplicity one in `[c1,c2,d1,d2]` and differs from `c0`. This is an
exact rational selector lemma, not a value fit: `c0` collides on both opposite pairs; repeated side
values create a double collision or collisions on both pairs; a singleton side value creates
precisely `(4,5,5,6,6)`.

The executable normal-form census verifies this formula with zero mismatches for every x in all
tested fields: primes 7 through 101 and GF(9), GF(25), GF(27), GF(49), GF(121), GF(125), GF(343).
It exposes two persistent failure families:

```text
characteristic 5: x=+-2
characteristic 7: x in {+-2,+-3}.
```

The first is the embedded `P^1(F5)` six-set. The second is inherited from the separately solved q=7
normal form: GF(49) and GF(343) still have no balanced center at those four prime-subfield values,
even though their many extension-field legal parameters all have type `(4,6,6,6,6)`. Thus the
earlier “Baer exception” wording was too narrow. The remaining geometric task is now finite and
explicit: cross-multiply the equality/forbidden cases among `c0,c1,c2,d1,d2` to prove that these are
the only empty-selector cases over every odd field, then formulate the two small-subfield game
lemmas. The `d=5` maximum-pencil branch also remains to be proved geometrically.

### `d=5` collision-certificate ledger

The `d=5` branch has an equally small exact reduction. Normalize the unique primary product
collision as

```text
A={0,1,r,s,rs},    (e,w)=(0,infinity),    1*(rs)=r*s.
```

For a nonprimary frame point f and a pairing `{p,q}|{u,v}` of the other four frame points, put

```text
alpha=(p-f)(q-f),    beta=(u-f)(v-f),
a(f;pq|uv) = (alpha*u*v - beta*p*q)/(alpha-beta),
```

omitting a zero denominator or zero parameter. This follows by factoring the spoke product-equality
quadratic in `tau_a(f)`: one root is the trivial endpoint f and the displayed quotient is the
remaining center parameter. There are twelve such pointed-pairing certificates. Because the pencil
is maximum with `dmin=5`, no other spoke can have defect 4. Therefore the certificate degree of a
legal parameter is the number of its defect-5 nonprimary spokes, and a legal center is balanced
exactly when its certificate degree is two.

The twelve certificates are more structured than this raw count suggests. Label a certificate by
the directed edge `f->g`, where `(0,g)` is the pair containing zero. With `t=rs`, direct substitution
in the quotient proves four identities:

```text
C(1,r)=C(s,t),    C(1,s)=C(r,t),
C(r,1)=C(t,s),    C(s,1)=C(t,r).
```

Thus eight directed edges occur in four equal pairs. Only `1->t`, `t->1`, `r->s`, and `s->r` are
unpaired, so a legal degree-one label injects into these four edges and `n1<=4` is proved uniformly.

The normal-form census has zero formula mismatches and no balanced failures over all maximum forms
at q=19,23,25,27,29,31,37,49. It finds 2--4 balanced parameters per form. More importantly, every
form satisfies the same bounded ledger inequalities:

```text
T = number of nonzero finite certificate incidences >= 10,
F = certificate weight landing in the five forbidden parameters <= 3,
n1 = number of legal degree-one parameters <= 4 (now proved by the four identities),
every legal certificate degree <= 2.
```

Writing `n2` for legal degree-two parameters gives the exact count

```text
T-F = n1 + 2*n2.
```

Hence these inequalities imply `2*n2 >= 10-3-4=3`, so `n2>=2`: at least two balanced centers.
This is now the entire `d=5` geometric proof obligation. The quotient formula and counting
implication, `n1<=4`, and legal degree at most two are proved. The sole remaining uniform bound is
`F<=3`. Nonmaximum controls sharpen the route: every primary-d5 form hiding a d4 line violates at
least one ledger bound. Algebraically, the open bound says that forbidden labels carry weight at
most three; each forbidden equality should therefore construct the excluded d4 line directly.

For `T>=10`, the pole packet is already explicit. Up to nonzero factors, the four paired-label pole
conditions and four singleton pole conditions are

```text
A = s+rs-r-rs^2          E = r+s-2rs
B = r+rs-s-r^2s          F = r+s-2
C = s+rs-1-s^2           G = 1+rs-2s
D = r+rs-1-r^2           H = 1+rs-2r.
```

`A,B,C,D` each remove two certificates (the corresponding paired edges); `E,F,G,H` remove one.
A pole with source f is exactly a product collision on the candidate line `(f,infinity)`, so two
poles with the same source immediately make that line d=4. Therefore a counterexample to `T>=10`
would need at least three poles with distinct sources. The pairing graph leaves only fourteen
minimal patterns to exclude: eight paired-pole plus disjoint-singleton cases, two pairs of disjoint
paired poles, and four triples of singleton poles. Rectangle relabeling and rescaling act transitively
on each of these three pattern classes, so three representatives suffice:

1. `A=F=0` gives `B=0`, repeating source 1 and producing a d4 line.
2. `A=C=0` gives `(1-r)(1+s^2)=0`; distinctness yields `s^2=-1`, then C gives `r=-1`.
   Thus `U={+-1,+-s}` and the primary line itself has d=4.
3. `E=F=G=0`: subtracting E from F gives `rs=1`, and then G gives `s=1`, contradicting
   distinctness.

This exhausts the fourteen cases and proves `T>=10` for every odd field. The controls agree: every
`T<10` form exhibits the predicted repeated-source or primary-d4 obstruction.

The `F<=3` controls also collapse to one rectangle-symmetry template. In every primary-d5 form with
forbidden certificate weight four, exactly one paired label (weight two) and two singleton labels
are forbidden. The paired label coincides with one singleton at the same forbidden parameter, giving
forbidden degree three; the other singleton lands at a second forbidden parameter. No control has
two forbidden paired labels or four forbidden singletons. This template has zero violations over
q=19,23,25,27,29,31,37,49; when it occurs, the full pencil census always reports a hidden d4 line.
Thus the `F<=3` proof is reduced to one rational-equality orbit: normalize the coincident
paired/singleton value, use its membership in `{r,s,rs,r^2s,rs^2}` plus the second singleton's
membership, and construct the reported d4 line.

The forbidden-monomial assignments sharpen this further. Up to rectangle relabeling, the unique raw
template is

```text
C(1,r)=r^2s=C(1,rs),    C(r,s)=rs^2.
```

The first equality already supplies the contradiction: `C(1,r)` and `C(1,rs)` are two distinct
opposite-edge product collisions on the same candidate line `(1,r^2s)`, hence that line has d=4.
In every raw assignment, the coincident singleton shares its source with one of the two directed
edges represented by the paired label, so the same argument applies after relabeling. Consequently
the geometric contradiction for the observed template is proved. The only remaining `F<=3` step is
the finite assignment-classification lemma: show from membership in the five-element forbidden set
that any weight-four pattern must be one of these four relabelings (excluding two-pair and
four-singleton alternatives).

Resolving every individual label-to-forbidden-monomial equality yields a rigid target table:

```text
paired labels:     P1r -> rt,  P1s -> st,  Pr1 -> s,  Ps1 -> r
singleton labels:  S1t -> {rt,st}    St1 -> {r,s}
                   Srs -> {s,st}     Ssr -> {r,rt}.
```

There are zero target-table violations over every primary-d5 normal form tested through GF(49),
including nonmaximum controls. The classification lemma is therefore down to three algebraic
subclaims: (i) at most one paired target can hold; (ii) with a paired target, more than one singleton
target forces the already-proved incident coincidence/d4 template; and (iii) without a paired
target, at most three singleton targets can hold. Directly cross-multiplying the eight entries in
this table is the remaining route to `F<=3`.

The legal-degree controls admit the same source-incidence reduction. Every legal degree-3 merge is
one paired label plus an **incident** singleton: the singleton's source is one of the paired label's
two sources, so two collisions lie on the same candidate line and make it d=4 immediately. Every
degree-5 merge contains two adjacent paired labels (already sharing a source), plus a singleton, and
is therefore d4 for the same reason. Across q=19,23,25,27,29,31,37,49 there is no legal merge of a
paired label with a disjoint singleton, two opposite paired labels, or three singleton labels.
Rectangle symmetry makes these the three remaining equality orbits. Proving that each is impossible
under the primary-d5 hypotheses will establish legal certificate degree at most two.

Choosing representatives sharpens those three cross-multiplications:

```text
pair + disjoint singleton: C(1,r)=C(rs,1)  =>  C(1,s) has the same value;
opposite paired labels:    C(1,r)=C(r,1)   is incompatible with primary d=5;
three singleton labels:    C(1,rs)=C(rs,1)=C(r,s) is incompatible with primary d=5.
```

The three identities close algebraically. For the first, cross-multiplication gives

```text
C(1,r)=C(rs,1)  iff  (s-1)K=0,
C(1,r)=C(1,s)   iff  (r-s)K=0,
K=r^2s^2-3rs+r+s.
```

Distinctness (`s!=1`, `r!=s`) therefore forces the second equality, putting two collisions at source
1 and making line `(1,a)` d4. For opposite paired labels, their numerators differ by a sign, and the
denominator equation factors as `(r+1)(s-1)^2=0`; hence `r=-1` and the primary four-set is
`{+-1,+-s}`, already d4. Finally `C(1,rs)=C(rs,1)` makes the two singleton denominators negatives,
so `2(r+s-rs-1)=0`, equivalently `(r-1)(s-1)=0`, contradicting distinctness in odd characteristic.
Thus legal certificate degree is at most two over every odd field.

## Reproduction

```bash
cd rust
python3 -m py_compile scripts/c77_pencil_value_probe.py scripts/c77_intruder_reply_graph.py \
  scripts/c77_balanced_center_geometry.py
python3 scripts/c77_pencil_value_probe.py 11 13 17 19
python3 scripts/c77_balanced_center_geometry.py 11 13 17 19 23 25 29 31
python3 scripts/c77_balanced_center_geometry.py --normal-forms 7 9 11 25 27 49 121 125 343
python3 scripts/c77_balanced_center_geometry.py --d5-normal-forms 19 25 27 31 49
python3 scripts/c77_intruder_reply_graph.py --solver target/gridcap-ledger
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap-c77
target/gridcap-c77 fanmoves 17 0,0 1,1 2,3
```

The reply-graph pass uses `checkpos`, which fully solves every q=11 root/break pair and reports exact
P/N replies.  It checks reply-edge symmetry, computes an exact bitmask perfect matching, and clusters
the 32 graphs with a dependency-free exact isomorphism backtracker.
