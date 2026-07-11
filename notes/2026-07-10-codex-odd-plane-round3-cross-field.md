# Odd projective cap game — Codex round 3 cross-field report

**Date:** 2026-07-10
**Scope:** theorem refinement using existing exact artifacts, finite-field algebra,
equivariant game structure, and impartial-hypergraph structure theory
**New large solves:** none
**Replay working directory:** `/home/tavis/src/othello/rust` for every shell command below

## Executive result

No uniform proof of the odd-plane theorem was obtained.  The round did, however, turn the
hard `d=4` one-intruder pencil into a substantially smaller exact problem.

The strongest new chain is:

1. **[PROVED, round 2 input]** A `d=4` maximum-capacity pencil normalizes to
   `U={r,-r,s,-s}`.
2. **[PROVED]** Every legal center in that pencil gives a position invariant under the
   projective homology

       sigma(X:Y:Z) = (X:-Y:Z).

3. **[PROVED]** At every later `sigma`-invariant cap reached by mirror replies, `sigma(x)`
   is a legal reply to every legal move `x` except when `x` lies on one of exactly two
   fixed defect lines.  Both defect lines are option cliques.
4. **[PROVED]** For the character-selected half of the legal centers,
   `chi(-a)=-1`, neither defect line contains a live conic point.  Thus every unresolved
   mirror obligation is off-conic and lies on the union of two lines.
5. **[COMPUTED-EXACT]** This half-pencil contains a P child on every *per-frame* maximum
   line in all
   available exact prime-field data `q=7,11,13,17,19`.  The minimum P counts are
   `2,3,3,2,4`, respectively.  At `q=17`, 1,080 of 1,365 arbitrary candidate lines fail
   the same test, while all 21 maximum lines pass with at least two witnesses.  Hence the
   conjunction “maximum-capacity line + character half” is doing real localization.

Only the `d=4` members of this computed family are covered by the homology theorem.
In particular, some q=19 per-frame maxima have `d=5`; this round proves no dynamic
reduction for frames whose best pencil bottoms out there.

The remaining gap is no longer “control arbitrary play after an intruder.”  It is:

> Construct a value-blind pairing-switch certificate for at least one character-half
> center of every hard `d=4` frame, handling moves on two explicit off-conic option
> cliques.

For `d=4`, this gap is strictly narrower geometrically than the one-intruder pencil lemma:
all moves
off the two defect lines already have a proved, iterative, value-blind response.  It is not
yet a game theorem, because at `q=11` one of the four character-half centers on each knife
line is N.  “Character half” alone is therefore not a hidden definition of P.
The defect-switch certificate (DSC) remains unproved, and the localization must never be
reported as proving that a character-half center is P.

## 1. q=25 rebound incorporated

Claude's mid-census update is accepted as the current exact status:

- **[COMPUTED-EXACT]** Bucket 10, the size-720 generic bucket, is P.
- **[PROVED from the disclosed row formula and `f_10=P`]** `R7 >= 6`, and the current
  global row lower bound is `min-witness(25) >= 4`.
- **[COMPUTED-PARTIAL]** The census is 13/28 buckets, all P, with zero N labels and zero
  aborts.  Buckets 0–12 are complete and bucket 13 is running.  This strongly points toward
  non-depletion, but `nu(25)=0` must not be asserted until all 28 labels are known.
- Consequently **(ON) is established at q=25 at the current census trust tier**, with
  `min-witness(25) >= 4`; this is a fixed-q result, not a uniform proof of (ON).
  The more selective on-conic form of L at row 7 is still refined by buckets 14/16/17
  and must not yet be called settled.

The running census remains healthy at this checkpoint (about 8.0 GB RSS and 3.7 GB
available after `/tmp` cleanup).  The completed prefix includes size-720 generic buckets
3, 6, and 10.  Bucket 14 is the next decisive label for L's on-conic form; no competing
q=25 solve should be launched while the census owns the machine.

The frozen concurrency point `(1:15:9)` is external.  Exact GF(25) arithmetic gives

    Delta = Y^2-XZ = 24,       Delta^12 = 1.

Since `q=25 == 1 (mod 4)`, this point is outside the character half below, and its
conic-restricted component count is odd (`M=9`).  If the post-census solve labels it P,
that will be another conic/zone reversal, not evidence for the new half-pencil condition.

Reproduction:

```sh
python3 -c 'import sys; sys.path.insert(0,"scripts"); from c74_fan_orbits import Field; F=Field(25); X,Y,Z=(1,15,9); d=F.sub(F.mul(Y,Y),F.mul(X,Z)); print(f"delta={d} delta^12={F.pow(d,12)}")'
```

Output:

```text
delta=24 delta^12=1
```

## 2. Exact pencil algebra

Work over any odd finite field.  Normalize the conic and a candidate line by

    C(t) = (t^2:t:1),       C(infinity)=(1:0:0),
    F=C(0),                 w=C(infinity),
    L: Y=0,
    z_a=(-a:0:1),           a in F_q^*.

Let the other four selected conic parameters be `U={u1,u2,u3,u4}`.  The chord through
`C(u),C(v)` has equation

    X-(u+v)Y+uv Z=0,

so it meets `L` at `z_(uv)`.  Therefore

    B(U)={u_i u_j : i<j},       d=|B(U)|,
    z_a is legal iff a notin B(U).

The round-2 line theorem gives `d in {4,5,6}`, and a maximum-capacity line minimizes `d`;
its minimum is 4 or 5.  When `d=4`, the round-2 classification gives, after scaling,

    U={r,-r,s,-s},
    B(U)={-r^2,-s^2,rs,-rs}.

### 2.1 [PROVED] Conic-restricted nim half

The intruder `z_a` induces the conic involution

    tau_a(t)=a/t,       0 <-> infinity.

Remove the five selected conic points and their mates.  Fixed selected points and fixed
live points cancel in the count, so the number of live singleton/edge components is

    M(a) = (q+1-10+(1+chi(a)))/2
         = (q-8+chi(a))/2.

Every component has nim-value 1.  Hence

    g_conic(a)=0
      iff M(a) is even
      iff chi(-a)=-1.

Among all nonzero parameters, exactly `(q-1)/2` satisfy this condition.  A maximum line
therefore has at least

    (q-1)/2-d >= (q-11)/2

legal zero-conic-nim centers.  For `d=4`, the two forbidden values `-r^2,-s^2` are never
in the chosen half and at most both of `rs,-rs` are, giving the sharper bound

    # legal character-half centers >= (q-5)/2.

This is nonempty already at q=7 and grows linearly.  Supply is not the missing theorem.

### 2.2 [PROVED] Möbius blocker law

For an off-line point `y=(X:Y:Z)` and `u in U`, a determinant calculation gives

    z_a, y, C(u) collinear
      iff a = u(uY-X)/(uZ-Y).

If the denominator vanishes, no finite `a` works unless `y=C(u)`, which is already
unavailable.  Thus a fixed future point blocks at most four pencil parameters through the
selected frame.  For a conic point `y=C(s)`, the blocker set is exactly `sU`.

More generally, if a fixed support `Y` of `m` off-line points is to coexist with a pencil
center, its frame/new-point secants and new/new secants exclude at most

    4m + binom(m,2)

additional parameters.  Hence such a bounded support embeds whenever

    q-1-d > 4m+binom(m,2).

This also explains why a bounded algebraic gadget is easy to place but does not commute
the winning-strategy quantifiers: a full reply strategy must cover an unbounded family of
opponent moves.

## 3. [PROVED] The two-line homology-defect theorem

This is the main new theorem of the round.

Assume `d=4` and write

    S_a={C(0),C(r),C(-r),C(s),C(-s),z_a},

where `a` avoids `{-r^2,-s^2,rs,-rs}`.  Define

    sigma(X:Y:Z)=(X:-Y:Z),
    ell: Y=0,
    c=(0:1:0),
    D_0 = line(c,C(0)),
    D_a = line(c,z_a).

Then:

1. `sigma` preserves `S_a` setwise: it swaps each `C(t),C(-t)` pair and fixes
   `C(0)` and `z_a`.
2. The fixed locus of `sigma` is the axis `ell` together with the center `c`.
   Every point of `ell` is unavailable because `ell` contains the selected pair
   `C(0),z_a`.  The point `c` is unavailable because it lies on the selected chord
   `C(r)C(-r)`.
3. Let `T` be any later cap containing `S_a`, invariant under `sigma`, obtained by adding
   nonfixed `sigma`-pairs.  If `x` is legal from `T`, then `sigma(x)` is legal before
   `x` is selected.  It ceases to be legal after selecting `x` exactly when

       x in D_0 union D_a.

4. If `x` is outside those two lines, selecting `x,sigma(x)` returns to a cap of the same
   invariant form, so the response can be iterated.
5. Each `D_i` is an option clique: it already contains a selected fixed point, so at most
   one further point of that line can ever be selected during the phase.

Proof of item 3: if `sigma(x)` became illegal only after `x`, then
`x,sigma(x),t` are collinear for some `t in T`.  Their line is `sigma`-invariant and passes
through `c`.  If `t` were nonfixed, it would bring `sigma(t) in T` on the same line, so
`x` was already on a selected secant, contradicting legality.  Thus `t` is a fixed selected
point.  The only such points are `C(0),z_a`, yielding precisely `D_0,D_a`.  Conversely,
on either defect line the corresponding fixed selected point makes the mirror response
illegal.

This theorem does not resurrect the refuted fixed-mirror route.  It identifies exactly why
the mirror fails and proves closure everywhere else.  C28's zero `MirrorStepGood` census is
therefore respected rather than ignored.

The statement lives in the original projective game.  The homology need not preserve the
names of the two burned directions or the labelled row/column presentation: those directions
are selected frame points, and preserving the whole selected cap setwise preserves projective
legality.  Transport back to the residual grid is therefore legitimate.

### 3.1 [PROVED] Character half removes every conic defect

The line `D_0` is tangent to the conic at the already selected point `C(0)`.  In coordinates,
`D_a` has equation

    X+aZ=0.

It meets the conic at parameters satisfying `t^2=-a`.  Therefore

    chi(-a)=-1
      iff D_a is external to the conic.

For the same half of the pencil on which `g_conic(a)=0`, neither defect line contains a
live conic move.  Combining Sections 2 and 3 gives:

> **Two-off-conic-clique reduction.**  Every `d=4` maximum pencil contains at least
> `(q-5)/2` legal centers for which all non-mirrorable moves lie in two explicit
> off-conic option cliques.

This is a geometric/dynamic statement and uses no game-value labels.

### 3.2 Exact remaining gap

The character half does not itself imply P.  On every one of the ten tied q=11 knife
lines its six off-conic centers split as

```text
character half / external: 3 P, 1 N
opposite half / internal:   1 P, 1 N
on-conic endpoint:          N
```

Thus the missing object must distinguish the three good centers from the one bad center
without consulting value.  A sufficient next lemma is:

> **Defect-switch certificate (DSC).**  From an arbitrary `d=4` frame, an explicitly
> defined algebraic rule chooses a legal `a` with `chi(-a)=-1` and equips the two defect
> lines with a value-blind response certificate.  Every move on either defect line has an
> explicit reply that restores a certified state of smaller rank; terminal certified
> states are P.

DSC plus the proved homology response would prove that chosen child P, hence the required
escape for every frame to which it applies.  DSC is not being claimed: its certificate and
boundary response are the isolated gap.  It is narrower than the original theorem because
all off-boundary opponent moves have already been discharged, and each unresolved boundary
is a one-dimensional option clique containing only off-conic points.

The natural algebraic search space is now small and principled: use the Möbius blocker law
to seek rational cross-pairings between `D_0` and `D_a`, or a finite switching family of
homologies.  Any proposal must first separate the q=11 `3P+1N` character-half split.

## 4. [COMPUTED-EXACT] Frozen-before-query half-pencil kill test

The predicate and kill condition were frozen before this label slice was read:

> On every per-frame maximum-capacity line, count P centers satisfying `chi(-a)=-1`; kill the route
> if any count is zero.

The exact labels already existed, so this is a blinded query-order discipline rather than a
historical out-of-sample preregistration.  The q=25 test in Section 5 is prospective.

Here “maximum” is taken separately inside each five-frame: choose the candidate lines with
largest legal-child count for that frame.  It does **not** mean that every tabled line has
global collision minimum `d=4`.

In the existing feature dumps, the geometric `pos` label translates to the character half
as follows:

- `q == 1 mod 4`: internal centers;
- `q == 3 mod 4`: external centers.

Results:

| q | character half | maximum lines | minimum P in half | histogram |
|---:|:---:|---:|---:|:---|
| 7  | external | 9   | 2 | `{2:9}` |
| 11 | external | 16  | 3 | `{3:16}` |
| 13 | internal | 18  | 3 | `{3:9,4:3,5:6}` |
| 17 | internal | 21  | 2 | `{2:9,3:6,4:6}` |
| 19 | external | 181 | 4 | `{4:30,7:90,8:61}` |

At q=5 the recorded maximum lines have `d=4`, hence `q-1-d=0`: there is no legal
off-conic center to put in either character half.  q=5 remains a separately Lean-closed
base case.  q=9 was not silently treated as prime-field data and was not tested here.

Capacity-stratified control (`tuple = (legal children, lines, zero-half failures,
minimum P, maximum P)`):

```text
q=11: [(5,192,92,0,1), (6,72,48,0,2), (7,16,0,3,3)]
q=13: [(7,396,36,0,3), (8,126,12,0,5), (9,18,0,3,5)]
q=17: [(11,1092,960,0,2), (12,252,120,0,2), (13,21,0,2,4)]
q=19: [(13,1682,0,3,7), (14,312,0,4,8), (15,31,0,8,8)]
```

At q=17, all 21 maximum lines have `d=4`; 1,080/1,365 arbitrary lines fail while none of
the maxima do.  This rules out the explanation “there are simply many P centers everywhere.”
At q=19 abundance returns and every line passes, so q=17 is the informative control.
The 181 q=19 per-frame maxima split as 31 lines with `d=4` and 150 with `d=5`.
The three q=19 rows in the capacity-stratified control above refer to *all* candidate lines,
not three strata of per-frame maxima.

Reproduction of that distinction:

```sh
python3 -c 'import os,sys,collections; sys.path.insert(0,"scripts"); from c73_secant_algebra import DATA,PRIME_FILES,parse,analyze; R=analyze(19,parse(os.path.join(DATA,PRIME_FILES[19]))); C=collections.Counter(); [(C.update({19-max(d["nlegal"] for d in r["cand"].values()):sum(d["nlegal"]==max(x["nlegal"] for x in r["cand"].values()) for d in r["cand"].values())})) for r in R.values()]; print(dict(sorted(C.items())))'
```

```text
{4: 31, 5: 150}
```

Exact command for the headline table:

```sh
python3 -c 'import os,sys,collections; sys.path.insert(0,"scripts"); from c73_secant_algebra import DATA,PRIME_FILES,parse,analyze; exec("for q in (7,11,13,17,19):\n R=analyze(q,parse(os.path.join(DATA,PRIME_FILES[q])))\n want=\"int\" if q%4==1 else \"ext\"\n counts=[]; fails=[]\n for c,r in sorted(R.items()):\n  mx=max(d[\"nlegal\"] for d in r[\"cand\"].values())\n  for k,d in r[\"cand\"].items():\n   if d[\"nlegal\"]==mx:\n    n=sum(v==\"P\" and p==want for _,v,p in d[\"hit\"]); counts.append(n)\n    if n==0: fails.append((c,k))\n print(f\"q={q} half={want} max-lines={len(counts)} min={min(counts)} hist={dict(sorted(collections.Counter(counts).items()))} failures={len(fails)}\")")'
```

Output:

```text
q=7 half=ext max-lines=9 min=2 hist={2: 9} failures=0
q=11 half=ext max-lines=16 min=3 hist={3: 16} failures=0
q=13 half=int max-lines=18 min=3 hist={3: 9, 4: 3, 5: 6} failures=0
q=17 half=int max-lines=21 min=2 hist={2: 9, 3: 6, 4: 6} failures=0
q=19 half=ext max-lines=181 min=4 hist={4: 30, 7: 90, 8: 61} failures=0
```

## 5. q=25 row-7 falsification target

The full-PGL row-7 representative and its three tied `d=4` lines are label-blindly

```text
A7 = (0,1,2,6,11)
lines = (0,5), (2,7), (11,21).
```

The setwise stabilizer of `A7` has order 6 and acts transitively on these three lines.
Together with PGL transport, this makes the first line representative of all three.
Because this row has `d=4`, the homology-defect theorem applies here.  This prospective
batch says nothing about the unresolved `d=5` frame family.

On the first line `(0,5)`, the ten legal character-half centers are

```text
(1:15:5),  (1:15:6),  (1:15:8),  (1:15:13), (1:15:14),
(1:15:17), (1:15:18), (1:15:20), (1:15:21), (1:15:23).
```

They are exactly the `(q-5)/2=10` internal centers predicted by the theorem.  The already
frozen concurrency point `(1:15:9)` is in the opposite, external half.

Here GF(25) elements use the committed encoding `a+5b` for
`F_5[u]/(u^2+3)`.  Reproduction of the representative, line orbit, and stabilizer action:

```sh
python3 -c 'import sys; sys.path.insert(0,"scripts"); from c74_fan_orbits import *; F=Field(25); G=pgl_matrices(F); rows,*_=orbit_map(F,5,G); A=rows[7]; keys=line_pencil_summary(F,A)[2]; H=[g for g in G if tuple(sorted(act(F,g,x) for x in A))==A]; print("A",A,"stab",len(H),"keys",keys); print("first-key-orbit",sorted({(act(F,g,keys[0][0]),act(F,g,keys[0][1])) for g in H}))'
```

```text
A (0, 1, 2, 6, 11) stab 6 keys [(0, 5), (2, 7), (11, 21)]
first-key-orbit [(0, 5), (2, 7), (11, 21)]
```

The ten-point list was produced by enumerating the 26 points of `C(0)C(5)`, deleting
the conic endpoints and the intersections with the ten frame chords, and retaining the
nonsquare values of `Y^2-XZ`; this leaves 20 legal off-conic points split 10/10 by square
class.

```sh
python3 -c 'import sys; sys.path.insert(0,"scripts"); from c74_fan_orbits import Field,pgl_matrices,orbit_map,line_pencil_summary; from c74_concurrence import conic,cross,dot,norm; exec("F=Field(25)\nrows,*_=orbit_map(F,5,pgl_matrices(F)); A=rows[7]; e,w=line_pencil_summary(F,A)[2][0]; P=conic(F,e); Q=conic(F,w)\ndef addpt(P,Q,t): return norm(F,tuple(F.add(P[i],F.mul(t,Q[i])) for i in range(3)))\npts={addpt(P,Q,t) for t in range(F.q)}|{norm(F,Q)}\nchords=[cross(F,conic(F,A[i]),conic(F,A[j])) for i in range(5) for j in range(i+1,5)]\ndef delta(x): return F.sub(F.mul(x[1],x[1]),F.mul(x[0],x[2]))\nlegal=[x for x in pts if delta(x)!=0 and not any(dot(F,L,x)==0 for L in chords)]\ninternal=sorted(x for x in legal if F.pow(delta(x),12)!=1)\nprint(\"A\",A,\"line\",(e,w),\"legal\",len(legal)); print(\"internal\",internal)")'
```

```text
A (0, 1, 2, 6, 11) line (0, 5) legal 20
internal [(1, 15, 5), (1, 15, 6), (1, 15, 8), (1, 15, 13), (1, 15, 14), (1, 15, 17), (1, 15, 18), (1, 15, 20), (1, 15, 21), (1, 15, 23)]
```

Post-census kill test:

- score the ten listed centers as size-4 children of row 7;
- **any P** preserves the character-half existence claim on this stressed row;
- **all N** refutes that claim at q=25, while leaving L, (ON), and the main theorem intact.

This targeted batch is more diagnostic for the new route than scoring only the concurrency
point.  It should not run concurrently with the census.

## 6. Literature import and theorem-level closure obstruction

### 6.1 [LITERATURE-IMPORTED, PRIMARY-SOURCE-VERIFIED] Sieben's structure equivalence

Nándor Sieben, *Impartial Hypergraph Games*, Electronic Journal of Combinatorics 30(2)
(2023), #P2.13, [DOI 10.37236/11665](https://doi.org/10.37236/11665):

- Definition 4.1 sets `phi_H(P)` to the maximal stable sets containing `P`.
- Proposition 4.2 proves that two positions have the same `phi_H` family exactly when
  their closures (intersections of those maximal stable extensions) agree.
- Proposition 4.8 proves that structure-equivalent positions of the same parity have equal
  nim-value in a building hypergraph game.
- Proposition 3.15 proves that if all maximal stable sets have one parity, the avoidance
  game's nim-value is that parity.

The cap game is exactly the building-avoidance game on the hypergraph of collinear triples
(or the conditioned hypergraph after fixing the frame).  Its maximal stable sets are
complete arcs.  Therefore the paper supplies a valid value-preserving quotient if many
positions have the same family of complete-arc extensions.

### 6.2 [PROVED] Anti-Frattini theorem for arcs

Let `S` be a nonempty `n`-arc in `PG(2,q)`, and define

    Core(S) = intersection {C : C is a complete arc and S subset C}.

If

    q > binom(n-1,2)+1,

then

    Core(S)=S.

Proof.  Take `y notin S`.  If `y` is already illegal over `S`, no complete arc containing
`S` can contain it.  Otherwise choose `p in S` and inspect the line `py`.  A point
`z in py-{p,y}` can be illegal over `S` only by lying on a secant among `S-{p}`; there
are at most `binom(n-1,2)` such secants.  The inequality leaves a legal `z`.  Extend
`S+z` greedily to a complete arc.  It omits `y` because `p,y,z` are collinear.  Thus no
point outside `S` lies in every complete extension.

Consequences:

- for a residual size-3 parent plus the two burned directions (`n=5`), closure is trivial
  for every odd `q>=9`;
- for every residual size-4 child (`n=6`), closure is trivial for every odd `q>=13`.

Hence Sieben's exact structure quotient merges no distinct size-4 children at the active
frontier for q>=13.  Completion-family closure is not merely empirically weak here: its
standard value-preserving quotient is provably the identity on these children.  Computing
the recursive type of every singleton class would reproduce the original game recursion.

This is the best literature import of the round, but it is a rigorous negative rather than
a missing positive theorem.

## 7. Further cross-field obstructions

### 7.1 [PROVED] Maximum-option-clique universality

No abstract Node-Kayles theorem about a maximum clique can prove L.  Given any
`T subset {1,...,n}`, construct a graph with maximum clique `C={c_i}`.  For each
`i notin T`, add an independent vertex `x_i` adjacent to every `c_j` except `c_i`.
After playing `c_i`, the residual graph is empty when `i in T` and the singleton `x_i`
otherwise.  Thus the P/N pattern of the children indexed by a maximum clique is exactly
the arbitrary prescribed set `T`.

The projective proof must therefore use the rank-two incidence linking the pencil to later
moves, not “maximum clique,” deletion size, or parity alone.

### 7.2 [REFUTED] Matroid/greedoid shortcut

If the cap complex were a matroid, all terminal sets would be bases of one size and Sieben
Proposition 3.15 would settle the nim parity.  It is not.  Take two lines through `p`, with
`a,b` on the first and `c,d` on the second.  The collinear triples `{p,a,b}` and
`{p,c,d}` are circuits, but `{a,b,c,d}` contains no circuit, violating circuit elimination.
A hereditary greedoid is a matroid, so that route does not weaken the obstruction.

### 7.3 [REFUTED] Homotopy type alone

Node-Kayles on `K1` has nim 1 and on the path `P4` has nim 0, while both independence
complexes are contractible.  Homology, homotopy type, or a discrete-Morse collapse without
additional option data cannot determine P/N.

## 8. Approach registry

| Family | Exact target | Strongest result | Blocker | Weaker than theorem? | Next kill test |
|---|---|---|---|---|---|
| Equivariant `d=4` pencil | Classify and close mirror defects | Two-line homology-defect theorem; defects conically empty on character half | Need a value-blind switch certificate distinguishing q=11's `3P+1N` half | Yes: only two off-conic option cliques remain | q=11 center-by-center certificate audit; then ten q=25 row-7 centers |
| Finite-field/polynomial method | Prove existence inside an algebraic Good set | Exact Möbius blocker law; dense character half; bounded-support exclusion | No proved `Good => P` closure | Yes once Good is explicit; not yet instantiated | Require low-degree certificate and list every denominator/square-class exception |
| Hypergraph structure theory | Quotient by complete-arc extensions | Sieben import plus anti-Frattini theorem | Quotient is identity for size-4 children q>=13 | Closed negative | None; do not fund completion-closure compression |
| Abstract graph/module methods | Deduce a P member from maximum clique | Arbitrary P/N trace construction | Projective incidence is indispensable | Closed negative | None |
| Matroid/topological methods | Terminal parity or homotopy invariant | Exact circuit and contractible-complex obstructions | Cap complex is nonmatroidal; topology loses option data | Closed negative | Only revisit with a new incidence-sensitive invariant |
| q=25 A5 | Determine whether rebound persists | `f_10=P`, `min-witness>=4`, 13/28 all P | Census incomplete; off-conic row-7 labels absent | Data route only | Finish census, then score ten declared internal centers |

## 9. Recommended next round

### Route A — fund at high effort: defect-switch algebra

**Assignment:** one high-reasoning proof agent plus one medium exact-data adversary.  The proof
agent should derive coordinates for all legal points on `D_0,D_a`, all cross-line secant
collisions, and candidate rational switch maps.  It must define the certificate before seeing
labels.  The data agent should test only that frozen certificate on the ten q=11 knife lines,
then q=13/q=17 controls.

**Success gate:** a proved closure theorem for a value-blind certificate and a finite-field
coverage proof selecting at least one of the `3P` q=11 character-half centers while rejecting
or failing on the known N center.

**Failure gate:** every natural rational switch is killed by a named q=11 center/move, or the
certificate exists equally on the N center.  Record the exact counterexample and stop broad
feature search.

**Estimated cost:** 20–30 high-effort minutes for symbolic derivation; 10–15 medium minutes
for existing-artifact replay; under 2 GB and no new solve.

### Route B — fund at medium/high effort after the census: q=25 character-half stress

**Assignment:** one medium data agent to translate the ten declared row-7 projective points into
the exact residual/raw representation, followed by one high agent only if at least one is P.

**Success gate:** any listed point is certified P, followed by extraction of its forced-reply
geometry on the two defect lines.  Compare that certificate with q=11/q=17 before generalizing.

**Failure gate:** all ten are N.  Then mark the character-half existence conjecture refuted at
q=25 and retain only the proved two-line reduction; redirect to the on-conic endpoint or the
external concurrency point.

**Estimated cost:** translation is minutes; solving cost must be sized after the census and must
not overlap it.  Do not launch a broad q=25 off-conic census.

## 10. Circularity and scope audit

- No P label enters the homology, defect-line, character, blocker, or anti-Frattini proofs.
- The q<=19 predicate and kill condition were frozen before that label slice was queried;
  this is not described as historical out-of-sample preregistration.
- `g_conic=0` is not treated as the full value.  q=11 supplies both P and N full positions in
  that half.
- The report does not assume uniform (ON), L, `L_forall`, or non-depletion at q=25.
  Section 1 concludes fixed-q (ON) from the monotone resolved-P lower bound, but that
  conclusion is used as an input nowhere in the new proofs.
- A legal center is not called winning merely because it exists; DSC is explicitly unproved.
- The partial mirror is not advertised as a fixed winning mirror.  Its exact two-line failure
  locus is retained as the missing obligation.
- No exact Z, Grundy value, remoteness, table membership, or strategy depth is a selector
  coordinate.
- All algebra uses `F_q`, quadratic characters, and projective coordinates valid for odd prime
  powers.  The GF(25) checks use the committed finite-field implementation, not integer-mod-25
  arithmetic.
- Missing q=25 buckets and off-conic states remain unknown.  The 13/28 census prefix is not
  promoted to `nu(25)=0`.
- The abstract graph and closure no-go theorems do not say a projective proof is impossible;
  they say exactly which forgotten structure those routes would have to restore.

## 11. Independent verification addendum

**[VERIFIED-INDEPENDENTLY]** Claude Fable subsequently replayed the declared GF(25),
half-pencil, stabilizer, and ten-point calculations and reported bit-for-bit agreement.
The chord/product algebra, parity law, supply bound, full two-line theorem (including its
converse and iterative form), anti-Frattini proof, and the three Section 7 obstructions were
also hand-checked independently.

The verification raised four presentation issues, all incorporated above:

1. every command now names `rust/` as its required working directory;
2. “maximum” is explicitly per-frame, with the q=19 `d=4/d=5` split recorded;
3. the unproved DSC caveat remains adjacent to the localization claim;
4. fixed-q `(ON)` is distinguished from a uniform assumption and
   `min-witness(25) >= 4` replaces the ambiguous word “margin.”

The two low-stakes items left to the verifier were checked independently during this round:
Sieben's Definition 4.1 and Propositions 4.2, 4.8, and 3.15 match the published EJC paper,
and the q=5 remark follows exactly from `q-1-d=5-1-4=0` legal off-conic centers.
