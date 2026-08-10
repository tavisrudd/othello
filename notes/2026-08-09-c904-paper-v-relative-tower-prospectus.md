# C904 — Paper V relative and tower prospectus

**Date:** 2026-08-09  
**Status:** exploration only; not licensed for the manuscript until reviewed  
**Lean:** deferred by user instruction

## Immediate extension-field theorem

Let `K/F_11` be any field extension.  Base-change the full marked Paper-II
package, its five-isotypic projection, the six-axis augmentation, the two
invariant cubic lines, and the outer-normalizer action from `F_11` to `K`.
Then:

1. the invariant cubic space remains two-dimensional;
2. the Paper-II generator remains chordal and its scheme-theoretic singular
   locus remains the base-changed rational normal quartic;
3. the distinguished reduced divisor whose geometric points have exact
   stabilizer `C_5` is the base change of `A_5/C_5`;
4. the intrinsic map
   `A_5/C_5 -> A_5/D_5`, `gC_5 |-> gN_G(C_5)`, still has fibres of degree two
   and recovers the marked six-axis carrier;
5. on the invariant pencil, `q(C)=-C`, `q(H)=8C+H`, so `q-1` restricts to an
   isomorphism from either selected chordal line to the conference line;
6. the exact tensor forward and reverse maps remain inverse after scalar
   extension.

This gives an infinite tower over `F_{11^m}` for every `m >= 1`.  The proof is
flat scalar extension of the printed identities and schemes, plus the
group-theoretic stabilizer map.  One must not say that the entire rational
singular locus has twelve points: over `F_{11^m}` the quartic has
`11^m+1` rational points.  The correct selector is the exact-`C_5` stabilizer
divisor.

This theorem is mathematically valid but formally close to base change.  It
should enter Paper V only if cold reviewers find that it materially clarifies
the intrinsic selector or the scope of the result.

Two adversarial reads approved the stabilizer-stratified version for import.
The manuscript now states it as a corollary and not as a separate novelty
claim.  A stronger geometric decomposition was also identified but remains
outside the manuscript: over an algebraic closure the nonfree locus on the
quartic has strata of degrees `12,20,30` for stabilizers `C_5,C_3,C_2`; over
`F_121` the rational points decompose as `12+20+30+60=122`.  This requires
its own complete stabilizer proof and exact audit before use.

## EJ prospect: the full icosahedral stabilizer tower

The degree-twelve selector appears to be one row of a sharper uniform
statement. Let \(k\) have characteristic prime to \(60\), let the constant
group \(G\cong A_5\) act faithfully on a split rational curve \(R/k\), and
assume the action is the icosahedral projective action after geometric base
change. For each constant subgroup \(P\leq G\), let \(R^P\) be its
scheme-theoretic fixed locus over \(k\), and define
\[
 Z_5=\coprod_{P\in\operatorname{Syl}_5(G)}R^P,\qquad
 Z_3=\coprod_{P\in\operatorname{Syl}_3(G)}R^P,\qquad
 Z_2=\coprod_{\substack{P\leq G\\|P|=2}}R^P.
\]
After geometric disjointness is proved, these scheme-theoretic unions equal
the displayed coproducts. The expected theorem is:

1. \(Z_5,Z_3,Z_2\) are disjoint reduced finite étale divisors of degrees
   \(12,20,30\);
2. their geometric points have exact stabilizers \(C_5,C_3,C_2\),
   respectively;
3. normalizers pair the two fixed points of each cyclic subgroup, giving
   canonical degree-two maps
   \[
   Z_5\to(G/D_{10})_k,\qquad
   Z_3\to(G/S_3)_k,\qquad
   Z_2\to(G/V_4)_k;
   \]
4. the complement \(R\setminus(Z_5\sqcup Z_3\sqcup Z_2)\) is the free
   \(G\)-locus.

The human proof should be short but must be printed. Tameness makes each
nontrivial cyclic fixed scheme reduced of degree two. A geometric point
stabilizer in a tame finite subgroup of \(\PGL_2\) is cyclic, so fixed
schemes belonging to distinct cyclic subgroups cannot meet. \(A_5\) has six
Sylow-\(5\), ten Sylow-\(3\), and fifteen order-two subgroups. Their
normalizers are \(D_{10},S_3,V_4\), of orders \(10,6,4\), giving the three
degree counts and pairing maps. (The Paper-V notation \(D_5\) denotes this
order-ten dihedral group.) This also proves that every remaining geometric
point has trivial stabilizer.

The tame stabilizer lemma has a direct proof. For \(x\in R(\bar k)\), the
derivative gives \(G_x\to\bar k^\times\). It is injective: if a finite-order
automorphism fixes \(x\) and acts trivially on its tangent line, write its
first nonidentity term in a local parameter as
\(t\mapsto t+a_mt^m+\cdots\). Its \(n\)-th iterate has first term
\(t\mapsto t+na_mt^m+\cdots\), impossible when \(n\) is invertible. Thus
\(G_x\) is cyclic. A generator of a cyclic subgroup of order \(2,3\), or
\(5\) is semisimple on the underlying two-space and has exactly two distinct
eigenlines, so its fixed scheme on \(R\cong\PP^1\) is reduced finite étale
of degree two. Fixed schemes for distinct cyclic subgroups cannot meet,
since a common geometric point would have a cyclic stabilizer containing
both. Finally, \(A_5\) has no other nontrivial element orders, so the
stabilizers on the three divisors are exact and the complement is free.

For the Paper-V model over \(\F_{11}\), the \(C_5\) eigenlines are already
rational, while the \(C_3\) and \(C_2\) eigenlines become rational over
\(\F_{121}\). Hence the predicted exact census is
\[
 R(\F_{121})=Z_5(\F_{121})\sqcup Z_3(\F_{121})
             \sqcup Z_2(\F_{121})\sqcup\mathcal O_{\mathrm{reg}},
 \qquad 122=12+20+30+60,
\]
where \(\mathcal O_{\mathrm{reg}}\) is one regular \(A_5\)-orbit. More
generally, over every even extension \(\F_{11^{2m}}\), the free complement
should be a disjoint union of
\[
 \frac{11^{2m}+1-62}{60}
\]
regular orbits. For odd \(n\), only \(Z_5\) is rational:
\[
 \#Z_5(\F_{11^n})=12,\qquad
 Z_3(\F_{11^n})=Z_2(\F_{11^n})=\varnothing,
\]
and the free complement is a disjoint union of
\[
 \frac{11^n-11}{60}
\]
regular orbits. This is a genuine infinite-tower decomposition, not merely
a constant degree-twelve base change.

### Exact finite audit

The independent script
`papers/clebsch-round-trip/verification/evidence/icosahedral_stabilizer_tower.py`
enumerates the \(122\) points in the explicit model
\(\F_{121}=\F_{11}[u]/(u^2-2)\), transports the certified quartic
projectivity, and computes every point stabilizer, subgroup fibre,
normalizer, and orbit. Replay:

```text
python3 papers/clebsch-round-trip/verification/evidence/icosahedral_stabilizer_tower.py --check
```

It returns `CHECK OK (12+20+30+60)`. The script SHA-256 is
`b3d03b4a4f4206f6af64a543023d833e0b90730bd797586b74d9c3d536b5fcc0`;
the adjacent JSON certificate SHA-256 is
`72ff7f4f48fb70aa28398060fac67ad9c370761ff8eadd0b0386083e22b70520`.
This closes the finite \(\F_{121}\) census, not the literature or
scheme-theoretic proof gates.

### Gates before manuscript use

- give the scheme-level proof that every tame cyclic subgroup fixes a
  reduced degree-two divisor and that geometric point stabilizers are cyclic;
- independently review the odd/even descent statement and add it to the
  certificate if this theorem is promoted;
- audit classical icosahedral orbit/branch-divisor sources and modern
  treatments of finite subgroups of \(\PGL_2\);
- decide priority only after forward-citation closure; otherwise present the
  result explicitly as a useful marked specialization of the classical
  \(2,3,5\) branch stratification.

Until those gates close, this remains a successor theorem prospect and not a
Paper-V claim.

## EJ elevation: ramification and a uniform finite-field formula

The three divisors are the complete ramification stratification of the
icosahedral quotient
\[
 \pi:R\longrightarrow R/G.
\]
Their ramification indices are (5,3,2), respectively.  Thus the degree
calculation is also the Riemann--Hurwitz identity
\[
 12(5-1)+20(3-1)+30(2-1)=118=2|A_5|-2.
\]
This packages the tower as the arithmetic form of the classical
((2,3,5)) quotient, rather than as three unrelated fixed-point counts.

There is a stronger uniform statement over finite fields.  Let
(k=\F_q), with \(q\) prime to (30), and let a constant (A_5) act
faithfully and icosahedrally on a split (R\cong\PP^1_k).  Geometrically,
(Z_r\) is the transitive (G)-set (G/C_r), of degree
\[
 d_5=12,\qquad d_3=20,\qquad d_2=30.
\]
Its group of (G)-equivariant automorphisms is
(N_G(C_r)/C_r\cong C_2).  Frobenius therefore acts on (Z_r) by one
sign (\epsilon_r\in\{1,-1\}): the sign is (1) when the two fixed
points of (C_r) are rational and (-1) when Frobenius exchanges them.
Consequently, for every (n\geq1),
\[
 \#Z_r(\F_{q^n})=\frac{d_r}{2}(1+\epsilon_r^n),
\]
and the free rational points form exactly
\[
 \frac{q^n+1-
   \sum_{r\in\{2,3,5\}}\frac{d_r}{2}(1+\epsilon_r^n)}{60}
\]
regular (A_5)-orbits.  This is a simultaneous infinite-family and
infinite-tower theorem: the only arithmetic inputs are the three split
types.  It also gives the zeta factors
\[
 Z(Z_r,t)=
 \begin{cases}
   (1-t)^{-d_r},&\epsilon_r=1,\\
   (1-t^2)^{-d_r/2},&\epsilon_r=-1.
 \end{cases}
\]

For the Paper-V action over (\F_{11}),
((\epsilon_5,\epsilon_3,\epsilon_2)=(1,-1,-1)).  Hence
\[
 Z(R\setminus(Z_5\sqcup Z_3\sqcup Z_2),t)
   =\frac{(1-t)^{11}(1-t^2)^{25}}{1-11t},
\]
which recovers both the odd and even orbit formulas at once.  Promotion
would require a citation for the classical ((2,3,5)) quotient and an
independent check that the three Frobenius signs are intrinsic under the
declared notion of marked (A_5)-action.  The derivation itself is
group-theoretic once the stabilizer theorem is proved.

## Stronger arithmetic theorem to investigate

The more substantial target is a relative theorem over a localization of
`Z[sqrt(5)]`:

> For the nonstandard six-axis `A_5` module over an explicit localized base,
> the invariant cubic module is locally free of rank two; the outer
> involution has a rank-one anti-invariant conference summand and exchanges
> two chordal summands; its difference restricts from either chordal summand
> to the conference summand as an isomorphism.  The singular rational normal
> quartic carries a finite étale `A_5/C_5` divisor whose normalizer quotient is
> the six-axis `A_5/D_5` cover.

This would specialize to infinitely many characteristics and would explain
the `F_11` theorem rather than merely repeat it.

### Proof obligations

- construct the six-axis module, invariant pencil, conference line, chordal
  lines, and outer involution over one explicit base ring;
- prove the invariant module is locally free of rank two and commutes with
  base change;
- identify every bad prime, rather than hiding it in an unspecified `N`;
- prove flatness and good reduction of the chordal singular scheme;
- construct the exact-`C_5` divisor and its degree-two map to `A_5/D_5`
  functorially, including Galois descent when the chordal lines are conjugate;
- prove the coefficient of `(q-1)H` on the conference generator is a unit on
  the declared base;
- lift the Paper-II tensor and its normalization if the theorem is to include
  the matching transport, rather than only the companion pencil.

At minimum the semisimple and tensor/polynomial steps require inversion of
`2,3,5`, suggesting `Z[1/30,sqrt(5)]`.  Current integer lifts of the finite
matrices have determinants with extra primes; those primes may be coordinate
artifacts and cannot be declared intrinsic without a new integral
calculation.

### Literature obligations

Before import, audit Pinardin--Zhang Section 8.2, HMSV, classical
chordal/Segre sources, Hunt/Dolgachev, Bussemaker--Mathon--Seidel, and
Goethals--Seidel at theorem level.  The invariant pencil, chordal members,
outer extension, conference conventions, and abstract six-axis set are
pre-empted background.  A defensible new relative claim would be the
functorial exact-`C_5` divisor, normalized difference isomorphism, and its
compatibility with the Paper-II tensor.

## Recommendation

Close the finite theorem and its literature boundary first.  The
extension-field tower is then a safe optional corollary.  Treat the arithmetic
spread-out theorem as a separate upgrade gate requiring its own exact
certificate, literature audit, and cold review.
