# Cold read: `papers/discrepancy-one-flips` — defect hunt

Date: 2026-08-14. Reader: fresh, no prior context on the note.

Sources read in full: `discrepancy_one_flips.tex`, `sections/01-introduction.tex`,
`sections/02-hypotheses.tex`, `sections/03-normalization.tex`,
`sections/04-aperture.tex`, `sections/05-scope.tex`, `README.md`.
Upstream checked: `/tmp/persistent/tavis/lit-search/text/arXiv_2502.08762v2.txt`
(Shen–Shoemaker, "Quantum spectrum and Gamma structure for standard flips", v2), plus
`/tmp/persistent/tavis/lit-search/text/arXiv_math_0110142.txt` (Coates–Givental,
"Quantum Riemann–Roch, Lefschetz and Serre") for the two external citations that pin
numbered items.

Line numbers are as of the files at the time of reading. Paths are relative to
`/home/tavis/src/othello/papers/discrepancy-one-flips/`.

---

## MATH-AFFECTING

### A1. Abstract excludes all of `s=0`; the body excludes only `(r,s)=(1,0)`

- **File:** `discrepancy_one_flips.tex`, lines 62–64
- **Current text:**
  ```
  \(r-s\).  The only remaining formal failure of the normalization is the
  degenerate endpoint \(s=0\), whose point fibres contain
  no extremal line.
  ```
- **Proposed replacement:**
  ```
  \(r-s\).  The only remaining formal failure of the normalization is the
  degenerate endpoint \((r,s)=(1,0)\), whose point fibres contain
  no extremal line.
  ```
- **Reason:** Remark `rem:pbundle` (`sections/03-normalization.tex`, lines 292–300) shows the
  same `z`-order count succeeds for `s=0` whenever `r\ge2` (bound `1-rd\le-1`), so the
  normalization does *not* fail for all `s=0`; only `(r,s)=(1,0)` fails, which is also what
  `sections/01-introduction.tex` line 160, `rem:boundary`, `05-scope` line 49 and `README.md`
  line 40 say. "Point fibres" additionally requires `r=1`, not `s=0`.

### A2. Theorem `thm:aperture` asserts the wider sector is invalid; only unavailability is proved

- **File:** `sections/01-introduction.tex`, lines 106–109
- **Current text:**
  ```
    expansion of \cite[Proposition~7.5]{SS} for the component indexed by
    \(m=-k\) is valid on
    \(\bigl|\arg(z/q)+(2m+s)\pi\bigr|<\tfrac{3\pi}{2}\), and not on the wider
    sector obtained by setting \(r-s=1\) in \cite[(64)]{SS}.
  ```
- **Proposed replacement:**
  ```
    expansion of \cite[Proposition~7.5]{SS} for the component indexed by
    \(m=-k\) is valid on
    \(\bigl|\arg(z/q)+(2m+s)\pi\bigr|<\tfrac{3\pi}{2}\); \cite[Theorem~A.1]{SS}
    does not supply it on the wider sector obtained by setting \(r-s=1\)
    in \cite[(64)]{SS}.
  ```
- **Reason:** Lemma `lem:center` proves only that Barnes/Theorem A.1 at `\epsilon=1/2` yields
  the `3\pi/2` sector and that the naive specialization of (64) is `\pi/2` wider on each side.
  It does not prove the expansion fails on the wider sector. The rest of the note is careful
  about this — abstract line 65 says "unavailable", `01-introduction` line 152 says "than
  Barnes' expansion supports", `04-aperture` line 75 says "smaller than the naive
  specialization" — so this one sentence is the outlier and is a genuine over-claim.

### A3. "The second uses only Theorem A.1"; the aperture argument also uses Theorem A.2

- **File:** `sections/01-introduction.tex`, lines 75–76
- **Current text:**
  ```
  This note supplies the two missing steps.  The second uses only
  \cite[Theorem~A.1]{SS}, in the form the authors state it.
  ```
- **Proposed replacement:**
  ```
  This note supplies the two missing steps.  The second uses only
  \cite[Theorems~A.1 and~A.2]{SS}, in the form the authors state them.
  ```
- **Reason:** Theorem `thm:aperture` has two halves; the second (the Proposition 8.2 sector) is
  proved in Lemma `lem:ambient` (`sections/04-aperture.tex`, lines 91–99), whose proof invokes
  `\cite[Theorem~A.2]{SS}`. `sections/02-hypotheses.tex` line 85 also names Theorem A.2 as the
  source of (78). As printed, the introduction understates the inputs.

### A4. Theorem 1.2 of Shen–Shoemaker grouped with the statements that carry no `\nu` restriction

- **File:** `sections/01-introduction.tex`, lines 33–35
- **Current text:**
  ```
  \cite[Theorems~1.2, 1.4 and~9.14, Corollary~1.5]{SS}, and it is stated for
  standard flips with the explicit remark that it covers the blow-up case
  \(s=1\) and the projective-bundle case \(s=0\).
  ```
- **Proposed replacement:**
  ```
  \cite[Theorems~1.2, 1.4 and~9.14, Corollary~1.5]{SS}; apart from
  \cite[Theorem~1.2]{SS}, which assumes \(r-s>1\), it is stated for
  standard flips with the explicit remark that it covers the blow-up case
  \(s=1\) and the projective-bundle case \(s=0\).
  ```
- **Reason:** Hypothesis strictness stated two ways. Upstream Theorem 1.2 opens "Assume that
  `r − s > 1`" (line 328 of the extraction), and the remark about `s=0` and `s=1` (line 373)
  is attached to Theorem 1.4, not to Theorem 1.2. The note itself says at line 70 that
  "Theorem~1.2 is proved only in its stated range `r-s>1`", and the abstract (line 45) says
  "Their Theorem~1.2 is printed only for `r-s>1`".

### A5. Sections 9.1–9.4 said to carry no inequality beyond `r>s`, contradicting `rem:circularity`

- **File:** `sections/02-hypotheses.tex`, lines 86–90
- **Current text:**
  ```
  are stated and proved with \(r>s\) as the only inequality.
  ```
  (closing the sentence begun at line 86, "and the reductions of
  `\cite[Sections~9.1--9.4]{SS}` --- weak-to-strong in the local model, the reduction to the
  split case, the cohomological reduction to the local model, and the comparison of the
  Fourier--Mukai transform with the local model ---")
- **Proposed replacement:**
  ```
  state no inequality beyond \(r>s\), although the reduction to the split case
  runs through \cite[Lemmas~9.4--9.6]{SS}, whose proofs read \eqref{eq:ss35} as
  the extremal \(J\)-function; see Remark~\ref{rem:circularity}.
  ```
- **Reason:** Remark `rem:circularity` (`03-normalization`, lines 239–255) and `05-scope`
  lines 35–39 both say the opposite in substance: Section 9.2 runs through Lemmas 9.4–9.6,
  and Lemma 9.4's proof reads "By (35) the J-functions of `T` and `T_sp` agree" (extraction
  line 3735), i.e. it inherits Theorem 4.4's `r-s>1`. Verified upstream. As printed, Section 2
  claims independence that Section 3 then denies. A forward reference to `rem:circularity` is
  already used at `02-hypotheses` line 80, so the proposed cross-reference is in keeping.

### A6. Coates–Givental Corollary 2 does not state the concave/inverse-Euler identification

- **File:** `sections/03-normalization.tex`, lines 156–159
- **Current text:**
  ```
    the theory twisted by the inverse \(\C^{\times}\)-equivariant Euler class
    is the Gromov--Witten theory of the total space, which is
    \cite[Corollary~2]{CoatesGivental};
  ```
- **Proposed replacement:**
  ```
    the theory twisted by the inverse \(\C^{\times}\)-equivariant Euler class
    is the Gromov--Witten theory of the total space, the concave case recorded
    in the introduction of \cite{CoatesGivental};
  ```
- **Reason:** In the Coates–Givental extraction, Corollary 2 is the nonlinear Serre duality
  identity `D_{s*} = (sdet c(E))^{-1/24} D_s` (line 545), relating the `c`-twisted theory of
  `E` to the `c*`-twisted theory of `E*`. The statement actually used here — "When E is
  concave, and the inverse `C^\times`-equivariant Euler class is chosen, the twisted theory
  yields GW-invariants of `E_X`" — is in their introduction (lines 13–15) and is not
  Corollary 2. Shen–Shoemaker themselves cite `[12]` without a number here (extraction line
  1267). Confidence: high that Corollary 2 is misnamed; medium on the best replacement
  wording.

---

## MATH-SAFE

### S1. Cone-level quantum Riemann–Roch is Corollary 4, and the cone transformation is unquantized

- **File:** `sections/03-normalization.tex`, lines 159–162
- **Current text:**
  ```
   and quantum Riemann--Roch
    \cite[Theorem~1]{CoatesGivental} presents the twisted cone as the image of
    \(\mathcal L_{\PP(V)}\) under an explicit quantized symplectic
    transformation.
  ```
- **Proposed replacement:**
  ```
   and quantum Riemann--Roch
    \cite[Theorem~1]{CoatesGivental}, in its genus-zero cone form
    \cite[Corollary~4]{CoatesGivental}, presents the twisted cone as the image of
    \(\mathcal L_{\PP(V)}\) under an explicit symplectic transformation.
  ```
- **Reason:** Coates–Givental Theorem 1 is stated on total potentials in the Fock space; the
  genus-zero cone statement `L_s = exp{...} L_0` is Corollary 4 (extraction lines 667–680),
  and they say explicitly (lines 661–666) that on cones the quantized `exp \hat A` becomes the
  "unquantized" `exp A`.

### S2. Wrong internal citation for the `q^{(r-s)d}` weight

- **File:** `sections/03-normalization.tex`, lines 104–105
- **Current text:**
  ```
  In either reading the degree-\(d\) summand carries \(q^{(r-s)d}\) by
  \cite[(33)]{SS}.
  ```
- **Proposed replacement:**
  ```
  In either reading the degree-\(d\) summand carries \(q^{(r-s)d}\) by
  \eqref{eq:ss35}.
  ```
- **Reason:** Upstream (33) is the Novikov/parameter specialization `Q^d=1` if `d=k[L]`,
  `Q^d=0` otherwise, `t = t + \ln(q)c_1(T)` (extraction lines 1206–1207). The weight
  `q^{(r-s)d}` appears in (35), which is `\eqref{eq:ss35}` in this note.

### S3. Shen–Shoemaker Remark 4.5(3) is two sentences, not one with two halves

- **File:** `sections/03-normalization.tex`, lines 121–123
- **Current text:**
  ```
  cone membership that this uses at
  all.  This is asserted in \cite[Remark~4.5(3)]{SS}, in the same sentence
  whose first half Corollary~\ref{cor:normalized} contradicts, so we prove it
  instead of quoting it.
  ```
  (the exact contiguous string to replace is `in the same sentence
  whose first half Corollary~\ref{cor:normalized} contradicts`)
- **Proposed replacement:**
  ```
  the same remark
  whose other assertion Corollary~\ref{cor:normalized} contradicts
  ```
- **Reason:** Upstream Remark 4.5(3) reads "In the case `r−s ≤ 1`, ... cannot be equal to the J
  function of T. Nevertheless it can be shown ... that (35) lies on the Lagrangian cone of T"
  (extraction lines 1282–1284) — two separate sentences. `01-introduction` line 78 already says
  "the same remark", so this also removes an internal inconsistency.

### S4. "discrepancy" reused in a second, unrelated sense

- **File:** `sections/03-normalization.tex`, lines 117–118
- **Current text:**
  ```
  that coefficient, and the mirror map is precisely the discrepancy between
  the prescribed \(z^{0}\) coefficient and the parameter one started with.
  ```
- **Proposed replacement:**
  ```
  that coefficient, and the mirror map is precisely the difference between
  the prescribed \(z^{0}\) coefficient and the parameter one started with.
  ```
- **Reason:** `sections/01-introduction.tex` lines 20–23 define "the *discrepancy* of the flip"
  to be `\nu := r-s`, and the word carries that meaning everywhere else in the note (including
  the title). Using it here for an unrelated difference collides with the definition.

### S5. Misdescribed index counts of the Meijer `G`-function

- **File:** `sections/04-aperture.tex`, lines 21–23
- **Current text:**
  ```
  In the notation of \cite[Appendix~A]{SS} the lower and upper index counts of
  this \(G\)-function are \(s\) and \(r\), so the parameter governing the
  asymptotic expansion is
  ```
- **Proposed replacement:**
  ```
  In the notation of \cite[Appendix~A]{SS} the upper and lower parameter rows of
  this \(G\)-function have \(s\) and \(r\) entries, so the parameter governing the
  asymptotic expansion is
  ```
- **Reason:** In `G^{r,0}_{s,r}` both `s` and `r` are subscripts, so "lower and upper index
  counts" does not identify them; and if read as naming the parameter rows it is reversed —
  the upper row `1-\sigma_1,\dots,1-\sigma_s` has `s` entries and the lower row
  `\rho_1,\dots,\rho_r` has `r`. The parenthetical at lines 28–30 remains correct under the
  replacement.

### S6. "Of the same argument" / "the same substitution": the constant phase differs

- **File:** `sections/04-aperture.tex`, lines 92–97
- **Current text:**
  ```
    \cite[Proposition~8.2]{SS} is deduced from \cite[(76)]{SS}, which applies
    \cite[Theorem~A.2]{SS} to a \(G^{r,1}_{s,r}\) function of the same
    argument.  The hypothesis of \cite[Theorem~A.2]{SS} is
    \(|\arg t|<(\tfrac\nu2+1)\pi\); it involves no \(\epsilon\) and no
    restriction on \(\nu\).  Transporting it through the same substitution as
    above gives \eqref{eq:ss78} for every \(\nu\ge1\), and the displayed form
    at \(\nu=1\).
  ```
- **Proposed replacement:**
  ```
    \cite[Proposition~8.2]{SS} is deduced from \cite[(76)]{SS}, which applies
    \cite[Theorem~A.2]{SS} to a \(G^{r,1}_{s,r}\) function of the argument
    \(t=e^{\pi\sqrt{-1}(1-s)}(q/z)^{r-s}\) of \cite[(75)]{SS}.  The hypothesis of
    \cite[Theorem~A.2]{SS} is
    \(|\arg t|<(\tfrac\nu2+1)\pi\); it involves no \(\epsilon\) and no
    restriction on \(\nu\).  Transporting it through that substitution gives
    \eqref{eq:ss78} for every \(\nu\ge1\), and the displayed form
    at \(\nu=1\).
  ```
- **Reason:** Upstream (75) sets `t = e^{\pi\sqrt{-1}(1-s)}(q/z)^{r-s}` (extraction lines
  3085–3094), whose constant phase differs from the `e^{-\pi\sqrt{-1}(2m+s)}` of `\eqref{eq:kappa}`.
  That phase difference is exactly what puts the two sector centres `\pi` apart in
  `prop:common`, so calling the arguments and substitutions "the same" is misleading here even
  though both sectors are quoted correctly.

### S7. `\dim` vs `\rk` for the same multiplicity

- **File:** `sections/01-introduction.tex`, lines 93–95
- **Current text:**
  ```
    \(s\ge1\), as does \cite[Theorem~1.2]{SS}, with the single nonzero
    eigenvalue \(\lambda_{0}(q)=(-1)^{s}q\) of multiplicity
    \(\dim H^{*}(Z)\).
  ```
- **Proposed replacement:**
  ```
    \(s\ge1\), as does \cite[Theorem~1.2]{SS}, with the single nonzero
    eigenvalue \(\lambda_{0}(q)=(-1)^{s}q\) of multiplicity
    \(\rk H^{*}(Z)\).
  ```
- **Reason:** Corollary `cor:presentation` (`03-normalization`, line 269) writes the same
  multiplicity as `\rk H^{*}(Z)`, and upstream Theorem 1.2 writes `rank(H^*(Z))`. The macro
  `\rk` is defined in the preamble and used elsewhere in the note.

### S8. `\one` and `\bar{\mathbf t}` used in the abstract with no definition

- **File:** `discrepancy_one_flips.tex`, line 54
- **Current text:**
  ```
  \(z\one+\bar{\mathbf t}+O(z^{-1})\), no mirror-map correction arises, and
  ```
- **Proposed replacement:**
  ```
  \(z\one+\bar{\mathbf t}+O(z^{-1})\) with \(\one\) the unit class and
  \(\bar{\mathbf t}=t+\ln(q)c_{1}(T)\) the extremal parameter, no mirror-map
  correction arises, and
  ```
- **Reason:** Both symbols are first defined in the body (`\bar{\mathbf t}` at
  `02-hypotheses` line 24, and `\one` implicitly there too). The abstract is read standalone.

### S9. `\epsilon` used in the abstract with no definition

- **File:** `discrepancy_one_flips.tex`, lines 64–67
- **Current text:**
  ```
  no extremal line.  Second, at \(\nu:=r-s=1\) the
  sector printed after their Lemma~7.4 is unavailable, being the
  \(\epsilon=1\) case of their own Theorem~A.1; the correct \(\epsilon=1/2\)
  sector still meets the sector of their Proposition~8.2 in an open sector of
  ```
- **Proposed replacement:**
  ```
  no extremal line.  Second, at \(\nu:=r-s=1\) the
  sector printed after their Lemma~7.4 is unavailable: their own Theorem~A.1
  is valid on \(|\arg t|<(\nu+\epsilon)\pi\) with \(\epsilon=1\) only for
  \(\nu>1\) and \(\epsilon=\tfrac12\) at \(\nu=1\), and the correct
  \(\epsilon=\tfrac12\)
  sector still meets the sector of their Proposition~8.2 in an open sector of
  ```
- **Reason:** `\epsilon` is Shen–Shoemaker's Appendix A parameter, defined in this note only at
  `04-aperture` equation `eq:A1`. As printed, the abstract's two `\epsilon` values are
  uninterpretable on a cold read. Also normalizes `1/2` to `\tfrac12` as used elsewhere.

### S10. Coefficient ring of `\eqref{eq:ss35}` omits `\ln q`, which the note itself raises later

- **File:** `sections/03-normalization.tex`, line 24
- **Current text:**
  ```
  is a finite sum, and \eqref{eq:ss35} is an element of \(zA[z^{-1}][[q]]\).
  ```
- **Proposed replacement:**
  ```
  is a finite sum, and each summand of \eqref{eq:ss35} is an element of
  \(zA[z^{-1}][[q]]\) once the prefactor's \(\ln q\) is handled as described
  before Lemma~\ref{lem:jslice}.
  ```
- **Reason:** The prefactor `q^{c_{1}(T)/z} = e^{\ln(q)c_{1}(T)/z}` puts `\ln q` in the
  coefficients, which the note acknowledges at lines 98–107 ("The parameter
  `\bar{\mathbf t}=t+\ln(q)c_{1}(T)` is not literally defined over `\C[[q]]`"). As printed,
  line 24 asserts something the note later says needs care.

### S11. Convergence given as the reason Shen–Shoemaker assume `r>s`

- **File:** `sections/03-normalization.tex`, lines 87–89
- **Current text:**
  ```
  \(d\)-independent value \(1-s\) and the sum is not \(q\)-adically
  convergent, which is why \(r>s\) is assumed throughout \cite{SS}.
  ```
- **Proposed replacement:**
  ```
  \(d\)-independent value \(1-s\) and the sum is not \(q\)-adically
  convergent, consistently with the standing assumption \(r>s\) in \cite{SS}.
  ```
- **Reason:** Upstream imposes `r>s` in the geometric setup of the local model — "vector
  bundles of rank `r`, `s` respectively, with `r > s`" (extraction line 895) — not as a
  convergence condition. The `q`-adic observation is correct; the attribution is not.

### S12. Vacuous contrast in the closing paragraph

- **File:** `sections/05-scope.tex`, lines 85–87
- **Current text:**
  ```
  identification \(I=J\) and a nontrivial mirror map at \(\nu=1\) is not the
  codimension of the centre but the presence of at least one factor in
  \(V'\).
  ```
- **Proposed replacement:**
  ```
  identification \(I=J\) and a nontrivial mirror map at \(\nu=1\) is the
  presence of at least one factor in \(V'\), that is \(s\ge1\).
  ```
- **Reason:** At `\nu=1` the centre `Z\subset\bar X` has codimension `r=s+1`, so "codimension
  at least two" and "`s\ge1`" are the same condition and the stated contrast has no content.
  "The centre" is also undefined in the note, where both `Z\subset\bar X` (codimension `r`) and
  `F\subset X` (codimension `s`) are in play.

### S13. Remark 4.5(3) counted among the hypotheses that Sections 5–9 depend on

- **File:** `sections/02-hypotheses.tex`, lines 33–35
- **Current text:**
  ```
  Three statements of \cite{SS} carry a hypothesis on \(\nu=r-s\), and the
  whole of Sections~5--9 depends on them through the chain recorded below.  We
  list each with the inequality it states and the statements that use it.
  ```
- **Proposed replacement:**
  ```
  Three places in \cite{SS} carry a hypothesis on \(\nu=r-s\), and the
  whole of Sections~5--9 depends on the first and third through the chain
  recorded below.  We list each with the inequality it states and the
  statements that use it.
  ```
- **Reason:** The table immediately below records the second row (Remark 4.5(3)) as "Used by:
  nothing; a negative assertion", so "depends on them" is inaccurate for one of the three.
  "Places" also fits the third entry, which is an introductory clause rather than a numbered
  statement.

### S14. "The sentence ``For `r-s>1`''" — it is a clause

- **Files:** `sections/01-introduction.tex`, lines 62–63; `sections/04-aperture.tex`, lines 43–45
- **Current text (`01-introduction.tex`):**
  ```
  \cite[Lemma~7.4]{SS} is introduced by the sentence ``For \(r-s>1\)'', and the
  ```
- **Proposed replacement:**
  ```
  \cite[Lemma~7.4]{SS} is introduced by the clause ``For \(r-s>1\)'', and the
  ```
- **Current text (`04-aperture.tex`):**
  ```
  in \cite[Section~7]{SS} after \cite[Lemma~7.4]{SS} is introduced by the
  sentence ``For \(r-s>1\)'', and the sector recorded with it,
  ```
- **Proposed replacement:**
  ```
  in \cite[Section~7]{SS} after \cite[Lemma~7.4]{SS} is introduced by the
  clause ``For \(r-s>1\)'', and the sector recorded with it,
  ```
- **Reason:** Upstream reads "For `r − s > 1`, we apply Barnes' asymptotic formula in [37, 35]
  (see Theorem A.1) to the Meijer G-function in Lemma 7.4 ..." (extraction line 2553) — the
  quoted fragment opens a sentence rather than being one.

### S15. Dead macro

- **File:** `discrepancy_one_flips.tex`, line 25
- **Current text:**
  ```
  \newcommand{\Ghat}{\widehat{\Gamma}}
  ```
- **Proposed replacement:** delete the line.
- **Reason:** `\Ghat` is never used in any of the five section files or the main file. Harmless,
  but it is the only unused definition in the preamble. (`eq:nu`, `rem:blowup`, `rem:pbundle`
  and `rem:uniqueness` are likewise labelled and never referenced; those are normal for
  remarks and I do not propose changing them.)

---

## CHECKED AND CORRECT

Recorded so the coverage of this read is visible. Nothing below needs changing.

### Internal cross-references and LaTeX

- Every `\ref`/`\eqref` in the five section files resolves to a label defined in those files;
  there are no dangling references. Unused labels: `eq:nu`, `rem:blowup`, `rem:pbundle`,
  `rem:uniqueness` (harmless).
- Section cross-references `sec:hypotheses`, `sec:normalization`, `sec:aperture`, `sec:scope`
  all point at the section they name.
- Theorem/lemma/corollary references in proofs (`lem:order` in `cor:normalized` and
  `rem:boundary` and `rem:pbundle`; `lem:jslice`, `lem:cone`, `cor:normalized`,
  `lem:split-reduction` in `prop:IJ`; `lem:center`, `lem:ambient`, `prop:common` in
  `05-scope`) all point at the statement actually used.
- Macros `\C`, `\PP`, `\one`, `\rk`, `\Db` are all defined and used consistently.

### Citations into Shen–Shoemaker arXiv:2502.08762v2

Every numbered item cited by the note was located in the extraction and has the right item
type and number:

- Theorem 1.1 (semiorthogonal decomposition, `0 \le k \le r-s`, components `D^b_{-k}(Z), …,
  FM(D^b(X')), D^b_0(Z), …, D^b_{r-s-1-k}(Z)`) — line 183. At `r-s=1` this leaves the single
  `Z`-component `m=-k` with `k\in\{0,1\}`, as `prop:common` says.
- Theorem 1.2 (assume `r-s>1`; eigenvalue 0 of multiplicity `rank(H^*(X'))`; `r-s` nonzero
  eigenvalues `\lambda_k(q)=(r-s)e^{-\pi\sqrt{-1}(2k+s)/(r-s)}q`, each of multiplicity
  `rank(H^*(Z))`) — line 328. The note's transcription in `cor:presentation` is exact.
- Definition 1.3, Theorem 1.4 with parts (1) ray `\arg(z/q)=\frac{-2m-s}{r-s}\pi` and (2) tame
  ray `\frac{1-s}{r-s}\pi`, Corollary 1.5, Remark 1.6 (including the condition
  `\tfrac14(r-s-6)<k<\tfrac34(r-s+2)`) — lines 359, 375, 389, 400, 427.
- (3), (11), (18), (20), (28), (29), (32), (33), (34), (35), (36), (37), (38), (39), (40),
  (64), (75), (76), (78) — all present, and the note's transcriptions of (35), (37), (64) and
  (78) are character-for-character faithful to the displayed formulas.
- Lemma 2.6, Proposition 3.1, Corollary 3.2, Theorem 3.3, Proposition 4.1, Theorem 4.2,
  Corollary 4.3, Theorem 4.4 (with `r-s>1`), Remark 4.5 parts (2) and (3), Theorem 4.6,
  Remark 4.7, Propositions 5.1 and 5.2, Corollary 5.3, Lemma 7.4, Proposition 7.5,
  Corollary 7.6, Proposition 7.8, Propositions 8.2, 8.3, Corollary 8.4, Propositions 9.1 and
  9.2, Corollary 9.3, Lemmas 9.4, 9.5, 9.6, Corollary 9.7, Theorem 9.9, Theorem 9.14,
  Theorems A.1 and A.2, Sections 4.3 and 9.1–9.4 — all exist with the cited type and number.
- Section titles 9.1–9.4 match the note's one-line descriptions ("Weak implies strong in the
  local model", "Reducing to the split case", "Cohomological reduction to the local model",
  "Comparing the Fourier-Mukai transform to the local model").
- "The two statements of Theorem 1.4 are given by Theorem 9.9 and Theorem 9.14" is stated
  verbatim upstream (extraction line 4307), confirming `05-scope` lines 40–41.
- Remark 4.5(3)'s attribution of cone membership to `[11]`, `[12]` and Lemma 9.6 matches the
  note; `[11]`=Brown, `[12]`=Coates–Givental, `[14]`=Cox–Katz, `[39]`=Pandharipande,
  `[35]`=Luke, `[37]`=Meijer, `[4]`=Barnes, `[7]`=Belmans–Fu–Raedschelders, `[19]`=GGI, all
  matching this note's bibliography.
- Theorem 4.6's proof does quote `[14, Theorem 10.3.1]` and `[39, Lemma 2]`, i.e.
  Cox–Katz Theorem 10.3.1 and Pandharipande Lemma 2, as `02-hypotheses` line 58 says.
- The circularity claim in `rem:circularity` is genuine: Lemma 9.4's proof reads "By (35) the
  J-functions of `T` and `T_sp` agree under this isomorphism of cohomology rings"
  (extraction line 3735).
- Appendix A: `\nu := q - p`, `\epsilon = 1` if `\nu>1` and `\epsilon = 1/2` if `\nu=1`
  (line 4365); Theorem A.1 valid for `|\arg t| < (\nu+\epsilon)\pi`; Theorem A.2 valid for
  `|\arg t| < \tfrac\nu2\pi+\pi`. The note's `eq:A1` and its statement of A.2's hypothesis are
  exact.

### Arithmetic and algebra

- `\tau^{*}K_{X}-\tau'^{*}K_{X'}=(r-s)E`: from `K_{\widehat X} = \tau^*K_X+(s-1)E =
  \tau'^*K_{X'}+(r-1)E`. Correct.
- Lemma `lem:order`: numerator `\prod_{j=1}^{s}\prod_{m=0}^{d-1}(\sigma_j-H-mz)` has `sd`
  factors, `s` of them (`m=0`) free of `z`, so degree `\le s(d-1)` in `z`; denominator has `rd`
  factors each with `m\ge1`, inverse in `z^{-rd}A[z^{-1}]`; leading `z` adds one. Total
  `1+s(d-1)-rd = 1-s-\nu d`. Correct, and the identity `1+s(d-1)-rd=1-s-(r-s)d` checks out.
- Naive count `1+sd-rd=1-\nu d`, equal to `0` at `d=1,\nu=1` (introduction lines 132–134).
  Correct.
- Corollary `cor:normalized`: at `\nu=1`, bound `1-s-d \le -1` for `s\ge1,d\ge1`. Correct.
- Remark `rem:boundary`: at `(r,s)=(1,0)` the bound is `1-d`, attained at `d=1`, and
  `z\,q/(\rho_1+H+z) = q\one - q(\rho_1+H)/z + \cdots`. Correct.
- Remark `rem:boundary`, `\nu=0`: bound `1-s`, `d`-independent. Correct.
- Remark `rem:pbundle`: at `s=0` the bound is `1-rd`, which is `\le-1` for all `d\ge1` iff
  `r\ge2`. Correct.
- `05-scope` lines 82–84: at `\nu=1` the bound `1-s-\nu d` equals `-1` exactly at `s=1,d=1`,
  and rises to `0` at `s=0,d=1`. Correct.
- `z\,e^{t/z}q^{c_1(T)/z} = z\,e^{\bar{\mathbf t}/z}` with `\bar{\mathbf t}=t+\ln(q)c_1(T)`.
  Correct.
- Rank `s(k-1)` of `R^1\pi_{C*}f^*V'(-1)` in genus zero along a degree-`k` extremal class:
  `-\chi = -(-sk + s) = s(k-1)`. Correct.
- Concavity argument (sections vanish on every component of positive degree, then on the
  contracted components by connectedness of the dual tree). Correct.
- `1/(mz+a) = (1/(mz))\sum_{l\ge0}(-a/(mz))^{l}`, finite because `a` is nilpotent in `A`.
  Correct.
- `\arg t_m = -(2m+s)\pi - \nu\arg(z/q)` from `t_m=e^{-\pi\sqrt{-1}(2m+s)}(q/z)^{r-s}`, and
  `|\arg t_m|<\tfrac32\pi` at `\nu=1` gives `eq:center`. Correct.
- `eq:ss64` is the `\epsilon=1` transport: `|\arg t_m|<(\nu+1)\pi \iff
  |\arg(z/q)+(2m+s)\pi/\nu|<(1+1/\nu)\pi`. Correct.
- `eq:ss78` is the A.2 transport: `|\arg t|<(\tfrac\nu2+1)\pi \iff
  |\arg(z/q)-(1-s)\pi/\nu|<(\tfrac12+1/\nu)\pi`; at `\nu=1` this is `3\pi/2`. Correct.
- `prop:common`: with `m=-k` the centres are `(2k-s)\pi` and `(1-s)\pi`, at distance
  `|2k-1|\pi=\pi` for `k\in\{0,1\}`; two open intervals of half-width `3\pi/2` at distance
  `\pi` meet in an interval of length `3\pi-\pi=2\pi`; since `\pi<3\pi/2` each centre lies in
  the other interval. The stated intersection `eq:common` is the correct
  `\max(\cdot)-3\pi/2 < \arg(z/q) < \min(\cdot)+3\pi/2`, and both named rays lie strictly
  inside for `k=0` and `k=1`. Correct.
- The worked `(r,s)=(2,1)`, `k=m=0` numbers, in both `01-introduction` lines 116–120 and
  `rem:blowup`: `eq:center` is `(-\tfrac{5\pi}2,\tfrac\pi2)` (centre `-\pi`), `eq:ss78` is
  `(-\tfrac{3\pi}2,\tfrac{3\pi}2)` (centre `0`), intersection `(-\tfrac{3\pi}2,\tfrac\pi2)`,
  containing the tame ray `0` and the eigenvalue ray `-\pi`. Correct, and the two passages
  agree with each other.
- `\lambda_0(q)=e^{-\pi\sqrt{-1}s}q=(-1)^{s}q`; at `(r,s)=(2,1)`, `\lambda_0=-q` and
  `\exp(-\lambda_0(q)/z)=\exp(q/z)`. Correct.
- `\lambda_k(q)=(r-s)e^{-\pi\sqrt{-1}(2k+s)/(r-s)}q` for `0\le k<r-s`, reducing at `r-s=1` to
  the single `k=0`. Matches upstream (12) exactly.
- Remark 1.6's condition at `r-s=1`: `\tfrac14(1-6)=-\tfrac54` and `\tfrac34(1+2)=\tfrac94`,
  so `-\tfrac54<k<\tfrac94` admits `k=0` and `k=1`. Correct.
- `2\pi > \pi`, the level-one uniqueness threshold. Correct.

### Consistency checks that passed

- The abstract's `z`-order claim (`1-s-(r-s)d`), Theorem `thm:normalization`, Lemma
  `lem:order`, Corollary `cor:normalized` and the `README.md` summary all state the same bound.
- The two statements of the aperture result (Theorem `thm:aperture` in the introduction and
  Lemmas `lem:center`/`lem:ambient` plus `prop:common` in Section 4) agree on both sectors,
  both centres, and the `2\pi` opening.
- Corollary `cor:repaired` (introduction) and Theorem `thm:assembled` (`05-scope`) list the
  same five upstream results (Theorems 1.2, 1.4, 9.9, 9.14 and Corollary 1.5) under the same
  hypothesis `r=s+1`, `s\ge1`.
- `README.md` correctly names the excluded endpoint as `(r,s)=(1,0)` — the abstract is the one
  place that says `s=0` instead (issue A1).

### Not verifiable from local sources

- `\cite[Theorem~1]{Brown}` and `\cite[Corollary~1]{Brown}` (Brown, *Gromov–Witten invariants
  of toric fibrations*). The paper is not in the local literature cache. The Corollary 1
  attribution is consistent with Shen–Shoemaker, who cite "[11, Corollary 1]" for exactly this
  step (extraction line 1267); the Theorem 1 attribution I could not check.
