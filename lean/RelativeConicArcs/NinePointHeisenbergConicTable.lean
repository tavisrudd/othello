import RelativeConicArcs.NinePointHeisenbergConicCensus

/-!
# Evaluation table for the 81 five-subset conics

This explicit list is an evaluation cache for the normalized conics constructed from all
five-subsets of the uncovered nine-arc.  The kernel checks that every constructed distinct conic
occurs in the table; therefore the table introduces no trusted classification assumption.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergConicTable

open NinePointHeisenbergConicCensus

/-- Explicit normalized coefficient vectors used for bounded downstream evaluation. -/
def conicTable : List QuadraticCoefficients :=
  [![0, 1, 4, 6, 0, 1],
   ![1, 0, 17, 0, 16, 13],
   ![1, 1, 0, 10, 2, 0],
   ![1, 1, 3, 8, 9, 10],
   ![1, 1, 6, 6, 16, 1],
   ![1, 1, 8, 11, 8, 14],
   ![1, 1, 8, 13, 8, 4],
   ![1, 1, 18, 17, 6, 3],
   ![1, 2, 4, 15, 3, 16],
   ![1, 2, 4, 15, 15, 0],
   ![1, 2, 7, 6, 0, 13],
   ![1, 2, 8, 17, 17, 11],
   ![1, 2, 11, 12, 3, 2],
   ![1, 2, 17, 2, 17, 14],
   ![1, 2, 17, 7, 10, 14],
   ![1, 3, 7, 12, 7, 14],
   ![1, 4, 2, 4, 4, 12],
   ![1, 5, 2, 7, 3, 6],
   ![1, 5, 14, 13, 2, 4],
   ![1, 6, 5, 3, 17, 15],
   ![1, 6, 13, 18, 4, 1],
   ![1, 7, 5, 10, 2, 2],
   ![1, 8, 8, 10, 2, 18],
   ![1, 8, 18, 8, 1, 0],
   ![1, 9, 10, 11, 18, 15],
   ![1, 9, 15, 5, 9, 4],
   ![1, 9, 15, 6, 0, 4],
   ![1, 9, 16, 11, 5, 10],
   ![1, 10, 5, 0, 18, 1],
   ![1, 10, 5, 11, 12, 13],
   ![1, 10, 7, 1, 1, 2],
   ![1, 10, 18, 0, 12, 6],
   ![1, 10, 18, 4, 12, 5],
   ![1, 11, 3, 5, 9, 0],
   ![1, 11, 3, 16, 3, 14],
   ![1, 11, 4, 9, 18, 11],
   ![1, 11, 8, 0, 16, 10],
   ![1, 11, 17, 10, 2, 9],
   ![1, 12, 8, 0, 12, 5],
   ![1, 12, 9, 11, 13, 16],
   ![1, 12, 10, 1, 17, 2],
   ![1, 12, 15, 1, 0, 6],
   ![1, 12, 15, 13, 1, 4],
   ![1, 13, 8, 4, 2, 12],
   ![1, 13, 10, 16, 13, 5],
   ![1, 13, 15, 2, 7, 13],
   ![1, 14, 2, 17, 6, 15],
   ![1, 14, 4, 4, 18, 13],
   ![1, 14, 5, 16, 0, 6],
   ![1, 14, 6, 8, 1, 17],
   ![1, 14, 7, 10, 2, 0],
   ![1, 14, 8, 7, 4, 0],
   ![1, 14, 11, 8, 11, 14],
   ![1, 14, 17, 11, 12, 1],
   ![1, 14, 18, 13, 13, 3],
   ![1, 14, 18, 13, 17, 4],
   ![1, 15, 1, 15, 13, 5],
   ![1, 15, 7, 13, 1, 6],
   ![1, 15, 8, 12, 1, 7],
   ![1, 15, 10, 4, 10, 15],
   ![1, 15, 17, 5, 9, 11],
   ![1, 16, 2, 13, 14, 4],
   ![1, 16, 3, 1, 0, 16],
   ![1, 16, 10, 10, 6, 17],
   ![1, 16, 13, 10, 2, 13],
   ![1, 16, 14, 0, 13, 2],
   ![1, 17, 8, 8, 9, 15],
   ![1, 17, 13, 17, 16, 16],
   ![1, 18, 1, 1, 5, 4],
   ![1, 18, 3, 7, 4, 11],
   ![1, 18, 12, 15, 14, 12],
   ![1, 18, 18, 10, 2, 5],
   ![0, 1, 8, 8, 13, 10],
   ![1, 0, 18, 14, 4, 15],
   ![1, 2, 0, 5, 9, 18],
   ![1, 3, 11, 11, 8, 17],
   ![1, 4, 5, 15, 3, 11],
   ![1, 5, 3, 6, 16, 15],
   ![1, 11, 5, 4, 4, 7],
   ![1, 11, 9, 18, 6, 12],
   ![1, 12, 12, 6, 16, 11]]

attribute [reducible] conicTable

/-- Every conic constructed from a five-subset occurs in the explicit evaluation table. -/
theorem conicTable_covers_distinctConics :
    distinctConics.all (fun coefficients =>
      conicTable.any (sameQuadraticCoefficients coefficients)) = true := by
  decide +kernel

/-- A Boolean predicate true on the evaluation table is true on every constructed distinct
conic. -/
theorem all_distinctConics_of_all_conicTable
    (predicate : QuadraticCoefficients → Bool)
    (tableCheck : conicTable.all predicate = true) :
    distinctConics.all predicate = true := by
  simp only [List.all_eq_true] at tableCheck ⊢
  intro coefficients coefficients_mem
  have covered :=
    (List.all_eq_true.mp conicTable_covers_distinctConics) coefficients coefficients_mem
  simp only [List.any_eq_true] at covered
  obtain ⟨tableCoefficients, table_mem, same⟩ := covered
  have equal : coefficients = tableCoefficients :=
    (sameQuadraticCoefficients_eq_true_iff coefficients tableCoefficients).mp same
  simpa [equal] using tableCheck tableCoefficients table_mem

/-- Three consecutive three-element checks combine to a nine-element prefix check. -/
theorem all_take_nine_of_three
    (list : List QuadraticCoefficients) (predicate : QuadraticCoefficients → Bool)
    (first : (list.take 3).all predicate = true)
    (second : ((list.drop 3).take 3).all predicate = true)
    (third : ((list.drop 6).take 3).all predicate = true) :
    (list.take 9).all predicate = true := by
  rw [show 9 = 3 + 6 by omega, List.take_add]
  rw [show 6 = 3 + 3 by omega, List.take_add]
  simpa using And.intro first (And.intro second third)

/-- Checks on a prefix and the complementary suffix combine to a check on the whole list. -/
theorem all_of_take_and_drop
    (list : List QuadraticCoefficients) (predicate : QuadraticCoefficients → Bool) (n : Nat)
    (takeCheck : (list.take n).all predicate = true)
    (dropCheck : (list.drop n).all predicate = true) :
    list.all predicate = true := by
  simp only [List.all_eq_true] at takeCheck dropCheck ⊢
  intro coefficients coefficients_mem
  rw [← List.take_append_drop n list, List.mem_append] at coefficients_mem
  exact coefficients_mem.elim (takeCheck coefficients) (dropCheck coefficients)

end NinePointHeisenbergConicTable
end RelativeConicArcs
