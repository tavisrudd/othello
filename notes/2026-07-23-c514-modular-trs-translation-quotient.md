# C514 — modular one-twist translation quotient

**Date:** 2026-07-23  
**Lane:** `reed-solomon`  
**Verdict:** translation quotient complete; universal C512 recursion obstructed

## Result

Let \(q=p^m\), let \(p\mid k\), put \(s=q-k\), and normalize the nonzero twist to
\(\theta=1\).  Since \(p\mid q\), also \(p\mid s\).  Write
\[
 h(t)=[1:t:\cdots:t^{s-2}:t^{s-1}-t^s]\in {\bf P}(M),\qquad
 M=\operatorname{Sym}^s(E)/\langle z\rangle ,
 \quad z=e_{s-1}+e_s .
\]
C510's translations \(A_bh(t)=h(t+b)\) fix \(z\) and act on \(M\).

For an ordered support \(T=(t_1,\ldots,t_{s-1})\), put
\[
 P_T(X)=\prod_{t\in T}(X-t),\qquad
 r(T)=1-\sum_{t\in T}t.
\]
Then, up to the fixed sign coming from the chosen column order,
\[
 \det(h(t_1),\ldots,h(t_{s-1}),y)
 =\Delta(T)\,\langle y,\;P_T(X)(X-r(T))\rangle .                 \tag{1}
\]
This is the requested determinant normal form.  Its extra root is canonical, not chosen:
\[
 \sum_{t\in T}t+r(T)=1.
\]
Because \(s=0\) in the field,
\[
 r(T+b)=r(T)+b.
\]
Translate the completion root to zero and set
\[
 U=T-r(T)=\{u_1,\ldots,u_{s-1}\}.
\]
Then
\[
 \sum_i u_i=1,\qquad
 Q_U(X)=\prod_i(X-u_i)
       =X^{s-1}-X^{s-2}+c_2X^{s-3}+\cdots+c_{s-1}.              \tag{2}
\]
The coefficients \(c_2,\ldots,c_{s-1}\), together with the nonzero discriminant of \(Q_U\),
are explicit coordinates on the unordered translation quotient.  If
\(y_r=A_{-r(T)}y\), (1) becomes
\[
 \det(h(t_1),\ldots,h(t_{s-1}),y)
 =\Delta(U)\,\langle y_r,\;XQ_U(X)\rangle                       \tag{3}
\]
up to the same fixed sign.  Equations (2)--(3) reduce every support test from an affine
\((s-1)\)-set to a distinct \((s-1)\)-set \(U\) of sum one.  No field census is involved.

The common fixed space has no hidden connecting correction.  If
\[
 J_s=\{j\in\{0,\ldots,s\}:j\text{ is maximal for the Lucas order }
 \preceq_p\},
\]
then
\[
 M^{(\mathbb F_q,+)}
 =\langle\bar e_j:j\in J_s\rangle
 =\langle e_j:j\in J_s\rangle/\langle e_{s-1}+e_s\rangle ,
 \qquad
 \dim M^{(\mathbb F_q,+)}=|J_s|-1.                              \tag{4}
\]
In particular, \(\bar e_{s-1}=-\bar e_s\) is the standard fixed syndrome direction.
Every additional fixed direction is exactly a visible Lucas-maximal direction already present
before projection.  The connecting map
\[
 M^{(\mathbb F_q,+)}\longrightarrow
 H^1((\mathbb F_q,+),\langle z\rangle)
\]
is zero.

The quotient does **not** give a universal pointed contraction in the C512 hierarchy.  There
are two exact obstructions.

1. The codimension-two splitting system attached to \(y\) has annihilator
   \(\langle z,\tilde y\rangle\subset\Gamma^sE\).  It is a C512 first-polar line only when it
   satisfies the consecutive-row compatibility in (8) below.  Generic syndromes do not.
2. The canonical completion root is allowed to collide with a support point.  In the slice this
   is \(0\in U\).  Such a \(U\) is a valid support in (3), whereas C512's pointed lifting identity
   requires the marker not to divide the lower split member.  Removing this diagonal would delete
   genuine support hyperplanes.

Thus C514 closes with an invariant quotient and a precise obstruction, rather than a recursive
deep-hole classification.  The result neither asserts standard-only completeness nor opens an
ambient syndrome census.

## 1. Determinant factorization

A hyperplane of \(M\) is represented by a polynomial
\[
 f(X)=a_0+a_1X+\cdots+a_sX^s
\]
annihilating \(z\), so \(a_{s-1}+a_s=0\).  The hyperplane through the \(s-1\)
distinct curve points indexed by \(T\) has a polynomial of the form
\[
 f_T(X)=P_T(X)(AX+B).
\]
The top two coefficients are
\[
 a_s=A,\qquad a_{s-1}=B-A\sum_{t\in T}t.
\]
The condition \(a_{s-1}+a_s=0\) forces
\(B=A(\sum T-1)\).  Taking \(A=1\) gives
\[
 f_T(X)=P_T(X)(X-r(T)).
\]
The usual alternant expansion contributes the Vandermonde \(\Delta(T)\), proving (1).

Translation sends \(f_T(X)\) to \(f_T(X-b)\), preserves the Vandermonde, and sends the extra
root \(r\) to \(r+b\).  Moreover,
\[
 \sum_{t\in T}(t-r)
 =\sum T-(s-1)r
 =\sum T+r=1,
\]
because \(s-1=-1\) in the field.  This proves (2)--(3).

Conversely, if \(U\subset\mathbb F_q\) has \(s-1\) distinct elements and sum one, every
\(r\in\mathbb F_q\) gives
\[
 T=r+U,\qquad r(T)=r.
\]
Hence \(U\) parametrizes one complete translation orbit, and every orbit occurs once.  This is
an equivalence of the pointed support action groupoid with the slice \(r=0\), not merely a map
of orbit sets.  The completion point makes the translation action on pointed supports free.
In fact the support action itself is already free: if \(T+b=T\), then comparison of sums gives
\[
 \sum T=\sum(T+b)=\sum T+(s-1)b=\sum T-b,
\]
so \(b=0\).  Thus no support stabilizer is hidden even before adjoining the completion root.
Frobenius sends
\[
 (U,r,y_r)\longmapsto(U^p,r^p,y_r^{(p)})
\]
and preserves \(\sum U=1\).  Syndrome-only translation stabilizers are retained as the
equalities \([A_{-r-b}A_b y]=[A_{-r}y]\) between slice representatives; none is silently
divided out.

## 2. Exact fixed flag and vanishing connecting class

In the degree-\(s\) module \(V=\langle e_0,\ldots,e_s\rangle\),
\[
 A_be_j=\sum_{i=j}^s {i\choose j}b^{i-j}e_i.                    \tag{5}
\]
Because \(s<q\), the functions \(1,b,\ldots,b^s\) on \(\mathbb F_q\) are linearly
independent.  Lucas's theorem applied to (5) gives
\[
 V^{(\mathbb F_q,+)}=\langle e_j:j\in J_s\rangle.               \tag{6}
\]
Since \(p\mid s\), both \(s-1\) and \(s\) are Lucas-maximal, and \(z=e_{s-1}+e_s\)
is fixed.

It remains to rule out a quotient-fixed vector with nonzero connecting cocycle.  Write
\(v=\sum c_je_j\) and suppose
\[
 (A_b-1)v=\lambda(b)(e_{s-1}+e_s)\quad\text{for every }b.       \tag{7}
\]
For each \(i\le s-2\), comparison of the \(e_i\)-coefficient and independence of the powers
of \(b\) gives
\[
 c_j{i\choose j}=0\qquad(0\le j<i\le s-2).
\]
Comparison of the last two coefficients gives
\[
 \sum_{j\le s-2}c_j{s-1\choose j}b^{s-1-j}
 =
 \sum_{j\le s-2}c_j{s\choose j}b^{s-j}.
\]
The same power comparison, followed by Lucas digit comparison at the last digit where
\(j\) differs from \(s-1\) or \(s\), says precisely that a surviving \(j\le s-2\)
is maximal in the full interval \(\{0,\ldots,s\}\).  Thus \(v\) differs modulo
\(\langle z\rangle\) from a vector in (6), and then (7) has \(\lambda=0\).
This proves (4) and the vanishing connecting class.

For example, at \(p=3,s=6\), \(J_s=\{5,6\}\), so only the standard line remains, agreeing
with C510's \(q=9,k=3\) calibration.  At \(p=3,s=12\),
\(J_s=\{8,11,12\}\), so the quotient fixed space has the standard line and the additional
class \(\bar e_8\), with no further invariant created by projection.

## 3. Exact C512 obstruction

Let \(\tilde y=(y_0,\ldots,y_s)\) be any lift of \(y\) to \(\Gamma^sE\).
The support members tested by \(y\) form the codimension-two system whose annihilator is
\(\langle z,\tilde y\rangle\).  A line in \({\bf P}(\Gamma^sE)\) is a C512 first-polar
line exactly when it has a basis
\[
 (a_0,\ldots,a_s),\qquad(a_1,\ldots,a_{s+1}).
\]
Consequently \(\langle z,\tilde y\rangle\) is polar exactly when there are
\(\alpha,\beta,\gamma,\delta\), with
\(\alpha\delta-\beta\gamma\ne0\), such that
\[
 \gamma z_i+\delta y_i
 =\alpha z_{i+1}+\beta y_{i+1},
 \qquad 0\le i<s.                                               \tag{8}
\]
Equivalently, the \(s\times4\) matrix
\[
 K(y)_i=(z_i,\ y_i,\ -z_{i+1},\ -y_{i+1})                       \tag{9}
\]
must have in its kernel a vector \((\gamma,\delta,\alpha,\beta)\) whose associated
\(2\times2\) matrix is invertible.  Equations (8)--(9) are invariant under changing the lift
of \(y\), changing the basis of \(\langle z,\tilde y\rangle\), and the surviving
\(PGL_2\) action; they are the precise polar-compatibility test.

This condition is not automatic.  For \(s\ge4\), the syndrome lift
\(\tilde y=e_0+e_2\) makes \(K(y)\) have rank four: the rows at \(0,1,s-2,s-1\)
successively detect the four columns (with the evident combined row when \(s=4\)).
Hence no universal map from the modular TRS syndrome space to C512 polar lines exists.
For \(s=3\), (8) remains the exact compatibility criterion, but the second obstruction below
still prevents an equivalence of avoidance problems.

Indeed, \(r(T)\) may equal an element of \(T\).  After slicing, \(U\) is still a distinct
\((s-1)\)-set, but it contains zero, and
\[
 XQ_U(X)
\]
has a repeated zero.  This determinant is nevertheless the hyperplane of the valid distinct
support \(T\).  C512's pointed identity instead lifts a lower squarefree member only on the
complement of the incidence divisor “marker divides the lower member.”  Here that divisor is
part of the required test domain.  The mismatch is intrinsic: it is exactly the collision
between the artificial completion root and a genuine support point.

## 4. Literature refresh

This refresh adds no new characterization of an individual paper.  It inherits C510's source
record: Fang--Xu--Zhu, arXiv:2403.11436v2, and Gu--Wang--Zhang,
arXiv:2509.08526v1, were read at `full text` from the cached PDFs; Cheng--Wu--Zhou,
DOI `10.1016/j.ffa.2026.102882`, was read at `partial` depth from the publisher's indexed
abstract, introduction, displayed Theorem 1.10, and conclusion.  Thus two of the three inherited
individual sources were read at full text.  Exact cache keys, hashes, version details, and source
characterizations remain in `notes/2026-07-23-c510-trs-deep-hole-literature-audit.md`.

All queries below were rerun on 2026-07-23.

- OpenAlex's pinned `filter=cites:W4411328908` returned one record, Cheng--Wu--Zhou; pinned
  `filter=cites:W4416069065` returned zero.
- Crossref's exact request for `10.1016/j.ffa.2025.102680` still reported
  `is-referenced-by-count=1`; the exact arXiv DOI request
  `10.48550/arXiv.2509.08526` returned HTTP 404, not an empty set.
- Semantic Scholar was now reachable.  The exact
  `ARXIV:2403.11436/citations?fields=title,abstract,year,externalIds&limit=1000`
  request returned 13 records and no next page; the corresponding `ARXIV:2509.08526`
  request returned zero.  The DOI seed `DOI:10.1016/j.ffa.2025.102680` returned one
  record, Cheng--Wu--Zhou.  The 13-record set—the largest—was screened over title and
  abstract using the discriminator
  `deep hole | covering radi | last-hook | last hook | modular`.  Four records matched at
  least one term; their metadata and abstracts concern the already assigned deep-hole paper,
  extended twisted-GRS classes, decoding/properties, or using deep holes to construct other
  codes.  None states a classification of the full-length modular last-hook family \(p\mid k\).

The disagreement `OpenAlex 1 / Crossref 1 / Semantic Scholar arXiv-record 13, DOI-record 1`
is version-indexing evidence, not thirteen independent results on the target.  The largest
set was nevertheless screened as required.  No predecessor for the C514 translation quotient
was located in these pinned forward graphs.  This is a bounded citation-graph negative, not an
unqualified priority claim: MathSciNet, zbMATH Open, and Google Scholar were not newly searched.

## 5. Extra-juice closeout and mystery ledger

The cheap closeout strengthens the quotient from a list of invariants to a canonical slice
equivalence.  The apparently awkward fixed coefficient “root sum one” is exactly what makes the
completion root translation-equivariant in the modular locus.  It also exposes why the C512
analogy almost works: factoring the completion marker gives a lower split polynomial, but the
marker incidence divisor has the opposite semantics.

### First extra-juice round — the additive recursion operator is exact

Keep \(U\) fixed and write
\[
 F_y(r,U)=\langle A_{-r}y,XQ_U\rangle.
\]
For every \(b\in\mathbb F_q\), its finite translation difference is
\[
 F_y(r+b,U)-F_y(r,U)
 =F_{(A_{-b}-1)y}(r,U).                                        \tag{10}
\]
Iterated differences therefore replace \(y\) by the corresponding product of augmentation
operators \(A_{-b_i}-1\); there is no correction term from the quotient coordinates.  The
common fixed flag in (4) is exactly the degree-zero endpoint of this recursion.  What remains
for C515 is not construction of the operator but the arithmetic question whether the first
nonzero additive polynomial produced by (10) hits zero on the split trace-one configuration
space.

This also strengthens the stabilizer statement: since every \((s-1)\)-support has trivial
translation stabilizer, all isotropy in the incidence problem comes from the syndrome direction,
not from a hidden periodic support.

### Second extra-juice round — the collision divisor is a recursive boundary

The valid completion/support collision \(0\in U\) has an exact normal form.  Write
\[
 U=\{0\}\sqcup V,\qquad |V|=s-2,\qquad
 V\subset\mathbb F_q^\times,\qquad\sum_{v\in V}v=1.
\]
Then
\[
 Q_U(X)=XQ_V(X),\qquad XQ_U(X)=X^2Q_V(X).                       \tag{11}
\]
Thus the collision divisor is itself the distinct split trace-one configuration space of
\((s-2)\)-subsets of \(\mathbb G_m\), paired with a double marked factor.  It is neither
unstructured debris nor C512's forbidden diagonal.  Equation (11) identifies the exact boundary
object that an additive or logarithmic successor must retain.

- **Settled — can nonexact invariants create a new fixed syndrome?** No.  Equation (7) forces
  every quotient-fixed class to lift to the Lucas-maximal fixed flag; the connecting class is
  zero.
- **Settled — is there an explicit quotient rather than only invariant-ring generators?** Yes.
  The completion-root slice \(r=0\) is canonical, and its unordered coordinates are the
  coefficients of \(Q_U\) with \(\sum U=1\).
- **Settled — are stabilizers or Frobenius lost?** No.  The pointed support action groupoid is
  equivalent to the slice, the support action is already free, syndrome stabilizers remain
  transporter equalities, and Frobenius preserves the slice.
- **Settled — does C512 apply universally?** No.  The shift matrix (9) is the exact
  polar-line gate, and valid completion/support collisions lie on the divisor that C512 must
  delete.
- **Settled — is the hoped-for additive operator itself available?** Yes.  Equation (10) is an
  exact augmentation-ideal recursion, and its degree-zero endpoint is the Lucas fixed flag.
- **Settled — is the collision divisor geometrically opaque?** No.  Equation (11) identifies it
  with the trace-one configuration space in \(\mathbb G_m\) carrying a double marker.
- **Open — which deep syndromes, if any, lie on the polar-compatible locus (8)?** C514 did not
  classify deep syndromes and no census was authorized.  A successor would need a newly allocated
  bounded theorem target that first proves this locus is relevant.  C515 owns that gate.
- **Open — does the quotient avoidance problem have a different recursion retaining the
  collision divisor?** Equation (10) supplies the operator and (11) supplies its boundary, but
  root existence and additive trace obstructions remain unproved.  C515 owns this gate.

Vibe check: the symmetry paid off cleanly—the quotient and fixed flag are exact—but it exposes a
structural near miss rather than the hoped-for PRS recursion, so the next advance needs a genuinely
different splitting mechanism, not more field data.
