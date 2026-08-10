# C902 Paper III cheap-upgrade wording for survivors

Date: 2026-08-09

Status: recommendation-only copy for the later integration owner.  Do not
apply before the Paper III formal-closure and API-reconciliation lanes are
complete.  Candidates 1, 5, and 8 need no further wording; candidate 6 is
deferred; candidate 7's promotion is rejected.

## Survivor 1: triangle--Pfaffian recognition theorem

**Placement.**  Insert immediately after the proof of the current
operator-shadows theorem and before the unnumbered “Why determinant” paragraph.
If the preceding inventory paragraph still ends with a generic warning that
the four formulas could coincide accidentally, replace only that warning with
a forward pointer to this theorem.

**Recommended theorem wording.**  Adapt notation mechanically to the local
macros, but preserve every hypothesis and boundary.

```tex
\begin{theorem}[Triangle--Pfaffian recognition]
\label{thm:triangle-pfaffian-recognition}
Let $A=(a_{ij})$ be a real symmetric matrix of even order $n\geq 4$, with
zero diagonal and with every off-diagonal entry nonzero.  Write
\[
 T_A(x)=\sum_{|S|=3}\Bigl(\prod_{\{i,j\}\subset S}a_{ij}\Bigr)x_S,
 \qquad
 H_A(x)=\operatorname{Pf}[D_x,A].
\]
If $H_A=\mu T_A$ for some $\mu\neq 0$, then $n=6$ and
$A^2=\lambda I$ for some $\lambda>0$.

If, in addition, all off-diagonal entries of $A$ have the same absolute
value, then, up to scale, switching, and relabelling, $A$ is the symmetric
conference matrix obtained from a pentagon.  Conversely that switching class
has $H_A=\pm4T_A$; the two signs are its two relative orientation classes.
\end{theorem}

\begin{proof}
The two nonzero forms have degrees $n/2$ and $3$, so proportionality first
forces $n=6$.  Since
$[D_{x+t\mathbf 1},A]=[D_x,A]$, the cubic $T_A$ is invariant under
$x\mapsto x+t\mathbf 1$.  For $i\neq j$, the coefficient of $tx_ix_j$ in
$T_A(x+t\mathbf 1)$ is
\[
 a_{ij}\sum_{r\neq i,j}a_{ir}a_{rj}=a_{ij}(A^2)_{ij}.
\]
Thus $A^2$ is diagonal.  The identity $[A,A^2]=0$, together with
$a_{ij}\neq0$, shows that all of its diagonal entries are equal; positivity
gives $A^2=\lambda I$ with $\lambda>0$.

In the equal-absolute-value case, rescale to a sign matrix $B$.  Then
$B^2=5I$.  After switching the entries incident with one vertex to $+1$, the
remaining five vertices have degree two in one sign class, and hence form a
pentagon.  The converse and the factors $\pm4$ are the calculation above; the
dihedral stabilizer preserves the two relative orientation classes exactly as
claimed.
\end{proof}
```

**Mandatory following boundary sentence.**

```tex
The hypotheses exclude both the zero-proportionality locus and vanishing
off-diagonal entries; the argument does not classify the remaining weighted
solutions of $A^2=\lambda I$.
```

**Claim ledger.**  Add a new row, suggested identifier `OPER-1R`, classed as a
proved recognition theorem.  Its evidence should point to the coefficient
calculation above and to the existing pentagon computation.  Its boundary must
name the zero-proportionality, zero-support, and weighted loci.  Use no novelty
or priority adjective.

**Citation disposition.**  No new citation is load-bearing because the proof is
self-contained.  Retain the manuscript's existing historical conference-matrix
attribution; do not convert the bounded C902 search into an absence claim.
Internal proof authority is C809's “four-shadow characterization,” especially
the degree, translation, scalar-square, and sign-locus steps.

## Survivor 2: determinant-line norm paragraph

**Placement.**  Replace the opening of the existing unnumbered “Why
determinant” paragraph.  Keep the current permanent counterexample immediately
after this replacement.

**Recommended wording.**

```tex
There is also a basis-free reason for the determinant.  If $V_+$ and $V_-$
are the two spectral spaces and
$B_x=P_-D_xP_+\colon V_+\to V_-$, then $\det(B_x)$ lies naturally in
$\det(V_-)\otimes\det(V_+)^{-1}$.  Galois exchange swaps the two spectral
spaces, while the symmetric pairing identifies the conjugate line with its
dual.  The induced contraction has the odd-rank swap sign, so after compatible
orientations the ordinary field norm satisfies
relative to $V_+\oplus V_-$,
\[
 [D_x,C]=
 \begin{pmatrix}
 0&-2\sqrt5\,B_x^{\mathsf T}\\
 2\sqrt5\,B_x&0
 \end{pmatrix},
 \qquad
 \det[D_x,C]=-8000\,N_{\mathbf Q(\sqrt5)/\mathbf Q}(\det B_x).
\]
Together with $\det[D_x,C]=16Z_C(x)^2$, this gives
$Z_C(x)=\pm10\sqrt5\,\det(B_x)$ after compatible determinant-line
trivializations.  The sign is the relative orientation choice already tracked
above.
```

**Claim ledger.**  Amend the existing determinant/operator row rather than
adding a headline claim.  Record that the scalar equality depends on compatible
trivializations and does not construct an integral or global determinant line.

**Citation disposition.**  No external citation is needed for this block
determinant calculation.  Internal proof authority is C862's
spectral-descent/recognition packet; C764 remains the authority for the existing
determinant-line and permanent boundary.

## Survivor 3: marked spectral compatibility sentence

**Placement.**  In the orientation-source section, immediately after the
existing computation that the exchanger sends `C` and `Z_C` to their
negatives.  Merge with the next sentence if necessary to avoid repeating the
same marking warning.

**Recommended wording.**

```tex
Thus deck exchange leaves the unmarked quadratic spectral algebra unchanged,
$\mathbf Q[C]=\mathbf Q[-C]$, even though it reverses the chosen marked
generator and the relative orientation data.
```

**Claim ledger.**  Amend the existing orientation row.  Do not create a theorem
asserting `E \cong Q[C]`, and do not describe deck exchange as trivial.

**Citation disposition.**  This is a formal consequence of the exchanger
calculation already proved in the orientation-source section, so it needs no new
external citation.  C733 remains the marking-boundary authority.

## Proof, trust, owner, and surface map

| Survivor | Proof/trust evidence | Integration owner | Other surfaces |
|---|---|---|---|
| Recognition theorem | C809 human proof plus the C902 Packet A and algebra red team; add ledger row `OPER-1R` before promotion | C816, after C815/C823/C800 freeze the shared API | Canonical Paper III source, claim ledger, then normal standalone/mirror propagation; no abstract or portfolio change |
| Determinant-line norm | C862 norm calculation plus C902 Packet B; amend the existing operator row | C816 during the same reconciled integration | Same canonical-to-mirror route; no new theorem, abstract, or public-summary surface |
| Marked spectral compatibility | Existing exchanger proof plus C902 Packet C and C733 marking boundary; amend the existing orientation row | C816, with C800 reconciliation if the marked API changes | Same canonical-to-mirror route; no independent public-surface wording |

## Integration order and stop conditions

1. Reconcile the final symbol and marking API from the formal Paper III lanes.
2. Insert the recognition theorem and run the paper's normal source build.
3. Replace the determinant paragraph and insert the compatibility sentence.
4. Update the claim ledger, then propagate through the normal mirror/export
   route exactly once.
5. Recheck that there is still one first-pass source--shadow--return route, no
   second figure, no duplicated marking disclaimer, and no abstract expansion.

Stop rather than improvise if the owning lanes change the definitions of
`T_A`, `H_A`, `B_x`, the relative orientation class, or the canonical source
and mirror relationship.  The mathematical packets remain authoritative, but
the prose should then be rebased on the frozen API.
