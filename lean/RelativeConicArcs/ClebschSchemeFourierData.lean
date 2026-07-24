/-
Generated source -- do not edit by hand.
-/

import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Matrix.Basic

/-!
# Frozen integer Fourier tables

These tables are reconstructed from the reduced projective icosahedral action on
`F_11^3`. The tracked generator
`lean/verification/clebsch_scheme_fourier/generate.py` reads the pinned exhaustive orbit
construction `lean/verification/clebsch_scheme_fourier/orbit_construction.py`, checks its
SHA-256 digest, cross-checks the result against
`lean/verification/clebsch_scheme_fourier/scheme_certificate.json`, reproduced by
`lean/verification/clebsch_scheme_fourier/check_scheme_certificate.py`, and emits canonical
schema `clebsch-scheme-fourier-lean-v1` data in `lean/verification/clebsch_scheme_fourier/data.json`.

The geometric interpretation of the frozen relations, eigenmatrices, and incidence
counts is an external exact-enumeration boundary. The companion Lean development checks
the abstract character identity and literal table consequences, including matrix
products, equality of the frozen matrices, and all recorded nonclosure witnesses; it
does not construct an association scheme or prove that the tables describe the stated
group action.

Semantic content:
* `firstEigenmatrix`, `secondEigenmatrix` : frozen candidate `8 x 8` eigenmatrices `P`
  and `Q`, in the fixed relation ordering
  `0, column_D5, triple_S3, deep_hole_C5, double_V4, single_secant_C2_1..3`;
* `valencies` : frozen candidate relation valencies;
* `hyperplaneLineCounts` : entry `(i, j)` is the number of projective lines of relation
  `j` orthogonal to a representative character of relation `i`; row `0` is the number of
  projective lines in each relation;
* `inverseModEleven` : multiplicative inverses in `F_11`, used by the projective
  normalization;
* `lineRelationClassifier` : each of the `133` projective lines of `PG(2,11)`, given by
  its leading-coefficient-one representative, paired with the index of the relation
  containing it;
* `primitivityWitnesses` : for each of the `126` proper nonempty unions of the seven
  nonidentity relations (indexed by a seven-bit mask and the explicit relation list),
  a pair of scheme vectors lying in the union whose sum is nonzero and lies outside it.
-/

namespace RelativeConicArcs
namespace ClebschSchemeFourier

/-- A vector of the ambient translation module `F_11^3`. -/
abbrev SchemeVector : Type := ZMod 11 × ZMod 11 × ZMod 11

/-- The number of rows and columns in the frozen candidate eigenmatrices. -/
def schemeRank : Nat := 8

/-- The cardinality `11^3` used to normalize the frozen matrix product. -/
def schemeOrder : ℤ := 1331

/-- Frozen candidate first eigenmatrix `P`, with the ordering documented above. -/
def firstEigenmatrix : List (List ℤ) :=
  [[1, 60, 100, 120, 150, 300, 300, 300],
    [1, -6, -10, 10, 40, -30, 25, -30],
    [1, -6, -10, -12, 18, 36, -30, 3],
    [1, 5, -10, -1, -15, 25, 25, -30],
    [1, 16, 12, -12, 7, -8, -8, -8],
    [1, -6, 12, 10, -4, 3, -8, -8],
    [1, 5, -10, 10, -4, -8, -8, 14],
    [1, -6, 1, -12, -4, -8, 14, 14]]

/-- Frozen candidate second eigenmatrix `Q`, independently reconstructed as `1331 * P⁻¹`. -/
def secondEigenmatrix : List (List ℤ) :=
  [[1, 60, 100, 120, 150, 300, 300, 300],
    [1, -6, -10, 10, 40, -30, 25, -30],
    [1, -6, -10, -12, 18, 36, -30, 3],
    [1, 5, -10, -1, -15, 25, 25, -30],
    [1, 16, 12, -12, 7, -8, -8, -8],
    [1, -6, 12, 10, -4, 3, -8, -8],
    [1, 5, -10, 10, -4, -8, -8, 14],
    [1, -6, 1, -12, -4, -8, 14, 14]]

/-- Relation valencies in the fixed ordering. -/
def valencies : List ℤ := [1, 60, 100, 120, 150, 300, 300, 300]

/-- Projective-line orthogonality counts `z(i, j)` entering the character-sum eigenvalue
`11 * z(i, j) - ℓ(j)`, where `ℓ(j)` is row `0`. -/
def hyperplaneLineCounts : List (List ℤ) :=
  [[1, 6, 10, 12, 15, 30, 30, 30],
    [1, 0, 0, 2, 5, 0, 5, 0],
    [1, 0, 0, 0, 3, 6, 0, 3],
    [1, 1, 0, 1, 0, 5, 5, 0],
    [1, 2, 2, 0, 2, 2, 2, 2],
    [1, 0, 2, 2, 1, 3, 2, 2],
    [1, 1, 0, 2, 1, 2, 2, 4],
    [1, 0, 1, 0, 1, 2, 4, 4]]

/-- Multiplicative inverse table for `F_11` (`inverseModEleven[k] = k⁻¹`, with slot `0`
unused). Consumed by the projective normalization in the companion development. -/
def inverseModEleven : List (ZMod 11) := [0, 1, 6, 4, 3, 9, 2, 8, 7, 5, 10]

/-- Each projective line of `PG(2,11)` (leading-coefficient-one representative) paired
with the index of the relation containing it. -/
def lineRelationClassifier : List (SchemeVector × Fin 8) :=
  [((0, 0, 1), 4),
    ((0, 1, 0), 4),
    ((0, 1, 1), 5),
    ((0, 1, 2), 2),
    ((0, 1, 3), 6),
    ((0, 1, 4), 1),
    ((0, 1, 5), 7),
    ((0, 1, 6), 7),
    ((0, 1, 7), 1),
    ((0, 1, 8), 6),
    ((0, 1, 9), 2),
    ((0, 1, 10), 5),
    ((1, 0, 0), 4),
    ((1, 0, 1), 5),
    ((1, 0, 2), 7),
    ((1, 0, 3), 1),
    ((1, 0, 4), 6),
    ((1, 0, 5), 2),
    ((1, 0, 6), 2),
    ((1, 0, 7), 6),
    ((1, 0, 8), 1),
    ((1, 0, 9), 7),
    ((1, 0, 10), 5),
    ((1, 1, 0), 5),
    ((1, 1, 1), 2),
    ((1, 1, 2), 5),
    ((1, 1, 3), 3),
    ((1, 1, 4), 6),
    ((1, 1, 5), 7),
    ((1, 1, 6), 7),
    ((1, 1, 7), 6),
    ((1, 1, 8), 3),
    ((1, 1, 9), 5),
    ((1, 1, 10), 2),
    ((1, 2, 0), 2),
    ((1, 2, 1), 5),
    ((1, 2, 2), 7),
    ((1, 2, 3), 7),
    ((1, 2, 4), 6),
    ((1, 2, 5), 6),
    ((1, 2, 6), 6),
    ((1, 2, 7), 6),
    ((1, 2, 8), 7),
    ((1, 2, 9), 7),
    ((1, 2, 10), 5),
    ((1, 3, 0), 6),
    ((1, 3, 1), 3),
    ((1, 3, 2), 4),
    ((1, 3, 3), 6),
    ((1, 3, 4), 4),
    ((1, 3, 5), 6),
    ((1, 3, 6), 6),
    ((1, 3, 7), 4),
    ((1, 3, 8), 6),
    ((1, 3, 9), 4),
    ((1, 3, 10), 3),
    ((1, 4, 0), 1),
    ((1, 4, 1), 6),
    ((1, 4, 2), 5),
    ((1, 4, 3), 7),
    ((1, 4, 4), 3),
    ((1, 4, 5), 7),
    ((1, 4, 6), 7),
    ((1, 4, 7), 3),
    ((1, 4, 8), 7),
    ((1, 4, 9), 5),
    ((1, 4, 10), 6),
    ((1, 5, 0), 7),
    ((1, 5, 1), 7),
    ((1, 5, 2), 5),
    ((1, 5, 3), 5),
    ((1, 5, 4), 4),
    ((1, 5, 5), 5),
    ((1, 5, 6), 5),
    ((1, 5, 7), 4),
    ((1, 5, 8), 5),
    ((1, 5, 9), 5),
    ((1, 5, 10), 7),
    ((1, 6, 0), 7),
    ((1, 6, 1), 7),
    ((1, 6, 2), 5),
    ((1, 6, 3), 5),
    ((1, 6, 4), 4),
    ((1, 6, 5), 5),
    ((1, 6, 6), 5),
    ((1, 6, 7), 4),
    ((1, 6, 8), 5),
    ((1, 6, 9), 5),
    ((1, 6, 10), 7),
    ((1, 7, 0), 1),
    ((1, 7, 1), 6),
    ((1, 7, 2), 5),
    ((1, 7, 3), 7),
    ((1, 7, 4), 3),
    ((1, 7, 5), 7),
    ((1, 7, 6), 7),
    ((1, 7, 7), 3),
    ((1, 7, 8), 7),
    ((1, 7, 9), 5),
    ((1, 7, 10), 6),
    ((1, 8, 0), 6),
    ((1, 8, 1), 3),
    ((1, 8, 2), 4),
    ((1, 8, 3), 6),
    ((1, 8, 4), 4),
    ((1, 8, 5), 6),
    ((1, 8, 6), 6),
    ((1, 8, 7), 4),
    ((1, 8, 8), 6),
    ((1, 8, 9), 4),
    ((1, 8, 10), 3),
    ((1, 9, 0), 2),
    ((1, 9, 1), 5),
    ((1, 9, 2), 7),
    ((1, 9, 3), 7),
    ((1, 9, 4), 6),
    ((1, 9, 5), 6),
    ((1, 9, 6), 6),
    ((1, 9, 7), 6),
    ((1, 9, 8), 7),
    ((1, 9, 9), 7),
    ((1, 9, 10), 5),
    ((1, 10, 0), 5),
    ((1, 10, 1), 2),
    ((1, 10, 2), 5),
    ((1, 10, 3), 3),
    ((1, 10, 4), 6),
    ((1, 10, 5), 7),
    ((1, 10, 6), 7),
    ((1, 10, 7), 6),
    ((1, 10, 8), 3),
    ((1, 10, 9), 5),
    ((1, 10, 10), 2)]

/-- One additive-non-closure witness for each proper nonempty union of nonidentity
relations. Each entry is `(mask, relations, x, y)`: `mask` is the seven-bit code of the
chosen nonidentity relations, `relations` lists their indices, and `x, y` lie in the
union while `x + y` is nonzero and outside it. -/
def primitivityWitnesses : List (Nat × List (Fin 8) × SchemeVector × SchemeVector) :=
  [(1, [1], (0, 1, 4), (0, 1, 7)),
    (2, [2], (0, 1, 2), (0, 1, 9)),
    (3, [1, 2], (0, 1, 2), (0, 1, 4)),
    (4, [3], (1, 1, 3), (1, 1, 8)),
    (5, [1, 3], (0, 1, 4), (0, 1, 7)),
    (6, [2, 3], (0, 1, 2), (0, 1, 9)),
    (7, [1, 2, 3], (0, 1, 2), (0, 1, 4)),
    (8, [4], (0, 0, 1), (0, 1, 0)),
    (9, [1, 4], (0, 0, 1), (0, 1, 0)),
    (10, [2, 4], (0, 0, 1), (0, 1, 0)),
    (11, [1, 2, 4], (0, 0, 1), (0, 1, 0)),
    (12, [3, 4], (0, 0, 1), (0, 1, 0)),
    (13, [1, 3, 4], (0, 0, 1), (0, 1, 0)),
    (14, [2, 3, 4], (0, 0, 1), (0, 1, 0)),
    (15, [1, 2, 3, 4], (0, 0, 1), (0, 1, 0)),
    (16, [5], (0, 1, 1), (0, 1, 10)),
    (17, [1, 5], (0, 1, 1), (0, 1, 4)),
    (18, [2, 5], (0, 1, 1), (0, 1, 2)),
    (19, [1, 2, 5], (0, 1, 1), (0, 1, 4)),
    (20, [3, 5], (0, 1, 1), (0, 1, 10)),
    (21, [1, 3, 5], (0, 1, 1), (0, 1, 4)),
    (22, [2, 3, 5], (0, 1, 1), (0, 1, 2)),
    (23, [1, 2, 3, 5], (0, 1, 1), (0, 1, 4)),
    (24, [4, 5], (0, 0, 1), (0, 1, 1)),
    (25, [1, 4, 5], (0, 0, 1), (0, 1, 1)),
    (26, [2, 4, 5], (0, 0, 1), (0, 1, 2)),
    (27, [1, 2, 4, 5], (0, 0, 1), (0, 1, 2)),
    (28, [3, 4, 5], (0, 0, 1), (0, 1, 1)),
    (29, [1, 3, 4, 5], (0, 0, 1), (0, 1, 1)),
    (30, [2, 3, 4, 5], (0, 0, 1), (0, 1, 2)),
    (31, [1, 2, 3, 4, 5], (0, 0, 1), (0, 1, 2)),
    (32, [6], (0, 1, 3), (0, 1, 8)),
    (33, [1, 6], (0, 1, 3), (0, 1, 4)),
    (34, [2, 6], (0, 1, 2), (0, 1, 8)),
    (35, [1, 2, 6], (0, 1, 2), (0, 1, 7)),
    (36, [3, 6], (0, 1, 3), (0, 1, 8)),
    (37, [1, 3, 6], (0, 1, 3), (0, 1, 4)),
    (38, [2, 3, 6], (0, 1, 2), (0, 1, 8)),
    (39, [1, 2, 3, 6], (0, 1, 2), (0, 1, 7)),
    (40, [4, 6], (0, 0, 1), (0, 1, 0)),
    (41, [1, 4, 6], (0, 0, 1), (0, 1, 0)),
    (42, [2, 4, 6], (0, 0, 1), (0, 1, 0)),
    (43, [1, 2, 4, 6], (0, 0, 1), (0, 1, 0)),
    (44, [3, 4, 6], (0, 0, 1), (0, 1, 0)),
    (45, [1, 3, 4, 6], (0, 0, 1), (0, 1, 0)),
    (46, [2, 3, 4, 6], (0, 0, 1), (0, 1, 0)),
    (47, [1, 2, 3, 4, 6], (0, 0, 1), (0, 1, 0)),
    (48, [5, 6], (0, 1, 1), (0, 1, 3)),
    (49, [1, 5, 6], (0, 1, 1), (0, 1, 3)),
    (50, [2, 5, 6], (0, 1, 1), (0, 1, 2)),
    (51, [1, 2, 5, 6], (0, 1, 1), (0, 1, 9)),
    (52, [3, 5, 6], (0, 1, 1), (0, 1, 3)),
    (53, [1, 3, 5, 6], (0, 1, 1), (0, 1, 3)),
    (54, [2, 3, 5, 6], (0, 1, 1), (0, 1, 2)),
    (55, [1, 2, 3, 5, 6], (0, 1, 1), (0, 1, 9)),
    (56, [4, 5, 6], (0, 0, 1), (0, 1, 1)),
    (57, [1, 4, 5, 6], (0, 0, 1), (0, 1, 1)),
    (58, [2, 4, 5, 6], (0, 0, 1), (0, 1, 3)),
    (59, [1, 2, 4, 5, 6], (0, 0, 1), (0, 1, 4)),
    (60, [3, 4, 5, 6], (0, 0, 1), (0, 1, 1)),
    (61, [1, 3, 4, 5, 6], (0, 0, 1), (0, 1, 1)),
    (62, [2, 3, 4, 5, 6], (0, 0, 1), (0, 1, 3)),
    (63, [1, 2, 3, 4, 5, 6], (0, 0, 1), (0, 1, 4)),
    (64, [7], (0, 1, 5), (0, 1, 6)),
    (65, [1, 7], (0, 1, 4), (0, 1, 5)),
    (66, [2, 7], (0, 1, 2), (0, 1, 6)),
    (67, [1, 2, 7], (0, 1, 2), (0, 1, 4)),
    (68, [3, 7], (0, 1, 5), (0, 1, 6)),
    (69, [1, 3, 7], (0, 1, 4), (0, 1, 5)),
    (70, [2, 3, 7], (0, 1, 2), (0, 1, 6)),
    (71, [1, 2, 3, 7], (0, 1, 2), (0, 1, 4)),
    (72, [4, 7], (0, 0, 1), (0, 1, 0)),
    (73, [1, 4, 7], (0, 0, 1), (0, 1, 0)),
    (74, [2, 4, 7], (0, 0, 1), (0, 1, 0)),
    (75, [1, 2, 4, 7], (0, 0, 1), (0, 1, 0)),
    (76, [3, 4, 7], (0, 0, 1), (0, 1, 0)),
    (77, [1, 3, 4, 7], (0, 0, 1), (0, 1, 0)),
    (78, [2, 3, 4, 7], (0, 0, 1), (0, 1, 0)),
    (79, [1, 2, 3, 4, 7], (0, 0, 1), (0, 1, 0)),
    (80, [5, 7], (0, 1, 1), (0, 1, 5)),
    (81, [1, 5, 7], (0, 1, 1), (0, 1, 4)),
    (82, [2, 5, 7], (0, 1, 1), (0, 1, 2)),
    (83, [1, 2, 5, 7], (0, 1, 1), (0, 1, 4)),
    (84, [3, 5, 7], (0, 1, 1), (0, 1, 5)),
    (85, [1, 3, 5, 7], (0, 1, 1), (0, 1, 4)),
    (86, [2, 3, 5, 7], (0, 1, 1), (0, 1, 2)),
    (87, [1, 2, 3, 5, 7], (0, 1, 1), (0, 1, 4)),
    (88, [4, 5, 7], (0, 0, 1), (0, 1, 1)),
    (89, [1, 4, 5, 7], (0, 0, 1), (0, 1, 1)),
    (90, [2, 4, 5, 7], (0, 0, 1), (0, 1, 2)),
    (91, [1, 2, 4, 5, 7], (0, 0, 1), (0, 1, 2)),
    (92, [3, 4, 5, 7], (0, 0, 1), (0, 1, 1)),
    (93, [1, 3, 4, 5, 7], (0, 0, 1), (0, 1, 1)),
    (94, [2, 3, 4, 5, 7], (0, 0, 1), (0, 1, 2)),
    (95, [1, 2, 3, 4, 5, 7], (0, 0, 1), (0, 1, 2)),
    (96, [6, 7], (0, 1, 3), (0, 1, 5)),
    (97, [1, 6, 7], (0, 1, 3), (0, 1, 4)),
    (98, [2, 6, 7], (0, 1, 2), (0, 1, 6)),
    (99, [1, 2, 6, 7], (0, 1, 2), (0, 1, 7)),
    (100, [3, 6, 7], (0, 1, 3), (0, 1, 5)),
    (101, [1, 3, 6, 7], (0, 1, 3), (0, 1, 4)),
    (102, [2, 3, 6, 7], (0, 1, 2), (0, 1, 6)),
    (103, [1, 2, 3, 6, 7], (0, 1, 2), (0, 1, 7)),
    (104, [4, 6, 7], (0, 0, 1), (0, 1, 0)),
    (105, [1, 4, 6, 7], (0, 0, 1), (0, 1, 0)),
    (106, [2, 4, 6, 7], (0, 0, 1), (0, 1, 0)),
    (107, [1, 2, 4, 6, 7], (0, 0, 1), (0, 1, 0)),
    (108, [3, 4, 6, 7], (0, 0, 1), (0, 1, 0)),
    (109, [1, 3, 4, 6, 7], (0, 0, 1), (0, 1, 0)),
    (110, [2, 3, 4, 6, 7], (0, 0, 1), (0, 1, 0)),
    (111, [1, 2, 3, 4, 6, 7], (0, 0, 1), (0, 1, 0)),
    (112, [5, 6, 7], (0, 1, 1), (0, 1, 3)),
    (113, [1, 5, 6, 7], (0, 1, 1), (0, 1, 3)),
    (114, [2, 5, 6, 7], (0, 1, 1), (0, 1, 2)),
    (115, [1, 2, 5, 6, 7], (0, 1, 1), (0, 1, 10)),
    (116, [3, 5, 6, 7], (0, 1, 1), (0, 1, 3)),
    (117, [1, 3, 5, 6, 7], (0, 1, 1), (0, 1, 3)),
    (118, [2, 3, 5, 6, 7], (0, 1, 1), (0, 1, 2)),
    (119, [1, 2, 3, 5, 6, 7], (0, 1, 1), (0, 1, 10)),
    (120, [4, 5, 6, 7], (0, 0, 1), (0, 1, 1)),
    (121, [1, 4, 5, 6, 7], (0, 0, 1), (0, 1, 1)),
    (122, [2, 4, 5, 6, 7], (0, 0, 1), (0, 1, 3)),
    (123, [1, 2, 4, 5, 6, 7], (0, 0, 1), (1, 1, 2)),
    (124, [3, 4, 5, 6, 7], (0, 0, 1), (0, 1, 1)),
    (125, [1, 3, 4, 5, 6, 7], (0, 0, 1), (0, 1, 1)),
    (126, [2, 3, 4, 5, 6, 7], (0, 0, 1), (0, 1, 3))]

end ClebschSchemeFourier
end RelativeConicArcs
