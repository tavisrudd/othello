/-!
# Four points of the conic plane, read through the Gram matrix of their normalized traces

An internal point of a nonsingular conic in `PG(2,13)` lifts to a trace-zero two-by-two matrix over
`ZMod 13` whose determinant is a nonsquare, uniquely up to sign once that determinant is scaled to a
fixed nonsquare `nu`.  For two internal points `P` and `R` with such lifts `A` and `B`, the residue

  `g = tr(A * B) / nu`

is defined up to a sign at each point, and its square is the elliptic invariant
`4 B(P,R)^2 / (Delta(P) Delta(R))` of the conic's polar form `B` with `Delta(P) = B(P,P)`.  The
square takes the value `9`, `10` or `12` exactly when the line through `P` and `R` misses the conic,
so a passant-joined pair has `g` in `{3, 5, 6, 7, 8, 10}`, the six residues whose squares are those
three values.  Flipping the sign of one point's lift flips the two traces at that point, so a triple
of internal points determines four trace patterns and not one.

Trace-zero matrices form a three-dimensional quadratic space under the determinant.  Two consequences
organize this module.  The Gram matrix of a family of internal points in normalized traces has
diagonal `2` and off-diagonal `-g`, so three internal points are collinear exactly when
`tripleGram`, which is `4 det G / (Delta_1 Delta_2 Delta_3)` for the coordinate Gram matrix `G`,
vanishes; and four internal points are four vectors in a three-dimensional space, so their
four-by-four Gram determinant vanishes for every quadruple.

Two further facts about a triple of internal points in general position are the hypotheses the
theorem consumes, and both are structural.  First, the span of three independent lifts is the whole
three-dimensional space, so the form it carries is isometric to the ambient one; over a finite field
a nondegenerate ternary form is determined by its discriminant, and the resulting condition is that
`tripleGram` is a nonsquare.  Second, for a secant chord `L` of the conic and a nonsquare `nu`, the
twelve points of the conic `C - nu L^2` off the chord are internal, and they are the support of a
minimum-weight word of the conic's binary passant code exactly when no tangent of `C - nu L^2` is a
passant of `C`.  A triple lies on such a conic exactly when one of its four trace patterns satisfies
`bitangentWitness`, and then some minimum-weight word has all three points in its support.

`admissible_trace_quadruple_has_vanishing_triple_grams` states that six normalized traces whose four
triples each are collinear or pass both of those tests, and whose four-by-four Gram determinant
vanishes, have all four three-by-three Gram determinants vanishing as well.

Residues are carried as natural numbers below `13` and combined by `add13`, `mul13`, `sub13` and
`neg13`.  The search is exhaustive over the six values each of the six traces can take, and is
discharged by kernel reduction, one declaration for each value of the first trace.
-/

namespace PassantCodeQ13.MinimumWords.RowUniqueness

/-- Sum of two residues modulo thirteen. -/
def add13 (first second : Nat) : Nat := (first + second) % 13

/-- Product of two residues modulo thirteen. -/
def mul13 (first second : Nat) : Nat := first * second % 13

/-- Difference of two residues modulo thirteen. -/
def sub13 (first second : Nat) : Nat := (first + 13 - second % 13) % 13

/-- Negation of a residue modulo thirteen. -/
def neg13 (value : Nat) : Nat := (13 - value % 13) % 13

/-- The nonsquare residues modulo thirteen. -/
def nonsquares : List Nat := [2, 5, 6, 7, 8, 11]

/-- Is a residue a nonsquare modulo thirteen? -/
def isNonsquare (value : Nat) : Bool := nonsquares.contains value

/-- The normalized traces available to a passant-joined pair of internal points: the residues whose
squares modulo thirteen are `9`, `10` or `12`. -/
def joinTraces : List Nat := [3, 5, 6, 7, 8, 10]

/-- The normalized Gram determinant of a triple of internal points, written in the three normalized
traces of its pairs.  It vanishes exactly when the three points are collinear, and is a nonsquare
otherwise. -/
def tripleGram (first second third : Nat) : Nat :=
  (30 - (first * first + second * second + third * third + first * second * third) % 13) % 13

/-- The discriminant of the chord of the bitangent conic through the three points named by a trace
pattern, normalized by `tripleGram` and by the first point's `Delta`. -/
def chordDiscriminant (first second third : Nat) : Nat :=
  let squares := add13 (add13 (mul13 first first) (mul13 second second)) (mul13 third third)
  let linear := add13 (add13 first second) third
  let pairs := add13 (add13 (mul13 first second) (mul13 first third)) (mul13 second third)
  add13 (add13 (sub13 3 (mul13 10 squares)) linear) (mul13 7 pairs)

/-- Does this trace pattern name a bitangent conic through the triple that is the support of a
minimum-weight word?  The first condition says the chord is a secant of the conic, the second that
no tangent of the bitangent conic is a passant. -/
def bitangentWitness (first second third : Nat) : Bool :=
  let gram := tripleGram first second third
  let chord := chordDiscriminant first second third
  !(gram == 0) && isNonsquare (mul13 chord gram) &&
    isNonsquare (mul13 (sub13 (mul13 4 chord) gram) gram)

/-- The four trace patterns of one triple of internal points: flipping the sign of a point's lift
flips the two traces at that point. -/
def signVariants (first second third : Nat) : List (Nat × Nat × Nat) :=
  [(first, second, third), (neg13 first, neg13 second, third),
    (neg13 first, second, neg13 third), (first, neg13 second, neg13 third)]

/-- The condition a triple of internal points with zero triple concurrence satisfies: it is
collinear, or its Gram determinant is a nonsquare and no bitangent conic through it is the support
of a minimum-weight word. -/
def tripleAdmissible (first second third : Nat) : Bool :=
  tripleGram first second third == 0 ||
    (isNonsquare (tripleGram first second third) &&
      (signVariants first second third).all fun pattern =>
        !bitangentWitness pattern.1 pattern.2.1 pattern.2.2)

/-- Determinant of the three-by-three matrix with the displayed entries, read row by row. -/
def minorDet (a b c d e f g h i : Nat) : Nat :=
  sub13 (add13 (mul13 a (sub13 (mul13 e i) (mul13 f h)))
               (mul13 c (sub13 (mul13 d h) (mul13 e g))))
        (mul13 b (sub13 (mul13 d i) (mul13 f g)))

/-- Determinant of the Gram matrix of four internal points, with diagonal `2` and the negated
normalized traces off the diagonal.  The arguments are the traces of the pairs
`(0,1), (0,2), (0,3), (1,2), (1,3), (2,3)` in that order. -/
def gramDet4 (p q r s t u : Nat) : Nat :=
  add13
    (add13 (mul13 2 (minorDet 2 (neg13 s) (neg13 t) (neg13 s) 2 (neg13 u) (neg13 t) (neg13 u) 2))
           (mul13 p (minorDet (neg13 p) (neg13 s) (neg13 t) (neg13 q) 2 (neg13 u)
             (neg13 r) (neg13 u) 2)))
    (add13 (mul13 (neg13 q) (minorDet (neg13 p) 2 (neg13 t) (neg13 q) (neg13 s) (neg13 u)
             (neg13 r) (neg13 t) 2))
           (mul13 r (minorDet (neg13 p) 2 (neg13 s) (neg13 q) (neg13 s) 2
             (neg13 r) (neg13 t) (neg13 u))))

/-- The exhaustive search at one value of the trace of the pair `(0,1)`: over the five remaining
traces, a quadruple whose four triples are admissible and whose Gram determinant vanishes has all
four triple Gram determinants zero. -/
def quadrupleCheckAt (p : Nat) : Bool :=
  joinTraces.all fun q => joinTraces.all fun s =>
    !tripleAdmissible p q s ||
      joinTraces.all fun r => joinTraces.all fun t =>
        !tripleAdmissible p r t ||
          joinTraces.all fun u =>
            !(tripleAdmissible q r u && tripleAdmissible s t u) ||
              !(gramDet4 p q r s t u == 0) ||
                (tripleGram p q s == 0 && tripleGram p r t == 0 &&
                  tripleGram q r u == 0 && tripleGram s t u == 0)

private theorem quadruple_check_at_three : quadrupleCheckAt 3 = true := by decide +kernel

private theorem quadruple_check_at_five : quadrupleCheckAt 5 = true := by decide +kernel

private theorem quadruple_check_at_six : quadrupleCheckAt 6 = true := by decide +kernel

private theorem quadruple_check_at_seven : quadrupleCheckAt 7 = true := by decide +kernel

private theorem quadruple_check_at_eight : quadrupleCheckAt 8 = true := by decide +kernel

private theorem quadruple_check_at_ten : quadrupleCheckAt 10 = true := by decide +kernel

/-- The search succeeds at every normalized trace a passant-joined pair can have. -/
theorem quadrupleCheckAt_eq_true {p : Nat} (p_mem : p ∈ joinTraces) :
    quadrupleCheckAt p = true := by
  simp only [joinTraces, List.mem_cons, List.not_mem_nil, or_false] at p_mem
  rcases p_mem with rfl | rfl | rfl | rfl | rfl | rfl
  · exact quadruple_check_at_three
  · exact quadruple_check_at_five
  · exact quadruple_check_at_six
  · exact quadruple_check_at_seven
  · exact quadruple_check_at_eight
  · exact quadruple_check_at_ten

/-- Six normalized traces of a quadruple of internal points whose four triples are admissible, and
whose four-by-four Gram determinant vanishes, have all four triple Gram determinants zero.  Read
geometrically, each of the four triples of points is collinear, so the four points lie on one
line. -/
theorem admissible_trace_quadruple_has_vanishing_triple_grams {p q r s t u : Nat}
    (p_mem : p ∈ joinTraces) (q_mem : q ∈ joinTraces) (r_mem : r ∈ joinTraces)
    (s_mem : s ∈ joinTraces) (t_mem : t ∈ joinTraces) (u_mem : u ∈ joinTraces)
    (admissible_first : tripleAdmissible p q s = true)
    (admissible_second : tripleAdmissible p r t = true)
    (admissible_third : tripleAdmissible q r u = true)
    (admissible_fourth : tripleAdmissible s t u = true)
    (gram : gramDet4 p q r s t u = 0) :
    tripleGram p q s = 0 ∧ tripleGram p r t = 0 ∧
      tripleGram q r u = 0 ∧ tripleGram s t u = 0 := by
  have check := quadrupleCheckAt_eq_true p_mem
  rw [quadrupleCheckAt] at check
  have outer := (List.all_eq_true.mp check) q q_mem
  have seed := (List.all_eq_true.mp outer) s s_mem
  rw [admissible_first] at seed
  simp only [Bool.not_true, Bool.false_or] at seed
  have branch := (List.all_eq_true.mp seed) r r_mem
  have extend := (List.all_eq_true.mp branch) t t_mem
  rw [admissible_second] at extend
  simp only [Bool.not_true, Bool.false_or] at extend
  have leaf := (List.all_eq_true.mp extend) u u_mem
  have gram_bit : (gramDet4 p q r s t u == 0) = true := by simp [gram]
  rw [admissible_third, admissible_fourth, gram_bit] at leaf
  simp only [Bool.and_self, Bool.not_true, Bool.false_or] at leaf
  simp only [Bool.and_eq_true, beq_iff_eq] at leaf
  exact ⟨leaf.1.1.1, leaf.1.1.2, leaf.1.2, leaf.2⟩

end PassantCodeQ13.MinimumWords.RowUniqueness
