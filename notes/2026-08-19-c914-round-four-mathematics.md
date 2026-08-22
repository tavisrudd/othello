# C914 round four: independent mathematical referee report

- **Date**: 2026-08-19
- **Lane**: `cubic-threefolds`
- **Task**: C914
- **Object under review**: the uncommitted diff `c914-round4.diff` against
  `papers/cubic-stabilization-m1/` (sections `02-envelope.tex`,
  `03-minimal-class.tex`, plus the ledger and the claims registry rows that mirror them).
- **Method**: cold read. No earlier referee report was consulted; every judgement below was
  formed from the manuscript sources and, where noted, from the cited literature.

*(report written incrementally; sections appended as the checks were completed)*

## Verdict

I found no mathematical error in the changed text. Every substantive claim in the four items
put to me is true, and in each case the printed justification does establish it, once the
readings recorded below are adopted. Two of the changes are genuine repairs rather than
cosmetic rewordings: the finiteness argument in `sections/03-minimal-class.tex` now runs in the
parameter curve, where the old version intersected the pencil (a subset of a projective line)
with loci that live in coarse moduli and never said how the two were compared; and the split of
the `L'` paragraph in `sections/02-envelope.tex` makes the final paragraph's back-reference
("uses only that the index is odd, not orthogonality") true as written, which it was not before,
because the sentence being referred back to previously asserted orthogonality and unimodularity
as part of the same breath as the module-level decomposition. The reworded conclusion of
`prop:no-elliptic-product` states exactly what its proof delivers, neither more nor less.

The defects below are precision and completeness defects in the printed prose, not errors.
The most serious is the first: as literally written, one clause of the new definition of a
signature admits a scalar for which the object being defined does not exist. The remaining four
are missing half-clauses in otherwise correct arguments.

I checked the two literature claims that the new argument leans on against the sources
themselves (both fetched successfully; see the "sources consulted" section), and both hold, with
the exact wording quoted below. I also confirmed the Klein cubic's order-three eigenvalue
multiplicities independently of González-Aguilera--Liendo, by a character computation in
`PSL(2,F_11)`, and that computation also independently confirms that the Klein cubic is a member
of this particular pencil rather than of the other `A_5`-component.

## Defects, most severe first

### 1. The scalar ambiguity in the definition of a signature is stated too widely

`papers/cubic-stabilization-m1/sections/03-minimal-class.tex`, new text:

> a signature is the tuple of exponents of \(\zeta_3\) in a diagonalization of a linear lift of
> the automorphism, well defined up to permutation of the coordinates, replacement of the chosen
> generator by its inverse, and multiplication of the lift by a scalar.

Taken literally the last clause is not available. The tuple of exponents of `zeta_3` exists only
for a lift whose eigenvalues are cube roots of unity, that is, for a lift of order dividing three
in `GL_5(C)`. Multiplying such a lift by an arbitrary scalar `c` produces eigenvalues
`c*zeta_3^{a_i}`, which are cube roots of unity only when `c` is one; for any other `c` the
exponent tuple of the new lift is undefined, so it is not a case in which "the tuple is well
defined up to" anything. The clause is salvageable only by reading "scalar" as "cube root of
unity", and the paper needs exactly that reading two sentences later: "a scalar shift permutes
the multiplicities cyclically" is the statement that the exponents move by `a -> a + b` for
`b` in `Z/3`, which is multiplication of the lift by `zeta_3^b` and by nothing else.

There is a second, smaller looseness in the same sentence: the lift is not said to be chosen of
order three, which is what makes the diagonalization have `zeta_3`-power eigenvalues at all.

Concrete replacement:

> a signature is the tuple of exponents of \(\zeta_3\) in a diagonalization of a linear lift of
> order three, well defined up to permutation of the coordinates, replacement of the chosen
> generator by its inverse, and multiplication of the lift by a cube root of unity
> \cite[Definition~2.1]{GonzalezAguileraLiendo}.

The added citation is worth its space: the normalization the paper is describing is
González-Aguilera--Liendo Definition 2.1 verbatim, `sigma ~ sigma'` iff
`sigma' = a * pi(sigma) + b * 1` for `pi` in `S_{n+2}`, `a` in `F_p^*`, `b` in `F_p`, whereas
Theorem 2.5, the only thing cited in the paragraph, is the classification that uses it. With
`p = 3` the three ingredients of that relation are precisely the three moves the manuscript
lists, with `a = 2` the inversion and `b` the cube-root-of-unity shift. So the normalization the
manuscript states is the right one for the comparison it makes and matches the source, once
"scalar" is narrowed.

**Reading taken.** I read "replacement of the chosen generator by its inverse" as `a = 2` in
that relation, that is, replacing the chosen primitive cube root of unity by the other one,
equivalently replacing the automorphism by its inverse. The two descriptions induce the same map
`a -> 2a` on exponents, so the ambiguity of the phrase does not affect anything.

### 2. The multiplicity comparison disposes of two of the three moves it listed

`sections/03-minimal-class.tex`, new text:

> The multiplicities of the eigenvalues \(1,\zeta_3,\zeta_3^2\) are \((2,2,1)\) for that
> signature and \((4,1,0)\) and \((3,2,0)\) for the two above, while a scalar shift permutes the
> multiplicities cyclically and inversion transposes the last two, so no such move identifies
> them: the Klein cubic lies in neither family.

The normalization sentence lists three moves; this sentence says what two of them do. The third,
permutation of the coordinates, is the one that acts trivially on the multiplicity triple, and
saying so is what closes the argument, since without it a reader has been told that signatures
are compared up to a move whose effect on the invariant being compared was never stated. The
omission is trivial to repair and the conclusion is correct.

While repairing it, the sentence can be made sharper at no cost. A cyclic shift together with
the transposition of the last two entries generates the full symmetric group on the three
multiplicity slots, so the invariant actually being compared is the multiset of multiplicities,
and the three multisets are `{1,2,2}`, `{0,1,4}` and `{0,2,3}`. Stating it that way removes any
need for the reader to check six cases.

Concrete replacement:

> The multiplicities of the eigenvalues \(1,\zeta_3,\zeta_3^2\) are \((2,2,1)\) for that
> signature and \((4,1,0)\) and \((3,2,0)\) for the two above. Permuting the coordinates leaves
> these triples unchanged, while a scalar shift permutes them cyclically and inversion
> transposes the last two, so the three moves compare the triples only as multisets; as
> \(\{1,2,2\}\), \(\{0,1,4\}\) and \(\{0,2,3\}\) are distinct, the Klein cubic lies in neither
> family.

### 3. "At least one block" has no antecedent, and the covering step is asserted without its reason

`sections/03-minimal-class.tex`, new text:

> At least one block has size one or two, since the defining form of a smooth cubic threefold
> involves all five variables and five is not a multiple of three.

The arithmetic is sound and complete for what it is asked to do, but two things it rests on are
not on the page. First, "block" occurs here for the first time in the paper; the object meant is
a group of variables in the separated-variable form of Proposition `prop:A5-nonseparated`, and
the bound that makes the argument work -- that every such group has at most three variables --
lives in that proposition's statement, not in this paragraph. A reader arriving at this sentence
has been given a divisibility argument whose two hypotheses are one paragraph away and unnamed.
Second, "the defining form of a smooth cubic threefold involves all five variables" is exactly
right and exactly necessary (without it the groups need not cover the five variables, and a
single group of size three would be a counterexample to the sentence), but its one-line reason
is omitted: a cubic form not involving `x_4` has all five partial derivatives vanishing at
`[0:0:0:0:1]`, which is then a singular point.

**Reading taken.** I read "block" as "group of variables in the separated-variable form", and
the sentence as quantified over separated-variable forms, not over all smooth cubic threefolds.

Concrete replacement:

> In such a form the groups of variables are disjoint, nonempty and of size at most three, and
> they cover all five variables, since a cubic form omitting a variable has a singular point at
> the corresponding coordinate point; as five is not a multiple of three, at least one group has
> size one or two.

### 4. The existence of a Klein parameter, which carries the whole finiteness argument, is left as a presupposition

`sections/03-minimal-class.tex`, new text:

> The preimage in \(B^\circ\) of each of the two loci under the moduli map is closed and omits a
> parameter of the Klein cubic, hence is a proper closed subset of the irreducible curve
> \(B^\circ\), a nonempty open subset of a \(\PP^1\), and therefore finite; \(M_{H_1}\) is the
> image of \(B^\circ\), so each locus meets it in a finite set.

Everything here is available and correct, and the step "closed in moduli, therefore closed
preimage" is exactly enough -- continuity of the classifying map is all the preimage needs, and
the classifying map is the restriction to `B°` of the quotient morphism onto the coarse moduli
space of smooth cubic threefolds. My objection is only that the load-bearing step is phrased as a
definite description rather than an assertion: "omits a parameter of the Klein cubic"
presupposes that a `b` in `B°` with `X_b` projectively equivalent to the Klein cubic exists. It
does, and the paper says so two sentences earlier ("The Klein cubic lies in the pencil"), with a
citation I verified. But this is the one place where nothing weaker will do, and the paragraph
should say so out loud, because a reader who reaches for a dimension count instead will fail:
González-Aguilera--Liendo record `D = 1` for the family `T_3^2`, so that locus is a curve, the
same dimension as `M_{H_1}`, and the containment `M_{H_1}` inside `T_3^2` is excluded by the
Klein point and by nothing else in the paper.

**Reading taken.** "A parameter of the Klein cubic" = a point of `B°` whose fibre is projectively
equivalent to the Klein cubic. On the alternative reading, a point of `B°` mapping to the moduli
point of the Klein cubic, the argument is the same and the citation supports it just as directly,
since Hartlieb's statement is about `M_{H_1}`.

Concrete replacement for the first clause:

> Some \(b\in B^\circ\) has \(X_b\) projectively equivalent to the Klein cubic, by the membership
> recorded above, and the preimage in \(B^\circ\) of each of the two loci under the moduli map is
> closed and omits that \(b\); hence it is a proper closed subset ...

### 5. Orthogonality is introduced one level below where the later steps consume it

`papers/cubic-stabilization-m1/sections/02-envelope.tex`, new text:

> Under the polarization hypothesis that sum is moreover orthogonal, each summand of \(L'\)
> carries \(m\) times a unimodular alternating form, and each \(P_i\) is unimodular.

This is true on either reading of "that sum" and supplies what the rest of the proof needs, so it
is not an error. It is, though, stated at the two-adic level, while the step that consumes it --
"That decomposition is orthogonal for the trace-determinant pairing `b` used above" -- needs the
`U_i` to be `kappa`-orthogonal in `W_5`, and it also needs `kappa` restricted to each `U_i` to be
nondegenerate for the discriminant-group count that follows. Getting from "the `P_i` are
orthogonal in `L ⊗ Z_2`" to "the `U_i` are `kappa`-orthogonal" is a two-step detour through the
earlier "two of them are orthogonal exactly when the subspaces are `kappa`-orthogonal" plus the
observation that a rational number vanishing in `Q_2` vanishes. The polarization hypothesis gives
the rational statement directly: `mu^*Theta = m * sum Theta_i` makes the polarization form
block-diagonal on `⊕ H_1(A_i,Z)`, so the `mu_* H_1(A_i,Q)` are mutually orthogonal and hence the
`U_i` are `kappa`-orthogonal.

**Reading taken.** "That sum" = the decomposition `L ⊗ Z_2 = ⊕_i P_i` just displayed, and "each
summand of `L'`" = `mu_* H_1(A_i,Z)`.

Concrete replacement:

> Under the polarization hypothesis the subspaces \(U_i\) are moreover \(\kappa\)-orthogonal,
> since \(\mu^*\Theta=m\sum_i\Theta_i\) makes the polarization form block-diagonal; so that sum
> is orthogonal, each summand of \(L'\) carries \(m\) times a unimodular alternating form, and
> each \(P_i\) is unimodular.

A smaller observation on the same sentence: I could not find a later step that uses the
unimodularity of `P_i`. The construction in the second case uses unimodularity of
`L ∩ (Qv ⊗ M_Q)` and `L ∩ (v^perp ⊗ M_Q)`, which is derived separately from `kappa(v,v) = 5`
being a unit at two, and the discriminant-group count uses `Lambda ∩ U_i`, not `P_i`. The clause
is true and harmless; it may simply be inert.

## What I checked and found correct

### The order-three signature route (`sections/03-minimal-class.tex`)

1. **The divisibility argument.** Partitions of five into parts of size at most three are
   `3+2`, `3+1+1`, `2+2+1`, `2+1+1+1` and `1+1+1+1+1`; all contain a part of size one or two,
   and the only way to avoid one would be all parts of size three, which needs three to divide
   five. The covering hypothesis really is needed, and the smoothness reason for it is right.
   Defect 3 above is about the prose, not the arithmetic.

2. **The automorphism produced.** Multiplying the variables of a group of size one or two by
   `zeta_3` multiplies that group's cubic summand by `zeta_3^3 = 1` and fixes the others, so the
   form is genuinely invariant, not merely semi-invariant. This matters for `p = 3`, where
   González-Aguilera--Liendo explicitly note (their Remark 2.3) that a lift need only send `F`
   into the `xi`-eigenspace in general; here the invariance is on the nose, so the cubic lies in
   the eigenspace `E_sigma` and hence in the family. The diagonal matrix is non-scalar, because
   the group of variables is a proper nonempty subset of the five, so the automorphism has order
   exactly three in `PGL_5(C)`, and its signature is `(0,0,0,0,1)` or `(0,0,0,1,1)`.

3. **The identification with `T_3^1` and `T_3^2`.** Verified directly against the source.
   González-Aguilera--Liendo Theorem 2.5 lists, for cubic threefolds,
   `T_3^1: sigma = (0,0,0,0,1)`, `D = 4`, `F = L_3(x_0,x_1,x_2,x_3) + x_4^3` and
   `T_3^2: sigma = (0,0,0,1,1)`, `D = 1`, `F = L_3(x_0,x_1,x_2) + M_3(x_3,x_4)`. Both the
   signatures and the numbering match the manuscript, in the manuscript's order. As a bonus,
   the two listed normal forms *are* separated-variable forms, so the containment can also be
   seen without the signature language at all.

4. **The containment clause.** Correct, and the inference is the direction Theorem 2.5 actually
   supplies: their theorem says that a smooth cubic threefold with an order-`p` automorphism has,
   after a coordinate change diagonalizing it, a defining form on the list, with `diag(sigma)`
   generating the cyclic group, and that the `sigma` in their list of representatives is unique.
   So "admits an order-three automorphism of signature `sigma_i`" implies "lies in the family
   with that signature", which is what the sentence needs. Membership is invariant under
   projective equivalence, as the loci are defined in moduli, so restricting the conclusion to
   points of `M_{H_1}` represented by cubics projectively equivalent to a separated form is
   sound.

5. **The Klein cubic's signature, and that it lies in neither family.** Supported by the source:
   González-Aguilera--Liendo Proposition 2.6 states that the Klein cubic belongs to `T_2^2`,
   `T_3^4`, `T_5^1` and `T_11^1`, and their proof says explicitly that because there is a single
   conjugacy class of elements of order three the cubic belongs to one and only one of the
   order-three families. Their `T_3^4` carries `sigma = (0,0,1,1,2)`, matching the manuscript.
   Signature is a `GL_5`-conjugacy invariant, so "one conjugacy class in `Aut(X)`" does give
   "one signature class for every order-three automorphism", which is the direction the argument
   needs.

   I also confirmed this independently of that source. The five-dimensional representation of
   `PSL(2,F_11)` in which the Klein cubic sits has character value `-1` on the class of elements
   of order three; the norm computation over the eight classes of `PSL(2,F_11)` pins that value
   down, since the alternative value `2` already overshoots the class-sum bound. Multiplicities
   `(m_0,m_1,m_2)` with `m_0 + m_1 zeta_3 + m_2 zeta_3^2` equal to `-1` up to a cube-root-of-unity
   shift force the multiset `{1,2,2}`, and neither `{0,1,4}` nor `{0,2,3}` admits such a trace.
   So the Klein cubic's exclusion from both families holds on a route that touches neither
   Theorem 2.5 nor Proposition 2.6.

6. **The multiplicity computation and the disjointness of the orbits.** `(0,0,1,1,2)` gives
   `(2,2,1)`; `(0,0,0,0,1)` gives `(4,1,0)`; `(0,0,0,1,1)` gives `(3,2,0)`. A scalar shift by
   `zeta_3^b` sends `(m_0,m_1,m_2)` to `(m_{-b}, m_{1-b}, m_{2-b})`, a cyclic permutation;
   inversion sends it to `(m_0,m_2,m_1)`. Together these generate the full symmetric group on the
   three slots -- the transformations `a -> a*x + b` on `Z/3` form `AGL(1,3)`, which is `S_3` --
   and coordinate permutations act trivially. So the orbits are the multisets `{1,2,2}`,
   `{0,1,4}` and `{0,2,3}`, which are pairwise distinct, and the orbits really are disjoint,
   including under coordinate permutations. Defect 2 above is only that the printed sentence
   leaves the permutations unmentioned.

7. **The finiteness argument upstairs, step by step.** Every step is available at that point of
   the paper.
   - The two loci are closed in the moduli space of smooth cubic threefolds. Hartlieb's Lemma 2.7
     proof supplies the finite morphism `U^G/N_{GL(5,C)}(G) -> U/GL(5,C) = M` (his citation is to
     Luna's main theorem), and a finite morphism is closed, so the image `M_G` is closed. The
     relevant `G` here, the cyclic group generated by the diagonal automorphism, does inject into
     `PGL(5,C)`, which is Hartlieb's standing assumption on `G` in that subsection. The two
     manuscript loci are exactly `M_{G_1}` and `M_{G_2}`, because
     González-Aguilera--Liendo's family for `sigma` is the image of the smooth locus of the
     eigenspace `E_sigma`, and `E_sigma` is the space of `diag(sigma)`-invariants.
   - Closedness in moduli is enough for the preimage to be closed, since the classifying map
     `B° -> M` is a morphism (the restriction of the quotient morphism; smooth cubics are stable,
     and the paper already uses the same map in the proof of `prop:A5-not-coprime`, where
     `M_{H_1}` is described as the image of `B°`).
   - `B°` is a nonempty open subset of a projective line: the introduction computes
     `dim (Sym^3 W_5^*)^{A_5} = 2` from the character `(5,1,-1,0,0)`, so the parameter space is a
     `P^1`, and smoothness is an open condition. So `B°` is irreducible of dimension one and a
     proper closed subset of it is finite.
   - The Klein membership is established, and the citation is exact: Hartlieb Proposition 5.7
     reads "The closure of `J(M_{H_1})` in `A_5` is a one-dimensional special subvariety.
     Moreover, `M_{H_1}` contains the Klein cubic threefold and is thus not contained in the locus
     of cyclic cubic threefolds." I confirmed it independently as well: the five-dimensional
     representation of `PSL(2,F_11)` restricts to the `A_5` subgroup with character
     `(5,1,-1,0,0)`, which is the irreducible `W_5` and not `1 + W_4`, so the Klein form is an
     `A_5`-invariant cubic on `W_5` and the Klein cubic is a member of this pencil rather than of
     the other `A_5`-component. Hartlieb's Lemma 5.5 makes the same dichotomy explicit, splitting
     the `A_5` locus into the `chi_5` component `M_{H_1}` and the permutation component `M_{H_2}`.
   - `M_{H_1}` is the image of `B°`, so the intersection of each locus with `M_{H_1}` is the image
     of the corresponding preimage, hence finite.
   - A consistency check the argument passes: the finite intersection is not empty. The Fermat
     cubic is a member of the pencil (`rem:fermat-in-pencil`) and belongs to every one of
     González-Aguilera--Liendo's families except `T_11^1`, so it is one of the finitely many
     points. The proposition is therefore finiteness and not disjointness, which is what the
     manuscript claims.

8. **The replacement repairs a real gap.** The text this replaced read "The pencil is an
   irreducible curve, so it meets each of the two loci in a finite set", which intersects a subset
   of the parameter line with two subsets of coarse moduli without saying how they were being
   compared, and which never used the closedness it had just established. The new version does
   the intersection upstairs, where both objects live in `B°`, and uses the closedness.

9. **The final sentence.** "The finiteness of the separated-variable locus therefore does not
   depend on the registered computation" is accurate: the alternative route uses no output of the
   `a5-pencil-eckardt` evidence bundle. Its inputs are instead literature results, one of which
   (González-Aguilera--Liendo's classification) was itself obtained with computer algebra, so the
   paragraph's opening claim of "a route that uses no computation" is a claim about this paper's
   own computations only. That opening sentence is unchanged text and I raise this only because
   the new material leans on the cited classification harder than the old material did.

### The `L'` paragraph and the rest of `prop:no-elliptic-product` (`sections/02-envelope.tex`)

10. **The module-level fact is correct and really does need only odd index.** `L'` is the image
    under `mu_*` of the integral homology of the product, so `[L : L']` is the degree of `mu`.
    Each `mu_* H_1(A_i,Z)` sits inside `L ∩ (U_i ⊗ M_Q)`, and those intersections are independent
    because the `U_i` are, so `L'` is contained in their direct sum, which is contained in `L`.
    With `[L : L']` odd, both indices are odd and both inclusions become equalities after
    localizing at two, giving `L ⊗ Z_2 = ⊕_i P_i`. No polarization data enters.

11. **Each later step that consumes orthogonality or unimodularity still has it.** I walked the
    proof step by step.
    - Surjectivity of the first-coordinate projection onto `Lambda_1 ⊗ Z_2`, and the resulting
      decomposition `Lambda_1 ⊗ Z_2 = ⊕_i (Lambda_1 ∩ U_i) ⊗ Z_2` with equality in each piece:
      uses only `L ⊗ Z_2 = ⊕ P_i` and the saturation of `Lambda_1 ∩ U_i`. No orthogonality.
    - The intersection with the first coordinate subspace being `Lambda ⊗ Z_2`, and its
      decomposition: the `U_i`-decomposition is compatible with the splitting of `M ⊗ Q_2` into
      its two basis coordinates, so a vector of the first-coordinate subspace has each of its
      `U_i`-components in that subspace. No orthogonality.
    - `H_2 = ⊕_i H_2^{(i)}` and the `omega`-stability of each summand: consequences of the two
      decompositions plus the displayed description of `L ⊗ Z_2`. No orthogonality.
    - "That decomposition is orthogonal for the trace-determinant pairing `b`": needs
      `kappa`-orthogonality of the `U_i`, which the polarization hypothesis supplies. Available,
      by the route recorded in defect 5.
    - "The discriminant group of a lattice of rank `r` needs at most `r` generators": applied to
      `Lambda ∩ U_i`, with `H_2^{(i)}` a subgroup of its discriminant group because
      `Lambda_1` is inside `Lambda^dual`. Needs `kappa` nondegenerate on `U_i`, which again comes
      from the orthogonal splitting. Available.
    - The construction in the second case uses unimodularity of the two summands cut out by an
      axis class `v` with `kappa(v,v) = 5`, derived on the spot from `5` being a unit at two, not
      from the `P_i`. Unaffected by the restructure.

12. **The final paragraph's back-reference is now accurate.** "The argument above through
    `H_2 = ⊕_i H_2^{(i)}` with each summand `omega`-stable uses only that the index is odd, not
    orthogonality" is exactly right after the split: as itemized above, the four steps up to and
    including `omega`-stability use the odd-index decomposition, the exotic-graph description of
    `L ⊗ Z_2`, and the absence of complex multiplication on `E`, and nothing else. Before the
    split the sentence pointed back at a paragraph that asserted orthogonality and the `m`-times-
    unimodular form in the same breath as the decomposition, so a reader had no way to see which
    half was being invoked.

13. **Rank one is genuinely forced, twice over.** With five elliptic factors, `mu_*` is an
    isomorphism on rational homology, so each `U_i` is a line in `W_5` and the five are
    independent. The printed route works: `Lambda ⊗ Z_2` has rank five and is the direct sum of
    the five `(Lambda ∩ U_i) ⊗ Z_2`, each of rank at most one, so each has rank exactly one, and
    the same for `Lambda_1`. There is also a one-line direct route, since each `U_i` is by
    construction a subspace of `W_5 = Lambda ⊗ Q` and therefore a rational line, so
    `Lambda ∩ U_i` is a rank-one lattice outright; the manuscript may prefer it, but the printed
    justification is valid as it stands.

14. **Killed by two, and the vanishing.** For `x` in `Lambda_1 ∩ U_i` we have `2x` in `Lambda` by
    `Lambda_1 ⊆ (1/2)Lambda` -- which is how `Lambda_1` was defined, as
    `Lambda^dual ∩ (1/2)Lambda` -- and `2x` is still in `U_i`, so `2x` is in `Lambda ∩ U_i`. The
    quotient of a rank-one lattice pair is cyclic, cyclic and killed by two means `F_2`-dimension
    at most one, and an `F_4`-subspace has even `F_2`-dimension, so each `H_2^{(i)}` vanishes and
    `H_2 = 0`, against `|H_2| = 16`. Correct, and the contradiction is with a quantity the proof
    established earlier (`F_4`-dimension two).
    A consistency check: the isogeny `E^5 -> J` coming from `Lambda ⊗ M ⊆ L` has degree divisible
    by sixteen, computed from the displayed graph description, so the proposition does not
    contradict the isogeny it acknowledges.

15. **The reworded conclusion states exactly what the proof gives.** The proof takes an arbitrary
    odd-degree isogeny from a product of five elliptic curves and derives a contradiction, with no
    hypothesis relating `mu^*Theta` to the product polarization, so "with no condition imposed on
    the pulled-back polarization" is right. It is also not more than the proof gives: the
    unpolarized argument kills exactly the case in which every `U_i` is a line, since a summand
    `H_2^{(i)}` of even `F_2`-dimension can only be nonzero when `dim U_i` is at least two, and
    the total is five. A three-factor shape of dimensions `1,2,2` is not excluded by it, so the
    statement's restriction to five elliptic curves is the true reach of the argument. The old
    phrase "whatever polarizations those factors carry" quantified over data the conclusion never
    uses -- elliptic curves carry a canonical principal polarization anyway -- and could be read
    as retaining the earlier `mu^*Theta = m sum Theta_i` hypothesis with the `Theta_i` varying,
    which is a strictly weaker statement than the one proved. The replacement removes that
    reading. The trailing "although `J` is isogenous to `E^5`" is correct and is corroborated by
    Hartlieb's Remark 5.8, which records that the intermediate Jacobians of members of `M_{H_1}`
    are all isogenous to the self-product of an elliptic curve.

### Ledger and registry rows

16. The registry row for `prop:no-elliptic-product` in
    `papers/cubic-stabilization-m1/lean/verification/claims.json` now says "odd isogeny
    degree, and an odd multiple of the product polarization; for the last conclusion, odd degree
    alone" and mirrors the manuscript's new phrasing in its conclusion field. Both are accurate
    against the proof. I recomputed the recorded `statement_digest` with the project's own
    hashing rule (annotations stripped, comments stripped, whitespace collapsed, SHA-256) and it
    matches the new proposition text: `04ed2c378b0...f955e8a`. The full annotation checker does
    not currently run to completion for an unrelated reason in the Lean tree (a missing docstring
    on `blockDiagonalProjection_apply`), which is outside the scope of this review and outside
    this diff.

17. The two changed rows of `papers/cubic-stabilization-m1/claim-proof-novelty-ledger.md`
    describe the proposition correctly, including the added sentence that the five-elliptic-factor
    conclusion drops the polarization hypothesis entirely and the refined description of the
    difference from van Geemen--Yamauchi, which now distinguishes "matching the polarizations when
    the factors have dimension at most three" from "nothing beyond odd degree when there are five
    elliptic factors". That is the correct division of the two cases.

## Sources consulted

- V. González-Aguilera and A. Liendo, *Automorphisms of prime order of smooth cubic n-folds*,
  arXiv:1002.4136. **Fetched successfully** and read directly (Definition 2.1, Remarks 2.2--2.3,
  Theorem 2.5, Proposition 2.6). Quotations above are from that text.
- M. Hartlieb, *Special subvarieties in the locus of intermediate Jacobians of cubic threefolds*,
  arXiv:2304.03214v2. **Fetched successfully** and read directly (Theorem 2.4, Remark 2.5,
  Lemmas 2.6--2.7, Lemma 5.5, Lemma 5.6, Proposition 5.7, Remark 5.8).
- Manuscript context read but not reviewed: `sections/01-introduction.tex` (the definition of the
  pencil, `thm:separation-family`, `rem:fermat-in-pencil`), the whole of
  `prop:no-elliptic-product` and its surrounding discussion in `sections/02-envelope.tex`, and
  `lem:eckardt-rank`, `prop:A5-not-coprime` and `prop:A5-nonseparated` in
  `sections/03-minimal-class.tex`.
- The character-theoretic cross-checks on `PSL(2,F_11)` and `A_5` were done by hand as recorded
  above, not taken from a source.
