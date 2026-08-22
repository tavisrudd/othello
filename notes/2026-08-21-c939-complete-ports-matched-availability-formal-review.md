# C939 matched-availability formal-correspondence review

**Date:** 2026-08-21
**Reviewed commit:** `f50c583cc8d23baacc03b71ade111ec243d91578`
**Tracked PDF SHA-256:** `2cbb5bd84f65c00d93a4b9e19a711f452468da8d849c918b7f571e03e9203a49`
**Verdict:** **MAJOR**

## Executive finding

The new availability- and blocker-matched Theorem 6.5 has an honest formal boundary.  The paper
does not claim that `RepairPorts.eventually_radiusThree_prescribedPortPair` proves the new
quotient-plane seed construction or packages the full asymptotic theorem.  The PDF and public
README consistently distinguish:

- kernel-checked general transfer, parameter, density, reliability, and bounded-EXIT components;
- the paired Lean theorem's narrow role of simultaneous eventual radius-three support/coefficient
  port transfer through one common outer family;
- the human quotient-plane construction and generic lift;
- the human finite-invariant, code-parameter, and reliability calculations;
- classical random-linear outer-family existence; and
- the human synthesis of the matched asymptotic conclusion.

The new finite clutter arithmetic and structural representation argument withstand this bounded
review.  No Lean strengthening or correspondence-prose fix is required.

The immutable paper surface nevertheless fails its own deterministic release verifier: rebuilding
the 23-page PDF from the committed sources does not reproduce the tracked PDF byte-for-byte.  The
authoritative checker reports `tracked PDF is stale`.  Because the task asks for a verdict on both
the immutable commit and its tracked PDF, this is a MAJOR acceptance failure even though the
formal-correspondence portion is GO.  The repair is mechanical and does not require a mathematical
or Lean change.

## Frozen identity

The checkout `HEAD` is exactly `f50c583cc8d23baacc03b71ade111ec243d91578`.  The tracked PDF has
the supplied SHA-256
`2cbb5bd84f65c00d93a4b9e19a711f452468da8d849c918b7f571e03e9203a49` and renders as 23 pages.
It contains the new `[10,4,6]_q` theorem and the revised formal-boundary paragraph.

No paper or Lean source was modified during this review.

## Formal boundary of the new Theorem 6.5

### What the paired Lean theorem proves

`RepairPorts.eventually_radiusThree_prescribedPortPair` remains a generic theorem about two inner
codes and one outer family.  Its conclusion gives, eventually and uniformly in every block:

- exact embedded equality of the radius-three support port for the first inner code;
- exact embedded equality of its radius-three normalized coefficient port;
- the same two equalities for the second inner code; and
- one common outer family and one common eventual cutoff.

The manuscript attributes only this transfer role to the declaration.  Appendix A says expressly
that it “covers only simultaneous eventual radius-three support/coefficient transfer through one
common outer family.”  This matches the declaration field by field.

### What remains human or classical

The manuscript correctly excludes the following from the paired Lean theorem:

- existence of the two five-edge clutters and the quotient-plane line arrangements;
- the generic four-dimensional lift and simultaneous reduction to one finite prime field;
- the resulting represented `[10,4,6]_q` seed codes;
- the five minimum repairs, locality three, matching and transversal numbers two, unique minimum
  blocker, and helper-degree multiset;
- equality of the pointed rank-triple multiplicity enumerators;
- the two explicit reliability polynomials;
- asymptotically good outer-family existence; and
- the final length, dimension, distance, density, and reliability synthesis.

The PDF labels the seed construction and these finite calculations as a structural human proof and
labels outer-family existence as classical.  The public README likewise says that Lean “does not
package the structural seed construction and asymptotic specialization into one theorem.”  It also
states that the independent field-seven replay belongs only to the separate small counterexample
in Proposition 6.4 and carries no logical weight for the stronger matched theorem.  There is no
evidence-category ambiguity.

## Bounded check of the new human finite layer

For

```text
A = {158, 026, 045, 013, 478}
B = {168, 237, 078, 015, 124},
```

an independent exact enumeration confirms:

- both helper-degree multisets are `(1,1,1,1,2,2,2,2,3)`;
- the unique minimum transversals are `{0,8}` and `{1,7}`;
- both matching and transversal numbers are two;
- the union-size rows in the proof are exact; and
- alternating inclusion-exclusion gives
  `5s^3-7s^5-s^6+5s^7-s^9` and
  `5s^3-7s^5-2s^6+8s^7-3s^8`.

The quotient-plane incidence construction realizes exactly the displayed edges: each clutter is
the five named line triples, and the genericity conditions exclude every unwanted collinear triple.
After lifting `(p_i)` to `(t_i,p_i)`, avoiding finitely many proper linear conditions makes every
helper triple and quadruple independent while preserving dependence of `{x}` plus exactly the
listed triples.  Rational choices and reduction away from finitely many nonzero determinants put
both configurations over one prime field.  The resulting rank-four sparse-paving matroids have
five circuit-hyperplanes through the target and none avoiding it, hence common pointed enumerators,
row-code parameters `[10,4,6]_q`, dual distance four, and pointed zero-functional cost eight.  The
human transfer synthesis at radius three is therefore coherent.

## Formal audit state

The formal closure remains the previously pinned narrow boundary:

- gate-fact SHA-256
  `fbb29ef0bc559b9ac2ce3308a7b3c0572753ffd7163d6c15cd18e57464fc0a4d`;
- 61 `#print axioms` terminals in `RepairPorts.Gates.CompletePorts`;
- field-seven certificate SHA-256
  `8096230e66f634c820ae7ec4bacd9b2493006782ff02b8be3a8c7e1caf80de07`; and
- permitted axiom union `Classical.choice`, `Quot.sound`, and `propext`.

The new theorem does not purport to alter this closure.  The read-only command

```text
python3 lean/scripts/lean-trust-spine.py audit --area complete_ports
```

completed with `0 error, 0 warn, 0 info`.  No heavyweight Lean build was necessary: the reviewed
change is a new human theorem whose formal claims deliberately reuse the unchanged general
terminals.

## Acceptance-gate failure

The paper-local command

```text
nix develop .#manuscript --command python3 verification/verify_release.py
```

rebuilt the manuscript successfully far enough to validate the expected 23-page shape, but then
failed with

```text
complete-repair-ports release: FAIL [tracked PDF is stale; rerun with --update-pdf]
```

The checker compares the complete rebuilt byte string to the tracked PDF, so the supplied PDF hash
cannot be accepted as the deterministic artifact of the committed source.  The surrounding Nix
dirty-tree warning is not the cause: the checker builds from its explicit paper inputs in a fresh
temporary directory and reached the final byte-comparison gate.

## Exact required fix

1. At commit `f50c583cc8d23baacc03b71ade111ec243d91578` (or a direct successor with no additional
   manuscript-source changes), run the documented deterministic refresh:

   ```text
   nix develop .#manuscript --command \
     python3 verification/verify_release.py --update-pdf
   ```

2. Confirm that the only intended paper change is the regenerated tracked
   `complete_repair_ports.pdf`; inspect and commit it as an ordinary forward commit.
3. Rerun the verifier without `--update-pdf` and require
   `PASS [paper surface, 23 pages, warning-free]`.
4. Record the successor commit and new PDF SHA-256, then repeat the immutable identity check.

No theorem, Lean, manifest, field-seven certificate, or formal-correspondence prose change is
required by this review.

## Verdict

- **Formal correspondence:** **GO**.  The narrowed Lean boundary remains accurate and the new
  quotient-plane theorem is clearly identified as human/classical synthesis.
- **Immutable commit and tracked PDF:** **MAJOR**.  The tracked PDF fails the mandatory
  byte-for-byte deterministic rebuild gate.
- **Overall requested verdict:** **MAJOR** until the PDF-only refresh is committed and the unchanged
  verifier passes.

**Vibe check:** the mathematics and trust statement are healthy; the frozen artifact missed one
mechanical release step.

## Mystery ledger

The `ej`+`tt` closeout found no unresolved mathematical or formal-correspondence mystery.  The sole
open evidence gap is the exact deterministic PDF byte sequence, owned completely by the refresh
and recheck above.  No broader successor is needed if that gate passes with only the PDF changed.
