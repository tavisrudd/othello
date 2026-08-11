# C904: symmetry-breaking Hecke pentad and log-boundary theorem

**Date:** 2026-08-10

**Status:** theorem-grade integral/log-boundary packet; the direct Prym
correspondence route is closed negatively at scalar two

**Scope:** the general stable-gluing packet, its \(A_5<S_6\) realization,
the four quartic--cubic cusps, and the conic-Prym factor audit.  No manuscript,
Lean, handoff, task-card, or commit change.

## Executive verdict

The quartic--cubic scalar-two isogeny has a canonical polarized extension at
every cusp as a morphism of the associated Raynaud/log one-motives.  Its log
degree remains \(2^{10}\), and the exact torus and lattice kernel packets are
now known.

It does **not** have a finite-flat kernel on the ordinary Neron models over
the whole compactified marked base.  At the two unramified cusps the ordinary
special-fibre kernel has only 64 geometric points, whereas the generic kernel
has order \(2^{10}=1024\).  The missing factor is retained by the log lattice,
not by the ordinary semiabelian fibre.

The result belongs to a general symmetry-breaking construction.  When the
stable mod-\(p\) gluing endomorphisms form \(\mathbf F_{p^r}\), the principal
gluings form a Hecke packet indexed by
\(\mathbf P^1(\mathbf F_{p^r})\).  A larger symmetry whose commutant drops to
\(\mathbf F_p\) selects the classical subpacket
\(\mathbf P^1(\mathbf F_p)\).  Every two distinct packet members are primitive
scalar-\(p\) Hecke neighbors.

For \(A_5<S_6\), this is a five-member packet

\[
 \mathbf P^1(\mathbf F_4)
   =\underbrace{\mathbf P^1(\mathbf F_2)}_{3\text{ classical quartic sheets}}
      \sqcup
     \underbrace{\{\omega,\omega^2\}}_{2\text{ exotic cubic sheets}}.
\]

It is a complete \(K_5\) of multiplier-four isogenies.  Every edge has Smith
type

\[
             (1,1,1,1,2,2,4,4,4,4)
\]

and kernel

\[
             (\mathbf Z/2)^2\oplus(\mathbf Z/4)^4.
\]

The tempting algebraic-correspondence bypass using conic bundles on both
sides is **DEAD at the primitive scalar**.  The integral Prym cylinder and
its transpose compose to \([2]\).  Consequently the natural divisor between
the two discriminant-cover Jacobians induces \(2\Phi\), not \(\Phi\).  It
does not remove the integral projector denominator.

## 1. General symmetry-breaking Hecke packet

Let \(p\) be prime.  Let \(\Lambda_0\) be a polarized lattice which is the
orthogonal sum of

- \(h\) symplectic planes with alternating matrix \(pJ_2\), and
- \(m\) unimodular symplectic planes.

Assume also that the generic rational \(G\)-equivariant polarized Hodge
comparisons are scalars.  This is the uniqueness hypothesis; the integral
Smith calculation below does not need it.

Assume the \(p\)-discriminant is \(U\oplus U\) as a module for a finite group
\(G\), with

\[
                   \operatorname {End}_G(U)=\mathbf F_{p^r},
\]

and assume the polarization adjoint fixes this field.  Equivalently for the
present purpose, the \(G\)-stable maximal isotropics are exactly the graphs

\[
 \Gamma_a=\{(u,au):u\in U\},\quad a\in\mathbf F_{p^r},
 \qquad \Gamma_\infty=0\oplus U.                              \tag{1.1}
\]

Let \(\Lambda_a\) be the self-dual overlattice selected by \(\Gamma_a\).

### Theorem 1.1: packet theorem

For distinct \(a,b\in\mathbf P^1(\mathbf F_{p^r})\), scalar multiplication by
\(p\) is the primitive integral comparison

\[
                         p\,\mathrm{id}:\Lambda_a\to\Lambda_b.
\]

It is a polarized similitude of multiplier \(p^2\) and has Smith type

\[
               (1^h,p^{2m},(p^2)^h).                        \tag{1.2}
\]

Here \(p^{,2m}\) means \(2m\) entries equal to \(p\).  In dimension
\(g=h+m\), its degree is \(p^{2g}\), with kernel

\[
          (\mathbf Z/p)^{2m}\oplus(\mathbf Z/p^2)^h.          \tag{1.3}
\]

Thus the \(p^r+1\) stable gluings form a complete graph of pairwise Hecke
neighbors.

If \(G\subset\widetilde G\) and
\(\operatorname {End}_{\widetilde G}(U)=\mathbf F_p\), then the
\(\widetilde G\)-stable, or **classical**, locus is exactly
\(\mathbf P^1(\mathbf F_p)\); the remaining \(p^r-p\) points are the
symmetry-breaking gluings.

### Proof

Distinct graphs in (1.1) intersect trivially.  On each defective plane a
symplectic discriminant change sends them to the two coordinate halves.  In
an ambient basis \(e,f\) with \(\langle e,f\rangle=p\), the corresponding
self-dual lattices have bases

\[
                         (e/p,f),\qquad(e,f/p).
\]

Scalar \(p\) is therefore \(\operatorname {diag}(1,p^2)\).  On each common
unimodular plane it is \(pI_2\).  Orthogonal sum gives (1.2), the polarization
multiplier \(p^2\), and (1.3).  Scalar one is not integral on a defective
plane.  The scalar-comparison hypothesis then proves uniqueness and
primitivity among rational Hodge comparisons.  The final assertion follows because a stable
graph is the graph of an endomorphism in the relevant commutant.  \(\square\)

This statement includes its necessary adjoint hypothesis.  The equality
\(\operatorname {End}_G(U)=\mathbf F_{p^r}\) alone would not imply that every
field scalar has isotropic graph if the polarization induced a nontrivial
involution on the field.

## 2. The \(A_5<S_6\) Hecke pentad

For the six-axis coefficient lattice at \(p=2\), the defective module has

\[
        \dim_{\mathbf F_2}U=4,\qquad
        \operatorname {End}_{A_5}(U)=\mathbf F_4.
\]

The enlarged \(S_6\)-symmetry cuts the commutant to \(\mathbf F_2\).  There
are \(h=4\) defective planes and \(m=1\) common unimodular plane.  Theorem 1.1
therefore gives the five-point packet and the displayed Smith type.

Over the common \(X_0(3)\) multiplicity curve, the identification is exact:

- the three points of \(\mathbf P^1(\mathbf F_2)\) are the three cyclic
  order-two choices, hence the three sheets of
  \(X_0(6)\to X_0(3)\) realized by the resolved \(S_6\)-quartic family;
- the two points \(\omega,\omega^2\) are the exotic Frobenius-conjugate
  gluings selected by the cubic square-root character.

The common three-primary gluing is unchanged.  Accordingly the disjoint
three-sheet classical cover and two-sheet exotic cover are the two geometric
parts of one fibrewise five-point Hecke packet.

There is an abstract

\[
                 \operatorname {PGL}_2(\mathbf F_4)\cong A_5
\]

acting on the five points.  This is only a discriminant-module symmetry.  It
does not lift to a geometric action permuting the quartic and cubic families:
the generic rational \(A_5\)-equivariant endomorphism algebra is
\(\mathbf Q\), so a non-scalar five-point permutation has no rational Hodge
lift.  No geometric ``hidden second \(A_5\)'' is licensed.

## 3. Common marked base and cusp widths

The scalar-two comparison is defined after the biquadratic marking

\[
 u^2=R(t)=-(6t-1)(10t-7),
\]

\[
 v^2=S(t)=-5(2t+1)(26t-11)(796t^2-596t+79).
\]

The \(R\)-cover branches at the original width-one and width-three cusps
\(t=7/10,1/6\), and the \(S\)-cover is unramified at all four cusps.  Hence
the primitive quartic widths \(1,2,3,6\) become

\[
                              2,2,6,6                         \tag{3.1}
\]

on the common marking cover.  The unramified \(S\)-sheets have identical
tables.

For the exact computation choose the rational quartic slope `zero`, the
exotic cubic slope `omega`, and the common three-primary slope `one`.  The
matrix

\[
                         A=\begin{pmatrix}1&0\\4&1\end{pmatrix}
\]

conjugates the standard \(\Gamma_0(6)\) cusp vectors to

\[
                  (1,4),(1,7),(1,6),(0,1).                   \tag{3.2}
\]

These correspond respectively to the original widths \(1,2,3,6\).

## 4. Polarized log one-motive extension

Let \(I_Q,I_X\) be the saturated vanishing lattices obtained by intersecting
the quartic and cubic principal homology lattices with the rational isotropic
space at a cusp.  The generic scalar-two map restricts to

\[
                           2I_Q\longrightarrow I_X.           \tag{4.1}
\]

It also induces a map on the quotient, or period, lattices
\(H_Q/I_Q\to H_X/I_X\).  Together these are the torus and lattice maps of the
Raynaud one-motives.  They commute with the primitive nilpotent monodromy and
respect its pairing with multiplier four.  Thus they give a canonical
polarized morphism of the associated log one-motives.  Both maps have finite
kernel or cokernel, so it is a log isogeny.

Canonicity is formal here: the generic \(A_5\)-equivariant isogeny is unique
up to sign, and a homomorphism of generic abelian varieties extends uniquely
to the Neron models.  The explicit lattice maps are its induced maps on the
identity torus and period lattice.

Write \(\Phi_Q,\Phi_X\) for the Neron component groups.  The following table
uses invariant-factor notation; `torus kernel` means the kernel on identity
tori, and `log lattice` means the finite cokernel of the period-lattice map.

| \(t\) | old/new width | torus kernel | \(\Phi_Q\) | \(\Phi_X\) | component kernel | log lattice | ordinary kernel size |
|---|---|---|---|---|---|---|---:|
| \(7/10\) | \(1/2\) | \(\mu_2\) | \(\mathbf Z/2\oplus(\mathbf Z/12)^4\) | \((\mathbf Z/3)^3\oplus\mathbf Z/6\) | \(\mathbf Z/2\oplus(\mathbf Z/4)^4\) | \(\mathbf Z/2\oplus(\mathbf Z/4)^4\) | 1024 |
| \(1/4\) | \(2/2\) | \(\mu_2^5\) | \((\mathbf Z/3)^3\oplus\mathbf Z/6\) | same | \(\mathbf Z/2\) | \((\mathbf Z/2)^5\) | 64 |
| \(1/6\) | \(3/6\) | \(\mu_2\) | \(\mathbf Z/2\oplus(\mathbf Z/4)^3\oplus\mathbf Z/12\) | \(\mathbf Z/6\) | \(\mathbf Z/2\oplus(\mathbf Z/4)^4\) | \(\mathbf Z/2\oplus(\mathbf Z/4)^4\) | 1024 |
| \(1/2\) | \(6/6\) | \(\mu_2^5\) | \(\mathbf Z/6\) | same | \(\mathbf Z/2\) | \((\mathbf Z/2)^5\) | 64 |

At every cusp the component cokernel has order two, hence is \(\mathbf Z/2\).
The log degree is constant:

\[
 |\ker(T_Q\to T_X)|\,
 |\operatorname {coker}(H_Q/I_Q\to H_X/I_X)|=2^{10}.        \tag{4.2}
\]

At the two ramified cusps the log kernel packet is

\[
       \bigl(\mu_2;\ \mathbf Z/2\oplus(\mathbf Z/4)^4\bigr),
\]

while at the two unramified cusps it is

\[
       \bigl(\mu_2^5;\ (\mathbf Z/2)^5\bigr).                \tag{4.3}
\]

### Corollary 4.1: ordinary finite-flat extension is impossible

At \(t=1/4,1/2\), the kernel of the map on ordinary Neron special fibres has
only

\[
                          2^5\cdot2=64
\]

geometric points.  A finite flat extension of the generic kernel over a
characteristic-zero DVR would have special-fibre length \(2^{10}\).  Hence
the ordinary Neron kernel is not finite flat at these cusps.  No global
finite-flat ordinary kernel exists over the compactified marked base.

At the other two cusps the point count is \(2^{10}\), which removes this
numerical obstruction but does not by itself prove flatness there.  The
uniform theorem is the log one-motive extension, not an ordinary finite-flat
kernel theorem.

## 5. Conic-Prym algebraic-correspondence audit

Let \(\widetilde\Delta_Q,\widetilde\Delta_X\) be the quartic and common-line
cubic discriminant covers, with Pryms \(P_Q,P_X\).  Write

\[
 j_Q:P_Q\hookrightarrow J(\widetilde\Delta_Q),\qquad
 j_X:P_X\hookrightarrow J(\widetilde\Delta_X).
\]

For an etale double cover, the Jacobian polarization restricts to twice the
principal Prym polarization.  Therefore

\[
                j_Q^\dagger j_Q=[2],\qquad
                j_X^\dagger j_X=[2],                         \tag{5.1}
\]

and \(j^\dagger=1-\sigma\) in the standard normalization.

Let \(\alpha:P_Q\dashrightarrow P_X\) be the scalar-one rational
quasi-isogeny, so \(\Phi=2\alpha\) is integral.  The proposed full-Jacobian
map

\[
 h=j_X\alpha j_Q^\dagger
   =j_X\alpha(1-\sigma_Q)                                   \tag{5.2}
\]

is indeed integral.  A divisor on
\(\widetilde\Delta_Q\times\widetilde\Delta_X\) represents it.  But composing
with the two integral conic cylinders gives on the Prym part

\[
 j_X^\dagger h j_Q
   =j_X^\dagger j_X\alpha j_Q^\dagger j_Q
   =2\alpha\,2
   =2\Phi.                                                    \tag{5.3}
\]

Thus:

> **Prym-factor obstruction.**  The canonical integral double-conic
> correspondence realizes \(2\Phi\), not \(\Phi\).  Realizing the primitive
> map would require either the nonintegral half-projector on the cubic Prym
> or an integral lift of the scalar-one map \(\alpha\).

This route is **DEAD** as a stand-alone proof of algebraicity of \(\Phi\).
If an independent integral correspondence inducing \(3\Phi\) were produced,
then subtracting the present \(2\Phi\) would give \(\Phi\).  The existing
six-axis identity \(F=3\Phi\) is an identity of homomorphisms/Hodge maps; its
primitive Chow representability is exactly the unresolved saturation gate,
so it cannot presently be used for this Bezout step.

## 6. Reproduction

Primary exact Sage computation, using a debris-free invocation:

```sh
nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("notes/2026-08-10-c904-quartic-cubic-boundary-kernels.sage").read()))'
```

Independent SymPy replay:

```sh
nix shell nixpkgs#sage -c sage -python \
  notes/2026-08-10-c904-quartic-cubic-boundary-kernels-replay.py
```

The replay hard-codes the independently exported rational and exotic
principal bases.  It reconstructs all four saturated isotropic
intersections, computes separate Smith decompositions, enumerates every
component-kernel element, and checks the table and constant log degree.  It
does not import the Sage construction.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-08-10-c904-quartic-cubic-boundary-kernels.sage` | 7,513 | `2a5c13042c6c9788e197a29d0512dbb3755fc71dc00933206f57827b36e69016` |
| `2026-08-10-c904-quartic-cubic-boundary-kernels.out` | 528 | `b6f58565bca76891b834a55b051176201a736e75dfb2920258553fd02bc16515` |
| `2026-08-10-c904-quartic-cubic-boundary-kernels-replay.py` | 7,542 | `a7f6285f2d688ff278bd4b59b47e3ed3f551959f9d6cd44e388eb827e9569409` |
| `2026-08-10-c904-quartic-cubic-boundary-kernels-replay.out` | 619 | `fbcbfc20956c6d991746f9162499d0d1980ad06c310ec185b606568569f6cc8e` |

## 7. Source ledger

This report newly read **zero sources at full-text depth**.  It reuses four
primary sources at the exact partial depths recorded in the earlier C904
literature audit; no novelty or priority claim is made here.

1. **Cheltsov--Kuznetsov--Shramov, _Coble fourfold,
   \(S_6\)-invariant quartic threefolds, and Wiman--Edge sextics_.**  Read
   depth: **partial**, introduction, Theorem 1.15, Sections 3.1 and 4.2,
   Theorem 4.4, Corollary 4.9, and Remark 4.5.  Used for the quartic conic
   bundle, admissible cover, and degenerations.  Cache key
   `arXiv:1712.08906`, SHA-256
   `14c94b0b671cf5e172893086fed33f6600a593d74a5a83efda5384978022c598`.
2. **Carocca--Gonzalez-Aguilera--Rodriguez, _Weyl Groups and Abelian
   Varieties_.**  Read depth: **partial**, construction, Remark 3.9,
   Proposition 4.1, Proposition 5.2, Theorem 5.4, and Remark 5.5.  Used for
   the root/weight family and \(\Gamma_0(6)\) marking.  Cache key
   `arXiv:math/0503340`, SHA-256
   `c8e4287a8173c8b5f9ed80187f3463dedcd8a23edeb9d74964357b7eb117cf11`.
3. **Beauville, _Varietes de Prym et jacobiennes intermediaires_.**  Read
   depth: **partial**, introduction, Proposition 2.8, and Theorem 3.6 with
   proof.  Used for the integral conic-component cylinder and its exact
   factor two.  Cache key `10.24033/asens.1329`, SHA-256
   `4cf7ebf67a7d0d58c643efdb2d090b3b5fb61b8b7a4dd8e8a743079e9600e1c0`.
4. **Nagel--Saito, _Relative Chow--Kunneth decompositions for conic bundles
   and Prym varieties_.**  Read depth: **partial**, introduction, Theorems 1
   and 2, Sections 1.5--1.7, 1.11, and 2.4.  Used to audit the rational
   anti-projector and reverse-cylinder normalization.  Cache key
   `arXiv:0806.1507`, SHA-256
   `fa369aa3512bcc82ef34b342ca2dd4ccc2150d28e23ddc42a32b8598ea3cd79f`.

## 8. Mystery ledger / `ej` + `tt`

- **Settled:** the five gluings are one Hecke pentad, with a precise
  \(3+2\) classical/exotic symmetry-breaking decomposition.
- **Settled:** the apparent hidden \(A_5\) is a local
  \(\operatorname {PGL}_2(\mathbf F_4)\) symmetry only; it has no generic
  rational Hodge lift.
- **Settled:** the scalar-two map extends canonically and polarized at every
  cusp in the log one-motive category.
- **Settled:** ordinary finite flatness fails at the width-two and width-six
  unramified cusps; the lost degree lives in the log lattice.
- **Settled:** the double-conic Prym construction gives exactly \(2\Phi\), so
  it does not close primitive algebraicity.
- **Open:** whether a genuinely integral Chow correspondence induces
  \(3\Phi\).  Exact gate: saturate the six-axis Hodge identity in relative
  Chow; if achieved, Bezout with the now-integral \(2\Phi\) closes \(\Phi\).
- **Open:** compatibility of the closure of any eventual primitive Chow
  correspondence with the chosen toroidal compactifications and vertical
  cycles.  The log homomorphism is settled; the cycle extension is not.

## Bottom line

The strongest clean boundary theorem is a polarized **log-Hecke pentad**,
not a finite-flat Neron-kernel theorem.  The quartic and cubic are two members
of a five-point symmetry-breaking packet; their primitive scalar-two isogeny
extends canonically through every cusp as a log one-motive isogeny with the
explicit kernel table above.  The natural conic-Prym algebraic construction
stops exactly at \(2\Phi\).
