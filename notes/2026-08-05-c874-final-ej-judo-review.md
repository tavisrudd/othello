# C874 — final priority-judo and extra-juice review of the 2026-08-05 ladder day

**Date:** 2026-08-05
**Task:** C874
**Lane:** `clebsch`
**Status:** complete; offline review plus two exact certificates, no manuscript or Lean file changed

Inputs: the day's chain C682/C865/C867/C868/C870/C872, the four audits
C866/C869/C871/C873, the surviving 2026-08-04 Paper IV bundles, and the
2026-08-05 discovery-track entry.  No literature was searched; the three audit
rounds' verdicts are treated as inputs.

## 1. Priority judo: plainly no, and here is the mechanism that closes it

The sharpened pattern asks for a broader statement of which the occupying
result is a specialisation.  Applied to every predecessor conceded today:

- **Brouwer & Shult (1990).**  Their theorem is a biconditional over
  *arbitrary finite graphs* with a coclique-parity hypothesis and no type,
  rank, field, or form.  There is no broader statement to stand on: our fold
  is a specialisation of their construction, their converse is stronger than
  any converse we could state, and C873 already closed the converse fallback.
  Judo structurally unavailable — one cannot out-generalise a general-graph
  biconditional from inside one of its applications.
- **Calderbank & Kantor (1986).**  The C870 tower judo was the right shape and
  was reversed by C871 because the tower slot is occupied (Brouwer–Van
  Maldeghem Proposition 3.6.1).  The remaining candidate was the secondary
  form — their theorem as engine, a code-level statement as the new layer.
  Section 2 below settles that candidate negatively: the code-level fold is a
  four-line formal property of Taylor doubles, so the composition produces a
  lemma, not a theorem.  Nothing to relocate against.
- **Brouwer & Van Maldeghem (naming of 120/56/28/27).**  Catalogue vocabulary,
  not a theorem to specialise.  No judo target exists.
- **Conder & Potočnik census (`X.182.1`), Goldschmidt amalgams.**  The graph is
  a catalogue entry; our surviving content there is the *identification* with
  Paper IV's two orbits plus the support-XOR identities, which C869/C871 left
  unpre-empted.  Identification is already the correct posture; no broader
  statement is available or needed.
- **Crnković, Rukavina & Šimac (2020, 2022).**  Correct papers, no error, our
  graph absent from both tables.  The two one-frame kernels stay individually
  unpre-empted; positioning ("cite, state the difference") is already right.

**Verdict: plainly no.**  The one move that looked live — the graph-engine
composition suggested by the discovery track — is executed below and comes out
as a mirage for novelty purposes.  The lane's unpre-empted mathematics remains
the Paper IV q13 material (parity-complement lift, cross-orbital exhaustion,
higher shell, support-XOR identities, colour-lift theorem, obstruction
certificates), none of which needed judo in the first place.

## 2. The code-level fold is a formal property of Taylor doubles (new lemma, certified)

This settles, in one stroke, the question C871 flagged as "settle before any
further manuscript work" (is the weight-enumerator descent a corollary of the
graph decomposition or an extra fact?) and the discovery-track lead (would a
non-quadratic family satisfying the coclique condition give a genuinely new
tower?).

**Lemma.**  Let \(\Gamma\) be *any* graph on \(m\) vertices, and let
\(\hat T\) be its Taylor double with the antipodal matching added (the form
the quadric link actually takes: the Gosset graph carries 28 extra antipodal
edges at rank 8).  Give any graph \(X\) the graph code
\(C(X)=\langle\mathbf 1,\ \text{rows of }A_X\rangle\) over \(\mathbf F_2\).
Then every adjacency row of \(\hat T\) has fibre-difference exactly
\(\mathbf 1\); hence the fibre-constant subcode of \(C(\hat T)\) is the
constants plus the even sums of rows, of codimension one; and folding each
fibre sends it onto \(\langle\mathbf 1\rangle+A_\Gamma\cdot(\text{even
coefficient vectors})\), which is \(C(\Gamma)\) or its index-two subcode.

*Proof.*  For \(x\neq y\), exactly one of \((x,0),(x,1)\) is adjacent to
\((y,j)\) — by the cover rule whether or not \(x\sim y\) — and the matching
handles \(x=y\); so each row's two fibre-values differ at every fibre.  A
combination \(c\mathbf 1+\sum\lambda_r\,\mathrm{row}_r\) is therefore
fibre-constant iff \(\sum\lambda_r\) is even, and folding
\(\mathrm{row}_{(y,0)}+\mathrm{row}_{(z,0)}\) gives
\(A\text{-row}_y+A\text{-row}_z\) directly. ∎

No quadratic form appears.  The certificate verifies the identity for the
quadric links at ranks six and eight (where the graph code of the induced
link equals the restricted affine code and the fold reproduces
\([28,7,12]\) and \([6,5,2]\) on the nose), for the pentagon (icosahedral
two-graph), for the Paley conference two-graphs on 10, 14 and 26 points —
families *not* of \(\mathbf F_2\) quadratic-form type — and for arbitrary
seeded pseudo-random graphs.  Full descent (fold = whole graph code rather
than the index-two subcode) held in every structured case and failed in every
random case; which of the two occurs is a one-line rank comparison between
the row span and its even-sum subspace, not a structural phenomenon.

Consequences, stated plainly:

1. **The C871 residue is empty.**  The code-level fold is a corollary of the
   double-cover structure alone.  The only quadric-specific inputs are (i)
   that the distance-two subgraph *is* a matched Taylor double — which is
   Brouwer–Shult's theorem — and (ii) the parity fact that descent is full
   there.  Neither supports a manuscript.
2. **The discovery-track lead is a mirage as a novelty vehicle.**  "Any family
   satisfying the coclique condition folds" is true — and trivially so at the
   code level, since *every* graph's Taylor double folds.  The folded codes of
   non-quadratic families are ordinary graph codes of the base (for the Paley
   cases, graph codes of Paley graphs — catalogued territory).  There is no
   tower outside the two-weight setting waiting here, because the fold never
   used the tower's geometry.  The discovery-track entry should be closed with
   this certificate as the falsifier outcome: the condition is satisfied by
   everything, so it selects nothing.
3. Retro-explanation: C872's corrected type-generality, and the withdrawn
   plus-type dichotomy, are both immediate from the lemma — a dichotomy was
   never possible.  The lemma is the "derive the mechanism before the sweep"
   habit C872's vibe check asked for, applied one day late.

## 3. The C868 equivariant-uniqueness claim: inference invalid, conclusion true, now certified

C868 claimed no other equivariant code of the right size exists on the 120
nonsingular points, inferring it from four adjacency ranks plus "a rank-three
permutation module has a very short submodule lattice."  That inference is not
valid — over \(\mathbf F_2\) the submodule lattice of a permutation module is
not controlled by the commutant dimension — and the coordinator was right to
suspect it.  The replacement is an actual bounded submodule-lattice
computation, complete rather than heuristic:

Every nonzero invariant subspace in characteristic two has nonzero fixed
points under any 2-subgroup.  Taking the Sylow 2-subgroup \(P\) of order
\(2^{12}\) (constructed explicitly; 4 orbits on the 120 points, sizes
8/16/32/64), every minimal invariant subspace is the \(G\)-span of a vector
of the 4-dimensional fixed space \(M^P\), and iterating on quotients
enumerates **every** \(GO_8^+(2)\)-invariant subspace of dimension at most 12
— over \(\mathbf F_2\) and over \(\mathbf F_4\) (where invariant codes need
not be scalar extensions, so the field was treated directly).

**Result: the complete list, both fields, is 0, the constants (dim 1), the
linear functionals (dim 8), and the affine code (dim 9).**  Nothing else up
to dimension 12.  So:

- C868's uniqueness conclusion is correct and is now theorem-grade rather
  than rank-inferred; the \(\mathbf F_4\) case, which the rank argument never
  addressed at all, is covered.
- C867's attack one (no invariant tenth dimension above the code) is
  independently re-proved and strengthened: no invariant subspace of any
  dimension 10–12 exists, containing the code or not.
- Still open, unchanged: codes invariant under a *proper* subgroup only, and
  non-additive (non-linear-carrier) constructions.

## 4. Adversarial scan of the other surviving computations

Checked for the "computation whose answer I wanted, checked only where the
fault was invisible" shape:

- **Cross-orbital optimality (PO-1).**  The Hamming exclusion for kernels of
  dimension ≥ 40 is the thinnest margin in the day's certificates:
  \(V(91,13)=2287415069586304\) against the dim-40 threshold
  \(2^{51}=2251799813685248\) — a 1.6% overshoot.  The tracked JSON did
  compute exact per-dimension bounds (dim 40 → distance ≤ 26, through dim 90
  → ≤ 2), so the claim is sound, but any future variant at slightly different
  parameters should not assume the volume bound will keep rescuing it.
- **C872's closed-form tetrad count.**  Re-derived independently
  (\(T=(2^n-1)\lambda(\lambda-1)/6\) via the perfect-difference-set property
  and the three-ways pairing of sum-zero tetrads; distinct pairs with equal
  sums are automatically disjoint); numerics re-checked at
  \((n,N)=(8,120)\): \(\lambda=28\), \(T=32130\).  Sound.
- **Parity-complement lemma.**  Re-derived (odd column degrees force even
  parity on kernel words; odd \(n\) and odd row degrees put \(\mathbf 1\) in
  \(\ker(C+J)\)).  Sound.
- **Higher-shell distance certificate.**  The 25-disjoint-information-set
  pigeonhole was checked for the outside-the-union loophole: the restriction
  weights sum to at most the total weight regardless of the 167 uncovered
  coordinates, so the bound \(\lfloor 204/25\rfloor=8\) stands.  Sound.
- **C682's non-transitivity of the public \([[28,14,5]]\).**  Rests on a
  monomial-invariant incidence distribution; sound as stated.

No new retraction.  The day's two retractions (C871's census correction,
C872's indexing fault) appear to have been the full crop.

## 5. Extra juice

Done rather than proposed:

- The graph-code formulation \(C(X)=\langle\mathbf 1,\text{rows}\rangle\)
  makes the entire ladder graph-intrinsic (certified at ranks 6 and 8: the
  induced link's graph code *is* the restricted affine code).  Any future
  write-up of the surviving material can drop the ambient \(\mathbf F_2^{2l}\)
  entirely.
- The two certificates above; the C868 upgrade is the day's one genuine
  strengthening (a suspect claim became a complete enumeration).

Cheap and worth queueing, not done here:

- **Score the minus and parabolic levels against the public tables.**  C872
  produced \([36,7,16]\), \([136,9,64]\), \([16,6,6]\), \([64,8,28]\),
  \([10,5,4]\) without table comparison.  If, as at plus type, they all sit at
  the unrestricted optimum, the "optimal at every small level" phenomenon is a
  property of the whole quadric family, not of the exceptional series — worth
  knowing before anyone romanticises the E-labels again.  Parameter lookups on
  codetables are coordinator-owned, hence queued rather than run.
- **Close the discovery-track entry** of 2026-08-05 with a pointer to the
  descent certificate (one edit, owned by whoever next touches the log).
- The only live mathematical target left on the ladder side remains the
  four-unit gap at \([256,10]\) — the one carrier with no proved obstruction.
  Nothing found today changes its priority, but nothing strengthens it either.

Surprising / unexplained, for the ledger:

- **Full descent tracks structure.**  Descent is full (not index two) for
  every vertex-transitive-ish case tested and index two for every random
  graph.  The criterion is elementary (is some odd sum of rows in the
  even-sum-plus-constants span?), but *why* the structured examples always
  land on the full side was not examined.  Low value, recorded only.
- **The 1.6% Hamming margin** at PO-1's dim-40 gate, noted above: correct,
  but suspiciously close for a bound doing that much work.
- No other genuine mystery remains from today's chain: the distance-four CSS
  ceiling has its one-line cause (C868), the E9 optimality loss has its
  Plotkin cause (C867), and the fold now has its double-cover cause (here).

## 6. Evidence and replay

From `/home/tavis/src/othello`:

```sh
python3 notes/2026-08-05-c874-e8-carrier-submodule-lattice.py --check
python3 notes/2026-08-05-c874-taylor-code-descent.py --check
sha256sum -c notes/2026-08-05-c874-e8-carrier-submodule-lattice.sha256
sha256sum -c notes/2026-08-05-c874-taylor-code-descent.sha256
```

Both checkers are standard-library Python, deterministic (the random graphs
use a fixed-seed LCG).  The lattice checker calibrates its fixed-space solver
against the orbit-indicator span, verifies the Sylow subgroup order and the
affine code's weight enumerator, and enumerates the complete bounded lattice
by minimal-submodule iteration; the descent checker asserts the lemma's three
clauses case by case and the exact \([28,7,12]\) enumerator at the rank-8
fold.  SHA-256 hashes of scripts and certificates are in the two manifests.

The V(91,13) margin check in section 4 is a two-line exact-integer
computation reproduced inline there; it needs no separate certificate.
