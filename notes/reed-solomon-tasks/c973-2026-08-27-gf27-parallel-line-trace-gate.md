# C973 — GF(27) parallel-line trace gate

**Lane:** `reed-solomon`
**Date:** 2026-08-27
**Status:** exact dense-stratum reduction; two trace bits remain
**Scope:** mathematics only; no manuscript, software, Lean, or certificate edit

## 1. Result

The previously isolated affine-plane locator is only the collinear-offset
slice of a substantially larger family.  Fix `K=F_27`, choose
`p=-alpha^2`, and put

\[
 L_p(t)=t^3+pt,
 \qquad W_p=\operatorname {im}L_p=\alpha^3\ker\operatorname {Tr}_{K/F_3}.
                                                                    \tag{1}
\]

For any three distinct offsets `q_1,q_2,q_3 in W_p`, the locator

\[
                         g(t)=\prod_{i=1}^3(L_p(t)+q_i)               \tag{2}
\]

has nine distinct affine roots: it is the union of three parallel affine
`F_3`-lines.  Write

\[
 e_1=q_1+q_2+q_3,
 \qquad e_2=q_1q_2+q_1q_3+q_2q_3,
 \qquad e_3=q_1q_2q_3.                                                \tag{3}
\]

Then the two GF(27) Hankel equations depend only on `(e_1,e_2)`, not on
`e_3`.  On the dense stratum `z_2z_3!=0`, they solve `(e_1,e_2)` rationally
as functions of the 13 possible directions `p`.  Splitness of the three
offsets is exactly two `F_3`-linear conditions: membership `e_1 in W_p` and
one affine-plane condition on `e_2`.  Thus dense GF(27) closure reduces to a
two-trace-bit problem on the norm-minus-one torus, without root enumeration.

## 2. Hankel collapse

Expanding (2) through `X=L_p(t)` gives

\[
\begin{aligned}
g(t)
 &=X^3+e_1X^2+e_2X+e_3\\
 &=t^9+e_1t^6-p e_1t^4+(p^3+e_2)t^3
      +p^2e_1t^2+p e_2t+e_3.                         \tag{4}
\end{aligned}
\]

For a carrier syndrome `z=(z_2,...,z_8)`, the two locator equations are
therefore

\[
\begin{aligned}
 &(pz_2+z_4)e_2+(p^2z_3-pz_5+z_7)e_1+p^3z_4=0,\\
 &z_3e_2+(p^2z_2-pz_4+z_6)e_1+p^3z_3=0.               \tag{5}
\end{aligned}
\]

The disappearance of `e_3` is structural: translating the three offset
roots together changes their product but not the two middle-moment
obstructions relevant to the carrier.

Put

\[
\begin{aligned}
A&=pz_2+z_4,&B&=p^2z_3-pz_5+z_7,\\
D&=z_3,&E&=p^2z_2-pz_4+z_6,\\
N(p)&=Bz_3-AE.                                          \tag{6}
\end{aligned}
\]

If `z_3N(p)!=0`, elimination in (5) gives

\[
 e_1(p)=\frac{p^4z_2z_3}{N(p)},
 \qquad
 e_2(p)=-p^3-\frac{E}{z_3}e_1(p).                      \tag{7}
\]

The cancellation producing the numerator `p^4z_2z_3` is exact:

\[
             -Ap^3+p^3z_4=-p^4z_2.                    \tag{8}
\]

Consequently, on `z_2z_3!=0`, every nonexceptional direction produces
`e_1(p)!=0`; only the two split conditions below remain.  The allowed
directions are the 13 nonsquares

\[
             p=-\alpha^2,qquad N_{K/F_3}(p)=-1.         \tag{9}
\]

On the dense stratum the leading term of `N(p)` is `-z_2^2p^3`, so `N` is
an honest cubic.  At most three of the 13 allowed directions are excluded,
leaving at least ten before the trace tests.  This is the promised one-
dimensional torus gate.

## 3. Exact three-offset split criterion

The following elementary classification removes the remaining unordered
triple.

### Lemma 3.1

Let `W` be a two-dimensional `F_3`-subspace of `K`.  A pair `(e_1,e_2)` is
the first two elementary symmetric functions of three distinct elements of
`W` exactly in one of the following cases.

1. `e_1=0`, and `e_2=-u^2` for one of the four directions
   `[u] in P(W)`.  The triples are the affine lines in `W`.
2. `e_1 in W\setminus{0}`.  Put `U=e_1^{-1}W`, choose any
   `theta in U\setminus F_3`, and require

   \[
                    \frac{e_2}{e_1^2}\in-\theta^2+U.    \tag{10}
   \]

   The coset in (10) is independent of the choice of `theta`.

In the second case, each admissible pair comes from a unique unordered
triple.

### Proof

Translation of a triple by `a in W` leaves `e_1` fixed and sends

\[
                              e_2\longmapsto e_2-ae_1.  \tag{11}
\]

There are 84 triples in `W`.  Exactly the twelve affine lines have sum zero:
each line does, and an ordered count gives twelve triples with `e_1=0`.
Their polynomial is

\[
 \prod_{c\in F_3}(X+a+uc)=(X+a)^3-u^2(X+a),             \tag{12}
\]

so `e_2=-u^2`.

For each fixed nonzero `e_1 in W`, an ordered count gives nine triples.
Translation acts freely on them, hence transitively.  By (11), their nine
`e_2` values form one coset of `e_1W`.  Choose a representative
`{0,a,b}` with `a+b=e_1`.  Then `a,b` are `F_3`-independent.  With
`theta=a/e_1`, one has `U=<1,theta>_{F_3}` and

\[
             \frac{e_2}{e_1^2}=\theta(1-\theta)
                    \equiv-\theta^2\pmod U.             \tag{13}
\]

Replacing `theta` by another element of `U\setminus F_3` does not change
the coset `-theta^2+U`.  Finally, (11) gives nine distinct `e_2` values, so
the triple is unique.  \(\square\)

Equivalently, choose the unique nonzero `F_3`-linear functional `ell_U` on
`K/U` normalized by `ell_U(theta^2)=1`.  Condition (10) is the single trace
bit

\[
                         \ell_U(e_2/e_1^2)=-1.           \tag{14}
\]

Together, `e_1 in W_p` and (14) are exactly the two ternary bits advertised
in Section 1.

## 4. Relation to the affine-plane and code compressions

If `e_1=0`, Lemma 3.1 says that the three offsets themselves form an affine
line in `W_p`.  Their three parallel root lines then form an affine plane in
`K`.  Thus the old plane locator is precisely the zero-sum slice of (2), not
the whole all-parallel family.

There are 84 triples of offsets for each of 13 directions, hence 1092
nine-point supports in (2), compared with only 39 affine planes.  On the
complementary agreement side, these are unions of six of the nine parallel
affine lines.  They give degree-18 root locators and sit naturally inside the
relative-code formulation

\[
                  [27,16,12]\subset[27,23,4].           \tag{15}
\]

This family is large enough to be a plausible saturation family, but size is
not proof of coverage.

## 5. Hostile audit and exact next lemma

The reduction does not close GF(27).

- On `z_2z_3!=0`, equations (7), `e_1(p) in W_p`, and (14) are an exact
  two-trace-bit torus problem.  A structural proof must show that one of the
  at least ten nonexceptional norm-minus-one directions satisfies both
  bits, or replace this family.
- The lower bound ten uses only the exact cubic leading coefficient
  `-z_2^2`; it gives no correlation information between the two trace bits.
- If `z_2=0`, the generic solve forces `e_1=0`, while (5) gives
  `e_2=-p^3`.  Since `p^3` is a nonsquare but Lemma 3.1 requires
  `e_2=-u^2` in the zero-sum case, the generic all-parallel family misses
  this boundary.  It cannot replace the universal two-point switch.
- No assertion that the 1092 supports cover the carrier is justified by
  their count.  The Borel/switch method remains necessary for the boundary
  unless a different family is found.

The highest-value next lemma is therefore:

> **Dense parallel-line lemma.** For every `z` with `z_2z_3!=0`, some
> norm-minus-one `p` with `N(p)!=0` makes (7) satisfy
> `e_1(p) in W_p` and (10).

This is strictly smaller than the earlier cubic-cover tower: it has one
13-point torus parameter and two explicit `F_3`-linear tests.  It is also
strictly weaker than full nucleus saturation, so even a proof must be joined
to the universal switch or a separate boundary argument.
