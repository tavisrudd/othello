# C577 — Clebsch factorization-memory Paper II

**Lane:** `clebsch`

**Date:** 2026-07-25

**Status:** `IN PROGRESS; SIX-PROFILE MATCHING-ROW RECONSTRUCTION DRAFTED`

## Current result

The Paper II candidate now contains a standalone six-profile reconstruction
section. For
\[
G=\operatorname{PGL}_2(11),\qquad H\simeq A_5,\qquad K\simeq A_4,
\]
subgroup marks split each of the two
\(\operatorname{PSL}_2(11)\)-sheets in \(G/H\) into \(K\)-orbits of sizes
\(1,4,6\). Four oriented pairs of scalar-\(K\) projective cells define a
secant-zero incidence profile. Six representative counts give the profiles
\[
v_1=(-6,0,12,-12),\quad v_2=(-3,3,0,3),\quad
v_3=(3,-2,-2,0)
\]
and their negatives, with fibre sizes \(1,4,6/1,4,6\).

The six vectors are pairwise distinct, so the profile recovers the exact
double-coset row in \(K\backslash G/H\), although their linear image is only
the plane
\[
2a+2b+c=0,\qquad 9a+8b+d=0
\]
over \(\mathbb F_{11}\). The singleton rows recover their individual
matchings; equality of the parent and matching stabilizers then recovers the
individual matching-decorated \(H_3\) parent. The size-four and size-six rows
recover only their \(K\)-orbits.

The weighted relation \(v_1+4v_2+6v_3=0\) and antipodality kill the first and
second signed moments of the compressed configuration. Its cubic remains
nonzero, so the profile map preserves the cubic-first orientation already
proved for the full quotient configuration. Conversely, the three antipodal
rational profile rays recover the primitive positive dependence \(1:4:6\),
and hence recover both the orbit-size multiset \(\{1,4,6\}\) and the
stabilizer-order multiset \(\{12,3,2\}\).

The section states its decoration boundary explicitly. Balanced moments
recover the unordered sheet pair from the affine quotient configuration.
They do not select the ordered golden pair, the common \(A_4\), or the
oriented scalar-\(A_4\) cell pairs. Six-profile row reconstruction is relative
to that selected refinement.

## Evidence and replay

No new computational result was generated for this drafting step. The paper
uses two existing atomic evidence bundles.

The six profiles, subgroup orbits, plane equations, weighted relation, and
cubic witness are certified by
`notes/2026-07-20-c411-double-coset-hecke.{md,py,json,sha256}` and its
independent replay. From `/home/tavis/src/othello`, run

```bash
python3 notes/2026-07-20-c411-double-coset-hecke.py --check
python3 notes/2026-07-20-c411-double-coset-hecke-replay.py
sha256sum -c notes/2026-07-20-c411-double-coset-hecke.sha256
```

The matching-decorated parent bijection and exact \(A_5\) stabilizer are
certified by
`notes/2026-07-19-c379-clebsch-deep-hole-extension.{md,py,json,sha256}` and
its independent replay. From the same directory, run

```bash
python3 notes/2026-07-19-c379-clebsch-deep-hole-extension.py --check
python3 notes/2026-07-19-c379-clebsch-deep-hole-extension-replay.py
sha256sum -c notes/2026-07-19-c379-clebsch-deep-hole-extension.sha256
```

The binary cubic factorization, Hessian, and exact boundary of the resulting
target flag are certified by
`notes/2026-07-20-c412-relative-cubic-depth-plane.{md,py,json,sha256}` and
its independent replay:

```bash
python3 notes/2026-07-20-c412-relative-cubic-depth-plane.py --check
python3 notes/2026-07-20-c412-relative-cubic-depth-plane-replay.py
sha256sum -c notes/2026-07-20-c412-relative-cubic-depth-plane.sha256
```

All three primary checks, independent replays, and checksum manifests passed
on 2026-07-25. Their reports record the exact inputs, byte counts, SHA-256
hashes, and trusted boundaries. The manuscript build command is

```bash
cd /home/tavis/src/othello/papers
make -B clebsch-factorization
```

The resulting twelve-page PDF is warning-free.

## Boundaries

The subgroup-mark argument and the consequences of \(K\)-equivariance and
\(J\)-negation are conceptual. The six representative incidence rows and
the equality of parent and matching stabilizers are exact finite inputs.
The theorem does not say that the profile map is a faithful linear quotient:
its function space has six double-coset basis elements while the displayed
linear image has rank two. It is faithful only on the six labels as a set.
Nor does it reconstruct an individual matching from a size-four or size-six
profile.

## `ej` + `tt` closeout and mystery ledger

The closeout exposed one cheap but necessary refinement: the profile theorem
uses an ordered golden pair and a scalar-\(A_4\) refinement that the balanced
quotient configuration does not intrinsically select. The manuscript now
states this before the theorem. It also replaces a bare appeal to finite
injectivity by the exact stabilizer mechanism: parent and obstruction
matching have the same \(A_5\) stabilizer, so their equivariant \(G/H\) map is
a bijection.

The explicit `ej` follow-up adds two reversible consequences. First, relative
to the oriented cell pairs, the profile is a pointwise sheet classifier; the
antipodal singleton pair recovers the unordered golden parent pair. This does
not revive the failed linear sheet sign because the profile uses decorated
zero-incidence data rather than a linear functional on the affine quotient.
Second, even after orientation is forgotten, the three rational profile rays
recover their own orbit multiplicities through the primitive positive
dependence \(1:4:6\).

The same integer table exposes the bad primes for the next arithmetic section.
The gcd of its nonzero \(2\times2\) minors is \(3\), so the profile plane drops
rank only in characteristic \(3\). The six signed vectors remain distinct
away from characteristics \(2\) and \(3\); characteristic \(2\) identifies
antipodes, while characteristic \(3\) sends \(v_1\) and \(v_2\) to zero.
This is presently a statement about reduction of the integral profile table,
not an all-characteristic geometric construction.

The explicit `tt` pass removes one more finite-looking step. A general
three-ray lemma now proves that over characteristic different from \(2,3\),
any nonzero weighted relation among three rays spanning a plane forces the
signed antipodal cubic to be nonzero: in a basis \(u_1,u_2\), the
\(u_1^{\odot2}\odot u_2\) coefficient is
\(-3n_1^2n_2/n_3^2\). Thus the compressed H3 cubic follows conceptually from
rank two and the \(1:4:6\) dependence. The former coordinate witness `6` is
retained only to pin the frozen normalization.

The second-order `ej2` pass asks what the forced cubic itself reconstructs.
It yields a general mass-zero factorization. For three spanning rays with
nonzero weights \(n_i\), both
\[
\sum_i n_i u_i=0\qquad\text{and}\qquad \sum_i n_i=0
\]
force the cubic to have type \(L^2R\), with \(L\ne R\); explicitly,
\[
\sum_i n_i u_i^{\odot3}
=\frac{n_1n_2}{(n_1+n_2)^2}(u_1-u_2)^{\odot2}
 \odot\bigl((2n_1+n_2)u_1+(n_1+2n_2)u_2\bigr).
\]
Thus the doubled line is forced here by the modular identity
\(1+4+6=11=0\), not by an accidental coordinate factorization. In the
profile basis \(e_1=v_2,e_2=v_3\), the normalized binary form is
\[
(x-y)^2(x-2y),
\]
and its Hessian is a nonzero scalar multiple of \((x-y)^2\). The compressed
cubic therefore carries an intrinsic target flag: a doubled line recovered
by the Hessian and a residual simple line. This is more structure than a
nonzero orientation carrier, but it remains output-side structure. C412
proves that it does not canonically identify the three-dimensional source
relative-cubic space with the two-dimensional profile plane, and the profile
partition does not admit a descended \(\operatorname{PSL}_2(11)\)-action.

| mystery | status | exact remaining gap or owner |
|---|---|---|
| Does the bare affine quotient intrinsically select the four oriented profile coordinates? | settled negatively for the present theorem | The manuscript now treats them as relative to the selected ordered golden pair; no intrinsic selection is claimed. |
| Why can rank-two data recover six rows? | settled | The six displayed vectors are pairwise distinct; linear rank does not control set-theoretic separation. |
| Why does a singleton profile recover a parent rather than only a matching? | settled | C379 certifies the common \(A_5\) stabilizer, making the equivariant decorated transform a bijection. |
| Do the unlabeled profile rays retain the group-theoretic orbit sizes? | settled | Their unique primitive positive rational dependence is \(1:4:6\), which also gives stabilizer orders \(12,3,2\). |
| Is compressed cubic nonvanishing an additional finite calculation? | settled | No. The three-ray cubic lemma forces it from rank two and the nonzero \(1:4:6\) relation in characteristic \(11\). |
| Why does the compressed cubic retain a doubled-line/simple-line flag? | settled | The orbit weights have total mass \(1+4+6=0\) in \(\mathbb F_{11}\); the general mass-zero cubic identity forces type \(L^2R\), and the Hessian recovers \(L^2\). |
| Does that flag canonically reconstruct the full relative-cubic source? | settled negatively | C412's covariance and non-descent tests leave no canonical source-to-target map; the flag is internal to the profile plane. |
| What do the exceptional primes \(2,3\) mean geometrically? | open | Exact reduction of the integral profile table isolates them, but C577's modular-depth section must decide whether this is part of the arithmetic gluing theorem or only degeneration of this coordinate realization. |
| Can the six representative incidence rows be derived without finite coordinate counts? | open, nonblocking | C411 reduces the computation to one representative per double coset but still certifies those six rows. A conceptual incidence derivation would be a trust-boundary upgrade, not a prerequisite for the present statement. |
| What is the next load-bearing Paper II frontier? | open by task order | C577 next drafts modular depth and arithmetic splitting/gluing. C616 separately owns the nonblocking coordinate-free radial-trace and equivariant rank upgrade. |
