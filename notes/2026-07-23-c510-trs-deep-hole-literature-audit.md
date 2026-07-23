# C510 twisted Reed--Solomon deep-hole literature audit

**Date:** 2026-07-23  
**Lane:** `reed-solomon`

## Summary

Two of the three individually characterized research papers were read at full text.  The two
assigned papers do not study different projective objects: after column scaling, both last-hook
families use the same tangent projection of a normal rational curve, with the 2025 family deleting
the parameter zero.  A 2026 forward citation materially narrows the open full-length problem by
classifying the translation-equivalent zero-\(x^{k-1}\)-coefficient code in broad ranges.

The audit therefore does **not** support an unqualified claim that the previously advertised
low-redundancy range is open.  It isolates the first surviving theorem target as the modular
full-length family
\[
  {\rm char}(\mathbb F_q)=p,\qquad p\mid k,\qquad
  k<\frac{3q+3\sqrt q-7}{4}\quad(q\ {\rm odd}),
\]
and its even-characteristic analogue below the Fang--Xu--Zhu range.  No classification of that
modular family was located in the covered sources.  This remains a qualified negative because the
Semantic Scholar forward graph was inaccessible.

## Assigned sources

1. Weijun Fang, Jingke Xu, and Ruiqi Zhu, *Deep holes of twisted Reed--Solomon
   codes*, arXiv:2403.11436v2 (30 May 2025).
   **Read depth:** `full text`; all sections and Appendix A, from the cached arXiv PDF.
   Cache key `arXiv:2403.11436`, SHA-256
   `6703afc8e6545dc03b04f5183085035ab48a85e947b39f2490ce22f58dccb08a`.
   The published record is DOI `10.1016/j.ffa.2025.102680`; the audit characterizes the
   preprint version actually read.

   For
   \[
     S_{k,\theta}=\langle 1,x,\ldots,x^{k-2},x^{k-1}+\theta x^k\rangle,
   \]
   the paper proves covering radius \(n-k\) and the standard degree-\(k\) deep holes for every
   evaluation set.  At full length it proves completeness of the standard class for even \(q\)
   in \((3q-4)/4\leq k\leq q-4\), and for odd \(q\) in
   \((3q+3\sqrt q-7)/4\leq k\leq q-4\), together with exact boundary classifications at
   \(k=q-3,q-2,q-1\).  Conjecture 2 asks for standard-only completeness throughout
   \(2\leq k\leq q-4\).

2. Haojie Gu, Nan Wang, and Jun Zhang, *Deep holes of a class of twisted
   Reed--Solomon codes*, arXiv:2509.08526v1 (10 September 2025).
   **Read depth:** `full text`; all sections and Appendix A, from the cached arXiv PDF.
   Cache key `arXiv:2509.08526`, SHA-256
   `d139d4a778d22b8852faaa6b8da7108814b959f88e0534c01a64ffb204ca4279`.

   For general \(A,l,\eta\), the paper gives a necessary-and-sufficient syndrome condition and
   explicit standard deep holes.  Its complete-family theorem is for
   \(A=\mathbb F_q^\ast,l=k-1\): standard-only completeness in the stated high-rate ranges in
   both parities, and a complete even-characteristic boundary classification at
   \(k=q-4,q-3,q-2\).  It leaves general \(A,l\), odd-characteristic boundary cases, and
   multi-twist families open.

3. Yingchun Cheng, Xuefei Wu, and Haiyan Zhou, *On deep holes of
   non-Reed--Solomon codes*, DOI `10.1016/j.ffa.2026.102882`.
   **Read depth:** `partial`; ScienceDirect indexed abstract, introduction, displayed
   Theorem 1.10, and conclusion were read on 2026-07-23.  The publisher full text was not
   retrievable as a PDF; the Elsevier API returned metadata only.

   The paper studies
   \(C(D,k)=\operatorname{ev}_D\langle1,x,\ldots,x^{k-2},x^k\rangle\).
   The accessible text states a complete odd-\(q\) classification for
   \((q+1)/2\leq k\leq q-1\), and an even-\(q\) classification except \(k=q-4\).
   Applying this to finite-\(\theta\) TRS codes is an inference of this audit, proved in the
   C510 task report by an explicit translation.

## Exact reconciliation and pre-emption

For \(f(x)=a_kx^k+a_{k-1}x^{k-1}+\cdots\), translation \(x\mapsto x+b\) sends
\[
  (a_k,a_{k-1})\longmapsto
  (a_k,\ a_{k-1}+kb\,a_k).
\]
On \(S_{k,\theta}\), \(a_k=\theta a_{k-1}\).  If \(p\nmid k\), choosing
\(b=-(k\theta)^{-1}\) makes the new \(x^{k-1}\)-coefficient zero.  Because translation
permutes the full evaluation set \(\mathbb F_q\), the resulting code is permutation-equivalent
to \(C(\mathbb F_q,k)\).  Consequently, the 2026 theorem pre-empts the odd-characteristic
\(p\nmid k\) part down to \(k=(q+1)/2\), and its stated even-characteristic range pre-empts
the odd-\(k\) part.

When \(p\mid k\), translation cannot remove the twist; instead every translation stabilizes the
code.  This modular locus is the surviving adjacent crown.  The top two extraction candidates
were cheap-tested:

1. **Full-length modular last-hook family \(p\mid k\): passes.**  It retains an additive
   \(\mathbb F_q\)-symmetry, a tangent-projected-NRC model, and at \(q=9,k=3\) has exactly the
   standard projective deep-hole direction.
2. **Punctured multiplicative last-hook odd boundary: fails the symmetry gate.**  Deleting zero
   destroys the affine one-parameter stabilizer of the fixed twisted curve; only the identity
   survives before semilinear field automorphisms.  Gu--Wang--Zhang's exact syndrome condition
   remains usable, but no PRS-style orbit or polar recursion survives this first test.

Other bounded candidates inspected but not promoted were the 2026 paper's even \(k=q-4\)
zero-coefficient exception, arbitrary-hook \(l<k-1\), and multi-twist codes.  They are respectively
a different limiting twist, a higher-degree parity-check deformation, and outside C510's
one-twist scope.

## Citation and author streams

All queries were run on 2026-07-23.

### OpenAlex

Pinned seeds:

- DOI `10.1016/j.ffa.2025.102680` resolved to `W4411328908`, with
  `cited_by_count=1`.
- DOI `10.48550/arxiv.2509.08526` resolved by
  `filter=doi:10.48550/arxiv.2509.08526` to `W4416069065`, with
  `cited_by_count=0`.

Load-bearing forward queries were verbatim:

```text
filter=cites:W4411328908
filter=cites:W4416069065
```

They returned respectively one and zero records.  The one-record set was screened in full
metadata (title, DOI, year, authors) and yielded Cheng--Wu--Zhou,
`10.1016/j.ffa.2026.102882`.

The relevant-author query used the six author IDs resolved from the pinned seed records:

```text
filter=authorships.author.id:A5018855940|A5045462328|A5094196874|A5052758965|A5055848225|A5100400217,from_publication_date:2024-03-18
search=deep holes Reed-Solomon twisted
per-page=20
```

OpenAlex returned four records, all versions of the two assigned papers.  The unrestricted union
reported 404 records because the `Jun Zhang` author entity is contaminated by namesakes; the
quoted discriminator was therefore applied over OpenAlex work-search fields.  This screen is not
a claim about the authors' complete oeuvres.

### Crossref

The exact DOI query

```text
https://api.crossref.org/works/10.1016/j.ffa.2025.102680
```

returned `is-referenced-by-count=1`.  The exact arXiv DOI query

```text
https://api.crossref.org/works/10.48550/arXiv.2509.08526
```

returned HTTP 404, distinguished from an empty result by the HTTP status.  Crossref therefore
provides no citing-set count for the second seed.

### Semantic Scholar

The pinned Graph API requests for `ARXIV:2403.11436`,
`ARXIV:2509.08526`, and DOI `10.1016/j.ffa.2025.102680` all returned HTTP 429.
This was distinguished from an empty result by the HTTP status.  Semantic Scholar is
**NOT COVERED**, so this audit does not license an unconditional forward-citation negative.

## Coverage statement and verdict

- OpenAlex: covered for both pinned seeds; largest citing set size one, screened.
- Crossref: count covered for the published 2025 seed; second seed absent from Crossref.
- Semantic Scholar: not covered (HTTP 429).
- zbMATH Open: not used because no priority claim is being made beyond the bounded forward and
  author streams.
- MathSciNet: not covered (institutional authentication unavailable).
- Google Scholar: not covered (automated access unavailable).

**Verdict:** the broad “first open low-redundancy TRS regime” claim is pre-empted in the
translation-equivalent \(p\nmid k\) range.  The modular \(p\mid k\) full-length family is the
first residual theorem target in the covered theorem map and passes C510's geometry gate, but any
successor must retain a claim-specific literature-refresh gate because Semantic Scholar was
unavailable.
