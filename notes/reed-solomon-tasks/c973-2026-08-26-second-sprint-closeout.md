# C973 second-sprint closeout — seam certification and extraction

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** checkpoint
complete; C973 remains active

## Outcome

The Tao audit was converted into two standalone propositions and then
reconstructed from the displayed catalecticants and terminal strata.  No
fatal defect was found.

1. The selector converse survives: containment of the composite-contraction
   row space in the reduced R5 carrier forces the upper syndrome into
   `P_r union M^max_(r,p)`.  Its contrapositive supplies a nonzero terminal
   equation of degree at most six, or four in characteristic two.
2. The terminal open survives: outside the reduced R5 carrier the cubic
   pencil has rank two, no base point, a separable degree-three map, and
   geometric monodromy `S_3`.
3. Recomposition gives exactly the already claimed simultaneous-marker
   theorem and thresholds; no extra hypothesis appears between the two
   seams.
4. The existence argument is witness-producing at fixed redundancy.
   Successive symbolic specialization finds marker roots with at most
   `(r-5)q` partial-substitution/zero tests, after which one enumerates the R5
   pencil.  Dense selector size is exponential in `r`, so no uniform
   polynomial-in-`r` claim is made.
5. The software leverage is concrete: the construction gives a certified
   arbitrary-`r` fast `NOT_DEEP` path, while the large-characteristic radius
   gate can extend positive classification beyond R10 only through a new
   parameterized registry and verifier route.  The exact design is recorded in
   `c973-2026-08-26-software-leverage.md`.

This is an author-side clean reconstruction, not independent specialist
review.  No manuscript, software, Lean, release, or Version 1 path changed.

## Exact trust boundary

Five facts remain imported from the earlier proof stack:

- C536's coherent-Fano identity for a polar line in the persistent component;
- the projected Veronese contains no projective line;
- C597's classification of catalecticant row spaces in wild-cone rulings;
- the characteristic-wise terminal cyclic and inseparable classification;
- the exact R5 split-member count and its branch budgets.

Everything newly connecting these inputs is explicit linear algebra,
irreducibility/density, the classification of transitive subgroups of `S_3`,
or the successive-specialization lemma.  An external reader can therefore
audit five named inputs rather than reconstruct a diffuse proof chain.

## Paper interface

If external review passes, the separately allocated paper successor should
print the two seams as the only geometric bridge between the recursive carrier
and the finite-field count.  The deterministic extraction belongs in one
corollary or remark and must not create a new algorithmic section.  This
preserves the intended compression: the arbitrary-`r` theorem replaces
stagewise packages rather than accompanying them.

The old lower-package machinery is not deleted wholesale.  Any lemma still
used by exact R8--R10 arithmetic, the R11 characteristic-seven slice, or the
five inherited seam inputs must be localized and retained.  Only its role in
the headline arbitrary-level spine disappears.

## Revised mystery ledger

| Feature | Verdict | Remaining gate |
|---|---|---|
| Selector converse | author-side PASS | External reconstruction of the C536, no-line, and C597 inputs. |
| Terminal `S_3` open | author-side PASS | External reconstruction of the terminal strata and R5 count. |
| Main theorem recomposition | PASS | Independent arithmetic review of strict thresholds. |
| Deterministic fixed-`r` extraction | proved | Optional exact implementation in a software successor. |
| Toolkit negative-witness route | designed | Prototype against the existing locator verifier; retain exhaustive fallback. |
| Toolkit R11+ positive route | designed, not enabled | New parameterized theorem registry and deep-certificate replay after external review. |
| Generic abundance equality | open, nonessential | Control selector-zero overlaps and moment distribution. |
| R12 coherent `p=2,3,7` blocks | exactly reduced | Prove one-extra-root abundance on the R11 constructions. |
| Small binary `q=16,32,64` | open | Pointed compact certificates, not the existing unpointed ones. |
| All-level Lucas graph | open | Package coherent propagation after the R11 abundance gate. |

## Highest-EV continuation

The next mathematical theorem is pointed one-extra-root abundance on the R11
binary, characteristic-three, and characteristic-seven constructions.  It is
the first common gate for the coherent R12 blocks and tests whether the Lucas
zero-run graph can propagate beyond the first boundary.  In parallel, but not
as a substitute, an external specialist should reconstruct the five imported
seam inputs.

Manuscript integration remains a separate future C item after those review
gates; software adoption likewise needs a separately authorized C969/C970
successor.  C973 edits neither the frozen paper nor the toolkit.
