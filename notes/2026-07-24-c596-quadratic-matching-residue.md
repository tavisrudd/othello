# C596: quadratic refinement of the conic matching residue

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** complete negative at the bounded discriminator gate.  Centering a
residue witness produces a canonical binary quadratic space and does separate
some regular-hyperoval conic configurations from Mathon's nonrealizable
matching design.  It is not a universal realization invariant: 1,890 actual
disjoint-conic configurations with matching residue have exactly the same
quadratic signature as all 1,080 Mathon matching-residue witnesses.  Since the
\((4096,92)\) exception also has matching residue, the refinement supplies no
obstruction there.

## Canonical centered quadratic space

Let \(M_1,\ldots,M_9\) be a ten-point C556 witness, and let \(R\) be its odd
edge residue, either a perfect matching or a vertex star.  In the binary edge
space of \(K_{10}\), put
\[
 V=\left\langle M_i+R:1\le i\le9\right\rangle .
\]
Both \(M_i\) and \(R\) have odd weight, so every vector in \(V\) has even
weight.  Hence
\[
 q(v)=\frac{\operatorname{wt}(v)}2\pmod2
\]
is a quadratic refinement of the support-intersection form:
\[
 q(u+v)=q(u)+q(v)+|\operatorname{supp}(u)\cap
 \operatorname{supp}(v)|\pmod2.
\]
The construction uses only the selected blocks and their residue.  Its
dimension, polar radical, restriction of \(q\) to the radical, and Arf
invariant when \(q\) descends to the nonsingular quotient are therefore
invariant under relabelling.

The relation \(\sum_i(M_i+R)=0\) makes \(\dim V\le8\).  Every enumerated
witness has dimension exactly eight.

## Exhaustive witness comparison

The certificate reuses C556's exhaustive lists:

| class | matching-residue witnesses | centered signatures | star-residue witnesses | centered signatures |
|---|---:|---:|---:|---:|
| regular hyperoval | 64,260 | 4 | 13,020 | 5 |
| Mathon | 1,080 | 1 | 114 | 2 |

All Mathon matching-residue witnesses have
\[
 \dim V=8,\qquad \operatorname{rad}V=0,\qquad
 |\{q=0\}|=120,\quad |\{q=1\}|=136,\qquad \operatorname{Arf}(q)=1.
\]
The regular class contains 18,900 witnesses with the same signature.  The
same signature also occurs among 4,536 regular and 108 Mathon star-residue
witnesses.  Thus neither the mod-\(4\) weight enumerator nor the centered Arf
invariant distinguishes the two abstract designs.

The particular conic used in C556 does have a signature absent from Mathon:
\[
 \dim V=8,\qquad \dim\operatorname{rad}V=2,\qquad
 q|_{\operatorname{rad}V}\ne0.
\]
That fact alone could have been an artefact of the chosen conic.  The cheap
geometric closeout therefore enumerated all conics disjoint from the fixed
regular hyperoval.

## All disjoint conics over \(\mathbf F_8\)

There are
\[
 \frac{8^6-1}{8-1}=37,449
\]
projective ternary quadratic forms over \(\mathbf F_8\).  Exact enumeration
retains precisely the forms whose zero sets have nine points, contain no
collinear triple, and are disjoint from the fixed regular hyperoval.  It finds
7,728 nondegenerate disjoint conics:
\[
 6,426\ \text{have matching residue},\qquad
 1,302\ \text{have star residue}.
\]

The star-residue conics have no centered signature occurring among Mathon's
star witnesses.  This is a real finite separation.  It is the wrong parity
branch for the open exception: C556 proves that at \((q,k)=(4096,92)\) the
conic nucleus lies outside the arc and the residue is a perfect matching.

On the relevant matching branch, 1,890 genuine regular-hyperoval/disjoint-conic
configurations have the same nonsingular Arf-one signature as Mathon's 1,080
matching witnesses.  Therefore even adding actual conic geometry does not
make the centered quadratic signature a necessary realization discriminator.

## Evidence and scope

The atomic evidence bundle is

- `notes/2026-07-24-c596-quadratic-matching-residue.py`;
- `notes/2026-07-24-c596-quadratic-matching-residue.json`;
- `notes/2026-07-24-c596-quadratic-matching-residue.sha256`.

Replay from the repository root:

```bash
python3 notes/2026-07-24-c596-quadratic-matching-residue.py --check
(cd notes && sha256sum -c 2026-07-24-c596-quadratic-matching-residue.sha256)
```

The generator pins the C556 script and certificate hashes.  It regenerates
C556's complete witness sets, enumerates every vector in each at-most
eight-dimensional centered span, and independently enumerates every projective
quadratic form over \(\mathbf F_8\).  Each retained conic is checked directly
for size, disjointness, absence of collinear triples, its nine selected
matchings, and whether its residue is a unique star or a unique matching.

The exhaustive C556 witness counts are an independent regression check for
the witness enumeration.  The new quadratic signatures and all-conic count
have one exact implementation, with direct internal identities but no second
enumerator.  The result is a bounded ten-point falsifier.  It makes no
classification or nonexistence claim at \(k=92\), and no novelty claim.

Artifact data:

| file | bytes | SHA-256 |
|---|---:|---|
| generator | 18,578 | `64ac43f5de2a92ab8295295ce8ff397f8d891f24ac8ca151fbce1db847fad197` |
| JSON certificate | 40,938 | `9866fdfad51cb63b751c48eb6a5501102886b97948ddb779d6dc10536c9bd9bd` |

## `ej` + `tt` closeout

The free upgrade was to replace the single C556 conic by all 37,449
projective quadratic forms.  This revealed the important parity split: every
actual star-residue conic is quadratically separated from Mathon, but actual
matching-residue conics are not.

The Tao-style stress test is to ask whether the invariant is forced on the
branch needed at \(k=92\), rather than whether one attractive example has it.
The 1,890 overlapping geometric matching cases answer no.  A further census
of quadratic signatures would only refine a non-universal invariant.

**NO-GO:** the Clebsch-like bit admits a natural mod-\(4\) quadratic lift, but
that lift still reads local residue structure rather than rank-three
realizability.  Do not promote it to the manuscript or to the exceptional
\((4096,92)\) argument.

## Mystery ledger

- **Settled:** centering at the odd residue gives the canonical quadratic
  refinement; no arbitrary base matching or labelling is required.
- **Settled:** the chosen C556 conic's nonzero radical is genuine, and all
  actual star-residue conics avoid Mathon's two signatures.
- **Settled negatively:** this separation does not survive the matching
  branch.  The exact overlap consists of 1,890 regular conic configurations
  and all 1,080 Mathon matching witnesses with the nonsingular Arf-one
  signature.
- **Explained:** star versus matching residue records whether the conic
  nucleus lies in the hyperoval.  The \(k=92\) exception lies on the matching
  side, so the favorable star signal is not transferable.
- **Open elsewhere:** a nonlinear many-base invariant could still distinguish
  rank-three realization, but C596 supplies no new gate for it.  The lane's
  next clean route remains the square-restriction degeneracy locus.
