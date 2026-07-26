# C545 PRS second cold-read repairs

**Date:** 2026-07-26

## Outcome

Two mutually blind cold readers reviewed the narrowed R5--R7 Version 1.
One returned minor revision/conditional accept; the other returned major
revision.  Their shared artifact condition and every concrete mathematical
objection are now repaired:

1. `prop:r7-gcd1` explicitly assumes \(\gcd(U)=1\), so its stated lower
   factor is exact.  The application derives that hypothesis from the exact
   linear gcd branch.  The proof now treats the zero of the \(w\)-linear
   form homogeneously on \(\mathbb P^1\), including infinity.
2. The sentence preceding `prop:r7-central` says that the central point is
   split-free for odd \(m\), and promotes it to a deep hole only under the
   separate radius-six hypothesis.
3. `prop:r6-lower-carrier` now proves the exhaustive lower trivial-gcd
   carrier trichotomy from the degree-three monodromy alternatives and
   prints the tame, binary, and ternary specialization calculations.  The
   R6 contained-component theorem cites this exhaustion rather than treating
   the carrier list as definitional.
4. A second R7 enumerator, independent of the C509 quotient code and stored
   orbit partition, reconstructs the complete split-free sets and
   \(\operatorname{PGL}_2(q)\)/Frobenius partitions in all fourteen bridge
   fields.
5. The abstract, theorem statement, verification table, and supplement now
   state the exact field list and the strengthened evidence boundary.

## Independent direct-locus replay

The source bundle is:

- `notes/2026-07-26-c545-r7-direct-locus-replay.py`
  - SHA-256
    `16d5d5bfccd6e4ac27d4f8b31655ab15025011ea41d86d08497e0d0a0e67572f`
  - 17117 bytes
- `notes/2026-07-26-c545-r7-direct-locus-replay.json`
  - SHA-256
    `c673eb7dc712875b180f70acbcd584c7dfb87561d24f7726ca33dd9bdec11aad`
  - 7244 bytes

The paper-local bundle contains byte-identical copies under
`papers/beyond4_prs/supplement/evidence/r7/`.

From the repository root, regenerate the compact certificate with

```text
python3 notes/2026-07-26-c545-r7-direct-locus-replay.py \
  --output notes/2026-07-26-c545-r7-direct-locus-replay.json
```

or check the bundled certificate from the paper directory with

```text
python3 supplement/evidence/r7/2026-07-26-c545-r7-direct-locus-replay.py \
  --check supplement/evidence/r7/2026-07-26-c545-r7-direct-locus-replay.json
```

The computation is deterministic and uses no random seed.  Its field domain
is exactly

\[
\{7,8,9,11,13,16,17,19,23,25,27,29,31,32\}.
\]

For \(q<16\), it constructs the infinity-pointed R6 bad locus as the literal
complement in \(\operatorname{PG}(5,q)\) of every span of four distinct
finite normal-rational-curve points.  For \(q\geq16\), it constructs the
proved/certified R6 pointed locus directly as the union of the persistent
quadratic-recurrence locus, the marked secant star, and the odd-binary nucleus
line, adding at \(q=19\) the transient 19-point marked orbit represented by
\((0,0,1,0,0,0)\).  It transports this set to every prospective root,
intersects all contraction conditions in \(\operatorname{PG}(6,q)\), then
independently rebuilds the full \(\operatorname{PGL}_2(q)\) orbit partition,
stabilizer orders, and coefficient-Frobenius targets.

The replay imports only the finite-field implementation from the separately
written R5 replay.  It imports no C509/R7 generator function, quotient
representative, stored R7 orbit, or R7 certificate code.  Every reconstructed
split-free count and orbit record agrees exactly with the public R7 record.
The boundary is explicit: from \(q\geq16\) it consumes the already proved and
certified R6 pointed-locus classification; it independently checks the R7
lifting/exhaustion step, not R6 itself.  Covering radius remains a separate
coding-theoretic input.

## Validation

From `papers/beyond4_prs/`:

```text
make check
make tit-check
python3 supplement/package_evidence_bundle.py --check
python3 supplement/build_classification_records.py --check
python3 supplement/verify.py
python3 supplement/verify.py --replay
```

The canonical build is 32 pages and the IEEE single-column build is 23 pages.
The evidence manifest contains 47 artifacts.  The paper, TIT, evidence,
classification-record, manuscript-label, and non-replay supplement gates are
green.  The new direct-locus replay passes all fourteen fields and its bundled
`--check` is byte-identical.

Both original cold readers then rechecked the repairs.  Each confirmed that
the exact-gcd defect, central-point wording, R6 lower-carrier exhaustion, and
R7 independence condition are closed.  One revised the recommendation to
**accept**; the other called the paper release-ready after ordinary external
replay.  Their final two nonblocking observations were also repaired:
`prop:r6-lower-carrier` now claims exhaustive coverage rather than unproved
pairwise disjointness of closures, and the tame surface is called the
projected quadratic Veronese surface.

The final ej+tt closeout strengthened the executable side rather than merely
restating the prose: the direct-locus checker now asserts the independently
constructed candidate count before comparing public records, and the bundled
C656 replay was repaired so it resolves its paper-local auxiliary input
without reaching back into `notes/`. The adversarial trust check records the
one deliberate shared boundary—the already proved R6 pointed-locus
classification—and confirms that no R7 generator, quotient partition, or
certificate code is imported by the new route.

A subsequent local-copy audit exercised that candidate-count assertion and
found that the first direct implementation omitted the transient 19-point
marked orbit at \(q=19\).  The orbit represented by
\((0,0,1,0,0,0)\) is now constructed directly under the affine marker
stabilizer.  The pointed count rises from \(4143\) to the exact \(4162\) and
the searched-candidate count from \(78718\) to \(79079\), while the final
split-free set remains unchanged at \(3800\).  Thus the executable route now
checks, rather than assumes, that the transient pointed orbit contributes no
coherent sextic polar line.

## Mystery ledger

- **R6 carrier exhaustivity:** settled in Version 1 by the new monodromy
  trichotomy plus explicit characteristic-two and characteristic-three
  closures.  This is level-specific and does not revive the rejected
  arbitrary-redundancy theorem.
- **R7 finite completeness:** settled independently relative to the R6
  pointed-locus input by the direct-locus replay, including the transient
  \(q=19\) marked orbit.  No trusted C509 quotient partition remains in this
  route.
- **Small-field radius at R7:** intentionally open at \(q=7,8,9\); the
  manuscript continues to claim only split-free classification there.
- **External release:** unchanged.  Human specialist signoff, immutable
  public revisions/identifiers, and author/account confirmation remain
  outside this local repair.

No genuine local mathematical mystery remains from these two cold reads.
