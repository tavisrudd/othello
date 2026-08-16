# C912 — the Serre normalization, and step (iii) restated for atoms

**Date:** 2026-08-15
**Lane:** `cubic-threefolds`
**Task:** C912 (analysis and memo edit; no manuscript edit)
**Follows:** `2026-08-15-c912-gm-genus-six-serre-test.md`, its steps 2 and 3

The genus-six test left two items ahead of it: resolve which Serre relation the
cubic threefold's residual component satisfies, and — the identification having
survived the census — restate step (iii) of the atom route in Serre terms. Both
are done here, and the second turned up a trap worth recording.

## Verdicts

1. **Kuznetsov's relation is the right one; the memo's transcription is not.**
   On the numerical Grothendieck group a shift `[k]` acts by `(-1)^k`, so
   `S^3 = [5]` predicts `S^3 = -I` and `S^5 = [3]` predicts `S^5 = -I`. The
   Serre operator computed from Riemann–Roch satisfies the first exactly and
   fails the second. `S^5 = [3]` would make the eigenvalues primitive tenth
   roots of unity, contradicting both the characteristic polynomial `Phi_6` and
   the manuscript's own exponents `-1/6, -5/6`.
2. **The mathematics no longer depends on the disputed sentence.** The endpoint
   route can be stated with the relation verified here and cited to Kuznetsov,
   using Katzarkov–Kontsevich–Pantev–Yu only for the atom and Serre-enhancement
   framework. The citation question survives as a citation question: their paper
   is not in the lane's literature cache, so Example 6.21 has not been read at
   the source. Searched domain and stop condition are in Section 1.
3. **Step (iii) must be stated for atoms, and is false one notch weaker.** Every
   non-minimal smooth projective surface carries an admissible subcategory whose
   numerical Serre operator has order six, with the primitive sixth roots of
   unity as eigenvalues. So "no admissible subcategory of a surface carries a
   primitive-sixth Serre eigenvalue" is false, and the surface obligation is a
   statement about atoms specifically.
4. **Half of the obligation is automatic.** Every atom of rank one has numerical
   Serre operator equal to the identity, for the trivial reason that a `1 x 1`
   matrix is symmetric. So wherever the small quantum cohomology of the surface
   is semisimple, every block is rank one, every atom is rank one, and step (iii)
   holds with nothing to prove. The obligation lives entirely in the
   non-semisimple cases.

## 1. Which relation holds, and what was and was not read

The frame-transport memo recorded Katzarkov–Kontsevich–Pantev–Yu's Example 6.21
as giving the graded minimal polynomial `S^5 = [3]` for the cubic threefold's
zero atom, where Kuznetsov's fractional Calabi–Yau relation for the same
category is `S^3 = [5]`. The lattice settles which is possible:

```
S = [[2,-3],[-1,-1]]-conjugate,  char poly Phi_6,  order 6
S^3 = -I   -> consistent with S^3 = [5]
S^5 != -I  -> inconsistent with S^5 = [3]
```

This is not a delicate computation: an operator whose characteristic polynomial
is `Phi_6` has order six, and `S^5 = -I` would force order ten.

**Literature status, stated exactly.** The lane's disk cache
(`/tmp/persistent/tavis/lit-search`) was queried for the source; it holds three
atom-programme papers — "Atoms meet symbols" (arXiv:2509.15831), "Naive atoms of
blowups: examples" (arXiv:2606.17884) and "An atomic criterion for irrationality
without …" (arXiv:2607.26718) — but not the Katzarkov–Kontsevich–Pantev–Yu
paper containing Example 6.21. Searching the cached text of the first for
"fractional Calabi–Yau", "Serre automorphism", "cubic threefold", "genus five"
and "primitive sixth" returns its own Kuznetsov-component discussion and a
citation to Kuznetsov's fractional Calabi–Yau paper, but not the example. Stop
condition: no cached copy of the source, and fetching it is a literature task
rather than part of this move. So the verdict above rests on the lattice and on
Kuznetsov's relation as standardly stated, and the source sentence remains
unverified. Nothing downstream needs it, because the endpoint route can cite the
relation that has been checked.

## 2. Step (iii), stated

> **(iii)** No atom of a smooth projective surface has formal monodromy with a
> primitive sixth root of unity as an eigenvalue. Equivalently, under the
> identification of the count with Serre eigenvalues: for no atom of a smooth
> projective surface does the characteristic polynomial of the Serre operator on
> the atom's numerical Grothendieck group have `Phi_6` as a factor.

Two reductions come free with the statement.

**Rank-one atoms are automatic.** For a rank-one lattice the Euler form is a
`1 x 1` matrix, necessarily symmetric, so `S = E^{-1}E^T = 1`. No rank-one atom
can carry a primitive sixth eigenvalue. Since a semisimple small quantum
cohomology has all blocks of rank one, step (iii) holds for every surface whose
small quantum cohomology is semisimple, with no further argument. That covers
the del Pezzo cases the memo's sketch reached by the projective-bundle and
blowup formulas, and it covers them more cheaply.

**The ambient category never sees it.** The Serre functor of a surface is tensor
by the canonical bundle followed by `[2]`, and `[2]` acts by `+1` on K-groups, so
the ambient numerical Serre operator is multiplication by `exp(K)` — unipotent,
with every eigenvalue `1`. Verified for the projective plane, the quadric surface
and the one-point blowup: characteristic polynomial `(lam-1)^n` in each case. A
primitive sixth eigenvalue on a surface can therefore only ever come from a
proper decomposition, never from the surface's own K-theory. That is what makes
step (iii) a statement about how the category decomposes rather than about the
surface.

## 3. The trap: admissible is not enough

For a subcategory generated by an exceptional pair with `chi(e_1,e_2) = x`, the
numerical Serre operator has characteristic polynomial

```
lam^2 + (x^2 - 2) lam + 1,
```

so its eigenvalues are primitive sixth roots of unity exactly when `x^2 = 1`.
Consecutive exceptional objects pairing to `+-1` therefore manufacture an
order-six Serre operator out of two rank-one pieces that each have Serre
operator `1`.

This is not hypothetical on surfaces. Let `X` be any smooth projective surface
containing a `(-1)`-curve `E` — that is, any non-minimal surface — and consider
`O_E(-1)`. From `E^2 = -1` and `K_X . E = -1` alone:

```
chi(O_E(-1))          = 0        chi(O_E(-1), O_E(-1)) = 1   (exceptional)
chi(O_X, O_E(-1))     = 0        chi(O_E(-1), O_X)     = -1
```

and `Hom^*(O_X, O_E(-1)) = H^*(P^1, O(-1)) = 0` on the nose, so
`<O_E(-1), O_X>` is an exceptional pair and generates an admissible subcategory.
Its Euler Gram matrix is `[[1,-1],[0,1]]`, its Serre operator is `[[0,1],[-1,1]]`,
its characteristic polynomial is `Phi_6` and its order is six. Checked on the
blow-up of the projective plane at one point; the two intersection numbers used
hold on every blow-up of a smooth surface at a point, so every non-minimal
surface has such a subcategory.

The subcategory is of course not an atom: it is generated by an exceptional
pair, hence decomposes into two rank-one pieces whose Serre operators are both
the identity. This is the same phenomenon the census sweep already flagged at the
quintic del Pezzo threefold, where the residual component under
`<Ku, O, O(1)>` has a Serre operator of infinite order with irrational
eigenvalues while its atoms are all rank one. The lesson is sharper here because
the fabricated eigenvalues are exactly the ones the criterion counts.

**Consequence for the route.** The eigenvalue criterion is not an invariant of
the surface, nor of an admissible subcategory chosen for convenience; it is an
invariant of the atomic decomposition. Any proof of step (iii) has to work with
atoms — indecomposable in the relevant sense — and no lattice-level argument
that ranges over admissible subcategories can succeed, because the statement it
would prove is false. Conversely, a would-be counterexample to step (iii) is not
established by exhibiting a Serre operator of order six on some component: it
must be shown that the component is an atom.

## 4. What is left of step (iii)

After the two reductions the obligation is: surfaces whose small quantum
cohomology is not semisimple, where some atom has rank at least two. For
canonical class nef, Katzarkov–Kontsevich–Pantev–Yu's Lemma 5.24 gives a single
atom and their Claim 6.15 a regular singularity with nilpotent residue after the
half-parity gauge, which puts every eigenvalue at a root of unity of order at
most two — no primitive sixth. The remaining surfaces are the non-minimal ones
and those with neither nef canonical class nor semisimple quantum cohomology,
where the blowup formula relates the atoms to those of the minimal model
together with rank-one pieces. That is the shape of the argument to write, and
the trap of Section 3 says the blowup step is where care is needed, since the
blowup is exactly what supplies the fake order-six subcategory.

## Memo changes carried by this report

The frame-transport memo's shorter-endpoint-route subsection now records the
verified relation `S^3 = [5]` in place of the transcription, states step (iii) in
the form above with both reductions, and carries the non-minimal-surface
counterexample as a warning against the weakened form.

## Mystery ledger updates

| ID | Status | Discovery | Owner |
|---|---|---|---|
| C912-M26 | resolved | The relation is Kuznetsov's `S^3 = [5]`: on the numerical K-group it predicts `S^3 = -I`, which the Riemann–Roch Serre operator satisfies, while the memo's `S^5 = [3]` predicts `S^5 = -I`, which it fails and which would force primitive tenth roots. The memo now records the verified relation; the source sentence is still unread and the citation goes to Kuznetsov. | Section 1 here |
| C912-M31 | confirmed | Every non-minimal smooth projective surface has an admissible subcategory whose numerical Serre operator has order six, from the exceptional pair `<O_E(-1), O_X>` on a `(-1)`-curve. Step (iii) is therefore false for admissible subcategories, and the eigenvalue criterion is an invariant of the atomic decomposition rather than of the surface. | Section 3 here |
| C912-M32 | resolved | Step (iii) is automatic wherever the small quantum cohomology is semisimple, because every atom is then rank one and a rank-one numerical Serre operator is the identity. The obligation lives entirely in the non-semisimple cases. | Section 2 here |

## Replay

```sh
uv run --with sympy python notes/2026-08-15-c912-surface-atom-serre-check.py
```

```
1fa241142326e529a9fad02174bdcc561dc6fea02985799fc0f31c056aca47a8  notes/2026-08-15-c912-surface-atom-serre-check.py
35c3be48a16acb8762cf4ff6c5f3b3728caeee4caff610072f7eeb01b1fb31ae  notes/2026-08-15-c912-surface-atom-serre-check.out
```

The script takes the cubic threefold's Euler Gram matrix from the genus-six
report's calibration row and each surface's Picard lattice and canonical class as
its only inputs; everything else, including the exceptionality and
semiorthogonality of the pair in Section 3, is computed.
