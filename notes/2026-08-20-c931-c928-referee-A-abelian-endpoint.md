# Referee A: abelian endpoint

## 1. Verdict

**A — accept.** I find no mathematical repair necessary on the assigned proof surface. The integral cylinder/Albanese normalizations, the divided-power Pontryagin endpoint, the projection formulas, and the resulting fibre-product coordinate are compatible. The minor suggestions below are optional clarifications.

## 2. Claim map

- **Theorem 1.1 (printed pp. 2 and 6, equations (2), (3), (13), and (14)):** the Fano endpoint supplies integral lifts in every exceptional direction, with Gysin coordinate \(\theta^{[2]}\wedge y(\gamma)\), and therefore realizes the claimed mod-two fibre product.
- **Theorem 1.2 (printed pp. 2 and 7, equations (15) and (16)):** on the assigned surface, the verified unimodularity of \(y\) and the verified coset in (3) justify the identification \(\ker b_*\simeq 2H^3(X,\mathbf Z)\), hence the doubled exceptional sublattice in the rank-ten escape lattice.
- **Corollary 1.3 (printed pp. 2 and 7):** Proposition 4.3 supplies the surjectivity input used in the displayed exact sequence; the separate intersection-complex identification is outside Packet A.

## 3. Major findings

1. **The divided-power endpoint is correct.** Location: printed p. 6, Lemma 4.2, equation (13). Assertion: for \(\xi\in H^9(J,\mathbf Z)=\bigwedge^9\Lambda\),
   \[
   \xi\star\theta^{[3]}=\varepsilon\,\theta^{[2]}\wedge y(\xi),\qquad \varepsilon\in\{\pm1\}
   \]
   with one convention-dependent global sign. Verification: write \(\theta=\sum_{i=1}^5 e_i\wedge f_i\), so
   \(\theta^{[3]}=\sum_{|I|=3}\prod_{i\in I}(e_i\wedge f_i)\) integrally. The Pontryagin product lowers degree by ten, so both sides have degree five. For an oriented basis monomial \(\xi\) missing one basis vector, the adjunction calculation against a degree-five monomial forces exactly that omitted vector onto the first factor and the four remaining required vectors onto the second. Every surviving term has coefficient one; there is no factor \(2\), \(3\), or \(3!\). Changing the omitted vector changes only the Koszul sign prescribed by the same wedge-duality convention. **Severity:** none. **Smallest adequate remedy:** none.

2. **The geometric \(y\)-coordinate is an integral unimodular coordinate.** Location: printed p. 5, equation (11), and p. 6 immediately before Proposition 4.3. Assertion: the adjoint cylinder map and the Albanese Gysin map identify \(H^3(X,\mathbf Z)\) with \(\Lambda\) without a hidden index or torsion correction. Verification: Clemens--Griffiths define the cylinder map and its adjoint in §2, equations (2.7)--(2.8), printed p. 291, and prove \(\operatorname{Alb}(F)\to J(X)\) is an isomorphism in Theorem 11.19, printed p. 334. Hence \(\pi_*p^*:H^3(X,\mathbf Z)\to H^1(F,\mathbf Z)\) is an isomorphism of free integral lattices. Perfect Poincaré pairings make its adjoint \(p_*\pi^*:H^3(F,\mathbf Z)/\mathrm{tors}\to H^3(X,\mathbf Z)\) unimodular. Likewise, \(a^*:H^1(J,\mathbf Z)\to H^1(F,\mathbf Z)\) is unimodular, so its Poincaré adjoint, followed by the principal-polarization wedge duality \(\bigwedge^9\Lambda\simeq\Lambda\), is unimodular. Possible torsion in \(H^3(F,\mathbf Z)\) is explicitly removed and cannot map nontrivially to either free target. **Severity:** none. **Smallest adequate remedy:** none.

3. **The factor order introduces exactly one global sign and no degree-dependent defect.** Location: printed p. 6, proof of Proposition 4.3, equation (14). Put \(\xi=a_*\beta\in H^9(J,\mathbf Z)\). Since \(\psi=m\circ((-a)\times a)\),
   \[
   \psi_*(\beta\otimes1)=(-1)_*\xi\star[F]=-\xi\star\theta^{[3]},
   \]
   whereas
   \[
   \psi_*(1\otimes\beta)=(-1)_*[F]\star\xi=\theta^{[3]}\star\xi=\xi\star\theta^{[3]}.
   \]
   Here inversion acts by \((-1)^9=-1\) on \(H^9\), by \((-1)^6=+1\) on \([F]\in H^6\), and graded commutativity contributes \((-1)^{6\cdot9}=+1\). Thus exchanging the two factors reverses one sign uniformly for every \(\beta\), while \(\Delta^*(\beta\otimes1)=\Delta^*(1\otimes\beta)=\beta\); the same restriction class \(\gamma\) is retained. **Severity:** none. **Smallest adequate remedy:** none.

4. **The Fano minimal-class normalization is correct.** Location: printed p. 5, opening of §4, and printed p. 6 in the proof of Proposition 4.3. The class has codimension three in the fivefold \(J\), hence lies in \(H^6(J,\mathbf Z)\), and the correct normalization is
   \([F]=\theta^3/3!=\theta^{[3]}\). Clemens--Griffiths state this as Proposition 13.1, printed p. 347; Debarre, *Minimal Cohomology Classes and Jacobians*, p. 1, uses \(\theta_d=\theta^d/d!\) and records the Fano surface as the dimension-five intermediate-Jacobian example with class \(\theta_3\). Translation of the Albanese embedding acts trivially on cohomology, and inversion acts trivially in degree six, so neither choice changes \([F]\). **Severity:** none. **Smallest adequate remedy:** none.

5. **The projection and clean-restriction formulas have the right degrees and multiplicities.** Location: printed p. 5, Lemma 4.1, equation (12), and printed p. 6 after Proposition 4.3. The identity \(bq=\psi\mu\), together with \(\mu_*\mu^*=1\) for the blow-up, gives \(b_*q_*\mu^*T=\psi_*T\). For restriction to \(X\), the support equality \(q^{-1}(X)=P\) follows from \(\psi^{-1}(0)=\Delta\). On a fibre of \(P\to F\), both \(q^*X\) and the exceptional divisor have degree \(-1\), so the Cartier multiplicity is one. The resulting Thom-class base change gives \(e^*q_*\mu^*T=p_*\pi^*\Delta^*T\). Finally, the ordinary projection formula gives
   \(b_*b^*\alpha=\alpha\wedge b_*1=\theta\wedge\alpha\), because \(b_*1=[\Theta]=\theta\). Beauville's Proposition 6, LNM 947, printed pp. 204--205, independently supplies the diagonal/blow-up geometry used here. **Severity:** none. **Smallest adequate remedy:** none.

6. **The fibre-product coset is canonical; only a chosen lift formula carries a sign convention.** Location: printed p. 2, equation (3), and printed p. 6, the paragraph completing Theorem 1.1. Equation (14) uses the globally normalized \(y\), but changing \(y\) to \(-y\) does not change the class in \(S/L\bigwedge^3\Lambda\): by Theorem 3.1 this quotient is killed by two, so \([\theta^{[2]}\wedge y]=[\theta^{[2]}\wedge(-y)]\). A translation in the Albanese embedding also acts trivially on cohomology. Consequently the image of the intrinsic map \((b_*,e^*)\) and its coset description are canonical, even though an equality for a selected endpoint lift is written after fixing a global sign. **Severity:** none. **Smallest adequate remedy:** none.

## 4. Minor findings

1. On printed p. 5, the sentence declaring \([F]=\theta^{[3]}\) could cite Clemens--Griffiths, Proposition 13.1, directly rather than only the broad references \([\mathrm{CG72},\mathrm{Bea82}]\). The normalization is correct as written.
2. On printed p. 6, the phrase “exchanging the two factors if needed” is correct but terse. The two displayed factor-order calculations in major finding 3 would make transparent why the sign is global and why the exceptional restriction is unchanged.
3. Lemma 4.2 could define “integral symplectic wedge-dual” by one displayed pairing convention. This would locate the sole remaining sign choice and make equation (13) mechanically reproducible without changing the argument.

## 5. Literature boundary

The frozen manuscript was checked at SHA-256 `3822f928217df38e4ed3f4feb687d9036637dbc751bda3f792906df1196e36e5`. The public Clemens--Griffiths cache record `10.2307/1970801` (SHA-256 `6cfe96ecb81179ce2756cb114414d3db1eab46274665c96c582d7f42c7a60a60`) establishes the integral incidence/cylinder maps and their adjunction in §2, the Albanese/intermediate-Jacobian isomorphism in Theorem 11.19, and the Fano minimal class in Proposition 13.1. It does not state the manuscript's divided-power endpoint (13), its endpoint lifts (14), or the integral fibre-product coset (3).

The Debarre cache record `arXiv:alg-geom/9301002` (SHA-256 `975fbc7f4a31b67e2e38e97364e9314b0060404f4c7a904d6ad5ca2a90ae4486`) independently confirms the convention that the minimal codimension-\(d\) class is \(\theta^d/d!\) and specifically identifies the cubic-threefold Fano surface with \(\theta^3/3!\); it does not address the cylinder adjoint or Pontryagin endpoint. The Beauville cache record `BEAUVILLE:LNM947-theta-singularities` (SHA-256 `4596f46edfdf9b69fd295581119faf814ad67a1e3d87592aa0146aaf225ea90a`) supports the difference-map/blow-up geometry; the multiplicity-one base-change and the cohomological endpoint are proved in the manuscript itself. No assigned public source already supplies the integral mod-two glue.

## 6. Confidence

1. **Major finding 1: high.** Supported by the explicit symplectic-basis expansion of \(\theta^{[3]}\), the degree count \(9+6-10=5\), and coefficient-by-coefficient Pontryagin adjunction.
2. **Major finding 2: high.** Supported by Clemens--Griffiths §2, equations (2.7)--(2.8), and Theorem 11.19, plus integral Poincaré duality on the free quotients.
3. **Major finding 3: high.** Supported by the functorial factorization of \(\psi\), the standard action of inversion on \(H^k(J)\), and the even graded-commutativity exponent \(6\cdot9\).
4. **Major finding 4: high.** Supported independently by Clemens--Griffiths Proposition 13.1 and Debarre p. 1.
5. **Major finding 5: high.** Supported by Lemma 4.1's Cartier multiplicity calculation, Thom-class base change, and the ordinary projection formula; Beauville Proposition 6 corroborates the geometric diagram.
6. **Major finding 6: high.** Supported by Theorem 3.1, equation (8), which makes the target coset group elementary two-torsion, and by translation invariance of abelian-variety cohomology.

## 7. Publication recommendation

- **Default — Proceedings of the AMS:** recommend acceptance. The assigned endpoint is concise, self-contained at the level appropriate to the paper, and integrally normalized; the three minor clarifications are optional polish.
- **Stretch — Algebraic Geometry:** recommend acceptance on mathematical grounds, with the same optional clarifications encouraged. The result has credible specialist interest through the interaction of cubic-threefold/Fano geometry with an integral lattice phenomenon, although the venue-fit case is naturally less certain than for the default concise-research venue.
