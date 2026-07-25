# C577 — Clebsch factorization-memory Paper II

**Lane:** `clebsch`

**Date:** 2026-07-25

**Status:** `IN PROGRESS; VERIFICATION/CONCLUSION LOCAL GATE GREEN; COLD REVIEW NEXT`

## Current result

Paper II now has its own verification architecture and mathematical
conclusion. The sixteen theorem-like statements are hash-identified and
mapped claim by claim to conceptual proofs, classical inputs, six exact
certificate bundles, and the arithmetic-gluing Lean gate. The aggregate
runner checks the statement map, all six checksum manifests, eleven primary
or independent executable routes, and the manuscript build. Its clean replay
is green.

The conclusion records the exact reconstruction ladder: linear harmonic and
radial memory, unordered balanced sheets, cubic orientation, and---after a
selected \(A_4\) refinement---the matching-table label. It also closes the
three boundaries a referee could otherwise misread: nonsingleton profiles
recover only orbits, the relative-cubic and depth planes have no natural
identification, and the three small-field split/fused rows do not imply an
all-prime reciprocity law. The candidate is warning-free at seventeen pages.

Paper II now contains its full change-of-characteristic section.  On one
\(H_3\) sheet, the characteristic-eleven permutation module
\[
V=\mathbb F_{11}[X_+]\simeq
\operatorname{Ind}_{A_5}^{\operatorname{PSL}_2(11)}\mathbf1
\]
is the projective cover \(P(\mathbf1)\) with Loewy dimensions
\(1\mid9\mid1\).  Its \(A_4\)-fixed subspace has orbit-indicator basis of
sizes \(1,4,6\).  Linearized depth sends those indicators to
\(v_1,4v_2,6v_3\), so the primitive relation
\(v_1+4v_2+6v_3=0\) identifies its kernel with the constant socle and gives
\[
P(\mathbf1)^{A_4}/\operatorname{soc}P(\mathbf1)
\simeq \langle v_1,v_2,v_3\rangle.
\]
The manuscript separates this rank-two linear quotient from the
set-theoretic six-row classifier.

The same section gives a standalone split--inert calculation.  The
\(A_3\) marker \(t^2-2\) is irreducible over \(\mathbb F_5\), while the
\(B_3\) marker splits over \(\mathbb F_7\) and the \(H_3\) golden marker
\(t^2-t-1\) splits over \(\mathbb F_{11}\).  Exact arithmetic
representatives are now displayed rather than left implicit.  The \(H_3\)
stabilizers glue as
\[
A_5\cap A_5=A_4,\qquad
\langle A_5,A_5\rangle=\operatorname{PSL}_2(11),
\]
with a nonsquare-determinant transporter and rational \(S_4/A_4\) hinge.
The determinant character simultaneously exchanges the rational sheets
and negates the depth profiles, so a split root chooses a sheet and its
singleton profile chooses the decorated matching row.

The relative-cubic Tate plane now appears in an appendix, not in the main
gluing argument.  Invariants and coinvariants form the exact rank pattern
\[
R\xrightarrow{\pi}M_G\xrightarrow{N}R,\qquad
\operatorname{rank}\pi=2,\quad\operatorname{rank}N=1,
\]
with common kernel/image line \([1:3:9]\).  Semi-invariant contraction
constructs the same quotient.  The appendix also proves the boundary:
the labelled source classes have relation \([2,9,1]\), the depth profiles
have relation \([2,8,1]\), and divided transfer kills the former balanced
relations while fixing the latter socle.  No natural source-to-depth map
is claimed.

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
uses existing atomic evidence bundles.

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

The split--inert rows, matching representatives, sheet exchanges,
stabilizer/intersection data, \(660\)-element generation closure, and
nonsquare-determinant transporters are certified by the stable
arithmetic-gluing bundle and its Lean gate.  The workflow compatibility
entry point and hash check are

```bash
python3 notes/2026-07-22-c503-clebsch-arithmetic-gluing-lean.py --check
sha256sum -c notes/2026-07-22-c503-clebsch-arithmetic-gluing-lean.sha256
```

The C412 primary check, independent replay, and checksum manifest, and the
C503 compatibility check and checksum manifest, passed again on 2026-07-25.
The earlier C411 and C379 checks remain the six-profile evidence surface.
Their reports record the exact inputs, byte counts, SHA-256 hashes, and
trusted boundaries. The manuscript build command is

```bash
cd /home/tavis/src/othello/papers
make -B clebsch-factorization
```

The resulting seventeen-page PDF is warning-free. The Paper II aggregate
entry point is

```bash
python3 papers/clebsch-factorization/verification/verify_release.py
```

It passed on 2026-07-25, including all six evidence bundles and the clean
manuscript build. A separate guarded elaboration of
`RelativeConicArcs/Gates/ClebschArithmeticGluing.lean` also passed with the
recorded axiom surface.

## Boundaries

The subgroup-mark argument and the consequences of \(K\)-equivariance and
\(J\)-negation are conceptual. The six representative incidence rows and
the equality of parent and matching stabilizers are exact finite inputs.
The theorem does not say that the profile map is a faithful linear quotient:
its function space has six double-coset basis elements while the displayed
linear image has rank two. It is faithful only on the six labels as a set.
Nor does it reconstruct an individual matching from a size-four or size-six
profile.

The modular proposition is mixed rather than purely conceptual. Projectivity,
locality of the two-dimensional commuting algebra, exactness of \(A_4\)-fixed
points, and the socle quotient are human arguments. Absolute irreducibility
of the nine-dimensional middle layer is an exact generator-matrix check.
The arithmetic theorem proves only the three frozen small-field models.
Classical \(S_4,A_5,A_4,\operatorname{PSL}_2(11)\) names are cited inputs;
orders alone are not used to infer them. No all-prime reciprocity, spinor
norm, integral cubic lift, or passage/torsor theorem enters Paper II.

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

The modular/gluing `ej` pass made the integral relation carry two jobs instead
of repeating it: over \(\mathbb F_{11}\) it is exactly the statement that
linearized depth kills the constant orbit indicator, while over
\(\mathbb Q\) it recovers the orbit multiplicities from the profile rays. It
also promoted the cheap bad-prime audit into a bounded remark: the integral
profile plane drops rank only in characteristic \(3\), and the signed labels
degenerate only in characteristics \(2,3\). The paper explicitly declines
to reinterpret those reductions as marked-conic geometries.

The corresponding `tt` pass exposed two referee traps and repaired both.
First, the arithmetic marker polynomials did not by themselves define their
matching models; the paper now displays the second \(B_3\) and \(H_3\)
representatives and states the exact projective-orbit seam. Second, putting
the canonical relative-cubic plane next to the depth quotient could suggest
an identification. The source construction has therefore moved to an
appendix whose closing remark gives the unequal relation lines and
divided-transfer obstruction.

The verification/conclusion `ej` pass turned the inherited computations into
one paper-specific audit surface. Semantic bundle names now keep workflow
identifiers out of the manuscript, and the conclusion uses the refinement
boundary positively: exact row recovery is a relative theorem, not an
intrinsic choice of orientation. The cheap extra value is a single replay
command that simultaneously detects theorem-statement drift, evidence-hash
drift, and a broken PDF build.

The matching `tt` pass tested the final paragraph against the strongest
plausible overreading. Saying that the conic ideal remembers a
matching-table label would be false without the selected \(A_4\) refinement;
the conclusion now carries that hypothesis in the same sentence. The pass
also separated the genuinely canonical outputs---the unordered sheets and
the two individual planes---from the noncanonical comparison between them.
A local referee-style coherence read found no internal theorem-order,
proof-mode, or conclusion mismatch. Independence remains the purpose of the
next context-free review rather than a hidden claim about this pass.

The `ej3` verification-hardening pass found that checksum validation alone
did not freeze the aggregate runner's admitted commands or proof-mode
vocabulary. The runner now rejects schema drift, evidence-set drift, changed
commands or checksum manifests, unsafe or duplicate checksum targets, unknown
proof modes, certificate claims with no evidence, and Lean claims with no
Lean bundle. This closes a cheap auditability gap without adding a new
mathematical claim or enlarging the release surface.

| mystery | status | exact remaining gap or owner |
|---|---|---|
| Does the bare affine quotient intrinsically select the four oriented profile coordinates? | settled negatively for the present theorem | The manuscript now treats them as relative to the selected ordered golden pair; no intrinsic selection is claimed. |
| Why can rank-two data recover six rows? | settled | The six displayed vectors are pairwise distinct; linear rank does not control set-theoretic separation. |
| Why does a singleton profile recover a parent rather than only a matching? | settled | C379 certifies the common \(A_5\) stabilizer, making the equivariant decorated transform a bijection. |
| Do the unlabeled profile rays retain the group-theoretic orbit sizes? | settled | Their unique primitive positive rational dependence is \(1:4:6\), which also gives stabilizer orders \(12,3,2\). |
| Is compressed cubic nonvanishing an additional finite calculation? | settled | No. The three-ray cubic lemma forces it from rank two and the nonzero \(1:4:6\) relation in characteristic \(11\). |
| Why does the compressed cubic retain a doubled-line/simple-line flag? | settled | The orbit weights have total mass \(1+4+6=0\) in \(\mathbb F_{11}\); the general mass-zero cubic identity forces type \(L^2R\), and the Hessian recovers \(L^2\). |
| Does that flag canonically reconstruct the full relative-cubic source? | settled negatively | C412's covariance and non-descent tests leave no canonical source-to-target map; the flag is internal to the profile plane. |
| What do the exceptional primes \(2,3\) mean geometrically? | settled for Paper II's boundary | The manuscript records only degeneration of the integral profile table and explicitly makes no all-characteristic marked-conic construction. A geometric reinterpretation would require a separately owned theorem. |
| Does the canonical relative-cubic Tate plane identify with the modular depth plane? | settled negatively for the natural labelled routes | Their relation lines are \([2,9,1]\) and \([2,8,1]\); divided transfer kills balanced source relations and fixes the depth socle. The appendix claims no canonical map. |
| Are the quadratic marker polynomials enough to specify the arithmetic matching models? | settled | No; the manuscript now displays the additional \(B_3\) and \(H_3\) representatives and marks projective transport into the configurations as exact finite evidence. |
| Can the six representative incidence rows be derived without finite coordinate counts? | open, nonblocking | C411 reduces the computation to one representative per double coset but still certifies those six rows. A conceptual incidence derivation would be a trust-boundary upgrade, not a prerequisite for the present statement. |
| Does the conclusion accidentally make relative row recovery intrinsic? | settled | It now says explicitly that exact label recovery occurs only after the \(A_4\) refinement is selected. |
| Is every theorem-like statement assigned one exact trust route? | settled | The sixteen-row statement identity and trust manifest form an exact partition; the aggregate checker rejects omissions, duplicates, stale statements, and stale evidence hashes. |
| Can the aggregate manifest silently redirect a checker or checksum target? | settled | The release runner now freezes the six semantic bundles, exact command vectors, manifest paths, proof modes, and safe repository-relative checksum targets. |
| Can Paper II's verification surface ship independently of the full repository? | open, release-facing | The semantic manifest currently resolves six bundles through dated `notes/` paths. Before a standalone archive is cut, either vendor those closures under stable paper-owned paths or define and test an explicit full-source packaging allowlist. This does not block the candidate cold review. |
| What is the next load-bearing Paper II frontier? | open by task order | Obtain a fresh context-free referee-style coherence review of the seventeen-page candidate and repair any findings before closing C577. C616 separately owns the nonblocking coordinate-free radial-trace and equivariant rank upgrade. |
