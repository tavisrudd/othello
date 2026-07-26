# C665 — Balanced matching completeness and C661 consequences

**Lane**: `clebsch`

**Status**: queued after the C661 formal synchronization; Paper II nonlinear
completeness upgrade; must not hold the current release.

## Objective

Exploit C661's affine-cocycle/Fischer-module proof in strict expected-value
order.  The crown is a completeness theorem for balanced projective matching
orbits.  Lower-ranked routes package consequences that are now conceptually
free.  Do not replace the crown by an unbounded matching-orbit census.

## EV-ordered routes

### 1. Classify balanced full projective matching orbits

Work over odd prime powers \(q\).  Let \(\Omega\) be a
\(\operatorname{PGL}_2(q)\)-orbit of perfect matchings of
\(\mathbb P^1(\mathbb F_q)\), of size \(2q\), which splits into two
\(q\)-point \(\operatorname{PSL}_2(q)\)-orbits.  Prove the stabilizer
reduction
\[
 [\operatorname{PSL}_2(q):H]=q,\qquad |H|=(q^2-1)/2,
\]
then use the subgroup classification of \(\operatorname{PSL}_2(q)\) to
determine every possible \(q\) and stabilizer type.

For each surviving case, determine the matching realization.  In particular,
resolve the complementary ten-matching orbit for \(q=5\), its \(5+5\) sheet
split, and its affine evaluation algebra.  The first kill test is dimensional:
decide whether its Schur square has a sheet-sign annihilator or already fills
the full function space.

Acceptance is a theorem, at an explicit prime-power and characteristic scope,
that classifies the balanced full-projective matching orbits and determines
which ones have quadratic sheet recovery.  The target conclusion is that the
\(B_3/\mathbb F_7\) and \(H_3/\mathbb F_{11}\) configurations are the only
recovering cases; a counterexample is equally valuable if completely proved.

### 2. Package the cocycle-span criterion

State and prove a reusable lemma: for an affine connecting cocycle with
translation space decomposed into irreducible Fischer summands, every nonzero
projected cocycle value fills its summand, while invariant Laplacian/apolar
traces detect radial summands.  Specialize it cleanly to the \(3,6,10\)
theorem.  This route passes only if it removes repeated case reasoning or
creates a genuinely reusable interface; a tautological restatement of
irreducibility does not pass.

### 3. Isolate cubic inevitability

Promote the C661 implication
\[
\text{quadratic recovery}
\Longrightarrow \text{signed Gale self-duality and CB(2)}
\Longrightarrow \text{Gorenstein Hilbert symmetry}
\Longrightarrow L^{\circ3}=k^\Omega,\ \mu_3\ne0
\]
to an abstract theorem at the correct characteristic scope.  Remove any
remaining paper-facing suggestion that nonzero cubic enumeration is logically
independent.

### 4. Test a uniform radial-trace lemma

Express the deepest radial projection of a matching quotient through the
appropriate iterated Laplacian or apolar trace.  Determine whether the
\(B_3\) common-secant square and the \(H_3\) second-trace witness are instances
of one geometric nonvanishing statement.  Stop if the result merely renames
the two existing scalar calculations.

## Method and gates

- Verify the subgroup-classification hypotheses and exceptional cases against
  primary sources before stating completeness.
- Use group theory and orbit--stabilizer before any finite matching check.
  Restrict computation to the surviving cases and state the exact domain and
  stop condition.
- Any paper-facing finite check must receive the repository's reproducibility
  bundle, compact certificate, independent replay, and trust-map disposition.
- Keep the C661 human proof and its ongoing Lean formalization authoritative;
  offer reusable abstract lemmas to the formalization only after their human
  statements stabilize.
- Integrate into Paper II only theorem-level gains that survive a fresh cold
  read.  Do not hold the current release.

## Stop conditions and non-goals

- Stop the classification route if the index-\(q\) reduction is false; record
  the corrected orbit condition before doing any search.
- Do not enumerate general matching orbits over increasing \(q\).
- Do not import unfinished Paper III arithmetic or harmonic claims.
- Do not count more examples, shorter certificates, or a repackaged trace as
  the completeness theorem.

The final report must give each route a pass/fail disposition in the order
above, run the required `ej`+`tt` closeout, and maintain a mystery ledger.

