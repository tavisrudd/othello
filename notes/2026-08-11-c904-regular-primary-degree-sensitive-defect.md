# C904: the regular-primary defect is degree-sensitive

Date: 2026-08-11

Status: exact bounded theorem and independent replay; Paper V research only;
no manuscript or Lean edit

## Verdict

The dyadic regular-primary graph gluing in dimension six has two different
integral divisor-product defects:

\[
 \operatorname {ord}\!\left(
   \frac{\Theta^5}{5!}\bmod P^5\right)=4,
 \qquad
 [H^{12}(A,\mathbf Z):P^6]=8.
\]

Thus the minimal-curve defect and the top/point defect need not agree, even
on one cyclic-primary, polarized-indecomposable ppav.  The proposed
regular-primary height formula for the **minimal curve** survives this test,
but it cannot be promoted unchanged to every divided degree.  Any intrinsic
(p)-typical classification must be graded: the nilpotent height alone does
not determine one common defect for the whole divisor-generated cohomology
ring.

The example uses the symmetric matrix over \(\mathbf F_2\)

\[
T=\begin{pmatrix}
0&1&0&1&0&0\\
1&0&0&1&1&0\\
0&0&0&1&1&1\\
1&1&1&1&1&0\\
0&1&1&1&1&1\\
0&0&1&0&1&0
\end{pmatrix}.
\]

It has characteristic and minimal polynomial \(x^6\).  Hence its reduced
centralizer is the local algebra \(\mathbf F_2[x]/(x^6)\); the cyclic-primary
idempotent lemma makes the associated principally polarized graph quotient
polarized-indecomposable.

This is a correction, not a failure of the curve-height conjecture.  The
curve order is the predicted

\[
 2^{\min\{v_2(5!),\lfloor\log_2 6\rfloor\}}=4.
\]

What fails is the formerly untested expectation, suggested by the exact
rank-three through rank-five bases, that the top defect would always equal
the curve defect.

## 1. Compressed top-lattice proof

For a graph gluing, every integral divisor has alternating matrix

\[
 \Omega_D=\begin{pmatrix}C_D&D\\-D&0\end{pmatrix},
 \qquad D^t=D,
\]

where \(C_D\) is the commutator carry.  Its Pfaffian is, up to a fixed sign,
\(\det D\), independently of \(C_D\).  Therefore the complete lattice of
top divisor products can be computed from the full coefficient lattice

\[
 L_T=\{D\in\operatorname {Sym}_6(\mathbf Z):DT=TD\pmod2\}
\]

without enumerating degree-six monomials.

Starting with \(W_0=\mathbf Z\), define \(W_{k+1}\) as the integral span of
all mixed-minor wedges \(w\wedge D\), with \(w\in W_k\) and \(D\) in an
integral basis of \(L_T\).  Then

\[
 W_k\subset
 \operatorname {Hom}(\bigwedge^k\mathbf Z^6,
                     \bigwedge^k\mathbf Z^6).
\]

Compressing by Hermite normal form after each degree gives ranks

\[
 21,105,175,105,21,1.
\]

The last rank-one lattice is \(8\mathbf Z\).  The same implementation
recovers the known rank-three top index two.

## 2. Independent full exterior replay

The independent replay does not use the mixed-minor compression.  It
reconstructs the principal twelve-dimensional graph homology lattice, the
complete rank-twenty-one lattice of integral alternating divisor forms, and
retains the carry block.  A depth-first exterior recursion exhausts all

\[
 \binom{21+6-1}{6}=230230
\]

degree-six divisor-basis monomials.  Their top-coefficient gcd is eight; the
explicit basis-index multiset `(0,0,1,6,6,17)` attains coefficient eight.

At depth five the same replay retains all

\[
 \binom{21+5-1}{5}=53130
\]

curve monomials.  Their span has the full Hodge rank twenty-one, and the
minimal curve \(\Theta^5/5!\) has exact order four in that lattice.  This
simultaneously verifies both sides of the strict inequality.

The two scripts use different coordinate normalizations.  The compressed
script records the coefficient lattice \(L_T\), of index \(2^{15}\) in
\(\operatorname {Sym}_6(\mathbf Z)\).  The replay records the source-form
lattice before dividing the cross block by two, so its displayed index is
\(2^{21}2^{15}=2^{36}\).  The actual alternating divisor forms and the two
defect calculations agree.

## 3. Consequences for the Annals-scale program

There is a free uniform recurrence which explains why the new factor can
appear precisely at the top step.  If

\[
 d_k=\operatorname {ord}\!\left(\Theta^k/k!\bmod P^k\right),
\]

then multiplication by the integral divisor \(\Theta\) gives

\[
 \Theta\,\frac{\Theta^k}{k!}
   =(k+1)\frac{\Theta^{k+1}}{(k+1)!},
 \qquad d_{k+1}\mid(k+1)d_k.                         \tag{3.1}
\]

Hence a (p)-primary defect can rise by at most
\(v_p(k+1)\) in one degree.  In the present example

\[
 v_2(d_5)=2,
 \qquad v_2(d_6)=3=v_2(d_5)+v_2(6),
\]

so the last multiplication realizes the largest new dyadic layer allowed by
(3.1).  This does not prove a general recurrence equality, but it gives a
conceptual location for the extra factor and a mandatory compatibility check
for every proposed graded formula.

The additive necklace/ghost cokernel has exponent
\(\operatorname {lcm}(1,\ldots,h)\), whose (p)-part is exactly
\(p^{\lfloor\log_p h\rfloor}\).  This remains the correct classical skeleton
for the distinguished minimal-curve order.  The new example shows that the
full saturation quotient needs more than that one exponent: each cohomological
degree sees a different piece of the carry-enhanced exterior/Koszul complex.

The stronger target is therefore a **graded p-typical defect theorem**:

> compute every elementary divisor of
> \(S_A^k/P_A^k\) from the carry-enhanced self-dual primary module, for all
> degrees \(k\), and identify the minimal-curve ghost quotient as one graded
> edge rather than the whole answer.

The strict `4 versus 8` split is useful positive information: it supplies the
first certified degree-sensitive layer and prevents an overstrong theorem
statement before an unbounded proof is attempted.

## 4. Reproducibility

Primary replay from the repository `rust/` directory:

~~~bash
nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("../notes/2026-08-11-c904-regular-primary-top-wedge.sage").read()))'
~~~

Independent replay:

~~~bash
nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("../notes/2026-08-11-c904-regular-primary-top-wedge-replay.sage").read()))'
~~~

Each command must reproduce its adjacent frozen `.out` file byte for byte.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-08-11-c904-regular-primary-top-wedge.sage` | 5,420 | `922e19f006d50d962e475634b8cee81f539ec876084ab962a11955b32067021c` |
| `2026-08-11-c904-regular-primary-top-wedge.out` | 210 | `a439db698843a0936a431e442109bc176a1f59d8dda6627e3fe5bb29ccd57fea` |
| `2026-08-11-c904-regular-primary-top-wedge-replay.sage` | 5,920 | `f791f2e6af9765e40564e9dbb0e048ff8f7306e7cb25251be857c8bcbf6bbaf9` |
| `2026-08-11-c904-regular-primary-top-wedge-replay.out` | 131 | `1d1e717e4ee8a43e291de8a673fc23262cd6b7cd806dbf43d374b7d292561311` |

Trusted boundary: the scripts prove the displayed finite integral lattice
orders for this graph gluing.  The indecomposability implication uses the
already proved cyclic-primary Rosati-idempotent lemma.  This bundle neither
proves the regular-primary curve formula in arbitrary height nor computes the
full graded quotient in dimension six.

## Mystery ledger

- **Settled:** curve and point defects can differ on one indecomposable ppav.
- **Settled:** the regular height-six curve still has exact order four.
- **Settled:** the extra top factor occurs at the unique dyadic allowance in
  the universal recurrence \(d_{k+1}\mid(k+1)d_k\), and is sharp here.
- **Open:** a structural criterion for when the recurrence inequality is an
  equality rather than a strict divisibility.
- **Open:** the full degree-by-degree elementary divisors and their modular
  exterior-power recursion.
- **Open:** whether the curve order always equals the truncated ghost exponent
  for every carry lift and bilinear type.

Vibe check: this is a valuable theorem correction.  It makes the intended
classification harder, but also more distinctive: the new invariant is a
graded defect profile, not one scalar.
