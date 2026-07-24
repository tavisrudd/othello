# C595 — stable-component Fano elimination

**Lane:** `reed-solomon`
**Date:** 2026-07-24
**Status:** complete at the first unresolved level's non-cyclic input obstruction

## Result

The universal cyclic/wild branch of the recursively pointed bad scheme has
an integral coherent-Fano model.  Its residual after the declared
persistent, modular, and rank/fixed-factor saturations is empty.  The
cleared-denominator integer is
\[
                         N_j=6                                      \tag{1}
\]
for every level \(j\), and \(6\) is the least common integer supported by
this integral presentation.  In particular, the first unresolved
stable-component level, \(j=11\), has no cyclic-type residual component.

The two vertical characteristics in (1) are also closed:

- in characteristic two, the true cyclic plane pulls back to the declared
  nucleus line, while the other vertical component of the primitive
  integral closure lies in the persistent Hankel scheme;
- in characteristic three, the cyclic/wild Fano locus is the rank-one
  boundary, in agreement with the ruling calculation.

This does **not** prove \(\mathrm{SC}(11)\).  The fixed-level R10 results
give arithmetic avoidance and identify the persistent/Lucas candidate
sets, but they do not supply one global integral generator ideal for the
complete non-cyclic recursively pointed bad scheme \(B_{10}\).  Without
that ideal there is no honest remaining saturation or vertical-component
certificate.  C595 therefore stops at the task card's first structural
obstruction.

## 1. Integral universal cyclic carrier

Let \(d=(d_0,\ldots,d_5)\) be a pointed lower syndrome and let
\([x:y]\) be the next contraction parameter.  Put
\[
 c_i=xd_i+yd_{i+1}\qquad(0\leq i\leq4).                    \tag{2}
\]
The sign convention differs from \(d_{i+1}-r d_i\) only by the homogeneous
coordinate \(r=-y/x\).  Thus (2) includes both affine parameters and the
point at infinity.

In the binomially rescaled coordinates used in the R5 cyclic calculation,
eliminating
\[
 [u^2:2uv:v^2+2uw:2vw:w^2]
\]
and taking primitive integral generators gives
\[
\begin{aligned}
q_1={}&2c_3^3-3c_2c_3c_4+c_1c_4^2,\\
q_2={}&6c_2c_3^2-9c_2^2c_4+2c_1c_3c_4+c_0c_4^2,\\
q_3={}&2c_1c_3^2-3c_1c_2c_4+c_0c_3c_4,\\
q_4={}&c_0c_3^2-c_1^2c_4,\\
q_5={}&2c_1^2c_3-3c_0c_2c_3+c_0c_1c_4,\\
q_6={}&6c_1^2c_2-9c_0c_2^2+2c_0c_1c_3+c_0^2c_4,\\
q_7={}&2c_1^3-3c_0c_1c_2+c_0^2c_3.                       \tag{3}
\end{aligned}
\]
Over \(\mathbf Z[1/6]\), (3) is the projected Veronese carrier printed in
the R6 lower package.  Write
\[
 q_i(c(x,y))=\sum_{k=0}^3 F_{i,k}(d)x^{3-k}y^k,\qquad
 \mathfrak F=(F_{i,k}:1\leq i\leq7,\ 0\leq k\leq3).         \tag{4}
\]
Equation (4) is the coherent-Fano ideal: a polar line is contained in the
cyclic carrier exactly when its twenty-eight coefficients vanish.  Since
the parameter is homogeneous, \(F_{i,0}\) and \(F_{i,3}\) are the two
endpoint equations.  No affine chart is omitted.

At redundancy \(j\), retain \(m=j-6\) old markers and write their monic
product as
\[
 T^m-s_1T^{m-1}+\cdots+(-1)^m s_m.
\]
Then
\[
 d_i=\sum_{k=0}^m(-1)^{m-k}s_{m-k}a_{i+k},\qquad s_0=1.    \tag{5}
\]
Substitution of (5) into (4) defines the recursively pointed cyclic Fano
ideal over
\(\mathbf Z[a_0,\ldots,a_{j-1},s_1,\ldots,s_m]\).
It is symmetric in the old markers and is compatible with every base
change.  The ordered-marker diagonals remain separate saturation factors,
as required by the pointed construction.

## 2. Cleared-denominator unit certificate

Let \(H_1,\ldots,H_4\) be the maximal minors, in lexicographic column order,
of
\[
 C_d=
 \begin{pmatrix}
 d_0&d_1&d_2&d_3\\
 d_1&d_2&d_3&d_4\\
 d_2&d_3&d_4&d_5
 \end{pmatrix}.                                             \tag{6}
\]
These generate the lower persistent rank-at-most-two Hankel ideal
\(\mathfrak H\).  Direct integral expansion gives
\[
\begin{aligned}
6H_1={}&-3F_{4,0}-2F_{5,1}+F_{6,2}-6F_{7,3},\\
6H_2={}&-6F_{3,0}+9F_{4,1}+6F_{5,2}-3F_{6,3},\\
6H_3={}&-3F_{2,0}+6F_{3,1}-9F_{4,2}-6F_{5,3},\\
6H_4={}&-6F_{1,0}+F_{2,1}-2F_{3,2}+3F_{4,3}.               \tag{7}
\end{aligned}
\]
The signs in (7) are not obtained by unsigned reversal.  Under
\(d_i\mapsto d_{5-i}\) and \(x\leftrightarrow y\), one has
\[
H_1\leftrightarrow H_4,\qquad H_2\leftrightarrow H_3,\qquad
q_1\leftrightarrow q_7,\quad q_2\leftrightarrow q_6,\quad
q_3\leftrightarrow q_5,\quad q_4\mapsto-q_4.
\]
Thus the magnitudes in the \(H_1/H_4\) and \(H_2/H_3\) pairs are
reversal-symmetric, while exactly the \(F_4\) position changes sign in
each pair.  Direct integral expansion in the checker verifies all four
displayed identities coefficient by coefficient.

Thus \(6\mathfrak H\subset\mathfrak F\).  On
\(\operatorname{Spec}\mathbf Z[1/6]\),
\[
              1\in\mathfrak F:\mathfrak H
              \subset \mathfrak F:\mathfrak H^\infty.      \tag{8}
\]
Geometrically, the cyclic coherent-Fano locus is contained in the lower
persistent locus.  Removing that already declared component leaves the
empty scheme.

The integer in (1) is not an arbitrary common denominator.  In degree
three, ideal membership is integer linear-span membership among the
twenty-eight coefficient cubics.  Modulo both \(2\) and \(3\), \(H_1\) and
\(H_4\) lie outside that span.  Hence any common integer in place of \(6\)
must be divisible by both primes.  The identities (7) prove that \(6\)
suffices.

Because (7) is a polynomial identity in the independent \(d_i\), every
substitution (5) preserves it.  Taking all old markers to zero recovers six
independent consecutive \(a_i\), so the same minimal common denominator
persists in the universal pointed ring.  This proves \(N_j=6\), including
\(N_{11}=6\).

## 3. Saturation order and geometry

The componentwise calculation uses the following order.

1. Keep the projective parameter homogeneous and remove contraction
   indeterminacy/rank-one boundary.  This does not discard either endpoint
   of the polar line.
2. Saturate the cyclic coefficient ideal by the lower persistent ideal
   \(\mathfrak H\).  Equation (8) makes the residual empty over
   \(\mathbf Z[1/6]\).
3. Analyze the vertical fibers \(2\) and \(3\) before applying the modular
   saturation.  This distinguishes a genuine modular component from an
   artifact of the primitive integral closure.
4. Saturate characteristic two by the declared nucleus ideal.  Saturate
   characteristic three by the fixed-factor/rank boundary.
5. The fixed-factor, marker-diagonal, and collision saturations are then
   vacuous on this branch: the residual is already empty.  They remain
   necessary for the other branches of the complete recursively pointed
   bad scheme and have not been silently removed from its definition.

This order avoids two common errors.  Saturating by \(2\) at the outset
would erase the genuine binary nucleus, while treating the primitive
specialization of (3) as the true binary carrier would retain a spurious
vertical component.

## 4. R6 and R7 regression

### R6

Over \(\mathbf Q\), the coefficient ideal \(\mathfrak F\) has one minimal
prime: the ten \(2\times2\) Hankel minors defining the rank-one rational
normal curve.  This is contained in the persistent scheme, so the saturated
residual is empty, exactly as Proposition 6.4 and the exhaustive R6
contained-component classification require.

Modulo \(2\), the primitive integral fiber has two minimal components:
\[
\begin{aligned}
\mathfrak m_2&=(d_0,d_1,d_4,d_5),\\
\mathfrak q_2&=(d_3d_4+d_2d_5,\ d_1d_4+d_0d_5,\
d_3^2+d_1d_5,\ d_2d_3+d_0d_5,\\
&\hspace{34mm}d_2^2+d_0d_4,\ d_1d_2+d_0d_3).
\end{aligned}                                               \tag{9}
\]
The first is the direct Fano pullback of the true binary cyclic plane
\(c_0=c_4=0\), hence the declared nucleus line
\(\mathbf P\langle e_2,e_3\rangle\).  All four minors (6) vanish modulo
\(\mathfrak q_2\), so the second component is already persistent.  There
is no binary residual after the two saturations.

Modulo \(3\), \(\mathfrak F\) again has only the rank-one minimal prime.
This is the scheme counterpart of the R6 wild-cone statement: a contained
line is a ruling, and the consecutive-Hankel condition forces the
rank/fixed-factor boundary.  Modulo \(5\), the generic rank-one answer is
restored.

### R7

For a degree-six syndrome, coefficient expansion of every lower
\(3\times3\) Hankel minor gives an ideal \(J_6\).  Exact Gröbner comparison
returns
\[
                            J_6=I_6                         \tag{10}
\]
over \(\mathbf Z\), where \(I_6\) is the upper rank-at-most-two Hankel
ideal.  This is the R7 persistent regression and independently reuses the
integral identity proved in C536.

In characteristic two, placing both consecutive contractions in
\(\mathbf P\langle e_2,e_3\rangle\) gives
\[
                 a_0=a_1=a_2=a_4=a_5=a_6=0,               \tag{11}
\]
so only the central point \(e_3\) remains.  Equations (10)--(11), together
with the R7 separable collision lemma, reproduce the printed exhaustive
R7 contained list.  The homogeneous coefficient extraction includes the
infinity chart at both levels.

## 5. First unresolved application: redundancy eleven

For \(j=11\), equation (5) becomes
\[
d_i=a_{i+5}-s_1a_{i+4}+s_2a_{i+3}-s_3a_{i+2}
       +s_4a_{i+1}-s_5a_i.                                 \tag{12}
\]
Substituting (12) into (7) proves that the six-marker cyclic branch is
contained in the pulled-back persistent branch over
\(\mathbf Z[1/6]\).  The characteristic-two and characteristic-three
fibers specialize exactly as in Section 4 and are removed by the declared
modular and rank/fixed-factor ideals.  Therefore the R11 cyclic-type
residual is empty.

The full \(\mathrm{SC}(11)\) elimination stops here.  C513 and C516 close
the R8 and R9 fixed-level contained calculations; C532 closes the R10
high-field arithmetic synthesis and confines binary candidates to the
Lucas carrier.  Those reports do not package the complete R10
recursively pointed bad scheme—generic degeneracy, fixed-factor,
ordered-Hessian, and collision charts with their auxiliary variables—as
one integral ideal with proved chart gluing and saturation equivalence.
An arithmetic statement that every rational point above a threshold is
shallow cannot replace that missing scheme.  Constructing it would be a
new task, not a denominator calculation inside C595.

## 6. Reproducibility and trust boundary

The evidence bundle is:

- `notes/2026-07-24-c595-stable-component-fano-elimination.py`;
- `notes/2026-07-24-c595-stable-component-fano-elimination.sing`;
- `notes/2026-07-24-c595-stable-component-fano-elimination.json`;
- `notes/2026-07-24-c595-stable-component-fano-elimination.sha256`.

Replay from the repository root:

```sh
python3 notes/2026-07-24-c595-stable-component-fano-elimination.py --check
nix-shell -p singular --run \
  "Singular -q notes/2026-07-24-c595-stable-component-fano-elimination.sing"
```

The Python checker has no third-party dependency.  It reconstructs all
integral polynomials, checks (7) term by term, proves the mod-\(2\) and
mod-\(3\) denominator obstructions by exact linear algebra, and exhausts
all projective points of \(\mathbf P^5(\mathbf F_p)\) for
\(p=2,3,5\).  The corresponding cyclic-Fano/persistent counts are
\[
\begin{array}{c|ccc}
p&2&3&5\\\hline
\#V(\mathfrak F)(\mathbf F_p)&12&4&6\\
\#V(\mathfrak H)(\mathbf F_p)&15&40&156
\end{array}
\]
and no cyclic-Fano point lies outside the persistent or declared modular
locus.

Singular 4.4.1 supplies the scheme-theoretic cross-check: the generic and
small-characteristic minimal primes, containment of \(\mathfrak q_2\) in
\(\mathfrak H\), and the exact R7 ideal equality (10).  The finite-field
enumeration independently checks rational point sets, not nilpotent or
embedded scheme structure.  The Singular minimal-prime computation remains
the trusted boundary for those scheme assertions.

The checksum manifest records the exact Python source, Singular source, and
canonical JSON certificate with byte-stable serialization.  `--check`
reconstructs the JSON in memory and verifies every recorded hash without
modifying the worktree.

## 7. Paper recommendation

The cyclic exclusion is theorem-grade and should be retained for a future
companion treatment of stable components: the four identities (7) replace
all level-by-level cyclic Fano calculations and isolate the only vertical
primes.  It does not justify a standalone companion paper or a change to
the frozen C545 submission.  A paper-level stable-component theorem becomes
plausible only after the non-cyclic integral bad scheme and its saturation
equivalence are constructed.

## Mystery ledger

| Feature | Status | Evidence or remaining gate |
|---|---|---|
| Whether the cyclic branch requires a carrier-point classification | settled | The coefficient identities (7) place the whole coherent-Fano scheme inside the persistent branch after inverting \(6\). |
| Whether the denominator depends on the redundancy or retained markers | settled | The identities are polynomial in six independent contracted coordinates and survive every marker substitution (5); \(N_j=6\) uniformly. |
| Whether \(6\) is only an artifact of one Gröbner lift | settled | \(H_1,H_4\) lie outside the coefficient span modulo both \(2\) and \(3\), while (7) supplies multiplier \(6\). |
| What happens in characteristic two | settled | Minimal-prime decomposition gives the true modular nucleus plus a vertical component contained in the persistent ideal. |
| What happens in characteristic three | settled | The only minimal prime is rank one, matching the wild-ruling/fixed-factor argument. |
| Whether \(\mathrm{SC}(11)\) now follows | open | The complete non-cyclic R10 recursively pointed bad scheme has no global integral generator ideal or proved chartwise saturation equivalence. |
| Whether C545 should be reopened | settled negatively | C595 proves a companion cyclic-branch lemma, not the full stable-component assertion; the frozen R5--R7 manuscript is unchanged. |

## Closeout assessment

The `ej`+`tt` pass upgraded a level-specific denominator calculation to the
uniform identity (7), proved that \(6\) is minimal, and separated the
genuine binary nucleus from the primitive closure's persistent vertical
component.  No further cheap saturation remains: the next step needs a new
integral construction for the complete non-cyclic R10 bad scheme.
