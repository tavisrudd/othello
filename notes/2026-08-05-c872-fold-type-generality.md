# C872 — the fold is type-general; the closed-form tetrad count and the translation identity

**Date:** 2026-08-05
**Task:** C872
**Lane:** `clebsch`
**Status:** exact research bundle; no manuscript or Lean file changed

> **This report replaces an earlier version of itself.** The earlier version,
> filed under `2026-08-05-c872-fold-is-plus-type-only.md`, claimed the affine
> code descends under the fold only at plus type, and concluded from that the
> code-level statement carries content beyond the graph-level Taylor extension
> result of Brouwer and Shult. **That claim was an indexing error and is
> withdrawn.** The checker read codeword bits at positions in the link while the
> words were indexed over the full point set, which silently sampled the wrong
> coordinate at minus and parabolic type. Corrected: the code descends in full at
> every type. The C871 verdict that the surviving residue is thin therefore
> stands, and the handoff paragraph that reopened the novelty question on the
> strength of the withdrawn claim has been reverted.

## Result one: the fold is type-general

Run the fold at plus, minus and parabolic quadrics.  Both the point count and
the code descend correctly in every case.

| Type       | Rank | Code             | Link | Folds to        | Next level's code | Full descent |
|------------|------|------------------|------|-----------------|-------------------|--------------|
| plus       | 6    | \([28,7,12]\)    | 12   | \([6,5,2]\)     | \([6,5,2]\)       | yes          |
| plus       | 8    | \([120,9,56]\)   | 56   | \([28,7,12]\)   | \([28,7,12]\)     | yes          |
| plus       | 10   | \([496,11,240]\) | 240  | \([120,9,56]\)  | \([120,9,56]\)    | yes          |
| minus      | 6    | \([36,7,16]\)    | 20   | \([10,5,4]\)    | \([10,5,4]\)      | yes          |
| minus      | 8    | \([136,9,64]\)   | 72   | \([36,7,16]\)   | \([36,7,16]\)     | yes          |
| parabolic  | 7    | \([64,8,28]\)    | 32   | \([16,6,6]\)    | \([16,6,6]\)      | yes          |
| parabolic  | 9    | \([256,10,120]\) | 128  | \([64,8,28]\)   | \([64,8,28]\)     | yes          |

The mechanism is uniform and needs no case analysis.  A codeword \(\ell+c\) is
constant on the pair \(\{u,u+\alpha\}\) exactly when \(\ell(\alpha)=0\), so the
constant-on-pairs subcode always has codimension one, and the only affine
function vanishing on the whole link is the one cutting out the affine
hyperplane \(B(\alpha,\cdot)=1\) that contains it.  Dimension therefore drops by
exactly two at every type and every rank.  Nothing here distinguishes the Arf
invariant, which is what the corrected computation shows.

So the code-level fold runs exactly parallel to the graph-level statement and
adds no type-sensitivity to it.

## Result two: the tetrad count in closed form, hence CSS distance at every rank

The nonsingular set of any \(\mathbf F_2\) quadratic form is a **perfect
difference set**: every nonzero vector occurs as a difference the same number of
times,

\[
 \lambda=\frac{N(N-1)}{2(2^n-1)}.
\]

A dual word of weight two is impossible because the points are distinct, and one
of weight three is impossible because the constant row forces even weight.  So
the dual distance is four exactly when the tetrad count is nonzero, and

\[
 T=\frac{(2^n-1)\,\lambda(\lambda-1)}{6}.
\]

| Type  | Rank | \(N\) | \(\lambda\) | \(T\)     |
|-------|------|-------|-------------|-----------|
| plus  | 6    | 28    | 6           | 315       |
| plus  | 8    | 120   | 28          | 32,130    |
| plus  | 10   | 496   | 120         | 2,434,740 |
| minus | 6    | 36    | 10          | 945       |
| minus | 8    | 136   | 36          | 53,550    |

Every level of every family has CSS distance exactly four, at every rank and
type, by formula rather than search.  This replaces the four separately observed
coincidences of C682, C865, C867 and C868 with one statement and removes the
computational cap the earlier version carried.  It is unaffected by the
retraction above.

## Result three: the odd-form coincidence is a translation

The fold target was described by an odd form \(\bar Q\) while the next level is
the nonsingular set of a form of the original type.  For nonsingular \(t\),

\[
 Q(x+t)=Q(x)+Q(t)+B(t,x)=Q'(x)+1,
 \qquad Q'(x):=Q(x)+B(t,x),
\]

so \(Q'\) is a quadratic form of the opposite type whose zero set, translated by
\(t\), is the nonsingular set of \(Q\).  Affine codes are translation invariant,
so the two descriptions give the same code.  Verified at rank eight.  Also
unaffected by the retraction.

## Evidence and replay

From `/home/tavis/src/othello`, run

```sh
python3 notes/2026-08-05-c872-fold-type-generality.py --check
sha256sum -c notes/2026-08-05-c872-fold-type-generality.sha256
```

The fold is now computed by evaluating the affine functionals directly on the
pair representatives, so no coordinate-indexing convention is involved at all —
the class of error that produced the withdrawn claim cannot recur in this form.
The checker asserts full descent in every case rather than a dichotomy.  The
same indexing fault was present in `2026-08-05-c870-fold-tower-judo.py` and has
been corrected there; its published results are unchanged, because its
assertions compared against independently constructed codes and the plus-type
case it tested was not affected.

## EJ + TT closeout and mystery ledger

- **Settled — the fold is type-general**, with a uniform one-line mechanism.
- **Settled — CSS distance four at every rank and type**, closed form, no cap.
- **Settled — the odd-form coincidence** is translation by a nonsingular vector.
- **Withdrawn — the plus-type dichotomy**, and with it the argument that the
  code statement is strictly stronger than the graph statement.
- **Open — Brouwer and Shult (1990) at full text**, still worth closing, but now
  to pin the scope of a known result rather than to decide a claim of ours.
  Delegated as C873, by triangulation through later citing literature.
- **Open — Hyun and Hu (2026)**, still at review only.

## Vibe check

Two of the three findings stand and the headline does not.  The withdrawn claim
came from a computation whose result I wanted, checked only against cases where
the fault was invisible, and it survived long enough to be written up and to move
a handoff paragraph.  The corrected mechanism is a one-liner that could have been
derived on paper in less time than the sweep took, and it would have shown
immediately that no type-sensitivity was possible.  Deriving the mechanism before
running the sweep is the cheap habit that was missing.
