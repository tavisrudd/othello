# C531 — degree-nine Lucas-carrier \(PGL_2\) strata

**Lane:** `reed-solomon` · **Date:** 2026-07-24 · **Status:** complete at the prescribed
nonconstant-cover/positive-moduli obstruction boundary

## Result

Work in characteristic two in the degree-nine Lucas carrier
\[
 \mathcal M_9=\mathbf P\langle e_2,e_3,e_4,e_5,e_6,e_7\rangle .
                                                               \tag{1}
\]
It has an intrinsic four-dimensional invariant block
\[
 U=\langle e_2,e_3,e_6,e_7\rangle
   \simeq \det^2\otimes(E^{(4)}\otimes E)                       \tag{2}
\]
and standard two-dimensional quotient
\[
 \mathcal M_9/U\simeq \det^4\otimes E.                         \tag{3}
\]
Writing a point of \(U\) as a \(2\times2\) matrix \(A\), the exact action is
\[
 A\longmapsto \det(g)^2 g^{(4)}Ag^{\mathsf T}.                 \tag{4}
\]
Consequently \(\mathbf P(U)\) has exactly three geometric \(PGL_2\)-orbits:

| stratum | dimension | representative | geometric stabilizer |
|---|---:|---|---|
| Frobenius graph \(C=\{[u^{(4)}\otimes u]\}\) | 1 | \(e_7\) | a Borel |
| rank-one quadric minus \(C\) | 2 | \(e_3\) | a split torus |
| rank two | 3 | \(e_3+e_6\) | \(PGL_2(\mathbf F_4)\cong A_5\) |

Their closures are
\[
 C\subset\{\det A=0\}\subset\mathbf P(U).                     \tag{5}
\]
This is the complete zero-moduli carrier stratification.  It is not an ambient
\(\mathbf P^5\) census.

The two rank-one strata are shallow over every
\(\mathbf F_{2^m}\), \(m\ge3\).  The graph case is C530's transported
three-space subspace-polynomial witness.  On the off-graph representative
\(e_3\), inversion of the seven nonzero points of any three-dimensional
\(\mathbf F_2\)-subspace gives a new uniform split squarefree witness.

The rank-two stratum has a genuinely new arithmetic layer.  After choosing six
roots, the final pair is the geometrically integral Artin--Schreier cover
\[
 y^2+y=\frac{N_p\Delta}{N_s^2};                              \tag{6}
\]
the right side is a nonconstant class.  Rational lifting is exactly its
absolute-trace-zero condition.  Thus the finite \(A_5\)-twist label does not
classify deepness: one must solve a rational-point problem on a nonconstant
cover of the six-root configuration space.  This fires C531's explicit
extra-monodromy stop.

There is one exact small-field warning.  The complete nine-divisor scan in
\(\mathbf P^1(\mathbf F_8)\) finds one split-free rank-two orbit, of size \(168\)
and stabilizer \(3\).  It is the \((2)(3)\)-twisted class.  This is outside the
admissible full-length redundancy-ten range.  Every rational carrier orbit at
\(q=16\) and \(q=32\) has a certified split witness, but these bounded controls
are not promoted to an all-field theorem.

Finally, \(\mathbf P(\mathcal M_9)\setminus\mathbf P(U)\) has dimension five,
while \(PGL_2\) has dimension three.  Its geometric quotient is therefore
genuinely two-dimensional.  No finite list of further carrier orbits exists.
This independently fires the task's positive-moduli stop before the generic
quotient.

## 1. The invariant filtration

Use the divided-power basis \(e_0,\ldots,e_9\), dual to the ordinary binary
monomials.  Let an inverse change of variables be represented by
\[
 g=\begin{pmatrix}a&b\\c&d\end{pmatrix},
 \qquad \delta=ad+bc.
\]
Lucas expansion of the six carrier basis vectors shows that the target support
of \(e_2,e_3,e_6,e_7\) is again \(\{2,3,6,7\}\).  Under
\[
 e_2,e_3,e_6,e_7
 \longleftrightarrow
 E_{00},E_{01},E_{10},E_{11},                               \tag{7}
\]
the four columns are exactly the coefficients of
\(\delta^2g^{(4)}Ag^{\mathsf T}\).  For example,
\[
 ge_7=\delta^2
 \left(b^5e_2+b^4d\,e_3+bd^4e_6+d^5e_7\right),              \tag{8}
\]
recovering C530, while \(ge_2\) is the same expression with the first column
\((a,c)\).

Modulo \(U\), the remaining columns are
\[
\begin{aligned}
 ge_4&=\delta^4(ae_4+ce_5),\\
 ge_5&=\delta^4(be_4+de_5).
\end{aligned}                                               \tag{9}
\]
Equations (8)--(9) prove (2)--(4) over the base scheme; they are not merely
pointwise finite-field identities.

## 2. Geometric and rational orbit classification

A rank-one matrix has a unique factorization
\[
 A=u^{(4)}v^{\mathsf T}
\]
up to inverse scalar changes.  The condition \([u]=[v]\) cuts out the
Frobenius graph \(C\).  \(PGL_2\) is transitive on the graph and on ordered
distinct pairs of projective points.  Their stabilizers are respectively a
Borel and a split torus.  This proves the first two rows of the table and the
first closure in (5).

For rank two take
\[
 J=\begin{pmatrix}0&1\\1&0\end{pmatrix}
 \longleftrightarrow e_3+e_6.
\]
The stabilizer equation is
\[
 g^{(4)}Jg^{\mathsf T}\sim J.
\]
Since \(Jg^{\mathsf T}J=\operatorname{adj}(g)\) in characteristic two, this is
equivalent projectively to \(g^{(4)}\sim g\).  Hence the geometric stabilizer
is \(PGL_2(\mathbf F_4)\), of order \(60\).  The orbit has dimension three and
is open in \(\mathbf P(U)\), proving the remaining row and closure in (5).

Let \(k=\mathbf F_{2^m}\).  Lang's theorem gives
\[
 PGL_2(k)\backslash O_{\mathrm{rk}\,2}(k)
 \simeq H^1(k,PGL_2(\mathbf F_4)).                           \tag{10}
\]
If \(m\) is even, Frobenius acts trivially on \(A_5\), so the five rational
orbits correspond to
\[
 1A,\quad2A,\quad3A,\quad5A,\quad5B
\]
with stabilizer orders
\[
 60,\quad4,\quad3,\quad5,\quad5.                            \tag{11}
\]
If \(m\) is odd, Frobenius restricts to the field involution of
\(\mathbf F_4\).  Twisted conjugacy becomes conjugacy in the odd coset of
\[
 P\Gamma L_2(\mathbf F_4)\cong S_5.
\]
The three types are a transposition, a \(4\)-cycle, and a product
\((2)(3)\), with \(A_5\)-centralizer orders
\[
 6,\quad2,\quad3.                                           \tag{12}
\]
An orbit has size \(q(q^2-1)/|C|\) for the corresponding centralizer \(C\).

Coefficientwise Frobenius supplies the semilinear transport.  In the even case
its outer automorphism fixes \(1A,2A,3A\) and exchanges \(5A,5B\).  In the odd
case it preserves each of the three odd \(S_5\)-cycle types.  Thus the exact
\(P\Gamma L_2\) fusion is already visible from (11)--(12).

## 3. Uniform arithmetic on the rank-one strata

For the Frobenius graph, C530 proves that every representative has a split
squarefree member over every \(k=\mathbf F_{2^m}\), \(m\ge3\).  The witness is
the subspace polynomial of a three-dimensional \(\mathbf F_2\)-subspace, and
projective transport proves the full-orbit statement.

For the off-graph orbit use the representative \(e_3\).  Its two Hankel
equations are
\[
 b_2=b_3=0                                                   \tag{13}
\]
for \(g(t)=\sum_{i=0}^8 b_it^i\).  Choose any three-dimensional
\(\mathbf F_2\)-subspace \(V\subset k\), and write
\[
 L_V(x)=x^8+A_4x^4+A_2x^2+A_1x,\qquad A_1\ne0.              \tag{14}
\]
The divisor
\[
 R_V=\{0\}\cup\{v^{-1}:0\ne v\in V\}
\]
has polynomial
\[
 g_V(t)=A_1^{-1}
 \left(t+A_4t^5+A_2t^7+A_1t^8\right).                      \tag{15}
\]
Indeed, (15) is the reciprocal of \(L_V(x)/x\), with the additional root
\(0\).  It has eight distinct \(k\)-rational roots and satisfies (13).
Therefore every off-graph rank-one point is shallow for every admissible
field.  This construction is distinct from C530's additive-affine witness:
it is its reciprocal seven-point divisor with a new zero root.

## 4. The rank-two Artin--Schreier obstruction

At \(J=e_3+e_6\), the kernel equations are
\[
 b_2+b_5=0,\qquad b_3+b_6=0.                               \tag{16}
\]
Choose six ordered roots with monic polynomial
\[
 h(t)=\sum_{i=0}^6h_it^i,\qquad h_6=1,
\]
and let the final pair have sum \(s\) and product \(p\).  Multiplication by
\(t^2+st+p\) turns (16) into
\[
\begin{aligned}
 A_0+sA_1+pA_2&=0,\\
 A_1+sA_2+pA_3&=0,
\end{aligned}                                               \tag{17}
\]
where
\[
 A_0=h_0+h_3,\quad A_1=h_1+h_4,\quad
 A_2=h_2+h_5,\quad A_3=h_3+1.                              \tag{18}
\]
On the principal open
\[
 \Delta=A_1A_3+A_2^2\ne0,
\]
the unique final-pair coefficients are
\[
 s=\frac{N_s}{\Delta},\qquad
 p=\frac{N_p}{\Delta},                                     \tag{19}
\]
with
\[
 N_s=A_0A_3+A_1A_2,\qquad
 N_p=A_1^2+A_0A_2.                                         \tag{20}
\]
The pair is distinct when \(N_s\ne0\).  Putting \(y=u/s\) gives (6), and the
two last roots are rational over \(k\) exactly when
\[
 \operatorname {Tr}_{k/\mathbf F_2}
 \left(\frac{N_p\Delta}{N_s^2}\right)=0.                   \tag{21}
\]

The four quantities \(A_0,\ldots,A_3\) are algebraically independent on the
six-root coefficient space: (18) is a rank-four linear projection from
\((h_0,\ldots,h_5)\).  Along \(N_s=0\), on \(A_3\ne0\),
\[
 A_0=\frac{A_1A_2}{A_3},\qquad
 N_p\Delta=\Delta^2\frac{A_1}{A_3}.                         \tag{22}
\]
The leading coefficient \(A_1/A_3\) is not a square in the residue function
field.  An Artin--Schreier coboundary with a double pole would have square
leading coefficient.  Thus (6) remains nontrivial after algebraic extension
of the constants: it is geometrically integral with exact deck group \(C_2\).

The deleted boundary is explicit: the first six roots must be distinct,
\(\Delta N_s\ne0\), and
\[
 \prod_{h(r)=0}(r^2+sr+p)\ne0                              \tag{23}
\]
keeps the last pair away from them.  The reciprocal chart accounts for
infinity.  Nothing in (6) silently treats a collision as a split member.

Equations (17)--(23) are the exact obstruction boundary.  The \(A_5\)-cocycle
classifies the rational syndrome orbit, but (21) is an additional nonconstant
cover over root configurations.  A uniform rank-two shallowness theorem would
need a rational-point/avoidance argument for this cover; finite stabilizer
classes alone cannot supply one.  C531 stops here as required.

## 5. Bounded controls

The exact certificate independently enumerates \(\mathbf P(U)(\mathbf F_q)\)
under three generators of \(PGL_2(\mathbf F_q)\) for
\[
 q=8,16,32.
\]
It obtains:

| \(q\) | graph sizes | off-graph sizes | rank-two orbit sizes |
|---:|---|---|---|
| 8 | \(9\) | \(72\) | \(84,168,252\) |
| 16 | \(17\) | \(272\) | \(68,816,816,1020,1360\) |
| 32 | \(33\) | \(1056\) | \(5456,10912,16368\) |

These equal the hand-derived centralizer formulas (11)--(12).  The complete
\(q=8\) scan checks all nine eight-point divisors of
\(\mathbf P^1(\mathbf F_8)\).  Exactly the rank-two orbit of size \(168\),
stabilizer \(3\), is split-free.  Deterministic explicit divisors certify a
split squarefree member for every \(\mathbf P(U)\)-orbit at \(q=16\) and
\(q=32\).

The computations certify the displayed bounded orbit decompositions, every
recorded witness, and the complete \(q=8\) negative.  They do not prove
rank-two shallowness for any untested field; that gap is exactly the
nonconstant cover (6).

## 6. Coding and successor boundary

A split squarefree degree-eight member of \(W_v\) is exactly the PRS
shallowness witness used throughout C491--C530.  Thus §§3--5 have coding
semantics, not only binary-form semantics.  The \(q=8\) exception lies outside
the full-length redundancy-ten range; the first admissible characteristic-two
field is \(q=16\).

C531 supplies C532 with an honest carrier theorem boundary:

- both rank-one carrier strata are uniformly shallow;
- the rank-two carrier is a finite \(A_5\)-twist list plus the explicit
  nonconstant Artin--Schreier root cover (6);
- the complement of \(\mathbf P(U)\) has a two-dimensional quotient and is
  not finitely classifiable by orbit normal forms.

C532 may derive a redundancy-ten statement only with this rank-two cover and
positive-moduli residue visible.  It may not infer deepness from containment
or replace either boundary by an ambient \(\mathbf P^9\) census.

## Evidence and replay

The atomic evidence bundle is:

- `notes/2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.py`;
- `notes/2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.json`;
- `notes/2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata-replay.py`;
  and
- `notes/2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.sha256`.

From the repository root:

```text
python3 notes/2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.py \
  --check notes/2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.json
python3 notes/2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata-replay.py
(cd notes && sha256sum -c 2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.sha256)
```

The generator uses exact Lucas/binomial polynomial identities, deterministic
finite-field arithmetic, orbit closure under explicit \(PGL_2\) generators,
and canonical root-divisor witnesses.  Its only negative is the complete
nine-divisor \(q=8\) domain.  The replay shares no generator code: it rebuilds
every polynomial from its roots, checks the two Hankel equations, repeats the
complete \(q=8\) negative, verifies the centralizer orbit-size formulas, and
checks reciprocal subspace witnesses.

## Extra-juice and Tao closeout

The closeout changes the carrier picture in four useful ways:

- The six-dimensional carrier is not representation-theoretically
  featureless: (2)--(3) isolate the complete finite-orbit block and prove that
  the remaining quotient has two moduli.
- C530's Borel orbit is only the Frobenius-graph boundary of a rank-one
  quadric.  The entire other rank-one orbit is also uniformly shallow by the
  cheap reciprocal construction (15).
- The first genuinely new arithmetic is not another constant-field cycle.
  It is the nonconstant Artin--Schreier class (6), sitting over an
  \(A_5\)-twisted rank-two syndrome.
- The \(q=8\) split-free twist shows that this cover can obstruct rational
  splitting, while the complete \(q=16,32\) witness tables show that the
  obstruction is not automatically persistent into the coding range.

The highest-value next mathematical move is therefore not a generic invariant
ring computation on the two-dimensional quotient.  It is C532's bounded
synthesis using the exact residue above: determine how much of redundancy ten
is already unconditional from transverse induction, and expose the rank-two
Artin--Schreier clause rather than hiding it.

## Mystery ledger

Settled:

- **What is the intrinsic structure of the carrier?**  The filtration
  (2)--(3), with exact tensor action (4).
- **What are the finite geometric strata?**  Exactly the graph, off-graph
  rank-one orbit, and rank-two \(A_5\)-stabilized orbit in \(\mathbf P(U)\).
- **How do rank-two rational orbits split?**  Five classes for even \(m\), three
  twisted classes for odd \(m\), with exact centralizers and semilinear fusion.
- **Is the second rank-one orbit arithmetically dangerous?**  No; (15) makes it
  shallow over every admissible field.
- **Does the rank-two cover reduce to its finite stabilizer twist?**  No; (6)
  is a geometrically integral nonconstant \(C_2\)-cover.
- **Is there a concrete obstruction value?**  Yes; the complete \(q=8\)
  \((2)(3)\)-twisted orbit is split-free.

Open, with exact boundary:

- **Are all rank-two twists shallow over every admissible field?**  The answer
  is positive at \(q=16,32\), but no all-field theorem is proved.  The missing
  input is rational avoidance on (6), owned by the visible C532 residue or a
  later bounded cover task.
- **What happens on the two-dimensional generic carrier quotient?**  C531's
  stop rule forbids pretending it is a finite orbit list.  C532 must retain it
  as an intrinsic positive-moduli residue unless its fixed-level induction
  avoids it.

No other genuine mystery remains inside C531's authorized finite-stratum
scope.

## Literature boundary

C531 makes no new priority claim.  It imports C529/C530's coding dictionary
and distinguished-orbit theorem, then proves the representation filtration,
orbit and cocycle classification, reciprocal witness, and rank-two cover
directly.  No manuscript prose, ambient syndrome census, or generic
positive-moduli classification is opened.
