# Conic-involution Schreier graphs

**Date:** 2026-07-12  
**Status:** downstream replacement for the overclaimed “linear-involution drain lemma”  
**Scope:** odd prime powers unless explicitly restricted to primes

## 1. Result worth keeping

The useful object behind the conic bulk is a Schreier graph, not a new drain lemma.

Let

\[
C=\{[t^2:t:1]:t\in\mathbf F_q\}\cup\{[1:0:0]\}
\]

be the conic \(XZ=Y^2\), identified with \(\mathbf P^1(q)\). An off-conic point
\(x=[a:b:c]\) induces the projection involution

\[
\sigma_x(t)=\frac{bt-a}{ct-b},\qquad
A_x=\begin{pmatrix}b&-a\\c&-b\end{pmatrix}.
\]

Here the formula has its usual projective interpretation at poles and infinity. Since

\[
A_x^2=(b^2-ac)I,
\]

\(\sigma_x\) is a nonidentity involution exactly when \(x\notin C\).

For selected centres \(S\), the coloured multigraph with edges
\(t\mathbin{-}\sigma_x(t)\), \(x\in S\), is the Schreier multigraph of

\[
H_S=\langle \sigma_x:x\in S\rangle\leq PGL(2,q)
\]

on \(\mathbf P^1(q)\). The actual live conic graph is the simple induced graph left after
removing the conic points lying on lines containing two selected centres. Conic-only play
is Node Kayles on this induced Schreier graph.

There is an exact group-theoretic description of the initial saturated set:

\[
D(S)=\bigcup_{\{x,y\}\subset S}\operatorname{Fix}(\sigma_x\sigma_y).
\]

Indeed, \(\sigma_x\sigma_y(t)=t\) exactly when
\(\sigma_x(t)=\sigma_y(t)\). This says either that \(x,y\) lie on the secant joining
\(t\) to their common partner, or that they both lie on the tangent at \(t\). In either
case \(t\in xy\), and the converse is immediate. Thus the residual graph can be written
compactly as

\[
\operatorname{Sch}\!\left(H_S,\mathbf P^1(q),\{\sigma_x:x\in S\}\right)
\left[\mathbf P^1(q)\setminus D(S)\right],
\]

with loops removed and coincident coloured edges merged.

This reframing supplies two nontrivial exact results: a complete two-centre decomposition
and a three-centre Klein-four family with closed-form P/N values.

## 2. Two centres: uniform alternating components

Let \(x\ne y\), put \(g=\sigma_x\sigma_y\), and let \(r=|g|\). Before saturated points
are removed, the union of the two involution matchings has maximum degree two. Its
components are paths, alternating cycles, isolated fixed points, and possibly one doubled
edge.

### Theorem 2.1

After removing the conic points on the line \(xy\):

1. the residual two-colour graph is simple;
2. it has at most two path components;
3. every cycle has the same length \(2r\).

#### Proof

A point of \(C\cap xy\) is either a common fixed point of \(\sigma_x,\sigma_y\), when
\(xy\) is tangent, or one endpoint of their unique shared edge, when \(xy\) is secant.
These are precisely the degeneracies removed by saturation.

Every remaining component has degree at most two and is properly two-edge-coloured. Its
path endpoints must be fixed points of one of the two involutions. Each involution has at
most two fixed points, so there are at most four endpoints and hence at most two paths.

Following two successive coloured edges applies \(g\) or \(g^{-1}\). Apart from the fixed
points already removed, every orbit of a nonidentity element of \(PGL(2,q)\) has length
\(|g|\): this is immediate in the split, unipotent, and nonsplit normal forms. An
alternating cycle therefore has length \(2r\). ∎

### Corollary 2.2: exact conic-only value

Let \(P_n\) be the Node-Kayles Grundy value of a path on \(n\) vertices, with \(P_m=0\)
for \(m\leq0\). Then

\[
P_n=\operatorname{mex}_{1\leq i\leq n}
\left\{P_{i-2}\mathbin{\oplus}P_{n-i-1}\right\}.
\]

For a cycle on \(n\) vertices,

\[
C_n=\operatorname{mex}\{P_{n-3}\}
=
\begin{cases}
1,&P_{n-3}=0,\\
0,&P_{n-3}\ne0.
\end{cases}
\]

Consequently the complete two-centre residual value is the xor of at most two path values
and the parity contribution of the identical \(2r\)-cycles. No bulk search is needed.

## 3. Three centres: self-polar triangles give only \(K_4\)'s

The conic polarity has bilinear form

\[
B(x,y)=a f+c d-2be
\]

for \(x=[a:b:c]\) and \(y=[d:e:f]\). Direct calculation gives

\[
\operatorname{tr}(A_xA_y)=-B(x,y).
\]

For traceless \(2\times2\) matrices,

\[
A_xA_y+A_yA_x=\operatorname{tr}(A_xA_y)I.
\]

Thus polar-conjugate centres give projectively commuting involutions.

### Theorem 3.1

Suppose \(x,y,z\) form a self-polar triangle: each vertex is the pole of the opposite
side. Then

\[
\{1,\sigma_x,\sigma_y,\sigma_z\}\cong V_4,
\qquad
\sigma_x\sigma_y=\sigma_z
\]

after relabelling. If exactly \(s\) of these three involutions are split, the saturated
set on the conic has size \(2s\), and the live conic graph is

\[
\frac{q+1-2s}{4}K_4.
\]

Its Grundy value is therefore

\[
\mathcal G=\frac{q+1-2s}{4}\pmod 2.
\]

#### Proof

Pairwise polarity gives \(\operatorname{tr}(A_xA_y)=0\), so the corresponding
involutions commute projectively. Their products give the third nonidentity element of a
Klein four group.

The side \(xy\) is the polar of \(z\). Its intersections with \(C\) are exactly the fixed
points of \(\sigma_z\), and similarly cyclically. Hence saturation removes the fixed
points of all three involutions. In odd characteristic their fixed-point sets are pairwise
disjoint. The Klein four action on the remaining points is free, so every orbit has four
points. On such an orbit, the three involutions supply the three perfect matchings of
\(K_4\). Finally, a move in \(K_4\) deletes the whole component, so \(\mathcal G(K_4)=1\)
and disjoint sums reduce to parity. ∎

### Corollary 3.2: explicit P families

The possible values of \(s\) and the conic-only P condition are:

| \(q\bmod4\) | \(s\) | number of \(K_4\)'s | P exactly when |
|---|---:|---:|---|
| 1 | 1 | \((q-1)/4\) | \(q\equiv1\pmod8\) |
| 1 | 3 | \((q-5)/4\) | \(q\equiv5\pmod8\) |
| 3 | 0 | \((q+1)/4\) | \(q\equiv7\pmod8\) |
| 3 | 2 | \((q-3)/4\) | \(q\equiv3\pmod8\) |

Orthogonal-basis counting gives \(|PGL(2,q)|/24\) self-polar triangles of the \(s=0\)
or \(s=3\) type, and \(|PGL(2,q)|/8\) of the other type. Thus these are large, explicit
families of reachable residual positions, not isolated coincidences.

This is an exact value theorem only for the conic-only residual. Additional legal
off-conic moves can change the value of the full cap-game position.

## 4. General triples: subgroup classification is the next lever

For three centres the pre-saturation graph is the Schreier graph of a three-involution
subgroup of \(PGL(2,q)\). This suggests using the finite-subgroup classification of
\(PGL(2,q)\), rather than treating the residual as an arbitrary subcubic graph.

For prime \(q\), exhaustive enumeration gives the following generated-subgroup profiles.
An entry \((h,m):n\) means that \(n\) distinct subgroups of order \(h\) occur, and each is
generated by \(m\) legal unordered centre triples.

| \(q\) | profiles \((h,m):n\) |
|---:|---|
| 3 | \((4,1):4\), \((8,4):3\), \((24,52):1\) |
| 5 | \((4,1):20\), \((8,4):15\), \((12,12):10\), \((24,52):5\), \((60,380):1\), \((120,1140):1\) |
| 7 | \((4,1):56\), \((8,4):42\), \((12,12):28\), \((16,16):21\), \((24,52):14\), \((168,392):1\), \((336,14392):1\) |

These orders are exactly the expected small dihedral/polyhedral subgroups and the large
\(PSL/PGL\) cases. The self-polar theorem is the order-four row. The next tractable rows
are dihedral groups, then \(A_4\) and \(S_4\); their Schreier orbits should yield a finite
catalogue of residual component types and exact Grundy reductions.

**Order-24 caveat (\(q\ge 11\)).** The table stops at \(q=7\), where \(12\nmid q^2-1\) and the
only order-24 subgroup is \(S_4\). For \(q\ge 11\) the order-24 row is **not** a single type: the
dihedral \(D_{24}\) also occurs whenever \(12\mid q^2-1\) (so at \(q=11,13,\dots\)), and *order 24
alone does not identify \(S_4\)*. Separate the two by element-order profile — \(S_4\) is
\(\{1{:}1,2{:}9,3{:}8,4{:}6\}\), \(D_{24}\) is \(\{1{:}1,2{:}13,3{:}2,4{:}2,6{:}2,12{:}4\}\). The
\(S_4\)-rooted escape catalogue (`s4_escape_probe.py`, `s4_abundance_check.py`) applies this
profile guard, so its abundance rows are genuine-\(S_4\) (verified q=7–23).

### Theorem 4.1: the order-eight row is also parity

Suppose a legal centre triple generates \(H\cong D_8\). Its residual conic graph has the
form

\[
aM_8\;\sqcup\;bK_2,
\]

where \(M_8\) is the 8-vertex Möbius ladder. Consequently

\[
\mathcal G=a+b\pmod2.
\]

#### Proof sketch

Write \(D_8=\langle r,s:r^4=s^2=1,\ srs=r^{-1}\rangle\). The involutions are the
central element \(r^2\) and the four reflections. Three reflection matrices lie in the
same projective line in the traceless-matrix model, so they are not a legal centre triple.
Hence, up to an automorphism of \(D_8\), a legal generating triple is

\[
\{r^2,s,rs\}.
\]

On every free orbit its Schreier graph is the Cayley graph
\(\operatorname{Cay}(D_8,\{r^2,s,rs\})\), which is \(M_8\). For a nonfree orbit, an
odd-characteristic point stabilizer contributes a cyclic 2-subgroup. The fixed points of
the three pairwise products \(r^2s,r^3s,r\) are deleted by saturation. The only surviving
part of a nonfree orbit is therefore one edge.

The Möbius ladder is vertex-transitive, and deleting the closed neighbourhood of any
vertex leaves \(P_4\). Since \(\mathcal G(P_4)=0\),
\(\mathcal G(M_8)=1\); also \(\mathcal G(K_2)=1\). The disjoint sum is their xor. ∎

The remaining arithmetic appears to have the following exact form.

### Conjecture 4.2: arithmetic profile of the order-eight row

| \(q\bmod8\) | possible \((a,b,|D|)\) |
|---:|---|
| 1 | \(((q-1)/8,0,2)\) or \(((q-9)/8,2,6)\) |
| 3 | \(((q-3)/8,1,2)\) |
| 5 | \(((q-5)/8,1,4)\) |
| 7 | \(((q+1)/8,0,0)\) or \(((q-7)/8,2,4)\) |

This has been exhaustively verified for prime \(q\leq17\). It should follow by sorting the
order-four rotation and the two reflection products by split type, then applying
orbit-stabilizer. Proving the table would turn Theorem 4.1 into an explicit P/N criterion
for every odd prime power.

The unrestricted triple family becomes complicated quickly, but it is not behaving like a
generic subcubic graph. Full enumeration gives:

| \(q\) | legal triples | P residuals | largest observed Grundy value |
|---:|---:|---:|---:|
| 3 | 68 | 3 | 1 |
| 5 | 1,980 | 625 | 3 |
| 7 | 16,408 | 6,258 | 4 |
| 11 | 265,980 | 109,175 | 5 |

These are counts of labelled centre triples, not graph isomorphism classes.

## 5. A strengthened drain bound

The exact closed-neighbourhood deletion identity is generic Node Kayles. The useful
geometric quantitative statement is instead an edge lower bound.

Let \(S\) contain \(k\) selected centres, let \(D\subset C\) be the \(d\) unavailable
conic points, and let \(f_x\leq2\) be the number of fixed points of \(\sigma_x\). The full
matching of \(x\) has \((q+1-f_x)/2\) edges. Deleting \(d\) vertices destroys at most
\(d\) of those edges. Since distinct colours cannot share a live edge,

\[
|E(G[C\setminus D])|
\geq
\sum_{x\in S}
\max\left(0,\frac{q+1-f_x}{2}-d\right).
\]

Hence a live conic move exists with drain at least

\[
1+\left\lceil
\frac{2}{q+1-d}
\sum_{x\in S}
\max\left(0,\frac{q+1-f_x}{2}-d\right)
\right\rceil.
\]

This is still an existence bound, not a minimax theorem. A viable next potential should
track both live vertices and live coloured edges so that an opponent cannot erase the
average-degree gain cheaply.

## 6. Concrete next programme

1. **Larger dihedral triples.** Extend Theorem 4.1 to orders \(12,16,\ldots\), and express
   their values through a finite family of Cayley components and truncated nonfree orbits.
2. **Polyhedral triples.** Catalogue the \(A_4,S_4,A_5\) actions on \(\mathbf P^1(q)\),
   including which saturated deletions occur and whether the remaining components have a
   bounded set of rooted types.
3. **Trace classifier.** Index triples by the scaling-invariant pair data
   \(\operatorname{tr}(A_xA_y)^2/(\det A_x\det A_y)\) and the corresponding triple
   invariant. Determine whether these invariants predict subgroup type and residual
   Grundy value.
4. **Minimax potential.** Combine live-vertex count with the coloured-edge lower bound;
   test whether a player can force entry into one of the exact small-subgroup families.
5. **Only then return to RSA/MDS analogies.** Neither presently contributes to the game
   theorem.

## 7. Reproduction

The accompanying `three_centre_probe.py` works over odd prime fields. It enumerates legal
centre triples, constructs the saturated residual graph, computes its Node-Kayles Grundy
value, and optionally enumerates generated subgroups.

```bash
python3 -m py_compile three_centre_probe.py
python3 three_centre_probe.py 3 5 7 11
python3 three_centre_probe.py --group-orders 3 5 7
```

The general Nofil-to-Node-Kayles reduction is prior art: M. A. Huggan, S. Huntemann, and
B. Stevens, [“The combinatorial game Nofil played on Steiner Triple
Systems”](https://arxiv.org/abs/2103.13501). Relevant algorithmic targets for the residual
graphs include Y. Kobayashi, [“On Structural Parameterizations of Node
Kayles”](https://arxiv.org/abs/2003.11775).
