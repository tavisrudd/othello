# C289 — The `A5 (3,5,5)` split: common order, class structure, and template sensitivity

**Date:** 2026-07-17. **Lane:** `dihedral`. **Status:** COMPLETE.

Conceptual companion to [C284](2026-07-17-c284-dihedral-polyhedral-coset-templates.md). C284
proved computationally that the pair `(sigma,rho)` is a complete `Aut(G)`-orbit invariant of
generating involution triples of `S4` and `A5`, and that the old `A5` signature `(3,5,5)` splits
into a `rho=3` and a `rho=5` class of 60 triples each, with equal regular nimbers (`t1=0`) but
different nonregular coset templates (`t3,t5 = 1,1` versus `0,0`). This report proves the
common-order lemma behind `rho`, identifies the two classes structurally, proves the `rho=5`
regular value by a symmetry argument, and explains what the coset construction sees that the
regular nimber does not. Verification artifacts: the adjacent script and JSON with the same stem.

Every claim below is labelled proved or computational. Notation follows the manuscript and C284:
`T={a,b,c}` a generating involution triple of `G`, `sigma(T)` the sorted pair-product orders,
`rho(T)` the common order of the six ordered products, `R(G,K,T)` the fixed-point-deleted coset
residual, `t_d` its nimber for `K=C_d`, `phi=(1+sqrt5)/2`.

## 1. The common-order lemma (proved)

**Lemma 1.** Let `a,b,c` be involutions in any group. The six ordered products
`abc, acb, bac, bca, cab, cba` all have the same order. More precisely, `{abc, bca, cab}` is a
single conjugacy triple, `{cba, acb, bac}` is a single conjugacy triple, and the second triple
consists of the inverses of the first.

*Proof.* Cyclic rotations of any product are conjugate: `bca = a^{-1}(abc)a` and
`cab = (ab)^{-1}(abc)(ab)`; likewise for the rotations of `cba`. Since `a,b,c` are involutions,
`(abc)^{-1} = c^{-1}b^{-1}a^{-1} = cba`. Conjugation and inversion preserve order. ∎

So `rho(T)` is well defined for every unordered involution triple, in every group; only the
inversion step uses that the generators are involutions. Verified exhaustively for all 84
involution triples of `S4` and all 455 of `A5` (script check 1). One further well-definedness
fact used below: in `A5` every 5-cycle is conjugate to its inverse by an even permutation
(`(1 2 3 4 5)^{-1} = (2 5)(3 4)\,(1 2 3 4 5)\,(2 5)(3 4)`), so by Lemma 1 the `A5`-conjugacy
class of the triple product is independent of the ordering whenever `rho=5`.

## 2. Structural identification of the split (proved)

`A5` has two conjugacy classes of order-5 elements, each of size 12, exchanged by the outer
automorphism; an element and its inverse are always in the same class. For a triple with
`sigma(T)=(3,5,5)`, let `p` and `q` denote the two pair products of order 5 (each well defined
up to inversion, so each has a well-defined class).

**Theorem 2.** Let `T={a,b,c}` generate `A5` with `sigma(T)=(3,5,5)`. Then

- `rho(T)=5` if and only if `p` and `q` are `A5`-conjugate, and in that case the triple product
  `abc` lies in the *other* order-5 class, the one not containing `p` and `q`;
- `rho(T)=3` if and only if `p` and `q` lie in different order-5 classes.

*Proof.* Realize `A5` as the icosahedral rotation group `I < SO(3)` (any faithful realization
proves the abstract statement) and lift to the binary icosahedral group `2I < SU(2) < SL2(C)`.
Each involution of `I` lifts to an element of trace 0; each lift is determined up to sign. Fix
lifts `A,B,C` of `a,b,c` and put `x=tr(AB)`, `y=tr(BC)`, `z=tr(CA)`.

*Step 1 (trace identity).* For any 2×2 matrix `M`, the adjugate satisfies
`adj(M) = tr(M)I - M`. If `tr U = tr V = 0` then
`adj(UV) = adj(V)adj(U) = (tr(V)I - V)(tr(U)I - U) = VU`, so

```text
VU = tr(UV) I - UV            for  tr U = tr V = 0.               (i)
```

Also `U^2 = -I` for `U` in `SL2` with `tr U = 0` (Cayley–Hamilton), so `U^{-1} = -U`, and
`tr(M^2) = tr(M)^2 - 2` for `M` in `SL2`. Using (i) with `U=B, V=C`:
`ACB = A(CB) = A(y I - BC) = yA - ABC`, hence

```text
tr(ACB) = -tr(ABC).                                               (ii)
```

Next, `tr(ABC)·tr(ACB) = tr(ABC·ACB) + tr(ABC·(ACB)^{-1})`. For the second term,
`(ACB)^{-1} = (-B)(-C)(-A) = -BCA` and `ABC·BCA = A(BC)^2A`, so
`tr(ABC·(ACB)^{-1}) = -tr(A^2 (BC)^2) = tr((BC)^2) = y^2 - 2`. For the first term, apply (i)
twice: `ABCACB = AB(CA)CB = z·ABCB - ABA C^2 B = z·ABCB + ABAB` and
`ABCB = y·AB - A B^2 C = y·AB + AC`, giving `tr(ABCACB) = z(xy+z) + x^2 - 2`. Summing,

```text
tr(ABC)^2 = -tr(ABC)tr(ACB) = 4 - x^2 - y^2 - z^2 - xyz.          (iii)
```

Flipping the sign of any one lift flips two of `x,y,z` and fixes the third, so both sides of
(iii) are independent of the lift choices.

*Step 2 (trace dictionary for `2I`).* An element of `I` of order 1, 2, 3, 5 rotates by 0, 180°,
±120°, or ±72°/±144°, and a lift of a rotation by angle `theta` has trace `±2cos(theta/2)`.
Hence the possible values of `tr^2` on `2I` are exactly `4, 0, 1, phi+1, 2-phi` (using
`2cos36° = phi`, `2cos72° = phi-1`, `phi^2 = phi+1`, `(phi-1)^2 = 2-phi`), and for order-5
elements `tr^2` separates the two `A5`-classes: rotation by ±72° has `tr^2 = phi+1`, rotation
by ±144° has `tr^2 = 2-phi`, conjugation preserves the rotation angle, and the two classes of
size 12 exist by the class equation `60 = 1+15+20+12+12` with `g` conjugate to `g^{-1} = g^4`
but not to `g^2`.

*Step 3 (case analysis).* Order the triple so that `x^2 = 1` (the order-3 pair product) and
`y^2, z^2` come from the order-5 products `p,q`. Traces of `2I` elements are real, so
`tr(ABC)^2 ≥ 0`, and it must lie in the spectrum `{4,0,1,phi+1,2-phi}`.

- *Different classes:* `{y^2,z^2} = {phi+1, 2-phi}`. Then `x^2+y^2+z^2 = 4` and
  `|xyz| = 1·phi·(phi-1) = 1`, so (iii) gives `tr(ABC)^2 = -xyz = ±1`, forcing
  `tr(ABC)^2 = 1`: the triple product has order 3.
- *Same class, `y^2=z^2=phi+1`:* (iii) gives `tr(ABC)^2 = 1-2phi - xyz` with
  `|xyz| = phi^2 = phi+1`. The option `-3phi` is negative; the other is
  `1-2phi+phi+1 = 2-phi`: order 5, in the class with `tr^2 = 2-phi` — the class *not*
  containing `p,q`.
- *Same class, `y^2=z^2=2-phi`:* `tr(ABC)^2 = 2phi-1 - xyz` with `|xyz| = 2-phi`. The option
  `3phi-3 ≈ 1.854` is not in the spectrum; the other is `2phi-1+2-phi = phi+1`: order 5, again
  the opposite class. ∎

Verified exhaustively over all 120 `sigma=(3,5,5)` generating triples in the permutation model,
and independently over all 48 exact rational trace-0 `SL2` instances for identity (iii) (script
checks 3–4). The argument is characteristic-free in the direction the paper needs: identity
(iii) and the adjugate manipulations hold verbatim for trace-0 lifts in `SL2(F)` for any field
`F` of odd characteristic, with `phi` a root of `X^2 = X+1`; only the positivity step used the
real embedding, and over a finite field it is replaced by the same spectrum-membership argument
(the trace of a product of lifts of elements of the embedded `A5` is a trace of `2I`).

## 3. Icosahedral and orbit interpretation (proved, verified exactly)

Identify the 15 involutions of `I ≅ A5` with the 15 edge-axes of the icosahedron. Two distinct
axes meet at one of the angles 90°, 60°, 36°, 72°, and the product of the two half-turns is a
rotation by twice the angle. The exact dictionary (verified over all 105 axis pairs in the
icosian quaternion model, exact `Q(sqrt5)` arithmetic, script check 5):

| axis angle | pair product          | lift `tr^2` |
|-----------:|-----------------------|-------------|
|        90° | order 2               | `0`         |
|        60° | order 3               | `1`         |
|        36° | order 5, rot. ±72°    | `phi+1`     |
|        72° | order 5, rot. ±144°   | `2-phi`     |

A `sigma=(3,5,5)` triple is a triple of edge-axes with one 60° angle and two angles from
`{36°,72°}`. The three possible configurations, with exact counts among the 120 generating
triples:

| configuration    | shape    | `rho` | count |
|------------------|----------|------:|------:|
| `(60°,36°,36°)`  | isoceles |   `5` |    30 |
| `(60°,72°,72°)`  | isoceles |   `5` |    30 |
| `(60°,36°,72°)`  | scalene  |   `3` |    60 |

So the split is a chirality-free shape dichotomy: **`rho=5` triples are isoceles, `rho=3`
triples are scalene.** The outer automorphism of `A5` (algebraically: conjugation by an odd
permutation; arithmetically: the Galois twist `sqrt5 -> -sqrt5`, which swaps the two order-5
trace classes) exchanges the two isoceles families and preserves the scalene family. The orbit
structure is exactly parallel (script check 6):

- `rho=5`: one `Aut(A5)`-orbit of 60, splitting into two inner `A5`-orbits of 30; the
  stabilizer of a triple in `Aut(A5) ≅ S5` has order 2 and is generated by an **inner**
  involution — conjugation by the `w in A5` that realizes the isoceles symmetry, swapping the
  two like generators and fixing the third.
- `rho=3`: one `Aut(A5)`-orbit of 60 which is already a single inner orbit; the order-2
  stabilizer is generated by an **outer** involution. A scalene triple has no internal
  symmetry inside `A5`.

Terminological remark (no logical weight): in the language of regular maps and hypermaps, a
generating involution triple presents `A5` as a quotient of the extended `(3,5,5)` triangle
group, and `abc` is its Petrie element; `rho` is the Petrie order, and the split is the
classical phenomenon of hypermaps of the same type differing in their Petrie invariant.

## 4. Why the regular nimber is blind and the coset templates are not

### 4.1 A mirror theorem for the regular template (proved)

**Lemma 3.** Let `T` be a generating set of involutions of a finite group `G`, and suppose there
is an involution `w in G \ T` with `wTw^{-1} = T`. Then the Node-Kayles value of `Cay(G,T)`
(edges `{g, tg}`) is 0.

*Proof.* Left multiplication `L_w: g -> wg` is a graph automorphism (`wg` and `wtg = (wtw^{-1})wg`
are adjacent because `wtw^{-1} in T`), is an involution (`w^2 = e`), is fixed-point-free
(`wg = g` would force `w = e`), and never maps a vertex into its closed neighborhood
(`wg = tg` would force `w = t in T`). The second player mirrors: if the live set `S` is
`L_w`-invariant and the first player takes `v`, then `wv` lies in `S \ N[v]`, so it is a legal
reply, and the new live set `S \ (N[v] ∪ N[wv]) = S \ (N[v] ∪ wN[v])` is again `L_w`-invariant.
By induction the second player always has a reply, so the position is a P-position; for an
impartial game this is exactly Grundy value 0. ∎

**Theorem 4.** The `rho=5` class of `A5 (3,5,5)` satisfies the hypothesis of Lemma 3: for the
representative `T = {(1 2)(3 4), (0 1)(3 4), (0 3)(2 4)}` one may take `w = (0 2)(3 4)`, the
isoceles symmetry of §3 (it swaps the first two generators and fixes the third, and
`w ∉ T`). Hence `t1 = 0` for the `rho=5` class is **proved**, not merely computed.

For the `rho=3` class no such `w` exists: by §3 the stabilizer of the triple in `Aut(A5)` is
generated by an outer involution, and inner set-stabilizing involutions are exactly the mirror
candidates. Exhaustive search (script check 8) confirms more: in the full color-respecting
automorphism group `{g -> alpha(g)h : alpha in Stab_{S5}(T), h in A5}` of order 120, the
`rho=3` Cayley graph admits **no** free non-adjacent involution at all. Its regular value 0
remains the independently double-computed C260/C284 result; whether a pairing exists in the
full (color-forgetting) automorphism group was not determined here.

The same criterion organizes the whole polyhedral table (script check: `mirror_criterion`,
all 10 classes): a mirror involution `w` exists for `S4 (2,3,3)`, `S4 (3,3,3)`, `S4 (3,4,4)`,
`A5 (3,3,5)`, `A5 (3,5,5) rho=5`, and `A5 (5,5,5)` — all with `t1=0`, now proved rather than
computed — and does not exist for the two value-1 classes `A5 (2,3,5)`, `A5 (2,5,5)` (as
Lemma 3 forces) nor for the two remaining zero classes `S4 (2,3,4)` and `A5 (3,5,5) rho=3`,
whose zeros stay computational.

### 4.2 The regular graph detects `rho`; the regular nimber does not (proved / computational)

The two Cayley graphs are *not* isomorphic: their closed-walk counts `tr(A^k)` first differ at
`k=8` (34740 versus 35460), and at `k=9` the `rho=3` graph has 360 closed walks while the
`rho=5` graph has none (script check 7). The 360 are exactly `6·60`: through each vertex, one
closed 9-walk for each of the six length-9 relators `(xyz)^3 = e` supplied by Lemma 1 — the
direct graph-theoretic shadow of `rho=3`. So the information is present in the regular
template as a graph; what collapses it is the passage to the single Grundy number, which for
the `rho=5` class is forced to 0 by the equivariant mirror of Theorem 4 and for the `rho=3`
class happens to be 0 as well.

### 4.3 What the coset construction sees (proved counts, computational values)

In the regular (free) orbit no rotation subgroup meets the trivial point stabilizer, so the
conjugacy position of the rotation subgroups `⟨ab⟩, ⟨ac⟩, ⟨bc⟩` relative to a stabilizer is
invisible. In a nonregular orbit the stabilizer is a cyclic `K = C_d`, and the C284
construction deletes exactly the cosets `gK` with `g^{-1}hg in K` for a pair product `h`:
deletion happens precisely where a rotation subgroup is conjugate *into* `K`. That is the
mechanism that turns Theorem 2's class datum into local graph structure:

- `K = C5 = ⟨s⟩` (coset space of size 12). Each of the two order-5 rotation subgroups is
  conjugate to `K` and fixes exactly 2 cosets, giving the `2+2 = 4` deleted vertices (verified
  per subgroup, script check 9). Whether `g^{-1}pg` lands in `{s, s^4}` or `{s^2, s^3}` — i.e.
  the class of `p` relative to `s`, the datum that `rho` encodes by Theorem 2 — governs how the
  two deleted stars sit relative to each other. The residuals differ already as graphs, before
  any game theory: the `rho=3` residual is a triangle-free girth-5 graph on 8 vertices with
  degree multiset `{2,2,2,2,3,3,3,3}` (each deleted star touches four distinct residual
  vertices once), nimber `t5 = 1`; the `rho=5` residual is two triangles joined by two
  parallel edges with two pendant vertices, degree multiset `{1,1,3,3,3,3,3,3}` (the deleted
  stars overlap doubly on two residual vertices), nimber `t5 = 0`.
- `K = C3`: only the order-3 rotation subgroup conjugates into `K`, deleting 2 of 20 cosets;
  the 18-vertex residuals have identical degree multisets `{2^2, 3^16}` but are
  non-isomorphic, with `t3 = 1` versus `0`.
- `K = C2`: no pair product has even order, nothing is deleted, and both classes give `t2 = 0`.

The characterization of the interlocking pattern ("stars overlap doubly exactly when `rho=5`")
is read off the verified residual graphs; deriving it by hand from Theorem 2 was not done and
is recorded as a precisely supported observation, not a theorem. The summary equivariance
statement, however, is exact: `(sigma,rho)` measures the mutual conjugacy geometry of the
rotation subgroups (Theorem 2), the free orbit quotients that geometry away entirely, and the
fixed-point-deleted coset orbits re-expose it as the deletion pattern.

## 5. Verification

All computational claims are certified by the adjacent script and its canonical JSON output:

- `notes/2026-07-17-c289-a5-triple-split.py` — generator/checker (pure Python 3 stdlib, exact
  `Fraction`/`Q(sqrt5)` arithmetic, deterministic enumeration, no randomness or timestamps);
- `notes/2026-07-17-c289-a5-triple-split.json` — output (sorted keys);
- `notes/2026-07-17-c289-a5-triple-split.sha256` — checksum manifest.

Regenerate and check from the repo root:

```bash
python3 notes/2026-07-17-c289-a5-triple-split.py > notes/2026-07-17-c289-a5-triple-split.json
(cd notes && sha256sum -c 2026-07-17-c289-a5-triple-split.sha256)
```

The script fails loudly (assert) on any mismatch and prints `ALL CHECKS PASSED` to stderr.
What it certifies, with exact counts:

1. Lemma 1 on all 84 (`S4`) + 455 (`A5`) unordered involution triples.
2. The `(sigma,rho)` census: `S4` 52 = 12+24+4+12, `A5` 380 = 120+60+60+60+60+20, matching
   the C284 table row for row.
3. Theorem 2 on all 120 `sigma=(3,5,5)` generating triples, including the opposite-class
   statement, with sub-counts 30 (`AA`) + 30 (`BB`) for `rho=5` and 60 (`AB`) for `rho=3`.
4. Identity (iii) and `tr(ACB) = -tr(ABC)` on 48 exact rational trace-0 `SL2(Q)` instances.
5. The icosahedral model: `|2I| = 120` from exact icosian generators, 15 axes, the full
   105-pair angle dictionary, and the 30/60/30 configuration table of §3.
6. The orbit structure of §3 (Aut-orbits, inner orbits, stabilizer orders and parities).
7. Cayley walk moments `tr(A^k)`, `k ≤ 16`, for one representative per class; first
   difference at `k=8`; non-isomorphism follows.
8. The pairing searches of §4.1 (exhaustive over the order-120 color group per class) and the
   mirror criterion over all 10 polyhedral classes, cross-checked against the known `t1`
   values.
9. Independent replay of C284: for each of the six `A5 (3,5,5)` rows, the residual coset graph
   is rebuilt from scratch (left cosets, `gK — tgK` edges, pair-product deletion) for 60
   (`K=C5`), 3 (`K=C3`), and 1 (`K=C2`) representative triples per class, checked isomorphic
   to the committed C284 edge lists, and its nimber recomputed with a separate Python
   Sprague-Grundy solver: all six values (`0,1,1` and `0,0,0` for `t2,t3,t5`) agree with C284.

Trusted boundary: the Python solver and graph-isomorphism backtracker are independent of both
C284 Rust solvers but share the Sprague-Grundy recurrence; the 60-vertex regular nimbers are
not recomputed here (they rest on the C260/C284/Appendix-A cross-checked computations, and for
the six mirror classes on Lemma 3); quaternion class tags compare exact values through floats
whose admissible values are separated by more than 0.19 against a 1e-9 tolerance; the
`rho=3` no-pairing statement is exhaustive only over the color-respecting automorphism group.
Nothing here touches the wild case or the full `PSL2/PGL2` escape residual.

## 6. Draft paragraphs for the paper (for C264 §6-adjacent integration; manuscript not edited)

> **The two `(3,5,5)` classes of `A5`.** For involutions `a,b,c` the six ordered products
> `abc,\dots,cba` form two conjugate triples exchanged by inversion, so they share a common
> order `\rho(T)`; this is the invariant that refines the pair-product signature. For
> `\sigma=(3,5,5)` the refinement has a classical meaning. Lifting to the binary icosahedral
> group and writing `x,y,z` for the traces of the lifted pair products, the Fricke relation for
> trace-zero triples, `\operatorname{tr}(ABC)^2 = 4 - x^2-y^2-z^2-xyz`, shows that `\rho=5`
> holds exactly when the two order-5 pair products are conjugate in `A_5` — in which case `abc`
> lies in the opposite order-5 class — and `\rho=3` exactly when they are not. Geometrically,
> the triple is a triple of icosahedral edge-axes with one 60° angle and two angles from
> `\{36°,72°\}`: the isoceles configurations are the `\rho=5` class (two inner orbits of 30
> exchanged by the outer automorphism, equivalently by the Galois twist
> `\sqrt5\mapsto-\sqrt5`), and the scalene configurations are the `\rho=3` class.
>
> **Why only the nonregular templates separate them.** An isoceles triple admits an internal
> symmetry: an involution `w\in A_5\setminus T` with `wTw^{-1}=T`. Left multiplication by such
> a `w` is a free automorphism of the Cayley graph that never maps a vertex into its closed
> neighborhood, and the resulting mirror strategy forces the regular value to be 0. The same
> criterion applies to five further polyhedral classes, turning those computed zeros into
> proofs; the scalene class has only an outer symmetry, and its regular zero remains a
> computed fact. The two regular graphs are nevertheless non-isomorphic — the `\rho=3` graph
> carries six closed 9-walks per vertex from the relators `(abc)^3=e`, the `\rho=5` graph
> none — so the regular *graph* remembers `\rho` while the regular *nimber* collapses it. The
> coset templates cannot collapse it: a nonregular orbit has cyclic stabilizer `K`, its dead
> points are exactly the cosets where a rotation subgroup `\langle ab\rangle` is conjugate
> into `K`, and the relative conjugacy class of the two order-5 rotations — the datum equal to
> `\rho` — determines how the two deleted stars interlock. For `K=C_5` the two residuals
> differ already in their degree sequences, and their nimbers separate: `(t_3,t_5)=(1,1)`
> for the scalene class against `(0,0)` for the isoceles class.

## 7. Proved versus computational — summary

- **Proved (elementary):** Lemma 1 (common order, any group); Theorem 2 (class discriminator
  and opposite-class law, via the trace identity (iii), which is derived in full); the
  axis-angle dictionary and the isoceles/scalene identification (exact icosian computation
  playing the role of a routine case check); the orbit/stabilizer structure of §3
  (exhaustively verified finite statements); Lemma 3 (mirror); Theorem 4 (`t1=0` for the
  `rho=5` class, and for the five other mirror classes); non-isomorphism of the two regular
  Cayley graphs (walk-moment certificate).
- **Computational (independently replayed here, dual-solver in C284):** the values
  `t2,t3,t5 = 0,1,1` (`rho=3`) and `0,0,0` (`rho=5`); the regular zero of the `rho=3` class
  (and of `S4 (2,3,4)`); non-existence of a `rho=3` pairing beyond the color group is open.
- **Supported observation, not derived by hand:** the exact interlocking pattern of the two
  deleted stars in the `K=C5` residuals ("overlap doubly iff isoceles").

The elementary-proof gate for this task is met for deliverables 1 and 2; the one delimited
remainder in deliverable 3 is the `rho=3` regular zero, which no symmetry argument found here
explains and which stays a computed fact.
