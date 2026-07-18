# C294 Crown I silver attack: the minimal three-centre gate

**Date:** 2026-07-17
**Lane:** `crowns`
**Status:** odd-subfield descent proved up to one explicit `PGL2` Cayley scar; silver remains open.

## Target and minimal size

Crown I silver asks for a tame P/N classification of every legal configuration of one fixed size,
including the proper, subfield, and full `PSL2/PGL2` cases. Three off-conic centres are the minimal
honest battlefield: two involutions generate only a cyclic/dihedral subgroup, while three can
already generate a full linear group.

For a legal triple `S`, let `R_S` be its fixed/dead-vertex-deleted conic Schreier graph. It has
maximum degree three. Define two noncircular P-certificates:

1. a **pairing reply** leaves a residual with a fixed-point-free nonadjacent involutory
   automorphism; and
2. a **degree-two reply** leaves a disjoint union of paths and cycles whose exact Dawson
   Node--Kayles nimbers xor to zero.

If every first move has a reply of the stated type, ordinary Node--Kayles semantics proves
`G(R_S)=0`; no root value is used in the certificate test.

## Exact bounded gate

Every legal off-conic triple was checked at `q=5,7,11`.

| q | legal triples | P triples | two-ply pairing | degree-two reply | union | P outside union |
|---:|---:|---:|---:|---:|---:|---:|
| 5 | 1,980 | 625 | 625 | 625 | 625 | 0 |
| 7 | 16,408 | 6,258 | 6,258 | 6,258 | 6,258 | 0 |
| 11 | 265,980 | 109,175 | 31,625 | 106,535 | 107,855 | 1,320 |

All certificate false-positive counts are zero. The path/cycle evaluator is independently
cross-checked against direct recursion at every graph size through 12 vertices.

### The exact q=11 boundary

The 2,640 P triples not certified by a degree-two reply are exactly three `PGL2(11)` conjugacy
orbits, and every representative generates the full group of order 1,320:

| orbit size | pair-product orders | residual | root pairing | role |
|---:|---|---|---|---|
| 660 | `(2,12,12)` | connected, 12 vertices, triangle-free | yes | pairing exception |
| 660 | `(6,12,12)` | connected, 12 vertices, triangle-free | yes | pairing exception |
| 1,320 | `(2,3,11)` | connected, 11 vertices, 14 edges, 2 triangles | no | sole union exception |

The last graph has degree sequence `(1,2,2,2,3,3,3,3,3,3,3)`. Thus q=11 admits a crisp finite
base theorem: degree-two response, two pairing orbits, and one named full-group `(2,3,11)` graph
requiring a bounded direct strategy certificate.

## Why the first response law is not the uniform silver mechanism

There is a simple size obstruction. If `G` is subcubic and
`G-N[v]-N[w]` has maximum degree at most two, every degree-three vertex of `G` lies in the union
of the radius-two balls about `v` and `w`. Each such ball has at most `1+3+6=10` vertices, so `G`
has at most 20 degree-three vertices.

Consequently a one-reply degree-two collapse cannot handle the large nearly cubic full-group
residuals. The q=5--11 success is a strong base layer, not an asymptotic classification theorem.
The q=11 exceptional orbit likewise does not justify a finite-template extrapolation.

## Odd-subfield descent theorem

Let `q=q0^n` with `q0` odd and `n>1` odd. After conjugating to the standard subfield copy, let a
legal triple of projection involutions `S={s1,s2,s3}` generate
`H=PGL2(q0)` or `H=PSL2(q0)`. Write `R_q(S)` for its conic residual and `Cay(H,S)` for the
three-colour Cayley graph on `H`. Put

\[
m=\frac{q-q_0}{|\operatorname{PGL}_2(q_0)|}
 =\frac{q_0^{n-1}-1}{q_0^2-1}
 =1+q_0^2+\cdots+q_0^{n-3}.
\]

Then there are coloured-graph decompositions

\[
R_q(S)\cong
\begin{cases}
R_{q_0}(S)\sqcup m\,\operatorname{Cay}(H,S),&H=\operatorname{PGL}_2(q_0),\\
R_{q_0}(S)\sqcup 2m\,\operatorname{Cay}(H,S),&H=\operatorname{PSL}_2(q_0).
\end{cases}
\]

Therefore Sprague--Grundy addition gives

\[
\mathcal G(R_q(S))=
\begin{cases}
\mathcal G(R_{q_0}(S))\mathbin\oplus
 (m\bmod2)\,\mathcal G(\operatorname{Cay}(H,S)),&H=\operatorname{PGL}_2(q_0),\\
\mathcal G(R_{q_0}(S)),&H=\operatorname{PSL}_2(q_0).
\end{cases}
\]

Indeed, a nonidentity fractional-linear transformation over `F_q0` has fixed points of degree at
most two over `F_q0`. Since `n` is odd, the intersection of `F_q` with `F_(q0^2)` is `F_q0`;
hence `H` acts freely on every point outside the base subline.
The dead points are the fixed points of the pair products `sj si`: a conic point lies on the
secant through the corresponding two centres exactly when that product fixes it. They too lie on
the base subline. Thus the base subline contributes `R_q0(S)`, every other `H`-orbit contributes
one regular Cayley component, and orbit counting gives `m` components for `PGL2` and `2m` for
`PSL2`.

Because `q0` is odd, `m` has the parity of `(n-1)/2`. Subfield `PSL2` therefore descends exactly
for every odd `n`, and subfield `PGL2` descends exactly for `n=1 (mod 4)`. The sole remaining
`PGL2` subfield obstruction for `n=3 (mod 4)` is the explicit nimber of one regular
`Cay(PGL2(q0),S)` component. This is a genuine recursive scar, not an unstructured extension-field
remainder.

## Silver attack

The remaining proof should be split by Dickson type, with no cross-stratum handwaving:

1. **Proper groups:** import the proved cyclic/dihedral/polyhedral orbit-template values and consume
   the direct-strategy layer when C199 delivers it.
2. **Subfield groups:** the odd-extension theorem above gives exact descent for `PSL2` and for
   `PGL2` when the extension degree is `1 mod 4`. Classify or recursively peel the single regular
   `PGL2(q0)` Cayley scar left when the degree is `3 mod 4`.
3. **Full groups:** choose one generator pair and decompose the graph into its alternating
   dihedral orbits. The third involution is then a correlated matching between those path/cycle
   backbones. The needed new theorem is a recursive scar/transfer rule that preserves P/N while
   peeling these backbones; immediate pairing and immediate degree degradation are only its base
   cases.
4. **Finite exceptions:** discharge bounded trace/order classes such as the q=11 `(2,3,11)` orbit
   by compact direct certificates, never by folding them into the uniform rule rhetorically.

The natural algebraic coordinates are the three pair-product traces/orders plus the full
trace/definition field. A successful quotient must preserve legal replies and P/N, not merely
spectra, coherent-configuration data, or conjugacy.

## Relation to the strengthened bronze family

The companion C294 theorem now gives a `Theta(q)` mirror-certified full-`PGL2(q)` four-centre
family over every odd extension of each eligible prime field: `(p-5)/2` parameters in degree one
and exactly half the full-degree elements in higher odd degree. Its projective-trace criterion
closes subfield exclusion for that family. The theorem above supplies the arbitrary-triple
odd-subfield decomposition, but the `PGL2` Cayley scar and the full-group recursion remain, so the
family still does not classify every configuration at a fixed size.

## Evidence and replay

From `/home/tavis/src/othello`:

```sh
python3 notes/2026-07-17-c294-silver-three-centre-gate.py 5 7 11 \
  --check notes/2026-07-17-c294-silver-three-centre-gate.json
sha256sum -c notes/2026-07-17-c294-silver-three-centre-gate.sha256
```

The checker uses the independent coordinate construction in `three_centre_probe.py`, exact direct
Grundy recursion for root classification, exact abstract-automorphism backtracking for pairing,
the path/cycle recurrence for structural certificates, and exhaustive `PGL2(q)` conjugation for
the exception-orbit audit. The computation certifies only q=5,7,11. It does not prove that the
listed certificate hierarchy remains dense, bounded-depth, or complete for larger fields.

| Load-bearing artifact | Bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-17-c294-silver-three-centre-gate.py` | 11,583 | `4b85a4f7a688a3d6c98b8a4cc241d9651ee3e2ce77674000978db694a37d3549` |
| `notes/2026-07-17-c294-silver-three-centre-gate.json` | 5,737 | `a46470e0ad869275b507e2ff5358bbdaa3c103958d5347e8e72d6eb717a83827` |
