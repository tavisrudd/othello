# AME--LU referee edit packet applied (2026-08-16)

**Lane:** `ame-lu`.  Source packet: `/tmp/persistent/tavis/opus_ame_lu_edit_packet.md`
(user-supplied, not tracked here).  Target: the 37-page *Local-Unitary Rigidity
and Quantitative Rounding for Stabilizer AME States* under `papers/ame_lu`.

The packet was written against `ame-lu (3).pdf`, SHA-256
`ee2dd0077...67681a9`.  The tracked `papers/ame_lu/ame-lu.pdf` at commit
`0c799f881` hashed to exactly that value, so every anchor was matched against
the same rendering the reviewer read.  All twelve APPLY anchors matched
verbatim; none was approximate, and no edit was skipped.

Authoritative commit: `e5d77ed0e`.

## Applied edits

1. **Corollary B.19, "Quadratic growth"** (`sections/B-secondary-quantitative.tex`).
   `e^{-i\theta}` corrected to `e^{i\theta}` in the bra identity, and the
   hand-wave "after conjugating the left factor" replaced by "so the modulus is
   unchanged".  The conclusion `f(gV)=f(V)` was already correct.
2. **Theorem 5.3 proof** (`sections/05-quantitative-rounding.tex`).  The local
   logarithms are now constructed rather than invoked: a phase `z_i` attaining
   the minimum in (5.5), a principal Hermitian logarithm `a_i` of
   `z_i^{-1}K_i^\dagger U_i`, the centered `h_i=a_i-\bar a_i I`, and an explicit
   rephasing of `K_i` by `z_i e^{i\bar a_i}` that moves `K` only by a global
   phase and leaves its projective Clifford action alone.  Phase-minimizing the
   Hilbert--Schmidt distance does not by itself make the principal logarithm
   traceless, so the old wording had a genuine gap.  The middle term of (5.6)
   now carries the explicit `\min_{|z|=1}`.
3. **Lemma 5.1** (same file).  Added the `c=0` branch: `|c|\ge1-4\varepsilon`
   forces `\varepsilon\ge1/4` there, and (5.1) holds trivially because its
   left-hand side is at most `2\le8\varepsilon`.  No smallness hypothesis was
   added to the lemma.
4. **Corollary B.19, "Isolation and the threshold."**  Added the `K=\varnothing`
   branch before taking `\min_K f`, which is otherwise undefined.
5. **Section 5 opening.**  BT09 Lemma 1 is now credited as the *qubit* cleaning
   lemma, with the additive prime-power version identified as the elementary
   symplectic statement already spelled out inside the proof of
   Lemma~\ref{lem:quantitative-cleaning-commutator}.
6. **`[Tan26b]`** is now *Discover Quantum Science* **2**:20 (2026), replacing
   the incorrect 1(1).  In-text theorem numbers unchanged.
7. **`[EK20]`** upgraded from an arXiv `@misc` to *Physical Review A*
   **101**(6):062302 (2020), DOI `10.1103/PhysRevA.101.062302`; the eprint field
   is retained but the alphabetic label `EK20` is unchanged.
8. **Section 5 scaling paragraph.**  The GRS/EGRS sentence now cites
   `SeroussiRoth1986` (new entry) and the already-present
   `RaissiGogolinRieraAcin2018` for the MDS-to-AME construction.  (5.11)
   untouched.
9. **Appendix B binary-MDS step.**  The vague "the binary MDS codes are the
   trivial ones" replaced by the direct argument over `F_2`: systematic
   `G=[I_m\mid A]`, all `1\times1` minors of `A` nonzero forces `A` all-ones,
   and any `2\times2` all-ones minor is singular, so `m\le1`.
10. **Introduction.**  PYHP15 "originate in holographic codes" softened to "are
    used explicitly in holographic codes"; the source supports explicit use, not
    historical priority.
11. **Appendix A, Wong--Jiang `d=9`.**  The `3\mathbb Z_9\times3\mathbb Z_9`
    projection statement is now attributed as a derivation "from their displayed
    stabilizer generators" rather than as their theorem.
12. **Appendix B.2, RAL22.**  "standing nuisance parameter of the classification
    programme" replaced by "local-unitary equivalence is a central part of the
    classification problem".

## Deliberate no-ops

- **`[CP24]`** (Claudet--Perdrix) keeps its key and its 2024 date.  The 2025
  STACS paper names `arXiv:2409.20183` as its long version with proofs, so the
  current citation is the right one.
- **Corollary B.27** conjugation bars were left alone.  The source has
  `(u_1,u_2,u_3,u_4)\mapsto(\overline u_1,\overline u_2,u_3,u_4)` at
  `B-secondary-quantitative.tex:1287` and `v_a=\overline u_a` at line 1320.
  `pdftotext` drops those overbars, which is what produced the original false
  report; verification was done against the TeX source and the rendered page,
  not the extraction.

## Mathematical checks

1. **B.19 phase.**  `g` unitary with `g|\psi\rangle=e^{i\theta}|\psi\rangle`
   gives `g^\dagger|\psi\rangle=e^{-i\theta}|\psi\rangle`, hence
   `\langle\psi|g=(g^\dagger|\psi\rangle)^\dagger=e^{i\theta}\langle\psi|` and
   `|\langle\psi|gV|\psi\rangle|=|\langle\psi|V|\psi\rangle|`.
2. **Theorem 5.3 centering.**  With `K_i'=z_ie^{i\bar a_i}K_i`,
   `(K_i')^\dagger U_i=e^{-i\bar a_i}z_i^{-1}K_i^\dagger U_i
   =e^{-i\bar a_i}e^{ia_i}=e^{ih_i}`; `\mathrm{Tr}(h_i)=\mathrm{Tr}(a_i)-q\bar
   a_i=0`; the spectrum of `h_i` is that of `a_i` shifted by `-\bar a_i`, so the
   spread is unchanged; and
   `\|h_i\|_F^2=\|a_i\|_F^2-q\bar a_i^2\le\|a_i\|_F^2`.  The chord bound
   `|e^{i\lambda}-1|=2|\sin(\lambda/2)|\ge(2/\pi)|\lambda|` on `[-\pi,\pi]`
   gives `\|h_i\|_F\le(\pi/2)\|U_i-z_iK_i\|_{\rm HS}`, so
   `D^2\le(\pi^2q/4)\sum_i(q^{-1/2}\min_{|z|=1}\|U_i-zK_i\|_{\rm HS})^2
   \le(\pi^2q/4)\,n\,(8\varepsilon)^2=16\pi^2qn\varepsilon^2`.
   The constant in (5.6) is therefore unchanged, as required.
3. **Lemma 5.1 `c=0`.**  `1=\|A\|\le\|A-cI\|+|c|\le4\varepsilon+|c|`, so
   `c=0` forces `\varepsilon\ge1/4`.  For unitaries the normalized left side of
   (5.1) is at most `1+1=2\le8\cdot(1/4)\le8\varepsilon`.
4. **Binary MDS.**  Over `F_2`, a nonzero `1\times1` minor equals `1`, so
   MDS forces every entry of `A` to be `1`; for `m\ge2` the `2\times2`
   all-ones minor has determinant `1-1=0`.  Hence `m\le1`.
5. **B.27 orientation.**  `v_a=\overline u_a` gives
   `v_a^\dagger=u_a^{T}`, hence
   `(u_1\otimes u_2)^{T}=v_1^\dagger\otimes v_2^\dagger=(v_1\otimes
   v_2)^\dagger`.  Consistent with the unedited source.

## Build and gates

- `make check` succeeds from the tracked state: warning-free, still 37 pages,
  314,312 bytes.  The log has no `Overfull`, `Underfull`, `LaTeX Warning`,
  undefined-reference, or undefined-citation line.
- `make release-check` initially failed on a stale manifest and passes after
  `release/verify_release.py --write --require-formal`: 18 public artifacts,
  public tree `01d3e7d0...`, 83 formal companion artifacts, formal tree
  `7e771df1...`.
- `git diff --check` is clean and the commit touches only `papers/ame_lu`.

## Foreign-lane note for the user

Regenerating the release manifest changed seven hashes.  Six are the files
edited here plus the rebuilt PDF.  The seventh is `lean/lakefile.toml`, which a
foreign lane changed in commit `f92d50b0c` ("Declare Q13 semantic library
root").  The AME--LU release manifest was therefore already stale at `HEAD`
before any edit in this session, and `make release-check` would have failed on
a clean tree.  Absorbing that hash is unavoidable if the gate is to pass, but it
is not an `ame-lu` change and the Q13 owner should know the AME--LU release
manifest now pins their current lakefile.

## Standalone repository synchronized

Exported per `notes/export-and-mirror-conventions.md` from the committed
authority `86b887162`, after the manuscript commit and the two documentation
commits:

- `export-paper-repos.py plan --source-ref HEAD` reports `ame-lu` with zero
  reference findings, and `audit --repository ame-lu` reports `findings=0`.
- `sync --repository ame-lu --root ~/src/math-papers/ame-lu` changed nine
  tracked files: the four edited sections, `refs.bib`, the rebuilt PDF, the
  release manifest, `PROVENANCE.md`, and `export-manifest.json`.  No path was
  deleted and no README or Zenodo metadata was touched, so neither of the two
  hard refusals arose.
- `make check` inside the repository rebuilds a warning-free 37-page PDF that is
  byte-identical to the authority's, SHA-256 `c40296d1...20713f19`.
- `release/verify_release.py` there verifies 18 public artifacts with public
  tree `01d3e7d0cc66c6a6513991e487f9c715e1bb821c2fadbbd4bc445203d5f8d7f5`,
  equal to the authority's, and correctly reports the formal companion as absent
  from that checkout.
- `export-paper-repos.py verify --root ~/src/math-papers/ame-lu` confirms 28
  tracked files against source commit `86b887162`.

Forward commit `c9af535` in `~/src/math-papers/ame-lu`, one ahead of its
`origin/main` at `67602af`.  **Nothing was pushed**; publishing stays an author
decision.  No Lean, certificate-package, finitegeom, or portfolio-summary tree
was touched, and none needed to be: this batch changed manuscript prose and
bibliography only.
