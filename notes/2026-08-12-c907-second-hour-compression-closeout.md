# C907 second-hour compression closeout

**Lane:** `clebsch`

**Status:** theorem-grade carrier exclusion for smooth well-formed/strongly
well-formed rank-one weighted Fano complete intersections; ten boundary-star
types and the bounded residual intersection certified algebraically; the first
non-WCI Fano test $V_5$ has ν₆ equal to zero.  The `m=2` theorem remains
open at the common fan/collar and universal threefold-carrier gates.

## Landed mathematics

### 1. Inertia--cyclotomic weighted-CI theorem

For a quasismooth WCI threefold

\[
X_{d_1,\ldots,d_c}\subset\mathbf P(w_0,\ldots,w_{c+3})
\]

with smooth coarse space, well-formed ambient weighted projective space, and
`codim_X(X intersect Sing W_coarse)>=2`, inertia avoidance gives

\[
 \#\{i:m\mid w_i\}\le \#\{j:m\mid d_j\}
 \qquad(m>1).
\tag{1}
\]

Equivalently,

\[
 \prod_i\frac{t^{w_i}-1}{t-1}
 \mid
 \prod_j\frac{t^{d_j}-1}{t-1}.
\tag{2}
\]

Thus every fractional denominator in the factorial period cancels.  The
reduced scalar operator is exactly

\[
 \theta^4-Cq\prod_{a\in A}(\theta+a),
 \qquad |A|=4-r,\quad A=1-A.
\tag{3}
\]

Wang's published all-complete-intersection toric-stack mirror theorem
identifies the surviving inertia-free identity-sector slice with the full
ordinary small-even QDM, including non-Cartier defining degrees.  Under
`Pic(X)=Z[O_X(1)]` primitively and `r>0`, the QDM is cyclic rank four and

\[
 \nu_6(X)\le2.
\tag{4}
\]

This closes the entire stated weighted-CI carrier class: the current
length-two enrichment needs at least two primitive-sixth pairs, hence
`nu_6>=4`.

The quotient

\[
R(t)=\prod_jQ_{d_j}(t)/\prod_iQ_{w_i}(t)
\]

also gives an exact one-line support test.  At index one the positive case is
`R=Phi_2 Phi_3`; at index two it is `R=Phi_3` or `Phi_6`; indices three and
four are zero.  This subsumes all prior WCI denominator scans and explains
why the raw `(3,6)` four-packet was forced to fail smoothness.

### 2. Boundary-star compression

Exact normalized/saturated tangent-Fitting certificates now cover ten
boundary-star types for arbitrary toric valuations of `y_1,y_2,y_3`:

- `B=C=0`;
- `B=0` or `C=0` with the other coordinate generic;
- `B=infinity` or `C=infinity` with the other coordinate generic;
- `B=C=infinity`;
- `B=1` or `C=1` with the other coordinate generic; and
- the translated `(1,0)` and `(0,1)` toric seams, together with their marked
  compact residual attachments.

Six exact Singular replays enumerate 31 masks apiece.  Each reports five
empty and 26 free masks, with no unmarked hold.  The translated seam's
incidence closure retains exactly the four known residual Morse points.

The 186 mask cases compress to two Laurent-support arguments:

1. a simplex support with a unit logarithmic derivative; and
2. a reciprocal--linear circuit, whose only mixed tangent system contradicts
   `5P!=0`.

The generic translated-one stars also have an order-zero face where `L`
survives; its separately recomputed Fitting ideal is unit.

### 3. A necessary negative correction

Positive pole order is not a freeness theorem.  The saturated domain

\[
 \delta^2L=x^2
\]

has a pre-normalization central product, but its normalization is
`x=delta y`, `L=y^2`, whose special-fibre value map is critical at `y=0`.
Therefore every face must be tested on the normal total strict graph.  The ten
closed stars pass because the explicit derivatives prove total smoothness and
normality there.  No local support calculation supplies a uniform
`delta`-collar or common overlap theorem.

### 4. The bounded residual intersection

In the finite Rees chart around `B=C=1`, arbitrary toric `y` weights have a
single support family.  When the normalization order is positive, its 14
possible proper supports split into four empty and ten `L`-free faces; the
four-term circuit cannot occur.  Order zero forces all three `y` weights to
vanish and recovers exactly

\[
 L=f_Q+ZU,
 \]

with the four reduced residual Morse points.  Thus the bounded `1/1` corner
has no unmarked tangent circuit.  The remaining algebraic hold is the joint
`y`/Rees-infinity fan and its translated/infinity seams.

### 5. The first non-WCI Fano

For the degree-five Fano threefold $V_5$, the exact cyclic small-even
operator is

\[
 \theta^4-s(11\theta^2+11\theta+3)-s^2,
 \qquad s=q/z^2.
\]

At infinity its four branches are unramified and irregular, with
\(\lambda^2=22\pm10\sqrt5\) and common scalar prefactor $x^{-3/2}$,
where $x=s^{1/2}=q^{1/2}/z$.  The threefold frame makes every formal residue
integral, so

\[
 \chi^{\rm fr}_{V_5}(T)=(T-1)^4,
 \qquad \nu_6(V_5)=0.
\]

## Further implications

1. The weighted-CI carrier search is finished under the exact hypotheses,
   and the first non-WCI Picard-one test $V_5$ is negative in the stronger
   form ν₆ equal to zero.  A reconnaissance calculation for the genus-six
   prime $V_{10}$ also gives zero, but remains conditional on a tracked
   creative-telescoping certificate and a direct full-QDM scalarization.  Its
   double HLT root is resonant with exponent difference one, so no
   diagonalizability or no-logarithm claim is made; this does not affect the
   primitive-sixth exclusion.
   Continue with the remaining prime families of genera `7,8,9,10,12` while
   certifying $V_{10}$ separately.
2. Rank four plus self-duality is not enough: it permits four primitive-sixth
   ranks.  The decisive abstraction is an eligible primitive-support
   subquotient of rank at most three, paired by duality.
3. `nu_6>=4` remains only an admission test.  A candidate still needs the
   sectorial Rees extension, Stokes order, polarization, and Gamma/Orlov
   marking required by the operation-framed carrier.
4. Fano classification cannot prove the universal carrier gate.  Weak
   factorization permits arbitrary non-Fano and non-nef threefold centers.
5. On the analytic side, valuation ranges are no longer the right unit of
   work.  The remaining fan should be classified by exponent circuits and
   their logarithmic discriminants.

## Verification

- The Wang source is cached as `arxiv:1910.14440` with SHA-256
  `24c2f43948000a0f3839a347e5f98128e713803237d67944a19f46d8be4fb3af`;
  the shared cache verifies with zero problems.
- The CCGK $V_5$ source tarball has SHA-256
  `fe01aedde30aec17ad6da442b82d9c15ff2c2fc5cdef0c7a6d15e87fa0573143`.
- Van der Put's direct vector-QDM/cyclic-scalar $V_5$ source is cached as
  `arxiv:1501.05205`, SHA-256
  `a60119e4088ccf4625a113b7cc0584a302d731e56d61ae91401f1242ce5646ec`.
- Every tracked C907 star `.sha256` bundle verifies.
- Each of the six Singular generators reproduces its tracked canonical
  output byte-for-byte.

## EJ / TT / mystery ledger

- **EJ:** cyclotomic dominance replaces all weighted-CI scans; two Laurent
  support lemmas replace 186 boundary masks.
- **TT:** ambient well-formedness and the codimension-two singular-locus
  condition are both necessary.  Without the former,
  `X_2 subset P(1,2,2,2,2)` is a smooth-coarse divisorial-inertia
  counterexample to the naive CST step.
- **Settled:** the stated weighted-CI class, $V_5$, ten boundary-star types,
  and the bounded residual intersection.
- **Open analytic:** joint `y`/Rees-infinity and translated/infinity seams,
  common normalized fan, overlap Fitting ideals, and proper product collars.
- **Open carrier:** the remaining non-WCI prime Fanos, then arbitrary
  threefolds; formal support must still be upgraded to operation-framed
  enriched length.
- **Conditional clue:** both certified (V_5) and provisional (V_{10}) have
  zero primitive-sixth support.  This suggests first testing whether the
  non-WCI prime-Fano scan has a stronger all-integral framed-residue law; no
  such theorem is yet licensed.
