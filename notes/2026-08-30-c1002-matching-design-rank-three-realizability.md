# C1002 — rank-three realizability of maximum-matching designs

**Lane**: `relconic`

**Status:** Reported 2026-08-30; no manuscript edits.  The odd-characteristic
part of the ten-point classification now has a three-block geometric
certificate, and a field-uniform six-local obstruction has been isolated.

## Goal

Classify, or obtain field-uniform obstructions to, rank-three projective representations of the simple maximum-matching designs forced by zero defect. Keep abstract design existence, projective representability, and realization by concurrent secants of an arc logically separate.

## Acceptance gate

- Freeze the exact incidence structure, representation notion, equivalence, degeneracies, and characteristic hypotheses.
- Reconcile the six-point classification, even-`k` field trichotomy, characteristic-two exclusion, and C659 bridge.
- Produce constructions for survivors and proof or reproducible certificates for exclusions.
- State exactly which zero-defect arc consequences follow and which geometric compatibility conditions remain.

## Publication successor

C1003 owns the later integration-versus-spinoff decision.

## 1. Frozen conventions

Write \(m=\lfloor k/2\rfloor\).  A simple
\(\operatorname{MATCH}(k,m,1)\) design is a collection \(\mathcal D\) of
maximum matchings of \(K_k\) in which every pair of disjoint edges occurs in
exactly one block.  A rank-three realization over a field \(K\) is an
injective assignment \(i\mapsto p_i\in\operatorname{PG}(2,K)\) whose image is
a \(k\)-arc and for which the chord lines indexed by each block of
\(\mathcal D\) are concurrent.  This is exactly Definition 8.1 of the arcs
paper; no weaker matroid representation notion is intended.

For a six-set \(S\subseteq[k]\), let \(c_{\mathcal D}(S)\) be the number of
blocks containing three edges with all six endpoints in \(S\).  Equivalently,
it is the number of perfect matchings of \(K_S\) extended by design blocks.
If a realization exists, it is the triple-chord concurrence count of the
six-subarc on \(S\).

## 2. Universal odd-characteristic local obstruction

**Six-local admissibility theorem.**  If \(\mathcal D\) has a rank-three
realization over a field of odd characteristic, then for every six-set \(S\):

1. identify the fifteen perfect matchings of \(K_S\) with the pairs of its
   six one-factorizations;
2. make such a pair adjacent exactly when that perfect matching extends to a
   block of \(\mathcal D\).

The resulting graph must be a disjoint union of cliques and at least one
clique must have odd order.  In particular,

\[
c_{\mathcal D}(S)\in\{0,1,2,3,4,6,10\}.
\]

This is an immediate application of the concurrence-spectrum proposition in
Paper I to every six-subarc.  It is a purely combinatorial, relabelling-
invariant prefilter for odd-characteristic realizability: a single bad
six-set is a nonrealizability certificate.

The easiest shadow is the **edge-local diagonal bound**.  Fix distinct
\(u,v,a,b,c,d\).  Of the three perfect matchings on these six vertices that
contain \(uv\), at most two may extend to design blocks.  Otherwise all three
diagonal points of the complete quadrangle \(a,b,c,d\) lie on the chord
\(p_up_v\), whereas their determinant is nonzero in odd characteristic.

There is also a useful global checksum.  Double-counting a block together
with three of its edges gives

\[
 \frac{1}{\binom{k}{6}}\sum_{|S|=6}c_{\mathcal D}(S)
 =\frac{30(m-2)}{(k-4)(k-5)}
 =\begin{cases}
 15/(k-5),&k\text{ even},\\
 15/(k-4),&k\text{ odd}.
 \end{cases}
\]

This average does not itself prove nonexistence, but it couples the local
spectrum to the abstract design parameters and gives a cheap consistency
test for any proposed family.

## 3. Ten points: a human-checkable odd-characteristic exclusion

For \(k=10\), every six-set has \(c_{\mathcal D}(S)=3\): its four-point
complement has three perfect matchings; the two edges of each determine a
unique design block, whose remaining three edges form a perfect matching of
\(S\).  In odd characteristic the concurrence graph must therefore have
partition \(3+1+1+1\); the alternative \(2+2+2\) is forbidden.

Mathon's external theorem gives exactly two abstract
\(\operatorname{MATCH}(10,5,1)\) classes.  In the representatives already
frozen in the arcs-paper certificate, **both** contain

\[
\begin{aligned}
&09\mid12\mid34\mid57\mid68,\\
&09\mid13\mid24\mid58\mid67,\\
&09\mid14\mid23\mid56\mid78.
\end{aligned}
\]

On \(S=\{0,1,2,3,4,9\}\), these are the three perfect matchings through edge
\(09\).  Thus all three diagonal points of quadrangle \(1,2,3,4\) would lie
on chord \(09\), contradicting the odd-characteristic diagonal theorem.
Equivalently, the six-factorization concurrence graph is \(3K_2\), not the
required \(K_3\sqcup3K_1\).

Consequently neither of the two abstract ten-point designs is realizable in
odd characteristic.  This replaces the odd-characteristic saturated-ideal
calculation in the existing proof by a three-block argument.  It does **not**
replace the characteristic-two elimination: that calculation still proves
that the nonhyperoval class is never realizable and that the regular-hyperoval
class is realizable exactly over fields containing \(\mathbf F_8\).

## 4. Current classification boundary

The arcs paper already contains more of the proposed programme than the old
idea recorded:

- \(k=6\): realizable exactly in characteristic two over fields containing
  \(\mathbf F_4\), with an explicit projective class;
- \(k=7,8,12\): the relevant abstract matching designs do not exist (the
  \(k=8,12\) statements are Alspach--Heinrich's maximum-matching
  nonexistence results);
- \(k=10\): exactly the regular-hyperoval class survives, in characteristic
  two over fields containing \(\mathbf F_8\);
- characteristic two supplies the geometric oval/hyperoval families at the
  corresponding powers of two.

What remains genuinely open is not the first small cases but a general
representability theorem beyond them.  The strongest presently justified
field-uniform filter is the six-local admissibility theorem above.  A next
math step is to combine it with design intersection numbers, seeking either
an infinite odd-characteristic nonrealizability theorem or an abstract
characterization of the characteristic-two hyperoval designs.

### Relation to the conic equality spectra

The rank-three realization question and the conic equality trichotomies are
not equivalent.  The former asks whether an abstract matching design can be
represented by concurrent secants of an arc over \(K\).  The latter adds a
prescribed nonsingular conic, completeness outside it, and zero defect.  Those
extra hypotheses force
\[
\begin{array}{ll}
k\ {\rm even}:&
q\in\{k-2,\binom{k-1}{2},\binom{k-1}{2}+1\},\\
k\ {\rm odd}:&
q\in\{k-1,\binom{k-1}{2}-1,\binom{k-1}{2}\}.
\end{array}
\]
In characteristic two the paper already closes the geometric equality
branches: odd \(k\) gives an oval of size \(q+1\) whose nucleus lies on the
prescribed conic, and even \(k\) gives a hyperoval of size \(q+2\).  These are
constructions of the associated rank-three matching designs, but they do not
classify arbitrary abstract designs at the same \(k\).

Conversely, every zero-defect pair supplies a rank-three realization.
Therefore the six-local obstruction is a necessary combinatorial gate before
the conic arithmetic is used.  At \(k=10\), Mathon's two-class completeness
and the displayed bad six-set exclude the order-\(37\) candidate in odd
characteristic by a human local proof; the regular hyperoval over
\(\mathbf F_8\) supplies the surviving equality construction.

### C659 boundary

C659 was queued as a projectivization/dual-Chow bridge for C658's
square-root carrier inequality.  It has no delivered task report and is not a
premise of the matching-design theorem or the six-local obstruction.  Its
planned output concerns coordinate charts, square restrictions, and a
nonsquare ambient Chow form; that could eventually add a different
rank-three obstruction, but it should not be cited as already banked
realizability machinery.  C1002 therefore leaves C659 separate and open.

## 5. Evidence and trust boundary

No new exhaustive computation underlies the local proof.  The only finite
input is the displayed membership of three blocks in each of the two tracked
representatives.  It is directly checkable with:

```sh
cd /home/tavis/src/othello
python - <<'PY'
import json
p = 'papers/arcs_complete_outside_conic/check_match10_rank_three.json'
targets = [
 [[0,9],[1,2],[3,4],[5,7],[6,8]],
 [[0,9],[1,3],[2,4],[5,8],[6,7]],
 [[0,9],[1,4],[2,3],[5,6],[7,8]],
]
for c in json.load(open(p))['classes']:
    print(c['name'], [b in c['matching_design'] for b in targets])
PY
```

The output is `True` three times for each class.  The load-bearing tracked
files are:

| file | bytes | SHA-256 |
|---|---:|---|
| `check_match10_rank_three.py` | 23229 | `700ab7ba7a7606249448d8e6569f4638bee3c4b1354da80334cff49cd3613ed5` |
| `check_match10_rank_three.json` | 79326 | `c2c3619a1c074bd28a9e0b967a4ac1762496589ede0cc636431f484d67fba357` |
| `check_match10_rank_three.sha256` | 190 | `4ddd207699856fd349a4c36c8c65138e87ba662d05978c4eb22f6608c43e91e8` |

The geometric contradiction is independent of the generator and Singular.
Completeness of the two abstract classes remains Mathon's external theorem;
the tracked enumeration reconstructs representatives but is not used to
prove that there are only two.

## 6. Frozen deliverables and successor work

1. **Delivered:** a theorem packet separating abstract design existence,
   six-local admissibility, and projective realization.
2. **Delivered:** a compact bad-six-set certificate: six vertices together
   with the extending design blocks; the \(k=10\) certificate uses only the
   three displayed blocks.
3. **Draft integration language:** replace only the
   odd-characteristic \(k=10\) elimination paragraph by the three-block
   diagonal proof, leaving the characteristic-two certificate and trust
   statement intact.
4. **Geometric transfer:** every zero-defect arc inherits all six-local
   constraints; the conic trichotomies and oval/hyperoval conclusions remain
   separate downstream filters.
5. **C1003 decision:** the present result is a strong appendix simplification
   and reusable design filter, not yet a standalone paper.  A standalone
   finite-geometry/design paper requires an infinite-family obstruction or a
   broader representability classification.

### Manuscript-ready draft language (not integrated)

> **Odd-characteristic exclusion at ten points.**  Mathon's theorem leaves
> two simple \(\operatorname{MATCH}(10,5,1)\) designs.  In the fixed
> representatives both contain
> \(09|12|34|57|68\), \(09|13|24|58|67\), and
> \(09|14|23|56|78\).  In a projective realization, restriction to the
> six-set \(\{0,1,2,3,4,9\}\) would put the three diagonal points of the
> complete quadrangle on \(1,2,3,4\) on the chord \(09\).  Those diagonal
> points are noncollinear in odd characteristic.  Hence neither abstract
> class is realizable there.
