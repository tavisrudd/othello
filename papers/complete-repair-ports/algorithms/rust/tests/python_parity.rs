use ergo_comp::balanced::{
    BalancedCarrierCoefficients, BalancedTerminalRejection, BalancedTransversalCatalog,
    HighFiberSpec,
};
use ergo_comp::{
    compile_integer_affine_constraints, compile_ternary_affine_constraints,
    confinement_by_generators, confinement_by_syndrome, maximum_parallel_repairs,
    ternary_orbit_syndrome_search, CompositionTable, ConfinementSector, CostTable,
    GeneratedSpanTable, IntegerAffineCompilation, Matrix, OrbitOption, TernaryAffineCompilation,
    WeightedRepairProblem,
};
use serde::Deserialize;

#[derive(Deserialize)]
struct Fixture {
    schema: String,
    balanced_terminal_cases: Vec<BalancedTerminalCase>,
    cases: Vec<Case>,
    compositions: Vec<CompositionCase>,
    confinements: Vec<ConfinementCase>,
    orbits: Vec<OrbitCase>,
    weighted_schedulers: Vec<WeightedSchedulerCase>,
    unit_schedulers: Vec<UnitSchedulerCase>,
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
    assert_eq!(fixture.schema, "ergo-comp-rust-v5");
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
