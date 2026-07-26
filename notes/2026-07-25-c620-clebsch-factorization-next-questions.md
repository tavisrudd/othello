# C620/C621 — Clebsch factorization: graded algebra and Gorenstein gate

**Lane:** `clebsch`

**Date:** 2026-07-25

**Status:** C620, C621, and C616 complete and adopted in Paper II.

## Origin

Two independent, unprimed cold readers of the standalone Paper II PDF were
asked:

1. what questions the paper begs;
2. what its results imply one should immediately check or prove; and
3. what strong mathematical connections it leaves underdeveloped.

Both readers independently found the same two immediate directions:

- the cubic moment completes the Schur-power filtration of the affine
  evaluation algebra; and
- the resulting symmetric Hilbert function points toward self-associated
  points, Cayley--Bacharach, and an arithmetically Gorenstein coordinate
  ring with a cubic inverse system.

They also independently identified classical \(SL_2\) invariant theory as
the likely route from the three certified rank calculations to a uniform
rank-three theorem. That direction belongs to C616 rather than a duplicate
task.

## C620 — immediate graded-evaluation theorem

**Completed 2026-07-25.**  The symbolic corollary, trust disposition,
validation, and mystery ledger are in
`notes/2026-07-25-c620-graded-evaluation-algebra.md`.

Let \(L\subseteq k^\Omega\) be the affine evaluation space of either
balanced \(B_3\) or \(H_3\) quotient configuration. Paper II proves
\[
 (L^{\circ2})^\perp=k\epsilon,\qquad
 \dim L^{\circ2}=2q-1,
\]
where \(\epsilon\) is the sheet sign, and it proves that the signed cubic
moment \(\mu_3\) is nonzero.

Because \(1\in L\),
\[
 L^{\circ2}\subseteq L^{\circ3}.
\]
Nonvanishing of \(\mu_3\) means that \(\epsilon\) does not annihilate
\(L^{\circ3}\). Since \(L^{\circ2}\) is already the hyperplane annihilated
by \(\epsilon\), one additional direction gives
\[
 L^{\circ3}=k^\Omega.
\]
Multiplication by \(1\) then gives \(L^{\circ d}=k^\Omega\) for every
\(d\ge3\). Thus
\[
 \dim L^{\circ d}=
 \begin{cases}
 1,&d=0,\\
 q,&d=1,\\
 2q-1,&d=2,\\
 2q,&d\ge3.
 \end{cases}
\]

For the homogenized point configuration
\[
 \widehat X=\{[1:x_M]:M\in\Omega\}\subseteq\mathbb P^{q-1},
\]
this is the Hilbert function
\[
 1,\ q,\ 2q-1,\ 2q,\ 2q,\ldots
\]
and hence the \(h\)-vector
\[
 (1,q-1,q-1,1).
\]

### C620 completion gate

1. Check carefully that tensor nonvanishing in the paper's conventions
   yields a triple product pairing nontrivially with \(\epsilon\); record
   the polarization hypothesis.
2. Prove \(L^{\circ3}=k^\Omega\), the full Schur-power filtration, and the
   Hilbert-function corollary symbolically.
3. Decide whether the result belongs in Paper II immediately after the
   balanced cubic theorem or only in this research note. If inserted,
   update the statement identity, trust manifest, aggregate replay, PDF,
   and cold-read surface.
4. Do not call the configuration Gorenstein, self-associated, or
   Cayley--Bacharach in C620; those are C621 questions.

## C621 — self-associated/Gorenstein falsifier and theorem gate

**Completed 2026-07-25.**  Both configurations pass.  The theorem,
ideal/resolution certificate, independent replay, literature audit, and
mystery ledger are in `notes/2026-07-25-c621-gorenstein-gate.md`.

The numerical signal is unusually sharp. Writing \(n=q-1\),
\(\widehat X\subseteq\mathbb P^n\) has \(2q=2n+2\) reduced points and
symmetric \(h\)-vector
\[
 (1,n,n,1).
\]
The unique quadratic evaluation dependence has full support and is the
sheet sign. These are the numerical features of a self-associated or
arithmetically Gorenstein point configuration of socle degree three.
They do not by themselves prove either property over the present finite
fields.

The candidate strengthening is:

> For \(T=B_3,H_3\), the homogenized balanced quotient configuration is a
> reduced arithmetically Gorenstein set of \(2n+2\) self-associated points
> in \(\mathbb P^n\), with \(h\)-vector \((1,n,n,1)\), and its dualizing
> residue vector is the sheet sign. Its Artinian reduction has a cubic
> Macaulay inverse system canonically related to \(\mu_3\).

### C621 falsifier-first gate

1. Construct the homogeneous saturated ideals of the \(B_3/\mathbb F_7\)
   and \(H_3/\mathbb F_{11}\) point sets from the frozen quotient data.
2. Compute, with a separately specified replay where feasible:
   - Hilbert functions and saturatedness;
   - minimal graded free resolutions and Betti tables;
   - Cohen--Macaulay type;
   - Cayley--Bacharach deletion tests in the predicted degree;
   - Artinian reductions and socle dimensions;
   - candidate Macaulay inverse-system cubics and their relation to
     \(\mu_3\).
3. Stop with an exact negative if either configuration is not
   arithmetically Gorenstein or not self-associated. Preserve the Hilbert
   theorem from C620 independently.
4. If both are positive, prove the result conceptually, determine whether
   it follows from a known \(2n+2\)-point self-association criterion, and
   complete a focused literature audit before making a novelty claim.
5. Only then decide whether this is a Paper II theorem, a Version 2
   upgrade, or a separate short note.

## C616 amendment — uniform \(SL_2/A_5\) rank proof

**Completed 2026-07-25.** The coordinate-free radial-trace proof,
equivariant top-summand argument, minimal radial witness, exact certificate,
independent replay, and mystery ledger are in
`notes/2026-07-25-c616-h3-uniform-rank-upgrade.md`.

C616 should formulate the quotient map equivariantly as
\[
 k[G/H]\longrightarrow R_d
   =\operatorname{Sym}^d(\operatorname{Sym}^2V)
\]
and use the Fischer/plethysm decomposition
\[
 \operatorname{Sym}^d(\operatorname{Sym}^2V)
 \simeq\bigoplus_i Q^i\operatorname{Sym}^{2d-4i}V.
\]
For \(H_3\), the target decomposition is
\[
 R_4\simeq
 \operatorname{Sym}^8V\oplus Q\operatorname{Sym}^4V\oplus kQ^2.
\]
The desired proof has two separate obligations:

1. exclude \(Q\operatorname{Sym}^4V=Q\mathcal H_2\) by the relevant
   \(A_5\)-fixed-space or covariant argument, equivalently proving
   \(\Delta_Q\Phi(M)\in\mathbb F_{11}Q\) without coordinates; and
2. prove equivariant nonvanishing on
   \(\operatorname{Sym}^8V\) and \(kQ^2\).

Because the working characteristic divides \(|G|\), no semisimple
character argument may be imported without checking the modular
hypotheses. Restriction to \(A_5\), whose order is prime to \(11\), and
Frobenius reciprocity/fixed-point exactness are the likely safe interface.

## Ranked secondary questions

These are documented follow-ons, not separately allocated tasks.

1. **Intrinsic automorphisms and reconstruction.** Compute
   \(\operatorname{AffAut}(X)\) and
   \(\operatorname{ProjAut}(\widehat X)\); test whether the quotient
   configuration, with or without \(\mu_3\), reconstructs
   \(\operatorname{PGL}_2(q)\), \(\operatorname{PSL}_2(q)\), the endpoint
   conic, and the matching orbit.
2. **Geometry of the principal cubic.** Determine catalecticant ranks,
   singular locus, symmetric/Waring rank, border rank, factorization over
   extensions, and the full \(GL(W)\)-stabilizer of \(\mu_3\).
3. **Full matching span.** Prove or falsify that, for generic \(2m\)
   endpoints, all matching quotients span \(R_{m-2}\); characterize
   exceptional endpoint sets and the layers omitted by symmetric
   suborbits.
4. **Hecke explanation of the six profiles.** Interpret the four
   incidence differences in the \(K\)-\(H\) double-coset module and derive,
   if possible, the \(1,4,6\) rows, rank-two image, and separation of all
   six labels from spherical functions or a coherent configuration.
5. **Characteristic and integral lifts.** Compute the same ranks, moment
   radicals, Hadamard powers, and cubic moments in nearby characteristics
   and modulo \(p^2\); distinguish collision, orbit, Fischer, radical, and
   cubic-vanishing failures.
6. **Classification of radical--Hadamard recovery.** Classify or bound
   transitive two-sheet configurations satisfying the hypotheses of
   Paper II's abstract recovery lemma; determine whether \(B_3,H_3\) are
   exceptional or members of a broader family.
7. **Coxeter-number formula.** Prove a representation-theoretic source
   for the displayed \(h_T\)-formula or produce a nearby counterexample.
8. **Derived source-to-depth obstruction.** Decide whether the Tate/depth
   mismatch is an \(\operatorname{Ext}^1\), Bockstein, divided-transfer,
   or stable-module obstruction. Do not infer a nonlinear bridge merely
   because the obvious linear bridge fails.

## Strong connections exposed by the reads

The two readers independently ranked the following interfaces:

1. self-associated point sets, Gale duality, Cayley--Bacharach, and
   arithmetically Gorenstein schemes;
2. apolarity and Macaulay inverse systems;
3. Schur powers of evaluation codes, design trades, orthogonal arrays,
   and dual-word structure;
4. classical \(SL_2\) invariant theory, plethysm, transvectants, and
   harmonic/Fischer decomposition;
5. Grassmannian bracket algebra, Plücker straightening, and
   matching-diagram algebras;
6. double-coset/Hecke algebras, association schemes, coherent
   configurations, and spherical functions;
7. modular projective covers, Tate cohomology, and stable-module
   obstructions;
8. affine circuits, Gale transforms, finite moment problems, and tensor
   identifiability.

Tight cubature/spherical-design, cluster/associahedral,
Temperley--Lieb, McKay, and quantum interpretations are analogies only
until an exact map explains a theorem, degree, or obstruction. Numerical
sporadic-group coincidences are not a research direction without such a
map.

## Execution order

1. C620 is the near-free theorem and should run first.
2. C621 is falsifier-first and may run after or alongside C616 once the
   frozen homogeneous coordinates are fixed.
3. C616 remains the conceptual uniformity upgrade and must not depend on
   a positive Gorenstein outcome.
4. Promote a secondary question only when C620/C621/C616 exposes a precise
   theorem or obstruction that needs it.
