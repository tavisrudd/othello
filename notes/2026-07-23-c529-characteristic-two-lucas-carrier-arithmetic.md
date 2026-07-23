# C529 — characteristic-two Lucas-carrier Frobenius arithmetic

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete at the authorized first
level-dependent monodromy obstruction

## Result

Put \(d=2^s\), \(s\ge2\), and work in characteristic two.  The top nucleus of the degree-\(d\)
normal rational curve is
\[
 \mathcal N_{d-1}^{(d)}
 =\mathbf P\langle e_1,\ldots,e_{d-1}\rangle .
\]
C512's consecutive-row kernel therefore gives the coherent degree-\((d+1)\) carrier
\[
 \mathcal M_{d+1}(\mathcal N_{d-1}^{(d)})
 =\mathbf P\langle e_2,\ldots,e_{d-1}\rangle .              \tag{1}
\]
The distinguished Borel-endpoint \(f_s=e_{d-1}\) lies on (1), and its degree-\(d\) Hankel kernel
contains the linearized net
\[
 \mathcal U_s=\langle1,t,t^d\rangle .                       \tag{2}
\]

The normalized ordered-root cover of
\[
 A+Bt+Ct^d,\qquad BC\ne0,                                  \tag{3}
\]
has generic geometric monodromy
\(\operatorname{AGL}_1(\mathbf F_d)=\mathbf F_d\rtimes\mathbf F_d^\times\), minimal constant
field \(\mathbf F_d\), and based residual deck group
\(\mathbf F_d^\times\cong C_{d-1}\).  Coefficientwise Frobenius acts on the based group by
\[
 a\longmapsto2a\pmod {d-1}                                 \tag{4}
\]
and cycles the constant components with exact order \(s\).  Equivalently,
\[
 \mathcal U_s\text{ contains a completely split squarefree member over }\mathbf F_{2^m}
 \quad\Longleftrightarrow\quad s\mid m.                     \tag{5}
\]

At \(s=2\), (1) is C498's line
\(\mathbf P\langle e_2,e_3\rangle\), and \(W_{e_3}\) equals (2).  The line is one
\(PGL_2\)-orbit, so formula (5) is the exact C498 law: every point is deep precisely for odd
\(m\).  Its only coherent lift is
C509's point \(e_3\); contraction recovers the same odd-\(m\) law, with \(t^4+t\) acquiring the
simple root at infinity in the quintic kernel.

The next nonzero coherent carrier occurs at \(s=3\):
\[
 \mathcal M_9(\mathcal N_7^{(8)})
 =\mathbf P\langle e_2,e_3,e_4,e_5,e_6,e_7\rangle .         \tag{6}
\]
At its distinguished point \(e_7\), the restricted cover has based deck group \(C_7\), Frobenius cycles
\[
 (0)(1\,2\,4)(3\,6\,5),                                    \tag{7}
\]
and constant-component cycle length three.  In particular \(e_7\), and hence its full
\(PGL_2\)-orbit in (6), is shallow whenever \(3\mid m\), because
\(t^8+t\in W_{e_7}\) has the eight distinct roots \(\mathbf F_8\).  This includes infinitely many
odd extension degrees.  Thus the C498/C509 extension-parity rule does not survive the first new
binary level: the first obstruction is an intrinsic order-three constant-field/monodromy
obstruction, not a sporadic syndrome orbit.

This fires C529's stop rule.  The report does not extrapolate through (6).  Even at \(e_7\), when
\(3\nmid m\), the four-dimensional quotient \(W_{e_7}/\mathcal U_3\) can contribute other
ordered-root components, so no converse deepness statement is made without their normalization.

## 1. Lucas nuclei and the overlap kernel

Let \(C_d\subset\mathbf P(\Gamma^dE)\) be the divided-power NRC.  The characteristic-two
coordinate rule for its order-\(j\) nucleus is
\[
 S(d,j)=
 \left\{i: \binom ri=0\pmod2\text{ for every }j<r\le d\right\}.               \tag{8}
\]
This is Lucas' criterion in intrinsic coordinates; it commutes with base extension.  If
\(\widetilde{\mathcal N}=\langle e_i:i\in S\rangle\), the two contraction rows show
scheme-theoretically that
\[
 \mathcal M_{d+1}(\mathcal N)
 =\mathbf P\langle e_i:
   (i=d+1\text{ or }i\in S),\
   (i=0\text{ or }i-1\in S)\rangle .                        \tag{9}
\]
There are no hidden equations or embedded components: (9) is the projectivization of the kernel
of a linear map, with the displayed coordinate basis.

Applying (8)--(9) through lower degree eight leaves exactly:

| lower degree | nucleus order | nucleus indices | upper carrier | vector rank |
|---:|---:|---|---|---:|
| 4 | 3 | \(1,2,3\) | \(2,3\) | 2 |
| 5 | 3 or 4 | \(2,3\) | \(3\) | 1 |
| 8 | 7 | \(1,\ldots,7\) | \(2,\ldots,7\) | 6 |

All overlap kernels in lower degrees two, three, six, and seven are zero.  Thus C498's line,
C509's rank-one contraction, and (6) are not selected examples from an ambient census: they are
the complete nonzero consecutive-row overlaps before degree nine.  Iterating the C509 point once
more gives zero, so (6) is the first fresh coherent flag rather than a continuation mistakenly
forced through a zero kernel.

For \(d=2^s\), Lucas gives
\(\binom di=0\pmod2\) for every \(0<i<d\), proving the top-nucleus formula and (1).  This is an
infinite representation-stable family indexed by the single binary digit of \(d\).

## 2. The distinguished linearized net

Write a binary degree-\(d\) form on the affine chart as
\[
 g(t)=\sum_{i=0}^d b_it^i .
\]
For a coordinate syndrome \(e_i\), the two Hankel equations remove the consecutive coefficients
\(b_{i-1},b_i\).  The intersection of the kernels over the whole carrier (1) therefore has only
the endpoint indices \(0,d\).  At the distinguished point \(f_s=e_{d-1}\), however, the three
coordinate forms with indices
\[
 0,\quad1,\quad d
\]
satisfy both equations.  This proves (2).  Since \(\dim W_{f_s}=d-1\):

- for \(d=4\), \(\dim W_{e_3}=\dim\mathcal U_2=3\), so \(W_{e_3}=\mathcal U_2\);
- for \(d=8\), \(\dim W_{e_7}/\mathcal U_3=4\).

The second equality is the precise reason the C498 converse does not automatically lift to (6).
The constant cover remains an exact shallowness detector on the distinguished orbit, but it no
longer exhausts even that point's kernel.

## 3. Normalization and monodromy of the ordered-root cover

Divide (3) by \(C\) and put
\[
 \alpha=B/C,\qquad\gamma=A/C.
\]
Choose \(\beta\) and \(y\) satisfying
\[
 \beta^{d-1}=\alpha,\qquad y^d+y=\gamma/\beta^d.             \tag{10}
\]
Then the complete root set is
\[
 \{\beta(y+c):c\in\mathbf F_d\}.                            \tag{11}
\]
Conversely, any two distinct roots have difference \(\beta c\), so (11) recovers both the
\(\mathbf F_d\)-affine structure and (10).  Therefore (10) is the normalization of the
affine-framed quotient of the ordered-root cover.

Over \(\mathbf F_d(\alpha,\gamma)\), the first equation of (10) is the generic cyclic
\((d-1)\)-cover and the second is the generic additive \(d\)-cover.  Their automorphisms act on
(11) by
\[
 c\longmapsto uc+v,\qquad
 u\in\mathbf F_d^\times,\ v\in\mathbf F_d,
\]
giving exact generic geometric monodromy \(\operatorname{AGL}_1(\mathbf F_d)\).  The valuation of
\(\alpha\) makes the Kummer equation irreducible, and after adjoining \(\beta\), the simple
\(\gamma\)-pole makes the additive equation regular and irreducible.  Hence these covers add no
further constants.  Since ratios of nonzero root differences contain all of \(\mathbf F_d\), the
minimal constant field is exactly \(\mathbf F_d\).

After fixing one root, the residual scalings form \(C_{d-1}\).  Frobenius squares the constants,
which is (4).  The order of \(2\) modulo \(2^s-1\) is exactly \(s\): if
\(2^r\equiv1\pmod{2^s-1}\), then \(2^s-1\mid2^r-1\), equivalently \(s\mid r\).
Thus the constant components form one Frobenius cycle of length \(s\).

Finally, a split member of (3) over \(k=\mathbf F_{2^m}\) has root set \(a+\beta\mathbf F_d\).
Taking ratios of nonzero differences proves \(\mathbf F_d\subset k\), hence \(s\mid m\).
Conversely, if \(s\mid m\), the member \(t^d+t\) has root set \(\mathbf F_d\).  Its derivative is
one, so all roots are distinct.  This proves (5) without a point count or Hasse estimate.

## 4. C498 and C509 controls

For \(d=4\), (4) acts on \(C_3\) by inversion:
\[
 (0)(1\,2).
\]
Because \(W_{e_3}=\mathcal U_2\), any completely split squarefree quartic at the representative
forces
\(\mathbf F_4\subset\mathbf F_{2^m}\), and \(t^4+t\) supplies one exactly when \(m\) is even.
This recovers C498 pointwise on its full nucleus line.  The line is one \(PGL_2\)-orbit, so the
statement is frame-independent and coefficientwise Frobenius preserves it.

Formula (9) sends the degree-five line to the unique degree-six point \(e_3\), whose kernel is
\[
 W_{e_3}=\langle1,t,t^4,t^5\rangle .
\]
For odd \(m\), a split quintic would contract at one root to a split quartic on the C498 line,
which is impossible.  For even \(m\), homogenizing \(t^4+t\) as a quintic adds the simple root at
infinity.  This is C509's central-point law derived from the same normalized cover, not from its
finite-field replay.

## 5. The first excluded binary pattern

At \(d=8\), (7) is multiplication by two on \(C_7\).  At \(e_7\), the ordered roots of
\(t^8+t\) are
\(\mathbf F_8\), and coefficient Frobenius fixes \(0,1\) while permuting the other six roots in
two three-cycles.  Hence \(e_7\) and its \(PGL_2\)-orbit in (6) are shallow over every
\(\mathbf F_{2^m}\) with \(3\mid m\).  There are arbitrarily large odd such \(m\), so ordinary
extension parity cannot encode this arithmetic.

This is the first excluded pattern because the complete overlap calculation in §1 has no
intermediate nonzero coherent carrier.  The obstruction is representation-level:

- its source is the next power-of-two Lucas digit pattern;
- its minimal constant field jumps from \(\mathbf F_4\) to \(\mathbf F_8\);
- its component Frobenius jumps from order two to order three; and
- it occurs on the intrinsic Borel-endpoint orbit inside the six-dimensional vector carrier.

No claim is made that \(e_7\), its orbit, or other points of (6) are deep when \(3\nmid m\).
Determining that would already require the normalizations and Frobenius classes contributed by
\(W_{e_7}/\mathcal U_3\), and the rest of the carrier can vary further.  This is precisely the
larger level-specific calculation that C529's stop rule forbids after the first proved
obstruction.

## 6. Coding and collision semantics

A completely split squarefree degree-\(d\) member of a Hankel kernel is exactly the standard PRS
shallowness witness used by C491--C525.  The witness \(t^d+t\):

- has degree exactly \(d\);
- has derivative one;
- has the \(d\) distinct finite roots \(\mathbf F_d\);
- has no repeated-root, diagonal, or prescribed-marker collision; and
- remains valid over every extension containing \(\mathbf F_d\).

Thus the conclusion applies to the distinguished orbit whenever the corresponding full-length
PRS parameters are defined;
there are infinitely many admissible fields in every extension class used above.  No curve bound
is invoked, so there is no deletion budget or Hasse threshold to state.  \(PGL_2\) transport sends
the root set and kernel witness together, and coefficientwise Frobenius preserves the Lucas
carrier, giving the claimed orbit transport.

## Evidence and replay

The atomic bundle is:

- `notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.py`;
- `notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.json`;
- `notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic-replay.py`; and
- `notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.sha256`.

From the repository root:

```text
python3 notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.py \
  --check notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.json
python3 notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic-replay.py
(cd notes && sha256sum -c 2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.sha256)
```

The generator uses integer binomial coefficients to compute every nucleus and consecutive-row
overlap through lower degree eight, then records the power-of-two family through \(s=4\), its
common kernel indices, doubling cycles, and control data.  The replay independently uses Lucas'
bit-subset criterion rather than binomial coefficients and separately reconstructs every overlap
and Frobenius cycle.  The computation certifies the displayed finite entry table and arithmetic
cycle data; the all-\(s\) nucleus, normalization, constant-field, and splitting assertions are the
hand proofs in §§1--3.
The load-bearing byte counts are `6498` for the generator, `6003` for the JSON certificate,
`3712` for the replay, and `15109` for this report.

## Extra-juice and Tao closeout

The closeout exposes a stronger clean boundary than merely finding one parity counterexample:

- the top power-of-two nuclei give the infinite carrier family (1);
- every family has a distinguished Borel-endpoint orbit with the exact monodromy quotient
  (2)--(4);
- the field condition is \(s\mid m\), so C498 is the accidental \(s=2\) parity specialization;
- C509 inherits that same level rather than furnishing a new one; and
- the first fresh level is forced to be \(s=3\) by the complete overlap calculation, so the
  obstruction cannot be moved to a smaller redundancy by a different coordinate choice.
- a final consecutive-coefficient stress test separates the carrier-wide endpoint pencil
  \(\langle1,t^d\rangle\) from the three-dimensional net at \(e_{d-1}\); the proved obstruction
  is therefore correctly orbitwise, not overstated as carrier-wide.

The highest-value further calculation would normalize the four-dimensional quotient
\(W_{e_7}/\mathcal U_3\), then extend across intrinsic \(PGL_2\)-normal forms in (6).  It is
deliberately not opened here:
the task requires stopping once the order-three component obstruction is proved.

## Mystery ledger

Settled:

- **Why do C498 and C509 have the same odd-extension law?**  They use the same
  \(\mathbf F_4\)-constant ordered-root cover; C509 is the unique coherent contraction of C498.
- **What is the representation-stable carrier family?**  Equation (1), for every power-of-two
  lower degree.
- **What controls its distinguished root cover?**  Generic monodromy
  \(\operatorname{AGL}_1(\mathbf F_{2^s})\), constant field \(\mathbf F_{2^s}\), and based
  Frobenius \(a\mapsto2a\).
- **Is extension parity stable?**  No.  It is the \(s=2\) instance of \(s\mid m\), and the first
  fresh carrier has an order-three component cycle.
- **Does the linearized net occur at every point of the carrier?**  No.  The full carrier shares
  only \(\langle1,t^d\rangle\); \(\mathcal U_s\) is the exact distinguished-endpoint net used for
  the obstruction.
- **Are the distinguished shallow witnesses collision-free?**  Yes; \(t^{2^s}+t\) has
  derivative one and exactly \(\mathbf F_{2^s}\) as its roots.

Open, with exact evidence gap:

- **Deepness on (6) when \(3\nmid m\).**  Even at \(e_7\), the distinguished net no longer
  exhausts the kernel: \(W_{e_7}/\mathcal U_3\) has dimension four.  Gate: normalize its
  additional ordered-root components and then compute their Frobenius action across intrinsic
  \(PGL_2\)-normal forms.  This is
  excluded by C529's first-obstruction stop rule and requires a separately allocated successor.

No other genuine mystery remains inside C529's authorized scope.

## Literature boundary

C529 makes no priority claim.  It uses the frozen C512 Lucas/contraction theorem and C525
carrier-containment theorem, and proves the selected carrier arithmetic directly.  No manuscript
or C500 work is opened.
