use anyhow::Result;
use clap::Args as ClapArgs;
use ergodis_private::g41_quotient_filter_proof::{
    synthesize_g41_quotient_filter_proof, G41QuotientFilterBinding, G41QuotientFilterObservation,
};
use ergodis_private::proof_synthesis::ProvenanceClass;

#[derive(ClapArgs)]
pub struct Arguments {}

pub fn run(_arguments: Arguments) -> Result<()> {
    let proof = synthesize_g41_quotient_filter_proof(
        G41QuotientFilterBinding::registered(),
        G41QuotientFilterObservation {
            individual_shift_hits: [1_536, 2_304, 2_304, 4_608],
            necessary_filter_survivors: 768,
            provenance: ProvenanceClass::ObservedEvolved,
        },
    )?;
    serde_json::to_writer(std::io::stdout(), &proof)?;
    println!();
    Ok(())
}
