# Odd projective cap game — Codex round 7: generator growth and the Baer obstruction

**Date:** 2026-07-10
**Scope:** three independent delegates plus root synthesis; existing q<=19 labels used only in
one preregistered falsification table; one label-blind GF(25) construction; no recursive solve,
no q=25 census query, and no complete proof claimed. Run every reproduction command from `rust/`.

## Executive result

Round 6 proposed that a legal defect pair, followed by a homology rebase, might reset the dynamic
state to the original four Möbius generators. Round 7 settles that proposal negatively and explains
the obstruction exactly.

1. **[PROVED] Perspectivity-generator theorem.** For a homology-stable cap with two fixed
   selected points, every nonfixed selected point induces a distinct perspectivity between the two
   defect lines. Thus an `n`-point selected cap has exactly `n-2` full cross-defect generators.
   Every mirrored pair adds two; no projective change of gauge makes that number uniformly four.
2. **[PROVED] Exact one-intruder normal form.** After a legal boundary pair and a cap-stabilizing
   rebase, five suitable selected points normalize to a new conic frame, one fixed selected point
   becomes the new off-conic center, and the third swapped pair remains as an explicit intruder
   pair. The correct blocker system has six affine graphs, with all coefficients given below.
3. **[REFUTED] Literal Möbius reset.** The transformed raw trace is

   ```text
   R_(new six-frame) / {intruder, mate},
   ```

   not the raw trace of a bare six-frame. For q>=7, a union-size argument also rules out
   representing the six full perspectivities by four.
4. **[REFUTED, COMPUTED-EXACT, LABEL-BLIND]** The most generous frozen boundary-local state from
   round 6 is not autonomous. It included the signed live cover, every `tau` color, ordered marked
   lifts, and all marked rank-three rows restricted to the old boundary. Equal states at q=11 and
   q=13 have different sets of possible rebased outputs.
5. **[REFUTED, COMPUTED-EXACT]** A one-shot repair—require every boundary move to have an opposite
   reply whose eight-cap has a homology and a seven-point conic subset—fails both ways. At q=11 ten
   N states satisfy the universal condition and sixteen P states have no such reply; at q=13 no
   state satisfies it.
6. **[LITERATURE-IMPORTED / PROVED]** Matrix Hilbert 90 puts every projective semilinear
   involution with nontrivial quadratic field part into coordinate-Frobenius form. Its fixed locus
   is a Baer subplane. A new secant-union count then excludes a fixed-point-free-on-the-live-game
   semilinear rebase for every square `q=s^2` with `s>=23`.
7. **[COMPUTED-EXACT / REFUTED]** The large-`s` threshold is real, not cosmetic. At q=25 there is
   an explicit Frobenius-stable eight-cap with no legal fixed point. It has 30 incompatible legal
   deck orbits on six tangent defect lines. Therefore the PGL two-defect theorem does not extend
   verbatim to `PGammaL` at the first square order.

The dynamic defect lane is not closed, but its proposed bounded-state implementation is. A future
proof in this lane must retain genuinely off-boundary/global trace information and accommodate a
growing list of perspectivity factors. The best main-theorem alternative is to return to the
one-shot S3-to-S4 escape layer rather than fund another boundary feature dictionary.

The user-reported q=25 result `min-witness(25)>=4`, hence fixed-q `(ON)`, is used nowhere below.
The 13/28 all-P census prefix is likewise not used.

## 1. Normalized defect geometry

Work over an arbitrary odd finite field `F`. Put

```text
C(t)=(t^2:t:1),               C(infinity)=(1:0:0),
z_a=(-a:0:1),                 sigma(X:Y:Z)=(X:-Y:Z),
c=(0:1:0).
```

The round-3 `d=4` six-cap is

```text
S_a(r,s)={C(0), C(+/-r), C(+/-s), z_a}.
```

Its two defect lines are

```text
D_0=c C(0): X=0,              D_a=c z_a: X+aZ=0.
```

Use projective pencil coordinates

```text
P(p)=(0:1:p) in D_0,          Q(q)=(-aq:1:q) in D_a.
```

The reciprocal coordinates are `b=1/p` and `d=1/q`. Points with zero or infinite coordinates
are retained when discussing full projectivities; the live game deletes the selected and blocked
ones.

## 2. The perspectivity-generator theorem

### Theorem 1 — one generator per nonfixed selected point

**[PROVED]** Let `K` be a homology of `PG(2,q)` stabilizing a cap `T`. Suppose `K` fixes exactly
two selected points `A,B` on its axis and has center `c`. For each nonfixed `R in T`, projection
from `R` defines a perspectivity

```text
phi_R : cA -> cB.
```

The maps `phi_R` are pairwise distinct. Consequently, if `|T|=n`, the full cross-defect system has
exactly `n-2` perspectivity generators. Adding one `K`-pair adds exactly two generators.

**Proof.** A nonfixed selected point cannot lie on `cA`: otherwise `A,R,KR` would be three selected
collinear points. The same holds for `cB`, so projection is defined.

If `phi_R=phi_S`, choose two domain points whose two joining lines to their images are distinct.
Both joining lines pass through `R`, because `phi_R` is projection from `R`, and through `S`, by
the same argument for `phi_S`. Their unique intersection gives `R=S`. Thus the map from nonfixed
selected points to perspectivities is injective. There are `n-2` such points. `square`

Every perspectivity fixes the pencil intersection `c`, so all six graphs contain the common edge
`(c,c)`. A mate pair `(R,KR)` has no other common edge: its center-line `RKR` passes through `c`.
A non-mate pair has exactly one further common edge, obtained by intersecting its joining line
with `cA` and `cB`. There are `C(6,2)-3=12` non-mate pairs, and their extra edges are distinct,
since equality would put three selected centers on one line. Hence the exact six-graph union is

```text
1+6q-12=6q-11.
```

Any four-map frame-blocker system consists of perspectivities between the same two pencils and
therefore also fixes `c`; its union has size at most `1+4q`. For every odd q>=7,
`6q-11>4q+1` (at q=7 this is `31>29`):

### Corollary 1.1 — no literal four-map reset

**[PROVED]** For every odd q>=7, no coordinate conjugacy can turn the full six-generator
cross-defect system of an eight-cap into a four-perspectivity system.

Minimizing to the currently live boundary can hide generators by deleting their graph edges. This
is why Corollary 1.1 is a theorem about the full perspectivity/raw-trace geometry, not a claim that
every live graph visibly has six components. Section 4 independently kills the proposed minimized
boundary quotient.

### 2.1 Coordinate formula

In the normalized coordinates of Section 1, let `R=(X:Y:Z)` be any nonfixed selected point. A
determinant gives

```text
P(p), Q(q), R collinear
    iff q = pX/(X+aZ-apY).
```

Cap stability implies `X(X+aZ) != 0`. In reciprocal coordinates the same projectivity is affine:

```text
d = ((X+aZ)/X)b - aY/X.                         (2.1)
```

For a conic pair `C(+/-u)`, Equation (2.1) becomes

```text
d = ((a+u^2)/u^2)b +/- a/u.
```

For an arbitrary homology pair `(xi,+/-eta,zeta)`, it becomes

```text
d = kappa b +/- delta,
kappa=(xi+a zeta)/xi,        delta=a eta/xi.     (2.2)
```

These formulas hold over every odd prime-power field; no square root or prime-field ordering is
used.

## 3. Exact rebase-conjugated normal form

Let

```text
T=S_a(r,s) union {x,y}
```

be an eight-cap after a legal cross-defect pair. Suppose a cap-stabilizing homology `K` fixes
selected `A,B` and swaps

```text
(P,KP), (Q,KQ), (W,KW).
```

There are generally six choices of which two swapped pairs join `A` in the new conic frame. The
homology alone does not select one.

### Theorem 2 — rational one-intruder normal form

**[PROVED]** Choose `A,P,KP,Q,KQ` as the new five-point conic frame. In the basis `(B,c,A)`, write
points as `(X,Y,Z)`. Then

```text
K(X,Y,Z)=(X,-Y,Z).
```

The unique conic through those five points has equation

```text
lambda X^2 + mu XZ + nu Y^2 = 0,                (3.1)
```

where

```text
(lambda,mu,nu)
  = (X_P^2, X_P Z_P, Y_P^2) cross
    (X_Q^2, X_Q Z_Q, Y_Q^2).
```

It is nondegenerate, so `mu nu != 0`. Put

```text
L_P=lambda X_P+mu Z_P.
```

If `lambda != 0`, define

```text
N(X,Y,Z)=(X/X_P, Y/Y_P, (lambda X+mu Z)/L_P).    (3.2)
```

Then `N` conjugates `K` to `sigma`, maps the conic to `XZ=Y^2`, and sends

```text
A       -> C(0),
P,KP    -> C(+/-1),
Q,KQ    -> C(+/-s'),
B       -> z_(a'),
```

where

```text
s' = Y_Q L_P / (Y_P(lambda X_Q+mu Z_Q)),
a' = -L_P/(lambda X_P).                          (3.3)
```

If `N(W)=(xi,eta,zeta)`, then `N(KW)=(xi,-eta,zeta)`. The exact six blocker graphs are

```text
d=(1+a')b +/- a',
d=((a'+s'^2)/s'^2)b +/- a'/s',
d=kappa b +/- delta,
kappa=(xi+a'zeta)/xi,        delta=a'eta/xi.     (3.4)
```

Equivalently, for the unminimized trace hypergraph of round 6,

```text
N_*(R_(S_a(r,s)) / {x,y})
  = R_(S_(a')(1,s')) / {N(W),N(KW)}.             (3.5)
```

The right side is not `R_(S_(a')(1,s'))`.

**Proof.** Uniqueness of the conic makes it `K`-invariant. Invariance under `Y -> -Y`, together
with passage through `A=(0,0,1)`, reduces its equation to (3.1). The determinant of its quadratic
form is `-nu mu^2/4`, hence `mu nu != 0`.

Since `P` is nonfixed, `Y_P != 0`. Equation (3.1) gives

```text
X_P L_P = -nu Y_P^2,
```

so `X_P L_P != 0`. Substituting (3.1) into (3.2) gives `X'Z'=Y'^2`; evaluating at `P`, `KP`, and
`Q`, `KQ` gives the parameters in (3.3). Evaluating at `B=(1,0,0)` gives `z_(a')`. Equation (3.4)
is Equation (2.1) applied to the three swapped pairs. Equation (3.5) is the exact contraction law
`R_(T union A)=R_T/A` from round 6, transported by `N`. `square`

### 3.1 Denominators and the exceptional gauge

- `det(B,c,A) != 0`, because `A,B` span the axis and `c` is off it.
- `Y_P,Y_Q,Y_W != 0`, because all six paired points are nonfixed.
- `X_P,L_P != 0` by the displayed conic identity.
- `lambda=0` exactly when `B` lies on the new conic. Then `A,B,P,KP,Q,KQ` are six selected conic
  points and a different normalization is required. This is an **all-six-on-conic gauge**; it is
  not identified with the distinct round-4 `d=5` involution.
- In the finite `d=4` gauge, cap legality gives `a' != 0,-1,-s'^2` and
  `s' notin {0,+/-1}`.
- The remaining intruder avoids both defect lines, so `xi eta (xi+a'zeta) != 0`.

### 3.2 q=11 formula check

**[COMPUTED-EXACT]** For the q=11 P collision member `a=9` and boundary pair `(3,8)`, the existing
audit finds

```text
(C0 x)(C1 za)(C-1 y),        C(+/-4) fixed.
```

Choose `A=C4`, `B=C-4`, conic pairs `(C0,x),(C-1,y)`, and intruder pair `(C1,z_a)`. Equations
(3.2)-(3.4) give

```text
a'=4, s'=9, N(C1)~(4,3,3), kappa=4, delta=3,
blockers: 5b+/-4, 2b+/-2, 4b+/-3.
```

The cap permutation and rebase matrix replay with:

```sh
python3 scripts/r6_rebase_audit.py
```

Its final line is:

```text
SUMMARY cases=4 unique_rebases=4 free_on_T_rebases=0 all_assertions=PASS
```

## 4. Frozen autonomy test

Before consulting any game labels, the exact-data delegate froze the following projected state
`Q(T;x,y)`:

1. the complete live two-defect incompatibility graph and deck involution;
2. the round-6 `tau` color on every live vertex;
3. ordered marked lifts `x,sigma x,y,sigma y`;
4. every rank-three trace row incident with a marked lift, restricted to the old live boundary.

For every legal cross-defect pair, the audit enumerates all `28*15=420` two-fixed/three-swapped
cap permutations, constructs every corresponding homology, rejects homologies with a legal fixed
point, and computes the set of rebased `Q` outputs. Output comparison permits interchange of the
two fixed points/defect sides. P/N fields are never read.

### Theorem 3 — the frozen boundary state is not autonomous

**[REFUTED / COMPUTED-EXACT, LABEL-BLIND]** At q=11 take

```text
U={+/-1,+/-2}, a=5, x=(0,1,3).
```

Compare

```text
y_A=(1,4,2),                 y_B=(1,7,2).
```

Their input `Q` states are exactly isomorphic by `0->0, 1->1, 2<->3`. All four live vertices have
`tau=0`; the complete boundary-restricted marked rank-three family is empty on both sides. The
ordered marked caps are in different PGL orbits. Nevertheless:

- the `y_A` cap has five admissible rebases and all five output boundaries are empty;
- the `y_B` cap has one admissible rebase and its output has one live deck fiber, with two
  `tau=0` vertices joined by an incompatibility edge.

Thus equal projected input states have unequal sets of projected outputs. No deterministic or
nondeterministic transition on this `Q` can reproduce rebasing.

The exhaustive totals are:

| q | states | legal pairs | input Q classes | rebase-count histogram | autonomy failures | Q classes merging marked PGL orbits |
|---:|---:|---:|---:|---:|---:|---:|
| 11 | 24 | 84 | 11 | `0:36, 1:42, 5:6` | 2 | 3, maximum 2 orbits |
| 13 | 30 | 400 | 54 | `0:340, 1:60` | 3 | 19, maximum 4 orbits |

At q=13 the first equal-`Q` pair has 19 marked rank-three entries on each side; one member has no
rebase and the other has a unique output containing a live `tau=1` fiber. The preregistered gate
therefore skipped q=17.

**[PROVED]** The boundary-restricted rank-three rows add no independent information here. For
three distinct live points in `D_0 union D_a`, collinearity holds exactly when all three lie on one
defect line: two points on one line determine it, and the intersection `c` is already deleted.
Hence these rows are determined by the side colors. Repairing autonomy requires off-boundary trace
or an algebraic certificate carrying equivalent global information.

Reproduction:

```sh
python3 scripts/r7_autonomy_audit.py
```

The script prints the frozen definition first, the collision coordinates and isomorphism, all
histograms above, and:

```text
q=17 SKIPPED_BY_PREDECLARED_SURVIVOR_GATE
```

## 5. The seven-conic one-shot repair also fails

The root froze a weaker, purely geometric proposal before joining labels.

> `REBASE7(S)`: for every live boundary move `x`, some legal move `y` on the opposite defect line
> makes an eight-cap admitting a two-fixed/three-swapped cap homology and a conic through seven of
> its eight selected points.

The script actually allows any such cap homology, even one with a legal fixed point, so failure is
not caused by imposing too strong a residual-mirror condition. A quadratic through seven cap
points is automatically nondegenerate, since a union of two lines contains at most four cap
points.

**[REFUTED / COMPUTED-EXACT]** After freezing `REBASE7`, the existing labels give:

| q | all replies pass, N | all replies pass, P | some but not all, N/P | no reply, N | no reply, P |
|---:|---:|---:|---:|---:|---:|
| 11 | 10 | 26 | `0 / 6` | 6 | 16 |
| 13 | 0 | 0 | `6 / 21` | 9 | 48 |

Thus the universal condition is neither sufficient nor necessary at q=11 and has no entry state
at q=13. Proving the extensions legal would in any event not prove them P-valued; the exact table
shows that this particular geometric closure does not repair that gap.

Reproduction:

```sh
python3 scripts/r7_rebase7_kill.py
```

The script stops before q=17 because q=11 and q=13 already meet the declared failure gate.

## 6. Semilinear involutions and Baer fixed loci

### 6.1 Matrix Hilbert 90

**[LITERATURE-IMPORTED]** Let `L/K` be a finite Galois extension. Matrix Hilbert 90 states

```text
H^1(Gal(L/K), GL_n(L))=1.
```

Equivalently, for a cyclic generator `tau`, a matrix cocycle `X` of norm one has the form
`X=B^(-1) tau(B)` (up to the chosen left/right convention). This exact statement appears as
Theorem 3.1 and Corollary 3.2 in
[Glasby–Howlett, *Matrices for finite group representations that respect Galois automorphisms*](https://link.springer.com/article/10.1007/s00013-023-01963-x),
which cites Serre, Chapter X, Proposition 3; see also
[Serre, *Galois Cohomology*](https://link.springer.com/book/10.1007/978-3-642-59141-9).

**Translation.** Let `q=s^2` and let a projective semilinear involution have nontrivial field part
`tau:x->x^s`. Choose a representative `A tau`. Projective order two gives

```text
A tau(A)=lambda I,            lambda in F_s^*.
```

The finite-field norm is surjective, so scalar-rescale `A` to make the product `I`. Matrix Hilbert
90 then conjugates `A tau` to coordinate Frobenius `tau`. Its fixed projective points are exactly a
copy of `PG(2,s)`, a Baer subplane. This agrees with the standard Baer-involution construction in
the [FinInG subgeometry documentation](https://gap-packages.github.io/FinInG/doc/chap14_mj.html).

The import classifies the fixed geometry. It does not say that a fixed point is legal; that is the
new counting problem below.

### Theorem 4 — fixed blocked-point bound

**[PROVED]** Let `h` be such a Baer involution stabilizing an eight-cap `T`. Let `f` be the number
of selected fixed points and `k=(8-f)/2` the number of selected conjugate pairs. Then

```text
f in {0,2,4,6,8}.
```

Among the 28 selected secants, exactly

```text
L=C(f,2)+k
```

are invariant: the secants among fixed selected points and the `k` conjugate-pair chords. The
remaining secants occur in conjugate pairs, whose intersections contribute at most

```text
M=(28-L)/2
```

additional blocked fixed points. The total number `B_f(s)` of blocked points in the fixed Baer
subplane satisfies:

| f | k | L | M | `B_f(s)` upper bound | guaranteed fixed legal point |
|---:|---:|---:|---:|---:|---:|
| 0 | 4 | 4 | 12 | `4s+13` | `s>=7` |
| 2 | 3 | 4 | 12 | `4s+13` | `s>=7` |
| 4 | 2 | 8 | 10 | `8s+1` | `s>=9` |
| 6 | 1 | 16 | 6 | `16s-37` | `s>=13` |
| 8 | 0 | 28 | 0 | `28s-125` | `s>=23` |

**Proof.** The `C(f,2)` fixed-point secants lie in the Baer plane. At a selected fixed point,
`f-1` of these secants concur, saving `f-2` points relative to disjoint addition, for a total
saving `f(f-2)`. Off the arc, at most `f/2` secants concur because their endpoint pairs are
disjoint. The number of pairs of disjoint secants is `3 C(f,4)`. If an off-arc point has
multiplicity `r`, then

```text
r-1 >= (4/f) C(r,2).
```

Therefore the off-arc overlap saving is at least

```text
(4/f) 3C(f,4)=(f-1)(f-2)(f-3)/2.
```

The union of the fixed-point secants consequently has size at most

```text
C(f,2)(s+1)-f(f-2)-(f-1)(f-2)(f-3)/2.           (6.1)
```

Each conjugate-pair chord avoids every fixed selected point. Intersect it with the `f-1` secants
through one chosen fixed selected point; these intersections are distinct. Thus each such chord
adds at most `s-f+2` fixed points to (6.1). For `f=0`, four lines have union at most `4s+1`; the
same value results for `f=2`. Finally add the at most `M` intersections of noninvariant secant
pairs. Substitution gives the table. Comparing each bound with the `s^2+s+1` Baer points gives the
last column. `square`

### Corollary 4.1 — large-square obstruction

**[PROVED]** If `s>=23`, every Baer involution stabilizing an eight-cap has a legal fixed point.
Hence it cannot be a residual rebase whose fixed locus is entirely unavailable.

The round-6 tangent reconstruction proof is incidence-theoretic and applies to semilinear
collineations as well as projectivities. Thus for `q=s^2>=529`, a continuation-clutter-preserving
semilinear involution first stabilizes the selected eight-cap and then is excluded by this
corollary. The theorem does not cover the small square orders.

### 6.2 Exact q=25 obstruction

**[REFUTED / COMPUTED-EXACT, LABEL-BLIND]** Write

```text
F_25=F_5(w),                  w^2=2,
tau(w)=-w,
C: XZ=Y^2.
```

Let

```text
T=C(F_5) union {(2:w:1),(2:-w:1)}.
```

The six points `C(F_5)` mean all six points of the subfield conic, including infinity. This
six-point seed is the classical characteristic-five Clebsch hexagon (Dye 1991, §1.4, p. 271); the
project-specific step is adjoining the conjugate pair and analyzing the resulting Frobenius
fixed-extension obstruction. The eight points of `T` lie on the nondegenerate F_25 conic, so they
form a cap, and `tau(T)=T` with `f=6`.
Every fixed Baer point is blocked: a point of the subfield conic is selected, while every other
point of `PG(2,5)` lies on a secant of that six-point conic. Therefore there is no legal fixed
point.

Exact enumeration gives:

```text
q=25 points=651 T=8 cap=PASS fixed_B=31 legal=150 fixed_legal=0
P=(1,15,3) tauP=(1,10,3)
bad_deck_orbits=30 defect_lines=6 orbits_per_line=[5,5,5,5,5,5]
all_assertions=PASS
```

The six defect lines are the six subfield tangents at the selected points of `C(F_5)`. Every other
subfield line through one of those points is a secant containing another selected conic point. The
30 displayed legal deck orbits are precisely legal `x` for which the nominal reply `tau(x)` is
made illegal by a selected point; they split five per tangent.

Thus this is a genuine semilinear residual rebase—cap and continuation geometry are preserved and
there is no legal fixed point—but it is not a mirror strategy. In particular, the two-line PGL
defect theorem cannot be reused with “axis plus center” replaced by “Baer subplane.”

Reproduction:

```sh
python3 scripts/r7_semilinear_q25.py
```

No q=25 game label or census artifact is read.

## 7. Exact remaining gap

Round 6's proposed dynamic projected-contraction lemma had two nontrivial hopes: rebasing would
return to four Möbius generators, and a boundary-local signed trace would be autonomous. Theorem 2
and Theorem 3 respectively refute those hopes.

What remains possible is a **global one-intruder certificate**:

1. start from a value-blind algebraic selector of a character-half `d=4` center;
2. answer off-boundary moves by the proved homology mate;
3. for a boundary move, use an explicit formula—not “choose a P reply”—for the opposite move and
   rebase gauge;
4. carry the complete list of `n-2` perspectivity factors together with enough off-boundary trace
   to update it exactly;
5. prove decrease of a declared well-founded algebraic rank and an SG-zero base case.

This is narrower than the original theorem because it concerns only the already localized
two-clique defect phase, and every off-boundary response is proved. It is wider than the round-6
bounded quotient because the generator list necessarily grows. No rank, reply formula, or base
case is currently proved, so this statement is an exact research target rather than a result.

At the main theorem level, the logical reduction remains unchanged:

```text
every legal residual S3 has a P-valued S4 child  =>  empty PG(2,q) is P.
```

Round 7 does not prove any child P-valued and does not assume `(ON)`. Its strongest service to the
main proof is to eliminate a deceptively attractive implementation of DSC and redirect effort
toward either a genuinely global trace proof or the one-shot S3-to-S4 escape layer.

## 8. Approach registry

| family | exact target | strongest result | blocker | weaker than main theorem? | next kill test |
|---|---|---|---|---|---|
| Literal rebase reset | Return to four Möbius maps after each pair | Exact one-intruder normal form | Six distinct generators remain | Closed negative | None |
| Perspectivity arrangement | Describe all cross-defect blockers | Exactly `n-2` injectively parameterized maps; explicit affine factors | Factor count grows by two per symmetric round | Yes | Any proposed bounded quotient must merge factor arrangements; test unequal contractions before labels |
| Frozen boundary `Q` | Autonomous signed local state | Properly merges marked PGL orbits | q=11/q=13 equal inputs have unequal rebase outputs | Closed for boundary-restricted data | Require a named off-boundary trace family, not another boundary color |
| Seven-conic rebase | One-shot geometric Good class | Explicit, label-free predicate | Ten q=11 N pass; sixteen P fail; q=13 has no universal state | Closed negative | None |
| Matrix Hilbert 90 | Normalize square-order semilinear involutions | All become Baer involutions | Legality of fixed points is separate | Yes | Completed by fixed-secants count |
| Baer fixed-point count | Exclude semilinear residual rebases | Uniform exclusion for `q=s^2`, `s>=23` | Small square orders survive | Yes | Classify small `f=4,6,8` secant unions only if needed by a global strategy |
| PGL-to-PGammaL extension | Keep two defects at square orders | Exact q25 test | Explicit six-defect residual rebase | Closed negative in literal form | Any square-order DSC must accept six tangent defects |
| Full raw-trace divisor | Replace bounded state by global algebra | Each homology pair contributes an explicit quadratic factor | Exact factor list approaches full state; no descent invariant | Yes | Freeze one low-degree relative invariant and seek equal-invariant/unequal-contraction pairs at q=11 before labels |

## 9. Recommended next round

### Route A — primary: return to the one-shot escape layer

**Assignment:** one Ultra/high proof agent on the exact S3-to-S4 geometry, plus one medium exact
adversary using only existing q=11/q=17 depleted data. Do not ask the proof agent for another DSC
feature. Instead, seek a direct algebraic family of candidate S4 children that contains both the
on-conic candidates and a projectively defined off-conic fallback, motivated by q=17's extremal
fan with one on-conic and four off-conic P escapes.

**Required first deliverable:** a bidirectional, label-free description of that candidate family
and an exact count/character-sum existence lemma. Only after freezing it should the adversary join
labels and demand that every extremal q=11/q=17 fan contain a member. A surviving family must then
come with a separate `candidate => P` game argument; legality alone is not success.

The q=25 Baer example is a scope guard for that second clause: square-order continuations can have
six tangent defects, so a prime-power-uniform candidate or strategy must not hard-code the
two-defect PGL geometry.

**Success gate:** a genuinely weaker sufficient chain

```text
every S3 meets algebraic family G
+ every G child has an explicit SG-zero strategy
=> required P child.
```

**Failure gate:** the family misses a known extremal fan, contains the known q=11 N child under the
same proposed certificate, or its second clause reduces to “choose a P reply.”

**Estimated cost:** 35–50 high-reasoning minutes plus 15–20 medium replay minutes; no new solve and
under 2 GB.

### Route B — secondary: global divisor dynamics, one sharply gated attempt

For a homology-stable cap, encode the full cross-defect arrangement by

```text
F_T(b,d)=product_i ((d-kappa_i b)^2-delta_i^2).
```

This is a union of `(1,1)` divisors on `P^1 x P^1`; adding a mirror pair multiplies one quadratic
factor, and a rebase acts by projectivities on the two pencils. This imports classical invariant
theory without pretending the low-degree invariants already determine play.

**Assignment:** one high algebraic-geometry/invariant-theory agent to derive the exact rebase action
on `F_T` and name one low-degree relative invariant tied to off-boundary deletion collisions; one
medium agent immediately tests autonomy on the q=11 collision corpus before labels.

**Success gate:** the invariant is proper, its contraction/rebase update is proved, and it passes
the q=11/q=13 label-blind autonomy test. **Failure gate:** equal invariant gives unequal updates,
or the invariant reconstructs the full factor arrangement. Stop after the first named invariant;
do not launch a feature search.

**Estimated cost:** 25–35 high-reasoning minutes plus 10–15 medium replay minutes.

Route A has priority. Route B is worth exactly one attempt because Theorem 1 supplies a natural
global algebraic object, but the round's evidence is against bounded dynamic compression.

The launcher exposed no model/effort selector. “Ultra/high” and “medium” above, and for the three
delegates in this round, are task-depth requests only; no product-level model setting is claimed.

## 10. Circularity and scope audit

- The generator, normal-form, autonomy, and Baer constructions use no game value.
- `REBASE7` was frozen before labels; its table is reported as a falsifier, never as a classifier.
- A legal extension, homology, or rebase is never called P-valued.
- The q=11 q=13 autonomy test compares transition geometry, not P/N labels, Z, remoteness, or an
  exact strategy oracle.
- The growing generator theorem concerns full perspectivities. It is not silently identified with
  the minimized live graph.
- The all-six-on-conic `lambda=0` gauge is not called the round-4 `d=5` state.
- Matrix Hilbert 90 is applied only after normalizing the projective scalar cocycle by the
  surjective finite-field norm.
- The large-square semilinear result assumes/states cap stabilization; tangent reconstruction is
  invoked only at q>=529, well inside its q>=23 range.
- The q25 example refutes a semilinear two-defect extension, not the main theorem or `(ON)`.
- Prime-field q=11/q=13 computations are not extrapolated to prime powers. The GF(25) script uses
  exact extension-field arithmetic and Frobenius.
- No absent early-break child is assigned a value, no census state is inferred, and no recursive
  game computation was launched.
- The proposed Route A still needs both coverage and P-value. The report explicitly rejects a
  chain ending at legal existence.

## 11. Files and exact commands

- `notes/2026-07-10-codex-odd-plane-round7-generator-growth-baer.md` — this report.
- `rust/scripts/r7_autonomy_audit.py` — frozen q=11/q=13 rebase-autonomy falsifier.
- `rust/scripts/r7_rebase7_kill.py` — preregistered seven-conic closure falsifier.
- `rust/scripts/r7_semilinear_q25.py` — exact GF(25) Baer residual-rebase construction.

Run from `rust/`:

```sh
python3 scripts/r6_rebase_audit.py
python3 scripts/r7_autonomy_audit.py
python3 scripts/r7_rebase7_kill.py
python3 scripts/r7_semilinear_q25.py
```

All four commands returned exit status zero in the root replay. The three new scripts are
diagnostic; none performs recursive game search or modifies a census artifact.

## 12. Independent verification (Claude, 2026-07-10)

**[INDEPENDENTLY VERIFIED]** Claude replayed all three Round-7 scripts exactly, including the
q=25 Baer construction, both `REBASE7` joint tables, and the q=11/q=13 autonomy collisions.
Theorem 2 was independently reconstructed numerically on the Section 3.2 example, recovering the
conic coefficients `(9,1,5)`, `L_P=2`, `a'=4`, `s'=9`, `N(C1)=(4,3,3)`, and all six blocker
coefficients. Theorem 4's overlap savings, five bounds, thresholds, and the q=25 subfield-conic
blocking argument were hand-checked.

The verification also identified and supplied the corrected common-edge accounting now used in
Corollary 1.1: the exact six-graph union is `6q-11`, not the earlier Bonferroni expression. The
conclusion for every odd q>=7 is unchanged because every competing four-map frame system shares
the same pencil-intersection edge and has union at most `4q+1`.
