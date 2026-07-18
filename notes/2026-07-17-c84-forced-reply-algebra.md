# C84: forced replies have no context-free coloured-word certificate

**Date:** 2026-07-17  
**Lane:** `cap`  
**Status:** exact bounded negative for the first adaptive-algebra candidate; C84 remains active.

## Result

For every class-D escaping child in the tracked prime-field corpus
`q = 13, 17, 19, 23, 29`, solve the conic-only residual exactly.  At each P root, retain every
opponent vertex having exactly one winning reply.  Label the four conic involutions by `0,1,2,3`,
with `0,1,2` the rooted `S4` triple and `3` the escaping fourth centre, and compute the
lexicographically first shortest coloured word carrying the opponent vertex to its unique reply
on the full conic.

The extraction contains **470 forcing pairs in 209 P roots**:

| q | roots with a forcing pair | forcing pairs | distinct shortest words |
|---:|---:|---:|---:|
| 13 | 15 | 30 | 11 |
| 17 | 25 | 58 | 34 |
| 19 | 25 | 62 | 31 |
| 23 | 53 | 125 | 48 |
| 29 | 91 | 195 | 63 |

Across all five fields there are **88** coloured-word patterns, of lengths two through five.
Every one of the 88 also occurs as the lexicographically first shortest word of a **nonwinning**
legal response elsewhere in the same corpus.  Equivalently, zero of the 470 forcing pairs lies on
a word pattern that is uniformly winning.  At q=29 this collision already holds internally for
all 63 patterns used by its 195 forcing pairs.

Thus the first proof-shaped adaptive candidate is exactly false: the unique response is not
certified by a fixed context-free word in the four involutions.  The word can still be part of a
certificate when combined with root-dependent geometry, and a packet of several word types might
still guarantee that at least one response wins.

## Secondary structure

The forced pair is not uniformly local in the residual graph.  Its graph distance reaches six at
q=29, and six q=19 pairs lie in different residual components.  In the full coloured action its
shortest-word distance is at most five on this corpus, but that is not a discriminator: all legal
and all winning responses occupy the same distance range, and the exact distance histograms are
recorded in the JSON.

The per-field counts of roots with a forcing pair are `15,25,25,53,91`; these independently agree
with the `m(R)=1` bins in the prior adaptive-core artifact.  The new checker also recomputes every
root nimber and compares it with `c84_adaptive_core.solve` before accepting a row.

## Evidence and replay

The canonical artifact
`notes/2026-07-17-c84-forced-reply-algebra.json` stores every root centre, every forcing pair in
conic parameters, its exact local graph data, its shortest coloured word and multiplicity, and
the complete control histograms for all legal and all winning responses at P roots.  It contains
314,117 bytes.  The generator/checker
`rust/scripts/c84_forced_reply_algebra.py` contains 11,250 bytes.  SHA-256 hashes for this report,
the JSON, and the checker are in `notes/2026-07-17-c84-forced-reply-algebra.sha256`.

From `/home/tavis/src/othello` run:

```sh
python3 rust/scripts/c84_forced_reply_algebra.py 13 17 19 23 29 \
  > /tmp/c84-forced-reply-algebra.json
cmp /tmp/c84-forced-reply-algebra.json \
  notes/2026-07-17-c84-forced-reply-algebra.json
python3 rust/scripts/c84_forced_reply_algebra.py 13 17 19 23 29 --check
sha256sum -c notes/2026-07-17-c84-forced-reply-algebra.sha256
```

The computation is deterministic.  The S4 representative search inherits the fixed seed and
exhaustive fallback from `c84_pairing_locus.s4_representatives`; no game sampling is used.  The
trusted boundary is the coordinate residual-graph construction, exact Sprague--Grundy recursion
with component xor, and breadth-first word enumeration in the four induced permutations.

This is a finite prime-field theorem for one rooted S4 class.  It does not exclude a
root-dependent algebraic formula, a relation using the full set of shortest words rather than the
chosen canonical word, a multi-response packet, another triple class, or any uniform theorem.

## Next C84 target

Condition the forcing transitions on the root geometry.  The smallest non-static extension is to
classify the double-coset relation of the opponent/reply pair under the rooted S4 together with
the fourth-centre orbit, then test packet purity rather than individual-response purity.  Stop if
those contextual fibres again mix winning and nonwinning responses; otherwise isolate the first
pure packet as the candidate multi-step adaptive certificate.
