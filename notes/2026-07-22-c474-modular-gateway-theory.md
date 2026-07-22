# C474 companion — a modular gateway theorem

**Date:** 2026-07-22

**Status:** abstract criterion proved; instantiated exactly for the frozen q=7 and q=11 matching
carriers; larger-family existence and the secondary orientation invariant remain open

## Result

The C465/C474 chain is an instance of a general modular mechanism.  A self-dual permutation
geometry can carry two complementary cross-incidence codes

```text
shared-edge image S,                 disjointness image D=<1> direct-sum S,
shared-edge kernel D,                disjointness kernel S,
```

with `S=D^perp`.  If the permutation degree is nonzero in the coefficient field, these identities
force the augmentation `A` to fit into a canonical self-dual Lagrangian extension

```text
0 -> S -> A -> S^* -> 0.                                      (1)
```

This first conclusion is pure linear algebra.  If the trace-zero endomorphisms of `S` become
projective on a Sylow subgroup, then `S` is endotrivial and hence invertible in the stable module
category.  If the fusion-stable part of the local coefficient cohomology is one-dimensional and
the extension (1) is nonsplit, then (1) is the unique nonzero element of
`Ext^1_G(S^*,S)` up to scalar and its middle term is the unique nonsplit carrier up to module
isomorphism.

For the frozen matching sheets these gates are all exact:

```text
q=7:   Hamming code  = <1> + S_7,    S_7|D8 = reflection-relative orbit syzygy;
q=11:  ternary Golay = <1> + S_11,   S_11|C3 = Omega(F_3) + free.
```

Thus the proved gateway is

```text
pointed matching sheet
  -> cross-incidence pair
  -> perfect code plus ambient augmentation
  -> simple Lagrangian core
  -> endotrivial Picard object
  -> unique nonsplit self-dual carrier.
```

The same proof also identifies the exact loss of information: after quotienting the nonzero Ext
line by endpoint automorphisms, the carrier moduli stack is `B G_m`.  There is one coarse carrier,
not a hidden scalar orientation.  Any arithmetic or cubic orientation must therefore be retained
as a pointing or recovered by a genuinely secondary invariant.

No literature-priority claim is made here.  “Modular gateway” names the proved synthesis and its
search criterion inside this project; a claim-specific literature audit would be required before
using novelty language externally.

## 1. Abstract incidence-to-extension theorem

Let `k` be a field, let a finite group `G` act on a finite set `Omega` of cardinality `n`, and let

```text
M = k[Omega],              1 = sum_(omega in Omega) omega,
epsilon:M -> k,            A=ker(epsilon)=1^perp
```

for the standard coordinate pairing.  Assume `n` is nonzero in `k`.  Then `<1,1>=n`, so

```text
M = k1 orthogonal-direct-sum A                                  (2)
```

and the form on `A` is nondegenerate.

Suppose `S` and `D` are `G`-submodules of `M` satisfying

```text
D = k1 direct-sum S,                                            (I1)
S = D^perp.                                                     (I2)
```

These are exactly the two load-bearing C465 code identities; the stronger cross-matrix
kernel/image equalities provide two independent constructions of the same modules but are not
needed for the theorem.

### Theorem 1 — forced Lagrangian carrier

Under (I1)--(I2):

1. `S` lies in `A` and is totally isotropic;
2. `dim(M)=2 dim(S)+1` and `dim(A)=2 dim(S)`;
3. the coordinate form induces a canonical exact sequence of `kG`-modules

   ```text
   0 -> S -> A -> S^* -> 0;                                    (3)
   ```

4. `S` is a `G`-stable Lagrangian in `A`;
5. the extension (3) splits if and only if there is a `G`-equivariant retraction `A -> S`.

### Proof

Since `S` is contained in `D=S^perp`, the restriction of the form to `S` is zero.  Since
`1` is also in `D=S^perp`, every element of `S` is orthogonal to `1`, hence lies in `A`.

Put `d=dim(S)`.  Nondegeneracy of the form on `M` and (I2) give

```text
dim(D)=dim(M)-d.
```

On the other hand, (I1) gives `dim(D)=d+1`.  Therefore `dim(M)=2d+1`; (2) then gives
`dim(A)=2d`.

Define

```text
rho:A -> S^*,              rho(a)(s)=<a,s>.
```

It is `G`-equivariant.  Its kernel is

```text
ker(rho)=A intersect S^perp=A intersect D.
```

Using (I1) and the direct sum (2), `A intersect (k1 direct-sum S)=S`.  Thus `ker(rho)=S`.
The quotient `A/S` and `S^*` both have dimension `d`, so `rho` is surjective and proves (3).
Since `S` is isotropic and has half the dimension of the nondegenerate space `A`, it is
Lagrangian.  Finally, a splitting of (3) is equivalent to a retraction onto its submodule `S`.
This proves all five assertions.

Two numerical obstructions are free.  Any geometry satisfying (I1)--(I2) has odd permutation
degree `n=2d+1`, where `d=dim(S)`, and its disjoint code has forced dimension `d+1=(n+1)/2`.
Candidate even-degree geometries, or candidates with the wrong cross-code dimension, fail before
any group-cohomology calculation.

### Corollary 1 — a literal gateway path-independence square

Assume in addition that two cross-incidence operators have the C465 kernel/image pattern

```text
im(shared)=ker(disjoint)=S,
im(disjoint)=ker(shared)=D.
```

Then the two routes

```text
cross incidence --shared image---------------------------> S
cross incidence --disjoint perfect code--> D --intersect A--> S
```

agree exactly, not only up to isomorphism or composition factors.  The second route recovers the
first because `D intersect A=S`.  Consequently the simple core and the extension (3) can be
reconstructed from either cross relation together with the ambient permutation augmentation.

This is the first closed path through the magic-gateway diagram whose commutativity follows from
the modular code identities themselves.

## 2. Local orbit fibres force stable invertibility

For a finite-dimensional `kG`-module `S`, let `End_k(S)` carry the conjugation action.  Suppose
`char(k)=p`, let `P` be a Sylow `p`-subgroup, and assume `dim(S)` is nonzero in `k`.  The ordinary
trace then gives a `G`-invariant splitting

```text
End_k(S) = k id_S direct-sum End_k(S)_0,                       (4)
```

where the second summand is trace-zero.

### Theorem 2 — Sylow orbit-fibre criterion

If `End_k(S)_0|P` is projective as a `kP`-module, then

```text
End_k(S) = k direct-sum projective
```

as a `kG`-module.  Hence `S` and `S^*` are endotrivial and define inverse elements in the Picard
group of `stmod(kG)`.

### Proof

A finite `kG`-module is projective if and only if its restriction to a Sylow `p`-subgroup is
projective.  Apply this projectivity-detection theorem to the trace-zero summand in (4).  The
resulting decomposition of `End_k(S)=S^* tensor S` is precisely the definition of an endotrivial
module.  Duality exchanges the class of `S` with its inverse.

### Practical orbit gate

The theorem does not say that every reduced orbit module is endotrivial.  The load-bearing test is
the projectivity of the trace-zero endomorphism module.  In the two frozen cases that test has the
following geometric normal forms:

```text
q=7:
  P=D8, H=<reflection>,
  S_7|P = Omega(k[P/H]) or its dual,
  End_k(S_7)|P = k direct-sum kP;

q=11:
  P=C3, H=1,
  S_11|P = ker(k[P/H] -> k) direct-sum kP
          = Omega(k) direct-sum kP,
  End_k(S_11)|P = k direct-sum (kP)^8.
```

Thus C474 proves the hypothesis of Theorem 2 directly in both rows.  The phrase “reduced Sylow
orbit fibre” is a construction heuristic; the endomorphism decomposition is its cheap falsifier.

## 3. From a Picard object to the unique carrier

For the extension (3), put

```text
L=Hom_k(S^*,S)=S tensor S.
```

Standard group cohomology identifies

```text
Ext^1_(kG)(S^*,S) = H^1(G,L).                                 (5)
```

If `x=[S]` in the stable Picard group, then `L` has stable class `2x`.  The extension is therefore
a degree-one cohomology class with a nontrivial Picard grading, rather than an ordinary scalar
extension in disguise.

### Theorem 3 — local detection and fusion descent

Let `P` be a Sylow `p`-subgroup.  Restriction

```text
res:H^1(G,L) -> H^1(P,L)
```

is injective.  More precisely, restriction followed by corestriction is multiplication by
`[G:P]`, which is invertible in `k`.

Suppose a subspace `F` of `H^1(P,L)` is known to contain the image of restriction, `dim(F)=1`, and
the class of (3) restricts to a nonzero element of `F`.  Then

```text
dim Ext^1_(kG)(S^*,S)=1,
```

and (3) spans it.

### Proof

The restriction/corestriction identity proves injectivity because `[G:P]` is prime to `p`.  Hence
`H^1(G,L)` embeds in `F` and has dimension at most one.  The nonzero restricted extension proves
that it has dimension at least one.  Equation (5) gives the conclusion.

The point of `F` is to separate cyclic detection from global fusion.  When local cohomology is
already one-dimensional, take `F=H^1(P,L)`.  When it is larger, `F` is the subspace satisfying the
conjugation compatibilities inherited from `G`.

### Exact instantiation

The C474 certificate gives

```text
q=11: dim H^1(C3,L)=1;
      the frozen class is nonzero locally;
      therefore dim H^1(PSL_2(11),L)=1.

q=7:  dim H^1(D8,L)=2;
      the PSL_2(7) fusion relation cuts out a one-dimensional subspace F;
      the frozen class lies nontrivially in F;
      therefore dim H^1(PSL_2(7),L)=1.
```

The stronger binary restriction calculation describes the selected line intrinsically: its
nonzero element is essential on both reflection-type Klein four subgroups and restricts to zero
on every constituent involution.  Among the three nonzero `D8` classes, it is the unique
bi-essential one.  Thus the fusion descent gate can be checked without naming the C474 cocycle
basis.

### Corollary 2 — uniqueness of the nonsplit carrier

Assume `S` and `S^*` are nonisomorphic simple modules, `End_(kG)(S)=k`,
`End_(kG)(S^*)=k`, and the conclusion of Theorem 3.  Then all nonzero elements of
`Ext^1(S^*,S)` have isomorphic middle modules.  There are exactly two extension types up to
middle-module isomorphism: the semisimple split module and one nonsplit carrier.  Moreover the
nonsplit carrier `A` is automatically a brick:

```text
End_(kG)(A)=k.
```

### Proof

The endpoint automorphism group is `k^x times k^x`.  It acts on the one-dimensional Ext space by
the scalar ratio.  This action is transitive on nonzero vectors, so all nonsplit extensions are
equivalent after endpoint automorphisms.  The split class is a separate orbit.  Its middle module
is semisimple, whereas the middle module of a nonsplit extension of simple endpoints is not, so
the two orbit types cannot collapse after forgetting the endpoint maps.

For the brick assertion, an endomorphism of `A` preserves its unique simple socle `S` and induces
scalars `a` and `b` on the socle and head.  Compatibility with the nonzero extension class says
`a alpha=alpha b`, hence `a=b`.  The kernel of the map from `End(A)` to these two endpoint scalars
is `Hom_G(S^*,S)=0` by nonisomorphism and simplicity.  Therefore every endomorphism of `A` is a
scalar.  In the two frozen cases this recovers C465's independently computed carrier commutants
from the Ext theorem.

## 4. The carrier groupoid and the orientation obstruction

The preceding scalar action proves more than coarse uniqueness.

### Theorem 4 — residual gerbe of a one-line carrier

Under the hypotheses of Corollary 2, the groupoid of unpointed nonzero extensions is

```text
[Ext^1(S^*,S)^x / (G_m times G_m)] = B G_m.                    (6)
```

Its coarse moduli space is one point.  Over a finite field `k`, the automorphism group at that
point is `k^x`.

### Proof

Choose any nonzero Ext vector.  The scalar-ratio action is transitive, and its stabilizer is the
diagonal copy of `G_m`.  A transitive quotient stack is the classifying stack of the stabilizer,
which gives (6).  There is no additional additive inertia: an automorphism inducing the identity
on both endpoints would lie in `Hom_G(S^*,S)`, which is zero.  If the endpoints were isomorphic,
this last conclusion could fail; nonisomorphism is therefore a load-bearing moduli hypothesis.

### Corollary 3 — no scalar orientation descends

No invariant of the unpointed middle module can distinguish two nonzero scalar representatives
of the Ext line.  Any such distinction must use additional pointed endpoint data, a Lagrangian
orientation, or a secondary invariant not determined by the carrier's module-isomorphism class.

This is the exact abstract form of the q=11 determinant experiment: determinant varies within one
gauge component and therefore fails before the endpoint-scalar quotient is even taken.  The
coarse carrier cannot secretly retain the arithmetic prime or cubic sign.

## 5. The modular gateway criterion

The preceding theorems combine into a reusable recognition theorem.

### Modular Gateway Theorem

Let a finite group `G` act on `Omega`, and let a pair of `G`-equivariant cross-incidence operators
on `k[Omega]` supply modules `S` and `D`.  Assume:

1. **semisimple line gate:** `|Omega|` is nonzero in `k`;
2. **cross-code gate:** `D=k1 direct-sum S` and `S=D^perp`;
3. **nonsplitting gate:** the resulting augmentation extension has no equivariant retraction;
4. **local Picard gate:** `dim(S)` is nonzero in `k`, and the trace-zero part of `End_k(S)` is
   projective on a Sylow subgroup;
5. **fusion-descent gate:** the fusion-compatible local subspace containing the restricted
   extension is one-dimensional;
6. **simple-core gate:** `S` and `S^*` are nonisomorphic simple modules;
7. **rigidity gate:** both endpoint endomorphism rings equal `k`.

Then:

1. the shared-code and disjoint-code recovery paths agree on `S`;
2. `S` is a simple stable Lagrangian;
3. `S` is an invertible object of `stmod(kG)`;
4. the augmentation is the unique nonsplit extension of `S^*` by `S` up to module isomorphism;
5. the carrier is a brick and a Picard-graded cone in degree `(1,2[S])`;
6. the unpointed nonsplit extension groupoid is `B G_m` and forgets scalar orientation.

### Proof

Items 1--2 follow from Theorem 1, Corollary 1, and the simple-core gate; item 3 follows from
Theorem 2; items 4--5 follow from Theorem 3 and Corollary 2; and item 6 follows from Theorem 4.  No
classification of simple endotrivial modules or character-table decomposition is used in this
implication.  Simplicity is a separate gate rather than a consequence of the orthogonal code
identities; C465 certifies it by exhaustive invariant-subspace generation in both realizations.

## 6. The two proved realizations

All seven gates can be read off from the frozen reports and their exact certificates.

| Gate | q=7 over `F_2` | q=11 over `F_3` |
|:---|:---|:---|
| permutation degree | `7=1` in `F_2` | `11=2` in `F_3` |
| code dimensions | `dim(S,D,A)=(3,4,6)` | `dim(S,D,A)=(5,6,10)` |
| perfect code | binary Hamming `[7,4,3]` | ternary Golay `[11,6,5]` |
| orthogonal flag | `S=D^perp`, `D=<1>+S` | `S=D^perp`, `D=<1>+S` |
| simple-core gate | distinct dual `3`-dimensional simples | distinct dual `5`-dimensional simples |
| nonsplitting rank gap | `18 < 19` | `50 < 51` |
| Sylow source | reflection-relative `Omega(k[P/H])` | `Omega(k)+kP` |
| endpoint endomorphisms | `k` | `k` |
| Sylow endomorphism module | `k+kD8` | `k+(kC3)^8` |
| local coefficient `H^1` | dimension `2` on `D8` | dimension `1` on `C3` |
| descent selector | one-dimensional fusion/bi-essential line | all local `H^1` |
| global `Ext^1` | dimension `1` | dimension `1` |
| unpointed nonsplit groupoid | point (`k^x=1`) | `B(C2)` (`k^x=C2`) |

Consequently both frozen rows satisfy all seven gates of the Modular Gateway Theorem.  This proves
the two-case statement

```text
cross-design -> perfect code -> endotrivial core -> unique augmentation carrier
```

without extrapolating to any unconstructed value of `q`.

## 7. What has actually been discovered

The theorem isolates three ideas that were previously mixed together.

### 7.1 Perfect codes can be intermediate, not terminal

For these symmetric designs the Hamming/Golay code is the semisimple object `D=k+S`.  Its
nontrivial summand is a stable unit, while the ambient sheet augmentation is the unique cone on a
class in the doubled Picard degree.  This suggests a theory of **Picard-core codes**: codes whose
canonical nontrivial equivariant core is endotrivial.

The term is descriptive, not a literature-priority assertion.  The first invariant package would
be

```text
([S], order([S]), 2[S], fusion profile, carrier class, self-dual formation data).
```

### 7.2 Rank-two coherence can be the first visible orientation

The binary carrier is invisible on every order-two subgroup but visible on both relevant `V4`s.
Thus a decoration can live at the level of compatibility among local views rather than in any
individual rank-one view.  The natural next theorem is an orbit-category formulation identifying
the global line as a homotopy equalizer or first higher-limit class.  C474 proves the entire finite
restriction profile needed for that formulation, but this report does not yet compute the full
orbit-category complex.

### 7.3 Self-duality needs a secondary layer

The external design is self-dual; the internal carrier is self-dual, metabolic, nonsplit, and
rigid.  Witt theory sees zero, Ext sees one nonzero orbit, and neither retains the pointed
orientation.  The missing invariant must therefore refine a metabolic object by a Lagrangian,
comparison, or orientation.  Relative Grothendieck--Witt formations, Maslov data, and determinant
gerbes are candidate languages.  No one of them is selected by the current evidence.

## 8. Cheap falsifiers and proof programme

A candidate new design/code gateway should be tested in this order:

1. Compute the two cross-code images and kernels.  Stop unless the two routes recover one core.
2. Check `D=k1+S`, `S=D^perp`, and `|Omega| != 0` in the coefficient field.  These force the
   Lagrangian extension and the dimensions `|Omega|=2 dim(S)+1`, `dim(D)=dim(S)+1`.
3. Solve one equivariant-retraction system.  Stop if the augmentation splits.
4. Check that `dim(S)` is nonzero in the field, restrict the core to a Sylow subgroup, and compute
   the trace-zero endomorphism module.  Stop unless it is projective.
5. Compute local `H^1` and impose fusion.  Stop unless the carrier occupies a one-dimensional
   compatible line.
6. Compute endpoint commutants.  Only scalar commutants give the one-orbit carrier theorem in the
   stated form.

These tests distinguish a modular gateway from a famous-object coincidence.  They are also much
cheaper than a full modular character-table or derived-category calculation.

The next proof targets, in value order, are:

```text
(A) orbit-category equalizer theorem for the q=7 bi-essential line;
(B) Picard orders and powers of [S_7] and [S_11];
(C) a relative Witt/formation invariant carrying the lost orientation;
(D) a bounded scan for another self-dual design passing gates 1--4.
```

Targets (A)--(C) deepen the two proved examples.  Target (D) is the first gate for claiming a
family rather than a two-point phenomenon.

## 9. Scope, evidence, and replay

The abstract proofs in Sections 1--5 are deductive and introduce no new computational premise.
The q=7/q=11 instantiation consumes the committed C465 and C474 evidence bundles without modifying
their generated data.  In particular:

- C465 certifies the cross matrices, kernel/image identities, module lattices, orthogonal flags,
  nonsplitting rank gaps, and endpoint commutants;
- C474 certifies global and local cohomology, cocycle nontriviality, full Sylow source and
  endomorphism decompositions, fusion selection, bi-essential restriction profiles, scalar
  orbits, and the determinant failure;
- the independent C474 replay repeats the cocycle and restriction calculations without importing
  the primary implementation.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c465-mod3-weil-golay.py --check
python3 notes/2026-07-21-c465-mod3-weil-golay-replay.py
sha256sum -c notes/2026-07-21-c465-mod3-weil-golay.sha256

python3 notes/2026-07-22-c474-uniform-ext-carrier.py --check
python3 notes/2026-07-22-c474-uniform-ext-carrier-replay.py
sha256sum -c notes/2026-07-22-c474-uniform-ext-carrier.sha256
```

Trusted boundary: exact finite-field linear algebra; deterministic enumeration of the frozen
groups and matching sheets; standard Sylow detection of projectivity;
restriction/corestriction in group cohomology; and the hash-pinned upstream bundles.  The present
report adds a proof layer, not a new generated certificate, so no separate script is appropriate.

The report proves neither existence outside `{q=7,q=11}` nor a relation between the combinatorial
sheet torsor and the coefficient-valued Ext class.  It does not identify a secondary orientation
invariant, an 11-cell residue map, or a Fano-block residue map.  Those remain explicit gates, not
consequences of matching cardinalities.

## Extra-juice closeout and mystery ledger

- **Settled — the abstract modular gateway criterion.**  The seven stated gates imply a stable
  Picard core, unique nonsplit carrier, and residual `B G_m` gerbe.  The proof uses only linear
  algebra, Sylow projectivity detection, transfer, fusion descent, and scalar orbit reduction.
- **Settled — first exact closed walk.**  Shared-edge image and disjoint-code intersection with
  augmentation recover the same literal subspace `S`, so path independence is stronger than an
  abstract module isomorphism.
- **Settled — why the augmentation has dual head.**  It is forced by the orthogonal identities:
  the pairing map `A -> S^*` has kernel exactly `A intersect D=S`.
- **Settled — the role of the reduced orbit fibre.**  It does not automatically prove
  endotriviality.  Its trace-zero endomorphism module must be Sylow-projective; this cheap test is
  the precise local gate.
- **Settled — the orientation-loss theorem.**  A one-dimensional Ext space with scalar endpoint
  commutants has quotient stack `B G_m`; the coarse carrier cannot distinguish nonzero Ext
  scalars.
- **Open — a third realization.**  No other design has yet passed the cross-code, Lagrangian,
  Sylow-projectivity, and fusion gates.  Until one does, “modular gateway theory” has an abstract
  theorem and two exact realizations, not a natural family classification.
- **Open — secondary self-dual orientation.**  External polarity and internal Lagrangian data
  coexist but have no proved comparison map.  The exact gate is a pointed formation invariant
  that descends through gauge while distinguishing the two arithmetic orientations.
- **Open — higher coherence.**  Bi-essentiality identifies the q=7 global line, but the report
  does not yet prove that line is a particular higher limit or homotopy equalizer in the orbit
  category.
- **No hidden degree-one mystery remains.**  Given the seven gates, the Lagrangian extension,
  stable invertibility, Ext uniqueness, carrier groupoid, and scalar information loss are all
  forced.  The remaining mysteries are higher descent, Picard powers, secondary duality, and
  existence beyond the two frozen examples.
