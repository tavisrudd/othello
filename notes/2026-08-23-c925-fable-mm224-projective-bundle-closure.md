# MM 2-24 closed: every smooth (1,2) divisor in P^2 x P^2 is a projective bundle, and Iritani--Koto splits its ledger over P^2

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Closes residue §4.1 of `2026-08-23-c925-fable-gs-carrier-blowup-chains.md`:
MM 2-24, the \((1,2)\) divisor \(X\subset\mathbf P^2\times\mathbf P^2\), was
the only identified primitive \(b_3=0\) Fano that neither the toric sweep,
the rank-one discharge, the blow-up-chain proposition, nor the homogeneous
flag computation reached.  The planned route (Ciolli's rank-2 small quantum
products, else a two-parameter quantum-Lefschetz evaluation) is replaced by
a structurally stronger one: \(X\) is a \(\mathbf P^1\)-bundle over
\(\mathbf P^2\), and the Iritani--Koto projective-bundle decomposition
closes it exactly the way Iritani's blow-up decomposition closed the chains.

## 1. Ciolli does not cover MM 2-24

Ciolli's computations (arXiv:math/0403300 and the published companion
*Computing the quantum cohomology of some Fano threefolds and its
semisimplicity*, per its abstract) treat Fano threefolds obtained as one- or
two-curve blow-ups of \(\mathbf P^3\) or \(Q^3\).  Those are blow-up chains
over closed bases — already discharged by the chain proposition — and MM
2-24 is not among them.  No étale check on Ciolli data is available or
needed.

## 2. Smoothness forces the projective-bundle structure

**Proposition.**  Let \(X=\{\sum_{i}x_iQ_i(y)=0\}\subset\mathbf
P^2_x\times\mathbf P^2_y\) be a smooth divisor of bidegree \((1,2)\), where
\(Q_0,Q_1,Q_2\) are the conics of its defining net.  Then the net is
base-point-free, the evaluation \(\varphi:\mathcal O^{\oplus3}\to\mathcal
O(2)\), \(e_i\mapsto Q_i\), on \(\mathbf P^2_y\) is surjective with kernel a
rank-two bundle \(E=\ker\varphi\), and the second projection exhibits
\(X=\mathbf P(E)\) with \(\mathcal O_{\mathbf P(E)}(1)=\mathcal
O(1,0)|_X\).

*Proof.*  If \(y_0\) were a common zero of the net, choose \(x_0\ne0\) with
\(\sum_i x_{0,i}\,dQ_i(y_0)=0\) — two linear conditions on three
coordinates.  Then \(F=\sum x_iQ_i\) vanishes at \((x_0,y_0)\) (each
\(Q_i(y_0)=0\)), \(\partial F/\partial x_j=Q_j(y_0)=0\), and \(\partial
F/\partial y=\sum x_{0,i}\,dQ_i(y_0)=0\), so \(X\) is singular there —
contradiction.  Base-point-freeness makes \(\varphi\) surjective, so
\(E=\ker\varphi\) is locally free of rank two, and the fibre of \(X\) over
\(y\) is \(\mathbf P(E_y)\subset\mathbf P^2_x\); globally \(X=\mathbf
P(E)\subset\mathbf P(\mathcal O^{\oplus3})=\mathbf P^2\times\mathbf P^2\),
with relative \(\mathcal O(1)\) the restriction of \(h_1\).  \(\square\)

From \(c(E)(1+2h)=1\): \(c_1(E)=-2h\), \(c_2(E)=4h^2\).  The Grothendieck
relation \(\xi^2-2h\xi+4h^2=0\) with \(\xi=h_1\), \(h=h_2\) is **exactly**
the degree-two apolar relation of \(X\)'s intersection cubic computed by
adjunction — certified in part 1 of the script below, together with the
Hilbert dimensions \((1,2,2,1)\) and the degree-three annihilator.  Note
\(E^\vee\) is a quotient of \(\mathcal O^{\oplus3}\), hence globally
generated, so the Iritani--Koto hypothesis holds for \(E^\vee\)'s dual on
the nose (their Remark 1.2 makes the twist immaterial anyway).

## 3. Ledger closure

**Theorem.**  The carrier ledger of any smooth MM 2-24 member over the
coefficient field of any of its Iritani bulk curves consists of semisimple
blocks only; MM 2-24 carries no marked block or triple.

*Proof.*  Iritani--Koto (arXiv:2307.03696), Theorem 5.1 with \(r=2\),
\(B=\mathbf P^2\), \(V=E\): there is an isomorphism
\(\Phi:\mathrm{QDM}(\mathbf P(E))_{\mathrm{loc}}\cong
\bigoplus_{j=0,1}\varsigma_j^*\mathrm{QDM}(\mathbf
P^2)^{\mathrm{ext,loc}}\) over a \(\mathbf
C[z]((q^{-1/2}))[[Q,\hat\tau]]\)-type ring, which by items (1) and (2)
intertwines the full quantum connections **including**
\(\nabla_{z\partial_z}\) and the pairings.  So the ledger of \(X\) over any
bulk-curve coefficient field is the disjoint union of the two summands'
ledgers, exactly as in the blow-up-chain proposition (Iritani 5.18
bookkeeping).  Each summand is \(\mathbf P^2\)'s quantum connection pulled
back along the formal bulk curve \(\varsigma_j(\hat\tau)\), whose base
point is a unit-direction shift plus a divisor-direction shift plus
\(O(q^{-1/2})\) corrections (item (4)).  The small quantum algebra of
\(\mathbf P^2\) is \(\mathbf C[h]/(h^3-q)\), with discriminant \(-27q^2\)
a unit at every point of the punctured Novikov torus and in every Laurent
coefficient field — étale everywhere, not just at one point.  The upgraded
anchor lemma of the blow-up-chains note (§1), whose proof is
dimension-free and applies verbatim to the surface base, then makes every
block of each summand semisimple: unit shifts rescale flat sections by a
common exponential, divisor shifts move within the punctured torus, and
bulk corrections preserve étale-ness by Hensel.  Coincidences of
exponentials across the two summands merge simple sheets into blocks with
vanishing nilpotent part, which are unmarked.  \(\square\)

With MM 2-32 (flag) and MM 2-24 both closed, **every identified primitive
non-toric \(b_3=0\) obstruction is discharged**; see §5 for what remains.

## 4. Exact corroboration and a warning about the ambient algebra

Certificate: `notes/cubic-threefolds-tasks/c925-fable-mm224-projective-bundle-etale.py`
(sha256 `b17c2d6d3869d8bb65df7da8e8d39e7e32776a414abe0e622c2004b0006ef572`),
output `c925-fable-mm224-projective-bundle-etale-output.txt` (sha256
`54a144783959538ae44e087d54c1ec10af5b236d36cd03120e5cd121aba6347c`); replay
`uv run --with sympy python3 notes/cubic-threefolds-tasks/c925-fable-mm224-projective-bundle-etale.py`
(about two seconds; every claim below is asserted).

1. **Cohomology dictionary** (part 1): apolar ring of the adjunction cubic
   \(=\) Grothendieck ring of \(\mathbf P(\ker(\mathcal
   O^3\to\mathcal O(2)))\), exactly.
2. **Anchor** (part 2): \(\mathrm{disc}(\lambda^3-q)=-27q^2\).
3. **Hypergeometric operators** (part 3): \(P_1=p_1^3-q_1(p_1+2p_2+z)\)
   and \(P_2=p_2^3-q_2(p_1+2p_2+z)(p_1+2p_2+2z)\) annihilate the
   two-parameter quantum-Lefschetz \(I\)-function term by term (grid
   \(l,m\le3\), exact).
4. **The ambient spectral scheme is NOT étale** (part 3b): at
   \(q_1=q_2=1\), the \(z\to0\) scheme of \((P_1,P_2)\) is nine-dimensional
   and decomposes as a **multiplicity-three point at the origin** plus six
   distinct reduced points; the trace form has rank \(7=1+6\) (a local cube
   plus six fields).  The fat origin is ambient excess — it carries the
   twisted-pairing degeneracy that \(X\)'s six-dimensional quotient must
   kill (\(\dim\ker i^*=3\)), and it sits at \(-K_X\)-eigenvalue \(0\),
   while the six reduced points have six distinct **nonzero**
   \(-K_X=2p_1+p_2\) values, the roots of
   \(s^6-12s^5+36s^4-238s^3+72s^2+24s-91\).  Two consequences: (i) the
   naive "étale check on the ambient presentation" that the task
   anticipated would have returned a **false negative** — the projective-
   bundle route was not merely cheaper but necessary for a clean statement;
   (ii) the six reduced points are the natural conjectural canonical-point
   \(c_1\star\) spectrum of \(X\), consistent with \(\chi(X)=6\), though
   the certificate does not prove the identification (the twisted pairing
   data alone does not pin the Frobenius quotient).
5. **CCGK quantum period** (part 4): the same \(I\)-function reproduces
   \(\widehat G_X=1+4t^2+24t^3+132t^4+780t^5+5800t^6+40320t^7+283780t^8
   +2105880t^9+\cdots\), the published regularized period of MM 2-24
   (Coates--Corti--Galkin--Kasprzyk arXiv:1303.3288 §41, Corollary D.5,
   Minkowski sequence 44), whose \(e^{-2t}\) prefactor equals the
   independently derived mirror-map factor.

## 5. Residue of the \(b_3=0\) tail after this note

1. **Enumeration completion (queued, unchanged):** read the \(b_3=0\)
   Mori--Mukai classification table against the closure criteria — chain
   over a closed base, product with \(\mathbf P^1\), homogeneous,
   projective bundle over a closed base (this note adds the last
   criterion, which independently re-closes the flag threefold MM 2-32
   \(=\mathbf P(T_{\mathbf P^2})\)) — and certify that no primitive family
   escapes all of them.
2. **Non-Fano carriers not presented as chains or projective bundles over
   closed bases:** open as before; the structural irregular-Hodge lead
   remains the candidate uniform closure.

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | Smoothness alone forces the \(\mathbf P^1\)-bundle structure on every MM 2-24 member (no genericity needed). | §2 proposition. |
| settled | Iritani--Koto Theorem 5.1 has the same ledger interface as Iritani 5.18(1); the anchor lemma is dimension-free and applies at the surface base. | §3. |
| settled | The ambient quantum-Lefschetz algebra at the canonical point is non-étale: fat origin of multiplicity three at eigenvalue \(0\) = the \(\ker i^*\) excess. | §4.4, certificate part 3b. |
| open, observation | Does ambient excess sit at \(c_1\)-eigenvalue \(0\) with multiplicity \(\dim\ker i^*\) for every Fano hypersurface in a product of projective spaces?  Logged to the discovery track; not a gate. | discovery-track entry 2026-08-23. |
| open, reduced | §5.1 enumeration completion; §5.2 non-Fano non-chain carriers. | unchanged owners. |

No manufactured mysteries: the tail residue is the same two named items,
with MM 2-24 removed from the first.
