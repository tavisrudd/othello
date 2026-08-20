# Referee T: local topology and integral intersection cohomology

## 1. Verdict

**A -- accept.**  The link calculation, pair and Mayer--Vietoris arguments,
integral weak-Lefschetz step, and degree-three intersection-cohomology
identification are correct.  I found no mathematical repair needed on this
proof surface.  Two optional additions would make the coefficient and shift
conventions easier to audit.

## 2. Claim map

- **Lemma 2.1 (PDF p. 3):** verified integrally, including
  \(H^4(K,\mathbf Z)\simeq \mathbf Z^{10}\oplus\mathbf Z/3\) and the
  isomorphism \(H^3(X,\mathbf Z)\to H^3(K,\mathbf Z)\).
- **Proposition 2.2 / the exact-sequence part of Theorem 1.1 (PDF pp. 3--4,
  equations (5)--(6), and p. 2, equation (1)):** verified; local topology gives
  the kernel statement and reduces surjectivity of \(e^*\) to survival of all
  link classes, while Proposition 4.3 (PDF p. 6, equation (14)) supplies those
  classes integrally.
- **Corollary 1.3 (PDF p. 2 and Section 6, p. 7, equation (17)):** verified for
  traditional middle perversity with \(\mathbf Z\)-coefficients, in either the
  unshifted Deligne-sheaf normalization or the equivalent perverse shift.
- **Section 6 coefficient boundary (PDF pp. 7--8, especially equation (18) and
  the final paragraph before the AI disclosure):** correctly limits the
  integral conclusion to degree three and makes no integral decomposition-
  theorem assertion in the degrees where multiplication by three occurs.

## 3. Major findings

1. **The circle-bundle calculation is exact over \(\mathbf Z\).**
   **Location:** Lemma 2.1, PDF p. 3.  **Assertion:** for
   \(p:K=S(\mathcal O_X(-1))\to X\), one has
   \(H^1(K)=H^2(K)=0\), \(p^*:H^3(X)\xrightarrow{\sim}H^3(K)\), and
   \(H^4(K)\simeq\mathbf Z^{10}\oplus\mathbf Z/3\).  **Verification:** with
   Euler class \(-h\), the relevant Gysin fragments are
   \[
   H^0(X)=\mathbf Z\xrightarrow{\,-h\,}H^2(X)=\mathbf Zh,
   \]
   an isomorphism up to sign,
   \[
   0=H^1(X)\longrightarrow H^3(X)\xrightarrow{p^*}H^3(K)
     \longrightarrow H^2(X)\xrightarrow{\,-h\,}H^4(X),
   \]
   where \(h^2=3\ell\) makes the last map injective, and
   \[
   \mathbf Zh\xrightarrow{\,-3\,}\mathbf Z\ell\longrightarrow H^4(K)
     \longrightarrow H^3(X)=\mathbf Z^{10}\longrightarrow0.
   \]
   Hence the last line is
   \(0\to\mathbf Z/3\to H^4(K)\to\mathbf Z^{10}\to0\), which splits as a
   sequence of groups because the quotient is free.  This also shows precisely
   why the degree-four decomposition is noncanonical while the degree-three
   pullback is canonical.  **Severity:** verification, no defect.  **Smallest
   adequate remedy:** none.

2. **Every zero and injection in the pair and Mayer--Vietoris argument is
   justified integrally.**  **Location:** Proposition 2.2, PDF pp. 3--4,
   equation (6).  **Assertion:** \(H^3(M)\simeq H^3(U)\) and
   \(\ker(e^*)=b^*H^3(J)\).  **Verification:** local conical structure and
   excision give
   \(H^k(\Theta,U;\mathbf Z)\simeq\widetilde H^{k-1}(K;\mathbf Z)\).
   Since \(H^2(K)=0\), the pair sequence begins
   \[
   0\longrightarrow H^3(\Theta)\longrightarrow H^3(U)
     \xrightarrow{r_U}H^3(K).
   \]
   For \(M=U\cup N(X)\), the preceding Mayer--Vietoris term is
   \(H^2(K)=0\), so
   \[
   0\longrightarrow H^3(M)\longrightarrow H^3(U)\oplus H^3(X)
     \xrightarrow{\ r_U-p^*\ }H^3(K)
   \]
   is exact.  Lemma 2.1 makes \(p^*\) an isomorphism, so the last arrow is
   surjective and projection of its kernel onto \(H^3(U)\) is an isomorphism,
   with inverse
   \(a\mapsto(a,(p^*)^{-1}r_U(a))\).  Under this identification,
   \(e^*=(p^*)^{-1}r_U\), whence
   \(\ker e^*=\ker r_U=\operatorname{im}(H^3(\Theta)\to H^3(U))\).
   Equation (5) then identifies this image with \(b^*H^3(J)\).  Local topology
   alone does not imply surjectivity of \(e^*\); the manuscript says so and
   supplies it in Proposition 4.3, PDF p. 6, equation (14).  **Severity:**
   verification, no defect or circularity.  **Smallest adequate remedy:** none;
   optionally display the formula \(e^*=(p^*)^{-1}r_U\).

3. **The singular weak-Lefschetz range used in equation (5) is integral and
   sufficient.**  **Location:** PDF p. 3, equation (5), citing [GM88, Part II,
   Section 1.2].  **Assertion:** restriction gives
   \(H^3(J,\mathbf Z)\xrightarrow{\sim}H^3(\Theta,\mathbf Z)\).
   **Verification:** let \(L=\mathcal O_J(\Theta)\), let \(s\) cut out
   \(\Theta\), and choose \(m\) with \(L^m\) very ample.  In the embedding by
   \(|L^m|\), the hyperplane corresponding to \(s^m\) meets \(J\) in a scheme
   whose topological support is \(\Theta\).  The complement
   \(J\setminus\Theta\) is smooth, hence a local complete intersection.  The
   special case printed in Goresky--MacPherson, *Stratified Morse Theory*, Part
   II, Section 1.2, pp. 153--154, therefore gives
   \(\pi_i(\Theta)\to\pi_i(J)\) isomorphic for \(i<4\) and surjective for
   \(i=4\).  Equivalently \((J,\Theta)\) is 4-connected; relative Hurewicz and
   universal coefficients give \(H^q(J,\Theta;\mathbf Z)=0\) for \(q\le4\),
   yielding the asserted isomorphism in degree three.  No rationalization and
   no extra smoothness assumption on \(\Theta\) is used.  **Severity:**
   verification.  **Smallest adequate remedy:** none; an optional parenthesis
   explaining the \(L^m,s^m\) reduction would make the citation self-contained.

4. **The Deligne-sheaf cutoff gives exactly equation (17), with no hidden
   torsion or lower/upper-middle ambiguity.**  **Location:** Section 6, PDF p.
   7, equation (17), and Corollary 1.3 on p. 2.  **Assertion:**
   \(IH^3(\Theta,\mathbf Z)\simeq H^3(U,\mathbf Z)\simeq H^3(M,\mathbf Z)\).
   **Verification:** stratify the real 8-dimensional pseudomanifold \(\Theta\)
   by \(U\) and the singular point and write \(j:U\hookrightarrow\Theta\).
   For either traditional middle perversity,
   \[
   \bar m(8)=\left\lfloor\frac{8-2}{2}\right\rfloor=3
   =\left\lceil\frac{8-2}{2}\right\rceil=\bar n(8).
   \]
   In the unshifted normalization (constant sheaf in degree zero on \(U\)),
   the Deligne sheaf is
   \[
   \mathcal P_{\bar m}=\tau_{\le3}Rj_*\mathbf Z_U,
   \qquad
   IH^q(\Theta,\mathbf Z):=\mathbb H^q(\Theta;\mathcal P_{\bar m}).
   \]
   The truncation triangle shows that
   \(\mathbb H^q(\Theta;\mathcal P_{\bar m})\to
   \mathbb H^q(\Theta;Rj_*\mathbf Z_U)=H^q(U,\mathbf Z)\) is an isomorphism
   for \(q\le3\), in particular for \(q=3\).  In perverse normalization,
   \(IC_\Theta(\mathbf Z)=\mathcal P_{\bar m}[4]\) and the same convention is
   written
   \(IH^3=\mathbb H^{3-4}(\Theta;IC_\Theta(\mathbf Z))\).
   The unit map from the constant sheaf factors canonically through
   \(\mathcal P_{\bar m}\); under the displayed isomorphism, the induced map
   \(H^3(\Theta)\to IH^3(\Theta)\) is ordinary restriction to \(U\).  At the
   singular stalk, \(R^qj_*\mathbf Z_U\) has fibre \(H^q(K,\mathbf Z)\).  Thus
   \(H^3(K)=\mathbf Z^{10}\) lies at the retained boundary, whereas the
   \(\mathbf Z/3\subset H^4(K)\) lies above the cutoff and cannot alter
   \(IH^3\).  The Mayer--Vietoris isomorphism from finding 2 finishes the
   identification with \(H^3(M)\).  **Severity:** verification, no defect.
   **Smallest adequate remedy:** none; optionally add the two normalization
   formulas above after equation (17).

5. **The integral decomposition-theorem boundary is stated at the correct
   place.**  **Location:** Section 6, PDF p. 8, immediately after equation
   (18).  **Assertion:** the known decomposition is used only over
   \(\mathbf Q\), and no integral analogue is claimed in affected even degrees.
   **Verification:** the link calculation contains
   \(H^2(X)=\mathbf Zh\xrightarrow{\,h\cup-\,}H^4(X)=\mathbf Z\ell\),
   \(h\mapsto3\ell\), whose cokernel is the observed \(\mathbf Z/3\).  This is
   exactly an integral coefficient obstruction invisible in equation (18), and
   it is disjoint from the degree-three truncation calculation.  **Severity:**
   verification.  **Smallest adequate remedy:** none.

**Reproducible evidence.**  The reviewed PDF returned
`3822f928217df38e4ed3f4feb687d9036637dbc751bda3f792906df1196e36e5`
under `sha256sum papers/blown-up-theta-lattice/blown_up_theta_lattice.pdf`,
matching the sealed dossier.  Page-local text was checked with
`nix shell nixpkgs#poppler-utils --command pdftotext -f N -l N -layout ... -`
for each \(N=1,\ldots,8\).  The public Goresky--MacPherson PDF downloaded from
<https://www.math.ias.edu/~goresky/pdf/SMT.pdf> had SHA-256
`87ec78b5948ef42f7af568ecdda7a71c8bc8feed81af21564dccc07ab9b2387c`;
the Friedman--McClure convention source downloaded from
<https://faculty.tcu.edu/gfriedman/papers/SHEAVES-revision4.pdf> had SHA-256
`0d23f9144d5306ec8f0b25c2660846274a4e3d26fdd3f20e4a5a93594d940739`.

## 4. Minor findings

1. At equation (17), PDF p. 7, state explicitly whether \(IC\) is shifted by
   \([4]\) and define \(IH^q\) accordingly.  The existing sentence is correct,
   but the formula would preclude a common four-degree indexing
   misunderstanding.
2. At equation (5), PDF p. 3, a short parenthesis noting the very-ample-power
   reduction would expose why the cited hyperplane theorem applies to the
   support of an arbitrary ample divisor.
3. In Lemma 2.1, PDF p. 3, the decomposition
   \(H^4(K)\simeq\mathbf Z^{10}\oplus\mathbf Z/3\) is an abstract splitting;
   no canonical splitting is used, but saying “noncanonically” would be exact.

## 5. Literature boundary

Goresky--MacPherson, *Stratified Morse Theory*, Part II, Section 1.2,
pp. 153--154, establishes the relative homotopy range needed for equation (5)
once the ample divisor is represented as the support of a hyperplane section
under a very ample power.  It does not supply the paper's link Gysin or
Mayer--Vietoris calculation.

Friedman--McClure, “Intersection homology duality and pairings: singular, PL,
and sheaf-theoretic,” Section 4.2, printed p. 17, states the unshifted Deligne
construction
\(\tau_{\le\bar p(n)}Ri_{n*}\cdots\tau_{\le\bar p(1)}Ri_{1*}\)
over a Dedekind domain, hence covers \(\mathbf Z\) and fixes the truncation
convention used above.  Maxim's public book introduction confirms that the
book develops this Deligne-sheaf model and the decomposition package, but the
public introduction alone does not establish the exact degree-three formula;
the formula here follows directly from the Deligne construction and the
manuscript's computed link.  None of these sources implies an integral
decomposition theorem in the even degrees, and the manuscript appropriately
does not claim one.

I did not use these sources to assess the symplectic Smith-form calculation,
the clean exceptional restriction, or the Pontryagin endpoint beyond taking
the explicitly constructed integral lifts in Proposition 4.3 as the supplied
surjectivity input to the assigned topology interface.

## 6. Confidence

1. **Finding 1: high.**  Direct integral Gysin calculation using
   \(h^2=3\ell\); all kernels and cokernels are displayed above.
2. **Finding 2: high.**  Direct pair and Mayer--Vietoris diagram chase, with
   the only geometric input the tubular neighborhood and Lemma 2.1.
3. **Finding 3: high.**  Goresky--MacPherson, Part II, Section 1.2, printed
   pp. 153--154, plus the explicit \(L^m,s^m\) reduction.
4. **Finding 4: high.**  Direct Deligne truncation at
   \(\bar m(8)=\bar n(8)=3\), checked against Friedman--McClure, Section 4.2,
   printed p. 17; the link torsion is one degree above the cutoff.
5. **Finding 5: high.**  The obstruction is the explicitly recomputed cokernel
   of multiplication by three, and the PDF's disclaimer is unambiguous.

## 7. Publication recommendation

- **Default -- *Proceedings of the American Mathematical Society*:** recommend
  acceptance on the assigned proof surface.  The topology and integral-IH
  portion is compact, correct, and sufficiently self-contained; the three
  minor findings are optional precision edits rather than repairs.
- **Stretch -- *Algebraic Geometry*:** mathematically acceptable on the
  assigned proof surface.  For this venue I would strongly encourage the
  optional two-line expansion at equations (5) and (17), because the
  integral-coefficient and perverse-shift boundary is part of the paper's
  conceptual distinction from the rational decomposition result.
