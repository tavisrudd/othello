import WeightedRules.Reflection
import WeightedRules.IncrementalReflection
import Lean

/-!
# External min-plus witnesses with kernel-checked proofs

`ergodis_solution P from "source.json"` invokes the executable selected by
`ERGODIS_RULE_ORACLE` (default `WeightedRules/oracle`) with the source filename.
That process returns a bounded min-plus JSON certificate. Only numeric literals
are inserted into the proof term; process output is never parsed as Lean code.
The elaborator checks the result against the independently supplied formal
program `P`, using `checkCertificate` and kernel reduction. The foreign process,
its parser and its source identity are not proof authorities.

`ergodis_improvement old to Q from "source.json" replay k` uses the same
provider's returned values but checks `k` steps from the old checked valuation.
It establishes leastness of `Q` only after checking unchanged rules and improved
facts. The provider's own round count describes its from-zero computation; the
explicit replay count describes the separate incremental proof.

The executable is a user-selected local program. The supplied adapter calls the
existing Ergodis C ABI using `ERGODIS_RULE_LIBRARY`, then independently verifies
the returned certificate through that ABI. Lean proves the scalar equations of
`P`; correspondence with an external relational syntax is a separate obligation.
-/

namespace WeightedRules
open Lean Meta Elab Term

private def decodeCertificate (payload : String) : Except String (Nat × List Nat) := do
  if payload.utf8ByteSize > 1048576 then throw "certificate exceeds byte limit"
  let json ← Json.parse payload
  let schema ← json.getObjValAs? String "schema"
  if schema != "finite-min-plus-certificate.v1" then throw "unsupported certificate schema"
  let count ← json.getObjValAs? Nat "scalar_count"
  let rounds ← json.getObjValAs? Nat "rounds"
  let values ← json.getObjValAs? (List Nat) "values"
  let identity ← json.getObjValAs? (List Nat) "source_id"
  if count > 4096 || values.length != count || rounds > count then
    throw "invalid certificate dimensions or round bound"
  if values.any (· ≥ 4294967296) then throw "cost outside bounded carrier"
  if identity.length != 32 || identity.any (· ≥ 256) then throw "invalid source identity encoding"
  return (rounds, values)

private def requestCertificate (source : String) (command : Option String) :
    TermElabM (Nat × List Nat) := do
    let executable ← match command with
      | some command => pure command
      | none => do pure ((← IO.getEnv "ERGODIS_RULE_ORACLE").getD "WeightedRules/oracle")
    let output ← IO.Process.output {
      cmd := executable
      args := #[source] }
    if output.exitCode != 0 then
      throwError "Ergodis oracle failed (exit {output.exitCode})"
    match decodeCertificate output.stdout with
      | .ok result => pure result
      | .error message => throwError "Ergodis certificate: {message}"

private def costLiterals (values : List Nat) : TermElabM (Array (TSyntax `term)) :=
  values.toArray.mapM fun value => do
    let numeral := Syntax.mkNumLit (toString value)
    `((⟨$numeral, by decide⟩ : WeightedRules.Cost))

private def elaborateCertificate (proof : Syntax) (failure : String) : TermElabM Expr := do
  try
    withoutErrToSorry do
      let result ← elabTerm proof none
      synthesizeSyntheticMVarsNoPostponing
      let result ← instantiateMVars result
      if result.hasSorry then throwError "Ergodis certificate did not produce a proof"
      return result
  catch _ => throwError "{failure}"

/-- Request an external witness for the formal program and construct a checked solution. -/
syntax "ergodis_solution " term " from " str (" via " str)? : term

elab_rules : term
  | `(ergodis_solution $program from $source:str $[via $command:str]?) => do
    let (rounds, values) ← requestCertificate source.getString (command.map TSyntax.getString)
    let roundTerm := Syntax.mkNumLit (toString rounds)
    let costs ← costLiterals values
    let proof ← `(({ rounds := $roundTerm
                     values := [$costs,*]
                     accepted := by decide } : WeightedRules.CheckedSolution $program))
    elaborateCertificate proof "Ergodis certificate failed kernel replay"

/-- Request new witness values and check them by bounded replay from the supplied
old checked solution, admitting only unchanged rules and improved facts. -/
syntax "ergodis_improvement " term " to " term " from " str " replay " num
  (" via " str)? : term

elab_rules : term
  | `(ergodis_improvement $old to $program from $source:str replay $rounds:num
      $[via $command:str]?) => do
    let (_, values) ← requestCertificate source.getString (command.map TSyntax.getString)
    let costs ← costLiterals values
    let proof ← `(({ rounds := $rounds
                     values := [$costs,*]
                     accepted := by decide } : WeightedRules.CheckedImprovement $old $program))
    elaborateCertificate proof "Ergodis incremental certificate failed kernel replay"

end WeightedRules
