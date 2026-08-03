# C532 — strongest honest PRS redundancy-ten synthesis

**Lane:** `reed-solomon` · **Date:** 2026-07-24 · **Status:** complete at the frozen
rank-two-cover/positive-moduli residue

## Result

Put \(n=9\).  A projective syndrome of the full-length code
\(\operatorname{PRS}(q-9)\) is shallow exactly when its degree-eight Hankel
kernel contains a completely split squarefree member.  Let
\(\mathcal P_9(q)\) be the persistent catalecticant rank-two set: the tangent
family together with the conjugate-sigma family.

The strongest unconditional synthesis is as follows.

1. **Odd characteristic.**  For every odd prime power \(q\ge59\), the projective
   deep-syndrome directions are exactly
   \[
      \mathcal D_{10}(q)=\mathcal P_9(q).
   \]
   Thus
   \[
      |\mathcal D_{10}(q)|=\frac{q(q+1)^2}{2}.                \tag{1}
   \]
2. **Characteristic two.**  For every \(q=2^m\ge64\),
   \[
      \mathcal P_9(q)\subseteq\mathcal D_{10}(q)
      \subseteq\mathcal P_9(q)\cup\mathcal M_9(q),            \tag{2}
   \]
   where
   \[
      \mathcal M_9=\mathbf P\langle e_2,e_3,e_4,e_5,e_6,e_7\rangle
   \]
   is the exact Lucas carrier.  Define the disjoint residual set
   \[
      \mathcal R_q=\mathcal D_{10}(q)\setminus\mathcal P_9(q).
   \]
   Then the exact cardinality statement is
   \[
      |\mathcal D_{10}(q)|
       =\frac{q(q+1)^2}{2}+\rho_q,\qquad
      \rho_q:=|\mathcal R_q|,                                \tag{3}
   \]
   with
   \[
      0\le\rho_q\le q(q^2-1)+q^4(q+1).                       \tag{4}
   \]
   Both rank-one strata in the invariant block
   \(U=\langle e_2,e_3,e_6,e_7\rangle\) are excluded from
   \(\mathcal R_q\).  The remaining candidate domain is exactly the rank-two
   \(A_5\)-twisted stratum in \(\mathbf P(U)\), with C531's nonconstant
   Artin--Schreier root cover, together with
   \(\mathbf P(\mathcal M_9)\setminus\mathbf P(U)\), whose geometric quotient
   by \(PGL_2\) has dimension two.

Clause (2) is deliberately not rewritten as an equality with the whole Lucas
carrier.  Carrier containment is not arithmetic deepness.  C531 proves that
the graph and off-graph rank-one strata are shallow, but it stops honestly at
the nonconstant rank-two cover and the positive-moduli complement.  Therefore
no proved exact numerical value of \(\rho_q\) is currently available.

The Seroussi--Roth covering-radius premise applies throughout the displayed
high-field ranges, so these projective deepest-syndrome statements are the
corresponding deep-hole statements for \(\operatorname{PRS}(q-9)\).

## 1. Effective threshold

### 1.1 Generic five-marker spine

Five distinct contractions reduce a degree-nine syndrome to the same
geometric-\(S_3\) ordered-pair cover used in C512--C516.  Its normalization has
genus at most one.  The base diagonal/branch deletion costs twelve points and
each forbidden marker costs six, hence
\[
   \delta_{\mathrm{gen}}=12+5\cdot6=42.                     \tag{5}
\]
The exact Hasse--Weil inequality is
\[
   q+1-2\sqrt q>42.                                         \tag{6}
\]
Its first integer threshold in C512's notation is
\(\mathcal H(1,42)=58\); the first prime power satisfying it is \(59\).

The first-polar line meets the lower persistent carrier in degree at most
three.  The already classified characteristic-specific lower nucleus loci
contribute at most two further transverse parameters.  The moving
\(g^6_8\) has ramification degree
\[
   (6+1)(8-6)=14.
\]
Thus
\[
   b_{9,0}\le3+2=5,\qquad c_{9,0}\le14,\qquad
   b_{9,0}+c_{9,0}\le19,                                   \tag{7}
\]
well below the arithmetic threshold.  C512 therefore makes every
noncontained syndrome shallow for \(q\ge59\).

The only odd-characteristic contained remnants imported from the preceding
level are already arithmetically closed.  The characteristic-five point has
the uniform split witness from C516.  The characteristic-seven binary-quartic
carrier has no deep point at \(q=49\) and is uniformly shallow for
\(q=7^m\ge343\); the first characteristic-seven field in the present
high-field range is \(343\).  Hence no unresolved odd-characteristic contained
component survives, proving the first clause of the result.

### 1.2 Characteristic-two ordered-Hessian slice

C525 gives a second, independent route in characteristic two.  At \(n=9\),
its rational base-selection threshold is
\[
 \min\left\{\frac{(9-4)(9+11)}2+1,\;9(9-4)\right\}
 =\min\{51,45\}=45.                                        \tag{8}
\]
On a good reduced \((2,2)\) slice the exact deletion table specializes to

| divisor | degree |
|---|---:|
| moving/fixed diagonal | \(5\) |
| residual determinant | \(2\) |
| inseparability branch | \(2\) |
| residual root through a fixed root | \(10\) |
| residual root through the moving root | \(4\) |
| **total** | **\(23\)** |

The inequality \(q+1-2\sqrt q>23\), together with (8), first holds at a power
of two for \(q=64\).  C525 then confines every split-free syndrome to
\(\mathcal P_9\cup\mathcal M_9\).  This proves (2) without treating a
collision component as a split member.

## 2. Persistent cardinality and orbit transport

The sigma family has \(q(q^2-1)/2\) projective points and the tangent family
has \(q(q+1)\), giving (1).  Put
\[
   d=\gcd(9,q+1).
\]
The sigma invariant is
\[
   T/T^9\simeq C_d
   \quad\text{modulo inversion and coefficientwise Frobenius},               \tag{9}
\]
where Frobenius acts by multiplication by the characteristic \(p\).
The tangent cocycle is
\[
   u\star z=z+9u.                                            \tag{10}
\]
It is one \(PGL_2(q)\)-orbit unless \(p=3\), when it splits into its fixed and
nonzero orbits.  In particular it does not split in characteristic two:
\(9=1\) there.

The complete persistent orbit counts are:

| arithmetic case | \(PGL_2\) | \(P\Gamma L_2\) |
|---|---:|---:|
| \(p=3\) | \(3\) | \(3\) |
| \(p\ne2,3,\ d=1\) | \(2\) | \(2\) |
| \(p\ne2,3,\ d=3\) | \(3\) | \(3\) |
| \(p\ne2,3,\ d=9,\ p\equiv8\pmod9\) | \(6\) | \(6\) |
| \(p\ne2,3,\ d=9,\ p\equiv2,5\pmod9\) | \(6\) | \(4\) |
| \(p=2,\ m\) even | \(2\) | \(2\) |
| \(p=2,\ m\equiv1,5\pmod6\) | \(3\) | \(3\) |
| \(p=2,\ m\equiv3\pmod6\) | \(6\) | \(4\) |

For \(d=1,3,9\), inversion gives respectively \(1,2,5\) sigma orbits.  At
\(d=9\), multiplication by \(p\equiv-1\) causes no further fusion, whereas
\(p\equiv2\) or \(5\) has order six and merges the six unit labels into one
semilinear orbit.  The multiples of three and zero remain separate.  The
characteristic-two rows add the single tangent orbit to these sigma counts.

The unresolved set \(\mathcal R_q\) is \(P\Gamma L_2(q)\)-stable.  Inside
\(\mathbf P(U)\), its rational rank-two orbit transport is exactly C531's:
five \(A_5\) cocycle classes for even \(m\), three odd-coset \(S_5\) types for
odd \(m\), with coefficientwise Frobenius exchanging the two order-five
classes in the even case.  This finite label does not decide membership in
\(\mathcal R_q\), because the root incidence has the additional nonconstant
cover.

## 3. Exact unresolved residues

### 3.1 Rank-two finite-stratum residue

At the representative \(e_3+e_6\), choose six roots with polynomial
\(h(t)=\sum_{i=0}^6h_it^i\), and use C531's quantities
\[
\begin{aligned}
A_0&=h_0+h_3,& A_1&=h_1+h_4,\\
A_2&=h_2+h_5,& A_3&=h_3+1,\\
\Delta&=A_1A_3+A_2^2,&
N_s&=A_0A_3+A_1A_2,&
N_p&=A_1^2+A_0A_2.
\end{aligned}
\]
On \(\Delta N_s\ne0\), the final pair lifts rationally exactly when
\[
 \operatorname{Tr}_{\mathbf F_q/\mathbf F_2}
 \left(\frac{N_p\Delta}{N_s^2}\right)=0.                   \tag{11}
\]
The six roots must be distinct and the final pair must avoid them.  A
rank-two syndrome can belong to \(\mathcal R_q\) only if every rational
six-root configuration either hits this explicit deletion boundary or fails
(11).  Equation (11) defines a geometrically integral nonconstant
Artin--Schreier cover; it cannot be replaced by the finite \(A_5\)-twist
label.

### 3.2 Positive-moduli residue

The quotient sequence
\[
 0\longrightarrow U\longrightarrow\mathcal M_9
 \longrightarrow\det^4\otimes E\longrightarrow0
\]
is \(PGL_2\)-equivariant.  The complement of \(\mathbf P(U)\) contains
\[
 |\mathbf P^5(\mathbf F_q)|-|\mathbf P^3(\mathbf F_q)|
 =q^4(q+1)                                                   \tag{12}
\]
rational points and has a two-dimensional geometric quotient.  Its stop
condition is exactly the absence of a split squarefree degree-eight member in
the corresponding Hankel kernel.  No finite orbit list exists on this
domain.  Together with the \(q(q^2-1)\) rank-two points of \(\mathbf P(U)\),
(12) gives the honest upper bound (4).

The bounded field residue below the uniform threshold is also explicit:
for odd admissible fields
\[
 q\in\{11,13,17,19,23,25,27,29,31,37,41,43,47,49,53\},
\]
the theorem leaves the nonpersistent points whose five-marker polar flag
meets the divisor in (7) at every rational parameter or whose lower identity
twist has no admissible rational point.  In characteristic two the
below-threshold admissible fields are \(q=16,32\).  C531 certifies every
\(\mathbf P(U)\)-orbit shallow at those two fields, but does not inspect the
two-dimensional quotient.  These are intrinsic polar-cover and carrier
quotient residues, not an invitation to scan ambient \(\mathbf P^9\).

## Evidence and replay

The compact arithmetic bundle is:

- `notes/2026-07-23-c532-prs-redundancy-ten-synthesis.py`;
- `notes/2026-07-23-c532-prs-redundancy-ten-synthesis.json`;
- `notes/2026-07-23-c532-prs-redundancy-ten-synthesis-replay.py`; and
- `notes/2026-07-23-c532-prs-redundancy-ten-synthesis.sha256`.

From the repository root:

```text
python3 notes/2026-07-23-c532-prs-redundancy-ten-synthesis.py --check
python3 notes/2026-07-23-c532-prs-redundancy-ten-synthesis-replay.py
(cd notes && sha256sum -c 2026-07-23-c532-prs-redundancy-ten-synthesis.sha256)
```

The generator independently checks the two threshold calculations, divisor
sums, cyclic inversion/Frobenius orbit counts, and carrier point-count bound.
The replay uses a separate prime-power sieve and direct cyclic-orbit closure.
Neither script proves the geometric input from C512, C525, or C531; those
theorems and the hand synthesis above are the trusted structural boundary.
The load-bearing byte counts are `5065` for the generator, `2100` for the
JSON certificate, and `2238` for the replay.

## Extra-juice and Tao closeout

The synthesis exposes three cheap improvements over a blanket
“redundancy ten remains open” statement.

- Odd characteristic is already closed uniformly from \(q=59\); C531's
  obstruction is purely characteristic two.
- C525's ordered-Hessian route gives the first characteristic-two threshold
  \(64\) with deletion \(23\), much smaller than the generic five-marker
  deletion \(42\), even though both routes land at the same first admissible
  power of two.
- The unresolved characteristic-two set has a sharp internal filtration:
  two rank-one orbits are uniformly shallow, rank two is a finite
  \(A_5\)-twist problem with a nonconstant \(C_2\)-cover, and only the
  complement has genuine two-dimensional moduli.

The highest-EV successor is a bounded rational-avoidance theorem for (11)
across the rank-two twists.  It is lower-dimensional, has a concrete
Artin--Schreier equation and deletion divisor, and could remove the first
piece of \(\rho_q\) without opening the generic two-dimensional quotient.

## Mystery ledger

Settled:

- **What is the strongest exact high-field theorem?**  Exact persistent-only
  classification for every odd \(q\ge59\), and exact
  persistent-plus-residue containment for every \(2^m\ge64\).
- **What are the effective constants?**  Generic genus one, deletion \(42\),
  transverse/collision budget \(19\), first prime power \(59\);
  characteristic-two base threshold \(45\), deletion \(23\), first power
  \(64\).
- **What is the persistent cardinality and semilinear law?**  Equation (1),
  \(T/T^9\) modulo inversion/Frobenius, tangent cocycle (10), and the complete
  eight-row orbit table.
- **Can the C530 graph orbit or C531 off-graph rank-one orbit contribute?**
  No; both are shallow over every admissible characteristic-two field.
- **Is the \(q=8\) split-free rank-two twist a redundancy-ten exception?**
  No; \(q=8\) is outside the admissible full-length range.

Open, with exact evidence gap:

- **Rank-two Lucas residue.**  Missing theorem: rational avoidance on the
  nonconstant Artin--Schreier cover (11) for every admissible field and
  \(A_5\)-twist.  The finite twist label alone is insufficient.
- **Generic Lucas residue.**  Missing theorem: component and rational-point
  analysis over the two-dimensional quotient of
  \(\mathbf P(\mathcal M_9)\setminus\mathbf P(U)\).
- **Fields below the effective threshold.**  No bounded quotient
  classification was allocated.  The exact field and intrinsic stop domains
  are listed above.

No other genuine mystery remains inside C532's synthesis scope.

## Literature boundary

C532 makes no new priority claim and is not a manuscript or preprint gate.
It combines the frozen C512, C516, C525, C530, and C531 theorem boundaries.
The threshold arithmetic and orbit fusion are checked by the adjacent compact
certificate; no literature search or ambient syndrome census is used.
