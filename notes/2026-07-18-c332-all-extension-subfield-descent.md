# C332: all-extension subfield descent

**Date:** 2026-07-19  
**Lane:** `crowns`  
**Verdict:** **THEOREM; UNIFORM ALL-EXTENSION DECOMPOSITION WITH ONE EVEN-DEGREE QUADRATIC SCAR**

## Result

Let `k=F_r` have odd order, let `K=F_(r^n)`, and identify the conic over `K` with
`P1(K)`. Let `S={s_1,s_2,s_3}` be the projection involutions of a legal triple of distinct
off-conic centres defined over `k`, and suppose that they generate

\[
H=\operatorname{PGL}_2(k)\quad\text{or}\quad H=\operatorname{PSL}_2(k).
\]

For an `H`-stable set `X`, write `R_X(S)` for the three-coloured projection graph on

\[
X\setminus D(S),\qquad
D(S)=\bigcup_{i<j}\operatorname{Fix}(s_js_i),
\]

with the colour-`i` edges `x--s_i x`; loops and edges incident with deleted vertices are omitted.
Thus the conic residual in the extension field is `R_K(S)=R_(P1(K))(S)`. Put

\[
B(S)=R_{\mathbf P^1(k)}(S),\qquad
Q_H(S)=R_{\mathbf P^1(k^2)\setminus\mathbf P^1(k)}(S),\qquad
C_H(S)=\operatorname{Cay}(H,S),
\]

where `Q_H(S)` is included only when `2|n`. The Cayley graph uses the left-action convention and
retains the three generator colours.

Define

\[
c_n=
\begin{cases}
\dfrac{r^{n-1}-1}{r^2-1}=1+r^2+\cdots+r^{n-3},&n\text{ odd},\\[6pt]
\dfrac{r^{n-1}-r}{r^2-1}=r(1+r^2+\cdots+r^{n-4}),&n\text{ even},
\end{cases}
\]

with the second sum empty, and hence `c_2=0`. Then there are colour-preserving graph
decompositions

\[
R_K(S)\cong
\begin{cases}
B(S)\sqcup c_n C_H(S),&H=\operatorname{PGL}_2(k),\ n\text{ odd},\\
B(S)\sqcup Q_H(S)\sqcup c_n C_H(S),&H=\operatorname{PGL}_2(k),\ n\text{ even},\\
B(S)\sqcup 2c_n C_H(S),&H=\operatorname{PSL}_2(k),\ n\text{ odd},\\
B(S)\sqcup Q_H(S)\sqcup 2c_n C_H(S),&H=\operatorname{PSL}_2(k),\ n\text{ even}.
\end{cases}
\]

This includes `n=1`, when the formula is simply `R_K(S)=B(S)`, and `n=2`, when the even formula
has no regular component.

### Exact Sprague--Grundy formula

Let `g_B`, `g_Q`, and `g_C` be the ordinary Node--Kayles nimbers of the three displayed residual
types. Sprague--Grundy addition gives

\[
\mathcal G(R_K(S))=
\begin{cases}
g_B,&H=\operatorname{PSL}_2(k),\ n\text{ odd},\\
g_B\oplus g_Q,&H=\operatorname{PSL}_2(k),\ n\text{ even},\\
g_B\oplus \epsilon_n g_C,&H=\operatorname{PGL}_2(k),\ n\text{ odd},\\
g_B\oplus g_Q\oplus \epsilon_n g_C,&H=\operatorname{PGL}_2(k),\ n\text{ even},
\end{cases}
\]

where multiplication by `0` or `1` means omission or inclusion in the xor, and

\[
\epsilon_n=c_n\bmod2=
\begin{cases}
(n-1)/2\bmod2,&n\text{ odd},\\
(n-2)/2\bmod2,&n\text{ even}.
\end{cases}
\]

Equivalently, the regular `PGL2` scar survives exactly for `n=3 mod 4` in odd degree and
`n=0 mod 4` in even degree. The complete residue-class table is therefore

| sheet | `n mod 4` | residual nimber |
|:--|:--:|:--|
| `PSL2` | `1,3` | `g_B` |
| `PSL2` | `0,2` | `g_B xor g_Q` |
| `PGL2` | `1` | `g_B` |
| `PGL2` | `2` | `g_B xor g_Q` |
| `PGL2` | `3` | `g_B xor g_C` |
| `PGL2` | `0` | `g_B xor g_Q xor g_C` |

The theorem isolates but does **not** evaluate `g_Q` or the mixed-determinant regular scar `g_C`.
In particular it does not resume C294 or turn its paused transfer problem into a claimed value
theorem.

## Proof

The orbit input is classical. A nonidentity fractional-linear transformation over `k` fixes only
the roots of a nonzero polynomial of degree at most two. Hence every point outside `P1(k^2)` has
trivial stabilizer in either group. Both groups are transitive on `P1(k)`. They are also transitive
on

\[
X_2=\mathbf P^1(k^2)\setminus\mathbf P^1(k),
\]

which has size `r(r-1)`: in `PGL2(k)` the stabilizer of a quadratic point is the nonsplit torus of
order `r+1`; its determinant-square intersection has order `(r+1)/2`, so orbit--stabilizer gives
the same `r(r-1)` orbit for `PSL2(k)`. Hollmann states exactly this base orbit, quadratic orbit,
and regularity beyond degree two in Section 7 of
[*Nonstandard linear recurring sequence subgroups in finite fields and automorphisms of cyclic
codes*](https://arxiv.org/abs/0807.0595). This is the classical input, not a C332 novelty claim.

The intersection identity

\[
K\cap k^2=\mathbf F_{r^{\gcd(n,2)}}
\]

shows that `X_2` occurs precisely when `n` is even. Counting the remaining points and dividing by
the regular orbit size gives `c_n` for `PGL2` and `2c_n` for its index-two subgroup `PSL2`.

It remains to justify that deletion respects exactly these orbit blocks. For each centre pair, the
line through the centres meets the parametrized conic at the fixed points of `s_j s_i`. Those
points have degree at most two over `k`, so

\[
D(S)\subseteq \mathbf P^1(k^2).
\]

Thus odd extensions delete only points of the base subline. Even extensions split the deletion
between the base subline and `X_2`; there is no deletion in a regular orbit. Every generator lies
in `H`, so every coloured edge stays in one `H`-orbit. A free orbit, identified by
`h \mapsto h x`,
has colour-`i` adjacency `h x -- s_i h x`, hence is the stated left Cayley component. This proves
the coloured decomposition. The nimber formula follows from disjoint-union xor, and the parity
formula follows because `r` is odd.

The hypothesis can be empty in a small sheet: `PSL2(3) \cong A4` has no involutory
generating triple, since all three of its involutions lie in its proper normal Klein four subgroup.
The theorem is valid but vacuous there. No other exception is needed; tangent pair-lines merely
make a repeated root in `D(S)` and are already covered by the set union.

## Continuation and repair-port base change

The result is stronger than an uncoloured Node--Kayles identity because the isomorphism preserves
the generator colours and the deleted-helper set.

For a sealed conic continuation whose remaining legal moves are the vertices of this residual,
restriction from `K` to `k` is the base block `B(S)`, while even degree adds the single canonical
quadratic boundary block `Q_H(S)` and higher-degree points add the displayed regular blocks. No
move or closed-neighbourhood interaction crosses blocks. Consequently the full residual-game
interface, not only its P/N outcome, base-changes by disjoint union and its nimber by the formula
above.

For repair ports, colour `i` is the radius-two recovery matching for target `i`; deletion removes
helpers killed by target secants. The recovery graph is therefore block diagonal with the same
decomposition. If `P_B`, `P_Q`, and `P_C` denote the projected fractional service-rate regions of
the three coloured helper blocks, then helper sets are disjoint and

\[
P_K=
\begin{cases}
P_B+c_nP_C,&\operatorname{PGL}_2,\ n\text{ odd},\\
P_B+P_Q+c_nP_C,&\operatorname{PGL}_2,\ n\text{ even},\\
P_B+2c_nP_C,&\operatorname{PSL}_2,\ n\text{ odd},\\
P_B+P_Q+2c_nP_C,&\operatorname{PSL}_2,\ n\text{ even},
\end{cases}
\]

where `+` is Minkowski sum and `mP` is the `m`-fold sum. The identical formula holds with
integral scheduling semigroups in place of fractional regions. This is a restriction/base-change
interface; it does not assert that any one block improves the homogeneous MDS service region.

## Exact replay

The adjacent checker is independent of the earlier C294 prime-field graph code. It implements
prime-field extensions as polynomial quotients, enumerates `PGL2(p)` and `PSL2(p)` as normalized
matrices, finds legal involutory generating triples, computes every orbit and pair-product fixed
point, and verifies:

- one base orbit and, exactly in even degree, one quadratic orbit of size `p(p-1)`;
- regular orbit sizes and the exact multiplicities `c_n` and `2c_n`;
- deletion support entirely in degree at most two;
- invariance of every colour on every orbit; and
- trivial stabilizers on every asserted Cayley block.

It checks `p=3` for `PGL2` at `n=2,3,4,5`, and `p=5` for both sheets at `n=2,3,4`. The selected
even-degree triples have nonempty quadratic deletion (`4` or `6` deleted quadratic points), so the
new deleted scar is exercised. The replay is a representative finite-field check, not a proof for
prime-power base fields; the proof above supplies that generality.

From `/home/tavis/src/othello`:

```sh
python3 notes/2026-07-18-c332-all-extension-subfield-descent.py \
  --check notes/2026-07-18-c332-all-extension-subfield-descent.json
```

| load-bearing artifact | bytes | SHA-256 |
|:--|--:|:--|
| `notes/2026-07-18-c332-all-extension-subfield-descent.py` | 13,991 | `afa6f53779a42246e898315b58f763816642d5797d132337cc46c795e04393e9` |
| `notes/2026-07-18-c332-all-extension-subfield-descent.json` | 4,566 | `f42f46f3f0110b5924a91507bd03fe66b2104aa0da948b8c693955e5fe6633f2` |

The checker trusts Python integer arithmetic, its explicit polynomial-quotient field
implementation, and exhaustive enumeration at the stated sizes. Its independent invariants are
orbit--stabilizer size, Frobenius degree classification, pair-product fixed-point support, and
colour-block closure. It does not compute either unevaluated scar nimber.

## Novelty boundary

The orbit lengths and regularity are classical. A focused search also found Niederreiter and
Winterhof's broader study of `PGL2(q)` orbits on `GF(q^n)`,
[*On the distribution of points in orbits of PGL(2,q) acting on GF(q^n)*](https://doi.org/10.1016/S1071-5797(03)00025-X),
but Hollmann is the direct source for the exact base/quadratic/regular statement used here.
Cameron--Omidi--Tayfeh-Rezaie's `3`-design paper concerns orbits on subsets of the base projective
line and is not the load-bearing citation for this extension-field orbit decomposition.

The new synthesis claimed here is limited to the fixed-point-deleted three-coloured residual, its
quadratic scar in even degree, the exact parity-sensitive Sprague--Grundy formula, and the
continuation/repair-port base-change consequences. No unrestricted Node--Kayles value, quadratic
scar evaluation, regular mixed-sheet transfer, or new classical orbit classification is claimed.
