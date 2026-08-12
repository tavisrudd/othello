# C909 — Proposition 2.4 relative gluing-local-system audit

Date: 2026-08-12

Status: **MAJOR proof seam, with a short exact repair.** This rereads only the
current epilogue source, in particular Proposition 2.4 and the preceding
six-axis construction. No manuscript, PDF, mirror, Lean, or ledger edit is
made here.

## Exact defect in the current proof

The last paragraph of Proposition 2.4 currently says that the rational and
exotic kernels are distinguished by their stabilizers under the fibrewise
\(A_5\)-action. That is false as written: the five points of
\(\mathbf P^1(\mathbf F_4)\) were defined as the \(A_5\)-stable principal
halves, so every one has full \(A_5\) stabilizer. The difference is instead
the stabilizer in the *source* \(S_6\): it is \(S_6\) for the rational three
and \(A_5\) for either exotic point.

More importantly, current Section 2 only gives the six axes and their
isogeny fibre by fibre. It does not construct the relative five-axis source,
its relative two-primary discriminant local system, or the actual quotient
kernel as a relative subgroup. Without those three objects, the phrase
“the geometric kernel is a finite sub-local-system” is an assertion rather
than a consequence. Connectedness alone cannot keep a section in a subset
that has not been shown monodromy-stable.

The minimal missing relative input is the following marked-axis lemma. It is
strictly weaker than a relative minimal cycle or a relative decomposition of
the diagonal.

> **Relative marked-axis lemma.** Let
> \(\mathcal J\to B^\circ\) be the intermediate-Jacobian abelian scheme of
> the universal nonstandard \(A_5\)-pencil, with the six fixed \(D_5\)
> subgroups used to form the axes. The five-axis construction supplies a
> relative polarized isogeny
> \[
>       a:\mathcal A\longrightarrow\mathcal J
> \]
> and, on the two-primary polarization kernel of \(\mathcal A\), an
> \(A_5\)-equivariant symplectic isomorphism of finite etale
> \(\mathbf F_2\)-local systems
> \[
>  \mathscr D_2:=\ker(\lambda_{\mathcal A})[2]
>       \simeq H_2\otimes_{\mathbf F_2}\mathscr V.       \tag{R}
> \]
> Here \(H_2\) is the constant four-dimensional six-point heart and
> \(\mathscr V\) is a rank-two \(\mathbf F_2\)-local system. The actual
> two-primary quotient kernel \(\mathscr K_2=\ker(a)_2\) is a relative
> maximal isotropic subgroup of \(\mathscr D_2\). At the geometric generic
> point, the marked coefficient source has its faithful permutation
> \(S_6\)-action, and the three \(\mathbf F_2\)-rational halves are fixed by
> that action.

For a source literally written as a relative elliptic power,
\(\mathscr V=\mathcal E[2]\). More generally (R) is the intrinsic
discriminant formulation and is unchanged by an etale cover used to identify
the six elliptic axes. It is exactly the relative statement that must be
proved from the norm-axis construction; the present fibrewise phrase
“after coherent identification” does not prove it.

## Short rigorous replacement proof

Assume (R), and write
\[
 \mathscr P=\mathbf P_{\mathbf F_4}
       (\mathbf F_4\otimes_{\mathbf F_2}\mathscr V).
 \tag{1}
\]
Fibrewise the calculation already printed in Proposition 2.4 identifies
\(\mathscr P\) with the set of \(A_5\)-stable maximal isotropic halves of
\(\mathscr D_2\). Hence \(\mathscr P\to B^\circ\) is a five-sheet finite
etale local system. Define
\[
 \mathscr P_{\rm rat}=\mathbf P_{\mathbf F_2}(\mathscr V),\qquad
 \mathscr P_{\rm ex}=\mathscr P\setminus\mathscr P_{\rm rat}.
 \tag{2}
\]
They have degrees three and two. Monodromy acts on (1) through
\(\mathrm{GL}(\mathscr V)\subset\mathrm{GL}_2(\mathbf F_2)\), whose
fractional-linear action preserves the three \(\mathbf F_2\)-points and
therefore their two-point complement. Thus (2) are finite sub-local systems.
The relative subgroup \(\mathscr K_2\) gives a section
\[
                  \kappa:B^\circ\longrightarrow\mathscr P. \tag{3}
\]

At the geometric generic point, a rational value of \(\kappa\) is invariant
under the full source \(S_6\). It therefore descends the source
\(S_6\)-action through the principally polarized quotient to an injection
\[
 S_6\longrightarrow\operatorname{Aut}(J_{\bar\eta},\Theta_{\bar\eta}).
 \tag{4}
\]
Indeed, if a source automorphism induces the identity after the quotient
isogeny \(a_{\bar\eta}\), then \(a_{\bar\eta}\circ(s-1)=0\). Its image is at
once connected and contained in the finite kernel of \(a_{\bar\eta}\), hence
is zero; so \(s=1\).
The exact Strong Torelli normalization needed here is
\[
 1\longrightarrow\{\pm1\}\longrightarrow
 \operatorname{Aut}(J_{\bar\eta},\Theta_{\bar\eta})
 \longrightarrow\operatorname{Aut}(X_{\bar\eta})\longrightarrow1. \tag{5}
\]
Do not write a direct-product identification unless it has separately been
fixed. The kernel of the composite of (4) with the last map in (5) is a
normal subgroup of \(S_6\) of order at most two. It is trivial, since \(S_6\)
has no nontrivial normal subgroup of that order. Thus \(S_6\) injects into
\(\operatorname{Aut}(X_{\bar\eta})=A_5\), impossible. The generic section
therefore lies in \(\mathscr P_{\rm ex}\).

Finally \(\kappa^{-1}(\mathscr P_{\rm ex})\) is open and closed in
\(B^\circ\), nonempty because it contains the geometric generic point.
The pencil smooth locus is connected, so it is all of \(B^\circ\). Therefore
every smooth fibre has exotic two-primary kernel. The two members can be
exchanged by monodromy; only their unordered pair is global, which is exactly
what the cycle argument uses.

## Replacement prose

Replace current lines 226--231 by the following, after inserting the
relative marked-axis lemma or an explicit proof of (R):

> The relative marked-axis construction identifies the two-primary
> discriminant with \(H_2\otimes\mathscr V\), where \(H_2\) is the constant
> six-point heart and \(\mathscr V\) is a rank-two
> \(\mathbf F_2\)-local system. Thus the five \(A_5\)-stable principal
> halves form the finite etale local system
> \(\mathscr P=\mathbf P_{\mathbf F_4}(\mathbf F_4\otimes\mathscr V)\).
> Its three rational points
> \(\mathbf P_{\mathbf F_2}(\mathscr V)\) and its two-point complement are
> sub-local systems, because monodromy acts through
> \(\mathrm{GL}_2(\mathbf F_2)\). The actual relative quotient kernel gives
> a section of \(\mathscr P\). At the geometric generic point it cannot be
> rational: a rational kernel is \(S_6\)-stable, so the principally polarized
> quotient would carry \(S_6\); Strong Torelli gives an exact quotient of its
> polarized automorphism group by \(\{\pm1\}\) onto the cubic automorphism
> group, hence an injection \(S_6\hookrightarrow A_5\), absurd. The section
> is consequently exotic generically, and connectedness of \(B^\circ\)
> forces it into the exotic two-point sub-local system on every smooth
> fibre.

This is the shortest proof that supplies every asserted transition:
five-sheet local system, generic exoticity, monodromy stability, and the
\(\pm1\) normalization.

## Audit verdict

* **Generic-exotic argument:** sound after replacing the direct-product
  wording by the exact sequence (5), provided the generic automorphism
  assertion \(\operatorname{Aut}(X_{\bar\eta})=A_5\) remains available.
* **All-fibres conclusion:** not established in the current source until
  (R) is constructed. The present \(A_5\)-stabilizer sentence cannot do this.
* **Cycle scope:** the relative marked-axis lemma concerns finite etale
  kernel data only. It neither supplies a horizontal minimal cycle nor
  strengthens the fibrewise \(CH_0\) conclusion.

## EJ + TT closeout and mystery ledger

The cheap structural compression is the tensor description
\(H_2\otimes\mathscr V\): it automatically gives the correct monodromy group
and the canonical three-plus-two decomposition, avoiding any appeal to a
generic-to-special “discrete choice” slogan.

* **Settled:** the correct object is a section of a five-sheet local system,
  not a “finite sub-local-system” by itself.
* **Open gate:** prove the relative marked-axis lemma (R) from the current
  norm-axis construction, including the relative quotient isogeny and its
  two-primary discriminant identification.
