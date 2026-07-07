import NodeKayles.Basic

/-!
# Small P-position certificates for Node-Kayles

The production solvers may eventually emit reply books.  This file gives the
basic kernel theorem such a book should satisfy: if every legal opponent move
has a certified reply to a P child, then the current position is P.
-/

namespace NodeKayles

variable {k : ℕ}

/-- The live set after playing `v` from `S`. -/
def child (G : Graph k) (S : Finset (Fin k)) (v : Fin k) : Finset (Fin k) :=
  S \ closedNbhd G v

/--
A one-ply P-certificate for a position: every move has a reply whose child is
already known to be P.
-/
def ReplyCertificate (G : Graph k) (S : Finset (Fin k)) : Prop :=
  ∀ v : S, ∃ w : child G S v, ¬ win G (child G (child G S v) w)

/-- A reply certificate proves that `S` is a P-position. -/
theorem not_win_of_replyCertificate {G : Graph k} {S : Finset (Fin k)}
    (hcert : ReplyCertificate G S) : ¬ win G S := by
  rw [win.eq_def]
  rintro ⟨v, hvlose⟩
  rcases hcert v with ⟨w, hwP⟩
  apply hvlose
  rw [win.eq_def]
  exact ⟨w, hwP⟩

/-- Board-level certificate for a first move: one P child proves the root is N. -/
theorem firstPlayerWins_of_move_to_not_win {G : Graph k} {v : Fin k}
    (hchild : ¬ win G (child G Finset.univ v)) : firstPlayerWins G := by
  rw [firstPlayerWins, win.eq_def]
  exact ⟨⟨v, Finset.mem_univ v⟩, hchild⟩

end NodeKayles
