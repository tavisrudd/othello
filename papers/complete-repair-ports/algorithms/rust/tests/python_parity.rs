use ergo_comp::balanced::{
    BalancedCarrierCoefficients, BalancedTerminalRejection, BalancedTransversalCatalog,
    HighFiberSpec,
};
use ergo_comp::{
    compile_binary_rank_one, compile_binary_target_subspace, compile_integer_affine_constraints,
    compile_ternary_affine_constraints, confinement_by_generators, confinement_by_generators_field,
    confinement_by_syndrome, maximum_parallel_repairs, ternary_orbit_syndrome_search,
    CompositionTable, ConfinementSector, CostTable, GeneratedSpanTable, Gf4,
    IntegerAffineCompilation, Matrix, OrbitOption, TernaryAffineCompilation, WeightedRepairProblem,
};
use serde::Deserialize;

#[derive(Deserialize)]
struct Fixture {
    schema: String,
    balanced_terminal_cases: Vec<BalancedTerminalCase>,
    cases: Vec<Case>,
    compositions: Vec<CompositionCase>,
    confinements: Vec<ConfinementCase>,
    gf4_transfers: Vec<Gf4TransferCase>,
    gf4_target_subspaces: Vec<Gf4TargetSubspaceCase>,
    target_towers: Vec<TargetTowerCase>,
    orbits: Vec<OrbitCase>,
    weighted_schedulers: Vec<WeightedSchedulerCase>,
    unit_schedulers: Vec<UnitSchedulerCase>,
}

#[derive(Deserialize)]
struct TargetTowerCase {
    ordinary: Vec<u32>,
    target: Vec<u32>,
    ordinary_level_one: Vec<(u32, Vec<u8>)>,
    target_level_one: Vec<(u32, Vec<u8>)>,
    ordinary_level_two: Vec<(u32, Vec<u8>)>,
    target_level_two: Vec<(u32, Vec<u8>)>,
}

#[derive(Deserialize)]
struct Gf4TargetSubspaceCase {
    columns: Vec<u8>,
    targets: Vec<usize>,
    normalization: MatrixFixture,
    functional_basis: Vec<u8>,
    ordinary: Vec<MatrixCostFixture>,
    target_normalized: Vec<MatrixCostFixture>,
    target_union_cost: u32,
    inner_dual_distance: u32,
    zero_cost: u32,
    nonzero_cost: u32,
    gamma: u32,
    winning_labels: Vec<Vec<u8>>,
}

#[derive(Deserialize, PartialEq, Eq, Debug)]
struct MatrixCostFixture {
    label: Vec<u8>,
    cost: u32,
    coefficients: Vec<u8>,
}

#[derive(Deserialize)]
struct Gf4TransferCase {
    target_coordinate: usize,
    functional_basis: Vec<u8>,
    profiles: Vec<Gf4TransferProfile>,
}

#[derive(Deserialize)]
struct Gf4TransferProfile {
    columns: Vec<u8>,
    ordinary: Vec<Option<(u32, Vec<u8>)>>,
    target_normalized: Vec<Option<(u32, Vec<u8>)>>,
    inner_dual: (u32, Vec<u8>),
    k_p: MatrixFixture,
    d_p: MatrixFixture,
    zero_cost: u32,
    nonzero_cost: u32,
    gamma: u32,
    outer_coefficient: u8,
    block_labels: Vec<u8>,
}

#[derive(Deserialize)]
struct MatrixFixture {
    rows: usize,
    cols: usize,
    data: Vec<u8>,
}

#[derive(Deserialize)]
struct BalancedTerminalCase {
    trace: Vec<u8>,
    product: Vec<u8>,
    rows: Vec<u8>,
    columns: Vec<u8>,
    ratios: Vec<u8>,
    kappa: u8,
    high_values: Vec<u8>,
    cubic_values: Vec<u8>,
    expected_rejection: String,
}

#[derive(Deserialize)]
struct Case {
    p: u8,
    rows: usize,
    columns: usize,
    demand: usize,
    generator: Vec<u8>,
    targets: Vec<Target>,
}

#[derive(Deserialize)]
struct Target {
    data: Vec<u8>,
    cost: Option<u16>,
    support: Option<Vec<u32>>,
}

#[derive(Deserialize)]
struct CompositionCase {
    p: u8,
    inner_rows: usize,
    demand: usize,
    inner: Vec<CostFixture>,
    block_rows: usize,
    blocks: Vec<Vec<u8>>,
    outputs: Vec<CompositionOutput>,
}

#[derive(Deserialize)]
struct CostFixture {
    data: Vec<u8>,
    cost: u32,
}

#[derive(Deserialize)]
struct CompositionOutput {
    data: Vec<u8>,
    cost: u32,
    local_labels: Vec<Vec<u8>>,
}

#[derive(Deserialize)]
struct ConfinementCase {
    p: u8,
    label_rows: usize,
    demand: usize,
    block_count: usize,
    target_block: usize,
    inner_dual_distance: u32,
    inner: Vec<CostFixture>,
    target: Vec<CostFixture>,
    functional_rows: usize,
    functional_basis: Vec<u8>,
    syndrome_rows: usize,
    constraint_blocks: Vec<Vec<u8>>,
    expected: ConfinementExpected,
}

#[derive(Deserialize)]
struct ConfinementExpected {
    cost: u32,
    sector: String,
    functional_coefficients: Option<Vec<u8>>,
    generator_labels: Vec<Vec<u8>>,
    syndrome_labels: Vec<Vec<u8>>,
}

#[derive(Deserialize)]
struct OrbitCase {
    families: Vec<Vec<OrbitOptionFixture>>,
    target_residue: Vec<u8>,
    target_totals: Vec<i32>,
    expected: OrbitExpected,
}

#[derive(Deserialize)]
struct OrbitOptionFixture {
    label: u32,
    residue: Vec<u8>,
    totals: Vec<i32>,
}

#[derive(Deserialize)]
struct OrbitExpected {
    choices: Option<Vec<u32>>,
    states_examined: u64,
    bound_prunes: u64,
    residue_prunes: u64,
    memo_prunes: u64,
}

#[derive(Deserialize)]
struct WeightedSchedulerCase {
    capacities: Vec<u32>,
    families: Vec<Vec<Vec<u32>>>,
    expected: WeightedSchedulerExpected,
}

#[derive(Deserialize)]
struct WeightedSchedulerExpected {
    assignment: Vec<(u32, Vec<u32>)>,
    unmatched_demands: Vec<u32>,
    total_loads: Vec<u64>,
    transitions_examined: u64,
    peak_pareto_states: u32,
}

#[derive(Deserialize)]
struct UnitSchedulerCase {
    capacities: Vec<u32>,
    families: Vec<Vec<Vec<u32>>>,
    expected: UnitSchedulerExpected,
}

#[derive(Deserialize)]
struct UnitSchedulerExpected {
    assignment: Vec<(u32, Vec<u32>)>,
    unmatched_demands: Vec<u32>,
    states_examined: u64,
    capacity_cut: CapacityCutExpected,
}

#[derive(Deserialize)]
struct CapacityCutExpected {
    resources: Vec<u32>,
    forced_demands: Vec<u32>,
    capacity: u64,
    repair_upper_bound: u32,
}

fn check<const P: u8>(case: &Case) {
    let generator = Matrix::new::<P>(case.rows, case.columns, case.generator.clone()).unwrap();
    let table = GeneratedSpanTable::build::<P>(&generator).unwrap();
    for target in &case.targets {
        let matrix = Matrix::new::<P>(case.rows, case.demand, target.data.clone()).unwrap();
        let answer = table.query::<P>(&matrix).unwrap();
        assert_eq!(answer.as_ref().map(|value| value.cost), target.cost);
        if let (Some(answer), Some(expected)) = (answer, &target.support) {
            assert_eq!(&*answer.support, expected);
        }
    }
}

fn check_composition<const P: u8>(case: &CompositionCase) {
    let inner = CostTable::from_entries::<P>(
        case.inner_rows,
        case.demand,
        case.inner.iter().map(|entry| {
            (
                Matrix::new::<P>(case.inner_rows, case.demand, entry.data.clone()).unwrap(),
                entry.cost,
            )
        }),
    )
    .unwrap();
    let blocks: Vec<_> = case
        .blocks
        .iter()
        .map(|data| Matrix::new::<P>(case.block_rows, case.inner_rows, data.clone()).unwrap())
        .collect();
    let table = CompositionTable::compose::<P>(&blocks, &inner).unwrap();
    assert_eq!(table.len(), case.outputs.len());
    for expected in &case.outputs {
        let label = Matrix::new::<P>(case.block_rows, case.demand, expected.data.clone()).unwrap();
        let answer = table.answer::<P>(&label).unwrap().unwrap();
        assert_eq!(answer.cost, expected.cost);
        assert_eq!(answer.local_labels.len(), expected.local_labels.len());
        for (actual, expected) in answer.local_labels.iter().zip(&expected.local_labels) {
            assert_eq!(actual.as_slice(), expected);
        }
    }
}

fn table<const P: u8>(rows: usize, cols: usize, entries: &[CostFixture]) -> CostTable {
    CostTable::from_entries::<P>(
        rows,
        cols,
        entries.iter().map(|entry| {
            (
                Matrix::new::<P>(rows, cols, entry.data.clone()).unwrap(),
                entry.cost,
            )
        }),
    )
    .unwrap()
}

fn check_confinement<const P: u8>(case: &ConfinementCase) {
    let inner = table::<P>(case.label_rows, case.demand, &case.inner);
    let target = table::<P>(case.label_rows, case.demand, &case.target);
    let basis = Matrix::new::<P>(
        case.functional_rows,
        case.block_count * case.label_rows,
        case.functional_basis.clone(),
    )
    .unwrap();
    let constraints: Vec<_> = case
        .constraint_blocks
        .iter()
        .map(|data| Matrix::new::<P>(case.syndrome_rows, case.label_rows, data.clone()).unwrap())
        .collect();
    let generated = confinement_by_generators::<P>(
        &basis,
        case.block_count,
        &inner,
        &target,
        case.target_block,
        case.inner_dual_distance,
    )
    .unwrap();
    let syndrome = confinement_by_syndrome::<P>(
        &constraints,
        &inner,
        &target,
        case.target_block,
        case.inner_dual_distance,
    )
    .unwrap();
    let expected_sector = match case.expected.sector.as_str() {
        "zero" => ConfinementSector::Zero,
        "nonzero" => ConfinementSector::Nonzero,
        other => panic!("unknown sector {other}"),
    };
    assert_eq!(generated.cost, case.expected.cost);
    assert_eq!(syndrome.cost, case.expected.cost);
    assert_eq!(generated.sector, expected_sector);
    assert_eq!(syndrome.sector, expected_sector);
    assert_eq!(
        generated
            .functional_coefficients
            .as_ref()
            .map(|matrix| matrix.as_slice()),
        case.expected.functional_coefficients.as_deref(),
    );
    for (actual, expected) in generated
        .block_labels
        .iter()
        .zip(&case.expected.generator_labels)
    {
        assert_eq!(actual.as_slice(), expected);
    }
    for (actual, expected) in syndrome
        .block_labels
        .iter()
        .zip(&case.expected.syndrome_labels)
    {
        assert_eq!(actual.as_slice(), expected);
    }
}

fn check_orbit(case: &OrbitCase) {
    let families: Vec<_> = case
        .families
        .iter()
        .map(|family| {
            family
                .iter()
                .map(|option| OrbitOption {
                    label: option.label,
                    residue: option.residue.clone().into_boxed_slice(),
                    totals: option.totals.clone().into_boxed_slice(),
                })
                .collect()
        })
        .collect();
    let answer =
        ternary_orbit_syndrome_search(&families, &case.target_residue, &case.target_totals)
            .unwrap();
    assert_eq!(answer.choices.as_deref(), case.expected.choices.as_deref());
    assert_eq!(answer.states_examined, case.expected.states_examined);
    assert_eq!(answer.bound_prunes, case.expected.bound_prunes);
    assert_eq!(answer.residue_prunes, case.expected.residue_prunes);
    assert_eq!(answer.memo_prunes, case.expected.memo_prunes);

    match compile_ternary_affine_constraints(&families, &case.target_residue, &case.target_totals)
        .unwrap()
    {
        TernaryAffineCompilation::Feasible(compiled) => {
            let compressed = ternary_orbit_syndrome_search(
                &compiled.option_families,
                &compiled.target_residue,
                &compiled.target_totals,
            )
            .unwrap();
            assert_eq!(
                compressed.choices.as_deref(),
                case.expected.choices.as_deref()
            );
        }
        TernaryAffineCompilation::Infeasible(_) => assert!(case.expected.choices.is_none()),
    }
    match compile_integer_affine_constraints(&families, &case.target_residue, &case.target_totals)
        .unwrap()
    {
        IntegerAffineCompilation::Feasible(compiled) => {
            let compressed = ternary_orbit_syndrome_search(
                &compiled.option_families,
                &compiled.target_residue,
                &compiled.target_totals,
            )
            .unwrap();
            assert_eq!(
                compressed.choices.as_deref(),
                case.expected.choices.as_deref()
            );
        }
        IntegerAffineCompilation::Infeasible(_) => assert!(case.expected.choices.is_none()),
    }
}

fn check_weighted_scheduler(case: &WeightedSchedulerCase) {
    let answer = WeightedRepairProblem::from_families(&case.capacities, &case.families)
        .unwrap()
        .solve()
        .unwrap();
    let assignment: Vec<_> = answer
        .assignment
        .iter()
        .map(|choice| (choice.demand, choice.loads.to_vec()))
        .collect();
    assert_eq!(assignment, case.expected.assignment);
    assert_eq!(&*answer.unmatched_demands, &case.expected.unmatched_demands);
    assert_eq!(&*answer.total_loads, &case.expected.total_loads);
    assert_eq!(
        answer.transitions_examined,
        case.expected.transitions_examined
    );
    assert_eq!(answer.peak_pareto_states, case.expected.peak_pareto_states);
}

fn check_unit_scheduler(case: &UnitSchedulerCase) {
    let answer = maximum_parallel_repairs(&case.families, &case.capacities).unwrap();
    let assignment: Vec<_> = answer
        .assignment
        .iter()
        .map(|choice| (choice.demand, choice.support.to_vec()))
        .collect();
    assert_eq!(assignment, case.expected.assignment);
    assert_eq!(&*answer.unmatched_demands, &case.expected.unmatched_demands);
    assert_eq!(answer.states_examined, case.expected.states_examined);
    assert_eq!(
        &*answer.capacity_cut.resources,
        &case.expected.capacity_cut.resources
    );
    assert_eq!(
        &*answer.capacity_cut.forced_demands,
        &case.expected.capacity_cut.forced_demands
    );
    assert_eq!(
        answer.capacity_cut.capacity,
        case.expected.capacity_cut.capacity
    );
    assert_eq!(
        answer.capacity_cut.repair_upper_bound,
        case.expected.capacity_cut.repair_upper_bound
    );
}

fn check_gf4_transfer(case: &Gf4TransferCase) {
    let functional_basis = Matrix::new_field::<Gf4>(1, 2, case.functional_basis.clone()).unwrap();
    for expected in &case.profiles {
        let profile = compile_binary_rank_one::<Gf4>(
            &expected.columns,
            case.target_coordinate,
            1 << expected.columns.len(),
        )
        .unwrap();
        let ordinary = profile
            .ordinary()
            .iter()
            .map(|entry| {
                entry
                    .as_ref()
                    .map(|witness| (witness.cost, witness.coefficients.to_vec()))
            })
            .collect::<Vec<_>>();
        let normalized = profile
            .target_normalized()
            .iter()
            .map(|entry| {
                entry
                    .as_ref()
                    .map(|witness| (witness.cost, witness.coefficients.to_vec()))
            })
            .collect::<Vec<_>>();
        assert_eq!(ordinary, expected.ordinary);
        assert_eq!(normalized, expected.target_normalized);
        let dual = profile.inner_dual().unwrap();
        assert_eq!((dual.cost, dual.coefficients.to_vec()), expected.inner_dual);
        assert_eq!(profile.k_p().rows(), expected.k_p.rows);
        assert_eq!(profile.k_p().cols(), expected.k_p.cols);
        assert_eq!(profile.k_p().as_slice(), expected.k_p.data);
        assert_eq!(profile.d_p().rows(), expected.d_p.rows);
        assert_eq!(profile.d_p().cols(), expected.d_p.cols);
        assert_eq!(profile.d_p().as_slice(), expected.d_p.data);
        let (ordinary_table, target_table) = profile.cost_tables::<Gf4>().unwrap();
        let answer = confinement_by_generators_field::<Gf4>(
            &functional_basis,
            2,
            &ordinary_table,
            &target_table,
            0,
            dual.cost,
        )
        .unwrap();
        assert_eq!(answer.zero_cost, expected.zero_cost);
        assert_eq!(answer.nonzero_cost, Some(expected.nonzero_cost));
        assert_eq!(answer.cost, expected.gamma);
        assert_eq!(
            answer.functional_coefficients.unwrap().as_slice(),
            &[expected.outer_coefficient]
        );
        assert_eq!(
            answer
                .block_labels
                .iter()
                .map(|label| label.as_slice()[0])
                .collect::<Vec<_>>(),
            expected.block_labels
        );
    }
}

fn check_gf4_target_subspace(case: &Gf4TargetSubspaceCase) {
    let normalization = Matrix::new::<2>(
        case.normalization.rows,
        case.normalization.cols,
        case.normalization.data.clone(),
    )
    .unwrap();
    let profile = compile_binary_target_subspace::<Gf4>(
        &case.columns,
        &case.targets,
        &normalization,
        1 << (case.columns.len() * normalization.cols()),
        1 << ((case.columns.len() - case.targets.len()) * normalization.cols()),
    )
    .unwrap();
    let ordinary = profile
        .ordinary()
        .iter()
        .map(|entry| MatrixCostFixture {
            label: entry.label.as_slice().to_vec(),
            cost: entry.cost,
            coefficients: entry.coefficients.as_slice().to_vec(),
        })
        .collect::<Vec<_>>();
    let target = profile
        .target_normalized()
        .iter()
        .map(|entry| MatrixCostFixture {
            label: entry.label.as_slice().to_vec(),
            cost: entry.cost,
            coefficients: entry.coefficients.as_slice().to_vec(),
        })
        .collect::<Vec<_>>();
    assert_eq!(ordinary, case.ordinary);
    assert_eq!(target, case.target_normalized);
    assert_eq!(profile.target_union_cost(), case.target_union_cost);
    assert_eq!(profile.inner_dual().unwrap().cost, case.inner_dual_distance);
    let functional_basis = Matrix::new_field::<Gf4>(1, 2, case.functional_basis.clone()).unwrap();
    let (ordinary_table, target_table) = profile.cost_tables::<Gf4>().unwrap();
    let answer = confinement_by_generators_field::<Gf4>(
        &functional_basis,
        2,
        &ordinary_table,
        &target_table,
        0,
        case.inner_dual_distance,
    )
    .unwrap();
    assert_eq!(answer.zero_cost, case.zero_cost);
    assert_eq!(answer.nonzero_cost, Some(case.nonzero_cost));
    assert_eq!(answer.cost, case.gamma);
    assert_eq!(
        answer
            .block_labels
            .iter()
            .map(|label| label.as_slice().to_vec())
            .collect::<Vec<_>>(),
        case.winning_labels
    );
}

fn check_target_tower(case: &TargetTowerCase) {
    let table = |costs: &[u32]| {
        CostTable::from_entries::<2>(
            1,
            1,
            costs
                .iter()
                .enumerate()
                .map(|(label, &cost)| (Matrix::new::<2>(1, 1, vec![label as u8]).unwrap(), cost)),
        )
        .unwrap()
    };
    let blocks = [
        Matrix::new::<2>(1, 1, vec![1]).unwrap(),
        Matrix::new::<2>(1, 1, vec![1]).unwrap(),
    ];
    let ordinary = table(&case.ordinary);
    let target = table(&case.target);
    let ordinary_one = CompositionTable::compose::<2>(&blocks, &ordinary).unwrap();
    let target_one =
        CompositionTable::compose_with_target::<2>(&blocks, &ordinary, &target, 0).unwrap();
    for label in 0..2 {
        let matrix = Matrix::new::<2>(1, 1, vec![label]).unwrap();
        let ordinary_answer = ordinary_one.answer::<2>(&matrix).unwrap().unwrap();
        let target_answer = target_one.answer::<2>(&matrix).unwrap().unwrap();
        assert_eq!(
            (
                ordinary_answer.cost,
                ordinary_answer
                    .local_labels
                    .iter()
                    .map(|label| label.as_slice()[0])
                    .collect::<Vec<_>>()
            ),
            case.ordinary_level_one[label as usize]
        );
        assert_eq!(
            (
                target_answer.cost,
                target_answer
                    .local_labels
                    .iter()
                    .map(|label| label.as_slice()[0])
                    .collect::<Vec<_>>()
            ),
            case.target_level_one[label as usize]
        );
    }
    let ordinary_table = ordinary_one.cost_table::<2>().unwrap();
    let target_table = target_one.cost_table::<2>().unwrap();
    let ordinary_two = CompositionTable::compose::<2>(&blocks, &ordinary_table).unwrap();
    let target_two =
        CompositionTable::compose_with_target::<2>(&blocks, &ordinary_table, &target_table, 0)
            .unwrap();
    for label in 0..2 {
        let matrix = Matrix::new::<2>(1, 1, vec![label]).unwrap();
        let ordinary_answer = ordinary_two.answer::<2>(&matrix).unwrap().unwrap();
        let target_answer = target_two.answer::<2>(&matrix).unwrap().unwrap();
        assert_eq!(
            (
                ordinary_answer.cost,
                ordinary_answer
                    .local_labels
                    .iter()
                    .map(|label| label.as_slice()[0])
                    .collect::<Vec<_>>()
            ),
            case.ordinary_level_two[label as usize]
        );
        assert_eq!(
            (
                target_answer.cost,
                target_answer
                    .local_labels
                    .iter()
                    .map(|label| label.as_slice()[0])
                    .collect::<Vec<_>>()
            ),
            case.target_level_two[label as usize]
        );
    }
}

fn check_balanced_terminal(case: &BalancedTerminalCase) {
    let catalog = BalancedTransversalCatalog::q27();
    let mapping = catalog.mappings(0).unwrap()[0];
    assert_eq!(case.kappa, mapping.kappa);
    assert_eq!(case.rows, mapping.rows);
    assert_eq!(case.columns, mapping.columns);
    assert_eq!(case.ratios, mapping.ratios);
    let high_values: [u8; 9] = case.high_values.clone().try_into().unwrap();
    let cubic_mask = high_values
        .iter()
        .enumerate()
        .fold(0u16, |mask, (slot, value)| {
            mask | (u16::from(case.cubic_values.contains(value)) << slot)
        });
    let spec = HighFiberSpec::new(high_values, cubic_mask).unwrap();
    let carrier = BalancedCarrierCoefficients::new(
        case.trace.clone().try_into().unwrap(),
        case.product.clone().try_into().unwrap(),
    )
    .unwrap();
    let rejection = catalog
        .check_balanced_terminal(0, 0, &spec, carrier)
        .unwrap_err();
    let name = match rejection {
        BalancedTerminalRejection::TaskIndex => "TaskIndex",
        BalancedTerminalRejection::CarrierDoesNotSplit => "CarrierDoesNotSplit",
        BalancedTerminalRejection::HighFiberProfile => "HighFiberProfile",
        BalancedTerminalRejection::MappingCellPresent => "MappingCellPresent",
        BalancedTerminalRejection::UnshiftedNorm => "UnshiftedNorm",
        BalancedTerminalRejection::ReciprocalNorm => "ReciprocalNorm",
        BalancedTerminalRejection::FourthWitt => "FourthWitt",
        BalancedTerminalRejection::TerminalRankBound => "TerminalRankBound",
        BalancedTerminalRejection::MobiusDiscriminantEmpty => "MobiusDiscriminantEmpty",
    };
    assert_eq!(name, case.expected_rejection);
}

#[test]
fn generated_spans_match_python_costs_and_supports() {
    let fixture: Fixture =
        serde_json::from_str(include_str!("fixtures/python_span_cases.json")).unwrap();
    assert_eq!(fixture.schema, "ergo-comp-rust-v6");
    for case in &fixture.balanced_terminal_cases {
        check_balanced_terminal(case);
    }
    for case in &fixture.cases {
        match case.p {
            2 => check::<2>(case),
            3 => check::<3>(case),
            other => panic!("unsupported fixture prime {other}"),
        }
    }
    for case in &fixture.compositions {
        match case.p {
            2 => check_composition::<2>(case),
            3 => check_composition::<3>(case),
            other => panic!("unsupported fixture prime {other}"),
        }
    }
    for case in &fixture.confinements {
        match case.p {
            2 => check_confinement::<2>(case),
            3 => check_confinement::<3>(case),
            other => panic!("unsupported fixture prime {other}"),
        }
    }
    for case in &fixture.gf4_transfers {
        check_gf4_transfer(case);
    }
    for case in &fixture.gf4_target_subspaces {
        check_gf4_target_subspace(case);
    }
    for case in &fixture.target_towers {
        check_target_tower(case);
    }
    for case in &fixture.orbits {
        check_orbit(case);
    }
    for case in &fixture.weighted_schedulers {
        check_weighted_scheduler(case);
    }
    for case in &fixture.unit_schedulers {
        check_unit_scheduler(case);
    }
}
