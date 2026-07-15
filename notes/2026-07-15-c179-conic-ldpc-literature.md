# C179 — Fixed-conic binary-code literature rebase

**Date**: 2026-07-15
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED** — the manuscript now distinguishes the adjacent binary incidence codes
from the six-coordinate $\mathbb F_{11}$ MDS/deep-hole code.

## Verdict

The omitted literature was real and close enough geometrically that a referee could reasonably
object to its absence. It does **not** duplicate the paper's code or its rigidity, covering-radius,
deep-hole, gap, or chirality results.

The neighboring papers fix the same conic in `PG(2,q)`, split points into internal/conic/external
classes and lines into passant/tangent/secant classes, and exploit the same
`PGL(2,q)`/`PSL(2,q)` action and conic polarity. Their codes, however, are binary incidence
null spaces or row spaces whose coordinates are all internal or all external points. The Clebsch
paper studies an `F_11`-linear `[6,3,4]` MDS code whose six coordinates are the vertices of one
Clebsch hexagon and whose projective syndrome/deep-hole locus is the fixed conic. The shared
geometry is infrastructure, not the same coding object.

The manuscript now says this explicitly and cites the direct lineage rather than mentioning only
Van de Voorde's separate stopping-set connection.

## Exact object ledger

| Source | Matrix / code object | `q=11` specialization | Relation to Clebsch paper |
|---|---|---:|---|
| Droms--Mellinger--Meyer (2006) | Four binary LDPC null-space codes from the passant/secant by internal/external submatrices of the full point--line incidence matrix | several length-55 or length-66 binary codes | Origin of the direct fixed-conic LDPC line; not a six-coordinate `F_11` code |
| Sin--Wu--Xiang (2011) | Binary null space of secant lines versus external points | length `66`, dimension `24` | Proves one Droms--Mellinger--Meyer dimension conjecture |
| Madison--Wu (2012) | Binary null space of the `55 x 55` passant-line versus internal-point incidence matrix | `[55,25]_2` | Most directly adjacent point--line code; no six-arc coordinate set |
| Wu (2013) | Rows are `PSL(2,q)`-stabilizer-orbit conics consisting wholly of internal points; columns are all internal points | row rank `24`, null-space code `[55,31]_2` | Most directly adjacent conic-block code; C178 reconstructs its 110 `q=11` blocks |
| Madison--Wu (2016) | External-point analogue: orbit conics versus the external-point class, with associated binary code and automorphism group | length `66` | Same orbit-conic program on the other point class; abstract-level check only |

Although the 2006 body remains unavailable, later primary proof papers explicitly identify the
four Droms--Mellinger--Meyer matrices and settle their dimension conjectures. At `q=11` the full
line-class by point-class ledger is:

| parity-check incidence | size | row / column weights | rank | binary null-space code |
|---|---:|---:|---:|---:|
| passant lines by internal points | `55 x 55` | `6 / 6` | `30` | `[55,25]` |
| secant lines by external points | `66 x 66` | `5 / 5` | `42` | `[66,24]` |
| secant lines by internal points | `66 x 55` | `5 / 6` | `35` | `[55,20]` |
| passant lines by external points | `55 x 66` | `6 / 5` | `35` | `[66,31]` |

The papers transpose the global incidence matrix relative to one another, so labels such as
`A23` and `A32` are intentionally omitted here; the explicit line-class by point-class descriptions
are stable.

For Madison--Wu (2012), `|I|=q(q-1)/2` and
`dim L=(q-1)^2/4`, hence `55` and `25` at `q=11`. For Wu (2013), since
`11 = 3 (mod 4)`, the row-space dimension is `(q-1)^2/4-1=24` and the null-space
dimension is `(q-1)(q+1)/4+1=31`. These are exact consequences of the papers' stated
formulas, not parameter guesses.

## Wu's construction and the C178 check

For an internal point `P`, Wu takes the length-`q+1` orbits of its stabilizer
`H_P <= PSL(2,q)` on the internal points. Each such orbit is a nonsingular conic consisting
entirely of internal points, and every passant line meets it in zero or two points. The binary
incidence matrix has those conics as rows and all internal points as columns.

C178 independently reconstructed the `q=11` case: 110 distinct conics in two
`PSL(2,11)`-orbits of 55, with each of the 55 passants meeting a block in the histogram
`0^19 2^36`. It then answered the new gem-lane question negatively: the graph joining two points
when their line is passant has clique number 4 on one conic orbit and 3 on the other, so no Wu
conic contains an all-passant six-set. That negative result is not used in the Clebsch manuscript;
it only confirms how much weaker Wu's even-intersection property is than the Clebsch exterior-set
condition.

## Evidence boundary

- **Primary full text read:** Madison--Wu, arXiv:1104.0324v1; Wu (2013), from the complete text
  supplied in the session. The local file named `~/wu-hexagons-codes.pdf` is actually a Cloudflare
  “Security verification” HTML capture, not an article PDF, so no claim relies on that file.
- **Primary author copy read:** Sin--Wu--Xiang (2011), including its reconstruction of the four
  Droms--Mellinger--Meyer incidence submatrices and its proved secant--external dimension formula.
- **Primary abstract / bibliographic record checked:** Droms--Mellinger--Meyer (2006) and
  Madison--Wu (2016). The manuscript attributes only their stated construction/program at this
  evidence level; it does not borrow a theorem from an unread body.

Primary links:

- Droms--Mellinger--Meyer: <https://doi.org/10.1007/s10623-006-0022-6>
- Sin--Wu--Xiang: <https://arxiv.org/abs/0911.2018>
- Madison--Wu (2012): <https://arxiv.org/abs/1104.0324>
- Wu's two remaining Droms-dimension proofs: <https://arxiv.org/abs/1001.5077>
- Wu (2013): <https://doi.org/10.1016/j.laa.2013.04.004>
- Madison--Wu (2016): <https://doi.org/10.1007/s10623-014-0013-y>

## Manuscript change

The paragraph added to Section 2 makes three bounded claims:

1. the fixed-conic binary incidence lineage exists and begins with the four point--line
   submatrices;
2. the orbit-conic papers use entire internal or external point classes; and
3. the exact `[55,25]_2` and `[55,31]_2` examples are different code objects from the
   `[6,3,4]_{11}` Clebsch code.

No novelty claim was walked back. The repair closes a citation and reader-orientation omission.

The external-conic abstract supports only the construction, intersection study, row-space/code
dimension computation, and automorphism-group determination. Its body remains unread. A later
enumeration gives 275 all-external 12-point conics at `q=11`, but it is not yet safe to identify
that full family with Madison--Wu's code blocks, so no such parameter is asserted in the manuscript.
