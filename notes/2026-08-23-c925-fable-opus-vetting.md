# C925 vetting of the 2026-08-22 22:47 – 2026-08-23 08:59 commits

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Scope: the `c925-fable` branch commits from `05d963390` (22:47) to the merge
`b608ac2dc`, and the post-merge commits `a9c6b0f97`, `d9832ae7c`,
`9df1a132a`, `4fac6d682`.  Commit `7c1f24910` (Kummer trait rescaling,
Deligne–Rees audit) is Sol's and is out of scope.  Every claim below was
re-derived from the reports, the scripts, and one new exact computation.

## 1. Verdicts

| Claim | Commit | Verdict |
|---|---|---|
| Multiplicity bound: a root of multiplicity \(\mu\) on an edge of slope \(p/q\) bounds every cycle over it by \(\mu q\); dP5 unit box never reaches 5 | `05d963390` | **Correct.**  Ramification indices over one root cluster are multiples of \(q\) summing to \(\mu q\).  Script logic checked. |
| First-stage rotation orders of del Pezzo mirrors are 3-smooth | `386748ce1` | **Correct as stated and correctly scoped** (first stage only; the cell-torsion picture is quoted, not proved). |
| Kobayashi–Ochiai dimension bound; "closes every \(m\) at once" | `b581a7170`, `cdcaf41aa` | **Refuted by Opus itself** (`9df1a132a`).  Refutation independently confirmed here, §2. |
| Newton-slope Theorem A: branch valuation \(=(b\cdot\gamma)/(c_1\cdot\gamma)\), rotation order \(=\) its denominator | `caea2234e` | **Valuation formula correct; "rotation order" overclaimed.**  The denominator is the *first-stage* ramification only.  The card sentence "the statement covers all Newton–Puiseux stages at once" is false — contradicted by the dP5 witness in the same card.  What survives: cycle length \(\le\mu q\le\) edge length \(\le N\). |
| Theorem B: at Picard rank one every rotation order divides the index | `caea2234e` | **Correct** (exact single-variable homogeneity; no later stage). |
| Picard-rank-one threefold centres excluded by counting (\(4<6\)) | `caea2234e` | **Correct and trivial**; already in the pre-switch ledger §9 (\(b_2\ge2\)). |
| Theorem C (grading-multiplicity exclusion): cyclic blocks on a connected threefold share a grading pair drawn from the \(\mu\)-spectrum, so a difference-two triple is impossible | `a9c6b0f97`, `d9832ae7c` | **Void.**  The hypothesis is false in every reading, §3.  The Lean module is sound combinatorics under a hypothesis the geometry does not supply. |
| "The marker's exponent difference is not a grading difference" | `4fac6d682` | **Conclusion right, reasoning wrong.**  The marker never encoded a grading difference, §3.  The external gate is unchanged. |
| Card "Residual gate": centre of Picard rank \(\ge2\) with grading difference zero or one | `a9c6b0f97` | **Void** with Theorem C.  The true residual at \(m=2\) is unchanged from the pre-switch ledger §9: a connected threefold centre with \(b_2\ge2\) carrying a marked three-cycle under an integral cocharacter. |

## 2. The dP5 witness is real (exact second Puiseux stage)

For \(\mathrm{Bl}_4\mathbf P^2\), cocharacter \(b=(-1,-1,-1,-1,0)\), three
random rational base points (seeds 1, 2, 3): the first-stage polygon has
vertices \((0,55),(4,57),(7,60)\), so the four large branches have
\(\lambda\sim\alpha t^{-1/2}\) with \(\alpha^2=16/5\) (edge polynomial
\((5\lambda^2-16)^2\); the branch valuation is *minus* the slope).  Substituting
\(t=s^2\), \(\lambda=(\alpha+\mu)/s\) and reading the polygon in
\((\deg\mu,\ \operatorname{ord}_s)\): the \(\mu^0\) term first appears at
\(s^{191}\) with coefficient \(-384\sqrt5/5\), the \(\mu^2\) term at
\(s^{190}\) with coefficient \(144/5\), giving
\(\mu^2=(8\sqrt5/3)\,s\), i.e. \(\mu=\pm c\,t^{1/4}\), \(c\neq0\).  Both
\(\alpha=\pm4/\sqrt5\) give the same polygon.  Hence each branch over the
squared edge is \(\lambda=t^{-1/2}(\alpha\pm c\,t^{1/4}+\dots)\), ramification
index four: one 4-cycle, not two 2-cycles.  Rotation order four on a surface of
Fano index one.  Opus's refutation of "rotation order \(\le\dim+1\)" stands.

Script: scratch `dp5_second_stage.py` (reuses the class enumeration of
`notes/cubic-threefolds-tasks/c925-fable-dp-sheet-cycles.py`; sympy with
`extension=sqrt(5)`).  Not tracked; the computation is a three-line
substitution on the tracked characteristic polynomial and is reproducible from
the description above.

## 3. Why Theorem C has no content

Theorem C needs: (i) the residue of each formal block at \(z=0\) has, in a
block-adapted gauge, a diagonal that is a sub-multiset of the \(\mu\)-spectrum
\(\{(2k-n)/2\}\); (ii) the blocks partition that spectrum.  Neither holds.

* **Semisimple counterexample.**  For \(\mathbf P^1\), \(\mu=\operatorname{diag}(-1/2,1/2)\)
  and \(E\star\) has eigenvectors \(e_\pm=1\pm H/(2\sqrt q)\).  Then
  \(\mu e_+=-\tfrac12e_-\): \(\mu\) swaps the eigenvectors and its diagonal in
  the eigenbasis is \((0,0)\).  The two rank-one block residues are \(0,0\),
  not \(\{-1/2,1/2\}\).  This is the general fact that a semisimple quantum
  connection has trivial formal monodromy at \(z=0\).
* **Rank-two blocks are traceless.**  \(\mu\) is anti-self-adjoint for the
  Poincaré pairing, the pairing restricts nondegenerately to each block, and
  the pairing-compatible formal gauge makes the block residue anti-self-adjoint,
  hence traceless.  Every computed rank-two residue in the lane confirms it:
  cubic marked block \(\pm1/6\) (modified to \((-5/6,-1/6)\)),
  \(\mathbf P^2\times C_g\) and both strict orientations \(\pm1/2\), dual-number
  chart \((-1/2,1/2)\), distinct-root chart \((-11/18,11/18)\).  The last is
  not a half-integer at all, so "grading pair" is not even defined there.
* **What Opus read as the cubic's grading pair** is the diagonal
  \((-19/18,1/18)\) of the *modified* residue in one basis, decomposed as
  \((-3/2+4/9,\ 1/2-4/9)\).  The diagonal of a non-diagonal matrix in an
  adapted basis is not invariant (the centralizer \(a+bN\) of the nilpotent
  moves it), and the decomposition is numerology: the only invariants are the
  exponents \(\pm e\) modulo the elementary modification.

The invariant content of the marker is therefore: a rank-two nilpotent block
has raw exponents \(\pm e\); the C924 modification shifts one by an integer and
\(\delta^\sharp=(1-2e)^2\) in the selected orientation.  So
\(\delta^\sharp\in\{0,4\}\Leftrightarrow e=1/2\) (formal monodromy \(-1\) on the
block) and \(\delta^\sharp=4/9\Leftrightarrow e=1/6\) (formal monodromy of
order six, eigenvalues \(e^{\pm\pi i/3}\)).  Grading differences play no role;
there is no "difference two versus zero or one" dichotomy to exclude.  The
\(m=2\) residual gate is exactly what the pre-switch ledger §9 stated.

## 4. Escape hatches for the routes Opus declared dead

1. **Dimension bound via rotation order (dead as derived).**  Two live
   reformulations.
   * *Prime-restricted.*  The route only needs primes \(\ell=m+1\).  The dP5
     witness is a 4-cycle; no cycle of prime length \(\ge5\) has been found on
     any del Pezzo, first stages are 3-smooth structurally, and Opus's own
     multiplicity bound closes the dP5 unit box.  If later Puiseux stages are
     governed by sub-cells of the first-stage cell (a finer regular
     subdivision of the cell), every stage order is a cell-torsion order of a
     reflexive sub-polygon, hence in \(\{1,2,3,4,6,8,9\}\), and the surface case
     of the marked prime-cycle bound follows for every \(\ell\ge5\).  This is an
     open structural statement, not a dead one.  It does nothing at \(\ell=3\).
   * *Irrelevant at \(m=2\).*  Threefolds of Picard rank \(\ge2\) do carry
     3-cycles (\(\mathbf P^2\times\mathbf P^1\)), so no rotation-order bound
     could ever exclude the \(m=2\) triple; the exclusion there must use the
     marker.  Losing this route costs nothing at \(m=2\).
2. **Marker-to-grading (dead, and correctly so), replaced by
   marker-to-Serre-functor.**  With the invariant of §3, the marked block is
   the block whose formal monodromy has order six.  Under the non-semisimple
   Dubrovin/Gamma-II picture, the \(u=0\) regular block of the cubic is the
   Kuznetsov component \(\mathcal Ku(B)\): numerical \(K_0\) of rank two, Serre
   functor with \(S^3=[5]\), hence \(S=-\operatorname{id}\) cubed on \(K_0\)
   with eigenvalues \(e^{\pm\pi i/3}\) — exactly the block's formal monodromy.
   For an integer Euler form \(\chi\) on a rank-two lattice,
   \(S=-\chi^{-1}\chi^{T}\) has determinant one and integer trace, so
   \(e\in\{0,1/6,1/4,1/3,1/2\}\) and the marker \(4/9\) is the single value
   \(\operatorname{tr}S=1\).  The \(m=2\) gate then reads: no smooth projective
   threefold with \(b_2\ge2\) has three \(\otimes L\)-conjugate semiorthogonal
   components of numerical rank two and Serre trace one.  This is conjectural
   (it assumes the block/component correspondence for the non-semisimple part),
   but it turns the gate into a question about Kuznetsov components of
   Picard-rank-\(\ge2\) threefolds, where classification results exist, and it
   is a cheap finite test on every Mori–Mukai family with a known
   semiorthogonal decomposition.  Recorded as a candidate, not a result.
3. **Theorem C's intended role** (a calibration-free topological exclusion)
   has no topological replacement: the raw block residue is traceless for every
   block, so no multiplicity count on the \(\mu\)-spectrum constrains it.  Do
   not reopen with a different "grading" bookkeeping; the only block invariant
   is \(e\bmod\mathbf Z\).

## 5. Actions taken

* Card: the "Geometric route" section rewritten to the verified content; the
  grading-multiplicity paragraphs and the "Residual gate" replaced.
* Handoff: the findings paragraph replaced by a routing line.
* `2026-08-23-c925-fable-grading-multiplicity-exclusion.md` and
  `2026-08-23-c925-fable-quantum-newton-slope-theorem.md`: vetting banners
  added at the top; bodies retained for the record.
* Not done (Lean edit, needs the guarded window): `GradingMultiplicityExclusion`
  stays registered as a build root; its docstring "The exclusion used at
  `m = 2`" overclaims and should be relabelled or the module deregistered.
  `QuantumNewtonSlope`'s `rotationOrder_*` names mean first-stage ramification.
