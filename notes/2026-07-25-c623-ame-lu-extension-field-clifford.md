# C623: extension-field Clifford classification

**Date:** 2026-07-25

**Lane:** `ame-lu`

**Status:** complete; the Desarguesian-spread reconstruction gate fails

## Result

For every odd prime power \(q=p^e\), the admitted non-GRS pencil has the
exact extension-field local-Clifford classification
\[
 \Psi_t\sim_{\mathrm{LC}(\mathbb F_p)}\Psi_u
 \quad\Longleftrightarrow\quad
 z(u)=z(t)^{p^k}\quad\text{for some }0\leq k<e,
\]
allowing arbitrary party permutations.  Adding the GRS boundary gives the
partition
\[
 \{\text{the GRS locus}\}\ \sqcup\
 \{\operatorname{Gal}(\mathbb F_q/\mathbb F_p)\text{-orbits of }z
   \text{ on the non-GRS locus}\}.
\]
The exact \(q=9,25,27\) census is an exhaustive falsifier and witness package
for this general algebraic theorem.

This orbit statement does **not** mean that all identifications are
semilinear.  The \(q=9\) admitted non-GRS pencil has genuine
\(\mathbb F_3\)-symplectic, nonsemilinear local-Clifford identifications.
The four parameters all have \(z=1\), form one LC orbit, and every one of
their fixed-party kernels has order \(96\), of which only \(16\) elements
are semilinear.  Thus \(80\) fixed-party elements do not preserve the
Desarguesian \(\mathbb F_9\)-spread.

The \(q=25\) GRS boundary gives a second, structural obstruction.  At each
of its four parameters the shortened-plane intertwiner space is the whole
\[
 \operatorname{End}_{\mathbb F_5}(\mathbb F_{25}^{\,2}),
\]
so the fixed-party kernel is exactly
\(\operatorname{Sp}_4(5)\), of order \(9{,}360{,}000\).  Its semilinear
subgroup has order
\(2|\operatorname{SL}_2(25)|=31{,}200\), leaving \(9{,}328{,}800\)
genuinely nonsemilinear elements.

Consequently the overlapping shortened marginal planes do not reconstruct
the Desarguesian spread, even on the admitted non-GRS locus: \(q=9\) is an
explicit falsifier.  In accordance with the task gate, no general positive
reconstruction theorem is attempted.

## Census

| field | full pencil | non-GRS / GRS | LC orbits | fixed-party kernels |
|---|---:|---:|---:|---|
| \(\mathbb F_9\) | 4 | \(4/0\) | 1 | order \(96\); 16 semilinear, 80 genuine nonsemilinear |
| \(\mathbb F_{25}\) | 20 | \(16/4\) | 4 | non-GRS: order \(24\); GRS: \(\operatorname{Sp}_4(5)\), order \(9{,}360{,}000\) |
| \(\mathbb F_{27}\) | 24 | \(24/0\) | 2 | order \(26\), all semilinear |

The complete non-GRS pair census checked 10, 136, and 300 unordered
parameter pairs at \(q=9,25,27\), respectively.  At \(q=9\), every one of
the ten pairs has a genuine nonsemilinear witness.  At \(q=25\) and \(q=27\),
every non-GRS witness is semilinear.  The exact projective normalization
independently verifies the GRS orbit and the ordinary \(z\)-fibres before
Frobenius closure.

The \(q=9\) kernel is further certified to have center order \(4\), derived
subgroup order \(24\), and element-order distribution
\[
 1^1\,2^7\,3^8\,4^{32}\,6^8\,8^{24}\,12^{16}.
\]
More precisely, its center is \(C_4\), its center quotient acts faithfully
on its four order-three subgroups and is therefore \(S_4\), and its
commutator subgroup has the order distribution of
\(\operatorname{SL}_2(3)\).  Thus it is an exact central \(C_4\)-extension
of \(S_4\) with commutator subgroup \(\operatorname{SL}_2(3)\).  This
intrinsic description avoids an ambiguous small-group catalogue label.

## Extra invariant exposed by the failure

The homogeneous shortened-transport intertwiner space is itself a
basis-free LC covariant.  Every additive block has a unique
linearized-polynomial decomposition
\[
 A(v)=\sum_{k=0}^{e-1}M_kv^{p^k},
\]
and the transport equations split as a direct sum over the Frobenius
exponent \(k\).  The exact fixed-party sector profile is
\[
\begin{array}{c|c|c}
\text{stratum}&k&\dim_{\mathbb F_p}\text{ and active coefficients}\\ \hline
q=25\text{ non-GRS}&0,1&4\ (xx,zz),\ 0\\
q=27\text{ non-GRS}&0,1,2&6\ (xx,zz),\ 0,\ 0\\
q=9\text{ non-GRS}&0,1&4\ (xx,zz),\ 4\ (xz,zx)\\
q=25\text{ GRS}&0,1&8\ (xx,xz,zx,zz)\text{ in each sector}.
\end{array}
\]
Thus the \(q=9\) mystery is not an undifferentiated eight-dimensional
accident.  Its ordinary field-linear sector is the expected diagonal
split-torus span, while its extra sector is purely off-diagonal and
Frobenius-twisted.  Equivalently, Frobenius exchanges the code and its Gale
dual with fixed party labels.  Sums of the linear diagonal and twisted
off-diagonal sectors are the genuinely nonsemilinear maps.  At the
\(q=25\) GRS boundary both Frobenius sectors instead carry the full matrix
algebra.

The off-diagonal jump has an exact divisor.  Put \(s=t^{p^k}\).  A
fixed-label diagonal association between \(C_s\) and \(C_t^\perp\) exists
exactly when
\[
 D_k(t)=((1-s)(1-t))^2+st=0.                    \tag{C623.1}
\]
Indeed, the nine entries of
\(H_s\operatorname{diag}(w_1,\ldots,w_6)H_t^{\mathsf T}=0\)
force, up to a common nonzero scalar,
\[
 (w_1,\ldots,w_6)
 =(-(1-s)(1-t),-(1-s)(1-t),1,1,-1,-1),
\]
and the final entry is precisely \(D_k(t)=0\).  For \(k=0\),
\[
 D_0(t)=(1-t)^4+t^2
 =t^4-4t^3+7t^2-4t+1=G(t),
\]
so the ordinary off-diagonal sector is exactly the GRS divisor.  For
\(q=9,k=1\), \(D_1\) vanishes at all four admitted non-GRS parameters and
produces exactly the extra \((xz,zx)\) sector.  The certificate checks
\(D_k=0\) iff an off-diagonal sector is active for every parameter and
Frobenius exponent in the three censused fields.

The diagonal sector is equally explicit.  Normalizing the first four
labeled columns projectively sends the last two to points depending only on
\[
 R(t)=\frac{t}{(1-t)^2}.
\]
Thus a fixed-label diagonal equivalence between \(C_s\) and \(C_t\) exists
exactly when \(R(s)=R(t)\), or
\[
 E_k(t)=(t^{p^k}-t)(1-t^{p^k+1})=0.             \tag{C623.2}
\]
Consequently, for every admitted parameter in odd characteristic, the
\(k\)-th fixed-party intertwiner sector is the direct sum of

- a \(2e\)-dimensional diagonal coefficient space iff \(E_k(t)=0\); and
- a \(2e\)-dimensional off-diagonal coefficient space iff \(D_k(t)=0\).

This accounts for every linear degree of freedom before imposing the
symplectic quadratic equations.  In particular, the \(q=9\) jump has
\(E_1\ne0,D_1=0\), while the \(q=25\) GRS boundary has
\(E_k=D_k=0\) in both sectors.

The failed reconstruction therefore leaves a sharper replacement invariant:
the complete twist-sector transport-commutant profile.  Any
quantitative-rigidity successor should treat its dimension-jump strata
separately; a uniform conditioning statement cannot silently identify them
with the generic split-torus stratum.

## Exact reduction

Write \(V_i=\mathbb F_q^2\) as a \(2e\)-dimensional symplectic
\(\mathbb F_p\)-space with trace form
\[
 \langle(x,z),(x',z')\rangle
   =\operatorname{Tr}_{q/p}(xz'-zx').
\]
Each four-party support \(S\) carries a two-dimensional shortened
\(\mathbb F_q\)-plane, and projection to any retained party is an
\(\mathbb F_p\)-linear isomorphism.  Let
\(R^C_{S,i\to j}:V_i\to V_j\) be the resulting transport.

For a party permutation \(\pi\), local blocks \(A_i\) must satisfy
\[
 A_jR^C_{S,i\to j}
   =R^D_{\pi S,\pi i\to\pi j}A_i.
\]
Choose party \(0\), propagate every \(A_i\) from \(A_0\), and impose the
remaining relations.  This is a homogeneous linear system over
\(\mathbb F_p\) in the \((2e)^2\) entries of \(A_0\).  The checker exhausts
its coefficient space, retains exactly the symplectic solutions on all six
parties, and directly verifies one accepted solution for every solution
permutation on the full prime-field-expanded CSS stabilizer Lagrangian.
A necessary, incidence-labelled holonomy trace filter removes permutations
but never accepts or rejects an equivalence by itself.

## All-extension-field orbit theorem

Let \(A_i:V_i\to V_{\pi i}\) be the additive symplectic blocks of a local
Clifford equivalence.  Each has a unique linearized-polynomial expansion
\[
 A_i(x,z)
 =\sum_{k=0}^{e-1}M_{i,k}(x^{p^k},z^{p^k}).
\]
The target CSS stabilizer equations are \(\mathbb F_q\)-linear, so uniqueness
of linearized polynomials makes the equations decouple by \(k\).  If one
entry of \(M_{i,k}\) is nonzero at one party, the four-party transport
relations propagate it nonzero to every party.  According to whether that
entry is \(xx,xz,zx,\) or \(zz\), it gives a nonsingular diagonal monomial
equivalence between
\[
 C_t^{(p^k)}\text{ or }(C_t^\perp)^{(p^k)}
 \quad\text{and}\quad
 C_u\text{ or }C_u^\perp,
\]
with the same party permutation \(\pi\).

The field-independent classical pencil quotient and its Gale invariance
therefore give \(z(u)=z(t)^{p^k}\).  At least one sector entry is nonzero
because the original \(A_i\) are invertible, proving necessity even when the
full map is a genuine sum of several Frobenius sectors.  Conversely,
\(z(u)=z(t)^{p^k}\) gives a projective/monomial equivalence from
\(C_t^{(p^k)}\) to \(C_u\); composing it with coordinatewise Frobenius gives
an additive local Clifford equivalence.  This proves the displayed
classification without reconstructing or preserving a Desarguesian spread.

For the \(q=25\) GRS parameters the nullspace has dimension \(16\), the
entire endomorphism algebra.  Hence its symplectic units are exactly
\(\operatorname{Sp}_4(5)\); an explicit nonsemilinear symplectic
transvection in the certificate passes the full-Lagrangian replay.  This
also exposes the valid conditional mechanism: whenever the
shortened-transport holonomies collapse to prime-field scalars, the
intertwiner algebra is the full prime-field endomorphism algebra and the
fixed-party kernel is the full additive symplectic group.  The certificate
proves that collapse for this \(q=25\) GRS boundary.  It does not infer the
same collapse for every GRS or diagonally isodual code.

## What the counterexample preserves

The nonsemilinear witnesses preserve every one of the fifteen shortened
four-party planes, all their transport and holonomy incidences, and the
full additive CSS stabilizer Lagrangian.  They fail the exact
\(\Gamma L_2(q)\) test: at least one local block is not linear after any
common Frobenius twist.  Since \(\Gamma L_2(q)\) is the normalizer of the
Desarguesian line spread, these blocks do not preserve that spread.  Thus
the shortened-plane configuration is strictly weaker than the spread it
was proposed to reconstruct.

## Reproducibility

Run from `rust/`:

```text
PYTHONDONTWRITEBYTECODE=1 python3 ../notes/2026-07-25-c623-ame-lu-extension-field-clifford.py --check
```

The generator uses only Python's standard library and canonical
low-to-high polynomial bases:
\[
 \mathbb F_9=\mathbb F_3[x]/(x^2+1),\quad
 \mathbb F_{25}=\mathbb F_5[x]/(x^2+2),\quad
 \mathbb F_{27}=\mathbb F_3[x]/(x^3-x+1).
\]
The tracked JSON records every parameter, orbit, kernel, solution count,
first witness, and exact group invariant.

Checksums and byte counts:

```text
8a0703b0458fad2c8e1b27fbdd660e23f73a80ee43ddd8e67b97f8fa10e4848f   64122  2026-07-25-c623-ame-lu-extension-field-clifford.py
4273fa355a507e2b1951e868f94f5431b2b469a60fc0af3d6426122a08a154a1  563719  2026-07-25-c623-ame-lu-extension-field-clifford.json
```

The trusted boundary is the standard-library finite-field and row-reduction
implementation.  The independent checks are exact projective
canonicalization, the direct full-Lagrangian replay of shortened-plane
witnesses, group closure/inverse/commutator checks for explicitly enumerated
kernels, and the full-endomorphism-algebra proof for the large
\(\operatorname{Sp}_4(5)\) kernels.  The certificate proves only the stated
finite fields.  The all-odd-prime-power admitted-pencil classification is
the separate linearized-polynomial argument above, not an extrapolation from
the census.  Neither result classifies arbitrary extension-field six-arcs.

## `ej` + `tt` closeout and mystery ledger

The closeout pass promoted two cheap consequences into the result rather
than leaving them as observations: the full \(q=25\) GRS boundary was added
to the initial non-GRS census, and its dimension-16 intertwiner algebra was
identified with the full \(\operatorname{Sp}_4(5)\) kernel.  It also checked
that the \(q=9\) counterexamples are genuinely nonsemilinear blockwise, not
merely semilinear with inconsistent Frobenius exponents.  The later explicit
extra-juice pass recognized the \(q=9\) kernel as the central \(C_4\)
extension of \(S_4\) described above and tightened the full-symplectic
statement to its exact prime-scalar-holonomy hypothesis.

- **Settled:** Galois-\(z\) gives the orbit partition in all three tested
  fields, after adjoining the single GRS class.
- **Settled:** Frobenius-sector decoupling upgrades the finite pattern to an
  all-odd-prime-power theorem on the admitted non-GRS pencil.
- **Settled:** Galois-\(z\) is not a complete description of the
  intertwiners; \(q=9\) supplies genuine nonsemilinear non-GRS maps.
- **Settled:** shortened marginal planes do not reconstruct the
  Desarguesian spread.
- **Settled:** the transport-commutant dimension gives a replacement exact
  invariant that detects both enlarged-kernel strata in the census.
- **Settled:** the formerly unexplained \(q=9\) degrees of freedom are the
  off-diagonal \(k=1\) Frobenius--Gale sector; the \(k=0\) sector remains the
  ordinary diagonal split-torus span.
- **Settled:** the exact jump equation is the twisted Gale divisor
  \(D_k(t)=((1-t^{p^k})(1-t))^2+t^{p^k+1}\); its untwisted specialization is
  the known GRS quartic.
- **Settled:** the diagonal twist equation is
  \(E_k(t)=(t^{p^k}-t)(1-t^{p^k+1})\), and together \(D_k,E_k\) account for
  every fixed-party additive intertwiner degree of freedom.
- **Settled:** the \(q=25\) GRS fixed-party kernel is the full
  \(\operatorname{Sp}_4(5)\), with an exact structural rather than sampled
  count.
- **Settled:** the \(q=9\) exceptional order-96 kernel has center \(C_4\),
  quotient \(S_4\), and commutator subgroup
  \(\operatorname{SL}_2(3)\).
- **Open mystery:** the exact central-extension class of the \(q=9\) kernel
  has not been matched to a catalogue identifier; the intrinsic structure
  above is sufficient for the falsifier.
- **Settled:** Galois-\(z\) remains the exact orbit invariant over every odd
  extension field; genuine nonsemilinear sums enlarge intertwiner groups but
  do not merge additional orbits.
- **Settled:** \(z=1\) alone does not control a jump; the missing fixed-label
  datum is exactly the vanishing of \(D_k\).
- **No unexplained linear fixed-party degree of freedom remains:** after the
  Frobenius-sector decomposition, \(E_k\) and \(D_k\) determine the entire
  intertwiner space.  Beyond the censused cases, the symplectic quadratic
  coupling when several twist sectors coexist may still produce distinct
  finite-group structures; that is a nonlinear classification question,
  not a missing linear parameter.
