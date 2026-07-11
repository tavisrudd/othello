# Odd projective cap game — Codex round 4: voltage, polarity, and Rédei isomorphisms

**Date:** 2026-07-10
**Scope:** existing exact artifacts plus new isomorphisms from signed graph covers,
coherent configurations, orthogonal polarity, affine direction theory, additive
combinatorics, and MDS-code extension
**New large solves:** none
**Replay working directory:** `/home/tavis/src/othello/rust`
**q=25 census at last supplied checkpoint:** 13/28 buckets, all P; bucket 13 running

## Executive result

No uniform proof was obtained.  Round 4 does provide a sharper answer to “what information
is the round-3 two-defect reduction still missing?”

For a `d=4` character-half child, the interaction between the two defect lines is exactly:

1. **[PROVED]** a four-generator bipartite Möbius/affine Schreier graph;
2. **[PROVED]** equivalently, a polarity-defined pair of non-tangent-line pencils with one
   complete cross-ratio orbital coordinate;
3. **[PROVED]** under later symmetric play, a signed two-cover whose deletions remain
   equivariant, so a voltage-enriched quotient is well defined;
4. **[REFUTED]** not determined by the ordinary orbit quotient, the static boundary SG,
   component count, or raw blocker-collision multiplicity.

The exact missing datum is the evolving `Z_2` cycle voltage together with overlap against
the already-deleted secant trace.  A six-vertex signed-lift example proves that forgetting
voltage can change SG from 0 to 1 even when the quotient and marked defect are identical.
Existing q=17 data proves that the static two-line game can be P while the full child is N.

Round 4 also covers the previously untouched `d=5` geometry:

- **[PROVED]** the six-conic endpoint has a homology with no selected fixed point;
- after sending its axis to infinity, the selected set is three antipodal affine pairs;
- the live fixed-axis reservoir is exactly the set of undetermined affine directions;
- its size has the exact collision identity

      R = q+1-k^2+E,

  where `2k` is the number of affine selected points and `E` is the repeated-direction
  surplus of the `k^2` secant orbits;
- on conic points this direction law is a restricted product set in a split or nonsplit
  one-dimensional torus, giving the precise Freiman/Rédei formulation of “collision
  energy.”

This Rédei/direction chain is separate root/`d=5` supply accounting.  It is **not** an
ingredient of the `d=4` defect-phase DSC: that homology axis already contains two selected
points and has empty reservoir.  The `d=4` spine is the voltage two-cover; polarity is useful
only as explicit algebra for replies inside that voltage-aware state.

These are proof-level reductions, not P-value conclusions.  The value-blind
voltage-aware defect-switch certificate remains unproved and must distinguish q=11's
known `3P+1N` character-half split.

## 1. Productive “mathematician lenses”

This round used named styles as question generators, not appeals to authority:

| Lens | Question asked | Exact answer |
|---|---|---|
| Conway/Berlekamp | Can paired options simply be canceled? | No.  A defect makes signed cycle voltage SG-relevant. |
| Klein/Noether | What is the complete invariant after quotienting by the conic group? | Line types plus Hollmann–Xiang modified cross-ratio. |
| Tutte/Gross | What survives passage to a two-cover? | The `Z_2` voltage on quotient cycles, not only the quotient graph. |
| Rédei/Szőnyi | What is the reservoir geometrically? | Undetermined affine directions; its depletion is polynomial root support. |
| Freiman/Kneser | What creates direction collisions on a conic? | Small restricted product sets in a cyclic algebraic torus. |
| MDS-code lens | What is a live fixed-axis point? | A one-column extension of a `[2k,3,2k-2]_q` MDS code. |

The common lesson is to retain the smallest functorial datum that survives symmetry.  Here
that datum is voltage plus the secant-trace deletion set.  A coarser quotient is provably
insufficient; a larger static feature dictionary is unnecessary.

## 2. [PROVED] Affine Schreier isomorphism for the two defect lines

Use the round-3 normalization

    C(u)=(u^2:u:1),
    z_a=(-a:0:1),
    D_0: X=0,
    D_a: X+aZ=0,
    U={r,-r,s,-s}.

Parametrize the two projective lines by

    x_p=(0:1:p) in D_0,
    y_q=(-aq:1:q) in D_a.

Here `p=q=0` is the homology center `c=(0:1:0)` and infinity gives the selected
endpoints `C(0)` and `z_a`.  A determinant gives, for every `u in U`,

    x_p, y_q, C(u) collinear
      iff q=f_u(p):=p u^2/(a+u^2-aup).

The matrix of this Möbius map is

    M_u = [[u^2, 0],[-au,a+u^2]].

It is invertible because a legal `d=4` center has `a != -u^2`.  Thus the ambient
cross-defect incompatibility graph is the bipartite graph of the four projectivities
`f_r,f_-r,f_s,f_-s`.  The actual game graph is its induced subgraph after deleting all
preblocked vertices.

### 2.1 Dead-point domain

The formula must not be treated as a permutation of the legal set without deletions:

- `p=0` is the already-illegal center `c`;
- `p=infinity` is selected `C(0)`;
- the pole `p=(a+u^2)/(au)` lies on `C(u)z_a` and maps to selected `z_a`;
- the intersections of `D_0` with selected conic chords are

      p=(u+v)/(uv);

- analogous endpoint and secant traces are deleted on `D_a`.

These are precisely the canonical dead points requested by the domain audit.  All group
statements below concern the ambient graph; the legal graph is the deletion-induced subgraph.

### 2.2 Reciprocal coordinates and monodromy

Put `b=1/p` and `d=1/q`.  The four graphs become affine:

    d = alpha_u b - a/u,
    alpha_u=(a+u^2)/u^2.

Therefore `alpha_u=alpha_-u`: there are only two multipliers, and each `+/-u` pair consists
of parallel affine graphs.  Two-step monodromy is

    f_v^{-1} f_u ~
      [[u^2(a+v^2),0],
       [auv(u-v),v^2(a+u^2)]].

In reciprocal coordinate `h=1/p`, this is

    h |-> [v^2(a+u^2)/(u^2(a+v^2))] h
           + av(u-v)/[u(a+v^2)].

In particular,

    f_-u^{-1} f_u:
      h |-> h - 2au/(a+u^2).

The ambient even-step group is consequently an affine group generated by translations
`t_r,t_s` and the multiplier

    m=s^2(a+r^2)/[r^2(a+s^2)].

This statement means “conjugate into `AGL(1,q)`,” not necessarily equal to the whole affine
group.  Over a prime field one nonzero translation already generates the additive group, so
ambient components are large.  Over `GF(p^e)`, the translation subspace is

    V=span_Fp {m^j t_r, m^j t_s : j in Z}.

A proper `V` is the precise subfield/Baer resonance condition.  Deletions can still split an
ambient orbit, so this is not a game-value invariant.

## 3. [PROVED] Equivariant deletion and the voltage quotient

Let `T` be a `sigma`-invariant cap in the round-3 `d=4` phase.  Adding a legal mirrored pair
`{w,sigma(w)}` has the following exact effect on either defect line:

1. its own chord `w sigma(w)` passes through `c`, already illegal, so that chord deletes no
   live boundary vertex;
2. mixed secants with an old nonfixed selected pair occur in `sigma`-paired lines and delete
   a `sigma`-pair of boundary vertices;
3. mixed secants with either fixed selected point likewise occur in `sigma`-pairs on the
   opposite defect line.

Thus the boundary deletion state remains a signed two-cover after every successful mirror
round.  Quotient vertices are `sigma`-orbits; lifted edges remember whether a matching is
parallel or crossed.  Cycle signs are invariant under changing orbit representatives.  This
proves that a voltage-aware dynamic DSC is a well-posed target rather than another feature
heuristic.

### 3.1 [PROVED / REFUTED] Ordinary quotient loses SG

Take the base triangle with vertices `d,x,y`, lift every vertex to `v_+,v_-`, and add the
defect/fiber edge `d_+d_-`.

- **Balanced signing:** all three base-edge matchings are parallel.
- **Unbalanced signing:** `dx,dy` are parallel and `xy` is crossed.

These graphs have the same ordinary orbit quotient, degrees, and marked defect orbit.
Nevertheless Node–Kayles gives

    SG(balanced)=0,
    SG(unbalanced)=1.

For the balanced graph every move leaves `K2` or `K3`, both SG 1, hence the root is 0.
For the unbalanced graph a `d` move leaves two isolates (SG 0), while an `x` or `y` move
leaves `P3` (SG 2), hence the root is `mex{0,2}=1`.

This is a `K3` two-lift plus a defect edge, equivalently a lift with a crossed loop/half-loop;
it is not an ordinary loopless two-lift.  Without the defect edge, the deck involution gives
the usual mirror strategy.  The example proves necessity of voltage after a defect breaks
that symmetry; it is not claimed to be an induced projective-cap subgame.

Reproduction:

```sh
python3 -c 'from functools import lru_cache; exec("def sg(adj):\n n=len(adj)\n @lru_cache(None)\n def g(mask):\n  vals=[]\n  for v in range(n):\n   if mask>>v&1: vals.append(g(mask & ~(adj[v]|(1<<v))))\n  z=0\n  while z in vals: z+=1\n  return z\n return g((1<<n)-1)\ndef lift(cross):\n A=[0]*6\n def edge(i,j): A[i]|=1<<j; A[j]|=1<<i\n edge(0,1)\n for u,v,c in [(0,1,0),(0,2,0),(1,2,cross)]:\n  for s in (0,1): edge(2*u+s,2*v+(s^c))\n return A\nprint(\"balanced\",sg(lift(0)),\"unbalanced\",sg(lift(1)))")'
```

```text
balanced 0 unbalanced 1
```

## 4. [PROVED] Polarity turns the defects into two non-tangent-line pencils

For the conic `Q=XZ-Y^2`, use the orthogonal polarity

    pi(P): P_Z X - 2 P_Y Y + P_X Z=0.

Then

    D_0=pi(C(0)),
    D_a=pi(z_-a).

The second equality uses the *opposite* center `z_-a=(a:0:1)`, not selected `z_a`.
In reciprocal coordinates write the live finite boundary points as

    x_b=(0:b:1),
    y_d=(-a:d:1),
    b,d != 0.

Their polar lines are

    pi(x_b): X-2bY=0,
    pi(y_d): X-2dY-aZ=0.

The first is the secant through `C(0),C(2b)`.  The second meets the conic with discriminant
`4(d^2+a)`.  Under `chi(-a)=-1`, it is never tangent, so the two defect cliques dualize to
two pencils entirely inside the Hollmann–Xiang coherent configuration of non-tangent lines.

### 4.1 [LITERATURE-IMPORTED] Complete two-line orbital coordinate

Hollmann and Xiang, *Association schemes from the action of PGL(2,q) fixing a nonsingular
conic in PG(2,q)*, J. Algebraic Combin. 24 (2006), 157–193,
[DOI](https://doi.org/10.1007/s10801-006-0005-8),
[primary preprint](https://arxiv.org/abs/math/0503573):

- Theorem 4.3: ordered pairs of distinct non-tangent lines are in the same conic-stabilizer
  orbit exactly when the corresponding line types agree and their unordered cross-ratios
  agree.
- Theorem 5.3: the modified cross-ratio is computable from homogeneous line coordinates.

In the coordinates above their invariant becomes

    rhohat(pi(x_b),pi(y_d))
      =(a+2bd)^2/[16 b^2(d^2+a)].

Thus every invariant depending only on the conic and an ordered cross-defect line pair
factors through

    (chi(d^2+a), rhohat).

This is a complete orbital coordinate, not a proposed P classifier.  Hollmann–Xiang's full
intersection-parameter development after Section 5 is for even characteristic, and its
valencies range over all non-tangent lines rather than the restricted reply pencil.  Those
are exact applicability gaps.

The signed-lift `SG=0/1` obstruction applies before any further polarity search: `rhohat` is a
static pair-orbital coordinate and does not carry cycle voltage.  Therefore `rhohat` alone is
already disqualified as a value or closure coordinate.  It survives only as a formula from
which a **voltage-aware** reply map might be built.  Such a map must then pass the q=11
character-half `3P/1N` gate before receiving any deeper audit.

Numeric odd-field orbit check, with `q=11,a=3,r=1,s=2`: `b=1,d=2` is a legal compatible
boundary pair and `rhohat=8`.  Scaling the conic parameter by 2 sends `(a,b,d)` to `(1,2,4)`
and preserves `rhohat=8`.

```sh
python3 -c 'q=11; a=3; inv=lambda x:pow(x,q-2,q); rho=lambda a,b,d:(a+2*b*d)**2*inv((16*b*b*(d*d+a))%q)%q; print(rho(a,1,2),rho(4*a%q,2,4))'
```

```text
8 8
```

## 5. [PROVED] Exact projection-overlap reservoir identity

Let `T` be a cap with exactly one selected point on each of distinct lines `D,D'`.  For a
legal `x in D\D'`, define

    pi_x(t)=xt intersect D',       t in T\D'.

This map is injective: a collision would place `x` on the selected secant through two
distinct preimages.  Its image avoids the selected point of `D'` for the same reason.

Let `B_T(D')` be the unselected points of `D'` already illegal from `T`.  Then

    |Leg(T+x,D')|
      = |Leg(T,D')|-(|T|-1)
        + |pi_x(T\D') intersect B_T(D')|.

In the defect application `c=D_0 intersect D_a` is already illegal and the selected point
on `D_0` projects to `c`.  With

    T°=T\{C(0),z_a},

the forced term cancels and

    |Leg(T+x,D_a)|
      = |Leg(T,D_a)|-|T°|
        + |pi_x(T°) intersect B_T(D_a)|.

This is the exact local collision energy: favorable slack is overlap of the injective
projection image with the *old* secant trace.  There are no collisions among the new blockers
once `x` is conditioned legal.

For the initial `S_a`, the four affine blocker graphs from `C(+/-r),C(+/-s)` meet only above

    b in {+/-rs/(r+s), +/-rs/(r-s)}.

These are precisely the intersections of `D_0` with old cross-chords, so all four are already
illegal opponent moves.  Raw blocker multiplicity cannot distinguish q=11's `3P+1N` centers;
one must retain overlap with old deletions or later voltage closure.

## 6. [PROVED / REFUTED] The static boundary game is not the missing game

Define the **static boundary game** at `S_a` by restricting every move to the points initially
legal on `D_0 union D_a`, while applying the ordinary cap legality rule inside that induced
move set.  No move outside the two lines is allowed.

Each line initially has at least

    (q+1)-1-binomial(5,2)=q-10

legal points: one point is selected, and only secants among the other five selected points can
block further points on that line.  A move on one line creates at most four new blockers on the
opposite line, one through each off-defect selected conic point.  For `q>=17`, at least one
opposite-line reply remains.  The remaining vertices form a nonempty option clique, so every
first option has SG 1 and

    SG(static boundary game)=0.

This is not a disjunctive component of the full game.  Exact q=17 data refutes the implication
“static boundary SG 0 => full child P.”  In class 0, maximum line `(15,11)`, the six
character-half centers are

```text
((5,6),N), ((6,7),N), ((8,9),N),
((9,10),P), ((11,12),N), ((12,13),P).
```

All six have the same static-boundary verdict 0; four full children are N.

Reproduction:

```sh
python3 -c 'import os,sys; sys.path.insert(0,"scripts"); from c73_secant_algebra import DATA,PRIME_FILES,parse,analyze; R=analyze(17,parse(os.path.join(DATA,PRIME_FILES[17]))); r=R[0]; mx=max(d["nlegal"] for d in r["cand"].values()); print(next((0,k,d["nlegal"],h) for k,d in r["cand"].items() if d["nlegal"]==mx for h in [[x for x in d["hit"] if x[2]=="int"]] if sum(v=="P" for _,v,_ in h)==2))'
```

The boundary interaction is useful only as a dynamically coupled voltage state.

## 7. [PROVED] Affine-direction and collision-energy isomorphism

Send a homology axis `H` to the line at infinity and its center to the affine origin.  In odd
characteristic the involution becomes

    v |-> -v.

This direction-reservoir lane has content only while `H` contains at most one selected point.
In the round-3 `d=4` phase, `H` contains selected `C(0),z_a`, so its reservoir is identically
empty.  The round-3 live objects there are the two defect lines, not `H`.  The direction model
applies to the `d=5` endpoint phase and later states built only from antipodal pairs.

Let

    U={+/-u_1,...,+/-u_k}

be a centrally symmetric affine cap, and let `Dir(U)` be its set of determined directions.
A fixed point on `H` is legal exactly when its direction is not in `Dir(U)`.  Therefore

    R_H(U)=q+1-|Dir(U)|.

The involution acts on unordered secants.  Exactly the `k` antipodal secants are fixed; all
others occur in pairs, so the number of secant orbits is

    [binomial(2k,2)+k]/2=k^2.

Let `mu(h)` count secant orbits of direction `h`, and define the collision surplus

    E(U)=sum_h max(0,mu(h)-1)
        =k^2-|Dir(U)|.

Then

    R_H(U)=q+1-k^2+E(U).

After adding a legal antipodal pair,

    Delta R_H=-(2k+1)+Delta E.

This is the untruncated collision-energy formula requested by the earlier reservoir lane.
It is not yet identified with C63's empirical `reservoir_slack_total`; that equality or
comparison is a new falsification test, not an assumption.

### 7.1 Rédei polynomial and MDS translation

In affine coordinates, take one linear factor for each inversion-orbit of secants.  Their
homogeneous product has degree `k^2`; its distinct roots on `H` are exactly `Dir(U)`, and `E`
is its total repeated-root surplus.  Equivalently, a direction is live iff projection of `U`
along it is injective.  This is the less-than-q Rédei direction problem.

The same statement in coding language is exact: the `2k` projective columns of `U` generate a
`[2k,3,2k-2]_q` MDS code, and a live point of `H` is precisely a projective column whose
adjoining preserves the MDS property.  Code-extension theorems therefore address the support
geometry, but not the normal-play value.

### 7.2 [LITERATURE-IMPORTED, WRONG INEQUALITY DIRECTION FOR CLOSURE]

Fancsali, Sziklai, and Takáts, *The number of directions determined by less than q points*,
J. Algebraic Combin. 37 (2013), 27–37,
[DOI](https://doi.org/10.1007/s10801-012-0357-1),
[author preprint](https://arxiv.org/abs/1407.5638), develops the Rédei polynomial for
arbitrary prime powers.  Their Theorem 17, under `|U|<q`, at least one undetermined direction,
and their algebraic parameters `s<=t<q`, gives the lower bound

    (|U|-1)/(t+1)+2 <= |Dir(U)|,

with an additional upper bound only in the `s>1` case.

Our strategy lane needs a lower bound on the *undetermined* reservoir, equivalently an upper
bound on `|Dir(U)|`.  The general Rédei results mostly point the other way and are therefore
falsifiers for mirror survival, not a closure theorem.  A generic symmetric cap can realize
essentially the full `k^2` support until saturation.  No literature bound is imported in the
wrong direction.

## 8. [PROVED] The d=5 endpoint and its torus product law

For a `d=5` per-frame maximum, label the unique repeated product

    kappa=u_1u_2=u_3u_4.

The involution

    tau_kappa(t)=kappa/t

swaps `F=0` with the on-conic endpoint `w=infinity` and pairs the other four frame points.
After selecting `w`, the six-conic child is invariant under

    sigma_kappa(X:Y:Z)=(kappa^2 Z:kappa Y:X).

Its fixed axis and center are

    H_kappa: X=kappa Z,
    c_kappa=(-kappa:0:1).

No selected point is fixed.  The center lies on the three selected pair-chords and is illegal.
At any invariant follower containing no selected axis point, every nonfixed legal move can be
answered by its mirror; the only defects are live points of `H_kappa`.

Sending `H_kappa` to infinity gives three antipodal affine pairs, so initially `k=3` and

    R_H >= q+1-9=q-8.

This is a genuine dynamic reduction for the `d=5` family left uncovered in round 3.  It does
not prove the endpoint P: mirrored pairs can deplete the axis reservoir, and a late unique fixed
move has no mirror.

### 8.1 Cayley transform: directions are restricted products in a torus

For finite conic parameters `t,u`, the chord `C(t)C(u)` meets `H_kappa` at coordinate

    t star u=(kappa+tu)/(t+u),

with the usual projective interpretations when a denominator vanishes.  Adjoin
`s` with `s^2=kappa` and define

    phi(t)=(t-s)/(t+s).

A direct factorization gives

    phi(t star u)=phi(t)phi(u),
    phi(kappa/t)=-phi(t).

If `kappa` is a square, `phi` identifies the nonfixed parameters with the split torus
`F_q^*`, of order `q-1`.  If it is nonsquare, Frobenius sends `s` to `-s`, and `phi` identifies
`P^1(F_q)` with the norm-one torus

    {z in F_(q^2)^*: z^(q+1)=1},

of order `q+1`.  Both groups are cyclic.

Thus a selected conic set of `k` involution pairs becomes `{+/-z_1,...,+/-z_k}`, and its
fixed-axis secant trace is the restricted product set

    {-z_i^2} union {+/-z_i z_j : i<j}.

The generic support size is `k^2`; collision surplus is exactly restricted multiplicative
energy.  In exponent coordinates this is a Freiman small-sumset problem in a cyclic group.
The familiar parabola identity “chord direction = parameter sum” is the split tangent-chart
version; the Cayley-torus formula is the one adapted to the actual `d=5` homology axis.

This makes square-order resonance precise: a small support can come from a proper
`F_p`-linear/subfield configuration, but such structure must be proved or tested rather than
inferred from `q` being a square.

### 8.2 [PROVED] A cap has at most one affine inversion center

If a nonempty affine cap in odd characteristic were invariant under inversions about distinct
centers `c,d`, their composition would be translation by `2(d-c)`.  Every orbit of this
nontrivial translation has prime-characteristic length at least three and is collinear.
Invariance would put such an orbit in the cap, contradiction.

Therefore a boundary switch cannot simply replace one affine central inversion by another
while preserving the selected cap.  A successful switch must use a more general projective
certificate or the voltage/deletion structure above.

## 9. [COMPUTED-EXACT, LABEL-BLIND] q=25 Baer/monodromy kill test

Here “maximum-capacity line” is always a maximum **for its frame**, not a claim that every
maximum line has global defect parameter `d=4`.  At q=19 the 181 such lines occupy three
capacity strata; only the `d=4` stratum is covered by the two-defect theorem.  The row-7 lines
tested below are `d=4`.  Frames whose maximum pencils bottom out at `d=5` belong to Sections
7–8 and are not covered by the DSC chain.

For row 7, line `(0,5)`, normalization gives

    U={24,6,7,23}={+/-24,+/-7} in GF(25).

For each of the ten prospective character-half centers from round 3, compute `t_r,t_s,m` and
the `F_5`-dimension of the translation space `V`.  The result is

```text
(original Z, normalized a, dim_F5 V)
(5,22,2), (6,23,2), (8,5,2), (13,15,2), (14,14,2),
(17,16,2), (18,10,2), (20,7,2), (21,8,2), (23,20,2).
```

Every ambient monodromy is full-dimensional over `F_5`; none has a proper Baer translation
orbit.  Therefore a future P label among these centers cannot be explained by small ambient
Schreier components or an `F_5`-line translation subgroup.  This is label-blind and does not
predict their values.

Reproduction:

```sh
python3 -c 'import sys; sys.path.insert(0,"scripts"); from c74_fan_orbits import Field; F=Field(25); r,s=24,7; d=F.neg(5); zs=(5,6,8,13,14,17,18,20,21,23); sub=set(range(5)); div=lambda x,y:F.mul(x,F.inv(y)); exec("def center_a(z):\n X,Y,Z=1,15,z\n Xp=X; Yp=F.add(X,F.mul(d,Y)); Zp=F.add(X,F.add(F.mul(F.add(d,d),Y),F.mul(F.mul(d,d),Z)))\n assert Yp==0\n return F.neg(F.mul(Xp,F.inv(Zp)))\ndef tr(a,u): return F.neg(F.mul(F.mul(2,F.mul(a,u)),F.inv(F.add(a,F.mul(u,u)))))\ndef mult(a): return F.mul(F.mul(F.mul(s,s),F.add(a,F.mul(r,r))),F.inv(F.mul(F.mul(r,r),F.add(a,F.mul(s,s)))))\nout=[]\nfor z in zs:\n a=center_a(z); t1,t2,m=tr(a,r),tr(a,s),mult(a); dim=1 if div(t2,t1) in sub and m in sub else 2; out.append((z,a,dim))\nprint(out)")'
```

No q=25 state was solved or labeled by this command.

## 10. Exact remaining gap

The strongest sufficient target is now a **voltage-aware polar DSC**:

1. from a `d=4` frame, choose `a` value-blindly with `chi(-a)=-1`;
2. retain the signed quotient of the live boundary graph, including cycle voltage and the old
   secant-trace deletion set;
3. for every legal boundary move `x_b`, choose a compatible `y_d` using an explicit affine or
   polarity-orbital rule;
4. prove that the updated signed/deletion state lies in a geometrically defined Good class of
   smaller rank;
5. prove the terminal Good class P.

The coverage step can use the exact formulas

    d != alpha_u b-a/u,
    rhohat=(a+2bd)^2/[16b^2(d^2+a)],

and the projection-overlap identity.  The closure step must retain voltage; legality or a
prescribed cross-ratio alone is insufficient.

The logical order is fixed:

1. retain the voltage two-cover, because the signed-lift theorem proves that datum necessary;
2. use polarity only to write an explicit reply on that cover;
3. freeze the resulting certificate and immediately replay the q=11 `3P/1N` entry test;
4. audit closure or general-q algebra only if that cheap test survives.

**[BLOCKED AT ENTRY]** No voltage-aware polar certificate has yet been defined, so
there is no q=11 predicate to replay.  The polarity lane therefore stops at its exact formula;
it does not earn a deeper literature or feature search merely because `rhohat` is canonical.

Mandatory failure gates:

- distinguish the three P and one N character-half centers on every q=11 knife line;
- reject any certificate that exists equally on the known N center;
- preserve the q=17 mixed full values despite identical static-boundary SG 0;
- do not use exact value, Z, remoteness, or future replies in the certificate.

This gap is narrower than the original theorem: the ambient interaction, legal domain,
minimal quotient state, and exact failure of coarser quotients are all known.  It is not yet a
proved winning reply theorem.

## 11. Approach registry

| Family | Lane/scope | Exact target | Strongest result | Blocker | Predeclared kill test |
|---|---|---|---|---|---|
| Signed/voltage quotient | `d=4` DSC spine | Cancel symmetric play without losing SG data | Voltage quotient well posed; ordinary quotient refuted by SG `0/1` pair | Need a Good class closed under boundary switches | Freeze certificate; require it on at least one of the 3 P centers and on none of the 1 N centers on every q=11 knife line |
| Affine Schreier graph | `d=4` DSC algebra | Algebraize cross-defect incompatibility | Four Möbius maps become two-multiplier affine graphs; explicit monodromy | Legal deletions are not group invariant | Freeze a deletion-aware rule; apply the q=11 `3P/1N` gate before generalizing |
| Polarity/coherent configuration | `d=4`, subordinate reply algebra | Canonical coordinate for switch pairs inside the voltage state | Complete line-type plus `rhohat` orbital coordinate | `rhohat` alone forgets voltage; odd-q restricted-pencil counts do not give closure | Static `rhohat` use is killed by the signed-lift pair; any voltage-enriched rule then faces the same frozen q=11 `3P/1N` gate |
| Projection overlap | `d=4` legality ledger | Exact reply-reservoir delta | New blockers inject; only overlap with old trace gives slack | Proves legality only | Any proposed overlap threshold must reject the q=11 N center before a forced-reply replay |
| Static boundary SG | `d=4` falsifier | Solve two cliques | SG 0 for all q>=17 | Full q17 children include N | Closed negative as value criterion by the recorded q17 mixed line |
| Rédei directions | root/`d=5` supply accounting only | Interpret the live fixed-axis reservoir | `R=q+1-k^2+E`; exact polynomial support | Literature bounds mostly wrong direction; irrelevant when `d=4` axis has two selected points | Predeclare equality or one-sided comparison with C63 root-lane reservoir on a frozen sample; first counterexample closes the identification |
| Torus/Freiman | root/`d=5` conic supply | Classify on-conic direction collisions | Chord trace is restricted product in split/nonsplit cyclic torus | Later off-conic points leave pure product-set model | Freeze a theorem-derived small-doubling statement; kill it on the first root-lane state leaving the conic model |
| Baer monodromy | `d=4` q25 ambient-group control | Explain square-order component splitting | All ten q25 row-7 targets have full `F_5` span | No small ambient component there | Closed for this stressed row by the label-blind dimension-2 computation |

## 12. Recommended next round

### Route A — high effort: voltage-aware DSC

**Proof assignment:** derive the signed quotient state and its update under an arbitrary legal
boundary pair.  Start from the affine generators and equivariant-deletion lemma, not from P
labels.  Seek a finite balancedness/trace condition strong enough to give an explicit response
and weak enough to cover at least one center per frame.

**Adversary assignment:** after the definition is frozen, replay it center-by-center on the ten
q=11 knife lines and the q17 line recorded in Section 6.

**Success gate:** an explicit reply map plus a well-founded closure proof.  **Failure gate:** the
same certificate covers a known N center, or a named q=11 boundary move has no certified reply.

**Estimated cost:** 25–35 high-reasoning minutes plus 10–15 minutes read-only replay; no solve,
under 2 GB.

### Route B — medium/high effort: identify the true reservoir charge

Compare the proved direction surplus

    E=k^2-|Dir(U)|

with C63's existing root-lane `reservoir_slack_total` on a frozen small transition sample.
This is an identity/comparison test, not a feature search.  Predeclare one of: exact equality
after coordinate translation, a one-sided inequality, or refutation.  This route accounts for
root/`d=5` supply only and must not be sold as DSC closure.

If it fails on the first forced corpus, record the counterexample and stop.  If it survives,
the result is a geometric interpretation of the root-lane charge, not a voltage theorem.

**Estimated cost:** 15–20 proof minutes plus 10 medium data minutes; existing q<=19 artifacts only.

The q=25 ten-center value batch remains post-census.  The full-dimensional monodromy result means
there is no reason to add a separate Baer-component campaign before those labels exist.

## 13. Circularity and scope audit

- No P label enters the Schreier, polarity, projection, voltage, direction, torus, or MDS proofs.
- The q17 labels are used only to refute static-boundary sufficiency.
- The q25 monodromy calculation is label-blind and does not consume census output.
- A legal opposite-line reply is never called a winning reply.
- Static boundary SG is not treated as a disjunctive summand of the full game.
- The ordinary quotient counterexample proves necessity of voltage, not sufficiency of
  balancedness.
- `AGL(1,q)` describes the ambient monodromy; the deleted legal subset need not be invariant.
- The affine direction reservoir is explicitly scoped away from the `d=4` axis, which already
  contains two selected points.
- The Rédei chain is not composed with the `d=4` DSC chain; it is separately scored as
  root/`d=5` supply accounting.
- `rhohat` alone is rejected before label mining because it omits the voltage already proved
  necessary; polarity survives only as reply-map algebra inside a voltage-aware certificate.
- Rédei lower bounds on determined directions are not reversed into reservoir lower bounds.
- The torus calculation works over every odd prime power and explicitly separates split and
  nonsplit/Frobenius cases.
- Small product sets, cross-ratio classes, and Baer spans are not defined through P labels.
- Fixed-q q=25 `(ON)` from round 3 is used nowhere in the new proofs.
- DSC remains unproved and attached to every statement of the remaining strategy target.

## 14. Independent round-4 verification (Claude, 2026-07-10)

**[INDEPENDENTLY VERIFIED]** Claude replayed all four declared reproduction commands
bit-for-bit and hand-checked the chord/blocker algebra, two-line homology-defect theorem,
external-line character criterion, parity/supply lemmas, anti-Frattini edge case, three no-go
examples, monodromy and polarity formulas, projection-overlap identity, static `q>=17` SG
argument, direction/torus identities, and single-inversion-center lemma.

**[COMPUTED-EXACT, INDEPENDENT]** On q=11, Claude enumerated the full 1,320-element conic
stabilizer and all 500 ordered cross-defect pairs in the character half.  There are exactly 12
orbits and exactly 12 `(chi(d^2+a),rhohat)` keys, bijectively in both directions.  This closes
the finite q=11 completeness audit for Section 4.1; it remains a fixed-q verification of the
imported orbital theorem, not a game-value result.

The static-boundary values at q=11 and q=13 requested in that audit are computed in the round-5
report.  The published proposition numbering for Sieben remains on the bibliographic trust
checklist; it is not load-bearing for any proof above.
