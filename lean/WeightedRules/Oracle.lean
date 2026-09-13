import WeightedRules.Reflection
import WeightedRules.IncrementalReflection
import WeightedRules.Support
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

`ergodis_support_solution P from "source.json"` requests a support certificate:
the values with a derivation rank and a rule witness per coordinate. The
kernel checks local fixedness and well-founded support in one pass over the
coordinates and one over the rules, without replaying the iteration, and the
result is a `SupportedSolution P` with the same leastness theorem. This is
the route whose checking cost does not grow with the producer's round count.

Resource policy. The producer runs with piped output that is read up to the
byte limit plus one byte, so an unbounded producer is cut off rather than
buffered; a producer still running at the deadline given by
`ERGODIS_RULE_ORACLE_TIMEOUT_MS` (default sixty seconds) is killed and the
elaboration fails. An explicit `via` executable must be a relative path with
no parent-directory segment, resolved against the working directory; the
environment override names any local program and is the user's choice. None
of this is proof-relevant: a soundness failure is impossible because the
kernel check is downstream of every step, and the policy only bounds the
resources a producer can consume during elaboration.

The executable is a user-selected local program. The supplied adapter calls the
existing Ergodis C ABI using `ERGODIS_RULE_LIBRARY`, then independently verifies
the returned certificate through that ABI. Lean proves the scalar equations of
`P`; correspondence with an external relational syntax is a separate obligation.
-/

namespace WeightedRules
open Lean Meta Elab Term

private def byteLimit : Nat := 1048576

private def checkIdentity (identity : List Nat) : Except String Unit := do
  if identity.length != 32 || identity.any (· ≥ 256) then
    throw "invalid source identity encoding"

private def decodeCertificate (payload : String) : Except String (Nat × List Nat) := do
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
  checkIdentity identity
  return (rounds, values)

private def decodeSupportCertificate (payload : String) :
    Except String (List Nat × List Nat × List Nat) := do
  let json ← Json.parse payload
  let schema ← json.getObjValAs? String "schema"
  if schema != "finite-min-plus-support-certificate.v1" then
    throw "unsupported certificate schema"
  let count ← json.getObjValAs? Nat "scalar_count"
  let values ← json.getObjValAs? (List Nat) "values"
  let ranks ← json.getObjValAs? (List Nat) "ranks"
  let witnesses ← json.getObjValAs? (List Nat) "witnesses"
  let identity ← json.getObjValAs? (List Nat) "source_id"
  if count > 4096 || values.length != count || ranks.length != count ||
      witnesses.length != count then
    throw "invalid certificate dimensions"
  if values.any (· ≥ 4294967296) then throw "cost outside bounded carrier"
  if ranks.any (· > count) || witnesses.any (· > 65536) then
    throw "rank or witness outside bounds"
  checkIdentity identity
  return (values, ranks, witnesses)

private def resolveExecutable (command : Option String) : TermElabM String := do
  match command with
  | some command =>
    let path := System.FilePath.mk command
    if path.isAbsolute || path.components.any (· == "..") then
      throwError "Ergodis oracle: explicit executable must be a relative path without parent segments"
    pure command
  | none => pure ((← IO.getEnv "ERGODIS_RULE_ORACLE").getD "WeightedRules/oracle")

private def timeoutMillis : IO Nat := do
  match (← IO.getEnv "ERGODIS_RULE_ORACLE_TIMEOUT_MS") with
  | some text => pure (text.trim.toNat?.getD 60000)
  | none => pure 60000

/-- Run the producer with bounded output and a deadline. Returns the exit code
and the captured bytes; a producer exceeding the byte limit or the deadline is
killed and reported. -/
private def runBounded (executable : String) (args : Array String) :
    IO (UInt32 × ByteArray × Bool) := do
  let child ← IO.Process.spawn
    { cmd := executable, args, stdout := .piped, stderr := .null, stdin := .null }
  let reader ← IO.asTask do
    let mut bytes := ByteArray.empty
    repeat
      let chunk ← child.stdout.read (byteLimit + 1 - bytes.size).toUSize
      if chunk.isEmpty then break
      bytes := bytes ++ chunk
      if bytes.size > byteLimit then break
    return bytes
  let deadline := (← IO.monoMsNow) + (← timeoutMillis)
  let mut timedOut := false
  repeat
    if (← IO.hasFinished reader) then break
    if (← IO.monoMsNow) > deadline then
      child.kill
      timedOut := true
      break
    IO.sleep 5
  let bytes ← IO.ofExcept (← IO.wait reader)
  if bytes.size > byteLimit then child.kill
  let exit ← child.wait
  return (exit, bytes, timedOut)

private def request (source : String) (mode : Array String) (command : Option String) :
    TermElabM String := do
  let executable ← resolveExecutable command
  let (exit, bytes, timedOut) ← runBounded executable (#[source] ++ mode)
  if timedOut then throwError "Ergodis oracle exceeded its deadline"
  if bytes.size > byteLimit then throwError "Ergodis certificate: certificate exceeds byte limit"
  if exit != 0 then throwError "Ergodis oracle failed (exit {exit})"
  match String.fromUTF8? bytes with
  | some text => pure text
  | none => throwError "Ergodis certificate: output is not UTF-8"

private def requestCertificate (source : String) (command : Option String) :
    TermElabM (Nat × List Nat) := do
  match decodeCertificate (← request source #[] command) with
  | .ok result => pure result
  | .error message => throwError "Ergodis certificate: {message}"

private def requestSupport (source : String) (command : Option String) :
    TermElabM (List Nat × List Nat × List Nat) := do
  match decodeSupportCertificate (← request source #["support"] command) with
  | .ok result => pure result
  | .error message => throwError "Ergodis certificate: {message}"

private def costLiterals (values : List Nat) : TermElabM (Array (TSyntax `term)) :=
  values.toArray.mapM fun value => do
    let numeral := Syntax.mkNumLit (toString value)
    `((⟨$numeral, by decide⟩ : WeightedRules.Cost))

private def natLiterals (values : List Nat) : Array (TSyntax `term) :=
  values.toArray.map fun value => Syntax.mkNumLit (toString value)

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

/-- Request a support certificate and check it in one pass by kernel reduction. -/
syntax "ergodis_support_solution " term " from " str (" via " str)? : term

elab_rules : term
  | `(ergodis_support_solution $program from $source:str $[via $command:str]?) => do
    let (values, ranks, witnesses) ←
      requestSupport source.getString (command.map TSyntax.getString)
    let costs ← costLiterals values
    let rankTerms := natLiterals ranks
    let witnessTerms := natLiterals witnesses
    let proof ← `(({ values := [$costs,*]
                     ranks := [$rankTerms,*]
                     witnesses := [$witnessTerms,*]
                     accepted := by decide +kernel } :
                       WeightedRules.SupportedSolution $program))
    elaborateCertificate proof "Ergodis support certificate failed kernel check"

end WeightedRules
