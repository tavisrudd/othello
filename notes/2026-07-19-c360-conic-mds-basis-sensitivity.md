# C360: symbolic conic-MDS basis sensitivity

**Date:** 2026-07-19  
**Lane:** `crowns`  
**Verdict:** **THEOREM; ALL-ODD-FIELD SAME-TYPE/SAME-AXIS SRR SEPARATION**

## Result

Let (q\ge 5) be any odd prime power and let

\[
\mathcal O=\{v(t)=(t^2:t:1):t\in\mathbb F_q\}\cup\{v(\infty)=(1:0:0)\}.
\]

For (u\in\mathbb F_q^*\setminus\{1,-1\}), put

\[
 y=\frac{u+u^{-1}}2,
\]

and consider the two ordered raw-object bases

\[
 A=\bigl((0:1:0),(1:y:1),(1:0:-1)\bigr),
\qquad
 B=\bigl((1:0:-1),(1:\tfrac12:0),(1:-\tfrac12:0)\bigr).
\]

Both are projective frames of external points.  Every coordinate of both service-rate regions has
axis intercept (q/2).  Nevertheless

\[
 \left(0,1,\frac{q-1}{2}\right)\in\Lambda(A)
 \quad\text{but}\quad
 \left(0,1,\frac{q-1}{2}\right)\notin\Lambda(B).
\]

Indeed, the full service-rate region of (B), including every minimal size-three recovery set,
has the facet

\[
 \boxed{\lambda_0+2\lambda_1+2\lambda_2\le q.}
\]

The displayed demand violates it by exactly one.  Thus, over every odd field of order at least
five, one fixed maximum-length `[q+1,3]` conic MDS code has two raw-object bases with the same
`EEE` point type and identical axial capacities but different full service-rate regions.  This
clears C360's first exit gate; no field congruence or extension-degree restriction remains.

## Projection-involution invariant

Projection from an off-conic point (P=(x:y:z)) pairs conic parameters by

\[
 \iota_P(t)=\frac{yt-x}{zt-y}.
\]

For the last two targets of (A),

\[
 \iota_{A_1}(t)=\frac{yt-1}{t-y},\qquad \iota_{A_2}(t)=\frac1t.
\]

The first involution exchanges the two fixed points (1,-1) of the second.  Equivalently their
product is the trace-zero involution

\[
 t\longmapsto\frac{y-t}{1-yt}.
\]

For the last two targets of (B),

\[
 \iota_{B_1}(t)=2-t,\qquad \iota_{B_2}(t)=-2-t.
\]

They have the single common fixed point (infty), and their product is the nonidentity unipotent
translation (t\mapsto t+4).  This is the invariant behind the separator: in (A), one target's
recovery pair occupies exactly the two tangent holes of another target's secant matching; in (B),
two targets share a tangent hole, and that common hole supports the separating dual cover.

This use of the product invariant is deliberately local.  The theorem does not claim a full
classification of frame orbits or service regions by involution products.

## Exact primal allocation for (A)

Since

\[
 y^2-1=\left(\frac{u-u^{-1}}2\right)^2\ne0,
\]

the middle point of (A) is external.  It lies on the chord (x=z), which joins (v(1)) and
(v(-1)).  Assign weight one to that recovery pair for target (A_1).  For target (A_2), whose
involution is (t\mapsto1/t), assign weight one to every one of its ((q-1)/2) secant pairs.  Its
two omitted tangent servers are precisely (v(1)) and (v(-1)), so the allocation uses every
server exactly once and realizes

\[
 (\lambda_0,\lambda_1,\lambda_2)=\left(0,1,\frac{q-1}{2}\right).
\]

This is a symbolic rational allocation, not an interpolation from the small-field census.

## Exact dual facet for (B)

Give weight zero to the server (v(\infty)) and weight one to every finite conic server.  Every
minimal recovery set for target (B_0) has at least two servers, so its cover weight is at least
one.  The point (v(\infty)) is tangent for both (B_1) and (B_2); consequently it lies in no
size-two recovery for either target, and every minimal pair or triple for those targets has cover
weight at least two.  The cover has total weight (q), proving

\[
 \lambda_0+2\lambda_1+2\lambda_2\le q
\]

for the full recovery hypergraph.

The inequality is a facet, not merely a valid separator.  The two axis points

\[
 (0,q/2,0),\qquad(0,0,q/2)
\]

are feasible and lie on it.  A third affinely independent equality point is

\[
 \begin{cases}
 (1,1,(q-3)/2),&\operatorname{char}\mathbb F_q=5,\\
 (1/3,1/3,(q-1)/2),&\operatorname{char}\mathbb F_q=3\text{ or }>5.
 \end{cases}
\]

The checker constructs these allocations explicitly.  In characteristic greater than five it
uses the target-0 pair ({0,\infty}) and target-1 pair ({-1,3}), each at weight (1/3); it
reduces the target-2 pairs ({0,-2}) and ({3,-5}) to weight (2/3), and adds the triples
({\infty,-1,-2}) and ({\infty,-1,-5}) at weight (1/3).  The characteristic-three and
characteristic-five collisions are handled by the two formulas encoded in the certificate.  The
axis allocation itself follows from any external target's secant matching: reduce one matching
edge to (1/2), then add at weight (1/2) the two triples formed from its endpoints and both
tangent points.  For the matching upper bound, give weight (1/2) to every non-tangent server and
(1/4) to each tangent server.  Every minimal pair or triple then has cover weight at least one,
while the cover totals (q/2).  This proves exact capacity (q/2) for every external coordinate.

## Exact certificate and replay

The evidence bundle is:

- `notes/2026-07-19-c360-conic-mds-basis-sensitivity.py` — deterministic symbolic checker;
- `notes/2026-07-19-c360-conic-mds-basis-sensitivity.json` — canonical replay certificate;
- `notes/2026-07-19-c360-conic-mds-basis-sensitivity.sha256` — hashes and byte counts.

From `/home/tavis/src/othello/rust`, regenerate with:

```bash
python3 ../notes/2026-07-19-c360-conic-mds-basis-sensitivity.py \
  --output ../notes/2026-07-19-c360-conic-mds-basis-sensitivity.json
```

Check the tracked artifact without modifying the worktree with:

```bash
python3 ../notes/2026-07-19-c360-conic-mds-basis-sensitivity.py --check
```

For (q=5,7,9,11), the checker independently enumerates every minimal recovery set from linear
dependence, validates every primal server load and every dual recovery-set inequality, proves the
three facet equality points affinely independent, and identifies both symbolic frames in C354's
exact conic-stabilizer orbit table.  Their C354 region indices are respectively

| (q) | (A) orbit/region | (B) orbit/region | third facet point |
|---:|:---:|:---:|:---:|
| 5 | `35 / 3` | `30 / 29` | `(1,1,1)` |
| 7 | `72 / 6` | `49 / 52` | `(1/3,1/3,3)` |
| 9 | `96 / 3` | `64 / 78` | `(1/3,1/3,4)` |
| 11 | `168 / 6` | `109 / 187` | `(1/3,1/3,5)` |

The replay also checks that C354's exact region certificate for each (B) orbit contains the
facet with coefficient multiset `{1,2,2}` and bound (q).  The trusted boundary is C354's short
finite-field implementation and conic action, this checker's separate subset-by-subset recovery
enumerator, Python exact `Fraction` arithmetic, and the tracked C354 JSON.  The computation checks
the formulas in the four certified fields; the all-field theorem is the symbolic proof above.

## Literature and novelty boundary

- Alfarano--Kilic--Ravagnani--Soljanin, [*The Service Rate Region
  Polytope*](https://arxiv.org/abs/2303.04021), establishes the allocation-polytope projection and
  rational-allocation framework.  It does not treat conic-basis sensitivity.
- Ly--Soljanin, [*Service Rate Regions of MDS Codes and Fractional Matchings in Quasi-uniform
  Hypergraphs*](https://arxiv.org/abs/2504.17244), develops the fractional-matching model and
  characterizes a class indexed by systematic columns.  The two all-external conic frames here are
  outside that classification.
- Di Giusto--Ravagnani--Soljanin, [*The Oval Strikes
  Back*](https://arxiv.org/abs/2601.16628), proves the all-internal oval simplex and its PIR and
  majority-logic consequences.  It does not compare external bases or give a same-axis separator.
- Hollmann--Xiang, [*Association schemes from the action of `PGL(2,q)` fixing a nonsingular
  conic*](https://arxiv.org/abs/math/0503573), describes pair orbitals of non-tangent lines by
  cross-ratio.  It does not project coloured recovery hypergraphs or determine SRRs.
- Tranchida, [*Triples of involutions in `PGL(2,q)` and their incidence
  geometries*](https://arxiv.org/abs/2411.10299), relates off-conic triangles, involution-generated
  subgroups, self-polarity, tangent triangles, and hypertopes.  It has no service-polytope or
  fractional-allocation theorem.

The primal and dual formulas are elementary exact LP certificates, so no novelty is claimed for
parametric linear programming or fractional-cover duality themselves.  A targeted title,
identifier, primary-reference, and forward search through 2026-07-19 found no paper proving
same-type/same-axis basis sensitivity for one conic MDS code, or this all-odd-field facet family.
The closest later SRR result found outside the conic line concerns binary Hamming codes and does
not intersect the theorem.  This is a focused search boundary, not a MathSciNet/zbMATH absence
claim.

The cached load-bearing texts and SHA-256 values are `arXiv:2303.04021`
`ffc9a8edbd513ad70b3336b27dd5fc475e4b4dad4665c10aed7c2794becffce4`,
`arXiv:2504.17244` `3943e2b5ba2a1bc0a84b5c62bc7f5f7d1c6d3551fbff4b91f4fd1b8290eb2700`,
`arXiv:2601.16628` `ab80a873ecf39ca7c130252d78eb07f2e2aa8b966f465e7f44dbdb3c9bf6871b`,
`arXiv:math/0503573` `c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b`,
and `arXiv:2411.10299` `3cf7c453735ab0c6be28e074a4be85d4a3ae4e03d0fc408e7e7d77966aa62656`.

## Scope

This theorem proves an infinite full-SRR separation, not a spectrum count.  It does not classify
all `EEE` frames, claim that projection-involution products determine an SRR, address integral
schedules or failures, or upgrade C354's finite counts to formulas.  Those remain separate tasks.
