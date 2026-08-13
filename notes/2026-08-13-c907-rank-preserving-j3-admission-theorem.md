# C907 rank-preserving `J_3` admission theorem

**Lane:** `clebsch`

**Status:** theorem-grade conditional carrier exclusion.  Any enriched
primitive-sixth Rees object which faithfully forgets to the framed formal QDM
cannot have a string longer than the rank of that QDM primary space.  Hence
every landed threefold class with `nu_6<=2` is automatically free of the
endpoint `J_3`.  This turns the entire prime-Fano and weighted-CI portfolio
from reconnaissance into a conditional Silver carrier theorem for those
classes.

## Rank lemma

Let `V_6(Z)` be the primitive-sixth formal solution lattice of a smooth
projective threefold `Z`, after splitting `Phi_6`, and suppose an enriched
Rees realization consists of a finite exhaustive filtration with torsion-free
associated grades `G_i` such that forgetting the filtration identifies its
underlying lattice with `V_6(Z)`.  Then

\[
 \sum_i\operatorname{rank}G_i
 =\operatorname{rank}V_6(Z)=\nu_6(Z).
 \tag{1}
\]

Every consecutive string of length `ell` has `ell` nonzero grades, so

\[
 \boxed{\ell_{1/6}(Z)\le\nu_6(Z).}
 \tag{2}
\]

In particular

\[
 \nu_6(Z)\le2\quad\Longrightarrow\quad
 \text{no endpoint }J_3\text{ occurs in }\mathscr A(Z).
 \tag{3}
\]

The proof is rank additivity for a finite filtration; it uses no splitting of
the filtration and no vanishing of first extensions.  It is stronger than the
old `nu_6>=4` prefilter for a length-two carrier because the corrected Silver
threat is length three, not length two.

## Classes now excluded conditionally

The landed formal calculations prove `nu_6<=2` for:

1. every smooth complex prime Fano threefold, with equality only in the
   recorded positive genera;
2. every smooth strongly well-formed rank-one weighted Fano complete
   intersection in the stated ordinary sector;
3. every smooth Fano cyclic cover of `P^3`;
4. `V_5`, `V_10`, and the stable-birationally compressed prime families;
5. the cubic Lefschetz-pencil total threefold, whose exact value is two.

Under the single faithful rank-preserving realization hypothesis of (1), all
these classes satisfy the exact Silver carrier condition: none contains a
Tate shift of `J_3`.  A nonzero one-step Rees extension may remain, but it is
irrelevant to the positive Krull--Schmidt telescope.

This does not prove the universal carrier theorem.  Weak factorization admits
arbitrary non-Fano/non-nef threefold centers, for which no universal `nu_6`
bound exists.  Nor do the formal QDM calculations themselves construct the
filtered realization assumed in (1).  They become decisive only after one
faithful forgetful comparison is part of the definition/theorem.

## Interaction with the local regressions

- The cubic-surface stationary `A_5` model cannot create `J_3` in the cubic
  pencil under (1), because its whole primitive-sixth space has rank two.
  This recovers the `S_6` Hom vanishing without knowing the endpoint
  characters.
- The conic Clifford node cannot contradict (3): its raw Loewy-length-three
  ideal is not a rank-preserving single-operator Rees string, and every
  radical element squares to zero.
- The formal stationary countermodel remains valuable: it shows that if a
  proposed enrichment introduces grades not accounted for by `V_6(Z)`, then
  formal monodromy and pairing alone cannot stop `N^2`.

## EJ/TT and mystery ledger

- **EJ:** correcting Silver from `ell<=1` to exclusion of `J_3` upgrades every
  `nu_6<=2` calculation at once; no sectorial multiplication computation is
  needed inside those classes after faithful rank preservation.
- **TT:** use formal rank only to bound the number of nonzero Rees grades, not
  to split extensions or identify their products.
- **Settled:** conditional `J_3` exclusion for the complete prime-Fano,
  weighted-CI, cyclic-cover, and cubic-pencil portfolios.
- **Open:** construct one faithful rank-preserving enriched realization and
  bound `nu_6` (or exclude `J_3` directly) for arbitrary non-Fano/non-nef
  threefolds.  The universal carrier mystery is now confined to those two
  issues.
