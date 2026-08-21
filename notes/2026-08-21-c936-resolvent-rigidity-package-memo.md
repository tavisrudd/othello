# C936 memo: resolvent rigidity package

Date: 2026-08-21  
Lane: cubic-threefolds  
Status: strategy memo; no priority claim  
Scope: mathematics, literature position, and a proposed reorganization of
`papers/cubic-gluing-resolvent/`

## Executive recommendation

Recast the short companion around one rigidity mechanism:

\[
 \boxed{
 \text{elliptic two-division resolvent}
 \;\longrightarrow\;
 \text{five polarized gluings}
 \;\longrightarrow\;
 \text{symmetry filter}
 \;\longrightarrow\;
 \text{cubic landing or escape}.}
\]

The paper should no longer culminate merely in the identification of a
three-sheet root cover and a two-sheet discriminant cover.  It can prove that
these two resolvent pieces have different geometric fates:

\[
 \boxed{
 \begin{array}{c|c}
 \mathbf P^1(\mathbf F_2) &
 \text{three }S_6\text{-symmetric quotients outside the smooth cubic-IJ locus},\\
 \{\omega,\omega^2\} &
 \text{two marked presentations of the same cubic intermediate Jacobian}.
 \end{array}}
\]

This turns the packet theorem into a cubic-intermediate-Jacobian separation theorem and
explains why the geometric cubic kernel is exotic: within this five-gluing
packet, the exotic orbit is not decorative; it is the only orbit compatible
with cubic Torelli rigidity.

The now-certified boundary theorem supplies an independent compatibility
check.  At the chordal value, the hyperelliptic limit has Jacobian isogenous to the fifth
power of the same elliptic factor that controls the smooth resolvent packet.

## Proposed theorem package

### Theorem A: universal elliptic resolvent

Let \(S\) be connected with \(2\) invertible, and let \(E/S\) be an elliptic
scheme.  There is a canonical decomposition of finite etale covers

\[
 \mathbf P_{\mathbf F_4}
   (\mathbf F_4\otimes_{\mathbf F_2}E[2])
 =
 \mathbf P_{\mathbf F_2}(E[2])
 \sqcup D(E[2]),
\]

where \(D(E[2])\) is the complementary double cover.  The first summand is
the root cover of the two-division cubic.  The monodromy of the second is the
sign character, so it has the same class in
\(H^1_{\mathrm{\acute et}}(S,C_2)\) as the usual
orientation/discriminant cover.  There are two isomorphisms between those
double covers, exchanged by the deck involution; no preferred isomorphism is
asserted.  If \(6\) is invertible, then on a short Weierstrass chart their
common torsor class has Kummer equation

\[
 u^2=\operatorname{disc}(f_2)\sim\Delta_E.
\]

This is the portable arithmetic theorem.  It should be stated before any
cubic-specific material.

### Theorem B: cubic and modular realization

For the nonstandard \(A_5\)-cubic family, the actual elliptic norm axis
\(\mathcal E\) has

\[
 j(\mathcal E)=J(T)=\frac{(T+27)(T+3)^3}{T}.
\]

Over the universal cyclic-level-three stack \(\mathcal Y_0(3)\), the two
proper transitive quotient covers of the full \(\mathcal E[2]\)-torsor are

\[
 Y_0(6)\longrightarrow Y_0(3),
 \qquad
 X_{\rm sgn}(6)\longrightarrow X_0(3),
\]

and, for the normalized Hauptmodul

\[
 t_3=\left(\frac{\eta(\tau)}{\eta(3\tau)}\right)^{12},
\]

the sign cover is

\[
 \mathbf Q(X_{\rm sgn}(6))
 =\mathbf Q(t_3)(\sqrt{t_3}).
\]

The function-field formula lives on the common effective coarse analytic
curve underlying \(X_1(3)\) and \(X_0(3)\).  Their modular stacks differ:
\(-I\) lies in \(\Gamma_0(3)\) but not in \(\Gamma_1(3)\).  The cubic base
statement must remain distinct from the universal modular
statement: it depends on the independently established actual-axis comparison
and cubic period coordinate, including the required marked/stack-level
comparison rather than only equality of coarse curves.

On the actual oriented cubic pullback, the geometric exotic kernel supplies
a section of the sign torsor, so the pulled-back exotic double cover splits
into two sections.  It is not a connected transitive cover there.  The
rational root cover is connected only after invoking the separate theorem
that the actual mod-two monodromy is exactly \(A_3\), rather than merely
contained in \(A_3\).

### Lemma C: symmetry filter

Extract the following reusable principle.

Work on a geometric characteristic-zero fibre.  Let \((A,\lambda)\) be a
polarized abelian variety with a faithful action of a finite group \(N\) by
origin-preserving group automorphisms preserving \(\lambda\).  Let
\(K\subset\ker\lambda\) be an \(N\)-translated packet of finite maximal
isotropic subgroups, and let \((B_K,\lambda_K)\) be the induced principally
polarized quotients.  Put \(H=\operatorname{Stab}_N(K)\).  If
\(h\in H\) acts trivially on \(B_K\), then
\((h-1)(A)\subset K\).  The image of the group homomorphism \(h-1\) is
connected and finite, hence zero.  Faithfulness on \(A\) gives \(h=1\), so

\[
 H\hookrightarrow\operatorname{Aut}_{\rm gp}(B_K,\lambda_K).
\]

Suppose a Torelli-type locus \(\mathcal T\) has, at the point in question, an
exact sequence

\[
 1\longrightarrow Z\longrightarrow
 \operatorname{Aut}_{\rm gp}(B_K,\lambda_K)
 \longrightarrow\operatorname{Aut}_{\rm geom}(X).
\]

If \(B_K\in\mathcal T\), then

\[
 H/(H\cap Z)
\]

must occur faithfully in the automorphism group of the corresponding
geometric object.

This is elementary descent plus Torelli, but it is the conceptual bridge from
the finite packet to geometric non-landing.  State it abstractly only at the
level actually used; do not advertise a general theory of all Torelli loci.

### Theorem D: cubic-IJ separation of the five gluings

State the result fibrewise, or equivalently over the relative packet cover;
the rational triple is generally a nonconstant degree-three local system and
must not be presented as three global sections of the cubic base.  On a
geometric fibre, let \((A,\lambda_A)\) be the six-axis source.  Fix the
selected three-primary half and, for a sheet
\(L\in\mathbf P^1(\mathbf F_4)\), put

\[
 (B_L,\lambda_L)
 =A/(K_3\oplus K_{2,L}).
\]

Here primary orthogonality, \(|K_3|=3^4\), and
\(|K_{2,L}|=2^4\) make \(K_3\oplus K_{2,L}\) a maximal isotropic subgroup of
order \(6^4\) in \(\ker\lambda_A\).  Polarization descent therefore gives a
unique principal polarization homomorphism \(\lambda_L\) satisfying

\[
 q_L^\vee\lambda_Lq_L=\lambda_A,
 \qquad q_L:A\longrightarrow B_L.
\]

The statement is about polarization homomorphisms or classes; choosing an
actual symmetric theta line bundle also entails the usual theta-group
linearization choices.

Then:

1. If \(L\in\mathbf P^1(\mathbf F_2)\), the full \(S_6\)-action preserves
   \(K_3\oplus K_{2,L}\) and descends faithfully to
   \(\operatorname{Aut}_{\rm gp}(B_L,\lambda_L)\).  Such a ppav cannot be the
   intermediate Jacobian of a smooth cubic threefold.
2. An element of \(N_{S_6}(A_5)\setminus A_5\) exchanges the two exotic halves
   \(K_{2,\omega}\) and \(K_{2,\omega^2}\), fixes the selected
   three-primary half, and preserves the source polarization.  Hence
   \[
    (B_\omega,\lambda_\omega)
    \simeq(B_{\omega^2},\lambda_{\omega^2}).
   \]
   Since one is the actual intermediate Jacobian, both represent the same
   unmarked coarse cubic moduli point; their \(A_5\)-actions are conjugated by
   the normalizer element and hence differ by the outer automorphism.

For the first assertion, if \(B_L\simeq J(X')\), cubic Torelli gives a map

\[
 S_6\hookrightarrow\operatorname{Aut}(J(X'),\Theta)
 \longrightarrow\operatorname{Aut}(X')
\]

whose kernel is a normal subgroup of \(S_6\) contained in the central
\(\{\pm1\}\).  That kernel is trivial.  The Wei--Yu classification says
that every finite faithful cubic automorphism group embeds into one of six
maximal groups, whose orders are

\[
 9720,\ 648,\ 24,\ 16,\ 660,\ 360.
\]

Five are smaller than \(|S_6|=720\), while \(720\nmid9720\); none can contain
\(S_6\).  This excludes a faithful \(S_6\)-action on a smooth cubic
threefold.

Consequently the five-sheet packet is not a nontrivial degree-five
self-correspondence of the smooth cubic intermediate-Jacobian curve:

\[
 \boxed{
 \text{rational triple exits the smooth cubic locus; exotic pair becomes the
 diagonal after forgetting its marking}.}
\]

Use the term *gluing-isogeny packet* until the polarized isogeny type between
the quotients has been computed.  Calling it a Siegel Hecke correspondence
would currently assert more than has been proved.

### Theorem E: chordal compatibility

At the chordal value \(T=729/5\), general chordal degeneration theory says
that the limit is the genus-five hyperelliptic double cover branched over the
degree-twelve divisor cut on the singular rational normal curve by the actual
transverse term of the pencil.  For this pencil, choose a primitive fifth root
\(\zeta\) and the \(C_5\)-eigenline

\[
 p=[1:\zeta:\zeta^2:\zeta^3:\zeta^4:0].
\]

At

\[
 t_0=-\frac35-\frac65(\zeta^2+\zeta^3),
 \qquad t_0^2=\frac95,
\]

exact differentiation shows that the twelve-point orbit
\(Z=A_5p\) lies on the singular rational normal quartic and in \(Q=0\).
Quadratic evaluation on \(Z\) has rank nine, so the six quadrics through
\(Z\) are exactly the quadratic ideal of the quartic.  Their linear multiples
have degree-three rank twenty-two, while adjoining \(Q\) raises that rank to
twenty-three.  Thus \(Q\) does not vanish identically on the quartic.  Its
restriction is a nonzero section of \(\mathcal O_{\mathbf P^1}(12)\) already
vanishing at the twelve distinct points of \(Z\), so that orbit is exactly
the reduced transverse divisor.  Its standard icosahedral coordinate gives

\[
 C_{\rm ico}:\quad w^2=x(x^{10}+11x^5-1).
\]

Paulhus's decomposition then gives

\[
 J(C_{\rm ico})\sim E_{\rm ico}^{5},
 \qquad
 E_{\rm ico}:y^2=x(x^2+11x-1),
\]

and direct calculation gives

\[
 j(E_{\rm ico})
 =\frac{2^{14}31^3}{5^3}
 =J(729/5).
\]

Equality of \(j\)-invariants identifies the elliptic curves over \(\mathbf C\)
or \(\overline{\mathbf Q}\).  Equality over \(\mathbf Q\) would additionally
require a quadratic-twist check.

This closes the mathematical narrative: the elliptic source that
controls the smooth gluing packet is recovered as the elliptic isogeny factor
of the chordal hyperelliptic limit.

## One organizing moduli diagram

Write \(\mathcal C_{A_5}\) for the one-dimensional smooth-cubic parameter
curve and
\(\mathscr H=\mathscr H_{\rm rat}\sqcup\mathscr H_{\rm ex}\) for the relative
five-packet of principally polarized quotients.  The paper should organize
the results around

\[
 \begin{array}{ccc}
 \mathscr H_{\rm rat}\sqcup\mathscr H_{\rm ex}
   &\longrightarrow& \mathcal A_5\\
 \downarrow && \\
 \mathcal C_{A_5}. &&
 \end{array}
\]

Theorem D identifies the two images:

\[
 \operatorname{im}(\mathscr H_{\rm rat})
 \cap\mathcal J_{\rm cubic}^{\rm sm}=\varnothing,
\]

whereas the two exotic maps agree on the coarse cubic moduli curve after
forgetting the orientation marking.  On the unmarked moduli stack the
descended normalizer isomorphism gives a 2-isomorphism rather than literal
equality; on the \(A_5\)-marked stack the two points retain the outer twist.

This diagram is more useful than presenting the five-set, modular curve, and
Bruhat--Tits star as parallel analogies.  It records the actual logical flow:
the elliptic torsor constructs the packet, and the stabilizers decide its
geometric landing.

## Literature audit

### 1. Elliptic two-division and modular curves

The \(S_3\)-action on nonzero elliptic two-torsion, the discriminant quadratic
subfield of a cubic splitting field, the covers \(X_0(6)\to X_0(3)\), and the
eta Hauptmodul are classical.  They are not novelty claims.

Looijenga--Zi identify the relevant Winger elliptic period with the completed
level-three modular curve and prove full \(\Gamma_1(3)\) monodromy.  Their
family is related but distinct.  The proposed paper's contribution is the
pullback to the actual cubic norm axis and identification with the actual
principal gluing packet, not the existence of the modular curves themselves.

Source checked: E. Looijenga and Y. Zi, *Monodromy and period map of the
Winger pencil*, arXiv:2109.01810v2, Introduction, Theorem 1.1, Remark 4.7,
and Proposition 5.1; `partial`; cached text SHA-256
`d49c591df00b53d11cf9f763007fa800935503d732ee745e5509bbd909adf5f1`.

### 2. The \(A_5\)-special cubic curve

Hartlieb proves that the \(A_5\)-family gives a one-dimensional special
subvariety and notes that each intermediate Jacobian is isogenous to a fifth
power of an elliptic curve.  No two-division resolvent packet or symmetry
separation of its five polarized gluings occurs in the audited portions of
that source.

Hartlieb asks whether there exists \(G\subset\operatorname{GL}_5(\mathbf C)\)
such that \(\overline{J(M_G)}\) is special but there is no subgroup \(H\) with
\(M_G=M_H\) satisfying condition \((**)\).  The proposed paper does not
answer that question.  It instead refines the structure of the already-known
\(A_5\)-special curve.

Source checked: M. Hartlieb, *Special subvarieties in the locus of
intermediate Jacobians of cubic threefolds*, arXiv:2304.03214v2,
Proposition 5.7, Remark 5.8, Theorem 3.1, and the open question in the
introduction; `partial`; cached text
SHA-256
`3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01`.

### 3. Cubic Torelli and automorphism obstruction

Cubic Torelli identifies polarized automorphisms of a smooth cubic
intermediate Jacobian with cubic automorphisms together with the central
involution.  Wei--Yu classify finite groups acting faithfully on smooth cubic
threefolds; none of the six maximal groups contains \(S_6\).  These are
load-bearing imports for Theorem D.

Sources checked:

- L. Wei and X. Yu, *Automorphism groups of smooth cubic threefolds*,
  arXiv:1907.00392v2, Theorem 1.1/3.2;
  `partial`; cached text SHA-256
  `af0c873f9b794d854d5e6a193f7e5ca9eda7e3897b18fbd7cd312b9173345f30`.
- Hartlieb, arXiv v2, Theorem 3.1, for the Torelli and automorphism
  formulation; `partial`.

The non-landing argument itself is the application-specific synthesis:
kernel stabilizer \(S_6\), faithful descent, Torelli, and the classification.
No claim is made here that the literature lacks a logically equivalent
argument elsewhere; that would require a specialist priority audit.

### 4. Chordal degeneration

Casalaina-Martin--Grushevsky--Hulek--Laza prove the extension of the
intermediate-Jacobian map and describe the hyperelliptic limit of a general
chordal degeneration.  For the \(A_5\)-pencil, Theorem E supplies the
family-specific transverse-term calculation identifying the branch divisor
with the reduced icosahedral orbit.

Paulhus computes the Jacobian decomposition of this genus-five curve and its
elliptic factor.  The exact equality of that elliptic factor's \(j\)-invariant
with the cubic norm-axis value \(J(729/5)\) is the proposed paper's comparison,
not either imported theorem separately.

Sources checked:

- S. Casalaina-Martin, S. Grushevsky, K. Hulek, and R. Laza, *Complete
  moduli of cubic threefolds and their intermediate Jacobians*,
  arXiv:1510.08891v2, introduction and chordal/hyperelliptic discussion;
  `partial`; cached text SHA-256
  `d5b3c69094eee70d5486542952f394308e3aa4bdbc5762a85588ebae4b2d7753`.
- J. Paulhus, *Elliptic factors in Jacobians of hyperelliptic curves with
  certain automorphism groups*,
  DOI 10.2140/obs.2013.1.487, Theorem 2 and its proof; `partial`;
  cached text SHA-256
  `d45781c71c6f655acb795fbfb3d79402f39965ee75c2739aaff1432d549b0261`.
  The separately fetched errata list was read `partial` (Theorem 1 correction
  and corrected summary table); cached SHA-256
  `278f15c4ab3ea4483f30af1942d39934bc5ea890cf0e2093b54779c6a48407ba`.
  It does not list Theorem 2, but its host had an unverifiable TLS chain, so
  the errata bytes are an access caveat rather than an independently trusted
  seventh mathematical authority.

### 5. Higher-prime comparison

For \(G=\operatorname{PGL}_2(\mathbf F_\ell)\), the decomposition

\[
 \mathbf P^1(\mathbf F_{\ell^2})
 =G/B\sqcup G/C_{\rm ns}
\]

places the \(3+2\) split in the general Borel/nonsplit-Cartan pattern.  At
\(\ell=2\), \(C_{\rm ns}=A_3\) and its normalizer is all of \(S_3\), which is
why the nonsplit orbit becomes a double sign cover only at two.

Rebolledo--Wuthrich provide relevant nonsplit-Cartan modular context.  The
finite-set decomposition used here is elementary and should be proved
directly rather than attributed as their theorem.

Source checked: M. Rebolledo and C. Wuthrich, *A moduli interpretation for
the non-split Cartan modular curve*, arXiv:1402.3498v2, introduction and
Section 2; `partial`; cached text SHA-256
`10cee9475c4fc778526ef1d0c11bb8e73647b2305eb7897d7613ee7ca545eaed`.

### Literature conclusion

Full-text count: 0 of 7 named source records: six mathematical papers and the
separate Paulhus errata record.  All seven were read `partial`, with the exact
portions recorded above.  This bounded audit
supports the following conservative position:

- this memo claims no explicit literature problem as solved and makes no
  literature-wide absence or priority verdict;
- the strongest candidate contribution is the application-specific bridge
  from the actual cubic gluing packet to elliptic two-division, followed by
  the proposed symmetry-based landing/escape classification;
- the exact transverse-term certificate makes the chordal equality an
  unconditional source of independent geometric evidence and a strong final
  theorem;
- a specialist priority audit remains necessary before using words such as
  “first,” “new,” or “previously unknown.”

The discovery searches were not exhaustively screened and support no negative
verdict.  Search domain: arXiv and publisher/author-hosted primary sources for cubic
threefold intermediate Jacobians, the Winger pencil, chordal degenerations,
elliptic-factor decompositions, cubic automorphism classifications, and
nonsplit-Cartan modular curves.  Query families included `cubic threefold
intermediate Jacobian Hecke`, `A5 cubic threefold elliptic factor`, `Winger
pencil modular curve`, `cubic threefold chordal hyperelliptic degeneration`,
`S6 automorphism smooth cubic threefold`, and `nonsplit Cartan modular curve
P1(F_p2)`.  Individual examination stopped after the six directly
load-bearing papers had been checked; no claim depends on the unenumerated
search-result sets.  Paulhus's errata host had an unverifiable TLS chain, as
recorded above.  This is background and claim-calibration research, not a
convention-complete priority search.  A submission-level novelty sentence
would require its own screened-set and citation-graph audit in the owning
claim ledger.

## Red-team targets

The following points must survive review before promotion into the paper.

1. **Existence of all five ppav quotients.**  The manuscript must state
   unambiguously that fixing the selected three-primary half and varying each
   two-primary half produces a principal polarization, not merely a maximal
   isotropic finite module.
2. **Faithfulness after quotient.**  If a source automorphism acts trivially
   on a quotient, the connected image of its difference from the identity is
   contained in the finite kernel; hence the difference is zero.  This
   argument must be stated for every rational quotient, not only for the
   actual kernel by contradiction.
3. **Central Torelli kernel.**  The map from \(S_6\) to the cubic
   automorphism group has kernel normal in \(S_6\) and contained in
   \(\{\pm1\}\).  Explain why this kernel is trivial; do not merely compare
   orders.
4. **No \(S_6\) in the Wei--Yu list.**  Check subgroup exclusion, not only
   equality with the six maximal groups.  Divisibility of group orders is a
   sufficient exclusion here and should be displayed accurately.
5. **Exotic quotient isomorphism.**  Verify that the odd normalizer element
   fixes the selected three-primary half and preserves the polarization, so
   it really descends to a polarized isomorphism of the full quotients.
6. **Meaning of “same cubic.”**  The two exotic marked quotients are
   isomorphic as ppavs; cubic Torelli then gives the same unmarked cubic
   moduli point.  It need not give the same marked \(A_5\)-object.
7. **Hecke terminology.**  Do not call the five-source construction a
   classical Siegel Hecke packet without computing the induced polarized
   isogeny type between the principal quotients.
8. **Boundary scope.**  The \(S_6\) argument excludes smooth cubic
   intermediate Jacobians.  It does not exclude landing in the closure of
   that locus or identify the rational quotients.
9. **Stack versus coarse curve.**  Retain the distinction between
   \(X_1(3)\), \(X_0(3)\), their common coarse complex orbifold where
   appropriate, and marked cubic bases.
10. **Chordal transversality.**  The identification of the twelve branch
    points with the icosahedral orbit must use the actual transverse
    deformation of the chordal cubic, not only uniqueness of an abstract
    twelve-point \(A_5\)-orbit.

## Highest-value additional calculations

### A. Identify the rational quotients

The strongest next computation is the exact isomorphism or isogeny class of
the three \(S_6\)-symmetric ppavs.  Possibilities to test include a
decomposable ppav, a Jacobian or Prym attached to a singular curve, or a
special boundary point.  This would upgrade “escape from the smooth cubic
locus” to an exact destination theorem.

### B. Compute the inter-quotient polarized isogeny type

The five ppavs share the same non-principally polarized source, but this does
not by itself specify a standard Siegel Hecke double coset between them.
Compute the lattice correspondence between \(B_\omega\) and each rational
\(B_L\).  Only after this calculation should the paper use “Hecke” in its
title or main theorem.

### C. Compactified landing

After A, compare the rational quotients with the boundary strata in the
second Voronoi compactification used for cubic intermediate Jacobians.  This
is potentially high reach but should not delay the finite smooth-locus
theorem.

## Recommended architecture

1. Introduction: resolvent rigidity and the landing/escape theorem.
2. Universal \(S_3\)-resolvent of elliptic two-division.
3. The six-axis gluing source and its five principal quotients.
4. Symmetry filter and cubic-IJ separation.
5. Modular realization over level three.
6. Compactification and chordal compatibility.
7. General-prime comparison and Bruhat--Tits interpretation.
8. Scope, open destinations, and reproducibility.

The Bruhat--Tits star, golden terminology, and general-prime decomposition
should illuminate the theorem after it is proved; they should not carry the
logical spine.

## Title and claim discipline

Recommended title:

> **Resolvent rigidity for icosahedral cubic threefolds**

Possible subtitle:

> Elliptic two-division, modular gluing, and cubic-IJ separation

Recommended main claim:

> Universally, the principal gluing packet is governed by the two proper
> transitive quotient covers of the elliptic \(S_3\) two-division torsor: its
> cubic root cover and quadratic discriminant cover.  On the oriented cubic
> pullback, the geometric exotic section trivializes the sign torsor, so its
> two sheets become the outer-twisted exotic presentations.  The rational
> resolvent quotients are excluded from the smooth cubic
> intermediate-Jacobian locus by their \(S_6\)-symmetry, while the exotic
> pair gives two oriented presentations of the same cubic intermediate
> Jacobian.

Avoid, pending further work:

- “solution of an open problem”;
- “Hecke self-correspondence of the cubic locus”;
- “all two-isogenous neighbors”;
- “complete compactified correspondence”;
- “first” or “previously unknown.”

The proposed revision should remain a compact paper, approximately fourteen
to sixteen pages.  Its reach should come from the reusable symmetry filter
and the exact landing theorem, not from accumulating additional analogies.

## Red-team record

### Round 1

Two independent read-only reviews were run: a proof audit against the
six-axis source and a primary-source literature/positioning audit.

The proof audit found the cubic-IJ nonlanding argument sound after three
repairs: the five principal quotients now receive an explicit
polarization-descent paragraph; the symmetry filter is restricted to
geometric characteristic-zero fibres and formulated as
\(H/(H\cap Z)\); and the packet theorem is stated fibrewise or over the
packet cover rather than treating the rational triple as three global
sections.  It also forced stack-level precision for the exotic pair.

The literature audit found two material overstatements.  The exotic
complement has the orientation torsor's class but no preferred isomorphism
with a separately defined orientation cover.  The chordal identification
still requires the actual transverse term of the cubic pencil to cut a
reduced degree-twelve divisor on the singular rational normal curve.  The
memo now states the first with its two deck-related isomorphisms and labels
the chordal theorem conditional on that family-specific check.  The audit
also corrected the Paulhus title, Looijenga--Zi pinpoints, Hartlieb numbering,
stack/coarse modular distinction, source hashes, depth labels, and bounded
search provenance.

### Round 2

Two fresh read-only reviews cold-read the revised memo: one attacked theorem
dependencies and one assessed the proposed paper package and claim discipline.

The proof review found no critical defect and confirmed that the central
landing/escape theorem survives.  It identified one major residual ambiguity:
the connected universal \(S_3\) sign cover was being conflated with its
oriented cubic pullback, where the geometric exotic section splits it into
two sections.  The universal/pullback distinction is now explicit, and
connectedness of the rational cover is tied to the separate exact-
\(A_3\)-monodromy theorem.  The same pass replaced the informal complement
of the cubic-IJ locus by an image-disjointness statement and required the
Wei--Yu subgroup-order exclusion to appear in full.

The package review gave a **go** verdict for using this memo to revise the
paper and a **no-go** verdict for submission-level novelty claims at present.
It demoted the abstract symmetry filter from theorem to lemma, moved cubic-IJ
separation before modular uniformization, restricted the rigidity conclusion
to this five-packet, separated equality of \(j\)-invariants over
\(\overline{\mathbf Q}\) from equality over \(\mathbf Q\), and kept the
chordal statement out of the unconditional spine pending transversality.  It
also exposed that the discovery searches were not a convention-complete
priority audit.  The literature section now makes no absence verdict, treats
the query log only as claim-calibration background, and requires a separate
screened-set/citation-graph audit before any submission-level novelty sentence.

Final red-team status:

- central cubic-IJ landing/escape result: survives both rounds;
- universal-versus-oriented resolvent statement: repaired;
- literature positioning: suitable for a strategy memo, not a priority
  verdict;
- chordal compatibility: conditional at the end of round 2, subsequently
  discharged by the exact certificate below;
- use of “Hecke”: blocked until the polarized inter-quotient double-coset
  type is computed.

### Post-red-team chordal discharge

The remaining chordal condition was removed after the two review rounds.
The tracked script
`papers/cubic-gluing-resolvent/verification/chordal_transversality.py` works
over \(\mathbf Q(\zeta_5)\) and certifies:

- the selected eigenline lies over \(t^2=9/5\);
- its projective \(A_5\)-orbit has twelve points, all singular on the chordal
  member and all in \(Q=0\);
- quadratic evaluation has rank nine, hence the quadrics through the orbit
  have dimension six and equal the quadratic ideal of the rational normal
  quartic;
- their degree-three multiples have rank twenty-two;
- adjoining \(Q\) raises the rank to twenty-three.

Therefore \(Q|_C\neq0\).  Since it is a section of
\(\mathcal O_C(3)\simeq\mathcal O_{\mathbf P^1}(12)\) vanishing on twelve
distinct orbit points, its zero divisor is exactly that reduced orbit.  This
supplies the missing family-specific hypothesis in the general chordal-limit
theorem and makes Theorem E unconditional.

The closeout literature check also exposes a stronger free consequence.
Allcock--Carlson--Toledo identify nonzero restriction to the singular quartic
with a direction normal to the chordal locus.  Here the equality
\(I_Z(2)=I_C(2)\) reconstructs \(C\) scheme-theoretically from the embedded
branch orbit, hence reconstructs its secant chordal cubic.  The divisor \(Z\)
also determines the unique projective section of
\(\mathcal O_C(3)\simeq\mathcal O_{\mathbf P^1}(12)\) vanishing on it; by
projective normality this is the class of \(Q\) modulo \(I_C(3)\).  Thus the
twelve branch points determine both the central fibre and the projective
first-order normal direction.
