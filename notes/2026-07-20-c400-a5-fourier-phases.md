# C400 — arithmetic phases of the scalar-`A5` Fourier schemes

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; UNIFORM BURNSIDE RANK/ORBIT LAW AND SIX CONIC-RELATION PHASES;
FLAGSHIP PRE-EMPTED`

## Result

Let `O=Z[tau]`, `tau^2-tau-1=0`, and reduce C346's integral three-dimensional
icosahedral representation modulo an odd prime ideal `P`.  Write `k=O/P`, `q=|k|`, and

```text
H = k^* x A5 <= GL_3(k).
```

The `H`-orbits on the additive syndrome space `V=k^3` are the relations of a primitive symmetric
translation association scheme.  Put

```text
e3 = 1  if char(k) != 3 and q = 1 mod 3, and 0 otherwise;
e5 = 1  if char(k) != 5 and q = 1 mod 5, and 0 otherwise.
```

Apart from zero, its projective orbit types and numbers are exactly

| point stabilizer | projective orbit size | number of orbits |
|:---|---:|---:|
| `D5` | 6 | 1 |
| `S3` | 10 | 1 |
| `V4` | 15 | 1 |
| `C2` | 30 | `(q-5)/2` |
| `C3` | 20 | `e3` |
| `C5` | 12 | `e5` |
| `1` | 60 | `((q-5)(q-9)-20e3-12e5)/60` |

Every projective orbit of size `s` lifts to a relation of valency `(q-1)s`.  Consequently the
scheme rank, including zero, is

```text
r(q) = 4 + (q-5)/2 + e3 + e5
           + ((q-5)(q-9)-20e3-12e5)/60
     = (q^2+16q+135+40e3+48e5)/60.
```

The mandated fields have ranks

```text
q:       5   9   11   19   29
r(q):    4   6    8   14   24,
```

and the natural completion at `q=59` has rank `76`.

The invariant form identifies `V` with its character group.  The contragredient of a scalar times
an `A5` matrix is another element of the same scalar closure, so primal and dual orbit partitions
agree in the same ordering.  For a relation containing `ell` projective lines, if exactly `z` are
perpendicular to a character direction, the eigenvalue is the exact integer

```text
q*z-ell.
```

Thus every scheme is Fourier self-dual, `P=Q`, and the Krein and intersection tensors agree under
this orbit identification.  This self-duality is standard; the portable content is the exact rank,
orbit-type, conic-role, and code/deep-hole phase synthesis below.

## The six invariant-conic relation phases

The invariant conic `X^2+Y^2+Z^2=0` has the following projective `A5` orbit counts.  Let

```text
d5 = [char(k)=5],                 d3 = [char(k)=3],
a2 = [char(k) not in {3,5} and q=1 mod 4],
a3 = e3,                          a5 = e5,
a1 = (q+1-6d5-10d3-30a2-20a3-12a5)/60.
```

Then its constituent stabilizer types occur with multiplicities

```text
D5:d5, S3:d3, C2:a2, C3:a3, C5:a5, 1:a1.
```

It is a single scalar-`A5` relation exactly at

| `q` | conic stabilizer | scheme rank | relation role |
|---:|:---|---:|:---|
| 5 | `D5` | 4 | the six source-code columns; the parent is GRS |
| 9 | `S3` | 6 | the ten triple-ambiguity points; the deep locus is empty |
| 11 | `C5` | 8 | the twelve projective deep holes; the child is GRS |
| 19 | `C3` | 14 | a twenty-point deep-hole constituent |
| 29 | `C2` | 24 | a thirty-point mirror constituent, hence not deep |
| 59 | `1` | 76 | a regular sixty-point deep-hole constituent |

Indeed transitivity forces `q+1` to divide `|A5|=60`; the possible odd good residue fields give
exactly `5,9,11,19,29,59`, and the formula above proves the converse.  The stabilizer ladder is

```text
D5, S3, C5, C3, C2, 1
```

with orders `10,6,5,3,2,1`.

C341's source code is uniformly the `D5` relation of valency `6(q-1)`.  C368's projective
deep-hole locus is the complement of the fifteen secants and has size `(q-5)(q-9)`; in this scheme
it is exactly the union of the `C3`, `C5`, and free relations.  Hence it is empty at `q=5,9`, one
`C5` relation at `q=11`, a `C3` relation plus two regular relations at `q=19`, eight regular
relations at `q=29`, and forty-five regular relations at `q=59` (one of which is the conic).

## Primitivity and fusions

No nonzero projective orbit has size one.  By Fourier self-duality the representation has neither
an invariant line nor an invariant plane, so the affine translation schemes are primitive at every
odd good reduction.

The full projective orthogonal group fuses the scalar-`A5` classes uniformly into the standard
rank-four affine orthogonal scheme:

```text
zero | nonzero isotropic | nonzero square norm | nonsquare norm.
```

Writing `delta=chi(-1)`, its nonzero valencies are

```text
q^2-1,
q(q-1)(q+delta)/2,
q(q-1)(q-delta)/2.
```

The checker independently constructs `Omega_3(q)` from equal-spinor-class reflection pairs.  Its
projective orbit sizes are respectively

```text
q+1, q(q-1)/2, q(q+1)/2
```

in all six controls and reproduce exactly the quadratic-type fusion blocks.  Full
Bannai--Muzychuk exhaustion is feasible through rank eight and gives:

```text
q=5:   fusion ranks 2,4;
q=9:   fusion ranks 2,4,6;
q=11:  fusion ranks 2,4,6,8.
```

Thus q=11 has the unique additional rank-six fusion already found by C372.  The coarse
decoder-weight partition is not coherent at `q=9,11,19,29,59`; it does not turn the arithmetic
phase theorem into a constant-rank decoding algebra.  Exhausting every set partition at ranks
`14,24,76` fails the bounded complexity gate, so this report claims the uniform orthogonal fusion
and the complete small-rank fusion lattices, not a complete coherent-fusion classification for all
larger fields.  Separability also remains open.

## Available corollaries and reuse contract

The isolated rank-eight algebra is the q=11 member of a primitive Fourier-self-dual family with the
displayed Burnside rank law, seven possible stabilizer types, and a uniform orthogonal quotient.
This can support a compact contextual remark without claiming that the classical projective-line
orbit ladder is new.  It is not automatically a second portable theorem in the Clebsch manuscript:
C399 retains the paper's single promotion slot unless the manuscript owner explicitly changes
scope.

Four proved consequences are available for reuse:

1. the six-column source code is always the `D5` relation of valency `6(q-1)`;
2. the projective deep-hole locus is exactly the union of the `C3`, `C5`, and free relations and has
   size `(q-5)(q-9)`;
3. the conic is one relation exactly in the six phases `q=5,9,11,19,29,59`; and
4. every relation eigenvalue is obtained from the incidence integer `q*z-ell`, while the
   isotropic/square/nonsquare coarsening supplies a rank-four negative control in every field.

For exposition, q=59 should close the stabilizer ladder: the conic has become a regular sixty-point
orbit, and that orbit is again a deep relation.  The q=5 and q=11 rows remain the two code-changing
phases—source GRS at five and deep-hole child GRS at eleven—rather than the whole arithmetic story.

The exact downstream contract for C402 is deliberately narrower than “use the association
scheme.”  A candidate AME invariant must:

- be defined from the tensor without choosing a Pauli frame, decoder, or syndrome basis;
- have proved covariance under local unitaries and party permutations;
- retain every individual scalar-`A5` relation and eigenrow in the `C3`, `C5`, and regular-orbit
  sectors rather than factor through stabilizer type or quadratic norm type; at q=19 the two
  regular relations must remain distinct;
- compare the q=19 `H3` state with the full same-field GRS moduli; and
- use the rank-four orthogonal spectrum as a mandatory collapse control.

Failure of any item is a categorical stop, not an invitation to enlarge a finite census.  Likewise,
complete all-field fusion classification and separability are not free corollaries: they require a
structural centralizer/representation-algebra theorem or a new CI criterion, respectively.

## Proof

The fifteen involutions fix their projective axis and mirror, hence `q+2` points each.  The twenty
order-three elements fix one projective point, plus two split eigenlines exactly when `e3=1`; the
twenty-four order-five elements behave analogously with `e5`.  Burnside's lemma gives

```text
(q^2+q+1 + 15(q+2) + 20(1+2e3) + 24(1+2e5))/60
```

projective orbits, yielding the displayed rank.

C346 supplies the fixed `6_5,10_3,15_2` mirror lattice.  Its three multiple-point strata give the
single `D5`, `S3`, and `V4` orbits.  Removing their incidences from the fifteen mirror lines leaves
`15(q-5)` generic mirror points, or `(q-5)/2` `C2` orbits.  Outside the mirrors, a split order-three
or order-five eigenspace gives one `C3` or `C5` orbit; every remaining stabilizer is trivial.
C339's complement count `(q-5)(q-9)` then forces the free-orbit number.

On the invariant conic, an odd-order split eigenline is isotropic because preservation of the form
gives `B(v,v)=lambda^2 B(v,v)` with `lambda^2 != 1`.  A nonmodular involution contributes its two
conic fixed points exactly when `q=1 mod 4`.  In characteristics three and five these fixed points
coalesce into the `S3` and `D5` modular orbits.  Subtracting these nonregular orbits from `q+1`
gives the free-conic count and the six transitive phases.

## Reproduction and trusted boundary

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-20-c400-a5-fourier-phases.py --check
sha256sum -c notes/2026-07-20-c400-a5-fourier-phases.sha256
```

The standard-library-only checker uses exact prime-field arithmetic at `q=5,11,19,29,59` and the
fixed encoding `a+3b` for `F_9=F_3[tau]/(tau^2-tau-1)`.  It independently:

- closes the projective reflection group to order 60;
- enumerates every projective point and stabilizer type;
- compares the explicit orbit count with the Burnside formula;
- constructs the complete integer Fourier eigenmatrix and checks `P^2=q^3 I`;
- verifies the orbit and quadratic-type formulas;
- constructs `Omega_3(q)` to order `q(q^2-1)/2` and replays the orthogonal fusion; and
- exhausts all `5`, `52`, and `877` candidate fusion partitions at `q=5,9,11`.

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 20,404 | `e9e3110317b45272559af8338538d051fc6fcacbab1e6dc476757cc9468fd5fb` |
| certificate `.json` | 129,761 | `96052bf03609b8136dbba3461ae8a4c5232b97935ca4b5d6920854eeae561811` |

The trusted boundary is Python 3 integer arithmetic, exhaustive finite enumeration in the six
fields, the elementary Burnside and stabilizer arguments above, and C339/C341/C346.  It does not
exhaust all coherent fusions above rank eight, prove separability, or establish a priority claim.
The paper-facing arithmetic interface is kernel-checked in
`RelativeConicArcs.ClebschGatewayA5FourierPhase`; the external group and eigenmatrix enumerations
remain at the stated certificate boundary.

The Lean exit command was

```bash
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.ClebschGatewayA5FourierPhase \
  RelativeConicArcs.Gates.ClebschGateway \
  --profile single --threads 1 --cores 20-23
```

Both the dedicated gate and the crowns umbrella gate passed, including their exact-target
`--no-build` traces and final trace-only aggregate.  The `#print axioms` audit contains no
`sorryAx` or project-local axiom: three finite terminals are axiom-free, the natural-number
Burnside identity uses only `propext`, and the integer ring identity uses only `propext` and
`Quot.sound`.

## Literature audit and pre-emption boundary

This audit read **three external sources at full text**.

1. Cameron--Omidi--Tayfeh-Rezaie, *3-Designs from PGL(2,q)*, published EJC version,
   DOI `10.37236/1076`: **full text**, all sections read from the journal PDF cached at SHA-256
   `dbb91fdd288ffe3e8e865e827513cc936583dfbcfde80166005ddf2fc4a7cbce`.  Lemma 11 already
   determines the nonregular `A5` orbit lengths on `P^1(q)`: `10,12,20,30`, with all remaining
   orbits regular.  This directly pre-empts the invariant-conic orbit ladder outside the modular
   characteristic-five case.
2. Tricot, *On 3-designs from PGL(2,q)*, arXiv `2408.14714v1`: **full text**, all sections read
   from the cached arXiv PDF, SHA-256
   `20a8e4187dafeda456cb3112d3cd9a71b9dd472f216a049f8ec7d87ba7cb658d`.  Lemma 6 restates
   the `A5` projective-line orbit lengths `10,12,20,30,60` and applies them to block stabilizers.
3. Feng--Wen--Xiang--Yin, *Partial difference sets from quadratic forms and p-ary weakly regular
   bent functions*, arXiv `1002.2797v2`: **full text**, all sections read from the cached PDF,
   SHA-256 `9eb10c1321554880d3856e4f4592a4a37aa7fe4b058a40d8fa32dca2027d8f1b`.
   It places affine quadratic-form Cayley graphs and amorphic fusions in prior art; its main
   quadratic construction assumes even dimension and does not identify the present `A5` fission.

Sixteen exact web queries screened **142 displayed title/snippet cards** for scalar-`A5`, modular
icosahedral, Schurian translation, affine primitive, and finite-field association schemes.  The
mechanical discriminator was: title or snippet must mention an `A5`/icosahedral finite-field orbit
on a vector/projective space or an association/translation scheme built from that action.  The
load-bearing queries were:

```text
"A5" "translation association scheme" finite field
icosahedral association scheme finite field A5 orbits
"A_5" orbits "PG(2,q)" icosahedral
modular icosahedral group orbit scheme finite field quadratic form
site:arxiv.org A5 subgroup PSL(2,q) orbits projective line
site:doi.org icosahedral subgroup PSL(2,q) orbits projective line
A5 subgroups PGL(2,q) orbit lengths projective line paper
"orbit lengths" A5 PSL(2,q)
"F_q^3" "A5" association scheme
"A5" Schurian translation scheme
"scalar" "A5" affine primitive group rank finite field
"icosahedral" "association scheme" A5 affine
"A5" "Schur ring" finite field
"A_5" "affine primitive" rank 3 dimensional finite field
"icosahedral group" orbits finite vector space
"A5" "Cayley scheme"
```

No exact scalar-`A5` affine scheme appeared, but that absence is not promoted into a priority claim:
MathSciNet, zbMATH Open, and Google Scholar were **NOT COVERED**, and no forward-citation closure
was run.  The conceptual conic-orbit core is already classical.  The defensible result is therefore
the exact arithmetic synthesis with the source/deep-hole code dictionary, not a new modular-`A5`
orbit theorem or a new association-scheme family.

## Bounded adjacent-crown extraction

The exact pre-emption is Cameron--Omidi--Tayfeh-Rezaie's Lemma 11: it owns the nonmodular
`A5` projective-line orbit types from which the five later conic phases follow.  The surviving
result is the full scalar-affine rank/orbit formula and its exact identification with the C341/C368
code and deep-hole relations.

The bounded extraction considered four distinct continuations:

1. complete all-field coherent-fusion lattices;
2. generic separability/CI classification;
3. the code/deep-hole relation-role phase theorem; and
4. parallel scalar-`A4`/`S4` schemes.

The top two cheap tests both fail.  The fusion search already grows from `Bell(7)=877` at q=11 to
`Bell(13)` and `Bell(23)` at the next controls without a structural closure theorem.  The known TI
and quasiregular separability criteria already fail at q=11, so there is no uniform separability
gate.  Candidate 3 is absorbed into C400's surviving theorem rather than allocated separately;
candidate 4 is pre-empted at the orbit level by the same PGL2 subgroup literature and has no new
code interface.  No successor is allocated.

## Claim boundary and hand-back

- C346 continues to own odd good reduction and residue-field descent.
- C341 continues to own the source code and the q=11 rank-eight decoder scheme.
- C368 continues to own the q=11 non-GRS-parent/deep-conic/GRS-child transform.
- C372 continues to own the exact q=11 eigenmatrix and complete q=11 fusion lattice.
- C400 adds the uniform rank/orbit/conic-role synthesis and its six-field replay, but does not take
  the portable flagship slot from C399.
- C402 may consume the fine orbit spectra only after proving they enter a basis-independent
  party-permutation LU invariant of the AME tensor.  It must retain every individual relation and
  eigenrow in the `C3`, `C5`, and regular-orbit sectors; q=19's two regular relations are not one
  `free` label.  The rank-four orthogonal fusion is a deliberately too-coarse control, and
  decoder-weight classes are not coherent; stop if LU covariance collapses the fine relations or
  if the statistic depends on Pauli/decoder choices.
