# C756 — Route F: sparse integral Paley-trade profile (twenty-third pass)

**Lane**: `clebsch` · **Date**: 2026-08-02 · **Task**: C756, saturated-internal branch

## Verdict

Route F's continue gate **passes**.  The \(q=5\) frames are isolated from every
negative coherent candidate by an exact integral/valuation profile that no prior
pass records and that is invisible to the already-tight second moment.  The
profile's first digit has a clean geometric meaning — rationality of the oriented
support sum — and the census proves the digit tower is transverse to the known
coherence statistic.  No norm, entropy, or interlacing inequality is introduced.

## Setup

For every normalized pairwise-resultant-character candidate in the bounded prime
fields \(q\in\{5,7,11,19,23\}\) (129 candidates: the two \(q=5\) frames plus 127
negatives; the same orientation-minimization bound as the 2026-08-01 uncertainty
pass), form the conjugation-odd signed vector
\[
  x=\mathbf 1_Z-\mathbf 1_{Z^q}
\]
on the additive group of \(\mathbb F_{q^2}\), where \(Z\) is the candidate in its
canonical minimizing orientation.  Fourier values use the trace pairing
\(\widehat x(w)=\sum_z x(z)\,\zeta_p^{\operatorname{Tr}(wz)}\in\mathbb Z[\zeta_p]\)
and are computed exactly as cyclotomic integers.  Valuations are at the unique
prime \(\pi=(1-\zeta_p)\) above \(p\), by the exact digit formula
\(v_\pi(\alpha)=\min_j\,(j+(p-1)v_p(c_j))\) on the \((1-\zeta)\)-expansion
(the minimum is uniquely attained because distinct \(j<p-1\) are distinct modulo
\(p-1\)).  Structural facts asserted exactly throughout: \(\widehat x(0)=0\),
\(\widehat x(w^q)=-\widehat x(w)\), hence \(\widehat x\) vanishes on all \(q\)
rational frequencies.

## Census results

| statistic | \(q=5\) frames (2) | negatives (127) |
|---|---|---|
| Fourier support | exactly 8 = all nonrational square-class frequencies | all \(q^2-q\) nonrational frequencies, both classes |
| exact values | every value \(\pm5\zeta^j\): \(q\) times a root of unity | never a rational multiple of a root of unity |
| squared moduli | all rational, uniformly \(q^2=25\) (flat spectrum) | all irrational, at every frequency |
| \(v_\pi\) profile | uniform \(v_\pi=4=p-1\) (terminal: \(v_\pi(q^2)=2(p-1)\)) | uniform \(v_\pi=1\) (114 candidates) or uniform \(v_\pi=3\) (13 candidates, all at \(q=23\)) |
| autocorrelation | two-valued: \(A(d)=3\) on the 8 nonrational nonsquares, \(-2\) on all other \(d\ne0\) | many-valued (at \(q=7\) already seven values across both classes) |
| additive energy | 200 | constant per field (e.g. 318 at \(q=7\)) — second moment sees nothing |

The valuation within each candidate is uniform across its whole Fourier support
in every one of the 129 cases.

## The digit mechanism

Expanding \(\zeta^t-\zeta^{t'}\equiv(t'-t)\pi\pmod{\pi^2}\) gives, for
\(w=(c,d)\) in the pair model \(\mathbb F_{q^2}=\mathbb F_q(\sqrt\varepsilon)\),
\[
  \widehat x(w)/\pi \equiv -2d\cdot 2\varepsilon\,\sigma_1 \pmod \pi,
  \qquad \sigma=\textstyle\sum_{z\in Z}z=(\sigma_0,\sigma_1).
\]
So \(v_\pi\ge2\) at every support frequency simultaneously iff \(\sigma_1=0\),
i.e. iff the oriented support sum is **rational**.  The census confirms this
exactly: all 114 candidates with \(v_\pi=1\) have \(\sigma_1\ne0\); all 13
candidates with \(v_\pi=3\) and both frames have \(\sigma_1=0\) (one \(q=23\)
candidate has \(\sigma=0\) outright).  Global conjugation negates \(\sigma_1\),
so rationality of \(\sigma\) is orientation-canonical for a coherent system whose
orientation is rigid up to the global flip — the condition is well-defined for
genuine saturated arcs.

Two further exact features of the tower:

- \(v_\pi=2\) never occurs: once \(\sigma_1=0\), conjugation-oddness kills the
  even digit and the valuation jumps straight to 3;
- the 13-candidate \(v_\pi=3\) group at \(q=23\) has the **larger** minimum
  coherence-violation count (30 vs 28).  The valuation tower is therefore
  transverse to the coherence residual, not the known balance condition renamed.

## Why this passes the continue gate

1. **Invisible to the second moment.**  Additive energy and the Parseval mass are
   constant across each field's candidates; the valuation histogram, rationality
   of squared moduli, and autocorrelation value count separate the frames
   completely.
2. **Integral, not analytic.**  Every recorded field is a finite exact invariant
   (support counts, cyclotomic coefficients, \(\pi\)-digits, integer
   autocorrelation values).  No renamed norm, entropy, or interlacing bound.
3. **New structure, not coherence in Fourier form.**  The digit tower orders the
   negatives differently from every prior statistic, and its first digit is a
   previously unrecorded bounded invariant of the candidate: the additive support
   sum.  All prior angle passes were multiplicative; this is their additive
   twin, and it is global (one condition per digit) rather than per-row.

## The emerging theorem shape

The frame is a **sparse integral Paley trade** in a precise sense: a \(\{0,\pm1\}\)
vector of support \(q+3\), Frobenius-odd, whose spectrum is \(q\) times a
unimodular monomial phase on exactly \(q+3\) frequencies inside one character
class, with perfectly two-valued autocorrelation.  Three exact levers appear:

- **the \(q=5\) coincidence**: the admissible class of nonrational square
  frequencies has size \((q-1)^2/2\), which equals \(q+3\) only at \(q=5\); the
  frame fills its entire admissible class flatly, an option closed to every
  \(q>5\);
- **near-extremal uncertainty**: any flat coherent system would have Fourier
  support exactly \(q+3\), against the Donoho–Stark floor
  \(q^2/(q+3)\) — within \(O(1)\) of extremality in \(\mathbb F_{q^2}\), the
  regime of subgroup-coset rigidity;
- **the digit ladder as a moment tower**: \(v_\pi\ge m+1\) is equivalent to the
  vanishing of the first \(m\) additive power-moment combinations of the oriented
  support; flatness is the terminal rung.

## Next gates (frozen)

1. Prove or refute: a genuine saturated arc's coherent orientation has rational
   support sum \(\sigma\) (digit 1).  The candidate mechanism is the balance
   theorem plus conjugation bookkeeping; this is a bounded attempt.
2. Determine the forced digit depth for genuine arcs: whether coherence pushes
   \(v_\pi\) to the terminal flat value, making the spectrum \(q\cdot(\pm\zeta^j)\)
   on exactly \(q+3\) class frequencies; if so, classify those biunimodular
   sparse trades by the group-ring norm equation and the near-extremal
   uncertainty regime.
3. Stop condition: if digit 1 is not derivable from existing exact identities and
   no new mechanism appears, or the tower stalls at bounded depth with no support
   consequence, close Route F and fall back to Route D (nullity-two repair) or
   Route R (masked Rédei gap).

## Replay

```sh
cd notes
python3 2026-08-02-c756-sparse-paley-trade-profile.py --check
```

Artifacts and hashes:

- `2026-08-02-c756-sparse-paley-trade-profile.py`
  `47eb40da66e709253026d106d5c3f2b8970787863864fccfefa4e9fbc5348e0e`
- `2026-08-02-c756-sparse-paley-trade-profile.json`
  `aff01eaca65af97f8ea8735cc85ad38ae917e46f7cf736d5bf32de4174e5b4bb`

Inputs (hashes recorded inside the JSON): the candidate enumerator
`2026-08-01-c756-probability-cheap-tests.py` and the audit
`2026-08-01-c756-saturated-internal-audit.json`.  Fields \(q=31,43\) are excluded
by the same exhaustive-orientation bound as the prior uncertainty pass; nothing
in the verdict depends on them.

## EJ + TT closeout

**EJ.**  The free upgrade landed in-pass: the two-valued autocorrelation
identity \(A=-2+5\cdot\mathbf 1_{\text{nonrational nonsquares}}+10\,\delta_0\)
and the monomial-phase value list are now exact recorded objects, so the next
pass can start from the group-ring equation rather than re-deriving it.  The
inversion identity \(\widehat y=q\,x\) for \(y=\widehat x/q\) is trivial
(Fourier inversion); the nontrivial recorded fact is that \(y\) is itself
monomial-phase valued on a class — the frame is Fourier self-dual up to phase.

**TT.**  The Tao-shaped observation is the uncertainty framing: a flat coherent
system at any \(q\) would be an \(O(1)\)-near-extremal support pair in
\(\mathbb F_{q^2}\), and near-extremal vectors carry subgroup-coset structure —
a classification instrument none of the previous 22 passes could reach.  The
sharpest skeptical question — is the valuation profile just coherence again? —
is answered negatively inside the census by the \(q=23\) transversality.

## Mystery ledger

| mystery | status | exact gap / owner |
|---|---|---|
| Is the \(q=5\) frame Fourier-integrally exceptional? | settled positively | this census: flat \(q\cdot\zeta^j\) spectrum, terminal valuation, two-valued autocorrelation |
| Why does \(v_\pi=2\) never occur? | settled | conjugation-oddness kills even digits once \(\sigma_1=0\) |
| Do genuine saturated arcs force digit 1 (\(\sigma\) rational)? | open | next gate 1; balance-theorem attempt |
| What selects the 13 \(\sigma_1=0\) candidates at \(q=23\), absent below? | open | unexplained residue texture; log-only, no allocated work |
| Does coherence force full flatness for \(q>5\)? | open | next gate 2; the classification lever |
