# C917 — Epilogue positioning against classical Hodge theory and Guéré's work

**Lane:** `cubic-threefolds`

**Status:** active; author-supplied edit specification below

**Objective:** update the `m = 1` cubic-stabilization epilogue
(`papers/cubic-stabilization-epilogue/`, build target
`irrationality_after_one_stabilization`) so that it answers the expert question
"why doesn't Clemens--Griffiths already obstruct `X x P^1`?", positions the
unconditional ordinary-Hodge-atom proof against Guéré and
Benedetti--Fay--Guéré--Manivel--Perrin, and does not overclaim the broad
quantum/Hodge philosophy as novel.

**Scope:** introduction prose, related-work discussion, and the two new
bibliography entries. Theorem statements, hypotheses, proofs, and Section 4
structure stay unchanged.

The remainder of this card is the author-supplied edit specification, verbatim.

---

**Target draft:** current 48-page version of *Irrationality of Cubic Threefolds after One Stabilization*.  
**Goal:** answer the expert question “why doesn't Clemens--Griffiths already obstruct \(X\times\mathbf P^1\)?”, accurately position the unconditional ordinary-Hodge-atom proof relative to Guéré and Benedetti--Fay--Guéré--Manivel--Perrin, and avoid overclaiming the broad quantum/Hodge philosophy as novel.

---

## 1. Mandatory edit: expand the introduction's classical comparison

### Anchor

Under:

> **Relation with earlier rationality results**

the current text begins:

> “Clemens and Griffiths proved that every smooth complex cubic threefold is irrational by means of its intermediate Jacobian [6]. That obstruction does not by itself control a product with projective space.”

Keep the first sentence. Replace the second sentence with the paragraph below.

### Recommended exact replacement

> The direct Clemens--Griffiths mechanism no longer yields a contradiction after one stabilization. Indeed,
> \[
> H^3(X\times\mathbf P^1,\mathbf Q)\simeq H^3(X,\mathbf Q),\qquad
> H^4(X\times\mathbf P^1,\mathbf Q)\simeq\mathbf Q(-2)^{\oplus2}.
> \]
> In a birational factorization of a fourfold, smooth surface centers may occur, and blowing up such a surface \(S\) contributes \(H^1(S,\mathbf Q)(-1)\) to \(H^3\). For the cubic itself, the Fano surface of lines satisfies \(\operatorname{Alb}(F(X))\simeq J(X)\) [6, Theorem 11.19], hence \(H^1(F(X),\mathbf Q)(-1)\simeq H^3(X,\mathbf Q)\). Thus the surviving weight-three Hodge structure is already realizable as the \(H^1\) of a smooth surface, exactly the form that a surface center may contribute, while the middle \(H^4\) is Tate. The standard intermediate-Jacobian/blowup bookkeeping therefore gives no contradiction here, though this does not exclude more elaborate classical Hodge-theoretic obstructions. The Hodge-atom argument below refines this raw Hodge bookkeeping by following the quantum spectral packet carrying the Hodge representation rather than \(H^3\) alone.

### Why this wording is safe

It does **not** claim:

- the Fano surface actually occurs as a blowup center;
- every Hodge-theoretic obstruction fails;
- rationality is compatible with all cohomological data;
- \(\delta^\sharp\) excludes surfaces;
- the stabilized cubic is the same classical-Hodge problem as a cubic fourfold.

It claims only that the **direct** Clemens--Griffiths Hodge/intermediate-Jacobian contradiction disappears.

---

## 2. Shorter version

If the introduction is too dense:

> The direct Clemens--Griffiths mechanism no longer yields a contradiction after one stabilization. Künneth gives \(H^3(X\times\mathbf P^1)\simeq H^3(X)\), while the middle group \(H^4(X\times\mathbf P^1)\simeq\mathbf Q(-2)^{\oplus2}\) is Tate. In dimension four a smooth surface center may contribute \(H^1(S)(-1)\) to \(H^3\), and the Fano surface of lines satisfies \(\operatorname{Alb}(F(X))\simeq J(X)\) [6, Theorem 11.19], equivalently \(H^1(F(X))(-1)\simeq H^3(X)\). Thus the surviving cubic Hodge structure is already of surface-center type. This removes the direct intermediate-Jacobian contradiction, though not every conceivable classical Hodge-theoretic obstruction, and motivates the finer atomic bookkeeping below.

---

## 3. Add a concise 2026 related-work paragraph

The March and July papers are close enough that the current draft should acknowledge them.

### Recommended paragraph

> Recent work gives complementary quantum/Hodge refinements of classical fourfold rationality obstructions. Guéré proves that if a smooth cubic fourfold is rational, then its primitive rational Hodge structure is the twisted middle cohomology of a projective K3 surface [NEWREF-G]. Benedetti--Fay--Guéré--Manivel--Perrin give a cohomological criterion that uses monodromy to force a large vanishing middle Hodge representation into one coarse atom, proving irrationality of Hodge-general cubic, Gushel--Mukai, and Küchle fourfolds without explicit quantum-cohomology computations [NEWREF-BFGMP]. Their criterion assumes \(b_3=0\) and exploits a large vanishing \(H^4\), so it does not apply to \(X\times\mathbf P^1\), where \(b_3=10\), the middle \(H^4\) is Tate, and the surviving \(H^3\) is already carried by the Fano surface. The present argument instead uses finer structure of the ordinary cubic atom, culminating in the rank-two residue discriminant.

This paragraph positions the result without suggesting that the broad atomic philosophy is new here.

### More compact version

> For comparison, Guéré obtains a K3-type Hodge necessary condition for rational cubic fourfolds using evaluated quantum data [NEWREF-G], while Benedetti--Fay--Guéré--Manivel--Perrin prove a monodromy/coarse-atom irrationality criterion for Hodge-general Fano fourfolds with large vanishing middle \(H^4\) [NEWREF-BFGMP]. The latter does not cover \(X\times\mathbf P^1\): here \(b_3=10\), middle \(H^4\) is Tate, and the surviving \(H^3\) is already of surface-center type. The proof below therefore requires finer information internal to the ordinary cubic atom.

### Recommendation

Use the compact version unless the introduction has room for the longer comparison.

---

## 4. Bibliography entries

Add:

> J. Guéré, *On the irrationality of cubic fourfolds*, arXiv:2603.04518v1 (2026).

and:

> V. Benedetti, A. Fay, J. Guéré, L. Manivel, and N. Perrin, *An atomic criterion for irrationality without quantum computations*, arXiv:2607.26718v1 (2026).

The final numbering will of course depend on insertion order.

---

## 5. Optional bridge sentence into the atom proof

No bridge is necessary.

If desired:

> In particular, the issue is not whether \(H^3(X)\) survives, but whether the finer quantum spectral packet carrying its Hodge representation can be realized by a smooth projective variety of dimension at most two.

This matches the ordinary KKPY non-rationality criterion better than saying “realized by a lower-dimensional center.”

Do **not** write:

> “The residue discriminant distinguishes the cubic from the Fano surface.”

Surface representatives are excluded by the atomic composition/parity argument and surface classification; \(\delta^\sharp\) excludes the genus-five curve candidate.

---

## 6. Update the novelty language

### Strong novelty language that is still supported

May say:

- “We prove that \(X\times\mathbf P^1\) is irrational for every smooth complex cubic threefold \(X\).”
- “We introduce a rank-two atomic residue discriminant \(\delta^\sharp\) for ordinary Hodge atoms.”
- “The stabilized cubic lies outside the recent coarse middle-Hodge atomic criterion.”
- “Its raw \(H^3\) is already carried by the Fano surface, whereas the ordinary atom carrying the corresponding Hodge representation is not realizable by any surface.”
- “The residue discriminant distinguishes the cubic atom from the only curve representative left by Hodge parity.”
- “The example separates surface-realizability of a Hodge representation from surface-realizability of the atom carrying it.”
- “The argument uses finer structure internal to an ordinary atom than the coarse Hodge-size criteria sufficient in several recent fourfold applications.”

### Broad novelty language to remove or avoid

Do not say or imply:

- “We introduce the idea of using quantum spectral localization to refine classical Hodge theory.”
- “This is the first atomic refinement of a classical Hodge rationality obstruction.”
- “Previous atomic fourfold arguments require explicit quantum computations.”
- “Our method is conceptually distinct from all previous quantum/Hodge fourfold methods.”

The July joint paper explicitly derives irrationality from atoms, monodromy, and Hodge theory without explicit quantum computations.

---

## 7. How to describe Benedetti--Fay--Guéré--Manivel--Perrin accurately

Their Theorem 4.1 concerns a smooth Fano fourfold \(X\) that is a hyperplane section of a smooth Fano fivefold \(Y\) and assumes, among other conditions,
\[
b_1(X)=b_3(X)=0
\]
and
\[
b_4(X)_{\rm van}\ge 10+12h^{3,1}(X).
\]

Monodromy irreducibility forces the vanishing \(H^4\) into one coarse atom. Under rationality, weak factorization forces the corresponding coarse atom to come from a surface. A Noether-type bound on surface Hodge numbers then gives the contradiction.

Use phrases such as:

- “coarse atomic criterion”;
- “monodromy forces the vanishing middle cohomology into one coarse atom”;
- “without explicit quantum-cohomology computations”;
- “relies deeply on the existence of atoms.”

Do not paraphrase their title as “without quantum information.” The atom theory and monodromy-equivariance of quantum multiplication remain essential.

### Important technical caveat

Their Remark 4.2 records a subtlety about maximal spectra for evaluation maps defined relative to a blowup-center embedding versus the identity morphism, and points to a forthcoming revision of Guéré's paper.

There is no reason to import this caveat into the current proof, because Section 4 does not use their maximal-evaluation argument. But if the related-work discussion becomes detailed, do not state their evaluation formalism more strongly than their current v1.

---

## 8. How to describe Guéré accurately

May say:

- “Guéré adapts the KKPY/Iritani framework.”
- “His evaluation maps are closely related to the Hodge-atom construction.”
- “He proves a K3-type necessary condition for rational cubic fourfolds.”
- “His \(♥\)-invariant forces a surface carrier with \(c_1(K)=0\), nonzero \(h^{2,0}\), and vanishing \(h^1\), which is K3 in the cubic-fourfold case.”

Do not say:

- “Guéré proves all cubic fourfolds irrational.”
- “Guéré's proof is literally a Hodge-atom proof.”
- “His result applies to \(X\times\mathbf P^1\).”

He explicitly says he chose not to discuss Hodge atoms because they were not directly necessary, while noting the close relation of his evaluation maps to the atom construction.

---

## 9. Keep the current Section 4 proof structure explicit

### Proposition 4.16

- Hodge representation forces genus \(5\) for a possible curve representative.
- \(\delta^\sharp\) separates the cubic atom from that curve.

### Proposition 4.17

- Push a possible surface atom to a minimal model.
- Nef-canonical minimal surfaces have one atom whose even rank is at least \(3\).
- \(\mathbf P^2\) and ruled surfaces have only point/curve atoms.
- Therefore \(\alpha_X\) cannot be represented by a surface.

The new related-work paragraphs should motivate why this is stronger than raw Hodge or coarse middle-Hodge bookkeeping; they should not change the proof.

---

## 10. Keep the first- and second-stabilization boundaries separate

There are now three distinct thresholds worth keeping conceptually separate:

1. **Classical CG mechanism:** becomes too weak already at the first stabilization because surfaces can carry \(H^3\).
2. **Present ordinary atom criterion:** proves the first stabilization irrational, but becomes too weak from the second stabilization because the cubic atom already has a threefold representative.
3. **July coarse fourfold criterion:** is aimed at fourfolds with \(b_3=0\) and large non-Tate middle \(H^4\), so it does not address the present first-stabilization geometry in the first place.

Do not merge these limitations.

---

## 11. Recommended fully integrated replacement passage

A ready-to-paste version for “Relation with earlier rationality results”:

> Clemens and Griffiths proved that every smooth complex cubic threefold is irrational by means of its intermediate Jacobian [6]. The direct Clemens--Griffiths mechanism no longer yields a contradiction after one stabilization. Indeed,
> \[
> H^3(X\times\mathbf P^1,\mathbf Q)\simeq H^3(X,\mathbf Q),\qquad
> H^4(X\times\mathbf P^1,\mathbf Q)\simeq\mathbf Q(-2)^{\oplus2}.
> \]
> In a birational factorization of a fourfold, smooth surface centers may occur, and blowing up such a surface \(S\) contributes \(H^1(S,\mathbf Q)(-1)\) to \(H^3\). The Fano surface \(F(X)\) satisfies \(\operatorname{Alb}(F(X))\simeq J(X)\) [6, Theorem 11.19], hence \(H^1(F(X),\mathbf Q)(-1)\simeq H^3(X,\mathbf Q)\). Thus the surviving weight-three Hodge structure is already realizable as the \(H^1\) of a smooth surface, exactly the form that a surface center may contribute, while the middle \(H^4\) is Tate. The standard intermediate-Jacobian/blowup bookkeeping therefore gives no contradiction here, though this does not exclude more elaborate classical Hodge-theoretic obstructions. The ordinary Hodge-atom argument below refines this raw Hodge bookkeeping by following the quantum spectral packet carrying the Hodge representation rather than \(H^3\) alone.
>
> Recent work gives complementary quantum/Hodge refinements in dimension four. Guéré proves that a rational smooth cubic fourfold must have primitive rational Hodge structure of projective-K3 type [NEWREF-G]. Benedetti--Fay--Guéré--Manivel--Perrin prove irrationality of Hodge-general cubic, Gushel--Mukai, and Küchle fourfolds from a monodromy/coarse-atom criterion without explicit quantum-cohomology computations [NEWREF-BFGMP]. Their criterion uses a large vanishing middle \(H^4\) and assumes \(b_3=0\), so it does not apply here: \(X\times\mathbf P^1\) has \(b_3=10\), Tate middle \(H^4\), and a surviving \(H^3\) already carried by the Fano surface. The present proof instead uses finer structure of the ordinary cubic atom, including the rank-two residue discriminant.

Then continue with the existing discussion of very general stable irrationality, Cai, Iritani/Iritani--Koto, and KKPY.

### Recommendation

This is mathematically clear but perhaps long. If the introduction becomes bloated, retain the classical paragraph and shorten the second paragraph to two sentences.

---

## 12. Suggested shorter integrated related-work wording

If space is important:

> For comparison, Guéré recently obtained a projective-K3-type Hodge necessary condition for rational cubic fourfolds using evaluated quantum data [NEWREF-G], while Benedetti--Fay--Guéré--Manivel--Perrin prove a monodromy/coarse-atom irrationality criterion for Hodge-general fourfolds with large vanishing middle \(H^4\) [NEWREF-BFGMP]. Their criterion does not cover \(X\times\mathbf P^1\), whose middle \(H^4\) is Tate and whose surviving \(H^3\) is already of surface-center type; the proof below instead requires finer information internal to the ordinary cubic atom.

This is probably the best default.

---

## 13. Exact novelty paragraph for a cover letter or introduction

> The recent fourfold literature shows that the localization of Hodge data into quantum spectral packets can itself carry birational information, sometimes without explicit quantum-cohomology computations. The stabilized cubic threefold lies outside those coarse middle-Hodge criteria: its middle \(H^4\) is Tate, \(b_3=10\), and its surviving \(H^3\) is already realized by the Fano surface. The new point here is that the ordinary atom carrying that Hodge representation cannot be represented by any surface. Hodge parity leaves a genus-five curve as the only remaining low-dimensional possibility, and the new rank-two atomic residue discriminant separates that curve atom from the cubic atom.

Use this rather than claiming novelty for the broad quantum/Hodge philosophy.

---

## 14. Final pre-commit checklist

- [ ] Uses the current 48-page draft.
- [ ] Leaves Theorem 1.1 unchanged.
- [ ] Leaves the abstract unchanged unless independently revising its novelty wording.
- [ ] Writes \(H^3(X\times\mathbf P^1)=H^3(X)\).
- [ ] Writes \(H^4(X\times\mathbf P^1)=\mathbf Q(-2)^{\oplus2}\).
- [ ] Uses \(H^1(F)(-1)\simeq H^3(X)\).
- [ ] Says surface centers are possible, not that \(F(X)\) actually occurs.
- [ ] Uses “direct” or “standard” before “Clemens--Griffiths mechanism.”
- [ ] Includes the caveat about more elaborate classical Hodge methods.
- [ ] Does not attribute surface exclusion to \(\delta^\sharp\).
- [ ] Cites Guéré only for a necessary K3-type condition.
- [ ] Does not call Guéré's proof literally a Hodge-atom proof.
- [ ] Cites the July joint atomic criterion as related work.
- [ ] Says the July criterion uses \(b_3=0\) and large vanishing middle \(H^4\).
- [ ] Does not claim that the July paper avoids quantum information; only explicit quantum computations.
- [ ] Does not claim the broad quantum/Hodge spectral-localization philosophy as novel.
- [ ] Makes the new \(\delta^\sharp\) invariant and the uniform one-stabilization theorem prominent.
