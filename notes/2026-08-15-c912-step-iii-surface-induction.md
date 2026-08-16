# C912 — step (iii) for surfaces: the induction, and exactly what it rests on

**Date:** 2026-08-15
**Lane:** `cubic-threefolds`
**Task:** C912 (analysis and memo edit; no manuscript edit)
**Follows:** `2026-08-15-c912-step-iii-serre-restatement.md`, Section 4

The previous report stated the surface obligation and disposed of the semisimple
and nef-canonical cases. What was left was the non-semisimple surfaces outside
the nef class. This report closes the case analysis by running the surface
minimal model program, and states precisely which external theorems the result
stands on.

## Verdicts

1. **Step (iii) holds for every smooth projective surface, conditional on three
   external inputs**, by induction along the minimal model program. The inputs
   are Iritani's blowup formula for atoms, the projective-bundle formula for
   atoms, and Katzarkov–Kontsevich–Pantev–Yu's description of the atom of a
   surface with nef canonical class. Nothing else is used.
2. **Two of the three are already load-bearing in the memo's route**, so the
   induction imports one new statement, not three. The memo's shorter endpoint
   route already puts two copies of the cubic's atom into `X x P^1` by the
   projective-bundle formula, and already invokes the nef-canonical description.
   The genuinely new import is the blowup formula, and it is exactly the case
   that has been verified for surfaces in the literature.
3. **The induction is short because the two reductions from the previous report
   do the work.** Rank-one atoms are automatic, and the blowup formula only ever
   adds rank-one atoms, so blowing up can never create the eigenvalue. Every
   minimal case then reduces to a curve or to a semisimple spectrum.

## 1. The statement

> **Theorem (step (iii), conditional).** Let `S` be a smooth projective surface
> over the complex numbers. Then no atom of `S` has a primitive sixth root of
> unity as an eigenvalue of its Serre automorphism; equivalently, for no atom of
> `S` does the characteristic polynomial of the Serre operator on the atom's
> numerical Grothendieck group have `Phi_6` as a factor.

The proof is an induction on the number of blow-downs to a minimal model, which
is finite by Castelnuovo's contractibility criterion.

**Blow-down step.** If `S` is not minimal, write `S = Bl_p S'`. Iritani's blowup
formula for a smooth centre `Z` of codimension `c` gives the atoms of the blowup
as the atoms of the ambient variety together with `c - 1` copies of the atoms of
the centre. Here `c = 2` and `Z` is a point, so the atoms of `S` are those of
`S'` together with one copy of the atoms of a point — a single rank-one atom,
whose Serre operator is the identity. So `S` satisfies the theorem if `S'` does,
and the induction descends.

**Minimal cases.** A minimal smooth projective surface either has nef canonical
class, or is the projective plane, or is a projective bundle over a smooth curve.

*Canonical class nef.* Katzarkov–Kontsevich–Pantev–Yu's Lemma 5.24 gives a
single atom, and their Claim 6.15 gives a regular singularity with nilpotent
residue after the half-parity gauge. A nilpotent residue means unipotent
monodromy, and the half-parity gauge can only introduce a sign, so every
eigenvalue is a root of unity of order at most two. No primitive sixth root.

*The projective plane.* Its small quantum cohomology is semisimple: the
characteristic polynomial of quantum multiplication by the anticanonical class is
`lam^3 - 27q`, whose discriminant `-19683 q^2` is not identically zero. Every
block of the quantum connection is then rank one, so every atom is rank one, and
a rank-one Euler form is a `1 x 1` matrix, necessarily symmetric, so its Serre
operator is the identity. The same computation for the quadric surface gives
`lam^4 - 8(q_1+q_2) lam^2 + 16(q_1-q_2)^2`, again with non-vanishing
discriminant, so that case is covered twice over — once as a projective bundle
and once by semisimplicity.

*Projective bundles over a curve.* The projective-bundle formula gives the atoms
of the bundle as copies of the atoms of the base curve. For a curve of any genus
the Euler form on the numerical Grothendieck group is `[[1-g, 1], [-1, 0]]` in
the basis of the structure sheaf and a point, its Serre operator is
`[[-1, 0], [2-2g, -1]]`, and the characteristic polynomial is `(lam+1)^2` for
every genus. The only eigenvalue is `-1`. For the rational base the category
splits further into the two rank-one atoms of its exceptional collection, whose
Serre operators are the identity. Either way, no primitive sixth root.

That exhausts the classification, so the theorem follows. ∎

## 2. The three external inputs, stated as used

1. **Iritani's blowup formula for atoms.** Blowing up a smooth projective variety
   along a smooth centre of codimension `c` yields atoms consisting of the atoms
   of the ambient variety together with `c - 1` copies of the atoms of the
   centre. Used only for a point in a surface, where it adds one rank-one atom.
   Source: H. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555 (v3,
   2025). Verified in the surface case by A. Gyenge and S. Szabó, *Blow-ups and
   the quantum spectrum of surfaces*, Advances in Mathematics 479 (2025),
   doi:10.1016/j.aim.2025.110432.
2. **The projective-bundle formula for atoms**, in the form the memo's shorter
   endpoint route already uses when it puts two copies of the cubic's atom into
   `X x P^1`. Used here for a projective bundle over a curve.
3. **The nef-canonical description**: Katzarkov–Kontsevich–Pantev–Yu's Lemma 5.24
   and Claim 6.15, as recorded in the memo.

**Settled after this report was written:** input 1 has since been read at the
source and holds in the decorated form — see
`2026-08-15-c912-blowup-formula-source-check.md`. The discussion below of what
the decorated form means, and of the gap between it and the multiplicity
reading, stands as written; only its status changed.

The induction needs the *decorated* form of inputs 1 and 2 — that the atoms
carry over with their Serre automorphisms, not merely that the multiplicities
match. That is how Katzarkov–Kontsevich–Pantev–Yu use the projective-bundle
formula in their own irrationality argument, and how the memo uses it, so the
same reading is being asked of the blowup formula. Worth stating because the
computational literature works with multiplicity sequences: Böhning, von Bothmer
and Su'a define naive and small atomic decompositions as ordered sequences of
multiplicities, and check the naive form of the blowup statement in examples.
Their own Example 12.11 records that the naive and small decompositions can
differ, so "the multiplicities behave" is strictly weaker than what is needed.

**Literature status, stated exactly.** The bibliographic locators for inputs 1
and 2 were read out of the bibliography and introduction of Böhning–von
Bothmer–Su'a, *Naive atoms of blowups: examples*, arXiv:2606.17884v2, which is in
the lane's disk cache. Neither Iritani's paper nor Gyenge–Szabó's has been read
here, and neither has Katzarkov–Kontsevich–Pantev–Yu's. Stop condition: the cache
holds three atom-programme papers and none of these three. The theorem above is
therefore conditional in the strict sense — the case analysis and the two
reductions are checked, the imported statements are not.

## 3. Why the blow-down step cannot go wrong, and where it could

The previous report showed that every non-minimal surface carries an admissible
subcategory whose numerical Serre operator has order six, built from the pair
`<O_E(-1), O_X>` on a `(-1)`-curve. That fake is manufactured by the very
operation the induction's first step performs, so the two statements need to be
held apart carefully.

They are compatible, and for a structural reason rather than an accident. The
blowup formula says the blowup's atoms are the old atoms plus one rank-one atom.
The fake subcategory is neither: it mixes the new exceptional object with the
structure sheaf of the ambient surface, which belong to different atoms. An
exceptional pair spanning two distinct atoms has no reason to be an atom itself,
and indeed it is decomposable. So the fake is not a counterexample to the
induction; it is a demonstration that the criterion must be applied to the
atomic decomposition and not to a convenient admissible subcategory.

Where the step could still go wrong is in the decorated reading of the blowup
formula. If the atoms of the blowup were only isomorphic to the old ones after a
twist that moves the Serre automorphism, the induction's conclusion would not
transfer. Nothing in the computational literature consulted here rules that out,
because it works with multiplicities. That is the single point to verify at the
source, and it is now isolated.

## 4. Consequence for the endpoint

With step (iii) reduced to three named imports, the shorter endpoint route in the
memo has no remaining mathematical gap of its own: the dimension-four exclusion
needs points, curves and surfaces, and all three are now covered — points and
curves by Katzarkov–Kontsevich–Pantev–Yu's own dimension-three argument, surfaces
by the induction here. What the route costs is the imports, which is the trade
the memo already recorded: the atom, motive and Serre-enhancement machinery in
exchange for the transport lemma this memo could not prove.

Next, in order.

1. Verify the decorated form of the blowup formula at the source (Iritani, and
   Gyenge–Szabó for surfaces). This is the one isolated point above, and it is a
   literature task with a definite target rather than an open problem.
2. Verify Lemma 5.24 and Claim 6.15 at the source, which the memo has wanted
   since it first recorded them.
3. Compute the quantum-side count for the sextic double solid, still the sharpest
   falsification test of the identification (ledger item C912-M28).

## Mystery ledger updates

| ID | Status | Discovery | Owner |
|---|---|---|---|
| C912-M33 | confirmed | Step (iii) holds for every smooth projective surface by minimal-model induction, conditional on three imports: Iritani's blowup formula, the projective-bundle formula, and the nef-canonical atom description. Blowing up only ever adds rank-one atoms, whose Serre operators are the identity, so the blow-down step is free; the minimal cases reduce to a curve or to a semisimple spectrum. | Section 1 here |
| C912-M34 | open | The induction needs the *decorated* blowup formula — atoms transferring with their Serre automorphisms — while the computational literature verifies only that multiplicity sequences behave, and records that naive and small atomic decompositions can differ. This is the single unverified point in the surface argument. | Section 3 here; owner is a source-level literature check |

## Replay

```sh
uv run --with sympy python notes/2026-08-15-c912-step-iii-surface-induction-check.py
```

```
af324bc0caa962be3bf483e53805525a932a99ecf4b632bbda22e08b7ef8386c  notes/2026-08-15-c912-step-iii-surface-induction-check.py
68656ebc84c90379ec527dee0b61f1ecfd25958ca3defc452231826823b22617  notes/2026-08-15-c912-step-iii-surface-induction-check.out
```

The script computes the two quantum spectra and their discriminants, the Serre
operator of a curve of arbitrary genus, and the rank-one triviality. The blow-down
step and the classification of minimal surfaces are structural and need no replay.
