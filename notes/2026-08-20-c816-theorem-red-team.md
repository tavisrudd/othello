# C816 review gate 1 — theorem-level red team of Paper III's operator section

**Task:** C816 (`clebsch` lane), review and release gate 1.
**Date:** 2026-08-20.
**Scope:** `papers/clebsch-passages/sections/05-golden-operator.tex` and the
statements it exports to the abstract, the introduction hierarchy, and the
conclusion; the `OPER-5` row of `papers/clebsch-passages/literature-boundaries.md`.
**Constraint honoured:** no manuscript file was edited by this pass.
**Focus set by the card:** hypotheses, proportionality versus equality, the
nonzero-shadow clause, orientation covariance, and the global weighted boundary.

**Verdict.** Every mathematical assertion checked in the section is correct.
Two of the seven findings are proof-level and should be repaired before the cold
read: the tangent-space dimension is asserted at the one point where the section
claims it is *forced*, and the local rigidity conclusion is attributed to the
constant-rank theorem, whose hypothesis the proof never establishes. The rest are
statement-level precision and positioning items. No claim needed to be withdrawn
and nothing found here changes what the paper proves.

## Evidence bundle

- Generator: `notes/2026-08-20-c816-theorem-red-team.py`.
- Certificate: `notes/2026-08-20-c816-theorem-red-team.json`.
- Hashes: `notes/2026-08-20-c816-theorem-red-team.sha256`.

| artifact                                     | bytes |                                                           SHA-256 |
|----------------------------------------------|-------|-------------------------------------------------------------------|
| `2026-08-20-c816-theorem-red-team.py`        | 27289 | `2754449d2ac71b3d1fecc78a4e3f9c44a3f41b811133f739a30ce2875a68872e` |
| `2026-08-20-c816-theorem-red-team.json`      |  9842 | `361710dafcd73139210216447232f7532597628534c7edc569a21233109f1b5f` |

Regenerate and replay, from the repository root:

```sh
uv run --with sympy --with numpy python3 notes/2026-08-20-c816-theorem-red-team.py \
    --full --out notes/2026-08-20-c816-theorem-red-team.json
uv run --with sympy --with numpy python3 notes/2026-08-20-c816-theorem-red-team.py \
    --check notes/2026-08-20-c816-theorem-red-team.json
sha256sum -c notes/2026-08-20-c816-theorem-red-team.sha256
```

The `--full` flag adds the exhaustive eight-point fibre analysis, which the
committed certificate includes; `--check` detects its presence in the tracked
JSON and reruns at the same depth. The generator is deterministic; it contains no
randomness and no timestamps, and `--check` regenerates in memory and compares
canonical JSON byte for byte, leaving the worktree unchanged. Its
conventions — the ordered axis set, the lexicographic edge and triple orders, the
Hodge sign as the sign of the permutation listing the complementary triple and
then the triple, `h_S` as the coefficient of `x_S` in `Pf[D_x,A]`, `tau_S` as the
triangle product, and `w(K)` as the sum of the three signed Hamilton-cycle
products — are stated in its docstring and match the manuscript's.

**What the certificate does not cover.** Nothing about the literature, nothing
about matrices outside the enumerated finite domains, and none of the manuscript's
prose. The trusted boundary is CPython plus sympy exact rational arithmetic; the
only floating-point step in the pass (the boundary probe in the last section
below) is explicitly marked as non-load-bearing and is excluded from the
certificate.

## Independent confirmations

All of the following were recomputed from the manuscript's own displayed
representative and sign conventions, not read back from any earlier C815 or C816
artifact.

1. **The universal half of the four descriptions.** For a generic symmetric
   order-six matrix in fifteen indeterminates, the coefficient of `x_S` in
   `Pf[D_x,A]` equals the signed complementary minor for all twenty triples, and
   the Pfaffian is homogeneous of degree three. This is the identity the
   paragraph "What the four descriptions do and do not assert" relies on.
2. **The marked representative.** `C^2 = 5I`; the triangle word of row `r=0` of
   table (5.1) reproduces as `--+++-++--++--+---++`, the string the manuscript
   displays; `h_S(C) = 4 tau_S(C)` for all twenty triples, so `C` lies in
   `X_{+1}` as the rigidity paragraph asserts.
3. **The two triangle orbits.** The complementary blocks displayed for `S = 012`
   and `S = 014` are the manuscript's, with determinants `4` and `-4`, Hodge
   signs both `-1`, and internal triangle products `-1` and `+1`.
4. **Theorem D's Jacobian.** Rank fourteen at `C`, kernel exactly the scaling
   line. The derivative shapes claimed in the proof hold: for an edge inside `S`
   the derivative is `-4 a_ik a_jk`, and for an edge inside the complement it
   vanishes.
5. **The equivariance group.** The stabilizer of `C` among signed permutations
   modulo the global sign has order sixty with element-order profile
   `1, 15, 20, 24`, and the edge module has character `(15,3,0,0,0)`, whose
   multiplicities against the alternating group of degree five are
   `1 + 4 + 5 + 5` exactly as displayed.
6. **The reduced table.** With `h = (0 2 4)(1 3 5)` and signs `(+,-,-,-,-,+)`,
   the fixed subspace is five-dimensional, the displayed `u_1,...,u_5` are a
   basis, `C` has coordinates `(1,1,1,-1,-1)`, and the eight primitive reduced
   rows — including which triples share a row — reproduce the manuscript's table
   entry for entry, with rank four, kernel `(1,1,1,-1,-1)`, and the four-by-four
   minor on the rows from `012, 013, 015, 024` equal to `-5`.
7. **Proposition (nonsingular complementary minors).** Verified exhaustively over
   all 32768 symmetric hollow sign matrices of order six: being a conference
   matrix, having all twenty complementary three-by-three minors nonzero, and
   satisfying the cubic proportionality hold on exactly the same 384 matrices,
   with no disagreement on any matrix; the only proportionality constants are
   `+4` and `-4`, and every complementary minor takes absolute value `0` or `4`.
   The proposition's own proof was also read line by line and is correct,
   including the parity step that rules out Gram determinant `20`.
8. **Exchange spectra and moments.** The trace identities are correct
   symbolically: the second-moment numerator equals `F_d + 32 c_Y`, the first
   moment is `d^2/q`, and the whole-matrix closed-walk count pins
   `(2d-3) w = -3`. At order six the exchange spectrum is `{1/5, 4/5, 4/5}` on
   every balanced half, and the order-three characteristic polynomial factors as
   the manuscript states.
9. **The design statistics.** `det C[K] = 3 - 2 w(K)` holds on every four-set of
   every conference matrix tested. At order ten the aligned family is a
   `3-(10,4,1)` design of thirty blocks; over all 126 projective cuts the mean is
   `5/7`, the variance is `10/49`, and the distribution is exactly 36 cuts with
   `c_Y = 0` and 90 with `c_Y = 1` — the split the manuscript reports. The
   general mean and variance formulas also reproduce exactly at orders fourteen
   and eighteen. Order six has no aligned four-set, matching `rho = 0` there.
10. **Aligned-design faithfulness.** Exhaustively over all two-graphs: at seven
    points every fibre of the aligned-family map has size exactly two, and at
    eight points likewise, so the map determines the two-graph up to complement
    and no further; at six points there are fibres of size four and one of size
    twelve, so six points genuinely fail. The witness pair in the sharpness
    remark is confirmed — both have aligned family exactly
    `{{0,1,2,5},{0,1,3,4}}`, and the second is neither the first nor its
    complement. The seven-point signature table, both balanced-cut tables, and
    the claim that interchanging two distinct balanced cuts preserves all six
    pair tests all reproduce exactly.
11. **The query arithmetic.** `1 + 4(n-4) + 6*binom(n-4,2) = 3n^2 - 23n + 45`;
    the counting floor `binom(n,2) - n` equals `binom(n-1,2) - 1`; the reciprocal
    of the binary entropy at one quarter is `1.23262...`, giving the stated
    `0.616 n^2` and the ratio `4.87`.

## Findings

### 1. The tangent-space dimension is asserted where the text claims it is forced

`sections/05-golden-operator.tex:456-465`. The paragraph opens "Its dimension is
forced rather than computed", proves `dim T >= 5` from the Grassmannian and
tight-frame count, and then says "Equality holds". No upper bound is given
anywhere. The `G`-module argument that follows does not supply one either: a
`G`-submodule of the edge module containing the trivial summand and of dimension
at least five could be `1 + 4`, `1 + 5`, `1 + 4 + 5`, or larger, so the
decomposition alone does not select `1 + 4`. The involution sentence assumes the
answer, since it asserts that the `+1`-eigenspace of `X -> CXC/5` *on `T`* is the
scaling line, which is a statement about `T`.

The claim is true. I verified that the linearized space
`L = { X hollow symmetric : CX + XC scalar }` has dimension exactly five, that
`{X in W : CXC = -5X}` has dimension exactly four, and that `L` has character
`(5,1,2,0,0)`, which is `1 + 4`. The repair is one sentence and needs no new
computation in the text: `mu` is linear on `L`, its kernel lies in the
`-1`-eigenspace of conjugation by `C/sqrt5`, and that eigenspace is
four-dimensional, so `dim T <= 1 + 4 = 5`.

Note that the natural structural count gives the wrong inequality for this
purpose. The `-1`-eigenspace of conjugation on all symmetric matrices is the
nine-dimensional off-block-diagonal space; its members are automatically
traceless, so hollowness imposes at most five independent conditions and the
count yields `>= 4`, not `<= 4`. Whatever sentence is added has to establish the
upper bound directly.

This matters because the module statement is the upgrade the card bought with
work item 2: "the four-dimensional constituent" and "one statement" both fail if
`T` is larger than five-dimensional.

### 2. The constant-rank theorem is the wrong instrument

`sections/05-golden-operator.tex:448-450`: "The constant-rank theorem confines
`X_{+1}` to a one-dimensional manifold near `C`." The proof establishes the rank
only at `C`; rank is lower semicontinuous, so nearby the rank may be fifteen, and
constancy is never shown. The argument the proof actually wants is the ordinary
implicit-function theorem applied to fourteen of the twenty functions whose
differentials are independent at `C`: their common zero set is a one-dimensional
manifold near `C`, it contains `X_{+1}`, and it contains the scaling line, so the
three agree locally. This is strictly easier than what is claimed, and it removes
an unverified hypothesis rather than adding one.

The C816 card advertises "the only external ingredient left is the ordinary
constant-rank theorem". After this repair the ingredient is the implicit-function
theorem, and the card's sentence should follow the manuscript.

### 3. "The opposite oriented representative" has a reading under which the theorem is false

`sections/05-golden-operator.tex:372-373`: "the same holds for `h_S + 4 tau_S` at
the opposite oriented representative." Everywhere else in this paper "opposite"
names the deck-opposite source, which `sections/03-orientation-source.tex` fixes
as `-C`. Under that reading the sentence is false, and the same paragraph already
says so: `X_{+1}` is a cone containing the whole line through `C`, hence
containing `-C`, so `h_S + 4 tau_S` does not vanish there. I confirmed both
halves numerically: `-C` lies in `X_{+1}`, and an odd relabelling of `C` — the
transposition of labels `0` and `1` — lies in `X_{-1}`.

What is meant is the same conference matrix carrying the reversed Hodge or label
orientation, i.e. an odd signed-permutation image, which is exactly what the last
line of the proof describes. The statement should say so rather than relying on
the proof to disambiguate it, since "opposite" is a loaded word in this paper.

### 4. The abstract states the recognition theorem more loosely than the theorem

`clebsch_passages.tex:48-51`: "Proportionality of the commutator Pfaffian to the
triangle cubic already characterizes order six, forcing a scalar square, for real
symmetric zero-diagonal matrices with nonzero off-diagonal entries." Three gaps
against `thm:triangle-pfaffian-recognition`:

- the theorem's hypothesis is *nonzero* proportionality, and the manuscript's own
  boundary sentence stresses that the hypotheses "exclude zero proportionality";
  the abstract drops it;
- the theorem also assumes even order, without which the Pfaffian is undefined;
- "characterizes" reads as a two-way statement. The theorem gives one direction
  only: proportionality forces order six, not the converse. The neighbouring
  abstract sentence, "Cut-independence of the balanced exchange spectrum also
  singles out order six", *is* an equivalence, so the parallel construction
  invites a referee to read both at the same strength.

The introduction (`sections/01-introduction.tex:238-241`) and the conclusion
(`sections/09-conclusion.tex:18-20`) both say "forces order six and a scalar
square", which is exact. The abstract is the only outlier and should adopt their
wording.

### 5. The recognition theorem still carries no priority sentence in the manuscript

Work item 1's ledger row `OPER-5` exists and is thorough, and it instructs: say
"we prove" and "we have not located", keep "to our knowledge" on every negative.
The manuscript does not carry any such sentence near
`thm:triangle-pfaffian-recognition`. The only two "We have not located" sentences
in the section, at lines 981 and 988, belong to the sharp two-graph
specialization (`OPER-4`) and the balanced singular-spectral classification
(`OPER-3`). The exposure the card described in its own words — a referee asking
who else has characterized the order-six conference class by Pfaffian-triangle
proportionality, and finding the question unasked — is unchanged in the
manuscript.

Related, and also still owed from the same audit's recommendations: none of the
classical owners the audit named is cited anywhere in the paper. There is no
bibliography entry for Beauville on linear Pfaffian representations, for
Tanturri's constructive cubic-surface case, or for Huang and Oeding's cycle-sum
coordinates on principal minors, and the identity identifying the triangle cubic's
coefficients with half the principal three-by-three minors of the same hollow
matrix does not appear. The card flags these as owner decisions rather than audit
output, so this is unfinished work item 1 follow-through, not an error — but the
card's acceptance sentence, "the recognition theorem carries an auditable priority
boundary", is currently satisfied by the ledger alone and not by the manuscript.

### 6. The factor-four paragraph overstates what nondegeneracy replaces

`sections/05-golden-operator.tex:533-538`: "This is where the factor `4` ... comes
from. It is not the output of the two orbit computations displayed earlier."

For the magnitude this is right, and the census confirms that every complementary
minor of a hollow sign matrix is `0` or `+-4`. But the recognition theorem's
second paragraph also asserts a converse — for the pentagon conference matrix,
`Phi_A = +-4 T_A` — and that requires the sign to be *the same* for all twenty
triples. Nondegeneracy gives `|det| = 4` triple by triple and says nothing about
sign coherence; the two orbit computations are exactly what supply it. Softening
to "the magnitude has no freedom left" keeps the point and stops the paragraph
from reading as though the orbit computation were dispensable.

### 7. The inclusion-rank descent is compressed past the point of being checkable

`sections/05-golden-operator.tex:654-657`: "descending on the subset size makes
the difference vanish pointwise, and one-element exchanges connect all
four-sets."

The descent alone does not do this. Each step lowers the summation size by one,
the half size by one, and the ground set by two, so after three steps one has
only that a threefold difference vanishes. Pointwise vanishing needs the return
leg at each level: a function that is unchanged by one-element exchange and whose
sum over a subset of positive size is zero must be zero. The chain closes for
`d >= 4`, which is the standing hypothesis, and the conclusion is correct; the
text as written asserts the endpoint of a four-step induction in half a sentence,
in the one place where the section has deliberately replaced a citation by a
proof. Two sentences would make it checkable.

### 8. Two minor wording items

- `sections/01-introduction.tex:264-266` says the balanced exchange theorem
  "characterizes order six among symmetric conference matrices" without the
  qualifier "nontrivial" that both the theorem statement and the conclusion
  carry. Order two has the property trivially.
- `sections/05-golden-operator.tex:171` opens "For every symmetric matrix `A`",
  but the sentence needs even order for the Pfaffian and order six for the middle
  exterior power. The identity is true generically at order six, as verified
  above; the quantifier should say so.

## Independent cross-check

The pass is itself the independent replay of the C815 and C816 computational
artifacts: every number was recomputed from the manuscript's displayed matrix and
sign conventions rather than read back from
`notes/2026-08-20-c816-theorem-d-table.*` or
`notes/2026-08-20-c816-extremal-minor-census.*`, and the reduced Jacobian table
and the 384-matrix census agree with them. Inside this bundle the order-six
census runs on plain integer arithmetic while the Jacobian, module, and tangent
computations run on sympy exact rationals, so the shared claims — that `C` lies in
`X_{+1}` and that the twenty complementary minors are `+-4` there — are produced
twice by different code paths. The `--check` mode reproduced the tracked
certificate byte for byte, hash
`361710dafcd73139210216447232f7532597628534c7edc569a21233109f1b5f`.

## Suggested paper edits

Ready-to-paste replacements for the eight findings, in the order the findings are
listed above. Line numbers are those of the working tree at commit `49502dcff`,
where the manuscript stands unchanged since `2abe343c4`. Nothing here was applied;
this pass did not edit any file under `papers/`.

### Edit A — prove the tangent-space dimension (finding 1)

`sections/05-golden-operator.tex:467-478`. Replace from "Equality holds, and the
splitting is visible." through "\(-1\)-eigenspace \(\ker\mu\)."; the two
sentences that follow it, on the Jacobian's injectivity on \(\ker\mu\), stay as
they are.

Current:

```tex
Equality holds, and the splitting is visible.  As a \(G\)-module
\(W\cong\mathbf1\oplus\mathbf4\oplus\mathbf5\oplus\mathbf5\), from the character
\((15,3,0,0,0)\) on the classes of orders \(1,2,3,5,5\), and \(T\) is exactly
\(\mathbf1\oplus\mathbf4\).  This is an eigenspace decomposition rather than a
character computation: differentiating \(A^2=\lambda I\) gives
\(CX+XC=\mu(X)I\) for \(X\in T\), and multiplying by \(C\) and using
\(C^2=5I\) gives
\[
 CXC=\mu(X)C-5X,
\]
so \(X\mapsto\tfrac15CXC\) is an involution of \(T\) with \(+1\)-eigenspace
\(\mathbf R\,C\) and \(-1\)-eigenspace \(\ker\mu\).
```

Proposed:

```tex
Equality holds, for the same reason that drives the recognition theorem.
Differentiating \(A^2=\lambda I\) gives \(CX+XC=\mu(X)I\) for \(X\in T\), so
\(T\) lies in the linear space
\[
 L=\{X\in W:CX+XC\in\mathbf R\,I\},
\]
on which \(\mu\) is a linear functional.  Write \(C=\sqrt5\,(P-Q)\) for the
spectral projections \(P+Q=I\) of the preceding subsection, so that
\(CX+XC=2\sqrt5\,(PXP-QXQ)\).  Membership in \(L\) therefore says
\(PXP=cP\) and \(QXQ=-cQ\) for a single scalar \(c\), the scalar recovering
\(\mathbf R\,C\), so that
\[
 L=\mathbf R\,C\oplus\ker\mu,
 \qquad
 \ker\mu=\{X\in W:PXP=QXQ=0\}.
\]
Such an \(X\) is exactly \(B+B^{\mathsf T}\) for an arbitrary map
\(B\colon\operatorname{im}Q\to\operatorname{im}P\), nine parameters, and writing
\(p_i=Pe_i\) and \(q_i=Qe_i\) its diagonal is
\(X_{ii}=2\langle p_i,Bq_i\rangle\).  The six hollowness conditions are thus the
pairings of \(B\) against \(p_iq_i^{\mathsf T}\), and a relation
\(\sum_ic_ip_iq_i^{\mathsf T}=PD_cQ=0\) holds exactly when \(D_c\) commutes with
\(P\), hence with \(C\), hence exactly when \(c\) is constant, since no
off-diagonal entry of \(C\) vanishes.  Five of the six conditions are therefore
independent, \(\dim\ker\mu=4\) and \(\dim L=5\); with the lower bound above,
\(T=L\) and \(\dim T=5\).

The splitting is then visible as an eigenspace decomposition rather than a
character computation: multiplying \(CX+XC=\mu(X)I\) by \(C\) and using
\(C^2=5I\) gives
\[
 CXC=\mu(X)C-5X,
\]
so \(X\mapsto\tfrac15CXC\) is an involution of \(T\) with \(+1\)-eigenspace
\(\mathbf R\,C\) and \(-1\)-eigenspace \(\ker\mu\).  As a \(G\)-module
\(W\cong\mathbf1\oplus\mathbf4\oplus\mathbf5\oplus\mathbf5\), from the character
\((15,3,0,0,0)\) on the classes of orders \(1,2,3,5,5\), and the only
four-dimensional submodule of that is the irreducible \(\mathbf4\), so \(T\) is
exactly \(\mathbf1\oplus\mathbf4\).
```

This is a strengthening rather than a patch. The upper bound now comes from the
same mechanism as the recognition theorem — a diagonal matrix commuting with a
conference matrix whose entries are all nonzero is scalar — so the section's two
rigidity statements rest on one hypothesis instead of two unrelated ones, and the
paragraph's opening claim that the dimension is forced rather than computed
becomes true of both bounds. It also removes the character table from the load
path: the module identification is now used only to name the four-dimensional
constituent, not to establish its dimension.

### Edit B — name the right theorem for the local conclusion (finding 2)

`sections/05-golden-operator.tex:448-450`.

Current:

```tex
The constant-rank theorem confines \(X_{+1}\) to a one-dimensional manifold near
\(C\); the scaling line is a one-dimensional submanifold of \(X_{+1}\), so the
two agree there.
```

Proposed:

```tex
Fourteen of the twenty differentials \(\mathrm dF_S(C)\) are independent, so by
the implicit function theorem their common zero set is a one-dimensional
submanifold \(N\) near \(C\).  It contains \(X_{+1}\), which in turn contains the
scaling line, and a one-dimensional submanifold containing a one-dimensional
submanifold through the same point agrees with it near that point; so all three
agree near \(C\).
```

The constant-rank theorem needs the rank to be locally constant, which the proof
never establishes and does not need. Note also that the C816 card's summary
sentence, "the only external ingredient left is the ordinary constant-rank
theorem", should be updated to name the implicit function theorem once this
lands.

### Edit C — say which representative carries the opposite orientation (finding 3)

`sections/05-golden-operator.tex:370-373`, the last clause of the theorem
statement.

Current:

```tex
The twenty functions \(F_S=h_S-4\tau_S\) have Jacobian of rank fourteen at
\(C\), with kernel the scaling line \(\mathbf R\,C\).  Near \(C\) the locus
\(X_{+1}\) is therefore exactly that line, and the same holds for
\(h_S+4\tau_S\) at the opposite oriented representative.
```

Proposed:

```tex
The twenty functions \(F_S=h_S-4\tau_S\) have Jacobian of rank fourteen at
\(C\), with kernel the scaling line \(\mathbf R\,C\).  Near \(C\) the locus
\(X_{+1}\) is therefore exactly that line, and the same holds for
\(h_S+4\tau_S\) near \(P_\sigma CP_\sigma^{\mathsf T}\) for any odd
permutation \(\sigma\), the representative carrying the reversed Hodge
orientation.  The reversal is of the orientation, not of the matrix: \(-C\)
again lies in \(X_{+1}\), since that locus is a cone.
```

As it stands the clause is false under this paper's own use of "opposite", which
`sections/03-orientation-source.tex` fixes as the deck-opposite source \(-C\);
the paragraph immediately above the theorem already puts the whole line
\(\mathbf R\,C\) inside \(X_{+1}\).

### Edit D — bring the abstract back to the theorem (finding 4)

`clebsch_passages.tex:48-51`.

Current:

```tex
Proportionality of the commutator
Pfaffian to the triangle cubic already characterizes order six, forcing a
scalar square, for real symmetric zero-diagonal matrices with nonzero
off-diagonal entries.
```

Proposed:

```tex
Among real symmetric zero-diagonal matrices of even order with nonzero
off-diagonal entries, nonzero proportionality of the commutator Pfaffian to the
triangle cubic already forces order six and a scalar square.
```

This restores the two dropped hypotheses and drops "characterizes", which reads
as an equivalence next to the abstract's genuine equivalence about the exchange
spectrum. The wording now matches the introduction and the conclusion, which both
already say "forces order six and a scalar square".

### Edit E — give the recognition theorem its priority boundary (finding 5)

`sections/05-golden-operator.tex`, after the boundary paragraph at lines 348-351
and before `\paragraph{Rigidity of the equality.}`. This is new text, licensed by
row `OPER-5` of `literature-boundaries.md`, which permits "we prove" and "we have
not located" and forbids "first" and "new".

Proposed:

```tex
Both halves of this statement have classical ingredients.  Which forms are
Pfaffians of skew matrices of linear forms is settled in general by Beauville
\cite{BeauvilleDeterminantal}, and the cubic-surface case is constructive in
Tanturri \cite{TanturriPfaffian}, so a \(6\times6\) linear Pfaffian
representation of a cubic surface is a known object.  On the other side, the
triangle cubic's coefficients are the order-three cycle products, which for a
hollow symmetric matrix are half the principal three-by-three minors,
\[
 \det A[S,S]=2a_{ij}a_{jk}a_{ki}
 \qquad(S=\{i,j,k\}),
\]
and cycle-sum coordinates on principal minors are Huang and Oeding's
\cite{HuangOeding}.  The conclusion is classical as a description too: after
scaling, \(A^2=\lambda I\) says that \(A\) is a hollow symmetric involution,
equivalently a constant-diagonal rank-three projection, equivalently an
equal-norm tight frame of six vectors in \(\mathbf R^3\), and in the
equal-modulus case this is the classical correspondence between conference
matrices, regular two-graphs, and equiangular lines.  What we prove here is the
converse direction, that proportionality of the two cubics forces the order and
the scalar square, together with its order-six nondegeneracy form in
Proposition~\ref{prop:nonsingular-complementary-minors}.  We have not located
either statement in the bounded audit recorded with the distributed source
archive, whose scope and access gaps are summarized in
Section~\ref{sec:verification}; to our knowledge neither appears in the
Pfaffian, principal-minor, determinantal-representation, conference-matrix, or
tight-frame literature.  Note that Greaves and Suda's two-valued fourth-order
spectrum, used in Section~\ref{sec:reconstruct-signing}, concerns the principal
\(4\times4\) minors and not these complementary \(3\times3\) minors.
```

With three bibliography entries in the house style of `sections/10-references.tex`:

```tex
\bibitem{BeauvilleDeterminantal}
A.~Beauville,
\emph{Determinantal hypersurfaces},
Michigan Mathematical Journal \textbf{48} (2000), 39--64;
arXiv:math/9910030.

\bibitem{TanturriPfaffian}
F.~Tanturri,
\emph{Pfaffian representations of cubic surfaces},
Geometriae Dedicata \textbf{168} (2014), 69--86,
\href{https://doi.org/10.1007/s10711-012-9818-x}{doi:10.1007/s10711-012-9818-x};
arXiv:1203.0999.

\bibitem{HuangOeding}
H.~Huang and L.~Oeding,
\emph{Symmetrization of principal minors and cycle-sums},
Linear and Multilinear Algebra \textbf{65} (2017), 1194--1219,
\href{https://doi.org/10.1080/03081087.2016.1233932}{doi:10.1080/03081087.2016.1233932};
arXiv:1510.02515.
```

Two cautions on this edit. The audit read all three sources at `partial` depth
from arXiv preprints rather than the published versions, so the volume, year and
page data above should be confirmed against the journal records before the edit
is committed; the digital object identifiers and arXiv identifiers are the parts
the audit verified. And the closing negative must keep "to our knowledge" and
must not acquire "first" or "new", which is what row `OPER-5` licenses and
forbids.

### Edit F — say what nondegeneracy actually replaces (finding 6)

`sections/05-golden-operator.tex:533-538`.

Current:

```tex
This is where the factor \(4\) in
Theorem~\ref{thm:triangle-pfaffian-recognition} comes from.  It is not the
output of the two orbit computations displayed earlier: a \(3\times3\) sign
matrix has determinant \(0\) or \(\pm4\) and nothing else, so once the
complementary minors are forced away from zero the constant has no freedom
left.
```

Proposed:

```tex
This is where the magnitude of the factor \(4\) in
Theorem~\ref{thm:triangle-pfaffian-recognition} comes from, and it owes nothing
to the two orbit computations displayed earlier: a \(3\times3\) sign matrix has
determinant \(0\) or \(\pm4\) and nothing else, so once the complementary minors
are forced away from zero the magnitude has no freedom left.  What the orbit
computations supply is the remaining half, that the sign is the same for all
twenty triples; nondegeneracy alone constrains each triple separately.
```

### Edit G — make the inclusion-rank descent checkable (finding 7)

`sections/05-golden-operator.tex:654-657`.

Current:

```tex
That is the same hypothesis one subset size lower, for the difference function
on the remaining \(2d-2\) points; descending on the subset size makes the
difference vanish pointwise, and one-element exchanges connect all four-sets.
```

Proposed:

```tex
That is the same hypothesis one subset size lower, for the difference function
on the remaining \(2d-2\) points.  Two more exchanges of the same kind reach
subsets of size one, where the hypothesis says that the third difference has
vanishing sum over every subset of size \(d-3\); comparing two such subsets that
differ in one element makes that difference constant, and its vanishing sum then
makes it zero.  Now read the chain upwards.  At each level a function whose
one-element differences all vanish is constant, since one-element exchanges
connect the subsets of a fixed size, and a constant with vanishing sum over a
nonempty family is zero.  Applying this at sizes one, two and three in turn makes
\(f\) constant on four-sets.  Every subset and exchange used exists because
\(d\geq4\).
```

The descent by itself terminates with a threefold difference vanishing, which is
weaker than pointwise vanishing; the return leg is what closes it. This is the
one place in the section where a citation was deliberately replaced by a proof,
so the proof should be legible.

### Edit H — two wording repairs (finding 8)

`sections/01-introduction.tex:264-266`:

```tex
Theorem~\ref{thm:balanced-exchange-rigidity} characterizes order six among
```

becomes

```tex
Theorem~\ref{thm:balanced-exchange-rigidity} characterizes order six among
nontrivial
```

so that the sentence reads "characterizes order six among nontrivial symmetric
conference matrices by cut-independent balanced exchange spectrum", matching the
qualifier the theorem statement and the conclusion both carry; order two has the
property trivially.

`sections/05-golden-operator.tex:171`:

```tex
For every symmetric matrix \(A\), the coefficient of \(x_S\) in
```

becomes

```tex
For every symmetric matrix \(A\) of order six, the coefficient of \(x_S\) in
```

since the sentence needs even order for the Pfaffian and order six for the middle
exterior power.

### What these edits cost

Edit A adds roughly fifteen lines and Edit E roughly twenty, including the three
bibliography entries; Edit G adds five, and the rest are net neutral or shorter.
The page count should absorb this at the current thirty-eight pages, but the
paper-local build gate is the check. No edit changes a theorem's content, a claim
identifier, a statement label, or the trust manifest, so the statement-identity
gate and `EXPECTED_LABELS` are untouched. Edit E adds bibliography keys, which
the reference and citation checks will see.

## The global weighted boundary: probe, and why it settles nothing

The boundary sentence after the recognition theorem is now correct — what is
unclassified is the set of weighted matrices satisfying the *proportionality*,
not the solutions of `A^2 = lambda I`. I probed whether that set is larger than
the conference orbit, by solving the twenty equations `h_S = mu tau_S` with `mu`
free on the affine slice `a_01 = 1`, from 3000 random starts with a fixed seed.
No solution with all entries bounded away from zero and `|mu| > 1/2` was found.

This is not evidence for emptiness and is deliberately excluded from the
certificate. The search also failed to recover the *known* solutions: the
conference orbit is isolated modulo scaling in an overdetermined system, which is
precisely the configuration a random-start least-squares solver does not find.
Every point it converged to had a vanishing entry, outside the theorem's
hypothesis. Settling the boundary needs an algebraic method — a Groebner or
numerical-algebraic-geometry decomposition of the twenty cubics — not a local
solver.

## Vibe check

Good. The mathematics of this section survived a hostile recomputation intact,
including the parts a referee is most likely to test by hand — the reduced
Jacobian table, the order-ten cut split, and the seven-point sharpness. The two
proof-level findings are both one-sentence repairs to argument bookkeeping rather
than to content, and the largest remaining gap is positioning: the recognition
theorem has a ledger row and no sentence in the paper.

## Recommended disposition before gate 4

Findings 1, 2, 3 and 4 should land before the fresh cold read, since a
context-free reader will hit all four. Finding 5 is the substantive C816 decision
still open and should be taken with them. Findings 6, 7 and 8 can ride along in
the same pass. None requires new mathematics.
