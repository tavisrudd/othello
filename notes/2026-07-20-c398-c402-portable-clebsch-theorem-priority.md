# C398--C402 — EV-ranked portable Clebsch theorem programme

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** C398--C400 complete; C399 survives its full audit as the selected portable synthesis;
C403 is active on its strongest exact line-defect/enumerator seam

## Decision

The Clebsch grand-spine paper needs at most one genuinely portable flagship theorem to raise its
ceiling.  These five candidates are ordered by estimated expected value after review of the proved
spine, current worktree, and recent theorem notes.  The scores are prioritization estimates, not
mathematical claims.

| Priority | Task | Target | EV | Estimated success |
|---:|---|---|---:|---:|
| 1 | C398 | non-GRS parent with conic deep-hole locus and GRS child | 82 | 63% |
| 2 | C399 | rank-three reflection-orbit arithmetic code phases | 76 | 58% |
| 3 | C400 | scalar-`A5` Fourier-self-dual scheme phases | 73 | 47% |
| 4 | C401 | cubic-contained uncovered loci of six-arcs | 66 | 43% |
| 5 | C402 | all-good-reduction `H3` AME separation from GRS | 60 | 20% |

Run the tasks serially in this order unless a task's own stop rule closes it early.  A bounded
negative does not authorize broadening the census; it hands control to the next task.  Every
paper-facing mathematical conclusion is a Lean target under the Clebsch trust policy, with exact
external certificates retained for discovery and independent replay.

## C398 — classify non-GRS-to-GRS conic deep-hole transforms

### Result

C398 closes with verdict `ALL-FIELD EXACT CLASSIFICATION; FOUR SEMILINEAR CLASSES; UNIQUE
FULL-CONIC CLASS IS CLASSICAL`.  The incidence inequality `q^2<=15(q+1)` forces `q<=15`, and the
complete `PGammaL_3(q)` quotient leaves one q=8 class with locus size four, two q=9 classes with
locus sizes six and seven, and the unique q=11 full-conic class.  The q=11 exterior six-arc is
already recorded by Korchmaros and Blokhuis--Seress--Wilbrink, so the result survives as a sharp
portable synthesis but does not trigger the flagship paper-promotion rule.  See
`notes/2026-07-20-c398-conic-deep-hole-classification.md` and its Python/JSON/checksum/Lean bundle.

### Target theorem

Classify, up to `PGammaL_3(q)`, every non-GRS six-arc `A` in `PG(2,q)` for which the nonempty
complete weight-three syndrome locus is contained in a nonsingular conic.  Determine exactly when
that locus is the full conic and adjoining it produces a GRS projective child.  State the result
equivalently for codimension-three MDS codes and one-column MDS extensions.

C341 supplies the all-odd-prime non-GRS parent boundary, and C368 supplies the exact q=11
non-GRS-parent/full-conic-deep-hole/GRS-child example.  Kaipa's redundancy-three result is a
mandatory boundary for GRS parents; novelty must lie in the non-GRS classification and geometric
deep-hole locus.  C395's source-conic determinant does not classify the deepest-syndrome locus and
does not bypass the incidence bound or semilinear pilot below.

### First pilot and stop

1. Prove a rigorous field-size reduction from secant/conic incidence before treating any finite
   enumeration as exhaustive.
2. Canonically enumerate the bounded pilot fields `q=4,5,7,8,9,11,13`, including prime powers,
   and quotient by the full semilinear projective equivalence.
3. For every survivor, certify the arc, non-GRS status, complete deepest-syndrome locus, conic, and
   child equivalence independently.

Stop if many unrelated exceptional orbits survive, if the size reduction does not make the
classification finite and small, or if primary/forward literature pre-empts non-GRS inputs.  The
sharp bounded census and obstruction are then the deliverable.  Do not continue to longer arcs or
higher codimension.

## C399 — rank-three reflection-orbit arithmetic phase classification

### Result

C399 closes with verdict `THEOREM; LITERATURE-REFRAMED UNIFORM COXETER-NUMBER COMPLEMENT-CODE
PHASE`.  For `A3/B3/H3`, with Coxeter number `h=4,6,10`, the projective
reflection-arrangement complement code has uniform parameters

```text
[(q-h/2)(q-h+1), 3, (q-h/2-1)(q-h+1)]_q.
```

At exactly `q=h+1=5,7,11` it is the full invariant conic and hence the
`[q+1,3,q-1]` extended GRS code; above `q>3h/2-1` it intrinsically recovers the arrangement.
B3 is the canonical short-root defect: its long-root frame has the A3 complete deep-hole locus,
and its short-root triangle deletes `3(q-3)` points.  Every irreducible rank-four candidate fails
the first quadric point-count gate.  The exact certificate and dedicated/umbrella Lean gates are
green.

The completed literature audit materially narrows ownership.  Edge and Dye already own the
individual q=5,7,11 conic configurations, the `5,14,22` geometric-marker fibres and much of their
relation geometry; Edge also contains the projective `3+6` split underlying the B3 deletion.
Complement length and conic--GRS are classical, and Raja pre-empts generic complement-code
language.  No exact predecessor was located for the uniform nonmirror maximum `q-h+1`, hence the
distance formula and common Coxeter-number phase.  C399 is therefore the paper-heading portable
synthesis, not a new exceptional-configuration claim.  See
`notes/2026-07-20-c399-coxeter-number-conic-phase.md` and
`notes/2026-07-20-c399-literature-audit.md`.

### Target theorem

For the distinguished integral projective orbit systems attached functorially to
`A3`, `B3`, and `H3`, classify every good finite-field reduction by:

- arc/MDS status and exceptional determinant ideals;
- conic/GRS status of the source;
- complement/deep-hole locus and any GRS child; and
- intrinsic recovery from the complement when it is nonempty.

C346 and C368 already provide the complete good-reduction and arithmetic-phase theorems for the
`H3` member.  The portable result must explain a common reflection-orbit mechanism across types,
not concatenate three determinant tables.  C395 supplies a reusable finite proof pattern: solve
all candidate projectivities over `Q` and factor their cleared residual gcds to obtain the complete
modular stabilizer-jump set.  Its generic `A4`, characteristic-17 `S4`, characteristic-31 `A5`
pencil phase is evidence for the target shape, not the missing `A3/B3/H3` orbit functor.

### First pilot and stop

Fix the orbit construction before computation, then derive and factor the integral maximal-minor,
conic, and complement ideals for `A3`, `B3`, and `H3`.  Test representative split, inert, ramified,
and bad primes with an independent finite-field replay.  Stop if no canonical orbit functor covers
all three types, or if the only common statement is the tautology that finitely many determinant
ideals control reduction.  Modular Coxeter groups, arrangement reduction, and reflection groups
over finite fields require a focused pre-emption audit.

## C400 — scalar-`A5` Fourier-self-dual arithmetic schemes

### Result

C400 closes with verdict `THEOREM; UNIFORM BURNSIDE RANK/ORBIT LAW AND SIX CONIC-RELATION
PHASES; FLAGSHIP PRE-EMPTED`.  Every odd-good scalar-`A5` scheme is primitive and Fourier
self-dual, with exact rank

```text
(q^2+16q+135+40e3+48e5)/60.
```

Its projective stabilizer types are exactly `D5,S3,V4,C2,C3,C5,1`; the invariant conic is one
relation exactly at `q=5,9,11,19,29,59`, successively of type `D5,S3,C5,C3,C2,1` and with
source/triple/deep/deep/mirror/deep roles.  The rank-four orthogonal fusion is uniform, and the
complete q=5/9/11 fusion lattices have ranks `2,4`; `2,4,6`; and `2,4,6,8`.  Larger complete
fusion enumeration stops at the Bell-number gate.  Cameron--Omidi--Tayfeh-Rezaie's classical
projective-line orbit theorem pre-empts the conceptual conic ladder, so the surviving result is an
exact scheme/code/deep-hole synthesis rather than a portable flagship.  See
`notes/2026-07-20-c400-a5-fourier-phases.md` and its Python/JSON/checksum/Lean bundle.

C400 supplies an optional all-field context paragraph around the q=11 rank-eight jewel: its
six conic-relation phases, q=59 regular endpoint, `q*z-ell` character formula, and rank-four
orthogonal fusion are reusable without reopening the theorem.  They do not replace the paper's
two code-changing conic phases, consume a second promotion slot, or enter the main theorem spine
without an explicit manuscript-owner scope decision.  All-field fusion classification and
separability remain behind their structural gates.

### Target theorem

For every odd good reduction of the integral three-dimensional `A5` representation, construct the
scalar-`A5` translation scheme and classify its:

- primal and dual orbit partitions under the invariant form;
- rank, valencies, and orbit types by arithmetic residue phase;
- primitivity and separability where accessible;
- orthogonal and other coherent fusions; and
- distinguished source-code and deep-hole relations.

C341 supplies the integral code family and q=11 decoder scheme; C372 proves exact q=11 Fourier
self-duality and its fusion lattice.  Uniform self-duality from a preserved form is not enough for
novelty.  The theorem must deliver nontrivial rank/fusion/exceptional-relation classification.

### First pilot and stop

Derive Burnside/orbit formulas and compute exact comparison fields `q=5,9,11,19,29`, including the
ramified and inert behavior relevant to the integral representation.  Stop if rank and fusions vary
without a finite arithmetic law, or if the only survivor is a standard orbital-translation-scheme
self-duality plus fieldwise tables.  Audit Schurian translation schemes, cyclotomic/orthogonal
schemes, formal duality, and modular `A5` orbit schemes before priority wording.

## C401 — cubic-contained uncovered loci of six-arcs

### Target theorem

Classify six-arcs `A subset PG(2,q)` whose nonempty uncovered locus `U(A)` is contained in an
`F_q`-curve of degree at most three, with the curve allowed to be reducible or nonreduced.  Recover
the q=11 Clebsch low-degree characterization as the exceptional flagship case and state every
additional family or small-field exception explicitly.

The theorem must be all-field or have a proved finite field bound.  It must not promote a search
range into a classification and must distinguish conics, irreducible cubics, line-plus-conic,
three-line, and nonreduced types.

### First pilot and stop

First combine chord-defect/evaluation identities with curve point bounds to derive a rigorous field
bound.  Then enumerate normalized six-arcs only in the residual fields and classify the containing
cubic by decomposition type.  Stop if reducible cubics produce a large taxonomy, if no small field
bound follows, or if finite-geometry/blocking-set literature already owns the classification.  C398
owns the nonsingular-conic subcase and must be consumed rather than duplicated.

## C402 — uniform `H3` AME separation from GRS

### Target theorem

For every odd good non-GRS reduction of the integral `H3/A5` six-arc, prove or refute that its
minimal-support stabilizer `AME(6,q)` state is LU-inequivalent, allowing party permutation, to every
six-point GRS-derived AME state.  A positive result requires one uniform finite or symbolic
invariant and an explicit account of all arithmetic exceptions.

C374 proves the q=11 separation.  C384--C396 show why a single marginal-moment statistic is not a
reliable family classifier, and C397 separates the easier Clifford/logical question from arbitrary
LU equivalence.  C395 adds an extension-stable characteristic-31 non-GRS `A5` control tower and a
characteristic-17 GRS `S4` tower in the same pencil presentation.  They are not cross-dimension
comparison objects: each must be tested only against GRS/non-GRS controls over the same field.  In
`F_31`, `chi(-1)=-1`, so the pencil has no GRS parameter and the same-field controls must come from
external GRS classes.  These are first falsifiers, not a uniform LU separator or yet an identified
copy of C402's fixed integral `H3` presentation.
Infinite AME/LU families and the MDS--AME dictionary are prior art.

C400 supplies an exact orbit-sensitive spectral substrate, but not yet an LU invariant.  Its
rank-four orthogonal fusion is too coarse, and decoder-weight classes are not coherent.  The first
C402 gate is therefore categorical: construct a basis-independent spectral or holonomy operator of
the AME tensor whose party-permutation LU covariance is proved and whose spectrum retains every
individual scalar-`A5` relation/eigenrow in the `C3`, `C5`, and regular-orbit sectors.  Stabilizer
type alone is not the fine datum: q=19 already has two distinct regular relations.  A Pauli-,
decoder-, or chosen-syndrome-basis statistic does not pass.

### First pilot and stop

First prove LU covariance of the fine-orbit spectral/holonomy construction above.  Then run the
first same-field `H3` versus full-GRS-moduli falsifier at `q=19`, retaining both distinct regular
relations separately alongside the `C3` relation, and use the rank-four orthogonal quotient as a
deliberate negative control.  Continue to one next
arithmetic phase only after separation survives.  Stop if LU covariance forces collapse to the
rank-four fusion, if the statistic depends on Pauli/decoder labels, on the first invariant
collision, any required continuous-unitary search, or an unbounded GRS-moduli census.  The resulting
sharp failure is a valid bounded negative and closes the task; it does not justify inventing
successively larger invariants.

## Paper-promotion rule

C399 fills the single promotion slot, subject to manuscript-owner integration and the exact
classical/new wording fixed by its audit.  Later tasks may still close their bounded pilots, but the
manuscript should not accumulate unrelated generalizations.  C403's conic-divisor quotient may
appear as a compact corollary to C399: it makes all-degree parent forgetting precise without taking
a second promotion slot, and must preserve the external-factor caveat.  Its broader weighted-
adjoint theorem remains a companion rather than replacing the leaner typewise proof interface;
C404 is literature-pre-empted, and C405 and later positives remain companions unless they are
mathematically inseparable from C399.
The preferred paper spine remains the exact q=11 reversible hexagon, with C399 explaining its place
in the rank-three Coxeter-number family.
