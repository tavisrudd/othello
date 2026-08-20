# C931 referee G — cubic theta divisor and Fano geometry

## 1. Verdict

**A — accept.**  I find no geometric defect in the cubic-theta or Fano-surface
input and no break in the endpoint-lift construction.  The two useful changes
below are optional clarifications, not mathematical repairs.

## 2. Claim map

- **Theorem 1.1 (printed pp. 2, 6; (1)–(3), Proposition 4.3 and (14)).**  The
  Fano difference correspondence supplies ten integral classes restricting to
  a basis of \(H^3(X,\mathbf Z)\), and their Gysin images have precisely the
  claimed divided-power representatives; this geometric input to the fibre
  product checks out.
- **Theorem 1.2 (printed pp. 2, 7).**  The packet-G contribution to the escape
  lattice theorem is sound: the exceptional restriction directions really are
  the ten integral directions furnished by Proposition 4.3; the subsequent
  dual-lattice argument is outside this packet.
- **Corollary 1.3 (printed pp. 2, 7; (17)).**  Proposition 4.3 validly supplies
  the surjectivity used in the final exact sequence; the integral
  intersection-cohomology convention itself is outside this packet.

## 3. Major findings

1. **The classical cubic-theta model is used at exactly the available
   strength.**  Location: printed p. 1, §1, first two paragraphs, and printed
   p. 5, §4, opening paragraph and blow-up diagram.  The assertions are the
   unique ordinary triple point, projectivized tangent cone \(X\), smooth
   blow-up with exceptional normal bundle \(\mathcal O_X(-1)\), the Albanese
   embedding, the tangent-bundle/universal-line identification, degree six of
   the difference map, and \([F]=\theta^{[3]}\).  Beauville proves the
   Albanese map is an embedding in the corollary after Proposition 3 (printed
   p. 201), identifies \(\mathbf P(TF)\) with the universal line in
   Proposition 4 (p. 202), constructs the blow-up lift and proves the tangent
   cone reduced in Proposition 6 (pp. 204–205), and states the unique triple
   point theorem on p. 205.  His Propositions 7 and 8 (p. 206) give
   \([F]=\theta^3/3!=\theta^{[3]}\) and generic degree six.  A smooth cubic
   projectivized tangent cone makes the point an ordinary triple point and its
   blow-up smooth; the exceptional normal bundle is the tautological
   \(\mathcal O_X(-1)\).  **Verification:** complete.  **Severity/remedy:** no
   defect; no remedy.

2. **The shorter multiplicity-one argument is sufficient; no missing local
   calculation is needed.**  Location: printed p. 5, Lemma 4.1, proof before
   (12).  Injectivity of \(a:F\hookrightarrow J\) gives
   \(\psi^{-1}(0)=\Delta\).  Together with \(bq=\psi\mu\) and
   \(b^{-1}(0)=X\), this gives \(q^{-1}(X)=P\) set-theoretically.  Since \(Y\)
   is smooth and \(P\) is prime, the effective Cartier pullback has the form
   \(q^*X=mP\).  Under Beauville's Proposition 4/Proposition 6 identification,
   \(q|_P=p\); on a fibre \(C\simeq\mathbf P^1\) of
   \(P=\mathbf P(TF)\to F\), \(p|_C\) is the isomorphism onto the corresponding
   line in \(X\).  Hence
   \(\deg(\mathcal O_Y(P)|_C)=-1\) and
   \(\deg(q^*\mathcal O_M(X)|_C)=\deg(\mathcal O_X(-1)|_{p(C)})=-1\).
   Restricting \(q^*X=mP\) to \(C\) gives \(-1=-m\), so \(m=1\).  This is a
   global Cartier-divisor proof, stronger than a merely generic degree
   comparison.  **Verification:** complete.  **Severity/remedy:** no defect;
   an optional two-clause clarification is listed below.

3. **The clean-restriction identity is integral and has the correct normal
   data.**  Location: printed p. 5, Lemma 4.1 and (12).  The Cartier equality
   \(q^*X=P\) identifies
   \(q|_P^*N_{X/M}=N_{P/Y}\); all spaces and embeddings are complex, so the
   Thom classes have canonical compatible integral orientations.  Thus
   \(q^*e_*=j_*p^*\) over \(\mathbf Z\), with no index or sign ambiguity.
   Pairing against a class on \(X\), then applying adjunction and projection,
   gives
   \[
   e^*q_*\mu^*T=p_*j^*\mu^*T=p_*\pi^*\Delta^*T.
   \]
   The other identity follows integrally from \(bq=\psi\mu\), the projection
   formula, and \(\mu_*\mu^*=1\).  **Verification:** complete.  **Severity/remedy:**
   no defect; no remedy.

4. **The endpoint construction gives ten integral lifts and does not assume
   full transfer surjectivity.**  Location: printed p. 5, (11) and Lemma 4.1;
   printed p. 6, Lemma 4.2, (13), Proposition 4.3 and (14).  Clemens–Griffiths
   set up the integral cylinder/adjoint correspondences in §2, especially
   (2.7)–(2.9) on printed p. 291, and prove that the induced
   \(\operatorname{Alb}(F)\to J(X)\) is an isomorphism in Theorem 11.19 on
   p. 334 (introduced in (11.1), p. 329).  Therefore
   \(\pi_*p^*:H^3(X,\mathbf Z)\to H^1(F,\mathbf Z)\) and its unimodular adjoint
   \(p_*\pi^*:H^3(F,\mathbf Z)/\mathrm{tors}\to H^3(X,\mathbf Z)\) are integral
   isomorphisms.  For each \(\gamma\), choosing a single \(\beta\) with
   \(p_*\pi^*\beta=\gamma\) and setting
   \(u_\gamma=q_*\mu^*(\beta\otimes1)\) gives the restriction by finding 3.
   The factor order is also correct:
   \(\psi_*(\beta\otimes1)=(-1)_*(a_*\beta)\star[F]\).  Inversion acts by
   \(-1\) on the degree-nine class \(a_*\beta\); replacing
   \(\beta\otimes1\) by \(1\otimes\beta\) reverses that one global sign while
   \(\Delta^*\) remains \(\beta\).  The divided-power calculation (13) has
   unit coefficients, so no denominator is introduced.  Taking a basis of
   the free rank-ten group \(H^3(X,\mathbf Z)\) yields exactly ten endpoint
   lifts.  Nothing here asserts that arbitrary classes of \(H^3(M,\mathbf Z)\)
   lie in the image of the full degree-six transfer.  **Verification:**
   complete.  **Severity/remedy:** no defect; no remedy.

## 4. Minor findings

1. At printed p. 5, immediately after defining \(p:P\to X\), it would help to
   say explicitly: “Under the classical tangent-bundle identification,
   \(q|_P=p\).”  This is already implicit in the next display and in the cited
   model.
2. In the proof of Lemma 4.1, the sentence before the fibre-degree comparison
   could read: “Since \(P\) is prime and is the set-theoretic inverse image,
   \(q^*X=mP\) for some \(m\geq1\); restriction to a fibre gives
   \(-1=-m\).”  This makes the Cartier step visible without adding a new
   argument.
3. The broad citation “[CG72, Bea82]” on printed p. 5 is correct, but replacing
   it with Beauville, Proposition 4 and Propositions 6–8, plus
   Clemens–Griffiths, Theorem 11.19, would make the proof faster to audit.

**Mystery ledger (ej+tt closeout).**  No genuine mystery remains within packet
G.  The closeout specifically retested whether the fibre-degree argument was
only generic, whether integral Thom pullback hid an excess factor, and whether
switching the two Fano factors changed the exceptional restriction.  Findings
2–4 settle all three: the Cartier equality is global, the normal line bundles
agree, and diagonal restriction is unchanged while only the global endpoint
sign flips.

## 5. Literature boundary

Beauville establishes the precise classical geometric package used here: the
Abel–Jacobi embedding, projectivized tangent bundle as universal line, the
blow-up map over the difference morphism, reduced cubic tangent cone and unique
triple point, minimal class, and degree six.  Clemens–Griffiths establish the
integral correspondence formalism and the isomorphism
\(\operatorname{Alb}(F)\simeq J(X)\), which is enough to make the cylinder map
and its adjoint unimodular over \(\mathbf Z\).

Those sources do **not** state the manuscript's clean pull-push formula (12),
its divided-power endpoint identity (13), the individual classes (14), or the
mod-two fibre-product lattice (3).  These are deductions made in the
manuscript and checked above; they should not be attributed to the classical
papers.  The public CU Boulder profile was used only to set the
cubic-threefold/theta-singularity emphasis of this cold read; no voice,
opinion, or endorsement is attributed to Sebastian Casalaina-Martin.

## 6. Confidence

- **Finding 1: high.**  Direct comparison with Beauville, printed pp. 201–206,
  Propositions 4 and 6–8 and the theorem on p. 205.
- **Finding 2: high.**  The support-plus-fibre-degree calculation determines
  the unique divisor multiplicity, using Beauville's universal-line
  identification.
- **Finding 3: high.**  Equality of the effective Cartier divisors identifies
  the normal line bundles, and the displayed pairing computation verifies the
  integral pull-push formula.
- **Finding 4: high.**  Clemens–Griffiths, printed pp. 291, 329, and 334,
  supplies the integral isomorphism; the two factor orders and the
  divided-power coefficient can be checked on a symplectic basis exactly as
  in Lemma 4.2.

The evidence is reproducible from the sealed objects.  The manuscript hash is
`3822f928217df38e4ed3f4feb687d9036637dbc751bda3f792906df1196e36e5`;
the Beauville and Clemens–Griffiths cache hashes are respectively
`4596f46edfdf9b69fd295581119faf814ad67a1e3d87592aa0146aaf225ea90a`
and `6cfe96ecb81179ce2756cb114414d3db1eab46274665c96c582d7f42c7a60a60`.
The relevant source images/text are recovered with:

```sh
sha256sum papers/blown-up-theta-lattice/blown_up_theta_lattice.pdf \
  /tmp/persistent/tavis/lit-search/pdf/BEAUVILLE_LNM947-theta-singularities.pdf \
  /tmp/persistent/tavis/lit-search/pdf/10.2307_1970801.pdf
nix shell nixpkgs#poppler-utils -c pdftotext -layout -f 5 -l 6 \
  papers/blown-up-theta-lattice/blown_up_theta_lattice.pdf -
nix shell nixpkgs#poppler-utils -c pdftotext -layout -f 12 -l 17 \
  /tmp/persistent/tavis/lit-search/pdf/BEAUVILLE_LNM947-theta-singularities.pdf -
nix shell nixpkgs#poppler-utils -c pdftotext -layout -f 12 -l 12 \
  /tmp/persistent/tavis/lit-search/pdf/10.2307_1970801.pdf -
nix shell nixpkgs#poppler-utils -c pdftotext -layout -f 50 -l 55 \
  /tmp/persistent/tavis/lit-search/pdf/10.2307_1970801.pdf -
```

For orientation, cached Beauville PDF pages 12, 13, 15–17 are printed pp.
201, 202, 204–206; cached Clemens–Griffiths PDF pages 12, 50, and 55 are
printed pp. 291, 329, and 334.

## 7. Publication recommendation

- **Default — Proceedings of the AMS:** accept on packet G.  The geometric
  mechanism is correct, compact, and adequately supported; the optional
  clarifications above would improve auditability but are not conditions of
  acceptance.
- **Stretch — Algebraic Geometry:** no geometric objection.  This packet
  supports sending the paper forward at the stretch venue, but a final stretch
  recommendation must remain conditional on the independent integral-topology,
  lattice, priority, and editorial-ceiling reviews; packet G alone cannot set
  that venue's originality or breadth threshold.
