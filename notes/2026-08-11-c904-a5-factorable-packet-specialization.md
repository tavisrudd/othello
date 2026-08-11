# C904: the degree-fifteen packet meets the special (A_5) family

Date: 2026-08-11
Status: exact family-specific specialization certificate; no manuscript or
Lean edit
Scope: the sole (A_5)-specific bridge left open in the degree-fifteen
(D_{3,3}) theorem

## Verdict

The finite all-good factorable-quadric packet open **does meet the generic
charge-three component over Roulleau's irreducible (A_5) cubic pencil**.
Thus the qualification left in
`2026-08-11-c904-d33-degree-fifteen-index-equivalence.md` is discharged.
The degree-(15) and degree-(3) relays really give the claimed
(2)-equivalence on the special Paper-V family.

This does not decide the final endpoint: the generic unordered-theta fibre,
and hence the generic charge-three Abel--Jacobi fibre, still has index one or
two.

## 1. Exact special-family point

Use Roulleau's integral basis (A,B) for the irreducible five-dimensional
(A_5)-representation's invariant cubic pencil and take (A+2B).  Over
(mathbf F_5), the search certificate finds an invertible coordinate matrix

\[
G=\begin{pmatrix}
0&4&3&4&3\\3&1&4&0&2\\4&2&1&3&3\\
2&4&4&3&1\\2&4&0&2&3
\end{pmatrix}
\]

and six lifts

\[
q_{ij}=q^H_{ij}+z(a_{ij}+c_{ij}z)
\]

of the fixed null-correlation wedge system such that

\[
q_{01}q_{23}-q_{02}q_{13}+q_{03}q_{12}
   =z\,(A+2B)(Gx).
\]

The search is deterministic (seed `90415`).  It splits the equality by the
power of (z): the constant layer is a rank-(20) linear system in the
twenty-four coefficients of the (a_{ij}), with kernel dimension four; the
next layer has a rank-(6) linear part and four compatibility equations.
It tests exactly (150) invertible projective transforms and (93{,}750)
kernel candidates before reaching the printed point.

The target cubic is projectively smooth and the six quadrics have no common
point on it.  The fixed hyperplane wedge system is also basepoint free, so it
is the ordinary null-correlation presentation, not the excess
\(\operatorname{Pf}=0\) stratum forced on an (A_5)-linearized bundle.

## 2. Why the characteristic-five point proves the characteristic-zero family statement

Let the thirty lift coefficients and twenty-five entries of (G) be
variables.  Equating the thirty-five cubic coefficients in the Pfaffian
identity gives thirty-five equations over (mathbf Z_{(5)}).  Their exact
(35\times55) Jacobian has rank (35) at the displayed point.  Hence the
presentation scheme is smooth over (mathbf Z_{(5)}) there and the point
lifts over an unramified characteristic-zero DVR.

The same full row rank is the family-direction check.  On adjoining the
second (A_5)-pencil parameter, every infinitesimal pencil direction can be
absorbed by the lift and coordinate variables.  The solution space therefore
maps smoothly onto the (A_5) parameter near (A+2B); this is not merely an
isolated good bundle on one special cubic.

Basepoint freeness gives a globally generated rank-two quotient bundle with
determinant ({\cal O}_X(2)).  The null-correlation hyperplane restriction
gives the stability argument recorded in
`2026-08-11-c904-d33-degree15-red-team.md`, Section 5.  The type-((3,3))
sections below have Hilbert polynomial (6t), so the bundle has the required
degree-six second Chern class and lies on the ordinary (M_9) component.

## 3. The whole packet is all-good

For the displayed special point the exact packet ideal is the Pluecker
equation plus the (3\times3) minors of the universal symmetric matrix.  The
certificate proves

\[
 \deg R=15,\qquad R/\mathbf F_5\text{ reduced and etale},\qquad
 R\cap\{\operatorname{rank}\le1\}=\varnothing.
\]

Its six Frobenius orbits have residue degrees

\[
                         1,1,1,4,4,4.
\]

The script constructs one exact residue-field point on every orbit, passes
to the quadratic extension when necessary to split its rank-two quadric, and
tests a section of the associated projective line.  In every case the total
section has Hilbert polynomial (6t), while each hyperplane residual has
Hilbert polynomial (3t+1) and empty projective singular locus.  Each
residual is therefore a smooth connected degree-three genus-zero curve in
its hyperplane, hence a twisted cubic.  The two components meet in length two.

Because the six checks cover every Frobenius orbit, they cover every
geometric packet point.  Finite etaleness, rank-one exclusion, the Hilbert
polynomials, and smoothness are open.  They persist on the characteristic-zero
lift and after shrinking in the (A_5) pencil direction.  This is precisely
the missing assertion that the finite all-good packet open meets the generic
(M_9)-fibre over the special marked family.

## 4. Consequence and exact boundary

Combining this specialization with the already proved general packet and
index lemmas gives, over the marked (A_5) family,

\[
 v_2(\operatorname{ind}V)
 =v_2(\operatorname{ind}D_{3,3})
 =v_2(\operatorname{ind}Y),
\]

and odd correspondences of multiplicities (15) and (3) in the two
directions between smooth proper models of (V) and (Y).  Thus they are
(2)-equivalent.

The certificate does **not** label the fifteen packet points by the fifteen
(A_5) involutions, construct a relative odd point on either endpoint, or
decide index one versus two.  The factorization (1+1+1+4+4+4) is Frobenius
data for this reduction, not an (A_5)-orbit decomposition.

## 5. Replay and trusted boundary

From the repository root:

```bash
C904_A5_TYPE_AUDIT=1 nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("notes/2026-08-11-c904-a5-factorable-packet-search.sage").read()))'
nix shell nixpkgs#macaulay2 -c M2 --script \
  notes/2026-08-11-c904-a5-factorable-packet-replay.m2
```

The Sage certificate owns the deterministic search, presentation Jacobian,
finite-field primary decomposition, residue-field extraction, quadratic
splitting, Hilbert polynomials, and smoothness checks.  The independent
Macaulay2 replay hard-codes the resulting point and separately verifies the
Roulleau-pencilled target identity, target smoothness, wedge basepoint
freeness, packet degree, radicality, rank-one exclusion, and the six component
degrees.  It does not independently repeat the extension-field twisted-cubic
smoothness calculations; those use Sage/Singular, while their geometric
interpretation is the elementary degree-three classification printed above.

The exact output files are stored beside the two scripts.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-08-11-c904-a5-factorable-packet-search.sage` | 14,869 | `8aff4de6dc346ad561e37d166181c5232a5b4670a1ead6cc0b5d55dc69a5c2dc` |
| `2026-08-11-c904-a5-factorable-packet-search.out` | 1,322 | `ef64efcc671b0dc4a6fd126bee699724c07af2c6eb73ba65c4212d05dbf68206` |
| `2026-08-11-c904-a5-factorable-packet-replay.m2` | 2,699 | `d4f2b69d13d38590e0f42df87e1bdc700db875dce4b6e793eac0043fde4cebd6` |
| `2026-08-11-c904-a5-factorable-packet-replay.out` | 210 | `a878c51fa36c0d919e81072e38070b5ac195aaef1e18e5d6254420a5ef8d9bce` |

## EJ / TT closeout and mystery ledger

- **Settled:** the general-cubic all-good open does not disappear on the
  special (A_5) locus.
- **Settled:** the witness is locally versal in every cubic direction, a
  stronger check than mere existence on one member.
- **Settled:** all fifteen geometric packet points are good, not only the
  rational points of the reduction.
- **Explained:** (1+1+1+4+4+4) is arithmetic Frobenius factorization and
  supplies no canonical involution/axis labels.
- **Open and load-bearing:** index one versus two for the generic
  unordered-theta fibre.  This certificate transfers that one obstruction
  exactly to (M_9); it does not solve it.
