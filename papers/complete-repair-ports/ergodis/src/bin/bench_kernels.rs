use std::convert::Infallible;
use std::hint::black_box;
use std::time::Instant;

#[cfg(feature = "control-plane")]
use ergodis::control::{CompiledPlan, PlanOp, PlanOutput, PlanRole, PlanSpec, PLAN_SCHEMA};
use ergodis::root_execution::{reduce_roots, RootKernel, RootOrdinal};
use ergodis::{
    azure_lrc_12_2_2_counted, ceph_xor_repair_family, ceph_xor_repair_supports,
    ceph_xor_repair_supports_compressed, certify_rank_one_transfer_by_generators_field,
    compile_binary_rank_one, compile_binary_target_subspace,
    compile_verified_explicit_binary_support, confinement_by_generators_field,
    enumerate_integer_moments, gpu_checkpoint_mds_recovery, gpu_checkpoint_mds_same_rack_recovery,
    minimum_node_span_repair, schedule_repair_dag, solve_hall,
    ternary_orbit_syndrome_meet_in_middle, ternary_orbit_syndrome_meet_in_middle_count_split,
    ternary_orbit_syndrome_meet_in_middle_unreserved, ternary_orbit_syndrome_search,
    ternary_orbit_syndrome_search_correlated, BinarySupportCandidate, CephXorLayer,
    CompiledBinaryLinearCode, CompositionTower, ContextStrategy, DenseHallGraph, DenseSelector,
    ExplicitBinarySupportProblem, FiniteField, FinitePermutationAction, Gf4,
    GpuCheckpointCapacities, HallWorkspace, IntegerMomentProblem, IntegerMomentWorkspace, Matrix,
    OrbitOption, Prime, PrimePolynomialRecurrence, PrimeQuadraticCharacter, QcLdpcCode,
    RankOneProbeCache, RepairTask, SparseSelector, TowerLevel,
    VerifiedExplicitBinarySupportProblem, WeightedRepairProblem, WeightedRepairWorkspace,
    WeightedSchedulerBackend,
};

fn next_u32(state: &mut u64) -> u32 {
    *state = state
        .wrapping_mul(6_364_136_223_846_793_005)
        .wrapping_add(1);
    (*state >> 32) as u32
}

fn advance_lcg(state: u64, mut delta: u64) -> u64 {
    let mut accumulated_multiplier = 1u64;
    let mut accumulated_increment = 0u64;
    let mut multiplier = 6_364_136_223_846_793_005u64;
    let mut increment = 1u64;
    while delta != 0 {
        if delta & 1 != 0 {
            accumulated_multiplier = accumulated_multiplier.wrapping_mul(multiplier);
            accumulated_increment = accumulated_increment
                .wrapping_mul(multiplier)
                .wrapping_add(increment);
        }
        increment = multiplier.wrapping_add(1).wrapping_mul(increment);
        multiplier = multiplier.wrapping_mul(multiplier);
        delta >>= 1;
    }
    accumulated_multiplier
        .wrapping_mul(state)
        .wrapping_add(accumulated_increment)
}

fn linear_span_spec(variant: &str) -> Option<(&str, usize, usize, u64)> {
    let mut fields = variant.split(':');
    if fields.next()? != "linear-span" {
        return None;
    }
    let backend = fields.next()?;
    let rank = fields.next()?.parse().ok()?;
    let coordinates = fields.next()?.parse().ok()?;
    let seed = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((backend, rank, coordinates, seed))
}

fn linear_span_fixture(
    rank: usize,
    coordinates: usize,
    seed: u64,
) -> (CompiledBinaryLinearCode, Vec<u64>, usize) {
    assert!(rank > 0 && rank <= 63 && coordinates >= rank && coordinates <= u16::MAX as usize);
    let mut state = seed;
    let mut entries = Vec::with_capacity(rank * coordinates);
    for row in 0..rank {
        for coordinate in 0..coordinates {
            let entry = if coordinate < rank {
                u8::from(coordinate == row)
            } else {
                (next_u32(&mut state) & 1) as u8
            };
            entries.push(entry);
        }
    }
    let matrix = Matrix::new_field::<Prime<2>>(rank, coordinates, entries).unwrap();
    let basis = matrix.canonical_row_basis::<2>().unwrap();
    assert_eq!(basis.rows(), rank);
    let word_count = coordinates.div_ceil(64);
    let mut basis_words = vec![0_u64; rank * word_count];
    for row in 0..rank {
        for (coordinate, &entry) in basis.row(row).iter().enumerate() {
            if entry != 0 {
                basis_words[row * word_count + coordinate / 64] |= 1_u64 << (coordinate % 64);
            }
        }
    }
    (
        CompiledBinaryLinearCode::compile(&matrix).unwrap(),
        basis_words,
        word_count,
    )
}

fn binary_span_recompute(
    basis_words: &[u64],
    rank: usize,
    word_count: usize,
    current: &mut [u64],
) -> (u16, u64) {
    let candidates = (1_u64 << rank) - 1;
    let mut best = u16::MAX;
    for mask in 1..=candidates {
        current.fill(0);
        for row in 0..rank {
            if mask & (1_u64 << row) == 0 {
                continue;
            }
            let basis = &basis_words[row * word_count..(row + 1) * word_count];
            for (word, &toggle) in current.iter_mut().zip(basis) {
                *word ^= toggle;
            }
        }
        let weight = current
            .iter()
            .map(|word| word.count_ones() as u16)
            .sum::<u16>();
        best = best.min(weight);
    }
    (best, candidates)
}

fn root_execution_spec(variant: &str) -> Option<(&str, usize, u32, u64)> {
    let mut fields = variant.split(':');
    if fields.next()? != "root-execution" {
        return None;
    }
    let backend = fields.next()?;
    let roots = fields.next()?.parse().ok()?;
    let rounds = fields.next()?.parse().ok()?;
    let seed = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((backend, roots, rounds, seed))
}

struct RootExecutionBenchKernel {
    rounds: u32,
}

impl RootKernel for RootExecutionBenchKernel {
    type Root = u64;
    type Worker = u64;
    type Output = u64;

    #[inline(always)]
    fn create_worker(&self) -> Self::Worker {
        0x9e37_79b9_7f4a_7c15
    }

    #[inline(always)]
    fn evaluate(
        &self,
        worker: &mut Self::Worker,
        ordinal: RootOrdinal,
        root: &Self::Root,
    ) -> Self::Output {
        let mut value = root
            .wrapping_add(u64::from(ordinal.0))
            .wrapping_add(*worker);
        for _ in 0..self.rounds {
            value ^= value >> 30;
            value = value.wrapping_mul(0xbf58_476d_1ce4_e5b9);
            value ^= value >> 27;
            value = value.wrapping_mul(0x94d0_49bb_1331_11eb);
        }
        *worker = worker.rotate_left(7) ^ value;
        value
    }
}

fn direct_root_execution(kernel: &RootExecutionBenchKernel, roots: &[u64]) -> u64 {
    let mut worker = kernel.create_worker();
    let mut aggregate = 0_u64;
    for (ordinal, root) in roots.iter().enumerate() {
        aggregate ^= kernel.evaluate(&mut worker, RootOrdinal(ordinal as u32), root);
    }
    aggregate
}

fn hall_spec(variant: &str) -> Option<(&str, u32, u32, u32, usize, u64)> {
    let mut fields = variant.split(':');
    if fields.next()? != "hall" {
        return None;
    }
    let backend = fields.next()?;
    let left = fields.next()?.parse().ok()?;
    let right = fields.next()?.parse().ok()?;
    let density_per_mille = fields.next()?.parse().ok()?;
    let graphs = fields.next()?.parse().ok()?;
    let seed = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((backend, left, right, density_per_mille, graphs, seed))
}

fn integer_moment_spec(variant: &str) -> Option<(&str, IntegerMomentProblem)> {
    let mut fields = variant.split(':');
    if fields.next()? != "integer-moment" {
        return None;
    }
    let backend = fields.next()?;
    let problem = IntegerMomentProblem {
        degree: fields.next()?.parse().ok()?,
        sum: fields.next()?.parse().ok()?,
        square_sum: fields.next()?.parse().ok()?,
        minimum: fields.next()?.parse().ok()?,
        maximum: fields.next()?.parse().ok()?,
    };
    fields.next().is_none().then_some((backend, problem))
}

fn hash_integer_moment_solution(values: &[i32]) -> u64 {
    values.iter().fold(0xcbf2_9ce4_8422_2325, |hash, &value| {
        (hash ^ value as u32 as u64).wrapping_mul(0x100_0000_01b3)
    })
}

fn flat_integer_moment_enumeration(
    problem: IntegerMomentProblem,
    values: &mut [i32],
    next_value: &mut [i32],
    prefix_sum: &mut [i64],
    prefix_square_sum: &mut [i64],
) -> (u64, u64) {
    let degree = problem.degree as usize;
    prefix_sum[0] = 0;
    prefix_square_sum[0] = 0;
    next_value[0] = problem.minimum;
    let mut depth = 0_usize;
    let mut solutions = 0_u64;
    let mut checksum = 0_u64;
    loop {
        if depth == degree {
            if prefix_sum[depth] == problem.sum && prefix_square_sum[depth] == problem.square_sum {
                solutions += 1;
                checksum = checksum.wrapping_add(hash_integer_moment_solution(&values[..degree]));
            }
            depth -= 1;
            continue;
        }
        let value = next_value[depth];
        if value > problem.maximum {
            if depth == 0 {
                break;
            }
            depth -= 1;
            continue;
        }
        next_value[depth] = value + 1;
        values[depth] = value;
        prefix_sum[depth + 1] = prefix_sum[depth] + i64::from(value);
        prefix_square_sum[depth + 1] =
            prefix_square_sum[depth] + i64::from(value) * i64::from(value);
        depth += 1;
        if depth < degree {
            next_value[depth] = value;
        }
    }
    (solutions, checksum)
}

fn character_sum_spec(variant: &str) -> Option<(&str, u32, usize, u64)> {
    let mut fields = variant.split(':');
    if fields.next()? != "character-sum" {
        return None;
    }
    let backend = fields.next()?;
    let modulus = fields.next()?.parse().ok()?;
    let degree = fields.next()?.parse().ok()?;
    let seed = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((backend, modulus, degree, seed))
}

fn selector_spec(variant: &str) -> Option<(&str, usize)> {
    let mut fields = variant.split(':');
    if fields.next()? != "selector" {
        return None;
    }
    let backend = fields.next()?;
    let terms = fields.next()?.parse().ok()?;
    fields.next().is_none().then_some((backend, terms))
}

fn semantic_anchor_spec(variant: &str) -> Option<(&str, u32, u32)> {
    let mut fields = variant.split(':');
    if fields.next()? != "semantic-anchor" {
        return None;
    }
    let backend = fields.next()?;
    let block_size = fields.next()?.parse().ok()?;
    let blocks = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((backend, block_size, blocks))
}

struct BlockRotation {
    block_size: u32,
    blocks: u32,
}

impl FinitePermutationAction for BlockRotation {
    type Error = Infallible;

    fn point_count(&self) -> u32 {
        self.block_size * self.blocks
    }

    fn generator_count(&self) -> u32 {
        1
    }

    fn apply(&self, _generator: u32, point: u32) -> Result<u32, Self::Error> {
        let block = point / self.block_size;
        let offset = point % self.block_size;
        Ok(block * self.block_size + (offset + 1) % self.block_size)
    }
}

fn semantic_anchor_fixture(block_size: u32, blocks: u32) -> VerifiedExplicitBinarySupportProblem {
    assert!(block_size >= 2 && blocks > 0 && block_size * blocks <= 64);
    let mut candidates = Vec::with_capacity((block_size * blocks * 2) as usize);
    for block in 0..blocks {
        let base = block * block_size;
        for offset in 0..block_size {
            let point = base + offset;
            let next = base + (offset + 1) % block_size;
            candidates.push(BinarySupportCandidate::new(
                1_u64 << point,
                100 + u64::from(block),
            ));
            candidates.push(BinarySupportCandidate::new(
                (1_u64 << point) | (1_u64 << next),
                10 + u64::from(block),
            ));
        }
    }
    let action = BlockRotation { block_size, blocks };
    let problem = ExplicitBinarySupportProblem::new(action.point_count(), candidates).unwrap();
    compile_verified_explicit_binary_support(&action, problem).unwrap()
}

fn all_anchor_minimum(
    verified: &VerifiedExplicitBinarySupportProblem,
) -> Option<BinarySupportCandidate> {
    let mut best = None;
    for anchor in 0..verified.problem().point_count() {
        let anchor_bit = 1_u64 << anchor;
        let local = verified
            .problem()
            .candidates()
            .iter()
            .copied()
            .filter(|candidate| candidate.support() & anchor_bit != 0)
            .min_by_key(|candidate| (candidate.cost(), candidate.support()));
        if let Some(candidate) = local {
            if best.is_none_or(|current: BinarySupportCandidate| {
                (candidate.cost(), candidate.support()) < (current.cost(), current.support())
            }) {
                best = Some(candidate);
            }
        }
    }
    best
}

#[cfg(feature = "control-plane")]
fn plan_vm_spec(variant: &str) -> Option<(&str, usize, u64)> {
    let mut fields = variant.split(':');
    if fields.next()? != "plan-vm" {
        return None;
    }
    let backend = fields.next()?;
    let rows = fields.next()?.parse().ok()?;
    let seed = fields.next()?.parse().ok()?;
    fields.next().is_none().then_some((backend, rows, seed))
}

struct HallBenchFixture {
    dense: DenseHallGraph,
    adjacency: Vec<Vec<u32>>,
}

fn hall_fixtures(
    left: u32,
    right: u32,
    density_per_mille: u32,
    graph_count: usize,
    seed: u64,
) -> Vec<HallBenchFixture> {
    assert!(left > 0 && left <= right && density_per_mille <= 1_000);
    let mut state = seed;
    (0..graph_count)
        .map(|_| {
            let mut edges = Vec::new();
            let mut adjacency = vec![Vec::new(); left as usize];
            for source in 0..left {
                for target in 0..right {
                    let include =
                        target == source || next_u32(&mut state) % 1_000 < density_per_mille;
                    if include {
                        edges.push((source, target));
                        adjacency[source as usize].push(target);
                    }
                }
            }
            HallBenchFixture {
                dense: DenseHallGraph::new(left, right, edges).unwrap(),
                adjacency,
            }
        })
        .collect()
}

struct AdjacencyHallWorkspace {
    left_match: Vec<u32>,
    right_match: Vec<u32>,
    left_seen: Vec<u32>,
    right_seen: Vec<u32>,
    parent_right: Vec<u32>,
    queue: Vec<u32>,
    epoch: u32,
}

impl AdjacencyHallWorkspace {
    fn new(left: u32, right: u32) -> Self {
        Self {
            left_match: vec![u32::MAX; left as usize],
            right_match: vec![u32::MAX; right as usize],
            left_seen: vec![0; left as usize],
            right_seen: vec![0; right as usize],
            parent_right: vec![u32::MAX; right as usize],
            queue: vec![0; left as usize],
            epoch: 0,
        }
    }

    fn solve(&mut self, adjacency: &[Vec<u32>]) -> u32 {
        self.left_match.fill(u32::MAX);
        self.right_match.fill(u32::MAX);
        let mut cardinality = 0_u32;
        for root in 0..adjacency.len() as u32 {
            self.epoch = self.epoch.wrapping_add(1);
            if self.epoch == 0 {
                self.left_seen.fill(0);
                self.right_seen.fill(0);
                self.epoch = 1;
            }
            let epoch = self.epoch;
            self.left_seen[root as usize] = epoch;
            self.queue[0] = root;
            let mut head = 0_usize;
            let mut tail = 1_usize;
            let mut augmented = false;
            while head < tail && !augmented {
                let left = self.queue[head];
                head += 1;
                for &right in &adjacency[left as usize] {
                    if self.left_match[left as usize] == right
                        || self.right_seen[right as usize] == epoch
                    {
                        continue;
                    }
                    self.right_seen[right as usize] = epoch;
                    self.parent_right[right as usize] = left;
                    let next_left = self.right_match[right as usize];
                    if next_left == u32::MAX {
                        let mut cursor = right;
                        loop {
                            let path_left = self.parent_right[cursor as usize];
                            let previous = self.left_match[path_left as usize];
                            self.left_match[path_left as usize] = cursor;
                            self.right_match[cursor as usize] = path_left;
                            if previous == u32::MAX {
                                break;
                            }
                            cursor = previous;
                        }
                        augmented = true;
                        break;
                    }
                    if self.left_seen[next_left as usize] != epoch {
                        self.left_seen[next_left as usize] = epoch;
                        self.queue[tail] = next_left;
                        tail += 1;
                    }
                }
            }
            cardinality += u32::from(augmented);
        }
        cardinality
    }
}

fn jin_fu_outer_dual_basis() -> Matrix {
    // Jin--Fu, Example 5.7: the [43,36,5] GF(4) cyclic code generated by
    // x^7 + a*x^5 + x^4 + x^3 + a^2*x^2 + 1.
    let polynomial = [1, 0, 3, 1, 1, 2, 0, 1];
    let mut rows = vec![vec![0u8; 43]; 36];
    for (shift, row) in rows.iter_mut().enumerate() {
        row[shift..shift + polynomial.len()].copy_from_slice(&polynomial);
    }

    let mut pivots = Vec::with_capacity(36);
    let mut pivot_row = 0usize;
    for column in 0..43 {
        let Some(found) = (pivot_row..36).find(|&row| rows[row][column] != 0) else {
            continue;
        };
        rows.swap(pivot_row, found);
        let inverse = Gf4::inverse(rows[pivot_row][column]).unwrap();
        for entry in &mut rows[pivot_row][column..] {
            *entry = Gf4::mul(inverse, *entry);
        }
        let normalized = rows[pivot_row].clone();
        for (row_index, row) in rows.iter_mut().enumerate() {
            if row_index == pivot_row || row[column] == 0 {
                continue;
            }
            let factor = row[column];
            for (entry, &pivot_entry) in row[column..].iter_mut().zip(&normalized[column..]) {
                *entry = Gf4::sub(*entry, Gf4::mul(factor, pivot_entry));
            }
        }
        pivots.push(column);
        pivot_row += 1;
    }
    assert_eq!(pivots.len(), 36);

    let mut data = Vec::with_capacity(7 * 43);
    for free in (0..43).filter(|column| !pivots.contains(column)) {
        let mut vector = vec![0u8; 43];
        vector[free] = 1;
        for (row, &pivot) in pivots.iter().enumerate() {
            vector[pivot] = rows[row][free];
        }
        data.extend(vector);
    }
    Matrix::new_field::<Gf4>(7, 43, data).unwrap()
}

fn gf4_hamming_dual_basis(dimension: usize) -> Matrix {
    assert!((2..=15).contains(&dimension));
    let column_count = (4usize.pow(dimension as u32) - 1) / 3;
    let mut rows = vec![Vec::with_capacity(column_count); dimension];
    for pivot in 0..dimension {
        let suffixes = 4usize.pow((dimension - pivot - 1) as u32);
        for mut suffix in 0..suffixes {
            for (row, entries) in rows.iter_mut().enumerate() {
                let entry = if row < pivot {
                    0
                } else if row == pivot {
                    1
                } else {
                    let digit = suffix & 3;
                    suffix >>= 2;
                    digit as u8
                };
                entries.push(entry);
            }
        }
    }
    let data: Vec<u8> = rows.into_iter().flatten().collect();
    Matrix::new_field::<Gf4>(dimension, column_count, data).unwrap()
}

fn jin_fu_hamming_spec(variant: &str) -> Option<(&str, usize)> {
    let mut fields = variant.split(':');
    if fields.next()? != "jin-fu-hamming" {
        return None;
    }
    let backend = fields.next()?;
    let dimension = fields.next()?.parse().ok()?;
    fields.next().is_none().then_some((backend, dimension))
}

fn application_spec(variant: &str) -> Option<(&str, Vec<usize>)> {
    let mut fields = variant.split(':');
    if fields.next()? != "application" {
        return None;
    }
    let application = fields.next()?;
    if fields.next()? != "rust" {
        return None;
    }
    let parameters = fields
        .map(|field| field.parse().ok())
        .collect::<Option<Vec<_>>>()?;
    Some((application, parameters))
}

fn vector_repair_fixture(nodes: usize, subpacketization: usize) -> (Matrix, Vec<u16>, Matrix) {
    let ambient = 8;
    let coordinates = nodes * subpacketization;
    let mut data = vec![0u8; ambient * coordinates];
    let mut owners = Vec::with_capacity(coordinates);
    for node in 0..nodes {
        let kind = node & 3;
        for symbol in 0..subpacketization {
            let coordinate = node * subpacketization + symbol;
            let row = 2 * kind + (symbol & 1);
            data[row * coordinates + coordinate] = 1;
            owners.push(node as u16);
        }
    }
    let mut target_data = vec![0u8; ambient * ambient];
    for diagonal in 0..ambient {
        target_data[diagonal * ambient + diagonal] = 1;
    }
    (
        Matrix::new::<2>(ambient, coordinates, data).unwrap(),
        owners,
        Matrix::new::<2>(ambient, ambient, target_data).unwrap(),
    )
}

fn repair_dag_fixture(width: usize, layers: usize) -> Vec<RepairTask> {
    assert!(width * layers <= 63);
    let mut tasks = Vec::with_capacity(width * layers);
    for layer in 0..layers {
        let predecessors = if layer == 0 {
            0
        } else {
            ((1u64 << width) - 1) << ((layer - 1) * width)
        };
        for task in 0..width {
            let mut loads = vec![0u16; width];
            loads[(task + layer) % width] = 1;
            tasks.push(RepairTask {
                predecessors,
                loads: loads.into_boxed_slice(),
            });
        }
    }
    tasks
}

fn ceph_fanout_fixture(levels: usize, branches: usize) -> (usize, Vec<CephXorLayer>, Vec<usize>) {
    assert!(levels > 0 && branches > 1 && (branches + 1) * levels < 256);
    let common = levels;
    let mut layers = Vec::with_capacity(branches * levels);
    for level in 0..levels {
        let previous = if level == 0 { common } else { level - 1 };
        for branch in 0..branches {
            layers.push(CephXorLayer {
                parity: level as u8,
                data: Box::new([
                    previous as u8,
                    (levels + 1 + branches * level + branch) as u8,
                ]),
            });
        }
    }
    ((branches + 1) * levels + 1, layers, (0..levels).collect())
}

fn transfer_tower_spec(variant: &str) -> Option<(&str, usize, usize)> {
    let mut fields = variant.split(':');
    if fields.next()? != "transfer-tower" {
        return None;
    }
    let backend = fields.next()?;
    if backend != "rust" && backend != "rust-stream" {
        return None;
    }
    let depth = fields.next()?.parse().ok()?;
    let fanout = fields.next()?.parse().ok()?;
    fields.next().is_none().then_some((backend, depth, fanout))
}

fn scheduler_problem(small: bool) -> WeightedRepairProblem {
    let (resource_count, capacity, demand_count) = if small { (4, 2, 80) } else { (6, 3, 11) };
    scheduler_problem_with(resource_count, capacity, demand_count, 4, 0xA17E_5EED)
}

fn scheduler_problem_with(
    resource_count: usize,
    capacity: u32,
    demand_count: usize,
    option_count: usize,
    seed: u64,
) -> WeightedRepairProblem {
    assert!(resource_count >= 2);
    let capacities = vec![capacity; resource_count];
    let mut state = seed;
    let families: Vec<Vec<Vec<u32>>> = (0..demand_count)
        .map(|_| {
            (0..option_count)
                .map(|_| {
                    let mut loads = vec![0u32; resource_count];
                    let first = next_u32(&mut state) as usize % capacities.len();
                    let mut second = next_u32(&mut state) as usize % capacities.len();
                    if second == first {
                        second = (second + 1) % capacities.len();
                    }
                    loads[first] = 1;
                    loads[second] = 1;
                    loads
                })
                .collect()
        })
        .collect();
    WeightedRepairProblem::from_families(&capacities, &families).unwrap()
}

fn scheduler_grid_spec(variant: &str) -> Option<(&str, usize, u32, usize, usize, u64)> {
    let mut fields = variant.split(':');
    if fields.next()? != "scheduler-grid" {
        return None;
    }
    let backend = fields.next()?;
    let resources = fields.next()?.parse().ok()?;
    let capacity = fields.next()?.parse().ok()?;
    let demands = fields.next()?.parse().ok()?;
    let options = fields.next()?.parse().ok()?;
    let seed = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((backend, resources, capacity, demands, options, seed))
}

fn heterogeneous_scheduler_problem_with(
    resource_count: usize,
    capacity: u32,
    demand_count: usize,
) -> WeightedRepairProblem {
    let capacities = vec![capacity; resource_count];
    let families = (0..demand_count)
        .map(|demand| {
            (0..resource_count)
                .map(|resource| {
                    let mut loads = vec![0u32; resource_count];
                    loads[resource] = 1 + u32::from((demand + resource) % 3 == 0);
                    loads
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();
    WeightedRepairProblem::from_families(&capacities, &families).unwrap()
}

fn heterogeneous_scheduler_grid_spec(variant: &str) -> Option<(&str, usize, u32, usize)> {
    let mut fields = variant.split(':');
    if fields.next()? != "scheduler-heterogeneous-grid" {
        return None;
    }
    let backend = fields.next()?;
    let resources = fields.next()?.parse().ok()?;
    let capacity = fields.next()?.parse().ok()?;
    let demands = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((backend, resources, capacity, demands))
}

fn graded_scheduler_problem_with(
    resource_count: usize,
    capacity: u32,
    demand_count: usize,
    option_count: usize,
    seed: u64,
    certified: bool,
) -> WeightedRepairProblem {
    assert!(resource_count >= 4);
    let capacities = vec![capacity; resource_count];
    let weights: Vec<u32> = (0..resource_count)
        .map(|resource| if resource % 2 == 0 { 1 } else { 2 })
        .collect();
    let even: Vec<usize> = (0..resource_count).step_by(2).collect();
    let odd: Vec<usize> = (1..resource_count).step_by(2).collect();
    let mut state = seed;
    let families: Vec<Vec<Vec<u32>>> = (0..demand_count)
        .map(|_| {
            (0..option_count)
                .map(|option| {
                    let mut loads = vec![0u32; resource_count];
                    match option % 4 {
                        0 => loads[even[next_u32(&mut state) as usize % even.len()]] = 4,
                        1 => loads[odd[next_u32(&mut state) as usize % odd.len()]] = 2,
                        2 => {
                            let first = next_u32(&mut state) as usize % even.len();
                            let mut second = next_u32(&mut state) as usize % even.len();
                            if second == first {
                                second = (second + 1) % even.len();
                            }
                            loads[even[first]] = 2;
                            loads[even[second]] = 2;
                        }
                        _ => {
                            loads[even[next_u32(&mut state) as usize % even.len()]] = 2;
                            loads[odd[next_u32(&mut state) as usize % odd.len()]] = 1;
                        }
                    }
                    loads
                })
                .collect()
        })
        .collect();
    if certified {
        WeightedRepairProblem::from_families_with_positive_grading(&capacities, &families, &weights)
            .unwrap()
    } else {
        WeightedRepairProblem::from_families(&capacities, &families).unwrap()
    }
}

fn graded_scheduler_problem_streaming_4(
    capacity: u32,
    demand_count: usize,
    option_count: usize,
    seed: u64,
) -> WeightedRepairProblem {
    let remainder_calls = [0u64, 1, 2, 4];
    let calls_per_family =
        u64::try_from(option_count / 4).unwrap() * 6 + remainder_calls[option_count % 4];
    let even = [0usize, 2];
    let odd = [1usize, 3];
    let families = (0..demand_count).map(|demand| {
        let offset = u64::try_from(demand).unwrap() * calls_per_family;
        let mut state = advance_lcg(seed, offset);
        (0..option_count).map(move |option| {
            let mut loads = [0u32; 4];
            match option % 4 {
                0 => loads[even[next_u32(&mut state) as usize % even.len()]] = 4,
                1 => loads[odd[next_u32(&mut state) as usize % odd.len()]] = 2,
                2 => {
                    let first = next_u32(&mut state) as usize % even.len();
                    let mut second = next_u32(&mut state) as usize % even.len();
                    if second == first {
                        second = (second + 1) % even.len();
                    }
                    loads[even[first]] = 2;
                    loads[even[second]] = 2;
                }
                _ => {
                    loads[even[next_u32(&mut state) as usize % even.len()]] = 2;
                    loads[odd[next_u32(&mut state) as usize % odd.len()]] = 1;
                }
            }
            loads
        })
    });
    WeightedRepairProblem::from_family_iterators_with_positive_grading(
        &[capacity; 4],
        families,
        &[1, 2, 1, 2],
    )
    .unwrap()
}

fn graded_scheduler_grid_spec(variant: &str) -> Option<(&str, usize, u32, usize, usize, u64)> {
    let mut fields = variant.split(':');
    if fields.next()? != "scheduler-graded-grid" {
        return None;
    }
    let backend = fields.next()?;
    let resources = fields.next()?.parse().ok()?;
    let capacity = fields.next()?.parse().ok()?;
    let demands = fields.next()?.parse().ok()?;
    let options = fields.next()?.parse().ok()?;
    let seed = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((backend, resources, capacity, demands, options, seed))
}

fn orbit_problem() -> (Vec<Vec<OrbitOption>>, Vec<u8>) {
    orbit_problem_with(&[3; 10], 12, 0xA17E_0B17)
}

fn orbit_grid_spec(variant: &str) -> Option<(usize, usize, usize, u64)> {
    let mut fields = variant.split(':');
    if fields.next()? != "orbit-grid" || fields.next()? != "rust" {
        return None;
    }
    let families = fields.next()?.parse().ok()?;
    let options = fields.next()?.parse().ok()?;
    let width = fields.next()?.parse().ok()?;
    let seed = fields.next()?.parse().ok()?;
    fields
        .next()
        .is_none()
        .then_some((families, options, width, seed))
}

fn orbit_problem_with(
    family_sizes: &[usize],
    width: usize,
    seed: u64,
) -> (Vec<Vec<OrbitOption>>, Vec<u8>) {
    let mut state = seed;
    let mut label = 0u32;
    let families = family_sizes
        .iter()
        .map(|&family_size| {
            (0..family_size)
                .map(|_| {
                    let option = OrbitOption {
                        label,
                        residue: (0..width)
                            .map(|_| (next_u32(&mut state) % 3) as u8)
                            .collect::<Vec<_>>()
                            .into_boxed_slice(),
                        totals: Box::new([]),
                    };
                    label += 1;
                    option
                })
                .collect()
        })
        .collect();
    let target = (0..width)
        .map(|_| (next_u32(&mut state) % 3) as u8)
        .collect();
    (families, target)
}

fn peak_rss_kib() -> u64 {
    std::fs::read_to_string("/proc/self/status")
        .ok()
        .and_then(|status| {
            status.lines().find_map(|line| {
                line.strip_prefix("VmHWM:")?
                    .split_whitespace()
                    .next()?
                    .parse()
                    .ok()
            })
        })
        .unwrap_or(0)
}

fn main() {
    let mut args = std::env::args().skip(1);
    let variant = args.next().expect("variant is required");
    let repetitions: u32 = args
        .next()
        .expect("repetitions are required")
        .parse()
        .expect("repetitions must be an integer");
    assert!(args.next().is_none(), "unexpected argument");

    let started = Instant::now();
    let mut work = 0u64;
    let mut peak_states = 0u64;
    let mut checksum = 0u64;
    if let Some((backend, rank, coordinates, seed)) = linear_span_spec(&variant) {
        let (compiled, basis_words, word_count) = linear_span_fixture(rank, coordinates, seed);
        let mut workspace = compiled.workspace();
        let mut current = vec![0_u64; word_count];
        for _ in 0..repetitions {
            let (weight, candidates) = match backend {
                "gray" => {
                    let summary = compiled.minimum_nonzero_weight_scan(&mut workspace);
                    (
                        summary.weight.expect("positive-rank fixture has a word"),
                        summary.candidates,
                    )
                }
                "recompute" => binary_span_recompute(&basis_words, rank, word_count, &mut current),
                _ => panic!("unknown linear-span backend"),
            };
            work += candidates;
            checksum = checksum.wrapping_add(u64::from(weight));
            black_box((weight, candidates));
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, root_count, rounds, seed)) = root_execution_spec(&variant) {
        assert!(root_count <= u32::MAX as usize);
        let roots = (0..root_count)
            .scan(seed, |state, _| {
                *state = state
                    .wrapping_mul(6_364_136_223_846_793_005)
                    .wrapping_add(1);
                Some(*state)
            })
            .collect::<Vec<_>>();
        let kernel = RootExecutionBenchKernel { rounds };
        for _ in 0..repetitions {
            let aggregate = match backend {
                "direct" => direct_root_execution(&kernel, &roots),
                "generic" => {
                    reduce_roots(&kernel, &roots, 1, || 0_u64, |left, right| left ^ right).unwrap()
                }
                _ => panic!("unknown root-execution backend"),
            };
            work = work.wrapping_add(root_count as u64 * u64::from(rounds));
            checksum ^= aggregate;
            black_box(aggregate);
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, problem)) = integer_moment_spec(&variant) {
        assert!(problem.degree > 0);
        let degree = problem.degree as usize;
        let mut workspace = IntegerMomentWorkspace::new(problem.degree).unwrap();
        let mut values = vec![0_i32; degree];
        let mut next_value = vec![0_i32; degree];
        let mut prefix_sum = vec![0_i64; degree + 1];
        let mut prefix_square_sum = vec![0_i64; degree + 1];
        for _ in 0..repetitions {
            let mut solution_checksum = 0_u64;
            let solutions = match backend {
                "envelope" => {
                    enumerate_integer_moments(problem, &mut workspace, |solution| {
                        solution_checksum =
                            solution_checksum.wrapping_add(hash_integer_moment_solution(solution));
                    })
                    .unwrap()
                    .solutions
                }
                "flat" => {
                    let (solutions, checksum) = flat_integer_moment_enumeration(
                        problem,
                        &mut values,
                        &mut next_value,
                        &mut prefix_sum,
                        &mut prefix_square_sum,
                    );
                    solution_checksum = checksum;
                    solutions
                }
                _ => panic!("unknown integer-moment backend"),
            };
            work += 1;
            checksum = checksum
                .wrapping_add(solutions)
                .wrapping_add(solution_checksum);
            black_box((solutions, solution_checksum));
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, modulus, degree, seed)) = character_sum_spec(&variant) {
        let character = PrimeQuadraticCharacter::new(modulus).unwrap();
        let mut state = seed;
        let coefficients = (0..=degree)
            .map(|_| next_u32(&mut state) % modulus)
            .collect::<Vec<_>>();
        let mut recurrence = PrimePolynomialRecurrence::compile(modulus, &coefficients).unwrap();
        for _ in 0..repetitions {
            let census = match backend {
                "horner" => character.polynomial_census_reduced(&coefficients).unwrap(),
                "recurrence" => character
                    .polynomial_census_recurrence(&mut recurrence)
                    .unwrap(),
                _ => panic!("unknown character-sum backend"),
            };
            work += u64::from(modulus);
            checksum = checksum
                .wrapping_add(u64::from(census.positive()))
                .wrapping_add(u64::from(census.negative()) << 21)
                .wrapping_add(u64::from(census.zero()) << 42);
            black_box(census);
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, term_count)) = selector_spec(&variant) {
        const SLOTS: usize = 5_usize.pow(5);
        assert!(term_count > 0 && term_count <= SLOTS);
        let mut dense_coefficients = vec![0_u8; SLOTS];
        let mut sparse_terms = Vec::with_capacity(term_count);
        for term in 0..term_count {
            let index = term * SLOTS / term_count;
            let coefficient = (term % 6 + 1) as u8;
            dense_coefficients[index] = coefficient;
            sparse_terms.push((index as u64, coefficient));
        }
        let dense = DenseSelector::<Prime<7>>::new([4; 5], dense_coefficients).unwrap();
        let sparse = SparseSelector::<Prime<7>>::new([4; 5], sparse_terms).unwrap();
        let mut dense_workspace = dense.workspace();
        let mut sparse_workspace = sparse.workspace();
        let expected = dense.select_nonzero(&mut dense_workspace).unwrap();
        assert_eq!(
            expected,
            sparse.select_nonzero(&mut sparse_workspace).unwrap()
        );
        for _ in 0..repetitions {
            let answer = match backend {
                "dense" => dense.select_nonzero(&mut dense_workspace).unwrap(),
                "sparse" => sparse.select_nonzero(&mut sparse_workspace).unwrap(),
                _ => panic!("unknown selector backend"),
            };
            work += answer.partial_tests;
            let assignment_hash = answer
                .assignment
                .iter()
                .fold(0x9e37_79b9_7f4a_7c15_u64, |hash, &value| {
                    hash.rotate_left(5) ^ u64::from(value)
                });
            checksum = checksum
                .wrapping_add(assignment_hash)
                .wrapping_add(answer.partial_tests);
            black_box(answer);
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, block_size, blocks)) = semantic_anchor_spec(&variant) {
        let verified = semantic_anchor_fixture(block_size, blocks);
        for _ in 0..repetitions {
            let candidate = match backend {
                "all" => all_anchor_minimum(&verified).unwrap(),
                "orbit" => verified.anchored_minimum().unwrap().candidate(),
                _ => panic!("unknown semantic-anchor backend"),
            };
            work += 1;
            checksum = checksum
                .wrapping_add(candidate.cost())
                .wrapping_add(candidate.support().rotate_left(17));
            black_box(candidate);
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            verified.cover().subproblem_count(),
            peak_rss_kib()
        );
        return;
    }
    #[cfg(feature = "control-plane")]
    if let Some((backend, row_count, seed)) = plan_vm_spec(&variant) {
        let fields = vec!["surplus".to_owned(), "drop".to_owned(), "debt".to_owned()];
        let spec = PlanSpec {
            schema: PLAN_SCHEMA.to_owned(),
            name: "bench-predicate".to_owned(),
            role: PlanRole::Diagnostic,
            output: PlanOutput::Predicate,
            scope: None,
            program: vec![
                PlanOp::Field {
                    name: "surplus".to_owned(),
                },
                PlanOp::Const { value: 0 },
                PlanOp::Gt,
                PlanOp::Field {
                    name: "drop".to_owned(),
                },
                PlanOp::Const { value: 0 },
                PlanOp::Gt,
                PlanOp::And,
                PlanOp::Field {
                    name: "debt".to_owned(),
                },
                PlanOp::Const { value: 0 },
                PlanOp::Lt,
                PlanOp::Or,
            ],
        };
        let plan = CompiledPlan::compile(&spec, &fields).unwrap();
        let mut state = seed;
        let rows = (0..row_count)
            .map(|_| std::array::from_fn(|_| i64::from(next_u32(&mut state) % 257) - 128))
            .collect::<Vec<[i64; 3]>>();
        for _ in 0..repetitions {
            for row in &rows {
                let value = match backend {
                    "direct" => i64::from(((row[0] > 0) & (row[1] > 0)) | (row[2] < 0)),
                    "vm" => plan.evaluate_row(row).unwrap(),
                    _ => panic!("unknown plan-VM backend"),
                };
                work += 1;
                checksum = checksum.wrapping_add(value as u64);
                black_box(value);
            }
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, left, right, density, graph_count, seed)) = hall_spec(&variant) {
        let fixtures = hall_fixtures(left, right, density, graph_count, seed);
        let mut dense_workspace = HallWorkspace::new(left, right).unwrap();
        let mut adjacency_workspace = AdjacencyHallWorkspace::new(left, right);
        for _ in 0..repetitions {
            for fixture in &fixtures {
                let cardinality = match backend {
                    "bitmap" => solve_hall(&fixture.dense, &mut dense_workspace)
                        .unwrap()
                        .cardinality(),
                    "adjacency" => adjacency_workspace.solve(&fixture.adjacency),
                    _ => panic!("unknown Hall backend"),
                };
                assert_eq!(cardinality, left);
                work += 1;
                checksum = checksum.wrapping_add(u64::from(cardinality));
                black_box(cardinality);
            }
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((application, parameters)) = application_spec(&variant) {
        for _ in 0..repetitions {
            match (application, parameters.as_slice()) {
                ("ceph", parameters @ &[levels, ..]) if parameters.len() <= 2 => {
                    let branches = parameters.get(1).copied().unwrap_or(2);
                    let (coordinates, layers, unavailable) = ceph_fanout_fixture(levels, branches);
                    let answer = ceph_xor_repair_supports(
                        coordinates,
                        &layers,
                        levels - 1,
                        &unavailable,
                        1 << 34,
                    )
                    .unwrap();
                    assert_eq!(answer.supports.len(), branches.pow(levels as u32));
                    work += answer.combinations_examined;
                    peak_states = peak_states.max(answer.supports.len() as u64);
                    checksum += answer.supports.len() as u64;
                    black_box(answer);
                }
                ("ceph-zdd", parameters @ &[levels, ..]) if parameters.len() <= 2 => {
                    let branches = parameters.get(1).copied().unwrap_or(2);
                    let (coordinates, layers, unavailable) = ceph_fanout_fixture(levels, branches);
                    let answer = ceph_xor_repair_supports_compressed(
                        coordinates,
                        &layers,
                        levels - 1,
                        &unavailable,
                        1 << 24,
                    )
                    .unwrap();
                    assert_eq!(answer.support_count, branches.pow(levels as u32) as u64);
                    work += answer.zdd_operations;
                    assert!(!answer.zdd_storage_grew, "ZDD storage grew after setup");
                    peak_states = peak_states.max(u64::from(answer.zdd_nodes));
                    checksum += answer.support_count;
                    black_box(answer);
                }
                ("ceph-reliability", parameters @ &[levels, ..]) if parameters.len() <= 2 => {
                    let branches = parameters.get(1).copied().unwrap_or(2);
                    let (coordinates, layers, unavailable) = ceph_fanout_fixture(levels, branches);
                    let mut family = ceph_xor_repair_family(
                        coordinates,
                        &layers,
                        levels - 1,
                        &unavailable,
                        1 << 24,
                    )
                    .unwrap();
                    let polynomial = family.reliability_polynomial().unwrap();
                    assert_eq!(polynomial.variable_count(), coordinates - unavailable.len());
                    work += polynomial.success_counts_by_available.len() as u64;
                    peak_states =
                        peak_states.max(polynomial.success_counts_by_available.len() as u64);
                    checksum += polynomial.variable_count() as u64;
                    black_box(polynomial);
                }
                ("ceph-aggregate", &[levels, branches, demands]) => {
                    let (coordinates, layers, unavailable) = ceph_fanout_fixture(levels, branches);
                    let family = ceph_xor_repair_family(
                        coordinates,
                        &layers,
                        levels - 1,
                        &unavailable,
                        1 << 24,
                    )
                    .unwrap();
                    let mut resources = vec![0u8; coordinates];
                    resources[levels] = branches as u8;
                    for level in 0..levels {
                        for branch in 0..branches {
                            resources[levels + 1 + branches * level + branch] = branch as u8;
                        }
                    }
                    let leaf_capacity = levels.saturating_mul(demands).div_ceil(branches) as u32;
                    let mut capacities = vec![leaf_capacity; branches];
                    capacities.push(demands as u32);
                    let aggregated = family
                        .aggregate_for_scheduler(&resources, &capacities, demands, 1 << 24)
                        .unwrap();
                    peak_states = peak_states.max(aggregated.options.len() as u64);
                    let answer = aggregated.problem.solve_adaptive().unwrap();
                    assert_eq!(answer.repaired_count(), demands);
                    work += answer.transitions_examined;
                    checksum += answer.repaired_count() as u64;
                    black_box((aggregated, answer));
                }
                ("azure", &[demands, capacity]) => {
                    let capacities = black_box([capacity as u32; 9]);
                    let answer = azure_lrc_12_2_2_counted(&capacities, black_box(demands));
                    work += answer.totals_checked;
                    checksum += answer.repaired_count;
                    black_box(answer);
                }
                ("rdag", &[width, layers]) => {
                    let tasks = repair_dag_fixture(width, layers);
                    let answer = schedule_repair_dag(&vec![1u16; width], &tasks, 1 << 28).unwrap();
                    assert_eq!(usize::from(answer.slots), layers);
                    work += answer.states_examined;
                    checksum += u64::from(answer.slots);
                    black_box(answer);
                }
                ("qc", parameters @ &[lift, size, ..]) if parameters.len() <= 3 => {
                    let maximum_odd_checks = parameters.get(2).copied().unwrap_or(0);
                    let code =
                        QcLdpcCode::new(2, 2, lift, vec![Some(0), Some(0), Some(0), Some(1)])
                            .unwrap();
                    let answer = code
                        .search_trapping_set(size, maximum_odd_checks, 1 << 32)
                        .unwrap();
                    work += answer.candidates_examined;
                    checksum += answer.answer.is_some() as u64;
                    black_box(answer);
                }
                ("vector", &[nodes, subpacketization]) => {
                    let (generator, owners, target) =
                        vector_repair_fixture(nodes, subpacketization);
                    let answer =
                        minimum_node_span_repair::<Prime<2>>(&generator, &owners, &target, 1 << 16)
                            .unwrap()
                            .unwrap();
                    assert_eq!(answer.node_cost, 4);
                    work += answer.transitions;
                    peak_states = peak_states.max(answer.generated_spans as u64);
                    checksum += u64::from(answer.node_cost);
                    black_box(answer);
                }
                ("gpu", &[shards, data_shards, failures]) => {
                    let shard_nodes: Vec<_> = (0..shards).map(|node| node as u16).collect();
                    let node_racks: Vec<_> = (0..shards).map(|node| (node / 8) as u16).collect();
                    let failed_shards: Vec<_> = (0..failures).collect();
                    let replacement_nodes: Vec<_> = (0..failures).map(|node| node as u16).collect();
                    let mut capacities = vec![failures as u32; shards + 2];
                    capacities[shards] = (data_shards * failures) as u32;
                    capacities[shards + 1] = (data_shards * failures) as u32;
                    let problem = gpu_checkpoint_mds_recovery(
                        data_shards,
                        &shard_nodes,
                        &node_racks,
                        &failed_shards,
                        &replacement_nodes,
                        &capacities,
                        1 << 24,
                    )
                    .unwrap();
                    let answer = problem.solve_adaptive().unwrap();
                    assert_eq!(answer.repaired_count(), failures);
                    work += answer.transitions_examined;
                    peak_states = peak_states.max(answer.peak_pareto_states as u64);
                    checksum += answer.repaired_count() as u64;
                    black_box(answer);
                }
                ("gpu-compiled", &[shards, data_shards, failures]) => {
                    let shard_nodes: Vec<_> = (0..shards).map(|node| node as u16).collect();
                    let node_racks: Vec<_> = (0..shards).map(|node| (node / 8) as u16).collect();
                    let failed_shards: Vec<_> = (0..failures).collect();
                    let replacement_nodes = vec![0u16; failures];
                    let node_capacities = vec![failures as u32; shards];
                    let answer = gpu_checkpoint_mds_same_rack_recovery(
                        data_shards,
                        &shard_nodes,
                        &node_racks,
                        &failed_shards,
                        &replacement_nodes,
                        GpuCheckpointCapacities {
                            nodes: &node_capacities,
                            same_rack: (data_shards * failures) as u32,
                            cross_rack: (data_shards * failures) as u32,
                        },
                    )
                    .unwrap()
                    .unwrap();
                    assert_eq!(answer.failure_count as usize, failures);
                    assert_eq!(answer.data_shards as usize, data_shards);
                    assert_eq!(answer.helper_shards.len(), failures * data_shards);
                    work += answer.assignments;
                    checksum += u64::from(answer.failure_count);
                    black_box(answer);
                }
                _ => panic!("unknown application benchmark variant"),
            }
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, dimension)) = jin_fu_hamming_spec(&variant) {
        let functional_dual_basis = gf4_hamming_dual_basis(dimension);
        let block_count = functional_dual_basis.cols();
        let profile = compile_binary_rank_one::<Gf4>(&[1, 2, 3], 0, 16).unwrap();
        let inner_dual = profile.inner_dual().unwrap();
        let (ordinary, target) = profile.cost_tables::<Gf4>().unwrap();
        let expected_nonzero = 4u32.pow((dimension - 1) as u32) - 1;
        let mut warm_cache =
            RankOneProbeCache::<Gf4>::new(&ordinary, &target, block_count, 0, inner_dual.cost)
                .unwrap();
        for _ in 0..repetitions {
            match backend {
                "rust" => {
                    let answer = confinement_by_generators_field::<Gf4>(
                        &functional_dual_basis,
                        block_count,
                        &ordinary,
                        &target,
                        0,
                        inner_dual.cost,
                    )
                    .unwrap();
                    assert_eq!(answer.cost, 5);
                    assert_eq!(answer.nonzero_cost, Some(expected_nonzero));
                    work += answer.transitions;
                    checksum += u64::from(answer.cost);
                    black_box(answer);
                }
                "certificate" => {
                    let answer = certify_rank_one_transfer_by_generators_field::<Gf4>(
                        &functional_dual_basis,
                        block_count,
                        &ordinary,
                        &target,
                        0,
                        inner_dual.cost,
                        4,
                    )
                    .unwrap();
                    assert!(answer.transfers_completely);
                    work += answer.candidates_examined;
                    checksum += 5;
                    black_box(answer);
                }
                "cache-cold" => {
                    let mut cache = RankOneProbeCache::<Gf4>::new(
                        &ordinary,
                        &target,
                        block_count,
                        0,
                        inner_dual.cost,
                    )
                    .unwrap();
                    let answer = cache.context_cost_cached(&functional_dual_basis).unwrap();
                    assert_eq!(answer.cost, 5);
                    work += answer.work.outer_vectors;
                    peak_states = peak_states.max(cache.cached_probe_count() as u64);
                    checksum += u64::from(answer.cost);
                    black_box(answer);
                }
                "cache-warm" => {
                    let answer = warm_cache
                        .context_cost_cached(&functional_dual_basis)
                        .unwrap();
                    assert_eq!(answer.cost, 5);
                    work += answer.work.outer_vectors;
                    peak_states = peak_states.max(warm_cache.cached_probe_count() as u64);
                    checksum += u64::from(answer.cost);
                    black_box(answer);
                }
                "auto-one" | "auto-zero-budget" => {
                    let mut cache = RankOneProbeCache::<Gf4>::new(
                        &ordinary,
                        &target,
                        block_count,
                        0,
                        inner_dual.cost,
                    )
                    .unwrap();
                    let answer = cache
                        .context_cost_planned(
                            &functional_dual_basis,
                            ContextStrategy::Auto {
                                expected_queries: 1,
                                memory_budget_bytes: if backend == "auto-one" {
                                    usize::MAX
                                } else {
                                    0
                                },
                            },
                        )
                        .unwrap();
                    assert_eq!(answer.result.cost, 5);
                    work += answer
                        .result
                        .work
                        .outer_vectors
                        .max(answer.result.work.generator_candidates);
                    peak_states = peak_states.max(cache.cached_probe_count() as u64);
                    checksum += u64::from(answer.result.cost);
                    black_box(answer);
                }
                _ => panic!("unknown Jin--Fu Hamming benchmark backend"),
            }
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if matches!(
        variant.as_str(),
        "jin-fu:rust"
            | "jin-fu:certificate"
            | "jin-fu:cache-cold"
            | "jin-fu:cache-warm"
            | "jin-fu:auto-one"
            | "jin-fu:auto-zero-budget"
    ) {
        let functional_dual_basis = jin_fu_outer_dual_basis();
        let profile = compile_binary_rank_one::<Gf4>(&[1, 2, 3], 0, 16).unwrap();
        let inner_dual = profile.inner_dual().unwrap();
        let (ordinary, target) = profile.cost_tables::<Gf4>().unwrap();
        let mut warm_cache =
            RankOneProbeCache::<Gf4>::new(&ordinary, &target, 43, 0, inner_dual.cost).unwrap();
        for _ in 0..repetitions {
            match variant.as_str() {
                "jin-fu:rust" => {
                    let answer = confinement_by_generators_field::<Gf4>(
                        &functional_dual_basis,
                        43,
                        &ordinary,
                        &target,
                        0,
                        inner_dual.cost,
                    )
                    .unwrap();
                    assert_eq!(answer.cost, 5);
                    assert_eq!(answer.nonzero_cost, Some(26));
                    work += answer.transitions;
                    checksum += u64::from(answer.cost);
                    black_box(answer);
                }
                "jin-fu:certificate" => {
                    let answer = certify_rank_one_transfer_by_generators_field::<Gf4>(
                        &functional_dual_basis,
                        43,
                        &ordinary,
                        &target,
                        0,
                        inner_dual.cost,
                        4,
                    )
                    .unwrap();
                    assert!(answer.transfers_completely);
                    work += answer.candidates_examined;
                    checksum += 5;
                    black_box(answer);
                }
                "jin-fu:cache-cold" => {
                    let mut cache =
                        RankOneProbeCache::<Gf4>::new(&ordinary, &target, 43, 0, inner_dual.cost)
                            .unwrap();
                    let answer = cache.context_cost_cached(&functional_dual_basis).unwrap();
                    assert_eq!(answer.cost, 5);
                    work += answer.work.outer_vectors;
                    peak_states = peak_states.max(cache.cached_probe_count() as u64);
                    checksum += u64::from(answer.cost);
                    black_box(answer);
                }
                "jin-fu:cache-warm" => {
                    let answer = warm_cache
                        .context_cost_cached(&functional_dual_basis)
                        .unwrap();
                    assert_eq!(answer.cost, 5);
                    work += answer.work.outer_vectors;
                    peak_states = peak_states.max(warm_cache.cached_probe_count() as u64);
                    checksum += u64::from(answer.cost);
                    black_box(answer);
                }
                "jin-fu:auto-one" | "jin-fu:auto-zero-budget" => {
                    let mut cache =
                        RankOneProbeCache::<Gf4>::new(&ordinary, &target, 43, 0, inner_dual.cost)
                            .unwrap();
                    let answer = cache
                        .context_cost_planned(
                            &functional_dual_basis,
                            ContextStrategy::Auto {
                                expected_queries: 1,
                                memory_budget_bytes: if variant == "jin-fu:auto-one" {
                                    usize::MAX
                                } else {
                                    0
                                },
                            },
                        )
                        .unwrap();
                    assert_eq!(answer.result.cost, 5);
                    work += answer
                        .result
                        .work
                        .outer_vectors
                        .max(answer.result.work.generator_candidates);
                    peak_states = peak_states.max(cache.cached_probe_count() as u64);
                    checksum += u64::from(answer.result.cost);
                    black_box(answer);
                }
                _ => unreachable!(),
            }
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, depth, fanout)) = transfer_tower_spec(&variant) {
        let normalization = Matrix::new::<2>(2, 2, vec![1, 0, 0, 1]).unwrap();
        let profile =
            compile_binary_target_subspace::<Gf4>(&[1, 2, 1, 2], &[0, 1], &normalization, 256, 16)
                .unwrap();
        let (ordinary, target) = profile.cost_tables::<Gf4>().unwrap();
        let levels = (0..depth)
            .map(|_| TowerLevel {
                outer_blocks: (0..fanout)
                    .map(|_| Matrix::new_field::<Gf4>(1, 1, vec![1]).unwrap())
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
                target_block: 0,
            })
            .collect::<Vec<_>>();
        let tower = CompositionTower::compile_field::<Gf4>(&ordinary, &target, &levels).unwrap();
        let label = Matrix::new_field::<Gf4>(1, 2, vec![0, 0]).unwrap();
        for _ in 0..repetitions {
            if backend == "rust-stream" {
                let mut visited = 0u64;
                let mut replay_checksum = 0u64;
                let answer = tower
                    .replay_target_witness_field::<Gf4>(&label, 1 << 30, |visit| {
                        visited += 1;
                        replay_checksum = replay_checksum
                            .wrapping_mul(0x9E37_79B1)
                            .wrapping_add(u64::from(visit.cost))
                            .wrapping_add(visit.level_from_base as u64)
                            .wrapping_add(visit.child_count as u64)
                            .wrapping_add(u64::from(visit.target_normalized))
                            .wrapping_add(
                                visit
                                    .label_data
                                    .iter()
                                    .fold(0u64, |sum, &entry| sum + u64::from(entry)),
                            );
                    })
                    .unwrap()
                    .unwrap();
                assert_eq!(visited, answer.witness_nodes);
                work += visited;
                peak_states = peak_states.max(visited);
                checksum = checksum.wrapping_add(replay_checksum);
                black_box(answer);
            } else {
                let answer = tower
                    .answer_target_field::<Gf4>(&label, 1 << 30)
                    .unwrap()
                    .unwrap();
                work += answer.witness_nodes;
                peak_states = peak_states.max(answer.witness_nodes);
                checksum = checksum.wrapping_add(u64::from(answer.cost));
                black_box(answer);
            }
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((family_count, option_count, width, seed)) = orbit_grid_spec(&variant) {
        let family_sizes = vec![option_count; family_count];
        let (families, target) = orbit_problem_with(&family_sizes, width, seed);
        for _ in 0..repetitions {
            let answer = ternary_orbit_syndrome_search(&families, &target, &[]).unwrap();
            work += answer.states_examined;
            peak_states = peak_states
                .max(answer.correlated_suffix_states)
                .max(u64::from(answer.memo_states));
            checksum = checksum.wrapping_add(answer.feasible() as u64);
            black_box(answer);
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, resources, capacity, demands)) =
        heterogeneous_scheduler_grid_spec(&variant)
    {
        let problem = heterogeneous_scheduler_problem_with(resources, capacity, demands);
        let planner_dense = problem.recommended_backend() == WeightedSchedulerBackend::DenseLattice;
        #[cfg(feature = "parallel")]
        let parallel_pool = backend.strip_prefix("parallel-").map(|threads| {
            rayon::ThreadPoolBuilder::new()
                .num_threads(threads.parse::<usize>().expect("invalid thread count"))
                .build()
                .unwrap()
        });
        for _ in 0..repetitions {
            let answer = if backend == "adaptive" {
                problem.solve_adaptive().unwrap()
            } else if backend.starts_with("parallel-") {
                #[cfg(feature = "parallel")]
                {
                    parallel_pool
                        .as_ref()
                        .expect("parallel pool was compiled")
                        .install(|| problem.solve_adaptive_parallel().unwrap())
                }
                #[cfg(not(feature = "parallel"))]
                panic!("parallel benchmark requires the parallel feature")
            } else {
                panic!("unknown heterogeneous scheduler backend")
            };
            work += answer.transitions_examined;
            peak_states = peak_states.max(u64::from(answer.peak_pareto_states));
            checksum = checksum.wrapping_add(answer.repaired_count() as u64);
            black_box(answer);
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum},\"planner_dense\":{planner_dense}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, resources, capacity, demands, options, seed)) =
        graded_scheduler_grid_spec(&variant)
    {
        let certified = backend.starts_with("graded-");
        let streaming = backend.starts_with("graded-stream");
        let problem = if streaming {
            assert_eq!(resources, 4, "streaming fixture has four resources");
            graded_scheduler_problem_streaming_4(capacity, demands, options, seed)
        } else {
            graded_scheduler_problem_with(resources, capacity, demands, options, seed, certified)
        };
        let planner_dense = problem.recommended_backend() == WeightedSchedulerBackend::DenseLattice;
        let mut workspace = WeightedRepairWorkspace::new();
        #[cfg(feature = "parallel")]
        let parallel_pool = backend
            .strip_prefix("graded-parallel-")
            .or_else(|| backend.strip_prefix("graded-stream-parallel-"))
            .map(|threads| {
                rayon::ThreadPoolBuilder::new()
                    .num_threads(threads.parse::<usize>().expect("invalid thread count"))
                    .build()
                    .unwrap()
            });
        for _ in 0..repetitions {
            let answer = match backend {
                "flat" | "graded-flat" => problem.solve().unwrap(),
                "dense" | "graded-dense" => problem.solve_dense_lattice().unwrap(),
                "adaptive" | "graded-adaptive" => problem.solve_adaptive().unwrap(),
                "graded-stream" => problem
                    .solve_adaptive_with_workspace(&mut workspace)
                    .unwrap(),
                "graded-dense-workspace" => problem
                    .solve_dense_lattice_with_workspace(&mut workspace)
                    .unwrap(),
                "graded-adaptive-workspace" => problem
                    .solve_adaptive_with_workspace(&mut workspace)
                    .unwrap(),
                backend
                    if backend.starts_with("graded-parallel-")
                        || backend.starts_with("graded-stream-parallel-") =>
                {
                    #[cfg(feature = "parallel")]
                    {
                        parallel_pool
                            .as_ref()
                            .expect("parallel pool was compiled")
                            .install(|| {
                                problem
                                    .solve_adaptive_parallel_with_workspace(&mut workspace)
                                    .unwrap()
                            })
                    }
                    #[cfg(not(feature = "parallel"))]
                    panic!("parallel benchmark requires the parallel feature")
                }
                _ => panic!("unknown graded scheduler grid backend"),
            };
            work += answer.transitions_examined;
            peak_states = peak_states.max(u64::from(answer.peak_pareto_states));
            checksum = checksum.wrapping_add(answer.repaired_count() as u64);
            black_box(answer);
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum},\"planner_dense\":{planner_dense},\"graded\":{certified}}}",
            peak_rss_kib()
        );
        return;
    }
    if let Some((backend, resources, capacity, demands, options, seed)) =
        scheduler_grid_spec(&variant)
    {
        let problem = scheduler_problem_with(resources, capacity, demands, options, seed);
        let planner_dense = problem.recommended_backend() == WeightedSchedulerBackend::DenseLattice;
        let mut workspace = WeightedRepairWorkspace::new();
        #[cfg(feature = "parallel")]
        let parallel_pool = backend.strip_prefix("parallel-workspace-").map(|threads| {
            rayon::ThreadPoolBuilder::new()
                .num_threads(threads.parse::<usize>().expect("invalid thread count"))
                .build()
                .unwrap()
        });
        for _ in 0..repetitions {
            let answer = match backend {
                "flat" => problem.solve().unwrap(),
                "flat-workspace" => problem.solve_sparse_with_workspace(&mut workspace).unwrap(),
                "dense" => problem.solve_dense_lattice().unwrap(),
                "adaptive" => problem.solve_adaptive().unwrap(),
                backend if backend.starts_with("parallel-workspace-") => {
                    #[cfg(feature = "parallel")]
                    {
                        parallel_pool
                            .as_ref()
                            .expect("parallel pool was compiled")
                            .install(|| {
                                problem
                                    .solve_sparse_parallel_with_workspace(&mut workspace)
                                    .unwrap()
                            })
                    }
                    #[cfg(not(feature = "parallel"))]
                    panic!("parallel benchmark requires the parallel feature")
                }
                _ => panic!("unknown scheduler grid backend"),
            };
            work += answer.transitions_examined;
            peak_states = peak_states.max(u64::from(answer.peak_pareto_states));
            checksum = checksum.wrapping_add(answer.repaired_count() as u64);
            black_box(answer);
        }
        let elapsed_ns = started.elapsed().as_nanos();
        println!(
            "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum},\"planner_dense\":{planner_dense}}}",
            peak_rss_kib()
        );
        return;
    }
    match variant.as_str() {
        "scheduler-flat"
        | "scheduler-mixed"
        | "scheduler-dense"
        | "scheduler-dense-unpacked"
        | "scheduler-dense-wide"
        | "scheduler-flat-small"
        | "scheduler-mixed-small"
        | "scheduler-dense-small" => {
            let small = variant.ends_with("-small");
            let problem = scheduler_problem(small);
            for _ in 0..repetitions {
                let answer = if variant.starts_with("scheduler-flat") {
                    problem.solve().unwrap()
                } else if variant.starts_with("scheduler-dense-unpacked") {
                    problem.solve_dense_lattice_unpacked().unwrap()
                } else if variant.starts_with("scheduler-dense-wide") {
                    problem.solve_dense_lattice_wide().unwrap()
                } else if variant.starts_with("scheduler-dense") {
                    problem.solve_dense_lattice().unwrap()
                } else {
                    problem.solve_mixed_radix().unwrap()
                };
                work += answer.transitions_examined;
                peak_states = peak_states.max(u64::from(answer.peak_pareto_states));
                checksum = checksum.wrapping_add(answer.repaired_count() as u64);
                black_box(answer);
            }
        }
        "orbit-coordinate"
        | "orbit-correlated"
        | "orbit-meet"
        | "orbit-meet-unreserved"
        | "orbit-split-count"
        | "orbit-split-balanced" => {
            let (families, target) = if variant.starts_with("orbit-split") {
                orbit_problem_with(&[2, 2, 2, 2, 2, 2, 64], 12, 0xA17E_5A17)
            } else {
                orbit_problem()
            };
            for _ in 0..repetitions {
                if variant.starts_with("orbit-meet") || variant.starts_with("orbit-split") {
                    let answer = if variant == "orbit-meet" || variant == "orbit-split-balanced" {
                        ternary_orbit_syndrome_meet_in_middle(&families, &target, &[]).unwrap()
                    } else if variant == "orbit-split-count" {
                        ternary_orbit_syndrome_meet_in_middle_count_split(&families, &target, &[])
                            .unwrap()
                    } else {
                        ternary_orbit_syndrome_meet_in_middle_unreserved(&families, &target, &[])
                            .unwrap()
                    };
                    work += answer.left_assignments + answer.right_assignments;
                    peak_states = peak_states.max(u64::from(answer.unique_right_states));
                    checksum = checksum.wrapping_add(answer.feasible() as u64);
                    black_box(answer);
                    continue;
                }
                let answer = if variant == "orbit-coordinate" {
                    ternary_orbit_syndrome_search(&families, &target, &[]).unwrap()
                } else {
                    ternary_orbit_syndrome_search_correlated(&families, &target, &[], 100_000)
                        .unwrap()
                };
                work += answer.states_examined;
                peak_states = peak_states
                    .max(answer.correlated_suffix_states)
                    .max(u64::from(answer.memo_states));
                checksum = checksum.wrapping_add(answer.feasible() as u64);
                black_box(answer);
            }
        }
        _ => panic!("unknown benchmark variant"),
    }
    let elapsed_ns = started.elapsed().as_nanos();
    println!(
        "{{\"variant\":\"{variant}\",\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"work\":{work},\"peak_states\":{peak_states},\"peak_rss_kib\":{},\"checksum\":{checksum}}}",
        peak_rss_kib()
    );
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::HashSet;

    #[test]
    fn gf4_hamming_basis_is_projective_and_simplex_constant_weight() {
        let dimension = 4;
        let basis = gf4_hamming_dual_basis(dimension);
        assert_eq!(basis.cols(), 85);
        let columns: HashSet<_> = (0..basis.cols())
            .map(|column| basis.column(column).into_vec())
            .collect();
        assert_eq!(columns.len(), basis.cols());
        assert!(columns.iter().all(|column| {
            column.iter().any(|&entry| entry != 0)
                && column.iter().find(|&&entry| entry != 0) == Some(&1)
        }));

        for packed in 1..4usize.pow(dimension as u32) {
            let mut weight = 0;
            for column in 0..basis.cols() {
                let mut value = 0;
                for row in 0..dimension {
                    value = Gf4::add(
                        value,
                        Gf4::mul((packed >> (2 * row)) as u8 & 3, basis.row(row)[column]),
                    );
                }
                weight += usize::from(value != 0);
            }
            assert_eq!(weight, 64);
        }
    }

    #[test]
    fn lcg_jump_matches_scalar_steps() {
        for steps in [0, 1, 2, 3, 17, 1_000, 1_000_000] {
            let mut scalar = 0xA17E_5EEDu64;
            for _ in 0..steps {
                next_u32(&mut scalar);
            }
            assert_eq!(advance_lcg(0xA17E_5EED, steps), scalar);
        }
    }

    #[test]
    fn streaming_fixture_matches_materialized_problem_and_witness() {
        let materialized = graded_scheduler_problem_with(4, 2, 80, 64, 2719080173, true);
        let streaming = graded_scheduler_problem_streaming_4(2, 80, 64, 2719080173);
        assert_eq!(
            streaming.solve_adaptive().unwrap(),
            materialized.solve_adaptive().unwrap()
        );
    }
}
