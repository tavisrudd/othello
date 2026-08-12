# Cubic-stabilization epilogue, Section 4: hostile quantum-interface review

## Verdict

**MAJOR.** The projective-bundle and weak-factorization spine is correct, and the
claimed scope really is limited to one stabilization.  The load-bearing
sixth-root functional is not yet justified as written, however, and the
cubic/curve comparison misidentifies what Cai computes.  Both defects look
repairable without changing the theorem: define formal monodromy intrinsically
(including ramified descent), weaken the cubic value from `=2` to `>=2` unless
the odd summand is computed, and correct the curve calculation.

This review consulted two primary sources: **one of two at full-text depth**.
Cai was read in full; KKPYY was read partially, at every numbered result cited
in Section 4 and the surrounding definitions/proofs needed to check the
interfaces.

## Findings and line-specific repairs

### 1. Lines 21--80: `nu_6` is not well-defined by the stated definition

**MAJOR.** “Formal-monodromy eigenvalues on the Levelt--Turrittin
regular-singular factors, after the exponential parts have been separated” is
ambiguous after ramification.  If a factor is written after `u=v^m`, then a
further substitution `v=w^e` raises its regular-singular monodromy eigenvalues
to the `e`th powers.  Thus the multiset in lines 22--29 is not intrinsic unless
the manuscript specifies minimal ramification and includes the deck/descent
action, or instead uses the intrinsic formal monodromy of the original
`C((u))` differential module.  KKPYY do not define this `nu_6`; their use of
monodromy in Section 6 is confined to regular-singular connections.

The proof of Lemma 4.1 also assumes, without a cited formal-classification
result, a simultaneous Levelt--Turrittin form compatible with the parameter
connection.  The displayed Lax equation does prove constancy once such a form
exists (and it remains valid with a Laurent parameter term), but existence and
ramified descent are the hard interface.  Definition 5.21 deliberately
identifies fibres lying over an entire connected spectral-cover component, so
pointwise invariance under an ordinary F-bundle isomorphism does not by itself
settle this.

**Repair:** replace lines 21--35 by an intrinsic definition using the full
formal-monodromy operator of the differential module over `C((u))`, described
after *minimal* Turrittin ramification together with its deck permutation.
Then expand lines 43--58 to cite/prove simultaneous good formal decomposition
on the unramified atom component and show that the descended formal-monodromy
operator varies by conjugacy.  State explicitly that ordinary F-bundle
isomorphisms fix `u`: KKPYY Definition 3.1 fixes the disc `D` and its coordinate,
and base pullback is `phi x id_D`; dilation is a separate symmetry functor, not
part of Definition 5.21 equivalence.  Proposition 5.22 then transports the
blowup and Leray--Hirsch equivalences.  Until this repair is supplied, `nu_6`
is not a homomorphism on the claimed free atom group.

### 2. Lines 95--107: Cai's rank-two block is not the whole KKPYY cubic atom

**MAJOR.** Cai explicitly works only with even cohomology.  His computation
finds the two fractional exponents in the rank-two **even** zero-eigenvalue
block.  KKPYY Example 6.21 describes one unsplit zero atom shaped like the atom
of a genus-five curve; it also contains the cubic's odd middle cohomology.
Consequently lines 103--105 (“The same block is the unsplit cubic zero atom”)
are false, and the exact assertion `nu_6(alpha_X)=2` is not established unless
the odd part is separately shown to contain no primitive sixth roots.

The theorem needs only positivity.  **Repair:** change Proposition 4.3(i) to
`nu_6(alpha_X) >= 2`.  Say that parity preservation places Cai's rank-two even
block inside the full zero atom, so its two eigenvalues occur in the atom's
formal-monodromy multiset; make no assertion about the remaining odd summand.
If equality `=2` is desired, add a separate full-big-connection computation of
the odd summand.  Also change “Cai's Proposition 6 gives the indicial
polynomial” to “Cai's calculation preceding Proposition 6 gives ...”; the
proposition itself records only `rho = +/-1/6 mod Z` and membership in the
rank-two Jordan block.

### 3. Lines 109--110: the curve parity statement is reversed and the citation
does not cover all curves

**MAJOR within Proposition 4.3(ii), though the desired vanishing remains
true.** Cai's standing convention excludes odd cohomology, and Proposition 7
assumes genus `g>0`.  Its displayed solutions `z^(1/2)` and `z^(-1/2)` belong
to the **even** part, so raw monodromy there is `-1`; the odd `H^1` summand has
grading residue zero and, because a positive-genus curve has no nonconstant
genus-zero Gromov--Witten invariants, raw monodromy `+1`.  The manuscript says
the opposite.  Cai also does not cover `P^1`.

**Repair:** split the cases.  For `P^1`, use KKPYY Theorem 4.11/Proposition
5.22(3) to reduce to point atoms.  For `g>0`, quote Cai Proposition 7 only for
the even `-1` monodromy and give the one-line odd calculation above.  Both are
disjoint from primitive sixth roots.

### 4. Lines 111--120: surface vanishing is sound after one clarification

**MINOR.** KKPYY Claim 6.15 is at an even base point with vanishing `H^0`
coordinate and concerns the parity-corrected connection.  Its gauge `u^g` has
integral exponents and the correction is `1/2 T`; hence the raw connection can
indeed have only `+1` and `-1` monodromy eigenvalues.  State these hypotheses
and the passage back to the raw connection explicitly.  The remaining surface
classification argument is correct over `C`: minimal `K`-nef surfaces use the
claim; minimal Kodaira-dimension `-infinity` surfaces are `P^2` or ruled; and
point blowups add only point atoms.

### 5. Lines 123--149: projective multiplicity and weak-factorization
noncancellation pass

**PASS.** KKPYY Theorem 4.11 and Proposition 5.22(3) use `r` for the vector
bundle rank, so `X x P^1 = P(O_X^2)` contributes exactly two positive copies:
`CFF(X x P^1)=2 CFF(X)`.  Proposition 5.22(2) gives the coefficient `r-1` for a
codimension-`r` blowup center.  Weak factorization of fourfolds uses smooth
centers of codimension at least two (divisor blowups are isomorphisms), hence
dimension at most two.  Once low-dimensional `nu_6=0` is repaired, all center
terms vanish after applying the homomorphism, and `P^4` contributes only point
atoms.  No signed cancellation or multiplicity mismatch occurs.

### 6. One-stabilization scope passes

**PASS.** Introduction lines 49--57 and synthesis lines 18--24 claim only
irrationality of `X x P^1` and explicitly disclaim stable irrationality.  For
`X x P^m`, `m>=2`, a weak-factorization center can have dimension at least
three and may carry the same cubic-type atom, so the low-dimensional vanishing
argument no longer closes.  The text states exactly this boundary.

## Source record

- Jiaji Cai, *The cubic threefold is symplectically irrational*,
  arXiv:2608.01577v1 (2026). **Read depth: full text**, cached PDF and text,
  cache key `arXiv:2608.01577`, SHA-256
  `06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e`.
- L. Katzarkov, M. Kontsevich, T. Pantev, T. Y. Yu, *Birational Invariants
  from Hodge Structures and Quantum Multiplication*, arXiv:2508.05105v2
  (2026). **Read depth: partial**: Definition 3.1 and F-bundle operations;
  Theorems 4.1, 4.5, 4.11 and surrounding constructions; Definitions 5.10,
  5.16, 5.20, 5.21; Propositions 5.17, 5.22 and proofs; Claim 6.15 and proof;
  Examples 6.19 and 6.21.  Cached PDF and text, cache key
  `arXiv:2508.05105`, SHA-256
  `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`.

Cache verification on 2026-08-11 reported 687 entries and zero hash problems.
