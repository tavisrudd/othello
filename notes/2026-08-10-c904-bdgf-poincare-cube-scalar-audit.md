# C904 BdGF Poincare-cube / Fano scalar audit

**Date:** 2026-08-10
**Scope:** quarantined Annals-upgrade research; no manuscript or Lean change

## Executive verdict

The Beckmann--de Gaay Fortman integral-Fourier construction works exactly as
proposed through the Poincare-cube stage, including its sign.  It does not
produce the identity correspondence on the cubic.

Let (A=J(X)) be the five-dimensional intermediate Jacobian, let
(p=c_1(\mathcal P)) on (A\times A), and suppose an integral relative
minimal cycle (Z) represents (\Theta^4/4!).  On the generic fibre define

\[
 \tau=j_{1,*}Z+j_{2,*}Z-\Delta_*Z.
\]

Beckmann--de Gaay Fortman Lemma 3.5 and Theorem 3.8 imply

\[
 [\tau]=\frac{p^9}{9!},
 \qquad
 [\tau^{[7]}]=\frac{p^3}{3!},
\]

with **positive** sign.  Here ([7]) denotes the canonical seventh
Pontryagin divided power.

However, if (i:F\hookrightarrow A) is the Fano-surface Albanese embedding,
then

\[
 \int_{F\times F}(i\times i)^*\!\left(\frac{p^3}{3!}\right)
       i^*a\,i^*b
   =4\int_A\frac{\Theta^4}{4!}ab.
\]

Thus the pullback kernel is four times the principal symplectic pairing on
(H^1(A,\mathbf Z)).  With Shen's cubic convention the minimal class pairs
as the negative of the middle intersection form, so negating the pullback
cycle gives (+4\langle-,-\rangle_X).  Shen's Theorem 1.4 therefore yields
the multiplier-four middle projector, not the identity.

This route reproduces the already known two-primary/multiplier-four ceiling.
It does not remove the odd-index gate for Voisin's charge-three fourfold and
does not construct an odd zero-cycle on either that fourfold or
(\operatorname{Bl}_0\Theta).

The bounded audit used **zero full-text reads and four claim-specific partial
reads** listed below.  The integral-Fourier implication is directly
pre-empted by Beckmann--de Gaay Fortman; only the project-specific scalar-four
pullback computation is a new derivation here.

## 1. Exact sign of the seventh divided power

Beckmann--de Gaay Fortman write, for a principally polarized abelian variety
of dimension (g),

\[
 \tau=j_{1,*}(\Gamma_\Theta)+j_{2,*}(\Gamma_\Theta)
      -(\operatorname{id},\lambda)_*(\Gamma_\Theta).
\]

Their Lemma 3.5 proves

\[
 \tau=(-1)^{g+1}R_A,
 \qquad
 R_A=\frac{c_1(\mathcal P_A)^{2g-1}}{(2g-1)!}.
\]

For (g=5), this gives (\tau=R_A=p^9/9!).  In the proof of Theorem 3.8,
an integral lift (\Gamma) of (R_A) satisfies

\[
 (-1)^g E((-1)^g\Gamma)=\operatorname{ch}(\mathcal P_A),
\]

where (E) is the Pontryagin divided-power exponential.  At (g=5),

\[
 -E(-\tau)=\operatorname{ch}(\mathcal P_A).
\]

The dimension-seven component on the left is

\[
 -(-\tau)^{[7]}=+\tau^{[7]},
\]

and the codimension-three component on the right is (p^3/3!).  Hence the
sign is positive, not merely determined up to sign.

This is not a new integral-Fourier theorem.  Beckmann--de Gaay Fortman
Theorem 1.1 and Theorem 3.8 already establish the equivalence between an
integral minimal class, an integral lift of the Poincare Chern character,
and the associated integral Fourier transform.

## 2. Relative-family status

Moonen--Polishchuk Theorem 1.6 is stated for a monoid scheme over a field
whose multiplication is proper.  It does not print the fully relative
statement for an arbitrary abelian scheme over a positive-dimensional base.
Deninger--Murre provide relative rational Fourier theory for abelian schemes,
and Moonen--Polishchuk have relative divided-power results for Jacobians of
families of curves, but neither is the exact general integral relative theorem
needed to quote the construction globally without comment.

That gap is unnecessary for the generic-index application.  If (B) is the
smooth marked base and (K=\mathbf C(B)), restrict the relative minimal cycle
to the abelian variety (A_K/K).  Moonen--Polishchuk applies over this field,
constructing (\tau_K^{[7]}) canonically.  The resulting Chow cycle spreads
after shrinking (B).  Base-change compatibility follows at the generic
fibre from the geometric symmetric-power definition of the divided powers.

Safe formulations:

- **generic-fibre theorem:** fully justified by the printed absolute theorem;
- **cycle after shrinking the base:** justified by spreading out;
- **canonical integral relative Fourier transform on the whole marked base:**
  not supplied verbatim by the sources checked and would need a relative
  proof, especially at the boundary.

## 3. Pullback and correspondence operations

Over the smooth locus, (F\to B), (A\to B), and the Albanese embedding
(i:F\hookrightarrow A) are smooth/regular in the needed sense.  After
passing to the generic fibre:

1. (i\times i) is a morphism of smooth varieties, so the pullback of the
   codimension-three class (\tau^{[7]}) is defined in Chow;
2. the universal line (P\subset F\times X) is a proper correspondence;
3. transpose, intersection, and proper pushforward define the composite
   ((P\times P)_*(i\times i)^*\tau^{[7]}) without a refined-intersection
   anomaly.

These operations are therefore valid.  The failure is numerical, not
functorial.

## 4. Exact scalar-four calculation

Use a symplectic integral basis

\[
 e_1,f_1,\ldots,e_5,f_5
\]

of (H^1(A,\mathbf Z)), with

\[
 \Theta=\sum_i e_i\wedge f_i,
 \qquad
 p=\sum_i(e_i\wedge f_i'-f_i\wedge e_i').
\]

Roulleau Theorem 11 records the standard Fano class

\[
 [F]=\frac{\Theta^3}{3!}.
\]

For (a,b\in H^1(A,\mathbf Z)), pullback to (F\times F) gives

\[
 \begin{aligned}
 B(a,b)
 &=\int_{A\times A}
   \frac{p^3}{3!}\,a_1b_2
   \frac{\Theta_1^3}{3!}
   \frac{\Theta_2^3}{3!}\\
 &=4\,\omega_\Theta(a,b).
 \end{aligned}
\]

The exact exterior-algebra replay checks the full (10\times10) matrix,
not only one entry:

```sh
cd /home/tavis/src/othello
diff -u notes/2026-08-10-c904-bdgf-fano-pairing.out \
  <(python3 notes/2026-08-10-c904-bdgf-fano-pairing.py)
```

It returns (4J_{10}), four times the standard symplectic matrix.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c904-bdgf-fano-pairing.py` | 2716 | `16ec29a50970566eec340121d1e96c6f2c0aa9cf4ed4816f58b1a6a52663dbfe` |
| `notes/2026-08-10-c904-bdgf-fano-pairing.out` | 142 | `38395174aa015660505e9c33eb2e571edfc8a6dfa6c98887067e207ae1a56a07` |

The computation uses exact integer exterior algebra and asserts every matrix
entry.  Its independent check is the invariant formula: the result must be an
integral scalar multiple of the unique symplectic form, and direct evaluation
on (e_1,f_1) gives (864/(3!)^3=4).

## 5. Comparison with Shen's pairing

Shen Theorem 1.4 says that a symmetric one-cycle (\vartheta) on
(F\times F) supplies the cohomological decomposition criterion precisely
when

\[
 [\vartheta]\cdot \widehat\alpha\otimes\widehat\beta
 =\langle\alpha,\beta\rangle_X.
\]

In the proof of Proposition 5.7, Shen's sign convention identifies the
minimal class (c=\Theta^4/4!) by

\[
 \int_A c\,a\,b=-\langle\alpha,\beta\rangle_X.
\]

Consequently the unnegated BdGF pullback pairs as
(-4\langle\alpha,\beta\rangle_X), and its negative pairs as
(+4\langle\alpha,\beta\rangle_X).  The magnitude four is invariant under
all Abel--Jacobi and Poincare sign conventions.

Therefore this construction gives a fourfold middle projector.  Algebraic
Lefschetz summands can correct the non-middle Kunneth pieces, but they cannot
divide the middle scalar by four.  Obtaining the identity from this kernel
would require exactly the missing two-local division.

## 6. Red-team consequences

1. **No odd zero-cycle.**  The construction never meets the charge-three
   fourfold and provides no section or odd multisection of (M_9\to J).
2. **No primitive cycle on (\operatorname{Bl}_0\Theta).**  It constructs a
   Poincare kernel on (J\times J), whose natural Fano pullback is divisible
   by four as a cohomological correspondence.
3. **No alternate direct composition.**  A correspondence
   (X\leftrightarrow J) inducing the integral Abel--Jacobi isomorphism
   without passing through (F) is the universal cubic cycle being sought;
   assuming it would be circular.
4. **No choice-of-representative escape.**  The scalar-four calculation is
   cohomological.  Replacing (\tau^{[7]}) by any other algebraic lift of the
   same class (p^3/3!) changes the pullback only by a homologically trivial
   correspondence and cannot alter its action on (H^3(X,\mathbf Z)).
   Hence the obstruction is intrinsic to the Poincare-cube class, not to the
   Beckmann--de Gaay Fortman representative.
5. **Boundary remains separate.**  Spreading the generic cycle does not prove
   finite-flat or semiabelian extension across the cusps.
6. **Priority is occupied.**  Minimal class (\Rightarrow) integral
   Poincare Chern character is exactly Beckmann--de Gaay Fortman, built from
   Moonen--Polishchuk divided powers.  It cannot be presented as a Paper-V
   theorem.  The scalar-four Fano specialization is the useful new no-go.

## 7. Attribution correction

The desingularization theorem

\[
 M_X(v)\cong\operatorname{Bl}_0\Theta
\]

in arXiv:`2011.12240` is by **Arend Bayer, Sjoerd Viktor Beentjes, Soheyla
Feyzbakhsh, Georg Hein, Diletta Martinelli, Fatemeh Rezaee, and Benjamin
Schmidt**.  A contrary correction in an earlier version of this note was
wrong; the arXiv record, published paper, and cached PDF agree on this
seven-author list.  No manuscript was edited in this task.

## 8. Primary sources and read depth

1. **Thorsten Beckmann and Olivier de Gaay Fortman, _Integral Fourier
   transforms and the integral Hodge conjecture for one-cycles on abelian
   varieties_.**  Read depth: **partial**, arXiv version
   `arXiv:2202.05230`, Theorem 1.1, Lemmas 3.5--3.6, Theorems 3.7--3.8,
   Proposition 3.11 and proof.  Cache SHA-256
   `ab63a64cc5be9444c4eb36609f4831e662e0f95b19e9be07d5ddb5d7d82f9fbc`.
2. **Ben Moonen and Alexander Polishchuk, _Divided powers in Chow rings and
   integral Fourier transforms_.**  Read depth: **partial**, arXiv v1
   `arXiv:0904.3995`, introduction and Theorem 1.6.  Cache SHA-256
   `ecb7b3882c96609b1c66f8012fd1adc9dd61a82c936c7fbecd17f097192007c4`.
3. **Mingmin Shen, _Rationality, universal generation and the integral Hodge
   conjecture_.**  Read depth: **partial**, arXiv version
   `arXiv:1602.07331`, Theorem 1.4, Theorem 3.8, Theorem 5.1 and
   Proposition 5.7 with proofs.  Cache SHA-256
   `2e0f3a438379830b85e0e63fce9b6d85e621c3e3d1fbbe84a4a6117773c1007c`.
4. **Xavier Roulleau, _Fano surfaces with 12 or 30 elliptic curves_.**
   Read depth: **partial**, arXiv v1 `arXiv:1001.4855`, section 1.3,
   Theorem 11 and proof.  Cache SHA-256
   `6cfe901586441afa6d875d17bd4c33c6675705d6658848e9b82b5bd5fbd77bec`.

Direct searches, recorded verbatim:

- `relative Pontryagin divided powers Chow abelian scheme Moonen Polishchuk`
- `"abelian schemes" "PD-structure" Chow Pontryagin`
- `"divided powers" "abelian scheme" Chow ring Pontryagin`
- `Mingmin Shen Theorem 1.4 cubic threefold decomposition diagonal universal line correspondence`

The search located Deninger--Murre's rational relative Fourier theory and
Moonen--Polishchuk's relative Jacobian paper, but no printed general integral
relative-PD theorem stronger than the safe generic-fibre argument above.
MathSciNet and Google Scholar were not covered.  No global novelty negative is
claimed.

## 9. Mystery ledger

- **Settled:** the seventh divided power has the desired Poincare-cube class
  and positive sign.
- **Settled:** generic-fibre construction and spreading are legitimate; a
  global canonical boundary extension is not automatic.
- **Settled negatively:** the Fano pullback has scalar four, so the proposed
  identity bypass fails.
- **Still open:** an odd carrier intrinsic to the charge-three fourfold or a
  genuinely two-local primitive correspondence on
  (\operatorname{Bl}_0\Theta).
- **Still open:** finite-flat extension and deck descent of any eventual
  relative identity cycle.

**Vibe:** elegant but not decisive.  BdGF gives exactly the hoped-for integral
Poincare cube; the Fano surface then inserts a rigid factor four, exposing the
same two-primary obstruction in a new and very clean form.
