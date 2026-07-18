# C294: an odd-extension full-`PGL₂` conic-continuation P-family

**Date:** 2026-07-17
**Lane:** `crowns`
**Status:** bronze strengthened to a `Theta(q)` odd-prime-power family; silver classification
remains open.

## Result

Let `q=p^e`, where `p>5` is prime, `e` is odd, and

\[
p\equiv 3\text{ or }27\pmod {40}.
\]

Use the conic (XY=Z^2), parametrized by

\[
P_\infty=(1,0,0),\qquad P_0=(0,1,0),\qquad
P_t=(t,t^{-1},1),
\]

For every `b in F_q` such that

\[
b\notin\{0,1,-1,2\},\qquad (b-1)^2+4\text{ is a nonsquare},
\qquad \mathbf F_p(b)=\mathbf F_q,
\]

take the four off-conic centres

\[
S_b=\{(0,1,1),\;(-1,0,1),\;(1,b,1),\;(-b,-1,1)\}.
\]

Then (\{P_\infty,P_0\}\cup S_b) is a six-arc, the projection involutions
(T_b=\{\sigma_x:x\in S_b\}) generate (PGL_2(q)), and the fixed-point-deleted
Schreier residual (R_{S_b}) is a P-position for Node Kayles. Equivalently,

\[
\mathcal G(R_{S_b})=0.
\]

For `e=1` there are exactly `(p-5)/2` admissible parameters. For `e>1` there are exactly

\[
\frac12\sum_{d\mid e}\mu(e/d)p^d
\]

admissible parameters: precisely half of the elements of degree `e` over `F_p`. Thus this is a
one-dimensional `Theta(q)` P-family across infinitely many genuine full-group residuals after the
fourth off-conic centre. The old bronze configuration is the prime-field member `b=3`.

This theorem concerns the **conic-only residual** after the four centres have been selected. It
does not prove that an earlier game state can force entry into this family, nor does it transfer an
off-conic P child to the on-conic child required by the outer odd-plane argument.

## Proof

### Coordinates and legality

For an affine off-conic centre (x=(r,c,1)), projection through (x) induces

\[
\sigma_{r,c}(t)=\frac{t-r}{ct-1},\qquad
A_{r,c}=\begin{pmatrix}1&-r\\c&-1\end{pmatrix}.
\]

The four products (rc) are (0,0,b,b), so the centres are off the conic when (b ne 1). Their row
and column coordinates are pairwise distinct when (b notin \{0,1,-1\}). The determinants of the
four triples of affine centres are

\[
2-b,\quad 2-b,\quad (b-2)(b+1),\quad (b-2)(b+1).
\]

Together with the distinct-row/distinct-column conditions, the displayed exclusions check all
twenty triples among (P_\infty,P_0) and the four centres.

### The generated group is full `PGL₂(q)`

Write the generators in the displayed order as (A_0,A_1,A_2,A_3). Direct multiplication gives

\[
A_2A_0A_2A_0A_1A_0=
\begin{pmatrix}2b-3&2-b\\b-2&1\end{pmatrix}.
\]

This matrix has trace (2b-2), determinant ((b-1)^2), zero discriminant, and is nonscalar exactly
when (b ne 2). Thus it is a nontrivial unipotent of projective order `p`. The fixed-point sets of
(A_0) and (A_1)
are respectively ({0,2}) and ({\infty,-1/2}); they are disjoint for (p>5). Thus the
generated group has no global fixed point and is not contained in a Borel subgroup.

The determinant of `A_0` is `-1`, a nonsquare in `F_q` because `p = 3 (mod 4)` and `e` is odd.
Hence the generated group `H` is not contained in `PSL_2(q)`. To exclude the remaining
proper-subfield case, use the scalar- and conjugacy-invariant projective trace

\[
\kappa(g)=\frac{\operatorname{tr}(g)^2}{\det(g)}.
\]

Direct multiplication gives

\[
A_2A_0=\begin{pmatrix}0&1\\b-1&1\end{pmatrix},\qquad
\kappa(A_2A_0)=\frac1{1-b}.
\]

Suppose that `H` were proper. Any maximal proper overgroup of `H` also omits `PSL_2(q)`, since
`PSL_2(q)` has index two and `H` already contains `A_0` outside it. By Giudici's
maximal-subgroup form of Dickson's classification, such an overgroup is a Borel, a split or
nonsplit torus normalizer, an `S_4` prime-field exception, or a conjugate of `PGL_2(q_0)` with
`q=q_0^r` for an odd prime `r`. The common-fixed-point test excludes the Borel. The nontrivial
`p`-element excludes the torus normalizers and `S_4`, since `p>5`. In the subfield case every
projective trace invariant belongs to `F_{q_0}`; hence `1/(1-b)` and therefore `b` belong to
`F_{q_0}`, contradicting `F_p(b)=F_q`. No proper maximal overgroup remains, so `H=PGL_2(q)`.

### A value-preserving mirror certificate

Let

\[
\tau(t)=-1/t.
\]

Because (-1) is nonsquare, (\tau) is fixed-point-free on (\mathbf P^1(q)). Conjugation by
(\tau) sends the centre coordinates

\[
(r,c)\longmapsto(-c,-r),
\]

so it swaps (A_0\leftrightarrow A_1) and (A_2\leftrightarrow A_3). It therefore preserves both
the union of generator matchings and the deleted conic set (D(S)), which is defined by secants
of pairs in (S).

It remains to check that no mirror pair is an edge. Equality
(\tau(t)=\sigma_{r,c}(t)) is equivalent to a fixed point of
(\tau^{-1}\sigma_{r,c}). Its discriminant is

\[
(r-c)^2+4,
\]

which is (5,5,(b-1)^2+4,(b-1)^2+4). For (p\equiv3,27\pmod {40}), quadratic
reciprocity gives

\[
\left(\frac{-1}{p}\right)=\left(\frac{5}{p}\right)=-1.
\]

Both constants remain nonsquares in `F_q` because `e` is odd. The hypothesis on (b) handles the
other pair. Thus (\tau) restricts to a fixed-point-free
automorphism of the live residual and no vertex is adjacent to its mate. After any move at (v),
the response at (\tau v) is legal; deleting the two closed neighborhoods restores a
(\tau)-invariant position. Induction gives a second-player win, hence
(\mathcal G(R_{S_b})=0).

### Exact parameter count

Put `x=b-1`. In every subfield `F_(p^d)` with `d | e`, both `d` and `e/d` are odd. Thus `-1`
is nonsquare there, `x^2+4` has no zero, and the standard quadratic-character identity gives

\[
\sum_{x\in \mathbf F_{p^d}}\chi_d(x^2+4)=-1.
\]

Consequently `(p^d+1)/2` values in `F_(p^d)` make `(b-1)^2+4` nonsquare. Nonsquareness is
unchanged on passage from `F_(p^d)` to `F_q`, since the extension degree is odd. Möbius inversion
over the subfield lattice therefore says that the number of nonsquare-test parameters of exact
degree `e>1` is

\[
\frac12\sum_{d\mid e}\mu(e/d)(p^d+1)
=\frac12\sum_{d\mid e}\mu(e/d)p^d,
\]

exactly half the full-degree elements. Such an element is automatically outside
`{0,1,-1,2}`. When `e=1`, `(p+1)/2` parameters pass the nonsquare test; `b=0,-1,2` are among
them because their tests are `5,8,5`, while `b=1` has square test `4`. This leaves `(p-5)/2`.

## Exact Dickson/subfield boundary audit

For this family the nonsquare determinant first removes `PSL_2(q)`. Giudici's Theorem 3.5 then
gives the exact maximal-overgroup boundary inside `PGL_2(q)`: Borel, split/nonsplit torus
normalizer, the stated prime-field `S_4` exception, or an immediate proper-subfield
`PGL_2(q_0)`. The unipotent and common-fixed-point tests handle the first three rows. They do
**not** handle the subfield row when `e>1`; the new load-bearing step is

\[
\kappa(A_2A_0)=1/(1-b),
\]

which makes every possible definition field contain `b`. The full-degree hypothesis closes the
row. This is a family-specific subfield exclusion. The companion silver report gives the general
odd-subfield orbit decomposition, with one regular `PGL2` Cayley scar still open in extension
degree `3 mod 4`.

The result crosses the full-group boundary over every odd extension of the eligible prime fields
without borrowing the unresolved abundance or recognition mechanisms owned by C84/C199/C200.

## Program relations and silver boundary

- C84 sought a full-dimensional density mechanism broad enough to survive bad-set avoidance. This
  family supplies `Theta(q)` configurations but remains a one-dimensional mirror locus, not the
  required two-dimensional raw fourth-centre density for a fixed rooted triple. It does not prove
  the `(ON)` transfer lemma.
- C199 seeks direct strategies for the bounded proper-subgroup catalogue. The mirror here is a
  direct strategy, but for a new full-group residual rather than a recertification of a catalogue
  row.
- C200 seeks structural recognition of bounded catalogue graphs. The present proof needs no graph
  isomorphism classification: it uses a value-preserving automorphism on a growing full-group
  Schreier family.
- The odd-projective-plane program uses the same burned-pair plus conic-residual object. C294
  supplies an explicit full-group off-conic P stratum, but it neither forces entry from an arbitrary
  size-three state nor identifies an on-conic P child, and it does not seal away later off-conic
  moves.
- Each centre's projection matching is its radius-two pointed repair port on the conic: an edge
  `{u,v}` means `{x,u,v}` is a projective 3-circuit. Thus `R_{S_b}` is the shared-helper conflict
  graph obtained by superposing four pointed repair ports and deleting helpers killed by target
  secants. This is a genuine future interface to the complete-ports theory, but it is multi-target
  and game-valued, outside that paper's frozen single-target reliability/Tutte scope.

Crown I silver asks for every tame legal configuration of one fixed size, including the full and
subfield linear-group cases. The family above is a new positive-dimensional full-group stratum,
not that classification. The minimal silver battlefield is three centres; exact q=11 data already
show that root and two-ply pairing certificates miss most P residuals, so silver needs a genuinely
non-pairing global recursion plus a value theorem for the remaining `PGL2` Cayley scar.

## Evidence and replay

The uniform theorem is the coordinate proof above, using the quadratic-character identity,
Möbius inversion, and Giudici's maximal-subgroup form of Dickson's classification. The finite
checker independently:

- verifies all twenty cap determinants for all 140 admissible parameters over the eligible primes
  at most 110;
- checks the generator conjugation, deleted-set invariance, fixed-free pairing, nonadjacency, and
  unipotent word for every parameter; and
- enumerates the complete generated projective matrix group for the (b=3) member in each field,
  obtaining (p(p^2-1)=|PGL_2(p)|) for (p=43,67,83,107);
- exhausts all 79,507 elements of the first eligible nonprime field `F_(43^3)`, finding exactly
  39,732 admissible full-degree parameters, and verifies that `1/(1-b)` has full definition field
  for every one, with Euler-character tests independently cross-checked against direct square-set
  membership; and
- checks the extension-field unipotent word and trace identity on eight deterministic polynomial-
  basis samples.

From `/home/tavis/src/othello` run:

```sh
python3 notes/2026-07-17-c294-full-conic-continuation-crown.py --check
sha256sum -c notes/2026-07-17-c294-full-conic-continuation-crown.sha256
```

The checker uses only Python's standard library, deterministic exhaustive enumeration, and no
random seed. The extension field is `F_43[x]/(x^3+3)`. The JSON is a compact certificate of the
checked finite cases. It does not certify the character-sum identity, Möbius inversion, the
maximal-subgroup classification, quadratic reciprocity, or the general mirror induction; those are
the trusted mathematical boundary. In particular, it does not enumerate `PGL_2(43^3)`: the
uniform full-group conclusion is the mathematical classification argument above.

| Load-bearing artifact | Bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-17-c294-full-conic-continuation-crown.py` | 15,096 | `386de0aee798d82db74ae5cf4d6267230a63307447fe96ff0a388d1fb4fb9c46` |
| `notes/2026-07-17-c294-full-conic-continuation-crown.json` | 6,167 | `7a011edb53ac3477391730a6532289877fbab3fa3d1ec8330d62dbfb2e488959` |

Subgroup-classification references: Michael Giudici, [*Maximal subgroups of almost simple groups
with socle `PSL(2,q)`*](https://arxiv.org/abs/math/0703685), Theorem 3.5 (cached PDF SHA-256
`2c829b573dadf9ee2c71a9f85f92e1fb2d7443f64242dbe4a829c6246d9ae8e9`); and L. E. Dickson,
*Linear Groups with an Exposition of the Galois Field Theory*, Teubner, 1901.
