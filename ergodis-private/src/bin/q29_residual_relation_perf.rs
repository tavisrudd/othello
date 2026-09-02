use ergodis_private::{
    cyclic_residual_relation_evolve::{
        evolve_q29_mod18_level_relation, prove_q29_mod18_level_relation,
        replay_q29_mod18_level_proof,
    },
    q29_exact_anneal::retained_mod18_seed_17737406,
};

fn main() {
    let iterations = std::env::args()
        .nth(1)
        .and_then(|value| value.parse::<u64>().ok())
        .unwrap_or(100);
    assert!(iterations != 0);
    let rows = retained_mod18_seed_17737406();
    let mut checksum = 0_u64;
    let mut final_proof = None;
    for blindness_level in 0..iterations {
        let hypothesis = evolve_q29_mod18_level_relation(&rows, blindness_level as u8)
            .expect("blind unit-orbit relation");
        let proof = prove_q29_mod18_level_relation(&rows, hypothesis)
            .expect("independent structural promotion");
        replay_q29_mod18_level_proof(&rows, &proof).expect("sealed source replay");
        checksum = checksum
            .wrapping_add(u64::from(proof.prime_fields_tested))
            .wrapping_add(proof.level);
        final_proof = Some(proof);
    }
    let proof = final_proof.expect("nonzero iteration count");
    println!("iterations={iterations}");
    println!("prime_fields_per_iteration={}", proof.prime_fields_tested);
    println!("coefficients={:?}", proof.coefficients);
    println!("level={}", proof.level);
    println!("exact_score_y={}", proof.exact_score_y);
    println!("checksum={checksum}");
    println!("provenance=ObservedEvolved unit-action orbit over anonymous residual coordinates; independently promoted by canonical PAF extraction and global PAF-sum identity; source-bound replay; no finite observation alone has authority");
}
