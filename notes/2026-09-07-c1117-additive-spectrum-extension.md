# C1117: additive and exact-spectrum extensions

**Lane:** `cubic-threefolds`
**Date:** 2026-09-07

## Mathematical outcome

The primary m1 paper now has a separate Section 4, after the original
obstruction and applications. It proves the additive Grothendieck-group
extension, its exact-discriminant refinement and the requested applications.
The former paragraph denying a Grothendieck extension because subtraction
and multiplicativity had not been constructed has been removed.

No priority claim is made. These deductions follow from the audited
comparison formulas, with Bittner's abelian-group presentation as the
external input. They do not imply a universal obstruction after two or more
stabilizations. The historical C907 dossier contains such an older target;
it is not the objective or a premise of this task.

## Exact discriminants and the fixed target

For a counted block the finite jet determining the canonical modified
residue lies in a finite algebraic extension of the reduced generic field.
Bulk flatness annihilates its discriminant. The divisor directions on the
reduced source are the logarithmic numerical-curve derivations; the other
even bulk derivatives also annihilate it.

The proof that their common constant field is C is explicit. For a
constant fraction f/g, simultaneous formal rescaling gives
f(exp(t)x)g(x)=f(x)g(exp(t)x). At bounded ample-plus-bulk degree there are
finitely many monomials. Their exponential characters are independent,
so coefficient comparison gives f_a g_b=g_a f_b for every pair of indices.
One nonzero g_b shows that f/g is a complex scalar. An algebraic constant
has a monic minimal polynomial whose derivatives have smaller degree;
minimality makes all its coefficients constants. Algebraic closedness of
C finishes the argument.

Thus the fixed index set is the complex numbers excluding integer squares.
The spectrum is the finite multiset of those exact discriminants, valued
in the corresponding free commutative monoid, and its group completion is
the common additive target. Scalar augmentation recovers the count.

Preservation is proved using the original and canonically modified
lattices. A regular gauge transports the centered leading operator and
its kernel/image line, hence the modified lattice. Its reduction conjugates
the residue. A common scalar residue shift preserves the squared gap.
This is stronger than preserving exponent classes modulo integers; separate
integer changes of representatives are not used to transport the spectrum.

## Extension and applications

- Each center occurrence is intrinsic in every dimension by C1116. Its
  exact spectrum is preserved as above. Independent unit parameters
  separate summands. This gives the intrinsic blowup formula and the
  rank-r projective-bundle formula for the spectrum and scalar count.
- Empty varieties receive zero and disjoint unions are treated additively.
  The exceptional divisor formula gives Bittner's blowup relation in the
  group completion. Bittner Theorem 3.1 supplies the unique additive
  extension on K0(Var_C). Its presentation (bl) and the projective-generator
  variant were checked directly in arXiv:math/0111062v1, pp. 3--4.
- The P1 formula proves annihilation of (L-1)[Y] for every smooth projective
  Y. Such classes generate the group, so annihilation holds on (L-1)a
  for every a. The scalar invariant is zero on 1 and L, and one on a
  cubic. It cannot be multiplicative.
- A smooth bidegree-(2,6) curve on a quadric has genus five. The Hodge
  blowup formula gives equal Hodge diamonds for Bl_p(X) and Bl_C(P3):
  diagonal middle entries two and off-diagonal middle entries five.
  The marker values are one and zero. The cubic Hodge-number calculation
  is justified by its Chern class, weak Lefschetz and its anticanonical
  bundle. No new quantum calculation is needed.
- Every rationalizing weak factorization from X x P^m to P^(m+3) has
  weighted blowdown spectrum minus weighted blowup spectrum equal to
  (m+1)e_(4/9). At m=2, only codimension-two threefold centers contribute,
  with net spectrum 3e_(4/9) and net scalar count three. This counts
  contributions, not distinct centers or centers identified as cubics.
- The rank-three pairing counterexample is proved by displaying both
  exact matrix products. It shows that pairing horizontality does not
  preserve the first kernel line. The condition i-j>k on the coefficients
  of a proposed higher-rank modification follows directly from the gauge
  powers z^(j-i). This is a hand proof, not a new numerical search or
  computer-assisted certificate.
- The deformation limitation is recorded using the stably rational cubics
  of Tschinkel--Zhang and the very-general stable-irrationality result
  already cited in the pair: deformation-invariant unmarked quantum data
  cannot completely distinguish stabilization levels within the cubic family.

## Proof review and trust boundary

The second pass checked the constants argument after clearing denominators,
finiteness of each monomial collision fibre, algebraic extension of the
derivations, and exact transport of the canonical lattice. It also checked
the sign of the telescoping identity, component/codimension conventions,
the genus-five example and the higher-rank matrix products.

All five new theorem-like statements have **absent** formal coverage.
Existing Lean sources and terminal signatures are unchanged. The primary
paper now has 20 statements: five absent, six fragments and nine conditional
deductions. The combined three-manuscript inventory has 62 claims, nine
absent, with the prior fragment/conditional/complete counts unchanged.
The source registry, claim map, dependency graph, README, reviewer guide
and description have been updated. No validation gate was relaxed.

## Validation and release

The final authority `make check` passed (2026-09-07, run-quiet directory
`/tmp/claude-run-quiet/20260907-154911-make-C-cubic-stabilization-m1-check/`).
The 17-page PDF has SHA-256
`6a13dfc44514a2e5ced925f8efb200a0509490e77b79ebafc1679efb6a0ef54e`.
Pages 14--16 were visually inspected after the final gate; no display or
pagination repair was needed. Scoped whitespace checks passed. This is an
authority checkpoint; standalone synchronization remains pending.

## Mystery ledger — ej + tt

The post-gate pass checked whether the additive extension might be mistaken
for a stable-birational invariant. A concrete clarification was added:
for X embedded in P4 inside P5, Bl_X(P5) has invariant one while P5 has
invariant zero. Birational invariance therefore already fails in dimension
five, exactly where threefold centers become available.

- **Settled:** the fixed spectrum target does not depend on comparing
  unrelated coefficient fields; every retained discriminant is in C.
- **Settled:** integer exponent classes alone are insufficient; the exact
  refinement uses the canonical modified lattice.
- **Settled:** multiplicativity is unnecessary for Bittner's additive
  presentation, and L acting trivially on the invariant is different from
  assigning L the value one.
- **Settled:** the factorization identity does not assert that a
  rationalization exists for every cubic, nor that there are three distinct
  cubic centers.
- **Open beyond this task:** explicit factorization centers and a geometric
  higher-rank filtration theorem are not supplied. The retained matrix
  counterexample explains the latter missing hypothesis.

There was no incidental discovery-track item: these were assigned checks
and their direct clarifications. C1118 and C1119 remain the next mathematical
upgrades. The author's requested terminology/symbol audit follows those
upgrades as part of C978/C956; the pencil project and email remain deferred.
