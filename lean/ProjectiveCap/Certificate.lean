import ProjectiveCap.Almost.OddEscape
import Mathlib.Data.ZMod.Basic

/-!
# Projective residual-grid certificate scaffold

This file connects the native Route-C certificate shape to the formal residual
grid game.  It is intentionally statement-level: it does not parse `.cert`
files yet, but it names the Lean objects and validity obligations that a parser
or generated Lean file must produce.
-/

namespace ProjectiveCap
namespace Certificate

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

/--
One `CLASS` record from the native certificate emitter, after parsing cells into
`GridPoint K`.

The native file stores more audit metadata (`escape`, `onconic`, node/row
counts).  The proof-relevant payload is the size-three representative, one
witness move, and a reply-book DAG for the child.
-/
structure GridClassCert (K : Type*) [Field K] [Fintype K] [DecidableEq K] where
  classIndex : Nat
  sizeThree : Finset (GridPoint K)
  witness : GridPoint K
  book : FiniteBuildGame.ReplyBookDAG (GridPoint K)

namespace GridClassCert

/--
Rules-only validity of one parsed class certificate.

This is the Lean analogue of the native `certcheck` contract for a `book ok`
class: the witness is a legal child of the size-three position, the book root
is exactly that child, and the book is a valid responder DAG for the residual
grid game.
-/
def Valid (c : GridClassCert K) : Prop :=
  c.sizeThree.card = 3 ∧
    GridCap (K := K) c.sizeThree ∧
      c.witness ∈ GridGame.LegalExtensions (K := K) c.sizeThree ∧
        c.book.root = insert c.witness c.sizeThree ∧
          c.book.ValidFor (GridCap (K := K))

/-- The witness child of a valid class certificate is a residual-grid P-position. -/
theorem isP_witness {c : GridClassCert K} (hc : c.Valid) :
    GridGame.IsP (K := K) (insert c.witness c.sizeThree) := by
  rcases hc with ⟨_hcard, _hcap, _hlegal, hroot, hbook⟩
  change FiniteBuildGame.IsP (GridCap (K := K)) (insert c.witness c.sizeThree)
  rw [← hroot]
  exact c.book.isP_root hbook

/-- A valid class certificate gives the escape witness required at its `S3`. -/
theorem escape_at_sizeThree {c : GridClassCert K} (hc : c.Valid) :
    ∃ p : GridPoint K,
      p ∈ GridGame.LegalExtensions (K := K) c.sizeThree ∧
        GridGame.IsP (K := K) (insert p c.sizeThree) := by
  exact ⟨c.witness, hc.2.2.1, isP_witness (K := K) hc⟩

end GridClassCert

/--
Statement-level assembly of per-class books into an odd-escape certificate.

The native files are per canonical class.  Until the parser/canonical-class
bridge is formalized, this scaffold represents that assembly as a selector:
for every legal size-three position, choose the class certificate representing
it.  The `represents` field is the place where the future projective/canonical
orbit proof belongs.
-/
structure GridOddEscapeBookCertificate (K : Type*) [Field K] [Fintype K] [DecidableEq K] where
  classCert :
    ∀ S : Finset (GridPoint K), S.card = 3 -> GridCap (K := K) S -> GridClassCert K
  represents :
    ∀ S hcard hcap, (classCert S hcard hcap).sizeThree = S
  valid :
    ∀ S hcard hcap, (classCert S hcard hcap).Valid

namespace GridOddEscapeBookCertificate

/-- A full assembled book certificate proves the residual odd-escape game target. -/
theorem oddEscapeGameStatement (cert : GridOddEscapeBookCertificate K) :
    Almost.OddEscapeGameStatement (K := K) := by
  intro S hcard hcap
  let c := cert.classCert S hcard hcap
  have hc : c.Valid := cert.valid S hcard hcap
  have hrep : c.sizeThree = S := cert.represents S hcard hcap
  refine ⟨c.witness, ?_, ?_⟩
  · have hlegal : c.witness ∈ GridGame.LegalExtensions (K := K) c.sizeThree := hc.2.2.1
    simpa [hrep] using hlegal
  · have hP : GridGame.IsP (K := K) (insert c.witness c.sizeThree) :=
      GridClassCert.isP_witness (K := K) hc
    simpa [hrep] using hP

end GridOddEscapeBookCertificate

/-- Prime-field spelling of the assembled certificate target. -/
abbrev PrimeGridOddEscapeBookCertificate (p : ℕ) [Fact p.Prime] :=
  GridOddEscapeBookCertificate (ZMod p)

/--
Route-C checker theorem for prime fields: a parsed and validated per-class book
certificate proves the `Almost` odd-escape target for `ZMod p`.

The current native certificate format also supports `GF(9)`, but this scaffold
deliberately skips non-prime fields; those need a parsed finite-field model and
an equivalence to the solver's polynomial representation.
-/
theorem almostOddEscapeGameStatement_zmod_of_certificate (p : ℕ) [Fact p.Prime]
    (cert : PrimeGridOddEscapeBookCertificate p) :
    Almost.OddEscapeGameStatement (K := ZMod p) :=
  cert.oddEscapeGameStatement

instance fact_natPrime_five : Fact (Nat.Prime 5) :=
  ⟨by decide⟩

/--
q=5 specialization shape.  The emitted q=5 book has one class and a terminal
root node; once the parser produces the assembled certificate object, this
theorem is the end-to-end Lean statement it discharges.
-/
theorem almostOddEscapeGameStatement_zmod5_of_certificate
    (cert : PrimeGridOddEscapeBookCertificate 5) :
    Almost.OddEscapeGameStatement (K := ZMod 5) :=
  almostOddEscapeGameStatement_zmod_of_certificate 5 cert

end Certificate
end ProjectiveCap
