# C333: an all-odd-field mirror-locus P-family

**Date:** 2026-07-19  
**Lane:** `crowns`  
**Status:** theorem; uniform all-odd-field family with explicit character tests and count

## Result

Let `q=p^e>3` be odd.  Use

\[
P_\infty=(1,0,0),\qquad P_0=(0,1,0),\qquad
P_t=(t,t^{-1},1)
\]

on the conic `XY=Z^2`.  Choose `delta in F_q` with

\[
\chi(\delta)=-1,\qquad \chi(\delta-4)=1,
\]

and put `tau(t)=delta/t`.  There are exactly

\[
|D_q|=\frac{q-\chi(-1)}4
\]

such `delta`, so a choice exists in every odd field.  For `b in F_q`, define

\[
S_{\delta,b}=\{(0,1,1),(\delta,0,1),(1,b,1),
                 (\delta b,\delta^{-1},1)\}.
\]

The following tests are sufficient and require only field arithmetic and quadratic characters:

1. `F_p(b)=F_q`;
2. `b` is not `0`, `1`, or `delta^(-1)`;
3. `1+delta(b-1)` and `1-delta+delta^2 b(1-b)` are nonzero;
4. `chi((1+delta b)^2-4delta)=-1`; and
5. if `chi(-1)=1`, then `chi(b-1)=-1`.

For every passing pair, `{P_infinity,P_0} union S_(delta,b)` is a six-arc, the four projection
involutions generate `PGL_2(q)`, and the fixed-point-deleted conic residual has a fixed-point-free,
nonadjacent `tau` pairing.  Consequently it is a Node--Kayles P-position and has Sprague--Grundy
value zero.

This removes all congruence restrictions from C294's frozen `S_b` family.  The restrictions
`p mod 40` and odd extension degree were artifacts of fixing `delta=-1` and forcing both `-1` and
`5` to be nonsquares.  They are not obstructions to a mirror-stable full-`PGL_2` P-family.

## Size and the explicit all-field threshold

Fix any `delta in D_q`.  The polynomial

\[
f_\delta(b)=(1+\delta b)^2-4\delta
\]

has nonsquare discriminant `16 delta^3`, hence no root in `F_q`, and

\[
\sum_b\chi(f_\delta(b))=-1.
\]

If `chi(-1)=-1`, exactly `(q+1)/2` parameters pass the mirror test before the six displayed
algebraic/full-degree exclusions.  If `chi(-1)=1`, the outer-sheet condition adds
`chi(b-1)=-1`; its raw count is

\[
N_\delta=\frac{q+1+S_\delta}{4},\qquad
S_\delta=\sum_b\chi((b-1)f_\delta(b)),\qquad |S_\delta|\le 2\sqrt q.
\]

The last inequality is the quadratic-character Weil bound for a square-free cubic.  If `E_q`
denotes the number of elements in proper subfields, the number of passing `b` is therefore at least

\[
\frac{q+1}{2}-6-E_q
\]

when `chi(-1)=-1`, and at least

\[
\frac{q+1-2\sqrt q}{4}-6-E_q
\]

when `chi(-1)=1`.  The union of maximal proper subfields gives

\[
E_q\le e\sqrt q\le \sqrt q\log_3 q.
\]

Thus every odd `q >= 3^12=531441` has a passing parameter, uniformly in the characteristic.
More precisely, for each fixed suitable mirror the family has size
`q/2+O(sqrt(q) log q)` on the nonsquare `-1` sheet and
`q/4+O(sqrt(q) log q)` on the square `-1` sheet.  The finite replay already finds passing full-group
examples in `q=5,7,9,11,13,17,25,27,49`; the theorem does not claim that this list closes every
smaller field.

The parametrization is injective as a family of normalized centre sets: `(delta,0,1)` is the unique
centre with column zero and `(1,b,1)` is the unique centre with row one, under the displayed
exclusions.  Hence the parameter counts are counts of distinct normalized sets, not only marked
formula instances.

## Geometry of the normalized mirror locus

After fixing the burned orbit `{P_infinity,P_0}` and one canonical fixed-point-free mirror
`tau(t)=delta/t`, an ordered pair of centre-orbit representatives `(r,c)` and `(s,d)` gives

\[
\{(r,c),(\delta c,r/\delta),(s,d),(\delta d,s/\delta)\}.
\]

The distinctness, off-conic, and six-arc requirements remove finitely many hypersurfaces from
`A^4`.  The resulting ordered normalized mirror locus is therefore an irreducible four-dimensional
open set whenever nonempty.  Passing to unordered orbits and unlabelled representatives is a
finite quotient by a subgroup of `C_2 wr S_2`; it remains irreducible and four-dimensional.  The
determinant sheets and mirror-nonadjacency signs split its finite-field points arithmetically, not
its geometric irreducible components.

The displayed `S_(delta,b)` construction is an explicit irreducible one-dimensional slice after
`delta` is fixed.  It is deliberately smaller than the full four-dimensional locus: its role is to
give a uniform theorem and a construction interface, not to claim a complete orbit classification
of every legal mirror-stable four-centre set.

## Proof

For an affine centre `(r,c,1)`, projection through the centre induces

\[
\sigma_{r,c}(t)=\frac{t-r}{ct-1},\qquad
A_{r,c}=\begin{pmatrix}1&-r\\c&-1\end{pmatrix}.
\]

Conjugation by `tau` sends `(r,c)` to `(delta c,r/delta)`, so it swaps the first two and last two
centres.  Rows and columns are pairwise distinct under test 2.  The two independent determinants
of triples of affine centres, up to the harmless factor `delta`, are

\[
1+\delta(b-1),\qquad 1-\delta+\delta^2b(1-b).
\]

Together with `b != 1`, these and the row/column tests check all twenty triples in the six-set.

Let the generators in displayed centre order be `A_0,...,A_3`.  Direct multiplication gives a
projectively nontrivial unipotent

\[
W=A_2A_0A_2A_0A_1A_0,
\]

whose trace is `2b-2`, determinant is `(b-1)^2`, and whose scalar exceptional equation is exactly
`1+delta(b-1)=0`.  The fixed-point sets of `A_0` and `A_1` are `{0,2}` and
`{infinity,delta/2}`, so the generated group has no global fixed point.  It also contains `W`, an
element of order `p`.  Finally

\[
\kappa(A_2A_0)=\frac{\operatorname{tr}(A_2A_0)^2}{\det(A_2A_0)}=\frac1{1-b}.
\]

At least one generator is outside `PSL_2(q)`: `det(A_0)=-1` suffices when `chi(-1)=-1`, while
`det(A_2)=b-1` suffices under test 5.  The maximal-subgroup list for `PGL_2(q)` outside
`PSL_2(q)` now closes the generation proof.  The disjoint fixed-point test excludes a Borel; the
`p`-element excludes both torus normalizers and the prime-field `S_4` exception; and a proper
subfield `PGL_2(q_0)` would force every projective trace invariant, including `1/(1-b)`, into
`F_(q_0)`, contrary to `F_p(b)=F_q`.  Thus the generated group is all of `PGL_2(q)`.

The equality `tau(t)=sigma_(r,c)(t)` has discriminant

\[
(r+\delta c)^2-4\delta.
\]

For the first centre orbit this is `delta(delta-4)`, a nonsquare by the choice of `delta`; for the
second it is `f_delta(b)`, a nonsquare by test 4.  Thus no live vertex is adjacent to its mirror.
The centre set and its secant-deleted conic set are `tau`-stable.  After a move at `v`, the response
at `tau(v)` is legal, and deleting both closed neighborhoods restores the invariant.  Induction
gives a second-player win and Grundy value zero.

## Applied construction interface

No group enumeration is needed:

1. find any nonsquare `delta` for which `delta-4` is square;
2. scan `b` through the five explicit tests;
3. emit the four centres above; and
4. use `tau(t)=delta/t` as the pairing/repair-scheduling certificate.

The tests are constant-size field arithmetic apart from the standard full-degree test.  They export
the four projection matchings, their mirror pairing, the exact exceptional locus, and a full-group
certificate suitable for the C334 repair/service consumer.

## Novelty and trusted boundary

Tranchida's 2025 paper supplies the classical off-conic-point/projective-involution dictionary,
quotes the needed `PGL_2(q)` maximal-subgroup list, and proves existence of suitable full-group
generating triples.  C333 does not claim any of those facts.  Its bounded new core is the explicit
four-centre `tau`-stable locus, the two quadratic-character nonadjacency conditions, the all-odd-q
count, and the resulting uniform mirror P-strategy.  A paper-facing priority claim still requires a
database and forward-citation closure.

A targeted current search on 2026-07-19 used the exact Tranchida title and the combinations
`four involutions`, `four-centre`, `tau-stable`, `PGL(2,q)`, conic, and finite field.  It recovered
Tranchida's updated/published triple work and the adjacent 2026 commuting-involution-graph paper,
whose object is the pairwise commuting graph on a conjugacy class in `PSL_2(q)`, not a
four-centre conic residual or mirror P-strategy.  It found no direct overlap with the bounded C333
core.  Search-result absence is not proof of priority: MathSciNet/zbMATH coverage and a systematic
forward-citation closure remain explicitly open before any unqualified first/novel claim.

The proof trusts finite-field character sums, the Weil bound, the maximal-subgroup classification,
and the standard mirror induction.  The checker does not prove those general results.  It verifies
the coordinate identities and finite instances independently and exhaustively.

Literature artifacts read for the boundary:

- Philippe Tranchida, *Triples of involutions in PGL(2,q) and their incidence geometries*,
  arXiv:2411.10299, cached PDF SHA-256
  `3cf7c453735ab0c6be28e074a4be85d4a3ae4e03d0fc408e7e7d77966aa62656`.
- Michael Giudici, *Maximal subgroups of almost simple groups with socle PSL(2,q)*,
  arXiv:math/0703685, cached PDF SHA-256
  `2c829b573dadf9ee2c71a9f85f92e1fb2d7443f64242dbe4a829c6246d9ae8e9`.

## Evidence and replay

From `/home/tavis/src/othello` run:

```sh
python3 notes/2026-07-18-c333-all-odd-q-mirror-locus.py --check
sha256sum -c notes/2026-07-18-c333-all-odd-q-mirror-locus.sha256
```

The standard-library checker deterministically exhausts all `(delta,b)` in the nine fields
`F_5`, `F_7`, `F_9`, `F_11`, `F_13`, `F_17`, `F_25`, `F_27`, and `F_49`.  It checks the exact
`delta` count, injectivity of the normalized parametrization, all twenty six-arc determinants,
mirror conjugation, deleted-set invariance, mirror nonadjacency, the unipotent word, and the
full-degree trace invariant.  For one canonical member of every field it independently enumerates
the generated projective matrix group, reaching `q(q^2-1)` in all nine cases.  There is no random
seed.  The JSON is canonical, sorted, timestamp-free, and schema-tagged.

| Load-bearing artifact | Bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-18-c333-all-odd-q-mirror-locus.py` | 14,070 | `4c94ebba61c1dd1b5fd0e5235e18ac6493d3cfffe529716ffe6d1866378ae4e5` |
| `notes/2026-07-18-c333-all-odd-q-mirror-locus.json` | 6,831 | `16465bc2910ace13939eddd1108b1e15fb86d3841c4fe6842d22b6109e681aa8` |
