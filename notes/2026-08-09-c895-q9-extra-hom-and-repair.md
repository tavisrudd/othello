# C895 q=9 extra Hom and revised repair

**Date:** 2026-08-09  
**Task:** C895  
**Verdict:** the universal Lucas-socle statement is false as written; the
load-bearing proof should be narrowed to detector-specific Hom statements

## Bounded exact result

At `q=9`, `p=3`, and `d=3`, modular Hermite reciprocity identifies Paper
II's linear module with

\[
 F\simeq\operatorname{Sym}^2(\operatorname{Sym}^3V).
\]

The current Lemma 3.2(i) predicts that the only central-even simple in the
socle of this module is `L(0,2)`, with multiplicity one.  Exact generator
intertwining equations instead give

\[
 \dim\operatorname{Hom}_{SL_2(9)}(L(0,2),F)=1,
 \qquad
 \dim\operatorname{Hom}_{SL_2(9)}(L(2,0),F)=1.
\]

The other central-even restricted simples `L(0,0)`, `L(1,1)`, and `L(2,2)`
have Hom dimension zero.  Thus `L(2,0)=L(q-7)` is an additional socle copy
outside the manuscript's claimed digitwise list.

## Independent structural witness

This extra copy is not a numerical artifact.  Put

\[
 A=X^3,\quad B=X^2Y,\quad C=XY^2,\quad D=Y^3.
\]

The exact nullspace calculation returns the classical catalecticant-minor
map

\[
\begin{aligned}
 X^2&\longmapsto B^2-AC,\\
 XY&\longmapsto AD-BC,\\
 Y^2&\longmapsto C^2-BD.
\end{aligned}                                             \tag{Q9}
\]

These three quadrics are linearly independent in characteristic three and
transform as `Sym^2 V=L(2)`.  Equivalently, (Q9) is the integral
`Sym^2 V` summand in the classical plethysm
`Sym^2(Sym^3 V)`, reduced modulo three.  Direct substitution in the two root
groups, torus, and Weyl element verifies equivariance.  This supplies a
human structural cross-check independent of interpreting the solver's rank.

## Why this matters

The extra module is not merely harmless noise.  It is exactly the
`L(q-7)` detector that the later extension-field proof says occurs linearly
in `F` “when present.”  The manuscript therefore both excludes and uses the
same `q=9` occurrence:

- Lemma 3.2(i)'s stated “if and only if” digit criterion excludes `L(2,0)`;
- Lemma 3.2(ii) and the uniform sheet exclusion rely on the linear
  `L(q-7)` occurrence and its outer parity.

The cold referee's concern about off-socle target states and carry kernels is
therefore realized by the smallest two-digit field.  A longer proof of the
stated universal basis is not the repair; the statement itself must change.

## Revised concise architecture

Delete the universal finite-group socle classification from the
load-bearing theorem.  Replace it by the only linear-Hom facts used later:

1. `Hom_H(St,F)=0` in the extension-field exceptional branch;
2. the exact occurrence and determinant-normalized outer parity of
   `L(q-7)` in `F` in the extension-field torus-normalizer branch; and
3. the multiplicity-one prime-field Fischer summands and their explicit
   retractions.

The opposite-parity absence from `Sym^2 F` is a different statement.  It is
proved by the root-defect injection into an algebraic-group Hom space and the
detector-specific vanishing calculations, not by a universal socle formula
for `F`.  The Steinberg target Hom in that step now has the complete
`T(2q)` Weyl-filtration proof recorded separately.

This narrowing should shorten the main proof and its appendix: it removes
the need to classify every simple in the finite-group socle and asks only
for three targeted linear channels plus the already targeted outer-parity
channels.

## Exact computation and boundary

Run from the repository root:

```sh
python3 notes/2026-08-09-c895-q9-hom-falsifier.py --check
```

The script constructs `F_9=F_3[a]/(a^2+1)`, the polynomial modules, and the
full intertwining equations.  It compares a compact generating set
`u(1),u(a),w,h` with all nine positive-root elements together with `w,h`.
Both give the displayed dimensions and the same explicit map.

- script: 10,141 bytes, SHA-256
  `782087ca2931c7438dca514010b65cb152d90df18cc27ae86822dde0fea20ab6`;
- canonical JSON: 2,731 bytes, SHA-256
  `c32901fbc65a05404bc4d449ddeb47fd63d483528e9713791019a2d4a368d7cd`.

The computation certifies only the five central-even simple rows at `q=9`.
It does not prove any all-field replacement.  The explicit catalecticant map
independently certifies the one counterexample needed to reject the current
universal statement.

## Next gate

Prove the three detector-specific linear-Hom assertions above.  In
particular, determine the general mechanism producing `L(q-7)` and its outer
normalization; its `q=9` specialization must be (Q9).  Do not resume the
carry-matrix factorization unless a later theorem genuinely needs the full
socle.
