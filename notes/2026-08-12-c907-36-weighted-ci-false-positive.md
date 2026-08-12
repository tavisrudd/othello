# C907 weighted `(3,6)` four-packet false positive

**Lane:** `clebsch`

**Status:** theorem-grade exclusion of one apparent `nu_6=4` candidate.

Consider the index-one formal weighted complete intersection

\[
 X_{3,6}\subset\mathbf P(1,1,1,1,2,4).
\]

The ambient weights sum to `10`, so adjunction gives formal index one.  It is
well formed, but it can never be quasismooth.  At the weight-four coordinate
point `p_4`, every cubic vanishes and has zero differential: its only possible
monomials are cubic monomials in the weight-one variables and products of a
weight-two variable with a weight-one variable.  The sextic also vanishes at
`p_4` (it may have a `z y` term, but has no pure `z` term).  Hence the
Jacobian of the two equations has rank at most one at `p_4`, so the affine
cone and the putative threefold are singular.

This failure is substantive: the raw weighted hypergeometric series has the
first plausible four-packet pattern,

\[
 \Phi(s)=\sum_{n\ge0}
 \frac{(3n)!(6n)!}{(n!)^4(2n)!(4n)!}s^n.
\]

Its exact recurrence is

\[
 \frac{a_{n+1}}{a_n}=
 \frac{19683}{16}
 \frac{(n+1/6)(n+1/3)^2(n+2/3)^2(n+5/6)}
 {(n+1)^4(n+1/2)(n+1/4)(n+3/4)},
\]

and the associated scalar operator is

\[
 \theta^4(\theta-1/4)(\theta-1/2)(\theta-3/4)
 -\frac{19683}{16}s
 (\theta+1/6)(\theta+1/3)^2(\theta+2/3)^2(\theta+5/6).
 \tag{1}
\]

The zero-exponential branches at `s=infinity` have scalar powers

\[
 1/6,\quad 1/3,1/3,\quad 2/3,2/3,\quad5/6.
\]

For index one, the threefold framing sends `a` to `a-3/2` modulo integers.
Thus the two copies each of `1/3` and `2/3` would give exactly four primitive
sixth residues.  But (1) is only a raw stacky hypergeometric calculation:
there is no smooth threefold QDM here and no defined carrier invariant.
It is therefore an exclusion, not a counterexample to the carrier bound.

## Source boundary

- Coates--Corti--Iritani--Tseng, arXiv:1310.4163, Theorem 31: the ambient
  weighted-projective hypergeometric construction.
- Coates--Givental, arXiv:math/0110142, Theorem 2: the smooth quantum
  Lefschetz comparison (inapplicable here precisely because quasismoothness
  fails).
- Cai, arXiv:2608.01577, Sections 2--3: framed threefold residue convention.

## Mystery ledger

- **Settled:** four primitive-sixth zero branches can occur in the raw
  weighted hypergeometric arithmetic before smoothness is imposed.
- **Open:** locate a smooth weighted complete intersection retaining this
  multiplicity, or prove a smoothness-forced cancellation theorem.
