# 2026-08-20 — C816 work item 2: Theorem D landed in Paper III, with its table certified against the manuscript's own representative

**Task:** C816 (lane `clebsch`), work item 2.
**Bundle:** this report, `2026-08-20-c816-theorem-d-table.py`, and
`2026-08-20-c816-theorem-d-table.json`, committed together.
**Manuscript:** `papers/clebsch-passages/sections/05-golden-operator.tex`,
`thm:golden-equality-rigidity` and the module paragraph that follows it.

## What landed

The rigidity statement C809 proved and C815 reduced to a structural argument is now in the
manuscript as `thm:golden-equality-rigidity`, stated as proved rather than certified. It says the
twenty equations \(F_S=h_S-4\tau_S\) have Jacobian of rank fourteen at the conference representative
\(C\) displayed in the manuscript's orientation-source section, with kernel the scaling line, so the
oriented equality locus is that line near \(C\). The proof in the text carries the whole chain:
Euler's relation for the upper bound, the multilinear difference rule with closed forms for the
partial derivatives, the stabilizer and its identification as the alternating group of degree five,
the fixed-vector argument that moves the computation into a five-dimensional space, the reduced
eight-by-five table, the \(-5\) minor, and the constant-rank step.

Four of the five proposals in
`notes/2026-08-05-c815-rank-14-weighted-jacobian.md` § "Proposed manuscript changes" were taken and
one declined, as that report recommended:

1. **Taken.** The numerical comparison sentence is replaced by the module statement. The Jacobian is
   injective on the four-dimensional constituent, so the conference deformations the cubic equality
   kills are exactly the scalings, and the conference count and the cubic count are one statement.
2. **Taken.** The eigenspace description is in the text: differentiating \(A^2=\lambda I\) gives
   \(CX+XC=\mu(X)I\), and multiplying by \(C\) with \(C^2=5I\) gives \(CXC=\mu(X)C-5X\), so
   \(X\mapsto\frac15CXC\) is an involution of the conference tangent space whose eigenspaces are the
   scaling line and \(\ker\mu\). The splitting no longer rests on a character computation.
3. **Taken.** The reduced table is carried with its derivation rather than as a display. The text
   states multilinearity, the difference rule, and the closed forms — \(\partial F_S/\partial
   a_e=-4\varepsilon a_{ik}a_{jk}\) for an edge inside \(S\), the signed \(2\times2\) cofactor of the
   cross block for an edge joining \(S\) to \(S^c\), zero for an edge inside \(S^c\) — so a reader
   can regenerate any entry.
4. **Taken, in a stronger form than proposed.** The proposal was to add the complementation
   antisymmetry as a remark. What went in instead is
   `prop:nonsingular-complementary-minors`, proved below, which subsumes the reason the factor
   \(4\) appears at all.
5. **Declined, as recommended.** The characteristic-five theorem stays out. The proposed footnote
   about five dividing the reduced minor is unnecessary now that the \(-5\) appears in the text with
   its role stated.

## The addition C815 did not propose

The audit's closeout pass turned up a census equivalence at order six and the parity reduction that
suggested a proof route; both are in `notes/2026-08-20-c816-extremal-minor-census.md`. The proof came
out, and it is short enough to carry in the manuscript, so the equivalence is landed as a theorem
rather than as a remark citing a census:

> **Proposition.** Let \(A\) be symmetric of order six with zero diagonal and every off-diagonal
> entry \(\pm1\). Then \(A^2=5I\) if and only if \(\det A[S^c,S]\ne0\) for every \(3\)-subset \(S\),
> and in that case every one of those twenty determinants is \(\pm4\).

The proof rests on two elementary facts and one identity. A \(3\times3\) sign matrix has determinant
\(0\) or \(\pm4\) — subtract the first row from the others and the determinant is divisible by four,
while Hadamard's inequality bounds it by \(3\sqrt3\) — and it is singular exactly when two rows are
equal or opposite, which follows from the Gram determinant \(18+2g_1g_2g_3\) having to be a square.
The identity is that for \(S^c=\{p,q,r\}\),
\(\sum_{m\in S}a_{pm}a_{qm}=(A^2)_{pq}-a_{pr}a_{qr}\), because the sum defining \((A^2)_{pq}\) runs
over \(S\cup\{r\}\). Nonsingularity forces the left side away from \(\pm3\) for each of the four
choices of \(r\); writing \(t_r=a_{pr}a_{qr}\) and counting the \(r\) with \(t_r=1\), the four
resulting conditions leave exactly one count, and it gives \((A^2)_{pq}=0\).

Two consequences went into the manuscript with it. The factor \(4\) in the recognition theorem is
now explained where it appears — a \(3\times3\) sign matrix has no other nonzero absolute
determinant, so once the complementary minors are forced away from zero the constant has no freedom
— and the boundary sentence after the recognition theorem now names the right set: what is
unclassified is the set of weighted matrices satisfying the *proportionality*, not the solutions of
\(A^2=\lambda I\), which the module paragraph describes.

## Replay

From the repository root, with CPython 3.13.12 and no third-party dependencies:

```sh
python3 notes/2026-08-20-c816-theorem-d-table.py --check
```

`--check` regenerates the certificate in memory, compares it byte for byte against the tracked JSON,
leaves the worktree unchanged, and exits nonzero on any difference. `--write` regenerates the tracked
file. The run takes about a tenth of a second.

**Inputs and conventions.** Order six throughout. The representative is the conference matrix
displayed in the manuscript's orientation-source section, pinned in the script as `ENTRIES`; the
order-three symmetry is \(h=(0\,2\,4)(1\,3\,5)\) with signs \((+,-,-,-,-,+)\), pinned as `H_PERM` and
`H_SIGNS`. Both are the manuscript's choices, not the C815 report's, which is the point of this
bundle. Enumeration is deterministic — `itertools` products and permutations in their natural order —
with no randomness and no seed. Arithmetic is exact CPython integers and `fractions.Fraction`; there
is no floating point.

**Hashes and byte counts.**

| File | Bytes | SHA-256 |
|---|---|---|
| `notes/2026-08-20-c816-theorem-d-table.py` | 14063 | `39d7481da14c2a7bb22a7978389da712d16bbd7a2e5d1d8692b0aecec1a11aff` |
| `notes/2026-08-20-c816-theorem-d-table.json` | 3918 | `8b292734d8ec23390f95f40ffb428534b92633ed9d3c1b919ec3425359994b58` |

**What the certificate certifies.** That the manuscript's representative is a conference matrix; that
the coefficient of \(x_S\) in \(\operatorname{Pf}[D_x,C]\) is \(4\tau_S\) for all twenty triples,
which fixes the orientation and removes any sign-convention ambiguity between the manuscript and the
C815 report; the closed forms for the partial derivatives, checked entry by entry against the
difference rule; that the stabilizer modulo the global sign has order sixty with element orders
\(1,2,3,5\) occurring \(1,15,20,24\) times and with every permutation sign and switching determinant
\(+1\); the character \((15,3,0,0,0)\) of the edge module; that \(h\) has order three, that its fixed
space is five-dimensional with the displayed orbit basis, and that \(C\) has coordinates
\((1,1,1,-1,-1)\) there; the eight reduced rows exactly as displayed; that every row annihilates
\(C\); that the rank on the fixed space is four; the value \(-5\) of the displayed four-by-four
minor; and that the conference system has rank eleven in its sixteen variables, so the conference
tangent space is five-dimensional.

**What it does not certify.** The constant-rank step, which is ordinary real analysis; the
representation-theoretic reduction from the fixed space back to the full space, which is the proof's
argument rather than a computation; the nondegeneracy proposition, which is proved in the manuscript
and needs no computation; and anything at any other order. The trusted boundary is CPython integer
and rational arithmetic together with `itertools`.

**Independent cross-checks.** The Pfaffian coefficients are computed twice by different routes, the
matching expansion and the signed complementary minor, and disagreements are counted; the count is
zero. The Euler relation is checked row by row rather than assumed. The closed-form derivative rules
are checked against the difference rule on every one of the three hundred entries. The prior bundle
`notes/2026-08-05-c815-rank-14-weighted-jacobian.{py,json}` reaches the same rank, stabilizer,
character, and isotypic dimensions from a separate code path and at a different representative, and
verifies the order-three reduction for all twenty order-three elements rather than the one displayed
here.

## Gates run

| Gate | Result |
|---|---|
| `verification/verify_scaffold.py` | OK; eleven sections, nine claims, `local_release_ready=true` |
| `verification/check_manuscript_build.py` inside the pinned manuscript shell | PASS, thirty-seven pages, warning-free |
| `notes/2026-08-20-c816-theorem-d-table.py --check` | OK |
| `notes/2026-08-20-c816-extremal-minor-census.py --check` | OK |

The tracked PDF was refreshed through the supported `--update` path, and the gate's pinned page count
moved from thirty-five to thirty-seven with the two pages the additions occupy. Pages twenty and
twenty-one were rendered and read; the table, the displayed identity, and the proposition all set
correctly.

## Also in this pass

Work item 5, the hard-coded equation numbers, is closed. The three `\tag` uses the card names in
`sections/05-golden-operator.tex` were already gone; one survivor in
`sections/02-orientation-cover.tex` hard-coded `\tag{2.1}` with a prose reference reading
"Equation~(2.1)". Both are now a semantic `\label{eq:branch-cycle}` and an `\eqref`.

## Still open on C816

Work item 3, the shorter balanced exchange rigidity proof, and work item 4, the abstract and theorem
hierarchy decision, which the audit ungated. The review and release gates beyond the paper-local ones
— red team, Milnor–Serre pass, cold read, downstream synchronization — have not been run.
