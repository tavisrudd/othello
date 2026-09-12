import WeightedRules.Reflection
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

/-- Request an external witness for the formal program and construct a checked solution. -/
syntax "ergodis_solution " term " from " str (" via " str)? : term

elab_rules : term
  | `(ergodis_solution $program from $source:str $[via $command:str]?) => do
    let executable ← match command with
      | some command => pure command.getString
      | none => do pure ((← IO.getEnv "ERGODIS_RULE_ORACLE").getD "WeightedRules/oracle")
    let output ← IO.Process.output {
      cmd := executable
      args := #[source.getString] }
    if output.exitCode != 0 then
      throwError "Ergodis oracle failed (exit {output.exitCode})"
    let (rounds, values) ← match decodeCertificate output.stdout with
      | .ok result => pure result
      | .error message => throwError "Ergodis certificate: {message}"
    let roundTerm := Syntax.mkNumLit (toString rounds)
    let costs ← values.toArray.mapM fun value => do
      let numeral := Syntax.mkNumLit (toString value)
      `((⟨$numeral, by decide⟩ : WeightedRules.Cost))
    let proof ← `(({ rounds := $roundTerm
                     values := [$costs,*]
                     accepted := by decide } : WeightedRules.CheckedSolution $program))
    try
      withoutErrToSorry do
        let result ← elabTerm proof none
        synthesizeSyntheticMVarsNoPostponing
        let result ← instantiateMVars result
        if result.hasSorry then throwError "Ergodis certificate did not produce a proof"
        return result
    catch _ => throwError "Ergodis certificate failed kernel replay"

end WeightedRules
