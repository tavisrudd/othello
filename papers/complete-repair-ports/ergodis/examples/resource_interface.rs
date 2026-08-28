//! Exact two-resource interface compilation with concrete plan replay.

use ergodis::observational::{compile_observational, GeneratorSpec};
use ergodis::{
    present_witnessed_pareto_interface, CappedAdditiveMonoid, ParetoWitness, WitnessedParetoFront,
};

fn front(resources: &CappedAdditiveMonoid, plans: &[([u16; 2], u32)]) -> WitnessedParetoFront {
    WitnessedParetoFront::new(
        resources,
        plans.iter().map(|(cost, witness)| ParetoWitness {
            resource: resources.encode(cost).unwrap(),
            witness: *witness,
        }),
    )
    .unwrap()
}

fn main() {
    // Coordinates are helper count and cross-zone traffic, each capped at 3.
    let resources = CappedAdditiveMonoid::new([3, 3]).unwrap();
    let local_a = front(&resources, &[([1, 1], 100), ([2, 0], 101)]);
    // Same observable tradeoff, but a different concrete deployment plan.
    let local_b = front(&resources, &[([1, 1], 200), ([2, 0], 201)]);
    let replicated = front(&resources, &[([2, 2], 300)]);

    // The context "add a remote replica" maps either local implementation to
    // the replicated state. It cannot distinguish local_a from local_b.
    let interface = present_witnessed_pareto_interface(
        &resources,
        [3],
        [local_a, local_b, replicated],
        [GeneratorSpec {
            source_sort: 0,
            target_sort: 0,
            transitions: [2, 2, 2].into(),
        }],
    )
    .unwrap();
    let compiled = compile_observational(interface.presentation()).unwrap();
    let witnesses = interface.verified_witnesses(&compiled).unwrap();

    assert_eq!(compiled.state_classes()[0], compiled.state_classes()[1]);
    assert_ne!(compiled.state_classes()[0], compiled.state_classes()[2]);
    let local_class = compiled.state_classes()[0];
    let chosen = witnesses.class_front(local_class).unwrap().entries()[0];
    println!(
        "3 concrete states -> {} exact classes; representative plan {}",
        compiled.class_representatives().len(),
        chosen.witness
    );
}
