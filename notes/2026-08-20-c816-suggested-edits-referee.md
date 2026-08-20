# C816 gate 2 — referee of the red-team's suggested edits (tightening + adversarial check)

**Task:** C816 (`clebsch` lane), review of the proposed replacements in
`notes/2026-08-20-c816-theorem-red-team.md`, "Suggested paper edits" A–H.
**Date:** 2026-08-20.
**Constraint honoured:** no file under `papers/` was touched; the red-team note
was not edited. Line numbers below are those of the unchanged working tree.

## Verdict

All eight proposed edits are mathematically sound: every step of Edit A's
tangent-space chain, Edit B's implicit-function sandwich, Edit C's two membership
claims, Edit E's minor identity, and Edit G's descend-then-ascend induction was
re-derived here and confirmed, most of them also in exact arithmetic. None is
ready to paste as drafted. Edit E violates its own licensing row twice — the
closing negative names a different literature list than the `OPER-5` audit
actually searched, and the "What we prove" sentence drops the `nonzero` that
finding 4 exists to restore; Edit A cites "the preceding subsection" for
projectors defined in the same subsection and momentarily contradicts its own
definition of `ker mu`; Edits A, E, F and G run longer than their content needs.
The tightened versions below repair all of this; each earns accept-with-change,
and the two Edit H items are accepted as drafted. One thing the red-team pass
missed is substantive: its finding 4 calls the introduction and conclusion
"exact", but both state the recognition theorem without `nonzero`
proportionality, and that unqualified statement is *false* — the order-four
all-ones matrix has identically vanishing commutator Pfaffian, hence satisfies
zero proportionality at the wrong order (verified symbolically below). Edit D's
repair must be extended to `sections/01-introduction.tex:239-241` and
`sections/09-conclusion.tex:18-19`, or the abstract will disagree with both after
the edit lands.

## Edit A — tangent-space dimension (finding 1): accept with changes

Replaces `sections/05-golden-operator.tex:467-478`, from "Equality holds, and the
splitting is visible." through "\(-1\)-eigenspace \(\ker\mu\)."; the two
following sentences on the Jacobian's injectivity stay.

```tex
Equality holds, by the same mechanism that drives the recognition theorem.
Differentiating \(A^2=\lambda I\) gives \(CX+XC=\mu(X)I\) for \(X\in T\), so
\(T\) lies in the linear space
\[
 L=\{X\in W:CX+XC\in\mathbf R\,I\},
\]
on which \(\mu\) is a linear functional.  Writing \(P_\pm=(I\pm C/\sqrt5)/2\)
for the spectral projections of \(C\), so that
\(CX+XC=2\sqrt5\,(P_+XP_+-P_-XP_-)\), membership in \(L\) says
\(P_+XP_+=cP_+\) and \(P_-XP_-=-cP_-\) for a single scalar \(c\); the scalar
part is \(c(P_+-P_-)=cC/\sqrt5\), so \(L=\mathbf R\,C\oplus\ker\mu\) with
\(\ker\mu=\{X\in W:P_+XP_+=P_-XP_-=0\}\).  Forgetting hollowness, a symmetric
\(X\) with both spectral blocks zero is \(B+B^{\mathsf T}\) for an arbitrary
\(B\colon\operatorname{im}P_-\to\operatorname{im}P_+\), nine parameters, with
diagonal \(X_{ii}=2\langle p_i,Bq_i\rangle\) where \(p_i=P_+e_i\) and
\(q_i=P_-e_i\).  Hollowness pairs \(B\) against the six matrices
\(p_iq_i^{\mathsf T}\), and a relation
\(\sum_ic_ip_iq_i^{\mathsf T}=P_+D_cP_-=0\) makes the diagonal matrix \(D_c\)
commute with \(P_+\), hence with \(C\), hence forces \(c\) constant, since no
off-diagonal entry of \(C\) vanishes; as \(\sum_ip_iq_i^{\mathsf T}=P_+P_-=0\),
the relations are exactly the constants.  Five of the six conditions are
therefore independent, \(\dim\ker\mu=4\) and \(\dim L=5\), and the lower bound
gives \(T=L\).

The splitting is an eigenspace decomposition: multiplying \(CX+XC=\mu(X)I\)
by \(C\) and using \(C^2=5I\) gives
\[
 CXC=\mu(X)C-5X,
\]
so \(X\mapsto\tfrac15CXC\) is an involution of \(T\) with \(+1\)-eigenspace
\(\mathbf R\,C\) and \(-1\)-eigenspace \(\ker\mu\).  As a \(G\)-module
\(W\cong\mathbf1\oplus\mathbf4\oplus\mathbf5\oplus\mathbf5\), from the
character \((15,3,0,0,0)\) on the classes of orders \(1,2,3,5,5\); the only
four-dimensional submodule is the irreducible \(\mathbf4\), so \(T\) is
exactly \(\mathbf1\oplus\mathbf4\).
```

Changes against the red-team draft, and why:

1. The draft's "the spectral projections \(P+Q=I\) of the preceding subsection"
   is a wrong locator: the projectors \(P_{T,\pm}\) are defined inside
   Theorem~`thm:operator-shadows`, in the *same* subsection
   (`sec:four-shadows`). The tightened text defines \(P_\pm\) inline in one
   clause, matching the \(P_\pm\) notation the exchange-spectra subsection
   already uses at its own representative.
2. The draft's "Such an \(X\) is exactly \(B+B^{\mathsf T}\) for an arbitrary
   map" is false for \(X\in\ker\mu\subset W\), which is already hollow; the
   arbitrariness holds only before hollowness is imposed. "Forgetting
   hollowness" restores the correct order of quantification.
3. Added the four-word converse "\(\sum_ip_iq_i^{\mathsf T}=P_+P_-=0\)", which
   the equalities \(\dim\ker\mu=4\), \(\dim L=5\) need (the draft's chain only
   bounds the relation space from above).
4. Compressed throughout; the second paragraph drops "rather than a character
   computation" (the new proof makes the contrast moot) and "then visible".

Mathematics checked (all confirmed, see the computational section):
\(C=\sqrt5(P_+-P_-)\); \(CX+XC=2\sqrt5(P_+XP_+-P_-XP_-)\); the
block-membership characterization of \(L\); \(\dim L=5\); \(\dim\ker\mu=4\);
the rank of \(\{p_iq_i^{\mathsf T}\}\) is five with nullspace exactly the
constants; \(\ker\mu\) lies in the \(-1\)-eigenspace of \(X\mapsto CXC/5\); and
the module step — a four-dimensional submodule of
\(\mathbf1\oplus\mathbf4\oplus\mathbf5\oplus\mathbf5\) must be a subsum of
constituent dimensions from \(\{1,4,5,5\}\) totalling four, and with a single
trivial summand the only option is the irreducible \(\mathbf4\) — is correct,
and the \(\mathbf4\) is unique because its multiplicity is one. The retained
lower-bound paragraph and the retained injectivity sentences are consistent
with the new text.

## Edit B — implicit function theorem (finding 2): accept with changes

Replaces `sections/05-golden-operator.tex:448-450`.

```tex
Fourteen of the twenty differentials \(\mathrm dF_S(C)\) are independent, so
by the implicit function theorem the common zero set of those fourteen
functions is a one-dimensional submanifold near \(C\).  It contains
\(X_{+1}\), which contains the scaling line; two one-dimensional
submanifolds, one inside the other through \(C\), coincide near \(C\), so all
three sets do.
```

Changed: compressed the draft's second sentence, whose "a one-dimensional
submanifold containing a one-dimensional submanifold through the same point
agrees with it near that point" said the right thing at twice the length.
The argument closes with no constant-rank hypothesis: rank fourteen at the
single point \(C\) makes the fourteen chosen functions a submersion near
\(C\) (openness of maximal rank is automatic, not a hypothesis), the zero set
\(N\) is a one-manifold, and the sandwich
\(\mathbf R\,C\subseteq X_{+1}\subseteq N\) between two one-dimensional
submanifolds forces local equality of all three. The containment statement is
correctly quantified: the lemma is applied to the two manifolds \(N\) and the
line, and \(X_{+1}\) — not known to be a manifold beforehand — is squeezed.
The proof's retained final sentence (odd signed permutations carry the
argument to \(X_{-1}\)) is unaffected. The red team's rider stands: the C816
card's "only external ingredient left is the ordinary constant-rank theorem"
must change to name the implicit function theorem when this lands.

## Edit C — the opposite oriented representative (finding 3): accept with changes

Replaces `sections/05-golden-operator.tex:370-373`, the theorem statement's
last clause.

```tex
The twenty functions \(F_S=h_S-4\tau_S\) have Jacobian of rank fourteen at
\(C\), with kernel the scaling line \(\mathbf R\,C\).  Near \(C\) the locus
\(X_{+1}\) is therefore exactly that line, and the same holds for
\(h_S+4\tau_S\) near every odd signed-permutation image of \(C\), the
representatives that reverse the orientation of the signed label space.
```

Changes against the draft: (i) generalized "\(P_\sigma CP_\sigma^{\mathsf T}\)
for any odd permutation \(\sigma\)" to every odd *signed*-permutation image,
which is what the proof's final sentence actually delivers and what the
recognition theorem's orientation-character clause refers to; (ii) replaced
"reversed Hodge orientation" by the recognition theorem's own term,
"orientation of the signed label space"; (iii) dropped the draft's second
sentence ("The reversal is of the orientation, not of the matrix: \(-C\) again
lies in \(X_{+1}\)...") from the theorem statement — the paragraph directly
above the theorem already places the whole line \(\mathbf R\,C\), hence
\(-C\), inside \(X_{+1}\), and a theorem statement should not carry a guard
against a misreading its own wording no longer permits. If the author wants
the guard, it belongs in the prose after the theorem.

Mathematics confirmed exactly: for the pentagon representative,
\(h_S/\tau_S=+4\) on all twenty triples at \(C\) and at \(-C\) (so \(-C\) lies
in \(X_{+1}\), as the cone structure requires), while
\(h_S/\tau_S=-4\) on all twenty triples at \(P_{(01)}CP_{(01)}^{\mathsf T}\)
(so the odd image lies in \(X_{-1}\)). A consistency point worth recording:
at order six, global negation is \(D_\epsilon=-I\) with
\(\det D_\epsilon=(+1)\), an *even* signed permutation, so "odd
signed-permutation image" excludes \(-C\) automatically and the statement has
no residual ambiguity.

## Edit D — abstract sentence (finding 4): accept with changes

Replaces `clebsch_passages.tex:48-51`.

```tex
For real symmetric zero-diagonal matrices with nonzero off-diagonal entries,
nonzero proportionality of the commutator Pfaffian to the triangle cubic
already forces order six and a scalar square.
```

Changed: dropped the draft's "of even order", per the author's test — and it
does drop. "Commutator Pfaffian" presupposes an even order for the Pfaffian to
be defined, and under the convention that an odd-order Pfaffian vanishes, the
nonzero-proportionality hypothesis is unsatisfiable at odd order (the triangle
cubic of a matrix with nonzero entries is nonzero), so no false reading
survives. Also reordered hypotheses-first to match the introduction's voice.
The result is twenty-five words against the current sentence's twenty-six, no
proof mechanism, and it restores both dropped hypotheses ("nonzero"
proportionality) while removing the two-way-reading "characterizes". "Already"
is retained: it carries the real claim that the single identity, without the
marked datum, suffices, and the introduction and conclusion both use it.

## Edit E — priority boundary paragraph (finding 5): accept with changes

New text after the boundary paragraph at
`sections/05-golden-operator.tex:348-351`, before
`\paragraph{Rigidity of the equality.}`.

```tex
Both halves of the theorem have classical ingredients.  Which forms are
Pfaffians of skew matrices of linear forms is settled in general by Beauville
\cite{BeauvilleDeterminantal}, with the cubic-surface case constructive in
Tanturri \cite{TanturriPfaffian}, so a \(6\times6\) linear Pfaffian
representation of a cubic surface is a known object.  The triangle cubic's
coefficients are the order-three cycle products, half the principal
three-by-three minors of a hollow symmetric matrix
(\(\det A[S,S]=2a_{ij}a_{jk}a_{ki}\) for \(S=\{i,j,k\}\)), and cycle-sum
coordinates on principal minors are Huang and Oeding's \cite{HuangOeding}.
The conclusion is likewise classical as a description: \(A^2=\lambda I\)
makes \(A/\sqrt\lambda\) a hollow symmetric involution, equivalently a
constant-diagonal rank-three projection or an equal-norm tight frame of six
vectors in \(\mathbf R^3\), and the equal-modulus case is the classical
correspondence between conference matrices, regular two-graphs, and
equiangular tight frames.  What we prove is the converse direction: nonzero
proportionality of the two cubics forces the order and the scalar square,
with the order-six nondegeneracy form in
Proposition~\ref{prop:nonsingular-complementary-minors}.  We have not located
either statement in the bounded audit documented with the distributed source
archive, whose scope and access gaps are summarized in
Section~\ref{sec:verification}; to our knowledge neither appears in the
Pfaffian-commutator, compound-minor, determinantal-representation,
conference-matrix, tight-frame, or maximal-determinant design literature.
Greaves and Suda's two-valued fourth-order spectrum, used in
Section~\ref{sec:reconstruct-signing}, concerns principal \(4\times4\)
minors, not these complementary \(3\times3\) minors.
```

Bibliography entries for `sections/10-references.tex`: adopt the red-team
draft's three `\bibitem` blocks unchanged (`BeauvilleDeterminantal`,
`TanturriPfaffian`, `HuangOeding`), **with its caution kept live**: the audit
verified the DOIs and arXiv identifiers only; the volume, year, and page data
are unverified — the `OPER-5` row carries none of them — and must be confirmed
against journal records before commit.

Changes against the draft, each against the `OPER-5` licence:

1. "What we prove here is the converse direction, that proportionality of the
   two cubics forces..." dropped `nonzero` — the exact hypothesis finding 4
   exists to restore, and the row's own statement of the converse says
   "nonzero proportionality". Restored.
2. The closing negative named "the Pfaffian, principal-minor,
   determinantal-representation, conference-matrix, or tight-frame
   literature". The row's searched domains are "Pfaffian-commutator,
   compound-minor, determinantal-representation, conference-matrix,
   tight-frame, and maximal-determinant/D-optimal-design". The draft both
   overstates ("Pfaffian" is broader than the searched "Pfaffian-commutator",
   "principal-minor" is not "compound-minor") and understates (drops the
   maximal-determinant domain). A negative must name exactly the searched
   scope; aligned to the row.
3. "recorded with the distributed source archive" changed to "documented with",
   the phrasing the section's two existing negatives (lines 981-992) use.
4. "equiangular lines" changed to "equiangular tight frames", the row's term.
5. "Note that Greaves and Suda's..." lost its "Note that" (house style), and the
   whole paragraph is compressed, with the minor identity inlined.

Line-by-line licence check on the final text: "we prove" and "we have not
located" both present; "first" and "new" absent; the one negative carries "to
our knowledge"; no novelty claimed for Pfaffian representations, cycle-sum
coordinates, or the conference/two-graph/tight-frame correspondence — each is
explicitly called classical or known. The attributions match the row's scoping
exactly: Beauville owns the general settling, Tanturri the constructive
cubic-surface case, Huang and Oeding the cycle-sum coordinates, and Greaves and
Suda are distinguished on principal versus complementary minors. The identity
\(\det A[S,S]=2a_{ij}a_{jk}a_{ki}\) is correct (verified symbolically). All
referenced labels (`sec:verification`, `sec:reconstruct-signing`,
`prop:nonsingular-complementary-minors`) exist; the three cite keys are new,
as intended, and `sections/10-references.tex` is the real references file.

## Edit F — what nondegeneracy replaces (finding 6): accept with changes

Replaces `sections/05-golden-operator.tex:533-538`.

```tex
This is where the magnitude of the factor \(4\) in
Theorem~\ref{thm:triangle-pfaffian-recognition} comes from: a \(3\times3\)
sign matrix has determinant \(0\) or \(\pm4\) and nothing else, so once the
complementary minors are forced away from zero the magnitude has no freedom
left.  The two orbit computations displayed earlier supply what nondegeneracy
cannot, the single sign shared by all twenty triples.
```

Changed: merged the draft's three sentences into two, folding "it owes nothing
to the two orbit computations" into the colon construction and "nondegeneracy
alone constrains each triple separately" into "what nondegeneracy cannot". The
mathematical split is right and the draft's repair is the correct one: the
census bounds each \(|\det|\) triple by triple, and the coherence of the sign
across the twenty triples — needed for \(\Phi_A=\pm4\mathcal T_A\) at the
pentagon representative — comes only from the two orbit computations.

## Edit G — inclusion-rank descent (finding 7): accept with changes

Replaces `sections/05-golden-operator.tex:654-657`.

```tex
That is the same hypothesis one subset size lower, for the difference
function on the remaining \(2d-2\) points.  Two more exchanges of the same
kind leave a function of single points whose sum over every
\((d-3)\)-subset vanishes; comparing two such subsets differing in one
element makes it constant, hence zero.  Now climb back up: a function whose
one-element differences all vanish is constant, since one-element exchanges
connect the subsets of a fixed size, and a constant with vanishing sum over
a nonempty family is zero.  Applied to the second and then the first
difference this makes both vanish identically, and vanishing first
differences make \(f\) constant on four-sets.  Every subset and exchange
used exists because \(d\geq4\).
```

Changed: compressed the draft by about a third and removed its double count —
the draft settles the size-one level in the descent sentence and then applies
the upward principle "at sizes one, two and three", re-doing size one; the
tightened text applies it to the second and first differences only, which is
what remains. Re-derivation of the whole induction: the first difference
\(g(S)=f(S\cup a)-f(S\cup b)\) on three-subsets of the \(2d-2\) remaining
points has vanishing sum over every \((d-1)\)-subset (every such subset is
\(Y\cap Y'\) for an actual exchange, since any \(d\)-subset is a balanced
half); differencing twice more yields the second difference on pairs of a
\(2d-4\)-set with vanishing \((d-2)\)-subset sums, and the third difference on
points of a \(2d-6\)-set with vanishing \((d-3)\)-subset sums. The bottom
closes: two \((d-3)\)-subsets differing in one element exist exactly when
\(2d-6>d-3\), i.e.\ \(d\geq4\), giving constancy, and the family is nonempty
(\(d-3\geq1\)), giving zero. Climbing up, the nonemptiness side conditions are
\(\binom{d-2}2\geq1\) and \(\binom{d-1}3\geq1\), both equivalent to
\(d\geq4\), and the Johnson-graph connectivity used at sizes two, three and
four holds since each ground set strictly exceeds the subset size. So the
closing sentence "\(d\geq4\)" is exactly right, and \(d=4\) is tight (the
bottom ground set has two points). The endpoint is only constancy of \(f\),
not vanishing — correct, since \(f\) has no vanishing-sum hypothesis — and the
tightened text preserves that asymmetry. Independently confirmed at \(d=5\):
the space of functions on four-subsets of ten points with equal sums over all
balanced halves is exactly the constants (nullity one).

## Edit H — two wording repairs (finding 8): accept as drafted

Both items are minimal and correct as proposed.

1. `sections/01-introduction.tex:264-266`: insert "nontrivial", matching the
   theorem's "unique nontrivial realized symmetric conference order"; order
   two has the property trivially (\(d=1\leq3\)).
2. `sections/05-golden-operator.tex:171`: "For every symmetric matrix \(A\) of
   order six" — the Pfaffian needs even order and the middle exterior power
   needs order six; the identity needs no hollowness (the diagonal of \(A\)
   drops out of \([D_x,A]\)), so "symmetric" alone is the right hypothesis
   otherwise.

## Computational checks

Both scripts live in the session scratchpad
(`/tmp/claude-1000/-home-tavis-src-othello-rust/f360236d-f0ae-4bfe-899c-0cff5f00d406/scratchpad/`);
they are referee scratch work, deliberately not a paper-facing evidence bundle —
the red-team certificate remains the committed artifact.

1. `uv run --with sympy --with numpy python3 c816_referee_checks.py` — exact
   sympy arithmetic on a pentagon conference matrix built from the
   manuscript's gauge (row zero all ones, negative pentagon on the rest).
   Output: \(C^2=5I\); \(h_S/\tau_S=4\) on all twenty triples at \(C\) and at
   \(-C\); \(h_S/\tau_S=-4\) on all twenty at
   \(P_{(01)}CP_{(01)}^{\mathsf T}\) (Edit C); \(\dim L=5\),
   \(\dim\ker\mu=4\), rank of \(\{p_iq_i^{\mathsf T}\}_{i}\) equal to five
   with nullspace spanned by \((1,1,1,1,1,1)\), and \(CXC=-5X\) on a basis of
   \(\ker\mu\) (Edit A); Jacobian of the twenty \(F_S\) at \(C\) of rank
   fourteen with one-dimensional kernel proportional to \(C\) (Edit B);
   \(h_S/\det A[S^c,S]=\pm1\) per triple on a generic symmetric matrix,
   consistent with the manuscript's "up to sign";
   \(\det[[0,a,b],[a,0,c],[b,c,0]]=2abc\) (Edit E); and
   \(\operatorname{Pf}[D_y,J_4]\equiv0\) for the order-four all-ones matrix
   (the missed-finding counterexample below).
2. `uv run --with numpy python3 c816_editG_d5.py` — at order ten, the
   difference map over all 251 independent balanced-half comparisons on the
   210 four-subsets has rank 209, nullity one: equal balanced-half sums force
   constancy on four-sets, Edit G's endpoint, independently of the induction.

## What the red-team pass missed

1. **The introduction and conclusion carry the abstract's gap, and there it is
   an actual falsehood.** Finding 4 repairs only the abstract and calls
   `sections/01-introduction.tex:238-241` and `sections/09-conclusion.tex:18-19`
   "exact". Both say "proportionality of the commutator Pfaffian to the
   triangle cubic ... forces order six and a scalar square" with no
   "nonzero". Under the standard reading in which the zero polynomial is
   proportional to everything, this is false: the order-four all-ones matrix
   has \(\operatorname{Pf}[D_x,J_4]\equiv0\) (the classical three-term
   identity, verified symbolically above) and nonzero triangle cubic, so it
   satisfies proportionality with \(\mu=0\) at order four. If Edit D lands as
   tightened, the abstract will say "nonzero" while the introduction and
   conclusion do not — the cold reader's first inconsistency. Recommend the
   same one-word insertion, "nonzero proportionality", at both sites in the
   same commit as Edit D.
2. **Draft A's internal locator is wrong.** "The spectral projections ... of
   the preceding subsection" points nowhere: the projectors are defined
   inside Theorem~`thm:operator-shadows` in the same subsection. Fixed in the
   tightened text.
3. **Draft A's parametrization sentence contradicts its own definition.**
   "Such an \(X\) is exactly \(B+B^{\mathsf T}\) for an *arbitrary* map" is
   asserted of \(X\in\ker\mu\subset W\), which is already hollow. Fixed by
   "Forgetting hollowness".
4. **Draft E fails its own licence twice** (missing "nonzero"; mismatched and
   partly overbroad literature list against the `OPER-5` searched domains) and
   deviates from the section's house phrasing for audit negatives. All fixed
   above.
5. A small consistency fact worth having on record for Edit C: at order six,
   global negation \(D_\epsilon=-I\) has determinant \(+1\), so \(-C\) is an
   *even* signed-permutation image of \(C\); "odd signed-permutation image"
   therefore excludes \(-C\) with no extra clause, which is why the guard
   sentence can be dropped from the theorem statement.
