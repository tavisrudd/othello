# C756 local diagonal-sign conjecture: exact negative verdict

## Verdict

The tempting local finisher is false.  A coherent all-passant quadrangle does
not have nonpositive diagonal character once \(q>5\), nor does it have a
fixed diagonal-type profile.  In the exact prime-field census:

- coherent quadrangles at \(q=13,17,19,23\) have positive aggregate diagonal
  bias;
- by \(q=17\), all four values \(r=0,1,2,3\) of the number of internal
  diagonal points occur; and
- \(q=11\) is exactly balanced, while \(q=7\) has no coherent quadrangle.

Therefore Proposition 29's positive-bias requirement cannot be contradicted
by a theorem about one coherent \(K_4\) at a time.  Any successful sign
obstruction must use the global size-\((m+1)\) simplex/eigenvector relation,
the simultaneous angle bijections, or another constraint coupling different
four-subsets.

## 1. Tested local hypothesis

Let \(K\) be the signed elliptic-fusion matrix and
\(\epsilon=\chi_q(-1)\).  Four internal points form a coherent quadrangle
when:

1. all six joins are passants;
2. no three points are collinear; and
3. after switching, their signed edges are constant, equivalently
   \[
   K_{ij}K_{jk}K_{ki}=\epsilon
   \quad\text{on every triangle}. \tag{1}
   \]

Condition (1) is exactly the restriction to four points of the saturated
equality-support equation \(K_{ij}=\epsilon\eta_i\eta_j\).  For each such
quadrangle \(A\), the certificate computes the three diagonal points and
records
\[
 r(A)=\#\{\text{internal diagonal points}\},
 \qquad
 t(A)=3-2r(A). \tag{2}
\]
The proposed local route would have needed \(t(A)\le0\) for every coherent
quadrangle outside the four-frame case, or at least a uniform negative
average strong enough to oppose covering.

## 2. Exact census

| \(q\) | coherent quadrangles | histogram of \(r(A)\) | \(\sum_A t(A)\) |
|---:|---:|---|---:|
| 5 | 5 | \(0^{5}\) | 15 |
| 7 | 0 | empty | 0 |
| 11 | 1,320 | \(1^{660},2^{660}\) | 0 |
| 13 | 5,187 | \(0^{3003},2^{2184}\) | 6,825 |
| 17 | 37,128 | \(0^{11424},1^{9792},2^{13464},3^{2448}\) | 23,256 |
| 19 | 88,920 | \(0^{10260},1^{44460},2^{27360},3^{6840}\) | 27,360 |
| 23 | 412,896 | \(0^{48576},1^{188232},2^{170016},3^{6072}\) | 145,728 |

The result is decisive against a local sign or parity lemma.  In particular,
the positive covering sign from Proposition 29 is common rather than locally
forbidden among coherent quadrangles in four of the tested fields.

The table does **not** exhibit a saturated coherent support at any \(q>5\).
It enumerates hereditary four-point restrictions only.  Its role is a stop
certificate for the proposed proof mechanism, not evidence for existence.

## 3. Consequence for the proof architecture

The Gram-cofactor formula remains useful, but it must be summed with global
weights or combined with the equality vector
\[
 x_P=\eta_P\mathbf1_Y(P),
 \qquad Kx=\lambda x. \tag{3}
\]
A successful continuation needs information unavailable on one quadrangle:

- compatibility of the same switching signs across all \(m+1\) points;
- the exact outside balance obtained by testing (3) against every internal
  point;
- the simultaneous angle-row bijections; or
- the signed-incidence reconstruction of a deleted point.

Simply summing an inequality valid for all coherent quadrangles is no longer
plausible, because the required local inequality is false.  A centered
identity could still work: the global eigenvector relation may cancel the
positive local background and leave a support-dependent remainder.  That is
a different, genuinely global calculation.

## Reproduction

From the repository root:

```sh
python3 notes/2026-08-09-c756-coherent-quadrangle-diagonal.py --check
```

The checker uses only the Python 3 standard library and the independently
committed signed-fusion constructor.  It rebuilds the internal points, tests
all passant/coherence/general-position conditions exactly, and computes
diagonal types directly in projective coordinates.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-09-c756-coherent-quadrangle-diagonal.py` | 4,811 | `652de1b8651a7994d3a7c84d6b238069a10af937c8dbafe0b02d94ce55ca7a39` |
| `notes/2026-08-09-c756-coherent-quadrangle-diagonal.json` | 1,730 | `83c8d15ae3c0088a0094c5cea5abacd486da72c3cc08b9a4cd2c8a906a071ab4` |

The scope is every coherent quadrangle over the prime fields
\(q\in\{5,7,11,13,17,19,23\}\).  It does not cover extension fields or
classify global supports.

## EJ + TT closeout

**EJ.**  The failure is informative rather than merely null: local coherence
and diagonal bias are nearly orthogonal.  This confirms that Proposition 29
is detecting the global star arrangement, not a hidden restatement of signed
triangle holonomy.

**TT.**  It would be easy to weaken the false claim to an average over all
coherent quadrangles in the ambient geometry, but the table already makes
that average positive in most tested fields.  Such an ambient average is also
not the average induced by a hypothetical minimum-support eigenvector.  Do
not fit a field-dependent formula to these totals; move to global balance.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Does coherence fix \(r(A)\)? | settled negative | all four values occur by \(q=17\) |
| Does every coherent quadrangle have nonpositive bias for \(q>5\)? | settled negative | \(q=13\) already has 3,003 quadrangles with maximal positive bias |
| Can an ambient coherent-quadrangle average contradict covering? | settled negative on the tested domain | aggregate bias is positive at \(q=13,17,19,23\) |
| Is Proposition 29 weakened? | no | it is a global necessary condition for the star vertex set, untouched by local counterexamples |
| What input is now indispensable? | settled | a relation coupling different four-subsets, such as the global equality eigenvector or reconstruction law |
| Highest-EV next move | open | contract the diagonal statistic against the global equality vector/outside-balance equations; stop if it does not reduce below fourth order |

## Next action

Attempt one centered global contraction: express the star-vertex indicator or
its passant-edge energy through the signed incidence images of the equality
vector and use \(Kx=\lambda x\).  If the absolute-value passage from signed
incidence to the star union destroys the sign information, record that exact
loss and move to a focused literature audit of structured relative blocking
sets.
