# C909 — Section 4 pro-Laurent convention and citation audit

Date: 2026-08-12
Status: read-only audit; no manuscript, PDF, mirror, bibliography, ledger, or
Lean file was changed.

## Verdict

**GO with a local definition repair and one citation repair.** The current
pro-Laurent idea is mathematically the right one: finite \(F\)-adic quotients
have ordinary Laurent gauges, while their compatible inverse limit may have no
uniform lower \(z\)-bound. The notation in (4.1a), however, is introduced only
inside the proof and is not yet a defined object. A short definition before
the coefficientwise-base-change lemma should make the pro-category and the
inverse-limit characteristic polynomial explicit.

The malformed rendered citation is Section 4 source line 245:

\[
\texttt{\textbackslash cite[Proposition\textasciitilde5.6 and Section\textasciitilde5.8]\{IritaniKoto\}}
\]

It occurs inside the display-math delimiters. The current PDF renders it
glued to \(O(u)\), approximately as
the string O(u)[11, Proposition 5.6andSection 5.8]. This is a source-level
defect, not a mathematical one. The other combined optional citations should
also be split for consistent typography, although they are outside math mode.

## Recommended pro-Laurent definition

Place the following immediately after the paragraph at current lines 48--49,
before the two formal lemmas. For a complete separated multiplicative
filtration \(F^\bullet B\), put \(B_N=B/F^N B\) and assume
\(B\cong\varprojlim_N B_N\):

\[
\mathcal G^{\mathrm{pro}}_{B,F}(V)
:=\varprojlim_N
\operatorname{GL}_{\,B_N((z))}
\bigl(V\otimes_k B_N((z))\bigr),
\qquad B_N=B/F^N B.
\tag{PL}
\]

The transition maps are reduction modulo \(F^N\). This is a group of
compatible finite-level Laurent gauges; it is deliberately not
\(\operatorname{GL}(V\otimes_k B((z)))\). A compatible family may have a
lower Laurent bound that decreases with \(N\). The filtration hypothesis
\(F^pB\,F^qB\subset F^{p+q}B\) is needed if the definition is stated for a
general filtered ring; the \(J_j\)-adic rings used later satisfy it.

Then replace the display (4.1a) by \(\mathcal G^{\mathrm{pro}}_{B,F}\) with
\(V=H^{\rm ev}(T)\), or retain the display and define its right-hand side by
(PL). Add the following sentence to the proof:

> If \(M_N\) is the framed-monodromy operator at level \(N\), the compatible
> finite-level characteristic polynomials
> \(P_N(T)=\det(T-M_N)\in B_N[T]\) define
> \(P(T)\in B[T]\) under \(B\cong\varprojlim B_N\). This \(P\) is the
> pro-Laurent characteristic polynomial.

At every finite quotient the integral-\(z\) gauge is single-valued on the
original \(z\)-disc and conjugates \(M_N\). Coefficientwise base change gives
the same \(P_N\) as the small connection. Compatibility then proves the
claimed inverse-limit invariant. This preserves the existing proof and avoids
the false implication that the pro-gauge belongs to ordinary \(B((z))\).

The current lemma statement should correspondingly say “complete separated
\(F\)-adically filtered \(k\)-algebra” (or simply “complete separated
\(I\)-adic \(k\)-algebra” with \(F^N=I^N\)). As written, “complete filtered
coefficient ring” does not itself guarantee that the quotients \(B/F^N B\)
are rings or that \(B\) is their inverse limit.

## Exact citation repair

Change the projective-bundle paragraph to end the display before the citation:

\[
 \varsigma_j=\varsigma_j^\circ+s_j,\qquad
 \varsigma_j^\circ
 =r\lambda_j-\frac{2\pi\mathrm{i}j}{r}c_1(V)+O(u).
\tag{4.5}
\]

Then write in prose:

> The asymptotic expansion is Proposition 5.6 of Iritani--Koto; the
> reconstruction of the initial value is in Section 5.8, especially (5.11).

Use separate citations, for example
\(\cite[Proposition~5.6]{IritaniKoto}\) and
\(\cite[Section~5.8, especially (5.11)]{IritaniKoto}\), rather than putting
\(and\) inside one optional citation note in math mode.

The source pinpoints are exact in the cached Iritani--Koto v4 text
(arXiv:2307.03696, SHA-256
5139f8e0c9d46f8ccb8cb415396a0fb1fb357719b7dcfbca46234a9735b57624):

* Proposition 5.6, PDF page 31/text around the proposition, defines
  \(\sigma_j\), \(\lambda_j=e^{2\pi\mathrm{i}j/r}q^{1/r}\), and the
  \(q^{-1/r}\), \(q^{-c_1(V)/r}Q\) coefficient rings.
* Section 5.5 and Proposition 5.8, PDF pages 32--33, give the localized
  decomposition and the \(r'\)-dependent comparison field.
* Section 5.8, PDF page 37, and equation (5.11) give the initial value
  \(\varsigma_j^\circ=r\lambda_j+[z^{-1}]\log(\cdots)\), from which the
  displayed \(r\lambda_j-\frac{2\pi\mathrm{i}j}{r}c_1(V)+O(u)\) follows.

For the same typography reason, split the outside-math notes
\(\cite[(1.1) and Remark~5.2]{IritaniKoto}\) and
\(\cite[Section~3 and Proposition~6]{Cai}\) if desired; they are not the
malformed source because they are outside display math. Iritani's separate
parity citation \(\cite[Section~2]{IritaniNotes}\) is source-valid: the notes'
Section 2 explicitly states parity of the formal coordinate changes and
\(\Psi\), at items (a) and (d).

## ej + tt closeout / mystery ledger

* **Settled:** the pro-Laurent object is an inverse limit of finite-level
  Laurent gauge groups, not an ordinary Laurent group; no uniform \(z\)-bound
  is required.
* **Settled:** finite-level characteristic polynomials glue in \(B[T]\) once
  completeness and separatedness are stated.
* **Settled:** the malformed output is caused by the Iritani--Koto citation
  being placed inside the displayed equation, not by a bad theorem number.
* **Open:** none for this audit. The manuscript owner must apply the two local
  source repairs if the typography and formal-category convention are to be
  made publication-clean.

## Source record

Hiroshi Iritani and Yuki Koto, *Quantum cohomology of projective bundles*,
arXiv:2307.03696v4: cached full-text extraction read at the cited loci;
SHA-256 5139f8e0c9d46f8ccb8cb415396a0fb1fb357719b7dcfbca46234a9735b57624.
Hiroshi Iritani, *Notes on the decomposition theorem for blowups*,
arXiv:2604.10028: official arXiv HTML spot-check of Section 2; no local cache
blob was created in this audit.
