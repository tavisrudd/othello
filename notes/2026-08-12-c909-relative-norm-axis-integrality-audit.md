# C909 — relative six-axis norms: integral audit and exact repair

Date: 2026-08-12  
Status: conditional structural closure of the relative-isogeny gate; no
manuscript edit

## Verdict

The norm construction in
\(2026\text{-}08\text{-}12\text{-}c909\text{-}relative\text{-}six\text{-}axis\text{-}norm\text{-}construction.md\)
has a sound core.  It can construct a relative, integral five-axis isogeny
without first identifying the cubic multiplicity lattice with the displayed
Tate/Prym lattice.  It does **not** make the group-algebra norm equal to the
Rosati axis projector: the exact normalization is

\[
              n_H=\sum_{h\in H}h=2\,i_Hq_H.                 \tag{1}
\]

Here \(H\simeq D_5\), \(i_H:E_H\hookrightarrow J\) is the primitive
norm-image inclusion, and \(q_H=i_H^\dagger\) is its Rosati adjoint for the
principal polarizations.  Formula (1) is the necessary scalar repair.  It
leaves the image and the resulting isogeny unchanged, but it is essential
for the diagonal Gram entry \(q_Hi_H=[5]\).

With the two lemmas below printed, the construction proves

\[
 f:E^5\longrightarrow J,\qquad
 f^*\Theta=6I_5-J_5,\qquad
 |\ker f|=6^4,\qquad
 \ker f\subset E^5[6].                                    \tag{2}
\]

Thus it closes the relative *elliptic-power/isogeny* input needed by the
C909 cohomological graph theorem.  It does not, by itself, identify the
resulting elliptic scheme or its \(2\)-torsion with the explicit Tate/Prym
model; that separate comparison is still needed for the equation
\(r^2=T\) to mark the actual cubic kernel.

## 1. What is formal from the integral group action

Let \(\mathcal J/B\) be the relative intermediate Jacobian of the smooth
\(A_5\)-pencil, with its relative principal polarization, and let
\(H\cong D_5\) be one of the six self-normalizing subgroups.  The integral
endomorphism

\[
                     n_H=\sum_{h\in H}h\in\operatorname{End}_B(\mathcal J)
\]

is Rosati self-adjoint.  On rational homology it is \(10P_H\), where \(P_H\)
is the orthogonal projector onto

\[
 (W_5\otimes M_\mathbf Q)^H=W_5^H\otimes M_\mathbf Q,
 \qquad\dim W_5^H=1.
\]

Its image consequently has relative dimension one.  Standard
image/quotient theory for a constant-rank homomorphism of abelian schemes
gives an elliptic abelian subscheme

\[
                       E_H=\operatorname{Im}(n_H)\subset\mathcal J. \tag{3}
\]

The inclusion \(i_H:E_H\hookrightarrow\mathcal J\) is primitive on integral
homology: the quotient \(\mathcal J/E_H\) is an abelian scheme, hence
\(H_1(\mathcal J,\mathbf Z)/H_1(E_H,\mathbf Z)\) is torsion-free.  Give
\(E_H\) its canonical principal polarization and set

\[
                         q_H=i_H^\dagger:\mathcal J\to E_H. \tag{4}
\]

Then \(q_H\) is the quotient dual to the inclusion and has connected kernel.

For \(h\in H\), \(h n_H=n_H\), so \(H\) acts trivially on \(E_H\).  As
\(N_{A_5}(H)=H\), transport by \(g\in A_5\) gives a representative-independent
isomorphism

\[
                 E_H\xrightarrow{\sim}E_{gHg^{-1}}.
\]

This is the promised coherent identification of all six norm axes.  It is
integral and relative; no period marking or non-CM hypothesis is required.

## 2. The scalar that the norm does not hide

On the rational \(H\)-fixed line, \(n_H\) is multiplication by \(|H|=10\).
The self-adjoint endomorphism \(N_H=i_Hq_H\) has image \(E_H\), is zero on
its polarized orthogonal complement, and acts on \(E_H\) as \(q_Hi_H=[d]\).
Thus

\[
                         n_H=(10/d)N_H.                   \tag{5}
\]

The Roulleau fibre calculation gives \(d=5\), hence (1).  In particular,
the tempting assertion \(n_H=i_Hq_H\) is false by a factor of two.

There is a direct way to connect this calculation to the norm axes.  At one
generic fibre, Roulleau's \(D_5\)-elliptic fibration gives a connected
quotient \(\widetilde q_H:J\to\widetilde E_H\).  It is \(H\)-invariant on
homology; therefore its Rosati-dual image is the unique one-dimensional
\(H\)-fixed abelian subvariety, namely (3).  After identifying
\(\widetilde E_H\) with this image through its dual inclusion,
\(\widetilde q_H=q_H\), up to the harmless elliptic automorphism.  Hence
\(\widetilde q_H^*[0]=q_H^*[0]\), so Roulleau's fibre intersection
calculation applies to the maps in (4), not merely to a rationally isogenous
set of axes.

This comparison is the first lemma which must be printed.  Its connectedness
input can be stated as: the \(D_5\)-fibration has connected fibres and the
Fano Albanese map generates \(J\), so its induced elliptic quotient has
connected kernel.  Without this sentence, a hidden isogeny of the elliptic
target could change \(d\).

## 3. Exact Gram and the five-axis isogeny

After the preceding identification, Roulleau's fibre classes give

\[
                       q_Hi_H=[5],\qquad
                       q_Hi_{H'}=[-1]\quad(H\ne H') .       \tag{6}
\]

At a generic non-CM fibre, the entries in (6) are integers.  Since the
homomorphisms are relative and the relative Hom scheme is discrete, (6)
holds over the entire connected smooth base, including CM fibres.

Choose five axes and use their canonical transports from one \(E\).  Put

\[
          f=(i_{H_1},\ldots,i_{H_5}):E^5\longrightarrow\mathcal J.
\]

The five coefficient axes span \(W_5\) over \(\mathbf Q\); therefore \(f\)
is fibrewise an isogeny and hence a finite flat isogeny.  Equation (6) gives
the equality of *integral polarization homomorphisms*

\[
          f^\vee\lambda_\Theta f
            =\lambda_E\circ(6I_5-J_5).                     \tag{7}
\]

This is the required primitivity statement.  It is stronger than knowing
only the rational isotypic decomposition or the Smith type.

Let \(G=6I_5-J_5\).  Its Smith form is
\(\operatorname{diag}(1,6,6,6,6)\).  From (7),

\[
 \deg(f)^2=\deg(\lambda_E\circ G)=\det(G)^2=6^8,
 \quad\text{so}\quad \deg f=6^4.                            \tag{8}
\]

Moreover \(\ker f\subset\ker(\lambda_E\circ G)\), and the Smith form shows
\(\ker G\subset E^5[6]\).  Therefore

\[
          K=\ker f\subset E^5[6],\qquad |K|=6^4.             \tag{9}
\]

Because \(\lambda_\Theta\) is principal, \(K\) is a maximal isotropic
subgroup of the polarization kernel \(\ker(\lambda_E\circ G)\).  The
polarization kernel has order \(6^8\), so the order in (9) is exactly the
maximal-isotropic square root.

## 4. Relation to the Gamma_0(3) two-endpoint lemma

The norm construction avoids a false shortcut but does not make the
two-endpoint theorem redundant:

* It **does** construct a concrete primitive elliptic subvariation
  \(H^1(E_H,\mathbf Z)\), the integral isogeny (2), and the actual finite
  kernel.  No rational tensor-product lattice needs to be guessed for this.
* It does **not** prove a rational isomorphism
  \[
    H^1(E_H,\mathbf Q)\simeq
    H^1(E_T^{D},\mathbf Q)
  \]
  with the explicit Tate/Prym factor.  Equality of \(j\)-maps or
  Picard--Fuchs equations is insufficient.
* Once that comparison is constructed, Theorem B says that the norm-axis
  lattice has only the two \(3\)-adic endpoint possibilities.  One primitive
  pairing (equivalently, the saturation index of the comparison on one fibre)
  then chooses the endpoint and fixes the scalar.  The norm formula
  \(n_H=2i_Hq_H\) and (6) are the natural geometric normalizations against
  which that datum must be measured.

Thus the norm construction closes the relative graph presentation.  The
remaining comparison is needed only for the sharper modular/Fricke statement,
including the claim that the minimal two-primary marking cover of the
*actual* \(K\) is the displayed discriminant cover \(r^2=T\).

## 5. Remaining precise gates

1. **Norm-axis/Roulleau comparison.**  Print the connected-quotient argument
   preceding (6), including
   \(D_H|_S=q_H^*[0]|_S=F_H\).  This is the only scalar/primitivity gap in
   the norm proof.
2. **Actual Tate/Prym identification.**  Produce a family isomorphism (or
   an explicit isogeny with controlled \(2\)-torsion) from the norm elliptic
   scheme \(E_H\) to the van Geemen--Yamauchi Prym model.  A quadratic twist
   is harmless for \(E[2]\), but the comparison itself must be given.
3. **Graph marking.**  After (2), full \(6\)-level makes \(K\) a constant
   graph.  To identify the smaller exotic-sheet cover with \(r^2=T\), use
   Gate 2 and the Tate two-division discriminant.  The group-theoretic
   argument already proves that the actual generic two-primary kernel is in
   the exotic pair.
4. **Horizontal Chow cycle.**  Still independently requires
   \(K\)-linearized coefficient line bundles.  Neither (2) nor a finite
   level cover automatically trivializes the associated relative Picard
   torsors.

## Consequence

The corrected headline is:

> Integral \(D_5\)-norms canonically produce the six relative elliptic axes.
> Their Rosati normalizations are half the norms, and Roulleau's fibre
> intersections then give a relative isogeny with pullback polarization
> \(6I_5-J_5\).  Hence the cubic pencil has an actual finite-etale
> self-dual graph kernel after finite level.  The explicit modular
> discriminant name of its exotic marking remains a separate Tate/Prym
> comparison.

This is materially stronger than the prior fibrewise construction while
keeping the modular and relative-Chow claims at their correct proof gates.

## Pointers

* \(2026\text{-}08\text{-}12\text{-}c909\text{-}relative\text{-}six\text{-}axis\text{-}norm\text{-}construction.md\)
  is the proposed construction audited here.
* \(2026\text{-}08\text{-}10\text{-}c904\text{-}integral\text{-}multiplicity\text{-}lattice\text{-}ceiling.md\),
  Sections 2 and 5--7, separates the \(\Gamma_0(3)\) endpoint result from
  the missing comparison with the explicit Prym system.
* \(2026\text{-}08\text{-}10\text{-}c904\text{-}annals\text{-}ceiling\text{-}dossier.md\),
  Sections 1 and 8, records the Roulleau Gram calculation and the prior
  warning that degree data alone do not select a kernel.
