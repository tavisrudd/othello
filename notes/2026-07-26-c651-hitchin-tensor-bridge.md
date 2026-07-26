# C651 exact Hitchin--Clebsch tensor bridge

Date: 2026-07-26

## Result

Let \(G\) be the order-\(60\) stabilizer of the \(H_3\)-invariant matching
inside \(\operatorname{PGL}_2(\mathbf F_{11})\), let \(\Omega\) be its
22-point matching orbit, and let
\[
  W=\left\langle q_M-q_{M_0}:M\in\Omega\right\rangle
\]
be the ten-dimensional factorization-difference quotient from Paper II.
Write \(\epsilon:\Omega\to\{\pm1\}\) for the two
\(\operatorname{PSL}_2(\mathbf F_{11})\)-sheet signs and put
\[
  T=\sum_{M\in\Omega}\epsilon(M)\,[q_M-q_{M_0}]^{\otimes3}
  \in\operatorname{Sym}^3(W).
\]

The exact computation proves the following.

**Tensor bridge theorem.** There is an explicit \(G\)-equivariant
isomorphism
\[
  S:\mathbf F_{11}^{\binom{[5]}2}\longrightarrow W
\]
such that, after transporting \(T\) by \(S^{-1}\), identifying the
ten-pair permutation module with its dual by the standard pairing, and
restricting along
\[
  E:\{(y_1,\ldots,y_5):\textstyle\sum_i y_i=0\}
     \longrightarrow\mathbf F_{11}^{\binom{[5]}2},
  \qquad E(y)_{\{i,j\}}=y_i+y_j,
\]
the resulting cubic tensor is
\[
  E^*(S^{-1})^{\otimes3}T=4\,\sigma_3,\qquad
  \sigma_3(y)=\frac{1}{3}\sum_{i=1}^5y_i^3.
\]
In particular, the Paper II signed matching cubic and the Clebsch cubic
generate the same nonzero invariant cubic line over \(\mathbf F_{11}\).

## Proof

The five Klein four subgroups of \(G\) have five distinct order-12
normalizers. Conjugation on those normalizers gives a faithful
degree-five action of \(G\), hence an identification \(G\cong A_5\).
This produces the ten-dimensional permutation representation \(P\) on
the two-subsets of the five points.

The matching construction independently gives ten-dimensional matrices
for \(G\) on \(W\). Solving
\[
  \rho_W(g)S=S\rho_P(g)
\]
over \(\mathbf F_{11}\) for a generating set gives a three-dimensional
intertwiner space. The certificate selects the lexicographically first
invertible solution, with coefficient vector \((0,0,1)\), records its
full \(10\times10\) matrix, and verifies the displayed equation for all
60 elements of \(G\). Thus the selected \(S\) is an explicit
\(G\)-equivariant isomorphism.

The 22 orbit vectors and their sheet signs give the 220 coordinates of
\(T\) in the ordered basis
\(\{e_i e_j e_k:0\leq i\leq j\leq k<10\}\). Their byte hash is
`9e9443c65e9fdf0a596968efeec13fd6f09e841f035e6d13a96aa4fc12b345fd`,
which agrees with the frozen Paper II cubic.

Set \(y_5=-y_1-y_2-y_3-y_4\). Exact contraction of the transported
220-coordinate tensor with the \(10\times4\) matrix of \(E\) gives the
full polarized \(4^3\)-tensor
\[
  R_{abc}=
  \begin{cases}
    0,&a=b=c,\\
    6,&\text{otherwise},
  \end{cases}
  \qquad a,b,c\in\{1,2,3,4\}.
\]
The polarized tensor of \(\sigma_3\) has entries \(0\) when all three
indices agree and \(-1/3=7\) otherwise. Since \(4\cdot7=6\) in
\(\mathbf F_{11}\), all 64 entries give \(R=4\sigma_3\). The scalar is
nonzero, proving equality of the two invariant lines.

The independent replay reconstructs \(\operatorname{PGL}_2\), its
\(\operatorname{PSL}_2\) subgroup, the orbit, quotient coordinates,
sheet signs, cubic, natural five-point action, and induced matrices
using the separate Paper II replay implementation. It then verifies the
certificate's matrix on all 60 group elements, recomputes the
three-dimensional Hom space, and independently contracts all 64
entries. It again obtains scalar \(4\).

## Lean formalization

The module
`RelativeConicArcs.ClebschTensorBridge` records the twenty nonzero
symmetric coordinates of the signed matching cubic and the exact
\(10\times4\) contraction matrix. Its theorem
`RelativeConicArcs.ClebschTensorBridge.restrictedCubic_eq_four_mul_clebschPolarization`
exhausts \((\operatorname{Fin}4)^3\) and proves
\[
  \operatorname{restrictedCubic}(a,b,c)
  =4\,\operatorname{clebschPolarization}(a,b,c)
\]
over `ZMod 11`. The companion theorem
`RelativeConicArcs.ClebschTensorBridge.restrictedCubic_nonzero`
checks the entry \((0,0,1)=6\). The kernel-checked theorem
`RelativeConicArcs.ClebschTensorBridge.gauntDenominator_divisibleBy_eleven`
records \(11\mid1247103\).

The finite terminal uses Lean native decision. Its pinned-toolchain
axiom audit is

```text
[propext, Quot.sound,
 restrictedCubic_eq_four_mul_clebschPolarization._native.native_decide.ax_1_1]
```

The nonzero-entry theorem uses only `[propext, Quot.sound]`. The module
does not formalize the upstream matching orbit, the construction of the
five-point action, or the 60 equivariance equations; those remain
exactly checked by the two Python routes above. Thus Lean verifies the
terminal tensor contraction from literal certificate data rather than
claiming an end-to-end formalization of the geometric provenance.

## Cross-characteristic boundary

The rational \(W_6\) Gaunt computation gives
\[
  W_6|_{V_4}=-\frac{784000}{1247103}\sigma_3.
\]
Here
\[
  1247103=3^3\cdot11\cdot13\cdot17\cdot19.
\]
Therefore that rational scalar has no reduction modulo \(11\). The
honest bridge is the common integral Clebsch line
\(\langle\sigma_3\rangle\), not an equality obtained by reducing the
rational Gaunt normalization. Determining a single integral
normalization across characteristics remains outside C651.

## Reproduction

Run from `/home/tavis/src/othello`:

```text
python3 notes/2026-07-26-c651-hitchin-tensor-bridge.py --check
python3 notes/2026-07-26-c651-hitchin-tensor-bridge-replay.py
lean/scripts/guarded-lean RelativeConicArcs/ClebschTensorBridge.lean
```

Expected output:

```text
Clebsch--Hitchin tensor bridge certificate: OK
independent tensor bridge replay: OK (22 orbit points, 60 group elements, Hom dimension 3, scalar 4)
```

Artifacts:

| File | Bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-26-c651-hitchin-tensor-bridge.py` | 14761 | `dfb2993b072bfd4eceab77aaad8cfe760771b654d8e4c0d05c065ef9f386e041` |
| `notes/2026-07-26-c651-hitchin-tensor-bridge-replay.py` | 8302 | `0ee0d31d189cb69872b8996329fc289c829724de090fe1846073ea0a402311fb` |
| `notes/2026-07-26-c651-hitchin-tensor-bridge.json` | 4369 | `9f93ccdc80c757eb78078e479c8107c0108980fb8b4daca5d1ba389072aa17e9` |
| `lean/RelativeConicArcs/ClebschTensorBridge.lean` | 5614 | `eb9c5458732903b4eea63afacdd1c715c871f2f8b0905d65794e2965fb9f181e` |
| `lean/RelativeConicArcs/Gates/ClebschTensorBridge.lean` | 761 | `acfcdec4da39397000c69c02692275ee852a5653efa15c4a4bf3534a98206643` |

Primary inputs frozen into the JSON certificate:

| File | Bytes | SHA-256 |
|---|---:|---|
| `papers/clebsch-factorization/verification/evidence/matching_module.py` | 48643 | `d2100485add18a92a148f0584d41b2108100baf545fd361e6cc08b7e61e92f40` |
| `papers/clebsch-factorization/verification/evidence/matching_orbit_scout.json` | 25385 | `d45512c9087874acdaf109367753f45151c2dd0c2cb745777f62ad26489e7394` |

## Trust boundary and closeout

The theorem is an exact finite-field statement. It relies on executable
finite enumeration and linear algebra, not floating-point numerics.
The primary and replay programs share Python's integer arithmetic and
the frozen orbit scout, but they do not share the quotient and group
implementations. The explicit JSON contains the claimed intertwiner and
tensors, so a third implementation can check the decisive identities
without trusting the search procedure.

Closed here: the exact Paper II--Clebsch tensor identification over
\(\mathbf F_{11}\), including a concrete equivariant module bridge and
nonzero scalar. Not closed here: the arithmetic Hitchin cover, the
\(T_{11}\) specialization, an integral comparison of Gaunt and matching
normalizations, or the novelty gate for a Paper III headline.

## Serialized import gate and exact freshness

The import-only target
`RelativeConicArcs.Gates.ClebschTensorBridge` was built through the shared
serialized Lean queue on 2026-07-26.  The build completed in 14.47 seconds
with peak resident memory 1,101,320 kB.  The queue's required post-build
trace-only invocation

```text
lake build --no-build RelativeConicArcs.Gates.ClebschTensorBridge
```

replayed both the source module and its gate and ended with
`All targets up-to-date (1268 jobs).`  The replayed gate reported exactly
the disclosed native-decision axiom for the 64-entry equality, only
`propext` and `Quot.sound` for nonvanishing, and only `propext` for the
denominator divisibility theorem.  This closes the serialized-build and
exact-target freshness condition without changing the optional status of
Lean in Paper III's release surface.

## Mystery ledger

The `ej` and `tt` closeout found no unresolved task-internal mystery.  The
three-dimensional intertwiner space is the expected commutant dimension of
the multiplicity-free \(1+4+5\) decomposition of the ten-pair permutation
module, and the scalar \(4\) is fixed by the explicitly frozen bases and
selected invertible intertwiner.

One broader normalization question remains deliberately outside this task:
the rational Gaunt scalar cannot be reduced modulo \(11\), so a single
integral normalization comparing the characteristic-zero and
characteristic-\(11\) representatives would require new arithmetic input.
No successor is allocated for that question, and C651 makes no claim beyond
the common integral cubic line.
