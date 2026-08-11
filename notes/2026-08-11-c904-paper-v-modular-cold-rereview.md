# Paper V cold referee — packet R

PDF SHA-256: `fffe903ea1fdd664173e48030aad5086df09c0e7c7bfcbaa7aee1662f2915543`

Packet: R — modular representations and extensions; manuscript Section 9 and its downstream use in Theorems 1.3 and 9.3.

Permitted sources actually read: one source, zero at full-text depth. Frauke M. Bleher, *Universal deformation rings and Klein four defect groups*, Trans. Amer. Math. Soc. 354 (2002), DOI `10.1090/S0002-9947-02-03072-6`: **partial text**, Section 3.3 from its opening through the displayed list of the four length-two uniserial principal-block modules and the available portion of Lemma 3.5 and its proof (pp. 3901 ff.), accessed through the CiteSeerX indexed text returned for the article. The PDF itself was not obtainable from the literature cache or the accessible publisher endpoint, so no stronger read depth is claimed. No Peter Sin source was named in packet R, and none was consulted.

Verdict: **GO**

## Main theorem in my own words

For the oriented order-six conference package, passing first from the integral operator $B$ to $\varphi=(I+B)/2$ and only then reducing modulo two turns $D_6^\vee/2D_6^\vee$ into a three-dimensional $\mathbf F_4$-module. Its commutator submodule is the two-dimensional natural $\mathbf F_4$-module for $A_5\cong \operatorname{SL}_2(\mathbf F_4)$; the quotient is a canonical trivial line, and the resulting extension is the unique nonsplit middle module up to isomorphism. The $\mathbf F_2$-linear $A_5$-commutant of the heart is exactly $\mathbf F_4$. Reversing the golden conference orientation, or applying the outer normalizer, conjugates the two primitive commutant scalars, so the geometric orientation torsor is the Frobenius torsor of this modular heart. This supplies the modular part of Theorem 1.3 and, downstream, the upper-branch instance of the Frobenius-orbit comparison in Section 10.

## Earliest unsupported implication

- Locator: Proposition 9.1, pp. 15–16, beginning with the displayed formula for $H=[G,M]$.
- Printed claim: the commutator submodule is a two-dimensional $\mathbf F_4$-space, the quotient is a trivial $\mathbf F_4$-line, and the extension is nonsplit.
- Why it follows / does not follow: it follows. The four printed commutators span the four-dimensional binary hyperplane displayed for $H$. Stability under $\varphi$ makes this a two-dimensional $\mathbf F_4$-submodule. Perfectness of $A_5$ kills the action on the one-dimensional quotient. The two printed generator actions have simultaneous fixed space zero; since every one-dimensional $\mathbf F_4$-representation of a perfect group is trivial, a splitting would produce a nonzero fixed vector and is therefore impossible.
- Smallest counterexample or missing lemma: none. The only implicit linear-algebra step is that a second invariant $\mathbf F_4$-plane in a three-dimensional space meets $H$ in a line; the manuscript states and uses this immediately.
- Downstream scope: the natural-module identification, the commutant field, the Ext classification, and the Frobenius torsor all remain supported.

## Controlling findings

1. **[pass] [Proposition 9.1, pp. 15–16]** The concrete heart is not inferred from dimensions alone. The printed commutators identify $H=[G,M]$ explicitly. Its nontrivial action is faithful because $A_5$ is simple; its determinant is trivial because $A_5$ is perfect; hence its image is all of $\operatorname{SL}_2(\mathbf F_4)$ by the order count. This proves that $H$ is one of the two Frobenius-conjugate natural modules.

2. **[pass] [Proposition 9.1, p. 16]** The claim $\operatorname{End}_{\mathbf F_2G}(H)=\mathbf F_4$ is justified. The two natural $\mathbf F_4$-modules are distinguished by their traces $\omega$ and $\omega^2$ on a fixed order-five class. Thus the $\mathbf F_4$-linear commutant consists of scalars, while a Frobenius-semilinear commuting map would give an intertwiner between two nonisomorphic twists. For a quadratic scalar extension, every $\mathbf F_2$-linear endomorphism is the sum of a linear and a Frobenius-semilinear one, so no additional commutant elements remain.

3. **[pass] [Proposition 9.1, pp. 15–16]** The quotient line is handled at the correct level. The line $\ell=M/H$ is canonical and has trivial $G$-action, but the manuscript expressly says that a displayed trivialization $\ell\cong\mathbf F_4$ is not canonical. The integral comparison is exact: $\mathbf Z^{\Omega_0}\cap2D_6^\vee=2\mathbf Z^{\Omega_0}+\mathbf Z\mathbf1$, so restricting the induced map to binary augmentation and quotienting by the constant line identifies $H$ canonically with $H_{\Omega_0}$.

4. **[pass] [Proposition 9.2, p. 17]** The Ext line is computed rather than cited. The $(2,3,5)$-presentation gives relation norms of ranks $(1,0,0)$, hence $\dim_{\mathbf F_4} Z^1=3$. The coboundary map from $H$ is injective because $H^G=0$, so $\dim B^1=2$ and $\operatorname{Ext}^1_{\mathbf F_4A_5}(\mathbf F_4,H)\cong\mathbf F_4$. Endpoint scalar automorphisms act transitively on its three nonzero classes, which is enough to identify their middle modules. Proposition 9.1 supplies the independent nonsplitting witness for $D_6^\vee/2D_6^\vee$. Bleher Section 3.3 is consistent with the nearby block description—two nontrivial simples and the corresponding length-two uniserial modules—but the manuscript does not outsource its stronger fixed-$\mathbf F_4$-form uniqueness claim to that citation.

5. **[pass] [Theorem 9.3, pp. 17–18; Theorem 1.3, p. 4]** The two involutions are identified on the actual commutant scalar. The equation $\bar\varphi^2+\bar\varphi+1=0$ makes $\bar\varphi|_H$ one of $\omega,\omega^2$. Reversal sends $\varphi$ to $1-\varphi$, which modulo two is $\omega\mapsto1+\omega=\omega^2$. The earlier recovered-six-set normalizer exchanges the two oriented conference classes, so its conjugation induces this same unique nontrivial automorphism of $\mathbf F_4$. The Cartesian torsor square, and the downstream upper-branch statement in Section 10, follow without identifying the upper and lower geometric carriers.

## Human-proof deletion test

All assigned claims remain valid after every sentence about scripts, checker output, and computation is removed. Section 9 contains the needed module actions, fixed-space calculation, commutator spanning set, integral intersection, triangle-presentation cocycle calculation, coboundary dimension, endpoint action, and Frobenius formula. The verification section is not used by any step in this chain.

## Attribution and novelty boundary

The Bleher citation is appropriately narrow: the partial text of Section 3.3 confirms the characteristic-two principal $A_5$-block has the trivial simple, two nontrivial simples, and four indicated length-two uniserial modules. It does not, at the depth read, establish the paper's precise $\mathbf F_4$-form, canonical integral heart, Ext-coordinate calculation, or golden/outer Frobenius identification. Those stronger statements are proved in the manuscript itself. I found no packet-R attribution overclaim. Because the source was read only partially, this report makes no broader priority or exhaustiveness claim about modular-extension literature.

## Mystery ledger

The closeout pass found no unresolved mathematical mystery in packet R. The only open evidence gap is bibliographic: Bleher was available at partial-text depth rather than as a complete PDF. That gap limits any broader priority assessment, but it does not gate the verdict because the manuscript proves the extension and Frobenius claims internally.
