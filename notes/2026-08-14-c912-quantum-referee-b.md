# C912 Quantum Referee B: source-exactness audit of `prop:framed-operations`

**Overall verdict: NO-GO as written — one blocking gap, localized and repairable in a
paragraph. Every external attribution I could check is CONFIRMED; no MISMATCH was found
between what a source says and what the manuscript claims it says. The blocking defect is
in the paper's own completion machinery on the blowup side, not in its reading of the
literature.**

Target: `/home/tavis/src/othello/papers/cubic-stabilization-epilogue/sections/04-one-step.tex`,
Proposition `prop:framed-operations` ("Framed operation formulas"), statement lines 369-388,
proof lines 390-704. Formula (4.2) `eq:projective-bundle-nu` is the projective-bundle formula
\(\nu_6(\mathbb P_T(V)) = r\,\nu_6(T)\); formula (4.3) `eq:blowup-nu` is the blowup formula
\(\nu_6(\widetilde T)=\nu_6(T)+\sum_{j=0}^{c-2}\nu_6(C;\chi_j)\).

Sources read from the cached extractions in `/tmp/persistent/tavis/lit-search/text/`.
Line numbers in the "locator" column are line numbers in those cached text files, given so
each quotation can be re-found.

## Version pins

| Bib key | Manuscript pin (`cubic_stabilization_epilogue.tex` lines 147-165) | Cached header | Numbering used | Verdict |
|---|---|---|---|---|
| `IritaniBlowup` | arXiv:2307.13555v3 (2025)  | `arXiv:2307.13555v3 [math.AG] 4 Feb 2025`  | v3 (Thm 5.18, §5.8.2, Rem. 5.6, (5.11), (5.15), (5.45)-(5.47)) | CONFIRMED |
| `IritaniNotes`  | arXiv:2604.10028v2 (2026)  | `arXiv:2604.10028v2 [math.AG] 19 Apr 2026` | v2 (§2 items (a)-(e))                                          | CONFIRMED |
| `IritaniKoto`   | arXiv:2307.03696v4 (2026)  | `arXiv:2307.03696v4 [math.AG] 31 Jan 2026` | v4 (Thm 5.1(4),(5), Prop. 5.6, Cor. 1.8, (1.1), (5.1)-(5.3))    | CONFIRMED |
| `KKPYY`         | arXiv:2508.05105v2 (2026)  | `arXiv:2508.05105v2 [math.AG] 6 Mar 2026`  | not cited inside this proof                                    | CONFIRMED |
| `Cai`           | arXiv:2608.01577v1 (2026)  | `arXiv:2608.01577v1 [math.SG] 3 Aug 2026`  | not cited inside this proof                                    | CONFIRMED |

The version pin on Iritani-Koto is load-bearing and correct. The arXiv version history for
2307.03696 records for v4 (31 January 2026): *"proof of Theorem 1.1 streamlined, log q term
in the change of coordinates for Theorem 1.7 removed, error in Theorem 5.1(5) corrected, a
reconstruction algorithm added in Section 5.8"*. So the manuscript's parenthetical at line
651-653 ("an item corrected in the fourth version of that preprint, dated 31 January 2026")
is exactly right, and the *other* v4 change — removal of the `log q` term from the change of
coordinates for Theorem 1.7 — is what makes the manuscript's "mirror coordinates are
independent of z" claim safe in the form used. On v3 the coordinate change carried a `log q`
term. Pinning v4 is not cosmetic.

Only `IritaniBlowup` and `IritaniKoto` are cited inside the proof body. `IritaniNotes` is
cited in the lead-in paragraph at lines 333-337; `KKPYY` and `Cai` are used elsewhere in the
section (lines 873, 989-1139) and play no role in this proposition.

## Claim-source-locator table

### A. Blowup half of the proof (lines 390-571)

| # | Manuscript claim (line) | Source statement, verbatim (locator) | Verdict |
|---|---|---|---|
| A1 | "Iritani's Theorem 5.18 gives a formal coordinate isomorphism and a quantum-D-module isomorphism QDM(T̃) ≅ QDM(T) ⊕ QDM(C)^{⊕(c-1)} over a Laurent extension in the exceptional Novikov variable" (400-408) | Thm 5.18: "an isomorphism Ψ of C[z]((q−1/s))[[Q, τ̃]]-modules  Ψ : QDM(X̃)la → τ∗QDM(X)la ⊕ ⊕_{j=0}^{r−2} ςj∗QDM(Z)la" (2307.13555 L5622-5632). "The variable q represents the class of a line in the exceptional divisor D ⊂ X̃ that maps to a point in Z" (L69-70). | CONFIRMED (with a cosmetic caveat: the manuscript's display drops the pullback decorations τ∗, ςj∗; it restores the coordinate maps at (4.4b), so nothing is lost, but the display as printed is not literally Theorem 5.18) |
| A2 | Codimension hypothesis c ≥ 2, C smooth, T smooth projective (371-378, §04 line 17) | "Let X be a smooth projective variety over C and let Z ⊂ X be a smooth subvariety of codimension r ≥ 2" (L47-49) | CONFIRMED |
| A3 | "The comparison field adjoins q^{−1/s_c}, where s_c = c−1 for even c and s_c = 2(c−1) for odd c" (410-412) | (5.11): "s = r−1 if r is even; 2(r−1) if r is odd" (L4150-4155); also L73 "where s equals r − 1 or 2(r − 1) depending on whether r is even or odd" | CONFIRMED, exact including the parity convention |
| A4 | "this is a coefficient extension in the Novikov direction, not a ramification of z, so the original loop is untouched" (411-413) | q is a Novikov variable ("q := S_Z^{−1} = yS^{−1} with deg q = 2(r − 1)", L4145-4147); the base ring is C[z]((q^{−1/s}))[[Q, τ̃]] = "C[q±1/s][[Q, τ̃]][[z]]" (Rem. 1.5, L107-109). No root of z is adjoined anywhere. | CONFIRMED |
| A5 | "The reconstruction coordinate below is u = q^{−1/(c−1)}" (413-416) | Thm 1.1: the change of variables is "defined over C((q^{−1/(r−1)}))[[Q]]" (L80-83); Cor. 1.2 likewise (L100-104). Note the source keeps the two rings distinct exactly as the manuscript does: coordinate change over q^{1/(r−1)}, Ψ over q^{1/s}. | CONFIRMED |
| A6 | "let R_j be the image of Q_C^d ↦ Q^{i_*d} u^{ρ_C·d}" (425-427) | (5.15): "C[z][[QZ , σ]] → C[z]((q−1/s))[[Q, σ]], Q^d_Z ↦ Q^{ı∗d} q^{−ρZ ·d/(r−1)}", with "ρZ = c1(NZ/W ) = c1(NZ/X)" (L4249-4252). With u = q^{−1/(c−1)}, u^{ρ_C·d} = q^{−ρ_C·d/(c−1)}. | CONFIRMED, exact |
| A7 | "The noninjective center monomial map merely replaces the source ring by its image" (464-465); and, just after the proof, "The center map in (4.3) is not necessarily injective [(5.15)]" (706-707) | (5.15) is introduced as "the (not necessarily injective but degree-preserving) extension of rings" (L4246-4248) | CONFIRMED, verbatim; the manuscript's downstream caution (generic vanishing on C does not transfer) is the correct reading |
| A8 | "The center connection is defined over this image ring by [Remark 5.6]" (458-459) | Rem. 5.6: "the structure of QDM(Z)La can be reduced to a smaller ring, namely, the image R of C[z][[QZ e^σ , σ′]][σ^0] under (5.15) ... the connection (5.16) multiplied by z preserves the submodule H∗(Z) ⊗ R" (L4275-4280) | CONFIRMED in substance, over-read in detail. Iritani's R is the image of `C[z][[Q_Z e^σ, σ′]][σ^0]`, i.e. the Novikov variable *packaged with the exponentiated divisor bulk directions*; the manuscript's R_j is the image of the bare Novikov monomial map with `u` and the components of `s_j` adjoined separately. `u` is not in the image of (5.15). See mismatch S5. |
| A9 | Reconstruction coordinates (4.4): "ς_j = ς_j° + s_j" cited to [§5.8.2] (416-424) | §5.8.2: "we write τ (τ̃ ) = τ ◦ + t(τ̃ ), ςj (τ̃ ) = ςj◦ + sj (τ̃ ) with t(τ̃ ) ∈ H∗(X)((q−1))[[Q, τ̃ ]], sj (τ̃ ) ∈ H∗(Z)((q^{−1/(r−1)}))[[Q, τ̃ ]]" and (5.47) "τ = τ ◦ + t, ςj = ςj◦ + sj" (L5812-5830) | CONFIRMED, exact |
| A10 | "ς_j° = −(c−1)λ_j + h_{C,j} + O(u)" (421) | Thm 5.18(6): "ςj (τ̃ )|Q=τ̃ =0 = −(r − 1)λj + hZ,j + O(q^{−1/(r−1)})" (L5658-5659); also (5.30) "ςj (0)|Q=0 ∈ −(r − 1)λj + hZ,j + q^{−1/(r−1)}H∗(Z)[q^{−1/(r−1)}]" (L5228-5231) | CONFIRMED, exact |
| A11 | "the ambient target uses τ = τ° + t, with τ° = O(q^{−1})" (559-561) | Thm 5.18(6): "τ (τ̃ )|Q=τ̃ =0 = q−1[Z] + O(q−2)" (L5658); (5.29): "τ (0)|Q=0 ∈ q^{−1}H∗(X)[q^{−1}]" (L5216-5222) | CONFIRMED |
| A12 | "[(5.45), (5.47), and the initial asymptotics (5.27)–(5.30)] shows that after the unit term −(c−1)λ_j and fixed divisor h_{C,j} are removed, its target bulk coordinate lies in J_j H∗(C)" (460-464) | (5.45) gives τ°, ς_j° as explicit `[z^{-1}] log` expressions (L5776-5784); (5.27) is the FT_{Z,j} initial asymptotic (L4864-4866); (5.30) is the ς_j initial asymptotic quoted in A10; (5.17) additionally gives "σj (θ)|Q=0 ∈ hZ,j + m′H∗(Z)[[q^{−1/(r−1)}, θ^{•Z}q^{1/(r−1)}]]" (L4283-4290) | CONFIRMED. The cited range does support the containment; (5.17) is the tighter citation and is not cited. |
| A13 | "the fixed-divisor substitution ... is well defined on the image because h_{C,j} is a scalar multiple of ρ_C" (554-557) | (5.19): "hZ,j = (2πi/(r−1))(j + 1/2) ρZ" (L4310-4315) | CONFIRMED, and the manuscript's inference is sound: the image monomial Q^{i∗d}u^{ρ_C·d} records ρ_C·d, so a substitution depending only on ρ_C·d descends to the image |
| A14 | "The comparison maps respect the filtration F_N of [Proposition 5.4, especially (5.13)–(5.14)]" (489-491) | Prop. 5.4: "The map FTX|QDMT(W)X̃ in Proposition 5.1 extends to a homomorphism of C[z][[C∨X̃,N, θ]]-modules ... on the completion" (L4185-4192); (5.13): "FTX(IN · C[q±] · QDMT(W) + FN(QDMT(W))) ⊂ FN(τ∗QDM(X)La)" (L4213-4214). F_N is defined by "ω_W · δ ≥ N, or θ^I is divisible by θ^{i,k} for some k ≥ N, or θ^I is of the form θ^{i1,k1}···θ^{il,kl} with l ≥ N" (L4205-4210). | CONFIRMED for the forward Fourier map only. Ψ is "the composition Φ ◦ (FT_{X̃})^{−1}" (L5712-5714); (5.13)-(5.14) do not cover the inverse. See mismatch S4. Note also that Iritani's F_N gives θ^{i,k} level ≥ k, which the manuscript's uniform weight does not reproduce — this is the root of the blocking defect S1. |
| A15 | "Our order is precisely the graded meaning of C[z]((v))[[Q, θ]] stipulated in [Remarks 1.3–1.5]" (492-495) | Rem. 1.3: "Throughout the paper, we work with completions in the category of graded rings or modules ... C((q^{−1/(r−1)}))[[Q]] is the same as C[q^{±1/(r−1)}][[Q]] since q has positive degree" (L96-99). Rem. 1.5: "The decomposition Ψ in Theorem 1.1 is defined over C[z]((q−1/s))[[Q, τ̃ ]]. The base ring can also be written as C[q±1/s][[Q, τ̃ ]][[z]] ... (where deg q = 2(r − 1), deg z = 2)" (L106-110). | CONFIRMED as a description of the source's convention. Whether the manuscript's weight order *reproduces* that convention is its own claim; see S1/S2. |
| A16 | (4.4b) "τ̃ ↦ (τ(τ̃), ς_0(τ̃), …, ς_{c−2}(τ̃)) is the graded formal coordinate isomorphism of [Corollary 1.2 and Theorem 5.18]" (497-508) | Cor. 1.2: "The map τ̃ 7→ (τ (τ̃ ), {ςj (τ̃ )}0≤j≤r−2) defines an isomorphism of quantum cohomology F-manifolds over C((q^{−1/(r−1)}))[[Q]], i.e. the differential of this map defines a ring isomorphism ... It also preserves the Euler vector fields." (L100-104) | CONFIRMED, exact |
| A17 | "This pullback and the inverse coordinate change preserve finite-below support ... the same induction on degree constructs the inverse because the displayed coordinate map has invertible linear term" (509-514) | §5.8.2: "The map τ̃ 7→ (t(τ̃), s0(τ̃), . . . , sr−2(τ̃)) gives a formal invertible change of variables over C((q^{−1/(r−1)}))[[Q]]. Let (t, s) 7→ τ̃(t, s) denote the inverse map." (L5818-5822); Thm 5.18(7) gives the Jacobian at Q=τ̃=0 "is invertible" (L5666-5669) | CONFIRMED — here the manuscript is *weaker* than the source, which already asserts formal invertibility of exactly this map |
| A18 | "Theorem 5.18 supplies both maps with only integral powers of z" (552-553); "The isomorphism and its inverse use only integral powers of z, and the mirror coordinates are independent of z" (408-409) | Thm 5.18: Ψ is "an isomorphism of C[z]((q−1/s))[[Q, τ̃ ]]-modules" (L5626-5628); Notes §2: "The decomposition isomorphism Ψ from (1) is an invertible element Ψ ∈ Hom(H∗(X̃), H∗(X) ⊕ H∗(Z)^{⊕(r−1)}) ⊗ C[z]((q−1/s))[[Q, τ̃ ]]" (2604.10028 L283-286). Mirror maps: "τ (τ̃ ) ∈ H∗(X)((q−1))[[Q, τ̃ ]] ... ςj (τ̃ ) ∈ H∗(Z)((q^{−1/(r−1)}))[[Q, τ̃ ]]" (L5622-5626) — no z. | CONFIRMED for both halves of the claim, and the Notes' "invertible element" wording settles the inverse explicitly |
| A19 | Endpoint faithfulness: "β̄ ↦ (φ∗β̄, −E·β̄)" (564-571) | (1.1), first arrow: "C[[Q̃]] ↪ C((q−1/s))[[Q]],  Q̃^{d̃} 7→ Q^{φ∗d̃} q^{−[D]·d̃}" (L62-66) — note the hooked (injective) arrow here versus the plain arrow used for the center map | CONFIRMED; the manuscript's numerical-lattice injectivity argument via N^1(T̃) = φ∗N^1(T) ⊕ Z[E] is its own addition and is correct for a smooth-center blowup |
| A20 | Lead-in (333-337): "Iritani's subsequent notes record explicitly that the blowup change of variables and decomposition preserve cohomological parity [Section 2]" | Notes §2(a): "The formal power series τ^i(τ̃), ς^i_j(τ̃) have the same degrees and the parities as the variables τ^i, σ^i" with "The statement about the parity in Part (a) was omitted in [4], but it is obvious from the construction"; §2(d): "The endomorphism ΨX is homogeneous of degree zero and each ΨZ,j is homogeneous of degree −r. They also preserve the parity." (2604.10028 L221-300) | CONFIRMED, exact — and note Remark 2 (L214-217): "the parity is not always congruent modulo 2 to the degree: we have deg q^{1/s} = 1 when r is odd, but the parity of q^{1/s} remains even", which is precisely what the manuscript needs for the odd-codimension ramified root. The manuscript does not cite Remark 2 but its conclusion is consistent with it. |

### B. Projective-bundle half of the proof (lines 573-703)

| # | Manuscript claim (line) | Source statement, verbatim (locator) | Verdict |
|---|---|---|---|
| B1 | rank r ≥ 2 (371) | "V → B of rank r ≥ 2 such that V∨ is globally generated" (2307.03696 L1196) | CONFIRMED |
| B2 | "Its comparison field adjoins q^{−1/r′}, with r′ = r when r−1 is even and r′ = 2r when r−1 is odd" (573-576) | (5.1): "r′ := r when r − 1 is even; 2r when r − 1 is odd" (L2286-2290) | CONFIRMED, exact including the parity convention |
| B3 | "the reconstruction coordinate remains u = q^{−1/r}" (575-578); "R_j the image of Q_T^d ↦ Q^d u^{c1(V)·d}" (578-579) | (5.2): "Q^d_B = q^{−c1(V)·d/r} Q^d for d ∈ H2(B, Z)" (L2300-2303). Thm 5.1: "ςj(τ̂) ∈ H∗(B)((q^{−1/r}))[[Q, τ̂]]" (L2338-2341). | CONFIRMED, exact |
| B4 | "Proposition 5.6 of [IritaniKoto] puts the normalized target coordinate in the maximal ideal, hence in J_j H^ev(T)" (607-609) | Prop. 5.6: "There exist σj ∈ −(2π√−1 j/r) c1(V) + τ(λj) + m H∗(B)[[q^{−1/r}, q^{−c1(V)/r}Q, q^{•/r}τ]] ... m ... is the closed ideal of C[[q^{−1/r}, q^{−c1(V)/r}Q, q^{•/r}τ]] ... generated by q^{−1/r} and q^{−c1(V)·d/r}Q^d with d ∈ Eff(B) \ {0}" (L2617-2640) | CONFIRMED in substance (m ⊂ J_j, so the containment follows a fortiori). Two wording slips: Iritani-Koto call m a *closed ideal*, not a maximal ideal, and it does not contain the bulk generators; and the restriction from H∗(B) to H^ev(T) presupposes the parity argument. Cosmetic; see S7. |
| B5 | "Theorem 5.1(4) and Proposition 5.6 give ς_j = ς_j° + s_j, ς_j° = rλ_j − (2πi j/r) c1(V) + O(u)" (611-618) | Thm 5.1(4): "ςj(τ̂)|Q=τ̂=0 = rλj − (2π√−1 j/r) c1(V) + O(q^{−1/r})", with "λj = e^{2π√−1 j/r} q^{1/r}" (L2372-2375, L2361) | CONFIRMED, exact. The `ς = ς° + s` shift decomposition itself is not in Iritani-Koto (it is (5.47) of the blowup paper); here it is a definition the manuscript makes, licensed by (4) and Prop. 5.6. |
| B6 | "Separate the Laurent unit as a single-valued rank-one exponential twist" for rλ_j (619-620) | End of proof of Thm 5.1: "the shift σj → σj + rλj in the H^0(B)-direction does not change the quantum product but affects the Euler vector field (2.3) and the covariant derivative in the q-direction (through q∂q(rλj) = λj)", and σj∗∇ + (λj/z)(dq/q) − rλj dz/z² = (σj + rλj)∗∇ (L2880-2895) | CONFIRMED — the source itself isolates exactly this H^0 shift, and λ_j = e^{2πij/r}u^{−1} is single-valued in u |
| B7 | (4.4d): nonlocalized coefficient ring is a power series ring in v, q^{−c1(V)·d/r}Q^d, q^{k/r}τ̂_{i,k}, cited to [(5.3)] and [Prop. 5.6] (624-642) | The exact ring appears in §5.5: "σj∗QDM(B)^{ext,loc} := σj∗QDM(B)^{ext} ⊗_{C[z][[q^{−1/r′}, q^{−c1(V)/r}Q, q^{•/r}τ]]} C[z]((q^{−1/r′}))[[Q, τ]]" (L2819-2822). (5.3) itself uses the *base* bulk parameter σ, not the scaled bulk variables (L2306-2312). Prop. 5.6 says "q^{•/r}τ stands for the infinite set {q^{k/r}τ^{i,k}} of variables" (L2630). | CONFIRMED in substance — the ring the manuscript writes is literally the display at L2819 — but the citation is to two places neither of which prints that ring, and Prop. 5.6's family is explicitly *infinite* while (4.4d) asserts finiteness. See S6. |
| B8 | "The bulk generators are finitely many, since 0 ≤ k ≤ r−1" (635-636) | End of proof of Thm 5.1: "(τ̂) ⊂ C((q^{−1/r}))[[τ̂]] denote the ideal generated by τ̂^{i,k} with 0 ≤ i ≤ s, 0 ≤ k ≤ r − 1" (L2973-2976); the bulk parameter is "τ̂ = Σ^s_{i=0} Σ^{r−1}_{k=0} τ̂^{i,k} ϕi p^k ∈ H∗(P(V))" (L2278-2281) | CONFIRMED for Theorem 5.1's τ̂ (which is the parameter the manuscript actually uses). It is *not* true of Prop. 5.6's τ, which is the cited object. |
| B9 | "the Novikov generators run over the effective monoid of the base, where ampleness leaves only finitely many below a given degree" (636-639) | Prop. 5.6: "K[[q^{−c1(V)/r}Q]] = { Σ_{d∈Eff(B)} c_d q^{−c1(V)·d/r} Q^d : c_d ∈ K }" (L2632-2634) | CONFIRMED (indexing set); the finiteness-below-a-degree statement is the manuscript's own, and is correct by finite-typeness of the Chow variety |
| B10 | (4.4e) "has invertible Jacobian by Theorem 5.1(5) ... an item corrected in the fourth version of that preprint, dated 31 January 2026, and hence is a graded formal coordinate isomorphism" (644-654) | Thm 5.1(5): "the Jacobian matrix of ς(τ̂) = ⊕^{r−1}_{j=0} ςj(τ̂) along Q = τ̂ = 0 is of the form (∂τ̂^{i,k} ςj)|Q=τ̂=0 = λ^k_j (ϕi + O(q^{−1/r})) and is invertible over C((q^{−1/r′}))" (L2376-2381). Thm 1.7 also states ς is "a formal invertible map ... over C((q^{−1/r′}))[[Q]]" (L156-160). arXiv v4 comment: "error in Theorem 5.1(5) corrected". | CONFIRMED, including the bibliographic claim about v4 |
| B11 | "its derivative gives the ring isomorphism in [Corollary 1.8]" (653-654) | Cor. 1.8: "The derivative of the map ς induces an isomorphism of the quantum cohomology rings (H∗(P(V)), ⋆τ̂) ≅ ⊕^{r−1}_{i=0} (H∗(B), ⋆ς_i(τ̂)) over the localized base C((q^{−1/r′}))[[Q]]" (L214-219) | CONFIRMED, exact |
| B12 | "Since the comparison maps use integral powers of z, the framed characteristic polynomial is preserved" (686-688) | Thm 5.1 states Φ as an isomorphism of the C[z]((q^{−1/r′}))[[Q, τ̂]]-modules QDM(P(V))_loc and ⊕ ς∗_j QDM(B)^{ext,loc} = H∗(B)[z]((q^{−1/r′}))[[Q, τ]] (L2341-2352, L2822-2824); the construction gives "a homomorphism of C[z, q][[Q, τ ]]-modules homogeneous of degree −(r − 1)" (L2886-2889); (5.10) gives Φ^{−1}|_{Q=τ̂=0} in H∗(B)[z][[q^{−1/r}]] (L3006-3013) | CONFIRMED. Worth recording that the intermediate Fourier transform *does* leave the log-free, z-polynomial world — "HB,C((q−1/r′)) := H∗(B) ⊗ C[z, z^{−1}]((q^{−1/r}))[[Q]][log q]" (L2538-2542), and Prop. 5.8's (5.7) carries the factor q^{−c1(V)/(rz)} (L2823-2826) — but Φ as stated in Theorem 5.1 does not, so the manuscript's claim is about the right object. |
| B13 | "The base Novikov map is the embedding in [(1.1) and Remark 5.2]" (693-694) | (1.1): "C[[QB]] ↪ C((q^{−1/r′}))[[Q]],  Q^d_B 7→ q^{−c1(V)·d/r} Q^d" (L138-148). Rem. 5.2: "The identification (5.2) corresponds to a splitting of π∗ : H2(P(V), Z) ↠ H2(B, Z) over Q defined by the kernel of c1(Tvert P(V)) = rp + π∗c1(V) ... it is intrinsic to the geometry of the projective bundle P(V) → B and is independent of the choice of the vector bundle V (up to tensoring with a line bundle)" (L2390-2398) | CONFIRMED, and the "independent … up to tensoring with a line bundle" clause is exactly what the global-generation remedy needs |
| B14 | "The theorem assumes V∨ globally generated. Tensoring V by a sufficiently negative line bundle achieves this without changing P_T(V) [Remark 1.2]" (694-697) | Rem. 1.2: "By tensoring V with a sufficiently negative line bundle, we can always assume that V∨ is generated by global sections, without changing P(V). This assumption ensures that JV^λ does not contain negative powers of λ and that the substitution λ = p + kz in the theorem is well-defined" (L84-89). The hypothesis is standing: "Hereafter we shall assume that V∨ is generated by global sections" (L631); also L624 (Lemma 2.1, semiprojectivity), L1196, L1756. | CONFIRMED, verbatim, and the manuscript is right that the hypothesis is genuinely required rather than decorative |
| B15 | "the resulting divisor shift preserves framed monodromy by [the formal base shift lemma]" (697-698) | Not a source claim. Rem. 5.2's intrinsicality clause is the closest source support. | Own addition; supported in spirit by Rem. 5.2, proved internally |
| B16 | "Formula (4.2) is tautological when r = 1" (703) | Sources exclude r = 1 (r ≥ 2 throughout) | CONFIRMED as a consistent boundary remark, not a source claim |

### C. Parity, and inputs the proof asserts without citation

| # | Manuscript claim (line) | Source position | Verdict |
|---|---|---|---|
| C1 | "After the odd bulk variables vanish, pullback, pushforward, Fourier transformation, and multiplication by the characteristic-class factors all preserve cohomological parity. Hence **both** decompositions restrict to the even quantum connections used here." (699-702) | For the blowup: Notes §2(a),(d) (see A20) — CONFIRMED. For the projective bundle: **no source statement exists.** The word "parity" does not occur in arXiv:2307.03696v4. | Half CONFIRMED, half own addition. See S3. |

## Severity-ranked mismatches and gaps

All line numbers below are in
`/home/tavis/src/othello/papers/cubic-stabilization-epilogue/sections/04-one-step.tex`.

**S1 — BLOCKING. The blowup-side Hahn value group is built from an infinite family of bulk
generators all carrying weight one, so "every permitted support is well ordered" is not
established.** Lines 449 (`w(s_{j,\ell})=1` for every component of `s_j`), 478-495 (display
(4.4a), which lists Iritani's scaled bulk variables `q^{k/(c-1)}θ_{Z,k} = u^{-k}θ_{Z,k}`
with no bound on k), and 516-526 (Γ_j^coeff formed from "the scaled source bulk variables",
then "Order this lattice by the preceding positive multidegree, then by any lexicographic
refinement. The finite-below property makes every permitted support well ordered").

In arXiv:2307.13555v3 the parameter θ is explicitly an infinite set of variables:
"θ = {θ^{i,k}}_{k∈N,i} is the parameter for θ = Σ_{i,k} θ^{i,k} ϕ_i λ^k ∈ H∗_T(W)"
(L3203-3205; also L2257, L523-524). With infinitely many generators of weight exactly one,
each multidegree has infinitely many monomials above it, and a lexicographic refinement of
the multidegree order admits infinite descending chains; the support of a series need not be
well ordered, so the coefficientwise map into `C((Γ_j^coeff))` is not shown to land in the
Hahn field. Everything downstream in the blowup half — the faithful embedding at 524-526,
the receiver `ℛ_j` at (4.4c), and the framed-operator comparison — rests on that step.

Iritani's own completion avoids this by grading the bulk variables: in Proposition 5.4 the
filtration F_N includes "θ^I is divisible by θ^{i,k} for some k ≥ N" (L4205-4210), i.e. level
at least k, not a uniform 1. The projective-bundle half of the manuscript gets this right by
a different route, explicitly invoking finiteness (line 635: "0 ≤ k ≤ r−1").

Two clean repairs, either sufficient: (i) work with Theorem 5.18's parameter τ̃ ∈ H∗(T̃),
which is finite-dimensional and is already what the manuscript's own display (4.4b) uses —
this makes the blowup case structurally identical to the bundle case; or (ii) adopt Iritani's
F_N weight, giving θ^{i,k} weight ≥ k, which restores finitely many generators below each
weight. As it stands, (4.4a) and (4.4b) are inconsistent with each other about which
parameter is in play.

**S2 — MODERATE. "The order is positive on every generator" is false for the ramified Novikov
generator, and the sentence that actually carries the argument is a different one.** Lines
638-641 ("The order is positive on every generator, so every element has well-ordered
support: this is the finite-below property used below") and the parallel at 486-489. The
generator `v = q^{-1/r'}` (respectively `q^{-1/s}`) is a *negative* power of a Novikov
variable — q is the class of a line in the fibre (bundle case) or in the exceptional divisor
(blowup case), both effective with positive ample degree — so v has nonpositive value in the
first slot of the stated order, and its exponent is unbounded below on the face of it. The
load-bearing fact is the neighbouring sentence, "The grading controls the negative v-power"
(line 642-643; "homogeneity controls the possible negative v-power" at 487-489), which is
correct: by Iritani's graded convention (Rem. 1.3/1.5; Iritani-Koto Rem. 5.3, L2400-2410) the
v-exponent of a monomial is pinned by the degrees of the remaining factors up to the finitely
many cohomological degrees. The proposition should be stated in that form — *finitely many
atoms below each multidegree, with the v-exponent determined by homogeneity* — rather than
via a positivity claim that is not true.

**S3 — MODERATE. Parity preservation is asserted for the projective-bundle decomposition with
no source and no proof.** Lines 699-702. Iritani's Notes supply this only for the blowup, and
say there that it "was omitted in [4], but it is obvious from the construction"
(2604.10028 L270, L299). Iritani-Koto never mention parity. The manuscript's lead-in at
333-337 is scrupulous — it cites the Notes for the blowup only — but the proof's closing
paragraph silently extends the conclusion to "both decompositions". Since ν_6 is defined on
the *even* quantum connection (line 141-147), the restriction of the Iritani-Koto
decomposition to the even part is a hypothesis of formula (4.2), not a corollary of anything
cited. Either give the two-line argument (the Fourier kernel, the characteristic-class
factors, and the mirror map all have even parity; Notes Remark 2 covers the ramified root)
or state it as an assumption.

**S4 — MINOR. Proposition 5.4 and (5.13)-(5.14) establish continuity of the forward Fourier
transform, not of the comparison map and its inverse.** Line 489-491. Proposition 5.4 says
"The map FT_X|QDM_T(W)_X̃ ... extends to a homomorphism ... on the completion" (L4185-4192);
(5.13) is a containment for FT_X. The comparison map of Theorem 5.18 is
Φ ∘ (FT_{X̃})^{-1} (L5712-5714), and the inverse Fourier direction is not what the cited
display bounds. Retarget the citation or add the inverse step.

**S5 — MINOR. The image ring attributed to Remark 5.6 is not Iritani's R.** Lines 425-435 and
458-459. Iritani's R is "the image of C[z][[Q_Z e^σ, σ′]][σ^0] under (5.15)" (L4275-4280) —
the Novikov variable is packaged with the *exponentiated* divisor bulk directions, which is
what makes the divisor equation work; and the conclusion is that z∇, not ∇, preserves
H∗(Z) ⊗ R. The manuscript's R_j adjoins `u = q^{-1/(c-1)}` and the shifted coordinates s_j
to the bare image of the Novikov monomial map. `u` is not in the image of (5.15) (that would
require i_∗d = 0 with ρ_C·d = c−1). The claim is repairable — B_j does contain the needed
exponentials — but as cited it over-reads Remark 5.6.

**S6 — MINOR. The nonlocalized ring (4.4d) is cited to two places that do not print it, and
the finiteness claim contradicts the cited proposition.** Lines 624-641. The ring the
manuscript writes is exactly the one displayed in Iritani-Koto §5.5 (L2819-2822); (5.3)
(L2306-2312) carries the base bulk parameter σ instead, and Proposition 5.6's variable set is
"the infinite set {q^{k/r}τ^{i,k}}" (L2630). The manuscript's "finitely many, since
0 ≤ k ≤ r−1" is correct for Theorem 5.1's τ̂ but false for Prop. 5.6's τ. Cite the §5.5
display, or Theorem 5.1 plus L2973-2976, rather than Prop. 5.6.

**S7 — COSMETIC.** (a) Line 402-406: the displayed Theorem 5.18 isomorphism omits the
pullbacks τ∗, ς_j∗ that the source carries; the manuscript restores them at (4.4b), so this
is presentational. (b) Line 607: Iritani-Koto's m is a closed ideal, not a maximal ideal, and
does not contain the bulk generators. (c) Line 607-608: "hence in J_j H^ev(T)" narrows the
source's H∗(B) to even cohomology, which is legitimate only after S3 is settled.

## Judgement on the paper's own additions

**Numerical Novikov quotient (`lem:numerical-base-change`, lines 339-367).** Not in any
source; both theorems are stated over Novikov rings of H_2. The passage survives. The
finiteness input is correct as argued — the Chow variety of cycles of bounded degree is of
finite type, hence has finitely many components, hence finitely many effective classes in
H_2(T,Z) of bounded ample degree, so each numerical fibre contributes a finite sum at every
cutoff. Every exponent the two theorems use is numerical: [D]·d̃, ρ_Z·d and c1(V)·d are
pairings with divisor classes, and the source degrees (deg Q^d = 2(c1(TB)+c1(V))·d, L2303)
are numerical too, so both the ring maps and the grading descend. Applying a ring
homomorphism to an isomorphism of free modules over the source ring yields an isomorphism
over the target ring, so the base change of the two comparison theorems is routine once the
homomorphism exists. No objection.

**Finite-below / well-ordered support argument (lines 440-457, 486-495, 516-526, 636-643).**
Survives on the projective-bundle side; **not established on the blowup side** — see S1 and
S2. The weight construction for R_j itself (lines 440-457) is sound: |ρ_C·d| ≤ const·(H·i_∗d)
on the effective cone holds by compactness of the ample slice of the closed cone, the weight
is a linear functional on the ambient exponent lattice so it respects the relations in the
image monoid, and ∩_N J_j^N = 0 follows. It is the *coefficient* lattice Γ_j^coeff, not R_j,
that is under-specified.

**Hahn receiver (4.4c) and (line 679-682).** Conditional on S1/S2. Given a genuine Hahn field
H_{0,j}, the receiver is fine: `Ω_{V,j}` and `C((Γ ⊕ Ze_z))` are both field extensions of
H_{0,j}, so the tensor product is nonzero and both factors inject, as the manuscript says.
The construction adds nothing the sources would contradict, because it operates purely on
coefficients: the source statements are module isomorphisms over a coefficient ring, and
scalar extension along a ring map preserves an isomorphism together with its inverse and the
connection identities. The one thing that would break the sources is a ramification of z, and
the manuscript is careful to adjoin only `e_z` with integral exponent (lines 532-544) — which
is exactly what Theorem 5.18 and Theorem 5.1 permit, since both fix Ψ, Φ and their inverses
in C[z]-linear rings (A18, B12).

**Algebraic closure and universal exponential field (lines 392-398, 526-531, 676-679).**
Survives. These are coefficient-field operations that fix C, and the invariant tested is the
multiplicity of the fixed roots of unity e^{±πi/3}, so the choice-independence argument at
lines 122-137 covers them. Nothing in either source is disturbed: neither theorem's statement
refers to the coefficient field beyond the named Novikov/Laurent ring.

**Continuity of the substitution and of its inverse (lines 509-514, 655-669).** Survives, and
on the blowup side the manuscript is *weaker* than the source: §5.8.2 already asserts that
τ̃ ↦ (t, s_0, …, s_{r−2}) is a formal invertible change of variables over
C((q^{−1/(r−1)}))[[Q]] and names its inverse (L5818-5822). On the bundle side the degreewise
argument with L invertible (Theorem 5.1(5)) and h order-raising is correct in the graded
convention; note that the manuscript's own observation that the higher-order terms carry
growing negative u-order — "growing negative u-order coupled to positive bulk degree is
retained rather than replaced by a fictitious uniform denominator" (line 685-687) — is
precisely what (5.9) shows, since the τ̂^{i,k}-linear coefficient is λ^k_j = u^{−k} and the
remainder lies in "(τ̂)²H∗(B)" with coefficients in C((q^{−1/r})) (L2961-2974). That is a
correct and non-obvious reading of the source, and it is the reason the naive J_j-adic
completion after inverting u would have been wrong.

**Possibly noninjective center specialization (lines 464-465, 706-709).** Handled exactly as
the source does: (5.15) is non-injective by Iritani's own parenthetical, and Remark 5.6
already tells one to work over the image. The manuscript's decision to write the center term
as ν_6(C; χ_j) — a *specialized* invariant, not ν_6(C) — and its explicit warning that
generic vanishing on C does not transfer, is the correct conclusion and is not overclaimed.

## What I could not verify, and why

1. **Whether v3 of Iritani-Koto stated Theorem 5.1(5) differently.** Only v4 is cached. The
   arXiv version-history comment for v4 confirms that an error in Theorem 5.1(5) was
   corrected and that Section 5.8 was added, which is all the manuscript asserts, so the
   bibliographic claim is confirmed at the level of the arXiv comment rather than by diffing
   the two texts.
2. **Iritani's Theorem 5.9, Corollary 4.9 and Lemma 5.13**, which supply the intermediate
   objects behind Theorem 5.18 (in particular the finite-dimensional slice H ⊂ H∗_T(W) used
   in §5.7-5.8.1). I read their statements only where they bear on S1; I did not verify their
   proofs. This does not affect any verdict above, but a full check of the blowup-side
   filtration bookkeeping would need them.
3. **Equation (5.28)** of the blowup paper (the Ψ° matrix) is badly mangled in the OCR
   extraction (L4948-4968) and could not be read. It is cited by the manuscript only inside
   the range "(5.27)–(5.30)", where (5.27), (5.29) and (5.30) alone already support the
   claim, so the gap is immaterial.
4. **The internal lemmas** `lem:pv-base-change`, `lem:formal-base-shift`, and Definition
   `def:framed-sixth-multiplicity` were read for context (they determine what the proposition
   needs from the sources) but were not audited as proofs; they are internal to the manuscript
   and outside this charge.
