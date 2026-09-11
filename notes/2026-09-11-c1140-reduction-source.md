# C1140 — primary source for potential toric rank

**Lane:** `cubic-threefolds`. Date: 2026-09-11.

**Full external works read: zero.** The precise required statements were read
at partial depth in the original French scan of SGA 7 I and verified visually
against the page images. The [Reduction] placeholder is closed: cite
**Exposé IX, Proposition 2.2.6 and Corollary 2.2.7; Corollary 3.3**.
The latter has no tameness restriction. The semistable-existence statement is
Theorem 3.6 in the same exposé, whose statement was also checked.

## Exact source and hypotheses

Alexandre Grothendieck, *Modèles de Néron et monodromie*, Exposé IX in
*Groupes de monodromie en géométrie algébrique. I (SGA 7 I)*, Lecture Notes
in Mathematics 288, Springer, 1972. Volume DOI:
https://doi.org/10.1007/BFb0068688 .

The original French scan is accessible at
https://library.slmath.org/nonmsri/sga/sga/pdf/sga7-1.pdf .
The cache key is `10.1007/BFb0068688`; cached PDF:
`/tmp/persistent/tavis/lit-search/pdf/10.1007_BFb0068688.pdf`.
SHA-256:
`17286b0f0bec451068e0a5fa2c39e93de28e7c1ecee6739487cfac11c03c8dab`.
The PDF has 528 pages and is an image scan. Its nominal text extraction has
only page labels and must not be treated as the text of the work.

1. **Isogeny invariance.** Proposition 2.2.6, printed pages 333–334
   (one-based PDF pages 338–339), says that an isogeny of abelian varieties
   induces an isogeny of the largest tori in the special fibres of their
   Néron models. Its proof uses an isogeny and a quasi-inverse whose composites
   are multiplication by a positive integer. Corollary 2.2.7 on printed page
   334 gives equality of the toric, unipotent, and abelian ranks. Remark 2.2.8
   removes the henselian hypothesis for these special-fibre assertions.
2. **Base extension after semistability.** Proposition 3.2, printed page 347,
   assumes a locally noetherian, regular, integral, one-dimensional base S.
   Under semistable reduction, Corollary 3.3 on printed page 348 applies to
   every dominant morphism from another such base S'. The canonical
   base-change morphism is an open immersion and gives an isomorphism on
   relative identity components. Thus the special torus is merely extended
   over the residue field. Remark 3.3.2 on printed page 349 explicitly
   distinguishes this from invariance of the entire Néron model.
3. **Existence.** Theorem 3.6, printed page 351 (PDF page 356), provides a
   finite Galois extension giving semistable reduction for an abelian variety
   over the function field of a noetherian regular connected curve. Its
   statement applies to the spectrum of a local ring of integers in the
   present application. The full proof of Theorem 3.6 was not reread.

These assertions were read on the authoritative scans, not inferred solely
from an online translation. No equality of component groups, original-field
conductors, or original-field Frobenius polynomials is asserted.

## Manuscript-ready proof interface

Let K be a finite extension of Q_p and let A/K be an abelian variety. Choose
a finite extension L/K over which A has semistable reduction, and define
\(\rho(A)\) to be the dimension of the maximal torus in the geometric
special fibre of the identity component of its Néron model over O_L.

For a further finite extension M/L, put
\(S=\operatorname{Spec}O_L\) and \(S'=\operatorname{Spec}O_M\).
These are regular noetherian integral one-dimensional schemes, and the
normalization morphism S' to S is dominant. Corollary IX.3.3 identifies

\[
\mathcal A_L^0\times_{O_L}O_M\simeq\mathcal A_M^0.
\]

Taking geometric special fibres preserves the dimension of the maximal
torus, so rho is unchanged. Two different semistabilizing extensions can be
compared in a common finite extension, proving independence of the choice
of L. **This argument permits arbitrary ramification.** Neither p at least
five nor separability of the residue-field extension supplies a substitute
for this check; the cited corollary itself covers the required morphisms.

If \(f:A\to B\) is an isogeny over K, choose \(g:B\to A\) and n positive
with \(gf=[n]_A\) and \(fg=[n]_B\). The Néron mapping property extends
these maps and identities over O_K. Their restrictions to the maximal
special-fibre tori therefore have composites [n]. A torus homomorphism has
torus image, and multiplication by n on a torus is finite and surjective,
even when p divides n. The two torus dimensions coincide. This is also the
proof mechanism in Proposition IX.2.2.6, summarized by Corollary IX.2.2.7.
Applying it over a common finite extension gives invariance of rho under
geometric isogeny. Products add torus dimensions, so the geometric
five-elliptic-factor decomposition may be used to compute rho factor by factor.

For the arithmetic pencil, choose a finite number field over which the
geometric factorization and any proposed isogeny are defined, then a place
above p and a common semistabilizing local extension. A difference of the
computed rho values rules out that geometric isogeny. This is the exact
interface needed by the arithmetic separation proof.

**Suggested compact citation sentence:**

> The potential toric rank is independent of the semistabilizing extension
> and invariant under geometric isogeny, by SGA 7 I, Exposé IX, Corollaries
> 3.3 and 2.2.7; the latter follows from the isogeny/quasi-inverse argument
> in Proposition 2.2.6.

The existing elliptic j-integrality source is a separate input. Nothing in
this note purports to replace its earlier audit.

## Read-depth and access register

| Source | Actual depth and version | Access and byte identity |
|---|---|---|
| Grothendieck, SGA 7 I, Exposé IX | **Partial**: Proposition 2.2.6 and proof, Corollary 2.2.7, Remark 2.2.8; Proposition 3.2 and proof, Corollary 3.3 and proof, Remark 3.3.2 and Definition 3.4; Theorem 3.6 statement and opening proof reduction. Original French 1972 scan. Incidental adjacent passages were also visible, without claiming complete section coverage. | Cache key `10.1007/BFb0068688`, original-PDF SHA-256 `17286b0f0bec451068e0a5fa2c39e93de28e7c1ecee6739487cfac11c03c8dab`. Source URL above. Load-bearing passages visually checked on PDF pages 338–339 and 352–354; existence statement checked on 356 and proof opening on 357. |
| Brian Conrad, *Néron models, Tamagawa factors, and Tate-Shafarevich groups* | **Partial**: §3, Definitions 3.1, 3.3, 3.6; Theorems 3.5 and 3.7 with surrounding discussion; Remark 3.8. Notes dated 14 October 2015. Its explicit arbitrary-finite-separable-extension consequence independently points to the same interface; the primary SGA passage is the final authority here. | https://math.stanford.edu/~conrad/BSDseminar/Notes/L3.pdf ; supplemental cached PDF `conrad-L3-c1140.pdf` at cache root; no DOI/arXiv index key. SHA-256 `bc27aad24f5b0ba8b1ae7fa6f8dde25f17ce479e46b1ff0256cf0e512ce988e6`. |
| Bosch–Lütkebohmert–Raynaud, *Néron Models* | **Secondary only for the theorem**: §7.4 is cited by Conrad's Theorem 3.7, whose partial depth is recorded above. Original theorem not read. Published-book **abstract/metadata only** consulted from publisher and scan-index metadata. The downloaded scan fragment does not contain the needed §7.4 and is not mathematical support. | Publisher DOI `10.1007/978-3-642-51438-8`; https://math.arizona.edu/~cais/scans/BLR-Neron_Models/neron1.pdf ; indexed cache fragment of 30 pages, SHA-256 `32baed54631829b55af3c9e883db41cbde8820fcd1e75cfaccd75584be7149b6`. |
| Modern SGA web reconstruction, grothendiecksga.com | **Partial**: English Exposé IX §2, Proposition 2.2.6–Remark 2.2.8; French Exposé IX §3 through Corollary 3.3 and adjacent remark, accessed 2026-09-11. This reconstruction was a locator, then checked against the primary scan; no independent fidelity certification of the entire reconstruction. | https://grothendiecksga.com/read/sga7/en/9-2.html and https://grothendiecksga.com/read/sga7/fr/9-3.html ; supplemental HTML files `sga7-en9-2-c1140.html`, SHA-256 `6c8dd91bdc0b0eefb5c1cd0e61392c38eb056c8a18445dda59930a9c8df442ee`, and `sga7-fr9-3-c1140.html`, SHA-256 `7b871b03e036fdecc326067bb13f5cf7c5042d3f815cbb910aeca7e7c3ce55d2`. No DOI/arXiv index keys. |

All supplemental paths are relative to `/tmp/persistent/tavis/lit-search/`.
The directly downloaded source files are cached bytes, not declarations of
full reading. The PDF ingester checked the original scan's file signature.
The Springer PDF endpoint returned HTML and was correctly rejected by the
ingester before the entry was replaced by the actual scan. A proposed
recomposed French PDF turned out to contain only twelve pages of front matter
and excerpts; it was not used as the source for either theorem.

The five principal page-image witnesses, rendered from the original scan,
are retained at the cache root:

| File | SHA-256 |
|---|---|
| `sga7i-c1140-page338.png` | `134adb522e9ee4e5767d4c4430b4442ad57ee6cf94ae5421a9a78a99cad9f03a` |
| `sga7i-c1140-page339.png` | `5a6a79e5319eecf3773f5aaca850cfc7c6b754aac9b74e09fa83ed668d7e7288` |
| `sga7i-c1140-page352.png` | `20360b1452da55ef9a61e8f86e91d7450a3d3a5d10a03a391073b0da17611c54` |
| `sga7i-c1140-page353.png` | `ce72d016da5e0990853dc3be06c7a2b8ca5149354cc22c23b2cac33f6037974b` |
| `sga7i-c1140-page354.png` | `fee9447fa01c662ce259d3adda4d52eadcf9a9cb58e694d5a8e08710f2d87fb5` |

The decisive source search was `"SGA7" "3.3" "base change"`; a later
`"sga7-1.pdf"` query located the historical scan directory after other
endpoints failed. This is a positive theorem-interface audit, not a novelty
or citation-closure search. No manuscript or Lean file was edited.

## Closeout

The bounded ej + tt pass checked whether wild ramification or p-power isogeny
degree could break the proposed shortcut. Both are covered: IX.3.3 is not
restricted to tame extensions, and [n] remains an isogeny of tori when p
divides n. **Mystery ledger: no unresolved issue remains in this source
interface.** The work is ready for the parent C1140 integration commit.
