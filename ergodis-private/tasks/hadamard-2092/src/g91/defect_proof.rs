use anyhow::Result;
use clap::Args as ClapArgs;
use ergodis_private::g91_defect_obstruction::{
    synthesize_g91_defect_proof, G91DefectBinding, G91DefectObservation,
};
use ergodis_private::proof_synthesis::ProvenanceClass;

#[derive(ClapArgs)]
pub struct Arguments {}

pub fn run(_arguments: Arguments) -> Result<()> {
    let proof = synthesize_g91_defect_proof(
        G91DefectBinding::registered(),
        G91DefectObservation {
            signed_energy: 1_976,
            defect_target: 34,
            solution_count: 0,
            provenance: ProvenanceClass::ObservedEvolved,
        },
    )?;
    serde_json::to_writer(std::io::stdout(), &proof)?;
    println!();
    Ok(())
}
