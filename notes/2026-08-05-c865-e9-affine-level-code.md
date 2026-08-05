# C865 — the affine E9 level code and where the ladder stops being optimal

**Date:** 2026-08-05
**Task:** C865
**Lane:** `clebsch`
**Status:** exact research bundle; no manuscript or Lean file changed

## Result

The exceptional ladder of C682 extends upward by one exact step, and the step
is where unrestricted optimality is lost.

Take the affine E8 root lattice

\[
 E_9 = Q(E_8)\oplus\mathbf Z\delta,
 \qquad \delta\cdot\delta=0,\quad \delta\cdot Q(E_8)=0.
\]

Reducing mod 2 gives a nine-dimensional space \(E_9/2E_9\) carrying the
quadratic form \(q(x)=\tfrac12 x\cdot x \bmod 2\).  Its radical is
\(\langle\delta\rangle\), and \(q(\delta)=0\).  The real affine roots
\(\alpha+n\delta\) reduce onto exactly the 240 nonsingular vectors: 120 E8
root-pair classes times the level parity \(n\bmod 2\).  So the count 240,
which is also the number of E8 roots, appears here as *root pair times
level*, not as roots.

Restricting affine linear functions on \(E_9/2E_9\) to those 240 points gives

\[
 \boxed{C_{E_9}=[240,10,112]_2},
 \qquad
 W(z)=1+255z^{112}+512z^{120}+255z^{128}+z^{240}.
\]

The code is doubly even and self-orthogonal, its dual is \([240,230,4]_2\)
with 264,180 weight-four tetrads, and the direct CSS construction is
\([[240,220,4]]\).

## The level fold, and why the step is a Plotkin sum

Pairing each point with its \(\delta\)-translate gives 120 pairs.  Codewords
constant on every pair form a nine-dimensional subcode, and folding each pair
to one coordinate returns \([120,9,56]\) with enumerator
\(1+255z^{56}+255z^{64}+z^{120}\).  The checker compares this word for word
against the packed C682 construction, after transporting the intrinsic lattice
model onto the packed \(x\cdot y\) model by an explicitly built isometry of
quadratic spaces.  So the ladder is now

\[
 [240,10,112]_{E_9}
 \xrightarrow{\text{level fold}}
 [120,9,56]_{E_8}
 \xrightarrow{\text{root link + pair fold}}
 [28,7,12]_{E_7}
 \xrightarrow{\text{shorten}}
 [27,6,12]_{E_6}.
\]

Splitting the 240 coordinates by level exhibits the code exactly as a Plotkin
\(|u\,|\,u+v|\) sum,

\[
 C_{E_9}=\{(u,\,u+v)\ :\ u\in C_{E_8},\ v\in[120,1,120]\},
\]

verified as a set equality.  Its distance is therefore
\(\min(2\cdot 56,\ 120)=112\), and the two components are badly unbalanced:
the repetition partner delivers 120 where only 114 is needed.

## Comparison with the state of the art

All bounds below were read from codetables.de on 2026-08-05.

### Classical linear codes

| Level | Our code       | Best known \(d\) | Verdict                                   |
|-------|----------------|------------------|-------------------------------------------|
| E6    | \([27,6,12]\)  | 12, exact        | optimal                                   |
| E7    | \([28,7,12]\)  | 12, exact        | optimal                                   |
| E8    | \([120,9,56]\) | 56, exact        | optimal                                   |
| E9    | \([240,10,112]\)| 114 ≤ d ≤ 116   | 2 below the record lower bound            |

The finite part of the ladder attains the unrestricted optimum at every level.
The affine level does not, and the shortfall is small and structural rather
than accidental: the level doubling is forced to be a Plotkin sum against the
repetition code, and no intrinsic E9 datum is available to rebalance it.  At
E8 the ladder is also not dimension-maximal — an exact \([120,10,56]\) code
exists — so \(d\)-optimality, not \((n,k,d)\)-extremality, is what the ladder
preserves below the affine level.

### CSS codes

| Source code    | Our CSS         | Best known                    | Verdict                        |
|----------------|-----------------|-------------------------------|--------------------------------|
| \([28,7,12]\)  | \([[28,14,4]]\) | \([[28,14,5]]\), exact        | one below the record           |
| \([120,9,56]\) | \([[120,102,4]]\)| \([[120,102,5]]\), exact     | one below the record           |
| \([240,10,112]\)| \([[240,220,4]]\)| \(4\le d\le 6\)              | matches the record lower bound |

The pattern is consistent across the whole ladder: every unsigned incidence
lift lands at distance four, one short of the record wherever the record is
known exactly.  The \([[240,220]]\) entry matches the published lower bound
only because that bound is itself 4 and its upper bound is still open, so it
is not evidence that the affine level behaves differently.

The obstruction is the same one identified at E7 in C682.  Unsigned binary
supports keep the full exceptional symmetry but always admit weight-four
logical operators — here 264,180 of them.  Reaching distance five requires
signed Pauli or \(\mathbf F_4\) data, and the affine level supplies a natural
place for the sign to live, namely the level coordinate.

## Higher levels

The overextended lattice \(E_{10}=II_{9,1}=E_8\oplus U\) reduces mod 2 to a
nondegenerate ten-dimensional plus-type space with 496 nonsingular vectors,
and the same affine-function construction gives \([496,11,240]_2\) with
enumerator \(1+1023z^{240}+1023z^{256}+z^{496}\).  codetables.de serves only
\(n\le 256\) over GF(2), so no parameter comparison is available and none is
claimed.  Unlike E9 this carrier is nondegenerate, so it is not a Plotkin
doubling of the E8 code, which makes it the more promising place to look for
a level that recovers optimality.

## Evidence and replay

From `/home/tavis/src/othello`, run

```sh
python3 notes/2026-08-05-c865-e9-affine-level-code.py --check
sha256sum -c notes/2026-08-05-c865-e9-affine-level-code.sha256
```

The checker builds the 240 E8 roots in the standard eight-dimensional
realization with exact rational arithmetic, solves for their coordinates in
the Bourbaki simple-root basis, and reduces mod 2 to confirm 120 nonsingular
classes.  It then builds \(q\) and its polarization on \(E_9/2E_9\) directly
from the Gram matrix, verifies \(\delta\) is an isotropic radical vector,
and checks that the 240 nonsingular vectors are exactly the mod-2 images of
the real affine roots.  It constructs deterministic hyperbolic bases on both
the intrinsic and packed eight-dimensional models, transports one to the
other, and verifies the isometry preserves \(q\) and \(B\).  It then
enumerates the full \(2^{10}\)-word code, verifies the weight enumerator,
double evenness, and self-orthogonality, performs the level fold and compares
it word for word against the transported C682 code, verifies the Plotkin
decomposition as a set equality, and counts the dual tetrads by a pair-sum
argument rather than by brute-force enumeration.  Standard library only, no
randomness.

## EJ + TT closeout and mystery ledger

- **Settled — the affine level exists and is exact.**  240 mod-2 real affine
  roots, \([240,10,112]\), folding onto the E8 code word for word.
- **Settled — why the ladder's optimality stops here.**  The level fold is a
  Plotkin sum against the repetition code; \(\min(112,120)=112\) and 112 is
  below the \([240,10]\) record range.  This is a structural consequence of
  the radical being one-dimensional, not a failure to search.
- **Settled — the CSS ceiling is uniform.**  Distance four at every level,
  one below the record wherever the record is exact.
- **Open — a rebalanced affine code.**  Nothing intrinsic to \(E_9\) supplies
  a \(v\)-code between the repetition code and the E8 code.  Whether a
  \([120,k,114]\)-ish partner with E8-monomial symmetry exists is untested.
- **Open — the \(E_{10}\) level.**  \([496,11,240]\) is exact but
  uncomparable against public tables at that length.
- **Open — novelty.**  Delegated as C866; see that report.

**Superseded in part by C867.**  The affine carrier is not special: this code
is the root-link half of the \(E_{10}\) code \([496,11,240]\), so the Plotkin
description above is an accident of the degenerate carrier rather than the
operation that produces the code.  C867 also proves no Plotkin rebalancing
beats 112 here, and that no invariant enlargement of this code exists.  See
`2026-08-05-c867-ladder-record-attack.md`.

## Vibe check

Solid but deliberately deflationary.  The affine level was the obvious next
move and it works cleanly, with a genuinely independent lattice-side
construction rather than a re-labelled repeat of the E8 model.  The valuable
part is the negative: the ladder's run of unrestricted optimality ends at
E9, and it ends for a reason we can name in one line.  That converts a vague
"does this keep going" question into a specific one about rebalancing the
Plotkin partner, and it makes \(E_{10}\) rather than \(E_9\) the interesting
next carrier.
