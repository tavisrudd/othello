# C907 isolated-stacky weighted-hypersurface rank theorem

**Lane:** `clebsch`

**Status:** theorem-grade for the stated hypersurface class.

## Theorem

Let

\[
 X_d\subset\mathbf P(w_0,\ldots,w_4)
\]

be a smooth well-formed Fano hypersurface threefold.  Assume:

1. the weights are pairwise coprime (equivalently, the stacky locus of the
   ambient weighted projective space consists only of coordinate points); and
2. `H=O_X(1)` is the primitive Picard generator.

Then, after the usual index-one reconstruction normalization, the full
small-even QDM is the reduced rank-four hypergeometric module

\[
 \theta^4-C s
 \prod_{a\in A}(\theta+a),\qquad s=q/z^r,
 \tag{1}
\]

where `r=sum_iw_i-d>0`, `C!=0`, the multiset `A` is invariant under
`a mapsto1-a`, and `|A|=4-r`.  Consequently its framed primitive-sixth
multiplicity satisfies

\[
 \nu_6(X)\le2.
\]

## Proof

At an ambient stacky coordinate point of weight `w_i`, all other tangent
characters are nontrivial because the weights are pairwise coprime.  If `X`
passed through that point, one equation could remove at most one nontrivial
character, leaving a three-dimensional quotient which is not a
pseudoreflection quotient.  Thus smoothness forces `X` to avoid every stacky
point.  Its defining equation therefore has a nonzero pure monomial
`x_i^(d/w_i)` for every `w_i>1`, so `w_i` divides `d`.

The untwisted weighted hypersurface period is

\[
 \Phi(s)=\sum_{n\ge0}
 \frac{(dn)!}{\prod_i(w_i n)!}s^n.
\]

For an integer `N`, write
`F_N={1/N,...,(N-1)/N}`.  Since each `w_i` divides `d`, the fractional
denominator set `F_(w_i)` is contained in `F_d`; pairwise coprimality makes
these nonzero sets disjoint.  Cancelling them in the coefficient recurrence
leaves

\[
 A=F_d\setminus\bigsqcup_iF_{w_i},
 \qquad |A|=(d-1)-\sum_i(w_i-1)=4-r.
\]

The five denominator `(n+1)` factors and the one numerator `(n+1)` factor
leave exactly `(n+1)^4`.  Hence the recurrence is that of (1).  Each `F_N`
is invariant under `a mapsto1-a`, so the same holds for `A`.

Because `X` avoids the stacky locus, `H` is an ordinary line bundle and the
target has no twisted sectors.  The weighted-projective mirror theorem and
quantum Lefschetz identify the cohomology-valued hypergeometric solution with
the small QDM.  Its four classical leading terms are
`1,H,H^2,H^3`, so (1) is its full small-even rank-four module, not merely an
ambient summand.  The rank-four support bound therefore gives `nu_6<=2`.

## Exact boundary

This does not cover a weighted projective space with a positive-dimensional
stacky stratum, a hypersurface meeting a stacky stratum by a special smooth
quotient mechanism, a non-primitive `O_X(1)`, a weighted complete
intersection, or any raw stacky `I`-series whose order exceeds four.  In
particular it does not turn the singular `(3,6)` false positive into a
counterexample.

## Source boundary

- Coates--Corti--Iritani--Tseng, arXiv:1310.4163, Theorem 31: weighted
  projective `I`-functions.
- Coates--Givental, arXiv:math/0110142, Theorem 2: quantum Lefschetz.
- Cai, arXiv:2608.01577, Sections 2--3: framed threefold formal residues.

## Mystery ledger

- **Settled:** in the isolated-stacky hypersurface class, smoothness forces
  the exact rank-four reduction required by the structural `nu_6<=2` bound.
- **Open:** positive-dimensional stacky strata and weighted complete
  intersections, where smoothness may impose a subtler cancellation.
