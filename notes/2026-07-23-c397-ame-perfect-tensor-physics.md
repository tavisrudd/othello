# C397 — exact AME Clifford phase, signed-sheet separation, and q=13 LU theorem

**Lane:** `crowns`

**Date:** 2026-07-23

**Status:** complete; positive operational theorem

**Literature depth:** two inherited sources were read at `full text`, one source was read
`partial`, and two additional sources were consulted at `abstract/metadata only`.

## Result

C397 closes positively on all three required fronts.

1. The fixed-party local-Clifford kernel gives a uniform operational GRS/non-GRS dichotomy.  For
   an equal-phase CSS state from a six-arc `A` over an odd field,

   ```text
   fixed-party symplectic kernel =
       SL_2(q)                 if A is conic/GRS,
       split torus F_q^*       if A is nonconic.
   ```

   Thus every encoder view of a GRS tensor admits the full one-qudit logical Clifford group from
   fixed-party tensor symmetries, while a non-GRS view admits only the split torus before
   party-moving isodualities are added.  At q=11 the exact full logical symplectic groups are
   `SL_2(11)` of order 1320 for all four GRS orbits and the split-torus normalizer of order 20 for
   both non-GRS classes.  This is a local logical-gate distinction, not merely a classical
   automorphism count.

2. C396's signed coordinate `w=B/A`, `z=w^2`, is none of the three suggested torsors.  The Gale
   transform fixes `w`; the Paper-1 determinant torsor is a parity character whereas both even and
   odd party permutations flip `w`; and C546's odd Fourier-isodual pentad swap fixes `w`.
   Moreover the Gale cover branches on the conic divisor `z=-1/4`, while `w -> z` branches at
   `w=0,infinity`.  The `w` sign is an LC-forgettable bracket marking, exchanged by an explicit
   monomial local Clifford, and has no quantum readout.

3. The two q=13 classes in C396's arbitrary-LU moment bucket are nevertheless **arbitrarily
   LU-inequivalent, even after every party permutation**.  Complete two-copy contraction data
   leaves all 720 party permutations; complete three-copy data leaves 48.  Two explicit
   four-copy permutation contractions eliminate those 48: the normalized contraction ranks are
   `21` and `20`, hence their invariant values are respectively `13^-9` and `13^-8`.  This is the
   theorem exit required by the staged LU ladder, not another pilot statistic.

The positive Stage-A invariant survives Stage B.  The characteristic-17 GRS/`S4` specialization
retains the full `SL_2(17)` kernel, while the characteristic-31 non-GRS/`A5` specialization retains
only the split torus of order 30.  The arithmetic party-symmetry jumps therefore do not erase the
GRS/non-GRS logical-Clifford phase.

## Exact q=11 party-permuting Clifford groups

Write `L_C=C_X direct-sum C^perp_Z` for the six-dimensional Lagrangian of the equal-phase CSS
state.  Global phase is quotiented.  The projective Pauli stabilizer has order `11^6`; the table
records the symplectic quotient and its party projection.

| tensor | symplectic order | party image | fixed-party kernel | logical group in each view |
|:---|---:|---:|---:|:---|
| non-GRS `t=2`, `z=1` (H3/Clebsch) | 1200 | 120 (`S5`) | 10 | `N(T)`, order 20 |
| non-GRS `t=10`, `z=9` | 240 | 24 (`S4`) | 10 | `N(T)`, order 20 |
| GRS orbit 330 | 5280 | 4 | 1320 | `SL_2(11)`, order 1320 |
| GRS orbit 264 | 6600 | 5 | 1320 | `SL_2(11)`, order 1320 |
| GRS orbit 220 | 7920 | 6 | 1320 | `SL_2(11)`, order 1320 |
| GRS orbit 110 | 15840 | 12 | 1320 | `SL_2(11)`, order 1320 |

Here `T={diag(a,a^-1):a in F_11^*}`.  Including logical Paulis, each non-GRS encoder view realizes
a projective logical Clifford subgroup of order `121*20=2420`; every GRS view realizes the full
projective one-qudit Clifford group of order `121*1320=159720`.

The complete projective local-Clifford stabilizer is

```text
F_11^6 semidirect G_symp,
```

where `G_symp` is generated explicitly in the certificate.  Its orders for the six rows are
respectively

```text
2,125,873,200; 425,174,640;
9,353,842,080; 11,692,302,600; 14,030,763,120; 28,061,526,240.
```

### Why the kernel theorem is exact

Every four-party support `S` carries a two-dimensional shortened stabilizer `K_S`, and projection
from `K_S` to the Pauli plane of any party in `S` is an isomorphism.  A party permutation and one
anchor block in `SL_2(q)` therefore force all other local blocks.  Checking all support overlaps
is both necessary and sufficient; the checker also tests the resulting transformation against
the full Lagrangian row space.

For the identity party permutation, diagonal blocks always give the split torus.  Any block with
a nonzero off-diagonal coefficient forces a coordinatewise scaling identification of `C` with
`C^perp`, equivalently fixes the labelled arc under Gale association.  C483 identifies that fixed
divisor exactly as the conic locus.  On it, the GRS dual multipliers let every anchor block in
`SL_2(q)` propagate through site-dependent conjugations; off it, only the diagonal anchors
propagate.  This proves the all-odd-field kernel dichotomy without extrapolating from q=11.

## Operator pushing

For any input leg and any nonidentity Pauli label, projection from `K_S` at that leg is invertible
for each of the ten four-subsets `S` containing it.  Hence the Pauli has exactly ten
minimum-support pushes, each on three of the five output legs.  The minimum output support is
exactly three, as required by the `[[5,1,3]]_11` distance.

There are

```text
6 * (11^2-1) * 10 = 7200
```

labelled minimum pushing relations.  Their full tensor-automorphism orbit sizes are:

| tensor | pushing-orbit profile |
|:---|:---|
| non-GRS `t=2` | `600^12` |
| non-GRS `t=10` | `120^12, 240^24` |
| GRS orbit 330 | `240^2, 480^14` |
| GRS orbit 264 | `600^12` |
| GRS orbit 220 | `720^10` |
| GRS orbit 110 | `720^2, 1440^4` |

Thus minimum support itself is forced by the AME parameters, but its orbit decomposition is not.
It separates several classes, though not all; the logical-kernel theorem separates both non-GRS
classes from every GRS class uniformly.

## The signed bracket coordinate and the three false identifications

Put

```text
A=-4t(t-1)^2,
B=(t^2-t+1)(t^2-3t+1),
w=B/A,
z=w^2.
```

In the ten signed complementary-triple bracket coordinates, ordered by the partition containing
party 1, the pencil is

```text
(A,A,-A,-A,-A,-B,B,B,-B,A).
```

A five-coordinate bracket basis is therefore

```text
([123][456], [124][356], [135][246], [136][245], [145][236])
   = (A,A,-B,B,B).
```

This is the requested classical bracket/mystic-pentagon presentation: the pencil is a projective
line in the five-dimensional bracket space, and `w` is its signed ratio.

For C481's labelled projection-sextic chart, let the centre be `u=(r,s,v)` and
`d_ij=det(u,h_i,h_j)`.  All thirty coordinates are

```text
R1_ijkl=d_ij d_kl/(d_ik d_jl),
R2_ijkl=d_ij d_kl/(d_il d_jk).
```

The fifteen linear brackets are recorded coefficientwise in the certificate.  For example,

```text
d12=2(t-1)r,
d13=-(t-1)^2 r-(t-1)s-v,
d14= (t-1)^2 r-(t-1)s-v,
d23= (t-1)^2 r+(t-1)s-v,
d24=-(t-1)^2 r+(t-1)s-v,
d34=2(t-1)v,
```

and C481's minimal labelled coordinates are

```text
(R2_1234,R2_1235,R2_1236).
```

The remaining nine `d_ij` and all thirty derived ratios are generated exactly in the JSON; no
square root or choice of Gale sheet occurs in these labelled projection coordinates.

### Exact Gale action

Choose the Gale generator with free kernel coordinates in columns 4,5,6.  The fixed odd
permutation

```text
p=(3 5 4 6)                 (one-based)
```

and

```text
T = [1  -1   -1]
    [0  1-t  t-1]
    [t   0    0]
```

satisfy, column by column,

```text
T G_j = lambda_j H_p(j),
lambda=(t,-t,1,1,-1,-1).
```

Here `det(T)=-2t(t-1)` and the displayed Gale basis has sole denominator `2(t-1)`.  Thus the
identity is valid over every odd field on the admitted pencil.  Complementary Pluecker minors
are exchanged under Gale duality, so each product `[I][I^c]`, and hence `A,B,w`, is fixed.

This separates the covers in four independent ways:

| candidate | concrete mismatch with `w -> -w` |
|:---|:---|
| PRS Gale sheet | Gale fixes `w`; its branch is the conic divisor `z=-1/4`, not `w=0,infinity` |
| Paper-1 determinant torsor | `w`-flip has both the odd permutation `(5 6)` and the even permutation `(3 5)(4 6)`, so it is not the `PGL/PSL` sign character |
| C546 pentad orientation | C546's odd Fourier-isodual permutation `(3 5 4 6)` fixes `w`, while an even permutation flips it |

The exceptional arithmetic is sharp.  Characteristic two destroys the sign linearization and the
Gale matrix above.  The admitted odd pencil removes `t=0,1`; `B=0` and `A=0` are precisely the
zero and pole branch of `w -> w^2`, while the conic/GRS quartic remains the separate Gale fixed
divisor.

Because the two explicit `w`-flipping permutations come with projective column scalings, they lift
to monomial local Cliffords.  Therefore the sign of `w` is not intrinsic LC or LU data, cannot be
read by any encoder logical action or pushing orbit, and is only a classical bracket marking.

## Exact q=13 arbitrary-LU separation

For `m` ket copies and `m` bra copies, assign a permutation `sigma_i in S_m` at each party and
contract the corresponding local indices.  This is an arbitrary-LU invariant.  For the normalized
equal-phase state of a three-dimensional linear code `C`, its value is

```text
I_sigma(C)=q^(3m-rank M_sigma(C)),
```

where `M_sigma` is the explicit `6m by 6m` linear matching system for the `m` ket and `m` bra
message vectors.  The formula follows by counting its finite-field solution space, so the
certificate evaluates the complex tensor contraction using exact finite linear algebra.

Common bra-copy relabelling normalizes `sigma_1=id`.  The exact ladder is:

| copies `m` | normalized contractions | party permutations still compatible |
|---:|---:|---:|
| 2 | `2^5=32` | 720 |
| 3 | `6^5=7776` | 48 |
| 4 | two explicit contractions applied to the 48 survivors | 0 |

For every one of the 48 degree-three survivors, one of the two stored degree-four patterns gives
rank `21` on the `t=2,z=4` class and rank `20` on the relabelled `t=3,z=12` class.  Therefore its
values are `13^(12-21)=13^-9` and `13^(12-20)=13^-8`.  An LU equivalence after party permutation
would preserve every such contraction, so none exists.

This also explains why the earlier pilots stalled: all subsystem purities (two copies), the full
three-copy rank histogram, and C396's selected marginal moment collide.  The first exact
separator occurs here at four copies within the tested contraction hierarchy.  No claim of global
degree minimality is made beyond the complete two- and three-copy checks.

## Evidence and replay

From the repository root:

```bash
python3 notes/2026-07-23-c397-ame-perfect-tensor-physics.py --check
sha256sum -c notes/2026-07-23-c397-ame-perfect-tensor-physics.sha256
```

The deterministic checker imports hash-pinned C374 and C396 arithmetic.  It:

- exhausts all `720*1320=950400` party/anchor candidates for each of six q=11 tensors;
- verifies every passing candidate against the complete Lagrangian row space;
- independently closes the recorded generators and recovers the enumerated group;
- computes all six logical images and all 7200 minimum pushing relations;
- verifies the ten symbolic bracket products, fifteen projection brackets, and exact symbolic
  Gale isoduality, with independent finite replay at q=11,13,101; and
- exhausts all 720 party permutations through the complete two- and three-copy q=13 contraction
  sets, then checks the two exact four-copy separators on the 48 survivors.

The trusted boundary is finite-field Gaussian elimination, exact rational polynomial arithmetic,
the standard stabilizer/Clifford symplectic dictionary, and the elementary copy-permutation
contraction proof above.  The support-propagation enumeration and full-row-space verification are
independent internal checks; the symbolic Gale identity and finite canonical-projective replay are
likewise separate.  A second external implementation was not added because the q=13 conclusion
reduces to two displayed ranks of explicit matrices, while the exhaustive wrapper is only the
party-permutation closure.

The checksum table is maintained in the adjacent `.sha256` manifest.

## Literature boundary

This report makes no priority claim.  Its positioning consumes the following sources.

- Howard--Millson--Snowden--Vakil, arXiv:0710.5916.  **Read depth: `full text`**, inherited from
  C396's audit, Sections 1--2, cached version and hashes recorded there.  They own the ambient
  bracket, outer-`S6`, Igusa-quartic, and Gale invariant theory.
- Van den Nest--Dehaene--De Moor, arXiv:quant-ph/0410165.  **Read depth: `full text`**, inherited
  from C396's audit.  They own abstract complete local-Clifford invariant families for stabilizer
  states.
- Burchardt--Raissi, arXiv:2003.13639.  **Read depth: `partial`**, Sections III--IV,
  Propositions 2,5,6, Remark 1, and the adjacent dimension table, cached SHA-256
  `7b38bd6a5bd8fb8299863e5ca3c7f64dfadd51a12f1b865edbbcbc3d4847a9e3`.  Their results place
  six-party local dimensions 11--16 at the first saturated minimal-support boundary where
  nonmonomial LU behaviour cannot be dismissed by the simpler rigidity criterion.
- Hanson Hao, *Investigations on Automorphism Groups of Quantum Stabilizer Codes*,
  arXiv:2109.12735.  **Read depth: `abstract/metadata only`**, arXiv metadata consulted
  2026-07-23.  It supplies broad prior-art context for strong, weak, and Clifford-twisted
  automorphism groups; no theorem from it is load-bearing here.
- Pastawski--Yoshida--Harlow--Preskill, arXiv:1503.06237.
  **Read depth: `abstract/metadata only`**, arXiv metadata consulted 2026-07-23.  It owns the
  perfect-tensor holographic-code setting and multiple boundary representations of logical
  operators; C397 makes no tensor-network performance claim.

C374/C375 already own the AME--MDS--QECC dictionary, the fixed q=11 LU separation from GRS, the
six encoder views, and the twenty multiunitary flattenings.  C397's defensible contribution is the
restricted exact synthesis above: a conic/Gale criterion becomes a logical-Clifford phase, the
signed bracket sheet is proved operationally forgettable, and a four-copy contraction resolves
the one q=13 LU collision.  No claim is made to a new general LU=LC theorem, new perfect-tensor
dictionary, or new holographic construction.

## `ej`/Tao closeout and mystery ledger

The closeout produced two upgrades beyond the original pilot.  First, the q=11 numerical kernel
gap is the specialization of an all-odd-field conic/Gale theorem, so the characteristic-17/31
phase is explained without a new census.  Second, the q=13 attack ladder did not stop at
minimal-support rigidity: complete low-copy contractions exposed the first successful rung and
gave an arbitrary-LU theorem.

| feature | disposition |
|:---|:---|
| Why every GRS logical group is much larger | **Settled:** conic arcs are exactly the labelled Gale fixed locus, giving the off-diagonal generator that enlarges the torus to `SL_2(q)`. |
| Whether the q=11 non-GRS distinction is just party symmetry | **Settled negatively:** the fixed-party kernel already separates GRS from non-GRS in every encoder view. |
| Whether minimum pushing support distinguishes the classes | **Settled negatively:** support three is forced for all; only orbit profiles vary, and one non-GRS/GRS pair shares `600^12`. |
| Whether `w` is the PRS Gale sheet | **Settled negatively:** Gale fixes `w` and has a different branch divisor. |
| Whether `w` is the Paper-1 determinant or pentad bit | **Settled negatively:** its flip is not parity, and the odd Fourier-isodual pentad swap fixes it. |
| Whether `w` is operationally readable | **Settled negatively:** explicit monomial local Cliffords exchange the signs. |
| Whether the q=13 moment collision is an LU collision | **Settled:** the two classes are arbitrarily LU-inequivalent; degree-four copy contractions separate them after all party permutations. |
| Whether degree four is globally minimal | **Open only as an invariant-compression question:** complete copy degrees two and three fail, but another non-copy-contraction invariant of lower polynomial degree was not classified. No successor is required for C397. |

No exit-condition mystery remains.

## Vibe check

Excellent.  The task found a clean operational phase rather than a larger automorphism table, the
signed-sheet analogy dissolved into exact mismatches, and the difficult q=13 collision ended in a
short arbitrary-LU certificate rather than an external-open-lemma retreat.
