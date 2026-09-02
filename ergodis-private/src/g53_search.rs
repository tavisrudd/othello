//! Private heuristic search for the generator-53 order-2092 shard.
//!
//! The orbit and intersection identities are exact. Simulated-annealing move
//! selection is discovery-only and carries no negative-result authority.

use std::sync::atomic::{AtomicBool, Ordering};

use crate::g53_mod49_high_scout::{cached_g53_mod49_q7_lifts, G53Mod49Q7Lift};
use crate::g53_mod7_reduction::{
    cached_g53_mod7_q0_lift_bank, cached_g53_mod7_q0_lifts, G53Mod7Q0Lift,
};
use crate::g53_q0_diverse::{cached_g53_diverse_q0_lifts, cached_g53_q0_mod49_q7_sample};
use crate::g53_q4_profiles::compile_g53_q4_profiles;
use crate::hadamard_2092::{CyclicMultiplierOrbitPartition, Hadamard2092Error};

const CARRIER: usize = 522;
const ORBITS: usize = 50;
const NONZERO_SHIFT_ORBITS: usize = 49;
const BLOCKS: usize = 4;
const TARGET_INTERSECTION: i16 = 520;
const CLASS_CAPACITY: usize = 32;
// Orders 58 and 87 are implied by the full Z/18 quotient equations below.
// Orders 9 and 18 retain the independent quotient-58/q58 and quotient-29/q29
// zero-shift shells.
const SUBGROUP_ORDERS: [usize; 2] = [9, 18];
const SUBGROUP_COSETS: [usize; 2] = [58, 29];
const SUBGROUP_TARGETS: [i32; 2] = [5_203, 9_883];
const MAX_SUBGROUP_COSETS: usize = 58;
const QUOTIENT_ORDER: usize = 18;
const QUOTIENT_SHIFTS: usize = 10;
const QUOTIENT_TARGETS: [i32; QUOTIENT_SHIFTS] = [
    15_603, 15_080, 15_080, 15_080, 15_080, 15_080, 15_080, 15_080, 15_080, 15_080,
];

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct G53SearchConfig {
    pub seed: u64,
    pub iterations: u64,
    pub initial_shift_orbits: u8,
    pub shift_orbit_step: u8,
    pub initial_quotient_shifts: u8,
    pub quotient_shift_step: u8,
    pub advance_mean_square: u16,
    pub restart_after: u64,
    pub temperature: u64,
    /// Weight of two additional, nonredundant cyclic-subgroup energy
    /// identities. Zero disables them for counter A/B controls.
    pub subgroup_energy_weight: u32,
    /// Weight of the proved Z/18 quotient-PAF equations. Zero disables them
    /// for counter A/B controls.
    pub quotient_paf_weight: u32,
    /// A validated discovery seed satisfying every Z/18 quotient-PAF equation.
    /// It is only an input to heuristic search, never negative authority.
    pub initial_quotient_shell: Option<G53QuotientShell>,
    /// Directly replayed discovery checkpoint satisfying an exact leading
    /// quotient prefix. It grants no negative or certificate authority.
    pub initial_quotient_prefix: Option<G53QuotientPrefixSeed>,
    /// Stop as soon as the exact quotient shell is reached, before introducing
    /// subgroup or fine-PAF residuals. This separates shell mining from its
    /// subsequent fine search.
    pub stop_at_quotient_shell: bool,
    /// Number of failed restarts allowed from one exact-prefix checkpoint
    /// before bounded backtracking requests a different lower-prefix survivor.
    pub quotient_prefix_retry_limit: u8,
    /// Experimental interval for atomic cross-block ownership exchanges.
    /// Zero keeps the rejected counter disabled.
    pub cross_block_move_interval: u8,
    /// Experimental interval for defect-profile-preserving quotient-coordinate
    /// swaps. Zero disables the move for retained A/B controls.
    pub quotient_slot_swap_interval: u8,
    /// Initialize from and remain inside the independently replayed 2,496-state
    /// scale-one modular domain. This is an exact necessary filter.
    pub mod7_locked: bool,
    /// Initialize from one exact-row lift per mod-seven root whose q0--q6
    /// quotient residuals vanish modulo 49. Guidance only; moves need not
    /// preserve this stronger congruence.
    pub mod49_q7_seed: bool,
}

impl Default for G53SearchConfig {
    fn default() -> Self {
        Self {
            seed: 1,
            iterations: 1_000_000,
            initial_shift_orbits: 0,
            shift_orbit_step: 8,
            initial_quotient_shifts: 1,
            quotient_shift_step: 3,
            advance_mean_square: 8,
            restart_after: 250_000,
            temperature: 1,
            subgroup_energy_weight: 1,
            quotient_paf_weight: 1,
            initial_quotient_shell: None,
            initial_quotient_prefix: None,
            stop_at_quotient_shell: false,
            quotient_prefix_retry_limit: 3,
            cross_block_move_interval: 0,
            quotient_slot_swap_interval: 0,
            mod7_locked: false,
            mod49_q7_seed: false,
        }
    }
}

/// Fixed-size, orbit-indexed discovery seed for the proved Z/18 quotient
/// equations. Its construction and acceptance are private to this adapter;
/// it deliberately carries no certificate or negative-coverage meaning.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct G53QuotientShell {
    selected_orbits: [u64; BLOCKS],
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct G53QuotientPrefixSeed {
    pub selection: G53QuotientShell,
    pub exact_shifts: u8,
}

const _: () = assert!(std::mem::size_of::<G53QuotientShell>() == 32);

/// Internal search checkpoint. Unlike `G53QuotientShell`, this carries no
/// claim that all ten quotient equations hold; its exact prefix length remains
/// separate search state.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct OrbitSelectionSnapshot {
    selected_orbits: [u64; BLOCKS],
}

const _: () = assert!(std::mem::size_of::<OrbitSelectionSnapshot>() == 32);

impl G53QuotientShell {
    const HEX_BYTES: usize = BLOCKS * 16;

    /// Cold-path interchange format for an exact discovery seed.
    pub fn to_hex(self) -> String {
        self.selected_orbits
            .iter()
            .map(|word| format!("{word:016x}"))
            .collect()
    }

    /// Parse a fixed-size seed representation. Semantic validation occurs in
    /// the compiled g53 workspace before the seed can enter search.
    pub fn from_hex(text: &str) -> Result<Self, Hadamard2092Error> {
        if text.len() != Self::HEX_BYTES {
            return Err(Hadamard2092Error::FixedField);
        }
        let mut selected_orbits = [0_u64; BLOCKS];
        for (block, word) in selected_orbits.iter_mut().enumerate() {
            let begin = block * 16;
            let end = begin + 16;
            *word = u64::from_str_radix(&text[begin..end], 16)
                .map_err(|_| Hadamard2092Error::FixedField)?;
        }
        if selected_orbits.iter().any(|word| *word >> ORBITS != 0) {
            return Err(Hadamard2092Error::FixedField);
        }
        Ok(Self { selected_orbits })
    }
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct G53SearchOutcome {
    pub iterations: u64,
    pub restarts: u64,
    pub active_shift_orbits: u8,
    pub active_subgroup_identities: u8,
    pub active_quotient_shifts: u8,
    pub best_objective: i64,
    /// Residuals for the active quotient prefix; inactive suffix entries are
    /// canonical zeroes and carry no observational meaning.
    pub best_active_quotient_residuals: [i32; QUOTIENT_SHIFTS],
    /// Scale-one modular root associated with the best residual snapshot.
    pub best_mod7_root_masks: Option<[u16; BLOCKS]>,
    /// Fixed-width discovery seed associated with the best residual snapshot.
    pub best_quotient_selection: G53QuotientShell,
    /// Deepest prefix directly observed at exact zero during this run.
    pub deepest_exact_quotient_prefix: u8,
    pub deepest_exact_mod7_root_masks: Option<[u16; BLOCKS]>,
    pub deepest_exact_quotient_selection: G53QuotientShell,
    /// Discovery-only seed, emitted solely by `stop_at_quotient_shell`.
    pub quotient_shell: Option<G53QuotientShell>,
    pub witness: Option<Box<[[u8; CARRIER]; BLOCKS]>>,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct OrbitMove {
    remove: [u8; 2],
    add: [u8; 2],
    remove_len: u8,
    add_len: u8,
    reserved: [u8; 2],
}

const _: () = assert!(std::mem::size_of::<OrbitMove>() == 8);

const MOVE_SINGLE_BLOCK: u8 = 0;
const MOVE_CROSS_BLOCK: u8 = 1;
const MOVE_QUOTIENT_SLOT_SWAP: u8 = 2;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct SearchMove {
    first_block: u8,
    second_block: u8,
    remove: [u8; 2],
    add: [u8; 2],
    remove_len: u8,
    add_len: u8,
    kind: u8,
    reserved: [u8; 7],
}

const _: () = assert!(std::mem::size_of::<SearchMove>() == 16);

struct G53Workspace {
    orbit_offsets: [u16; ORBITS + 1],
    orbit_points: [u16; CARRIER],
    orbit_quotient_residues: [[u8; 2]; ORBITS],
    orbit_quotient_values: [[u8; 2]; ORBITS],
    orbit_quotient_lengths: [u8; ORBITS],
    quotient_family_orbits: [[u8; 5]; 10],
    shift_representatives: [u16; NONZERO_SHIFT_ORBITS],
    class_orbits: [[u8; CLASS_CAPACITY]; 4],
    class_lengths: [u8; 4],
    selected_orbits: [[bool; ORBITS]; BLOCKS],
    minus: [[u8; CARRIER]; BLOCKS],
    intersections: [i16; NONZERO_SHIFT_ORBITS],
    subgroup_counts: [[[u16; MAX_SUBGROUP_COSETS]; BLOCKS]; 2],
    subgroup_squares: [i32; 2],
    quotient_counts: [[u16; QUOTIENT_ORDER]; BLOCKS],
    quotient_paf: [i32; QUOTIENT_SHIFTS],
    mod7_q0_lifts: &'static [G53Mod7Q0Lift],
    mod49_q7_lifts: &'static [G53Mod49Q7Lift],
}

impl G53Workspace {
    fn compile() -> Result<Self, Hadamard2092Error> {
        let mod7_q0_lifts =
            cached_g53_mod7_q0_lifts().map_err(|_| Hadamard2092Error::FixedField)?;
        Self::compile_with_lifts(mod7_q0_lifts, &[])
    }

    fn compile_replay_only() -> Result<Self, Hadamard2092Error> {
        Self::compile_with_lifts(&[], &[])
    }

    fn compile_with_lifts(
        mod7_q0_lifts: &'static [G53Mod7Q0Lift],
        mod49_q7_lifts: &'static [G53Mod49Q7Lift],
    ) -> Result<Self, Hadamard2092Error> {
        let partition = CyclicMultiplierOrbitPartition::compile(CARRIER as u32, 53)?;
        if partition.orbit_count() as usize != ORBITS {
            return Err(Hadamard2092Error::FixedField);
        }
        let mut orbit_offsets = [0_u16; ORBITS + 1];
        for orbit in 0..ORBITS {
            orbit_offsets[orbit + 1] = orbit_offsets[orbit] + partition.orbit_sizes()[orbit] as u16;
        }
        let mut cursors = orbit_offsets;
        let mut orbit_points = [0_u16; CARRIER];
        for point in 0..CARRIER {
            let orbit = partition.orbit_ids()[point] as usize;
            orbit_points[cursors[orbit] as usize] = point as u16;
            cursors[orbit] += 1;
        }
        let mut shift_representatives = [0_u16; NONZERO_SHIFT_ORBITS];
        let mut shift = 0_usize;
        for &representative in partition.representatives() {
            if representative != 0 {
                shift_representatives[shift] = representative as u16;
                shift += 1;
            }
        }
        if shift != NONZERO_SHIFT_ORBITS {
            return Err(Hadamard2092Error::FixedField);
        }
        let mut orbit_quotient_residues = [[0_u8; 2]; ORBITS];
        let mut orbit_quotient_values = [[0_u8; 2]; ORBITS];
        let mut orbit_quotient_lengths = [0_u8; ORBITS];
        for orbit in 0..ORBITS {
            let mut histogram = [0_u8; QUOTIENT_ORDER];
            for position in usize::from(orbit_offsets[orbit])..usize::from(orbit_offsets[orbit + 1])
            {
                histogram[usize::from(orbit_points[position]) % QUOTIENT_ORDER] += 1;
            }
            for (residue, value) in histogram.into_iter().enumerate() {
                if value == 0 {
                    continue;
                }
                let index = usize::from(orbit_quotient_lengths[orbit]);
                if index == 2 {
                    return Err(Hadamard2092Error::FixedField);
                }
                orbit_quotient_residues[orbit][index] = residue as u8;
                orbit_quotient_values[orbit][index] = value;
                orbit_quotient_lengths[orbit] += 1;
            }
        }
        let mut quotient_family_orbits = [[u8::MAX; 5]; 10];
        let mut quotient_family_lengths = [0_u8; 10];
        for orbit in 0..ORBITS {
            let length = usize::from(orbit_quotient_lengths[orbit]);
            let first_residue = usize::from(orbit_quotient_residues[orbit][0]);
            let slot = first_residue.min(QUOTIENT_ORDER - first_residue);
            if slot >= quotient_family_orbits.len() || length == 0 {
                return Err(Hadamard2092Error::FixedField);
            }
            let scale = orbit_quotient_values[orbit][0];
            if (0..length).any(|index| orbit_quotient_values[orbit][index] != scale) {
                return Err(Hadamard2092Error::FixedField);
            }
            let family = if scale == 1 {
                0
            } else if scale == 7 {
                1 + usize::from(quotient_family_lengths[slot])
            } else {
                return Err(Hadamard2092Error::FixedField);
            };
            if family >= 5 || quotient_family_orbits[slot][family] != u8::MAX {
                return Err(Hadamard2092Error::FixedField);
            }
            quotient_family_orbits[slot][family] = orbit as u8;
            if scale == 7 {
                quotient_family_lengths[slot] += 1;
            }
        }
        if quotient_family_lengths != [4; 10]
            || quotient_family_orbits
                .iter()
                .flatten()
                .any(|&orbit| orbit == u8::MAX)
        {
            return Err(Hadamard2092Error::FixedField);
        }
        let mut class_orbits = [[0_u8; CLASS_CAPACITY]; 4];
        let mut class_lengths = [0_u8; 4];
        for (orbit, &size) in partition.orbit_sizes().iter().enumerate() {
            let class = match size {
                1 => 0,
                2 => 1,
                7 => 2,
                14 => 3,
                _ => return Err(Hadamard2092Error::FixedField),
            };
            let index = usize::from(class_lengths[class]);
            if index == CLASS_CAPACITY {
                return Err(Hadamard2092Error::StateBudget);
            }
            class_orbits[class][index] = orbit as u8;
            class_lengths[class] += 1;
        }
        if class_lengths != [2, 8, 8, 32] {
            return Err(Hadamard2092Error::FixedField);
        }
        Ok(Self {
            orbit_offsets,
            orbit_points,
            orbit_quotient_residues,
            orbit_quotient_values,
            orbit_quotient_lengths,
            quotient_family_orbits,
            shift_representatives,
            class_orbits,
            class_lengths,
            selected_orbits: [[false; ORBITS]; BLOCKS],
            minus: [[0; CARRIER]; BLOCKS],
            intersections: [0; NONZERO_SHIFT_ORBITS],
            subgroup_counts: [[[0; MAX_SUBGROUP_COSETS]; BLOCKS]; 2],
            subgroup_squares: [0; 2],
            quotient_counts: [[0; QUOTIENT_ORDER]; BLOCKS],
            quotient_paf: [0; QUOTIENT_SHIFTS],
            mod7_q0_lifts,
            mod49_q7_lifts,
        })
    }

    fn initialize(&mut self, random: &mut SplitMix64) {
        self.selected_orbits.fill([false; ORBITS]);
        for block in 0..BLOCKS {
            let target = if block == 0 { 260 } else { 261 };
            let counts = self.random_class_counts(target, random);
            for class in 0..4 {
                let length = usize::from(self.class_lengths[class]);
                let mut shuffled = self.class_orbits[class];
                for index in (1..length).rev() {
                    let other = random.index(index + 1);
                    shuffled.swap(index, other);
                }
                for &orbit in &shuffled[..usize::from(counts[class])] {
                    self.selected_orbits[block][usize::from(orbit)] = true;
                }
            }
        }
        self.materialize_selected_orbits();
    }

    fn initialize_mod7_locked(&mut self, random: &mut SplitMix64) {
        let lift = self.mod7_q0_lifts[random.index(self.mod7_q0_lifts.len())];
        self.load_mod7_lift(lift);
    }

    fn load_mod7_lift(&mut self, lift: G53Mod7Q0Lift) {
        self.selected_orbits.fill([false; ORBITS]);
        for block in 0..BLOCKS {
            let mask = lift.scale_one_masks[block];
            for slot in 0..10 {
                if mask & (1 << slot) != 0 {
                    self.selected_orbits[block]
                        [usize::from(self.quotient_family_orbits[slot][0])] = true;
                }
                let scale_seven = usize::from(lift.scale_seven_count(block, slot));
                for family in 1..=scale_seven {
                    self.selected_orbits[block]
                        [usize::from(self.quotient_family_orbits[slot][family])] = true;
                }
            }
        }
        self.materialize_selected_orbits();
    }

    fn current_mod7_lift(&self) -> G53Mod7Q0Lift {
        const POWERS: [u32; 10] = [
            1, 5, 25, 125, 625, 3_125, 15_625, 78_125, 390_625, 1_953_125,
        ];
        let mut masks = [0_u16; BLOCKS];
        let mut digits = [0_u32; BLOCKS];
        for block in 0..BLOCKS {
            for slot in 0..10 {
                let scale_one = usize::from(self.quotient_family_orbits[slot][0]);
                masks[block] |= u16::from(self.selected_orbits[block][scale_one]) << slot;
                let mut count = 0_u32;
                for family in 1..5 {
                    count += u32::from(
                        self.selected_orbits[block]
                            [usize::from(self.quotient_family_orbits[slot][family])],
                    );
                }
                digits[block] += count * POWERS[slot];
            }
        }
        G53Mod7Q0Lift {
            scale_one_masks: masks,
            scale_seven_digits: digits,
        }
    }

    fn initialize_mod49_q7(&mut self, random: &mut SplitMix64) {
        self.selected_orbits.fill([false; ORBITS]);
        let lift = self.mod49_q7_lifts[random.index(self.mod49_q7_lifts.len())];
        for block in 0..BLOCKS {
            let mask = lift.scale_one_masks[block];
            for slot in 0..10 {
                if mask & (1 << slot) != 0 {
                    self.selected_orbits[block]
                        [usize::from(self.quotient_family_orbits[slot][0])] = true;
                }
                let scale_seven = usize::from(lift.scale_seven_count(block, slot));
                for family in 1..=scale_seven {
                    self.selected_orbits[block]
                        [usize::from(self.quotient_family_orbits[slot][family])] = true;
                }
            }
        }
        self.materialize_selected_orbits();
    }

    fn initialize_for_search(
        &mut self,
        mod7_locked: bool,
        mod49_q7_seed: bool,
        random: &mut SplitMix64,
    ) {
        if mod49_q7_seed {
            self.initialize_mod49_q7(random);
        } else if mod7_locked {
            self.initialize_mod7_locked(random);
        } else {
            self.initialize(random);
        }
    }

    fn load_quotient_shell(&mut self, shell: G53QuotientShell) {
        self.load_selection_snapshot(OrbitSelectionSnapshot {
            selected_orbits: shell.selected_orbits,
        });
    }

    fn load_selection_snapshot(&mut self, snapshot: OrbitSelectionSnapshot) {
        for block in 0..BLOCKS {
            for orbit in 0..ORBITS {
                self.selected_orbits[block][orbit] =
                    snapshot.selected_orbits[block] & (1_u64 << orbit) != 0;
            }
        }
        self.materialize_selected_orbits();
    }

    fn selection_snapshot(&self) -> OrbitSelectionSnapshot {
        let mut selected_orbits = [0_u64; BLOCKS];
        for (block, word) in selected_orbits.iter_mut().enumerate() {
            for orbit in 0..ORBITS {
                if self.selected_orbits[block][orbit] {
                    *word |= 1_u64 << orbit;
                }
            }
        }
        OrbitSelectionSnapshot { selected_orbits }
    }

    fn selection_seed(&self) -> G53QuotientShell {
        G53QuotientShell {
            selected_orbits: self.selection_snapshot().selected_orbits,
        }
    }

    fn restart_quotient_prefix(
        &mut self,
        initial_quotient: usize,
        active_quotient: usize,
        retry_limit: u8,
        mod7_locked: bool,
        mod49_q7_seed: bool,
        checkpoints: &mut [Option<OrbitSelectionSnapshot>; QUOTIENT_SHIFTS + 1],
        retries: &mut [u8; QUOTIENT_SHIFTS + 1],
        random: &mut SplitMix64,
    ) -> usize {
        if let Some(snapshot) = checkpoints[active_quotient] {
            if retries[active_quotient] < retry_limit {
                retries[active_quotient] += 1;
                self.load_selection_snapshot(snapshot);
                return active_quotient;
            }
            checkpoints[active_quotient] = None;
            retries[active_quotient] = 0;
        }
        for stage in (initial_quotient + 1..active_quotient).rev() {
            if let Some(snapshot) = checkpoints[stage] {
                self.load_selection_snapshot(snapshot);
                return stage;
            }
        }
        self.initialize_for_search(mod7_locked, mod49_q7_seed, random);
        initial_quotient
    }

    fn materialize_selected_orbits(&mut self) {
        self.minus.fill([0; CARRIER]);
        for block in 0..BLOCKS {
            for orbit in 0..ORBITS {
                if !self.selected_orbits[block][orbit] {
                    continue;
                }
                let start = usize::from(self.orbit_offsets[orbit]);
                let end = usize::from(self.orbit_offsets[orbit + 1]);
                for position in start..end {
                    self.minus[block][usize::from(self.orbit_points[position])] = 1;
                }
            }
        }
    }

    /// Direct cold-path verification, deliberately separate from the cached
    /// quotient objective used by the mutation kernel.
    fn direct_quotient_prefix_valid(&self, active_shifts: usize) -> bool {
        if active_shifts == 0 || active_shifts > QUOTIENT_SHIFTS {
            return false;
        }
        if self.minus[0]
            .iter()
            .map(|&value| usize::from(value))
            .sum::<usize>()
            != 260
            || self.minus[1..]
                .iter()
                .any(|block| block.iter().map(|&value| usize::from(value)).sum::<usize>() != 261)
        {
            return false;
        }
        let mut counts = [[0_u16; QUOTIENT_ORDER]; BLOCKS];
        for (block, row) in self.minus.iter().enumerate() {
            for (point, &selected) in row.iter().enumerate() {
                counts[block][point % QUOTIENT_ORDER] += u16::from(selected);
            }
        }
        for shift in 0..active_shifts {
            let mut value = 0_u32;
            for block_counts in counts {
                for residue in 0..QUOTIENT_ORDER {
                    value += u32::from(
                        block_counts[residue] * block_counts[(residue + shift) % QUOTIENT_ORDER],
                    );
                }
            }
            if value != QUOTIENT_TARGETS[shift] as u32 {
                return false;
            }
        }
        true
    }

    fn direct_quotient_shell_valid(&self) -> bool {
        self.direct_quotient_prefix_valid(QUOTIENT_SHIFTS)
    }

    fn quotient_shell(&self) -> Option<G53QuotientShell> {
        if !self.direct_quotient_shell_valid() {
            return None;
        }
        Some(G53QuotientShell {
            selected_orbits: self.selection_snapshot().selected_orbits,
        })
    }

    fn random_class_counts(&self, target: u16, random: &mut SplitMix64) -> [u8; 4] {
        loop {
            let singles = random.index(3) as u16;
            let pairs = random.index(9) as u16;
            let septets = random.index(9) as u16;
            let partial = singles + 2 * pairs + 7 * septets;
            let Some(remaining) = target.checked_sub(partial) else {
                continue;
            };
            if remaining % 14 == 0 && remaining / 14 <= 32 {
                return [
                    singles as u8,
                    pairs as u8,
                    septets as u8,
                    (remaining / 14) as u8,
                ];
            }
        }
    }

    fn recompute_intersections(
        &mut self,
        active: usize,
        active_subgroups: usize,
        active_quotient: usize,
        subgroup_weight: u32,
        quotient_weight: u32,
    ) -> i64 {
        for shift_index in 0..active {
            let shift = usize::from(self.shift_representatives[shift_index]);
            let mut total = 0_i16;
            for block in 0..BLOCKS {
                for point in 0..CARRIER {
                    let forward = point + shift;
                    let forward = if forward >= CARRIER {
                        forward - CARRIER
                    } else {
                        forward
                    };
                    total += i16::from(self.minus[block][point] * self.minus[block][forward]);
                }
            }
            self.intersections[shift_index] = total;
        }
        self.recompute_subgroup_squares();
        self.recompute_quotient_paf();
        self.objective(
            active,
            active_subgroups,
            active_quotient,
            subgroup_weight,
            quotient_weight,
        )
    }

    fn objective(
        &self,
        active: usize,
        active_subgroups: usize,
        active_quotient: usize,
        subgroup_weight: u32,
        quotient_weight: u32,
    ) -> i64 {
        let paf = self.intersections[..active]
            .iter()
            .map(|&value| {
                let residual = i64::from(value - TARGET_INTERSECTION);
                residual * residual
            })
            .sum::<i64>();
        let subgroup = self.subgroup_squares[..active_subgroups]
            .iter()
            .zip(SUBGROUP_TARGETS)
            .map(|(&value, target)| {
                let residual = i64::from(value - target);
                residual * residual
            })
            .sum::<i64>();
        let quotient = self.quotient_paf[..active_quotient]
            .iter()
            .zip(QUOTIENT_TARGETS)
            .map(|(&value, target)| {
                let residual = i64::from(value - target);
                residual * residual
            })
            .sum::<i64>();
        paf + i64::from(subgroup_weight) * subgroup + i64::from(quotient_weight) * quotient
    }

    fn recompute_subgroup_squares(&mut self) {
        self.subgroup_counts
            .fill([[0; MAX_SUBGROUP_COSETS]; BLOCKS]);
        self.subgroup_squares.fill(0);
        for group in 0..SUBGROUP_ORDERS.len() {
            let cosets = SUBGROUP_COSETS[group];
            for block in 0..BLOCKS {
                for point in 0..CARRIER {
                    self.subgroup_counts[group][block][point % cosets] +=
                        u16::from(self.minus[block][point]);
                }
                for &count in &self.subgroup_counts[group][block][..cosets] {
                    self.subgroup_squares[group] += i32::from(count) * i32::from(count);
                }
            }
        }
    }

    fn recompute_quotient_paf(&mut self) {
        self.quotient_counts.fill([0; QUOTIENT_ORDER]);
        self.quotient_paf.fill(0);
        for block in 0..BLOCKS {
            for point in 0..CARRIER {
                self.quotient_counts[block][point % QUOTIENT_ORDER] +=
                    u16::from(self.minus[block][point]);
            }
            for shift in 0..QUOTIENT_SHIFTS {
                for residue in 0..QUOTIENT_ORDER {
                    self.quotient_paf[shift] += i32::from(
                        self.quotient_counts[block][residue]
                            * self.quotient_counts[block][(residue + shift) % QUOTIENT_ORDER],
                    );
                }
            }
        }
    }

    fn active_quotient_residuals(&self, active: usize) -> [i32; QUOTIENT_SHIFTS] {
        std::array::from_fn(|shift| {
            if shift < active {
                self.quotient_paf[shift] - QUOTIENT_TARGETS[shift]
            } else {
                0
            }
        })
    }

    fn mod7_root_masks(&self) -> [u16; BLOCKS] {
        std::array::from_fn(|block| {
            let mut mask = 0_u16;
            for slot in 0..10 {
                let orbit = usize::from(self.quotient_family_orbits[slot][0]);
                mask |= u16::from(self.selected_orbits[block][orbit]) << slot;
            }
            mask
        })
    }

    fn flip_orbit(
        &mut self,
        block: usize,
        orbit: usize,
        active: usize,
        active_subgroups: usize,
        active_quotient: usize,
        subgroup_weight: u32,
        quotient_weight: u32,
        objective: &mut i64,
    ) {
        let start = usize::from(self.orbit_offsets[orbit]);
        let end = usize::from(self.orbit_offsets[orbit + 1]);
        let direction = if self.minus[block][usize::from(self.orbit_points[start])] == 0 {
            1_i32
        } else {
            -1_i32
        };
        self.flip_quotient_orbit(
            block,
            orbit,
            direction,
            active_quotient,
            quotient_weight,
            objective,
        );
        for position in start..end {
            self.flip_point(
                block,
                usize::from(self.orbit_points[position]),
                active,
                active_subgroups,
                subgroup_weight,
                objective,
            );
        }
    }

    fn flip_quotient_orbit(
        &mut self,
        block: usize,
        orbit: usize,
        direction: i32,
        active_quotient: usize,
        quotient_weight: u32,
        objective: &mut i64,
    ) {
        let length = usize::from(self.orbit_quotient_lengths[orbit]);
        for shift in 0..active_quotient {
            let mut cross = 0_i32;
            let mut self_correlation = 0_i32;
            for index in 0..length {
                let residue = usize::from(self.orbit_quotient_residues[orbit][index]);
                let value = i32::from(self.orbit_quotient_values[orbit][index]);
                let forward = (residue + shift) % QUOTIENT_ORDER;
                let backward = (residue + QUOTIENT_ORDER - shift) % QUOTIENT_ORDER;
                cross += value
                    * i32::from(
                        self.quotient_counts[block][forward]
                            + self.quotient_counts[block][backward],
                    );
                for other in 0..length {
                    if usize::from(self.orbit_quotient_residues[orbit][other]) == forward {
                        self_correlation +=
                            value * i32::from(self.orbit_quotient_values[orbit][other]);
                    }
                }
            }
            let delta = direction * cross + self_correlation;
            let prior_paf = self.quotient_paf[shift];
            let next_paf = prior_paf + delta;
            let prior_residual = i64::from(prior_paf - QUOTIENT_TARGETS[shift]);
            let next_residual = i64::from(next_paf - QUOTIENT_TARGETS[shift]);
            *objective += i64::from(quotient_weight)
                * (next_residual * next_residual - prior_residual * prior_residual);
            self.quotient_paf[shift] = next_paf;
        }
        for index in 0..length {
            let residue = usize::from(self.orbit_quotient_residues[orbit][index]);
            let prior = i32::from(self.quotient_counts[block][residue]);
            self.quotient_counts[block][residue] =
                (prior + direction * i32::from(self.orbit_quotient_values[orbit][index])) as u16;
        }
    }

    fn flip_point(
        &mut self,
        block: usize,
        point: usize,
        active: usize,
        active_subgroups: usize,
        subgroup_weight: u32,
        objective: &mut i64,
    ) {
        let old = self.minus[block][point];
        let direction = if old == 0 { 1_i16 } else { -1_i16 };
        for shift_index in 0..active {
            let shift = usize::from(self.shift_representatives[shift_index]);
            let forward_index = point + shift;
            let forward_index = if forward_index >= CARRIER {
                forward_index - CARRIER
            } else {
                forward_index
            };
            let backward_index = if point >= shift {
                point - shift
            } else {
                point + CARRIER - shift
            };
            let forward = self.minus[block][forward_index];
            let backward = self.minus[block][backward_index];
            let delta = direction * i16::from(forward + backward);
            let prior = self.intersections[shift_index];
            let next = prior + delta;
            let prior_residual = i64::from(prior - TARGET_INTERSECTION);
            let next_residual = i64::from(next - TARGET_INTERSECTION);
            *objective += next_residual * next_residual - prior_residual * prior_residual;
            self.intersections[shift_index] = next;
        }
        for group in 0..active_subgroups {
            let coset = point % SUBGROUP_COSETS[group];
            let prior_count = i32::from(self.subgroup_counts[group][block][coset]);
            let next_count = prior_count + i32::from(direction);
            let prior_square_sum = self.subgroup_squares[group];
            let next_square_sum =
                prior_square_sum + next_count * next_count - prior_count * prior_count;
            let prior_residual = i64::from(prior_square_sum - SUBGROUP_TARGETS[group]);
            let next_residual = i64::from(next_square_sum - SUBGROUP_TARGETS[group]);
            *objective += i64::from(subgroup_weight)
                * (next_residual * next_residual - prior_residual * prior_residual);
            self.subgroup_counts[group][block][coset] = next_count as u16;
            self.subgroup_squares[group] = next_square_sum;
        }
        self.minus[block][point] ^= 1;
    }

    fn choose_swap(&self, block: usize, random: &mut SplitMix64) -> Option<(usize, usize)> {
        let first_class = random.index(4);
        for offset in 0..4 {
            let class = (first_class + offset) & 3;
            let length = usize::from(self.class_lengths[class]);
            let mut selected = None;
            let mut unselected = None;
            let first_orbit = random.index(length);
            for offset in 0..length {
                let orbit = usize::from(self.class_orbits[class][(first_orbit + offset) % length]);
                if self.selected_orbits[block][orbit] {
                    selected = Some(orbit);
                } else {
                    unselected = Some(orbit);
                }
                if selected.is_some() && unselected.is_some() {
                    return selected.zip(unselected);
                }
            }
        }
        None
    }

    fn choose_search_move(
        &self,
        cross_block_move_interval: u8,
        quotient_slot_swap_interval: u8,
        mod7_locked: bool,
        random: &mut SplitMix64,
    ) -> Option<SearchMove> {
        if mod7_locked {
            if quotient_slot_swap_interval != 0
                && random.index(usize::from(quotient_slot_swap_interval)) == 0
            {
                if let Some(movement) = self.choose_quotient_slot_swap(true, random) {
                    return Some(movement);
                }
            }
            if cross_block_move_interval != 0
                && random.index(usize::from(cross_block_move_interval)) == 0
            {
                if let Some(movement) = self.choose_cross_block_move(true, random) {
                    return Some(movement);
                }
            }
            let block = random.index(BLOCKS);
            let movement = self.choose_mod7_locked_move(block, random)?;
            return Some(SearchMove {
                first_block: block as u8,
                second_block: 0,
                remove: movement.remove,
                add: movement.add,
                remove_len: movement.remove_len,
                add_len: movement.add_len,
                kind: MOVE_SINGLE_BLOCK,
                reserved: [0; 7],
            });
        }
        if quotient_slot_swap_interval != 0
            && random.index(usize::from(quotient_slot_swap_interval)) == 0
        {
            if let Some(movement) = self.choose_quotient_slot_swap(false, random) {
                return Some(movement);
            }
        }
        if cross_block_move_interval != 0
            && random.index(usize::from(cross_block_move_interval)) == 0
        {
            if let Some(movement) = self.choose_cross_block_move(false, random) {
                return Some(movement);
            }
        }
        let block = random.index(BLOCKS);
        let movement = self.choose_move(block, random)?;
        Some(SearchMove {
            first_block: block as u8,
            second_block: 0,
            remove: movement.remove,
            add: movement.add,
            remove_len: movement.remove_len,
            add_len: movement.add_len,
            kind: MOVE_SINGLE_BLOCK,
            reserved: [0; 7],
        })
    }

    fn choose_mod7_locked_move(&self, block: usize, random: &mut SplitMix64) -> Option<OrbitMove> {
        if random.next() & 3 == 0 {
            let remove_small = random.next() & 1 == 0;
            if let Some(composition) = self.choose_composition_move(block, 2, remove_small, random)
            {
                return Some(composition);
            }
        }
        let first_class = 2 + random.index(2);
        for offset in 0..2 {
            let class = 2 + ((first_class - 2 + offset) & 1);
            let length = usize::from(self.class_lengths[class]);
            let start = random.index(length);
            let mut selected = None;
            let mut unselected = None;
            for orbit_offset in 0..length {
                let orbit = usize::from(self.class_orbits[class][(start + orbit_offset) % length]);
                if self.selected_orbits[block][orbit] {
                    selected = Some(orbit);
                } else {
                    unselected = Some(orbit);
                }
                if let (Some(remove), Some(add)) = (selected, unselected) {
                    return Some(OrbitMove {
                        remove: [remove as u8, 0],
                        add: [add as u8, 0],
                        remove_len: 1,
                        add_len: 1,
                        reserved: [0; 2],
                    });
                }
            }
        }
        None
    }

    fn choose_cross_block_move(
        &self,
        preserve_mod7_roots: bool,
        random: &mut SplitMix64,
    ) -> Option<SearchMove> {
        let first_block = random.index(BLOCKS);
        let second_block = (first_block + 1 + random.index(BLOCKS - 1)) % BLOCKS;
        let class_count = if preserve_mod7_roots { 2 } else { 4 };
        let class_base = if preserve_mod7_roots { 2 } else { 0 };
        let first_class = random.index(class_count);
        for class_offset in 0..class_count {
            let class = class_base + (first_class + class_offset) % class_count;
            let length = usize::from(self.class_lengths[class]);
            let start = random.index(length);
            let mut from_first = None;
            let mut from_second = None;
            for orbit_offset in 0..length {
                let orbit = usize::from(self.class_orbits[class][(start + orbit_offset) % length]);
                match (
                    self.selected_orbits[first_block][orbit],
                    self.selected_orbits[second_block][orbit],
                ) {
                    (true, false) => from_first = Some(orbit as u8),
                    (false, true) => from_second = Some(orbit as u8),
                    _ => {}
                }
                if let (Some(remove), Some(add)) = (from_first, from_second) {
                    return Some(SearchMove {
                        first_block: first_block as u8,
                        second_block: second_block as u8,
                        remove: [remove, 0],
                        add: [add, 0],
                        remove_len: 1,
                        add_len: 1,
                        kind: MOVE_CROSS_BLOCK,
                        reserved: [0; 7],
                    });
                }
            }
        }
        None
    }

    fn choose_quotient_slot_swap(
        &self,
        preserve_mod7_root: bool,
        random: &mut SplitMix64,
    ) -> Option<SearchMove> {
        for _ in 0..16 {
            let block = random.index(BLOCKS);
            let (first_slot, second_slot) = if random.next() & 7 == 0 {
                (0_usize, 9_usize)
            } else {
                let first = 1 + random.index(8);
                let mut second = 1 + random.index(7);
                if second >= first {
                    second += 1;
                }
                (first, second)
            };
            let mut mask = 0_u8;
            let first_scale_one = usize::from(self.quotient_family_orbits[first_slot][0]);
            let second_scale_one = usize::from(self.quotient_family_orbits[second_slot][0]);
            if preserve_mod7_root
                && self.selected_orbits[block][first_scale_one]
                    != self.selected_orbits[block][second_scale_one]
            {
                continue;
            }
            for family in 0..5 {
                let first_orbit = usize::from(self.quotient_family_orbits[first_slot][family]);
                let second_orbit = usize::from(self.quotient_family_orbits[second_slot][family]);
                if self.selected_orbits[block][first_orbit]
                    != self.selected_orbits[block][second_orbit]
                {
                    mask |= 1 << family;
                }
            }
            if mask != 0 {
                return Some(SearchMove {
                    first_block: block as u8,
                    second_block: 0,
                    remove: [first_slot as u8, mask],
                    add: [second_slot as u8, 0],
                    remove_len: 0,
                    add_len: 0,
                    kind: MOVE_QUOTIENT_SLOT_SWAP,
                    reserved: [0; 7],
                });
            }
        }
        None
    }

    fn apply_search_move(
        &mut self,
        movement: SearchMove,
        active: usize,
        active_subgroups: usize,
        active_quotient: usize,
        subgroup_weight: u32,
        quotient_weight: u32,
        objective: &mut i64,
    ) {
        if movement.kind == MOVE_QUOTIENT_SLOT_SWAP {
            let block = usize::from(movement.first_block);
            let first_slot = usize::from(movement.remove[0]);
            let second_slot = usize::from(movement.add[0]);
            let mask = movement.remove[1];
            for family in 0..5 {
                if mask & (1 << family) == 0 {
                    continue;
                }
                for slot in [first_slot, second_slot] {
                    self.flip_orbit(
                        block,
                        usize::from(self.quotient_family_orbits[slot][family]),
                        active,
                        active_subgroups,
                        active_quotient,
                        subgroup_weight,
                        quotient_weight,
                        objective,
                    );
                }
            }
            return;
        }
        let first = usize::from(movement.first_block);
        for &orbit in &movement.remove[..usize::from(movement.remove_len)] {
            self.flip_orbit(
                first,
                usize::from(orbit),
                active,
                active_subgroups,
                active_quotient,
                subgroup_weight,
                quotient_weight,
                objective,
            );
        }
        for &orbit in &movement.add[..usize::from(movement.add_len)] {
            self.flip_orbit(
                first,
                usize::from(orbit),
                active,
                active_subgroups,
                active_quotient,
                subgroup_weight,
                quotient_weight,
                objective,
            );
        }
        if movement.kind == MOVE_CROSS_BLOCK {
            let second = usize::from(movement.second_block);
            self.flip_orbit(
                second,
                usize::from(movement.add[0]),
                active,
                active_subgroups,
                active_quotient,
                subgroup_weight,
                quotient_weight,
                objective,
            );
            self.flip_orbit(
                second,
                usize::from(movement.remove[0]),
                active,
                active_subgroups,
                active_quotient,
                subgroup_weight,
                quotient_weight,
                objective,
            );
        }
    }

    fn commit_search_move(&mut self, movement: SearchMove) {
        if movement.kind == MOVE_QUOTIENT_SLOT_SWAP {
            let block = usize::from(movement.first_block);
            let first_slot = usize::from(movement.remove[0]);
            let second_slot = usize::from(movement.add[0]);
            let mask = movement.remove[1];
            for family in 0..5 {
                if mask & (1 << family) == 0 {
                    continue;
                }
                let first_orbit = usize::from(self.quotient_family_orbits[first_slot][family]);
                let second_orbit = usize::from(self.quotient_family_orbits[second_slot][family]);
                self.selected_orbits[block].swap(first_orbit, second_orbit);
            }
            return;
        }
        let first = usize::from(movement.first_block);
        for &orbit in &movement.remove[..usize::from(movement.remove_len)] {
            self.selected_orbits[first][usize::from(orbit)] = false;
        }
        for &orbit in &movement.add[..usize::from(movement.add_len)] {
            self.selected_orbits[first][usize::from(orbit)] = true;
        }
        if movement.kind == MOVE_CROSS_BLOCK {
            let second = usize::from(movement.second_block);
            self.selected_orbits[second][usize::from(movement.add[0])] = false;
            self.selected_orbits[second][usize::from(movement.remove[0])] = true;
        }
    }

    fn choose_move(&self, block: usize, random: &mut SplitMix64) -> Option<OrbitMove> {
        if random.next() & 3 == 0 {
            let small_class = if random.next() & 1 == 0 { 0 } else { 2 };
            let remove_small = random.next() & 1 == 0;
            if let Some(composition) =
                self.choose_composition_move(block, small_class, remove_small, random)
            {
                return Some(composition);
            }
        }
        let (remove, add) = self.choose_swap(block, random)?;
        Some(OrbitMove {
            remove: [remove as u8, 0],
            add: [add as u8, 0],
            remove_len: 1,
            add_len: 1,
            reserved: [0; 2],
        })
    }

    fn choose_composition_move(
        &self,
        block: usize,
        small_class: usize,
        remove_small: bool,
        random: &mut SplitMix64,
    ) -> Option<OrbitMove> {
        let large_class = small_class + 1;
        let (remove, remove_len, add, add_len) = if remove_small {
            (
                self.choose_two(block, small_class, true, random)?,
                2,
                [self.choose_one(block, large_class, false, random)? as u8, 0],
                1,
            )
        } else {
            (
                [self.choose_one(block, large_class, true, random)? as u8, 0],
                1,
                self.choose_two(block, small_class, false, random)?,
                2,
            )
        };
        Some(OrbitMove {
            remove,
            add,
            remove_len,
            add_len,
            reserved: [0; 2],
        })
    }

    fn choose_one(
        &self,
        block: usize,
        class: usize,
        selected: bool,
        random: &mut SplitMix64,
    ) -> Option<usize> {
        let length = usize::from(self.class_lengths[class]);
        let start = random.index(length);
        for offset in 0..length {
            let orbit = usize::from(self.class_orbits[class][(start + offset) % length]);
            if self.selected_orbits[block][orbit] == selected {
                return Some(orbit);
            }
        }
        None
    }

    fn choose_two(
        &self,
        block: usize,
        class: usize,
        selected: bool,
        random: &mut SplitMix64,
    ) -> Option<[u8; 2]> {
        let length = usize::from(self.class_lengths[class]);
        let start = random.index(length);
        let mut result = [0_u8; 2];
        let mut used = 0_usize;
        for offset in 0..length {
            let orbit = self.class_orbits[class][(start + offset) % length];
            if self.selected_orbits[block][usize::from(orbit)] == selected {
                result[used] = orbit;
                used += 1;
                if used == result.len() {
                    return Some(result);
                }
            }
        }
        None
    }

    fn direct_witness_valid(&self) -> bool {
        let expected = [260_usize, 261, 261, 261];
        if self
            .minus
            .iter()
            .zip(expected)
            .any(|(block, total)| block.iter().map(|&bit| usize::from(bit)).sum::<usize>() != total)
        {
            return false;
        }
        for shift in 1..CARRIER {
            let total = self
                .minus
                .iter()
                .map(|block| {
                    (0..CARRIER)
                        .map(|point| usize::from(block[point] * block[(point + shift) % CARRIER]))
                        .sum::<usize>()
                })
                .sum::<usize>();
            if total != usize::from(TARGET_INTERSECTION as u16) {
                return false;
            }
        }
        true
    }
}

#[derive(Clone, Copy)]
struct SplitMix64(u64);

impl SplitMix64 {
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9e37_79b9_7f4a_7c15);
        let mut value = self.0;
        value = (value ^ (value >> 30)).wrapping_mul(0xbf58_476d_1ce4_e5b9);
        value = (value ^ (value >> 27)).wrapping_mul(0x94d0_49bb_1331_11eb);
        value ^ (value >> 31)
    }

    fn index(&mut self, length: usize) -> usize {
        (self.next() as usize) % length
    }
}

pub struct G53SearchRunner {
    workspace: G53Workspace,
}

const Q4_REPAIR_MOVE_BUDGET: usize = 8_192;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q4RepairCandidate {
    movement: SearchMove,
    delta: [i32; 4],
}

const _: () = assert!(std::mem::size_of::<Q4RepairCandidate>() == 32);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Q4RepairPair {
    delta: [i16; 4],
    first: u16,
    second: u16,
    reserved: u32,
}

const _: () = assert!(std::mem::size_of::<Q4RepairPair>() == 16);
const Q4_REPAIR_PAIR_BUDGET: usize = 32_000_000;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct G53Q4RepairWitness {
    pub repaired_selection: G53QuotientShell,
    pub move_count: u8,
    pub blocks: [u8; 3],
    pub remove: [[u8; 2]; 3],
    pub add: [[u8; 2]; 3],
    pub lengths: [[u8; 2]; 3],
    pub deltas: [[i32; 4]; 3],
    pub full_quotient_residuals: [i32; QUOTIENT_SHIFTS],
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct G53Q7RepairWitness {
    pub repaired_selection: G53QuotientShell,
    pub move_count: u8,
    pub blocks: [u8; 4],
    pub remove: [u8; 4],
    pub add: [u8; 4],
    pub deltas: [[i32; 7]; 4],
    pub full_quotient_residuals: [i32; QUOTIENT_SHIFTS],
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct Q7RepairCandidate {
    movement: SearchMove,
    delta: [i32; 7],
}

const _: () = assert!(std::mem::size_of::<Q7RepairCandidate>() == 44);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Q7DeltaIndex {
    delta: [i16; 7],
    index: u16,
}

const _: () = assert!(std::mem::size_of::<Q7DeltaIndex>() == 16);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Q7RepairPair {
    delta: [i16; 7],
    first: u16,
    second: u16,
}

const _: () = assert!(std::mem::size_of::<Q7RepairPair>() == 18);

fn finish_q7_repair(
    workspace: &mut G53Workspace,
    objective: &mut i64,
    candidates: &[Q7RepairCandidate],
    indices: [usize; 4],
    move_count: usize,
    target_prefix: usize,
) -> Result<Option<G53Q7RepairWitness>, Hadamard2092Error> {
    let original = workspace.selection_seed();
    let mut blocks = [0_u8; 4];
    let mut remove = [0_u8; 4];
    let mut add = [0_u8; 4];
    let mut deltas = [[0_i32; 7]; 4];
    for step in 0..move_count {
        let candidate = candidates[indices[step]];
        workspace.apply_search_move(candidate.movement, 0, 0, target_prefix, 0, 1, objective);
        workspace.commit_search_move(candidate.movement);
        blocks[step] = candidate.movement.first_block;
        remove[step] = candidate.movement.remove[0];
        add[step] = candidate.movement.add[0];
        deltas[step] = candidate.delta;
    }
    workspace.recompute_quotient_paf();
    let full = workspace.active_quotient_residuals(QUOTIENT_SHIFTS);
    if full[..target_prefix].iter().any(|&value| value != 0)
        || !workspace.direct_quotient_prefix_valid(target_prefix)
    {
        workspace.load_quotient_shell(original);
        *objective = workspace.recompute_intersections(0, 0, target_prefix, 0, 1);
        return Ok(None);
    }
    Ok(Some(G53Q7RepairWitness {
        repaired_selection: workspace.selection_seed(),
        move_count: move_count as u8,
        blocks,
        remove,
        add,
        deltas,
        full_quotient_residuals: full,
    }))
}

fn push_q7_repair_candidate(
    workspace: &mut G53Workspace,
    objective: &mut i64,
    residual: [i32; QUOTIENT_SHIFTS],
    candidates: &mut Vec<Q7RepairCandidate>,
    movement: SearchMove,
    target_prefix: usize,
) -> Result<(), Hadamard2092Error> {
    if candidates.len() == Q4_REPAIR_MOVE_BUDGET {
        return Err(Hadamard2092Error::StateBudget);
    }
    workspace.apply_search_move(movement, 0, 0, target_prefix, 0, 1, objective);
    let after = workspace.active_quotient_residuals(target_prefix);
    workspace.apply_search_move(movement, 0, 0, target_prefix, 0, 1, objective);
    if workspace.active_quotient_residuals(target_prefix) != residual {
        return Err(Hadamard2092Error::FixedField);
    }
    candidates.push(Q7RepairCandidate {
        movement,
        delta: std::array::from_fn(|shift| after[shift] - residual[shift]),
    });
    Ok(())
}

/// Cross-block-additive four-move q7 repair scout from a directly replayed
/// q0--q3 prefix. A returned witness is exact; a miss has no authority over
/// same-block combinations and is bounded local evidence only.
pub fn repair_g53_quotient_prefix_with_four_moves(
    seed: G53QuotientShell,
    exact_input_prefix: u8,
    target_prefix: u8,
) -> Result<Option<G53Q7RepairWitness>, Hadamard2092Error> {
    let exact_input_prefix = usize::from(exact_input_prefix);
    let target_prefix = usize::from(target_prefix);
    if exact_input_prefix == 0 || exact_input_prefix >= target_prefix || target_prefix > 7 {
        return Err(Hadamard2092Error::FixedField);
    }
    let mut workspace = G53Workspace::compile_replay_only()?;
    workspace.load_quotient_shell(seed);
    if !workspace.direct_quotient_prefix_valid(exact_input_prefix) {
        return Err(Hadamard2092Error::FixedField);
    }
    let mut objective = workspace.recompute_intersections(0, 0, target_prefix, 0, 1);
    let residual = workspace.active_quotient_residuals(target_prefix);
    if residual[..exact_input_prefix]
        .iter()
        .any(|&value| value != 0)
    {
        return Err(Hadamard2092Error::FixedField);
    }
    let mut candidates = Vec::with_capacity(Q4_REPAIR_MOVE_BUDGET);
    for block in 0..BLOCKS {
        for class in 2..4 {
            let length = usize::from(workspace.class_lengths[class]);
            let orbits = workspace.class_orbits[class];
            for &remove in &orbits[..length] {
                if !workspace.selected_orbits[block][usize::from(remove)] {
                    continue;
                }
                for &add in &orbits[..length] {
                    if workspace.selected_orbits[block][usize::from(add)] {
                        continue;
                    }
                    let movement = SearchMove {
                        first_block: block as u8,
                        second_block: 0,
                        remove: [remove, 0],
                        add: [add, 0],
                        remove_len: 1,
                        add_len: 1,
                        kind: MOVE_SINGLE_BLOCK,
                        reserved: [0; 7],
                    };
                    push_q7_repair_candidate(
                        &mut workspace,
                        &mut objective,
                        residual,
                        &mut candidates,
                        movement,
                        target_prefix,
                    )?;
                }
            }
        }
        let small_length = usize::from(workspace.class_lengths[2]);
        let big_length = usize::from(workspace.class_lengths[3]);
        let small = workspace.class_orbits[2];
        let big = workspace.class_orbits[3];
        for &remove in &big[..big_length] {
            if !workspace.selected_orbits[block][usize::from(remove)] {
                continue;
            }
            for first in 0..small_length {
                let first_add = small[first];
                if workspace.selected_orbits[block][usize::from(first_add)] {
                    continue;
                }
                for &second_add in &small[first + 1..small_length] {
                    if workspace.selected_orbits[block][usize::from(second_add)] {
                        continue;
                    }
                    push_q7_repair_candidate(
                        &mut workspace,
                        &mut objective,
                        residual,
                        &mut candidates,
                        SearchMove {
                            first_block: block as u8,
                            second_block: 0,
                            remove: [remove, 0],
                            add: [first_add, second_add],
                            remove_len: 1,
                            add_len: 2,
                            kind: MOVE_SINGLE_BLOCK,
                            reserved: [0; 7],
                        },
                        target_prefix,
                    )?;
                }
            }
        }
        for first in 0..small_length {
            let first_remove = small[first];
            if !workspace.selected_orbits[block][usize::from(first_remove)] {
                continue;
            }
            for &second_remove in &small[first + 1..small_length] {
                if !workspace.selected_orbits[block][usize::from(second_remove)] {
                    continue;
                }
                for &add in &big[..big_length] {
                    if workspace.selected_orbits[block][usize::from(add)] {
                        continue;
                    }
                    push_q7_repair_candidate(
                        &mut workspace,
                        &mut objective,
                        residual,
                        &mut candidates,
                        SearchMove {
                            first_block: block as u8,
                            second_block: 0,
                            remove: [first_remove, second_remove],
                            add: [add, 0],
                            remove_len: 2,
                            add_len: 1,
                            kind: MOVE_SINGLE_BLOCK,
                            reserved: [0; 7],
                        },
                        target_prefix,
                    )?;
                }
            }
        }
        for first_slot in 0..workspace.quotient_family_orbits.len() {
            for second_slot in first_slot + 1..workspace.quotient_family_orbits.len() {
                let first_endpoint = first_slot == 0 || first_slot == 9;
                let second_endpoint = second_slot == 0 || second_slot == 9;
                if first_endpoint != second_endpoint {
                    continue;
                }
                let first_scale_one = usize::from(workspace.quotient_family_orbits[first_slot][0]);
                let second_scale_one =
                    usize::from(workspace.quotient_family_orbits[second_slot][0]);
                if workspace.selected_orbits[block][first_scale_one]
                    != workspace.selected_orbits[block][second_scale_one]
                {
                    continue;
                }
                let mut mask = 0_u8;
                for family in 1..5 {
                    let first_orbit =
                        usize::from(workspace.quotient_family_orbits[first_slot][family]);
                    let second_orbit =
                        usize::from(workspace.quotient_family_orbits[second_slot][family]);
                    if workspace.selected_orbits[block][first_orbit]
                        != workspace.selected_orbits[block][second_orbit]
                    {
                        mask |= 1 << family;
                    }
                }
                if mask == 0 {
                    continue;
                }
                push_q7_repair_candidate(
                    &mut workspace,
                    &mut objective,
                    residual,
                    &mut candidates,
                    SearchMove {
                        first_block: block as u8,
                        second_block: 0,
                        remove: [first_slot as u8, mask],
                        add: [second_slot as u8, 0],
                        remove_len: 0,
                        add_len: 0,
                        kind: MOVE_QUOTIENT_SLOT_SWAP,
                        reserved: [0; 7],
                    },
                    target_prefix,
                )?;
            }
        }
    }
    let target: [i32; 7] = std::array::from_fn(|shift| -residual[shift]);
    let mut delta_index = Vec::with_capacity(candidates.len());
    for (index, candidate) in candidates.iter().enumerate() {
        let mut delta = [0_i16; 7];
        for shift in 0..7 {
            delta[shift] =
                i16::try_from(candidate.delta[shift]).map_err(|_| Hadamard2092Error::FixedField)?;
        }
        delta_index.push(Q7DeltaIndex {
            delta,
            index: index as u16,
        });
    }
    delta_index.sort_unstable();
    for (first_index, first) in candidates.iter().enumerate() {
        let mut required = [0_i16; 7];
        let mut representable = true;
        for shift in 0..7 {
            let value = target[shift] - first.delta[shift];
            match i16::try_from(value) {
                Ok(value) => required[shift] = value,
                Err(_) => representable = false,
            }
        }
        if !representable {
            continue;
        }
        let begin = delta_index.partition_point(|entry| entry.delta < required);
        let end = delta_index.partition_point(|entry| entry.delta <= required);
        for entry in &delta_index[begin..end] {
            let second = &candidates[usize::from(entry.index)];
            if !repair_moves_compatible(first.movement, second.movement) {
                continue;
            }
            if let Some(witness) = finish_q7_repair(
                &mut workspace,
                &mut objective,
                &candidates,
                [first_index, usize::from(entry.index), 0, 0],
                2,
                target_prefix,
            )? {
                return Ok(Some(witness));
            }
        }
    }
    let mut pairs = Vec::with_capacity(candidates.len().saturating_mul(16).min(1_000_000));
    for first in 0..candidates.len() {
        for second in first + 1..candidates.len() {
            if !repair_moves_compatible(candidates[first].movement, candidates[second].movement) {
                continue;
            }
            if pairs.len() == Q4_REPAIR_PAIR_BUDGET {
                return Err(Hadamard2092Error::StateBudget);
            }
            let mut delta = [0_i16; 7];
            for shift in 0..7 {
                delta[shift] =
                    i16::try_from(candidates[first].delta[shift] + candidates[second].delta[shift])
                        .map_err(|_| Hadamard2092Error::FixedField)?;
            }
            pairs.push(Q7RepairPair {
                delta,
                first: first as u16,
                second: second as u16,
            });
        }
    }
    pairs.sort_unstable();
    for (third, candidate) in candidates.iter().enumerate() {
        let mut required = [0_i16; 7];
        let mut representable = true;
        for shift in 0..7 {
            match i16::try_from(target[shift] - candidate.delta[shift]) {
                Ok(value) => required[shift] = value,
                Err(_) => representable = false,
            }
        }
        if !representable {
            continue;
        }
        let begin = pairs.partition_point(|pair| pair.delta < required);
        let end = pairs.partition_point(|pair| pair.delta <= required);
        for pair in &pairs[begin..end] {
            let first = usize::from(pair.first);
            let second = usize::from(pair.second);
            if !repair_moves_compatible(candidates[first].movement, candidate.movement)
                || !repair_moves_compatible(candidates[second].movement, candidate.movement)
            {
                continue;
            }
            if let Some(witness) = finish_q7_repair(
                &mut workspace,
                &mut objective,
                &candidates,
                [first, second, third, 0],
                3,
                target_prefix,
            )? {
                return Ok(Some(witness));
            }
        }
    }
    for pair in &pairs {
        let mut required = [0_i16; 7];
        let mut representable = true;
        for shift in 0..7 {
            match i16::try_from(target[shift] - i32::from(pair.delta[shift])) {
                Ok(value) => required[shift] = value,
                Err(_) => representable = false,
            }
        }
        if !representable {
            continue;
        }
        let begin = pairs.partition_point(|candidate| candidate.delta < required);
        let end = pairs.partition_point(|candidate| candidate.delta <= required);
        for other in &pairs[begin..end] {
            let indices = [
                usize::from(pair.first),
                usize::from(pair.second),
                usize::from(other.first),
                usize::from(other.second),
            ];
            let mut compatible = true;
            for first in 0..indices.len() {
                for second in first + 1..indices.len() {
                    compatible &= repair_moves_compatible(
                        candidates[indices[first]].movement,
                        candidates[indices[second]].movement,
                    );
                }
            }
            if !compatible {
                continue;
            }
            if let Some(witness) = finish_q7_repair(
                &mut workspace,
                &mut objective,
                &candidates,
                indices,
                4,
                target_prefix,
            )? {
                return Ok(Some(witness));
            }
        }
    }
    Ok(None)
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct G53Q4HomometricSwitch {
    pub block: u8,
    pub prior_digits: u32,
    pub replacement_digits: u32,
    pub switched_selection: G53QuotientShell,
    pub full_quotient_residuals: [i32; QUOTIENT_SHIFTS],
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Q4DeltaProfile {
    delta: [i16; 4],
    digits: u32,
}

const _: () = assert!(std::mem::size_of::<Q4DeltaProfile>() == 12);

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct G53Q4TwoBlockSwitch {
    pub blocks: [u8; 2],
    pub prior_digits: [u32; 2],
    pub replacement_digits: [u32; 2],
    pub switched_selection: G53QuotientShell,
    pub full_quotient_residuals: [i32; QUOTIENT_SHIFTS],
    pub checked_matches: u32,
}

fn quotient_word_paf(mask: u16, digits: u32) -> [i32; QUOTIENT_SHIFTS] {
    const POWERS: [u32; 10] = [
        1, 5, 25, 125, 625, 3_125, 15_625, 78_125, 390_625, 1_953_125,
    ];
    let mut word = [0_u16; QUOTIENT_ORDER];
    for (slot, place) in POWERS.iter().enumerate() {
        let value = ((mask >> slot) & 1) + 7 * ((digits / place) % 5) as u16;
        word[slot] = value;
        if slot != 0 && slot != 9 {
            word[QUOTIENT_ORDER - slot] = value;
        }
    }
    std::array::from_fn(|shift| {
        (0..QUOTIENT_ORDER)
            .map(|position| i32::from(word[position] * word[(position + shift) % QUOTIENT_ORDER]))
            .sum()
    })
}

/// Find the best bounded two-block replacement whose q0--q3 profile deltas
/// cancel exactly. This is a discovery switch; the emitted prefix is replayed
/// directly and a miss has no coverage authority.
pub fn find_g53_q4_two_block_switch(
    seed: G53QuotientShell,
) -> Result<Option<G53Q4TwoBlockSwitch>, Hadamard2092Error> {
    const MATCH_BUDGET: u32 = 2_000_000;
    let mut workspace = G53Workspace::compile_replay_only()?;
    workspace.load_quotient_shell(seed);
    if !workspace.direct_quotient_prefix_valid(4) {
        return Err(Hadamard2092Error::FixedField);
    }
    workspace.recompute_quotient_paf();
    let original_residuals = workspace.active_quotient_residuals(QUOTIENT_SHIFTS);
    let original_score = original_residuals[4..7]
        .iter()
        .map(|&value| i64::from(value) * i64::from(value))
        .sum::<i64>();
    let lift = workspace.current_mod7_lift();
    let current_paf: [[i32; QUOTIENT_SHIFTS]; BLOCKS] = std::array::from_fn(|block| {
        quotient_word_paf(lift.scale_one_masks[block], lift.scale_seven_digits[block])
    });
    let mut profiles: [Option<Box<[crate::g53_q4_profiles::G53Q4Profile]>>; BLOCKS] =
        std::array::from_fn(|_| None);
    for block in 0..BLOCKS {
        profiles[block] = Some(
            compile_g53_q4_profiles(
                lift.scale_one_masks[block],
                if block == 0 { 260 } else { 261 },
            )
            .map_err(|_| Hadamard2092Error::FixedField)?,
        );
    }
    let mut right_index = Vec::<Q4DeltaProfile>::with_capacity(600_000);
    let mut checked = 0_u32;
    let mut best: Option<(i64, [usize; 2], [u32; 2], [i32; QUOTIENT_SHIFTS])> = None;
    'blocks: for left_block in 0..BLOCKS {
        for right_block in left_block + 1..BLOCKS {
            right_index.clear();
            for profile in profiles[right_block]
                .as_deref()
                .ok_or(Hadamard2092Error::FixedField)?
            {
                let mut delta = [0_i16; 4];
                for shift in 0..4 {
                    delta[shift] = i16::try_from(
                        i32::from(profile.paf[shift]) - current_paf[right_block][shift],
                    )
                    .map_err(|_| Hadamard2092Error::FixedField)?;
                }
                right_index.push(Q4DeltaProfile {
                    delta,
                    digits: profile.digits,
                });
            }
            right_index.sort_unstable();
            for left in profiles[left_block]
                .as_deref()
                .ok_or(Hadamard2092Error::FixedField)?
            {
                let mut required = [0_i16; 4];
                for shift in 0..4 {
                    required[shift] =
                        i16::try_from(current_paf[left_block][shift] - i32::from(left.paf[shift]))
                            .map_err(|_| Hadamard2092Error::FixedField)?;
                }
                let begin = right_index.partition_point(|entry| entry.delta < required);
                let end = right_index.partition_point(|entry| entry.delta <= required);
                for right in &right_index[begin..end] {
                    if left.digits == lift.scale_seven_digits[left_block]
                        && right.digits == lift.scale_seven_digits[right_block]
                    {
                        continue;
                    }
                    checked += 1;
                    if checked > MATCH_BUDGET {
                        break 'blocks;
                    }
                    let left_paf = quotient_word_paf(lift.scale_one_masks[left_block], left.digits);
                    let right_paf =
                        quotient_word_paf(lift.scale_one_masks[right_block], right.digits);
                    let residuals = std::array::from_fn(|shift| {
                        original_residuals[shift] + left_paf[shift] - current_paf[left_block][shift]
                            + right_paf[shift]
                            - current_paf[right_block][shift]
                    });
                    if residuals[..4] != [0; 4] {
                        return Err(Hadamard2092Error::FixedField);
                    }
                    let score = residuals[4..7]
                        .iter()
                        .map(|&value| i64::from(value) * i64::from(value))
                        .sum::<i64>();
                    if score < best.map_or(original_score, |entry| entry.0) {
                        best = Some((
                            score,
                            [left_block, right_block],
                            [left.digits, right.digits],
                            residuals,
                        ));
                        if score == 0 {
                            break 'blocks;
                        }
                    }
                }
            }
        }
    }
    let Some((_, blocks, replacements, expected)) = best else {
        return Ok(None);
    };
    let mut switched = lift;
    for index in 0..2 {
        switched.scale_seven_digits[blocks[index]] = replacements[index];
    }
    workspace.load_mod7_lift(switched);
    workspace.recompute_quotient_paf();
    let full = workspace.active_quotient_residuals(QUOTIENT_SHIFTS);
    if full != expected || full[..4] != [0; 4] || !workspace.direct_quotient_prefix_valid(4) {
        return Err(Hadamard2092Error::FixedField);
    }
    Ok(Some(G53Q4TwoBlockSwitch {
        blocks: [blocks[0] as u8, blocks[1] as u8],
        prior_digits: [
            lift.scale_seven_digits[blocks[0]],
            lift.scale_seven_digits[blocks[1]],
        ],
        replacement_digits: replacements,
        switched_selection: workspace.selection_seed(),
        full_quotient_residuals: full,
        checked_matches: checked,
    }))
}

/// Find a distinct block word with exactly the same q0--q3 autocorrelation.
/// The replacement is independently replayed against the four-block prefix.
pub fn find_g53_q4_homometric_switch(
    seed: G53QuotientShell,
) -> Result<Option<G53Q4HomometricSwitch>, Hadamard2092Error> {
    let mut workspace = G53Workspace::compile_replay_only()?;
    workspace.load_quotient_shell(seed);
    if !workspace.direct_quotient_prefix_valid(4) {
        return Err(Hadamard2092Error::FixedField);
    }
    workspace.recompute_intersections(0, 0, 4, 0, 1);
    let lift = workspace.current_mod7_lift();
    for block in 0..BLOCKS {
        let mut paf = [0_u16; 4];
        for shift in 0..4 {
            let mut value = 0_u32;
            for position in 0..QUOTIENT_ORDER {
                value += u32::from(
                    workspace.quotient_counts[block][position]
                        * workspace.quotient_counts[block][(position + shift) % QUOTIENT_ORDER],
                );
            }
            paf[shift] = u16::try_from(value).map_err(|_| Hadamard2092Error::FixedField)?;
        }
        let profiles = compile_g53_q4_profiles(
            lift.scale_one_masks[block],
            if block == 0 { 260 } else { 261 },
        )
        .map_err(|_| Hadamard2092Error::FixedField)?;
        let Ok(index) = profiles.binary_search_by_key(&paf, |profile| profile.paf) else {
            return Err(Hadamard2092Error::FixedField);
        };
        let replacement = profiles[index].digits;
        if replacement == lift.scale_seven_digits[block] {
            continue;
        }
        let mut switched = lift;
        switched.scale_seven_digits[block] = replacement;
        workspace.load_mod7_lift(switched);
        workspace.recompute_quotient_paf();
        let full = workspace.active_quotient_residuals(QUOTIENT_SHIFTS);
        if full[..4] != [0; 4] || !workspace.direct_quotient_prefix_valid(4) {
            return Err(Hadamard2092Error::FixedField);
        }
        return Ok(Some(G53Q4HomometricSwitch {
            block: block as u8,
            prior_digits: lift.scale_seven_digits[block],
            replacement_digits: replacement,
            switched_selection: workspace.selection_seed(),
            full_quotient_residuals: full,
        }));
    }
    Ok(None)
}

fn repair_moves_compatible(first: SearchMove, second: SearchMove) -> bool {
    // PAF deltas add across blocks. Two individually measured moves in one
    // block also have a quadratic cross term, even when their orbit edits are
    // disjoint, so the additive MITM key is unsound for that case.
    first.first_block != second.first_block
}

fn push_q4_repair_candidate(
    workspace: &mut G53Workspace,
    objective: &mut i64,
    residual: [i32; QUOTIENT_SHIFTS],
    candidates: &mut Vec<Q4RepairCandidate>,
    movement: SearchMove,
) -> Result<(), Hadamard2092Error> {
    if candidates.len() == Q4_REPAIR_MOVE_BUDGET {
        return Err(Hadamard2092Error::FixedField);
    }
    workspace.apply_search_move(movement, 0, 0, 4, 0, 1, objective);
    let after = workspace.active_quotient_residuals(4);
    workspace.apply_search_move(movement, 0, 0, 4, 0, 1, objective);
    if workspace.active_quotient_residuals(4) != residual {
        return Err(Hadamard2092Error::FixedField);
    }
    candidates.push(Q4RepairCandidate {
        movement,
        delta: std::array::from_fn(|shift| after[shift] - residual[shift]),
    });
    Ok(())
}

fn finish_q4_repair(
    workspace: &mut G53Workspace,
    objective: &mut i64,
    candidates: &[Q4RepairCandidate],
    indices: [usize; 3],
    move_count: usize,
) -> Result<Option<G53Q4RepairWitness>, Hadamard2092Error> {
    let original = workspace.selection_seed();
    let mut blocks = [0_u8; 3];
    let mut remove = [[0_u8; 2]; 3];
    let mut add = [[0_u8; 2]; 3];
    let mut lengths = [[0_u8; 2]; 3];
    let mut deltas = [[0_i32; 4]; 3];
    for step in 0..move_count {
        let candidate = candidates[indices[step]];
        workspace.apply_search_move(candidate.movement, 0, 0, 4, 0, 1, objective);
        workspace.commit_search_move(candidate.movement);
        blocks[step] = candidate.movement.first_block;
        remove[step] = candidate.movement.remove;
        add[step] = candidate.movement.add;
        lengths[step] = [candidate.movement.remove_len, candidate.movement.add_len];
        deltas[step] = candidate.delta;
    }
    workspace.recompute_quotient_paf();
    let full_quotient_residuals = workspace.active_quotient_residuals(QUOTIENT_SHIFTS);
    if full_quotient_residuals[..4] != [0; 4] {
        workspace.load_quotient_shell(original);
        *objective = workspace.recompute_intersections(0, 0, 4, 0, 1);
        return Ok(None);
    }
    for (block, row) in workspace.minus.iter().enumerate() {
        let weight = row.iter().copied().map(u16::from).sum::<u16>();
        if weight != if block == 0 { 260 } else { 261 } {
            workspace.load_quotient_shell(original);
            *objective = workspace.recompute_intersections(0, 0, 4, 0, 1);
            return Ok(None);
        }
    }
    Ok(Some(G53Q4RepairWitness {
        repaired_selection: workspace.selection_seed(),
        move_count: move_count as u8,
        blocks,
        remove,
        add,
        lengths,
        deltas,
        full_quotient_residuals,
    }))
}

/// Cross-block-additive local q4 repair scout. A returned seed is replayed
/// against all ten quotient equations; only q0--q3 are claimed repaired. A
/// miss has no exhaustive authority over same-block move combinations.
pub fn repair_g53_q4_selection(
    seed: G53QuotientShell,
) -> Result<Option<G53Q4RepairWitness>, Hadamard2092Error> {
    let mut workspace = G53Workspace::compile_replay_only()?;
    workspace.load_quotient_shell(seed);
    for (block, row) in workspace.minus.iter().enumerate() {
        let weight = row.iter().copied().map(u16::from).sum::<u16>();
        if weight != if block == 0 { 260 } else { 261 } {
            return Err(Hadamard2092Error::FixedField);
        }
    }
    let mut objective = workspace.recompute_intersections(0, 0, 4, 0, 1);
    let residual = workspace.active_quotient_residuals(4);
    if residual[..4].iter().any(|value| value.rem_euclid(7) != 0) {
        return Err(Hadamard2092Error::FixedField);
    }
    if objective == 0 {
        workspace.recompute_quotient_paf();
        return Ok(Some(G53Q4RepairWitness {
            repaired_selection: seed,
            move_count: 0,
            blocks: [0; 3],
            remove: [[0; 2]; 3],
            add: [[0; 2]; 3],
            lengths: [[0; 2]; 3],
            deltas: [[0; 4]; 3],
            full_quotient_residuals: workspace.active_quotient_residuals(QUOTIENT_SHIFTS),
        }));
    }
    let mut candidates = Vec::with_capacity(Q4_REPAIR_MOVE_BUDGET);
    for block in 0..BLOCKS {
        for class in 2..4 {
            let length = usize::from(workspace.class_lengths[class]);
            let orbits = workspace.class_orbits[class];
            for &remove in &orbits[..length] {
                if !workspace.selected_orbits[block][usize::from(remove)] {
                    continue;
                }
                for &add in &orbits[..length] {
                    if workspace.selected_orbits[block][usize::from(add)] {
                        continue;
                    }
                    let movement = SearchMove {
                        first_block: block as u8,
                        second_block: 0,
                        remove: [remove, 0],
                        add: [add, 0],
                        remove_len: 1,
                        add_len: 1,
                        kind: MOVE_SINGLE_BLOCK,
                        reserved: [0; 7],
                    };
                    push_q4_repair_candidate(
                        &mut workspace,
                        &mut objective,
                        residual,
                        &mut candidates,
                        movement,
                    )?;
                }
            }
        }
        let small_length = usize::from(workspace.class_lengths[2]);
        let big_length = usize::from(workspace.class_lengths[3]);
        let small = workspace.class_orbits[2];
        let big = workspace.class_orbits[3];
        for &remove in &big[..big_length] {
            if !workspace.selected_orbits[block][usize::from(remove)] {
                continue;
            }
            for first in 0..small_length {
                let first_add = small[first];
                if workspace.selected_orbits[block][usize::from(first_add)] {
                    continue;
                }
                for &second_add in &small[first + 1..small_length] {
                    if workspace.selected_orbits[block][usize::from(second_add)] {
                        continue;
                    }
                    push_q4_repair_candidate(
                        &mut workspace,
                        &mut objective,
                        residual,
                        &mut candidates,
                        SearchMove {
                            first_block: block as u8,
                            second_block: 0,
                            remove: [remove, 0],
                            add: [first_add, second_add],
                            remove_len: 1,
                            add_len: 2,
                            kind: MOVE_SINGLE_BLOCK,
                            reserved: [0; 7],
                        },
                    )?;
                }
            }
        }
        for first in 0..small_length {
            let first_remove = small[first];
            if !workspace.selected_orbits[block][usize::from(first_remove)] {
                continue;
            }
            for &second_remove in &small[first + 1..small_length] {
                if !workspace.selected_orbits[block][usize::from(second_remove)] {
                    continue;
                }
                for &add in &big[..big_length] {
                    if workspace.selected_orbits[block][usize::from(add)] {
                        continue;
                    }
                    push_q4_repair_candidate(
                        &mut workspace,
                        &mut objective,
                        residual,
                        &mut candidates,
                        SearchMove {
                            first_block: block as u8,
                            second_block: 0,
                            remove: [first_remove, second_remove],
                            add: [add, 0],
                            remove_len: 2,
                            add_len: 1,
                            kind: MOVE_SINGLE_BLOCK,
                            reserved: [0; 7],
                        },
                    )?;
                }
            }
        }
    }
    let target: [i32; 4] = std::array::from_fn(|shift| -residual[shift]);
    for (first_index, first) in candidates.iter().enumerate() {
        for (second_index, second) in candidates.iter().enumerate() {
            if !repair_moves_compatible(first.movement, second.movement)
                || (0..4).any(|shift| first.delta[shift] + second.delta[shift] != target[shift])
            {
                continue;
            }
            if let Some(witness) = finish_q4_repair(
                &mut workspace,
                &mut objective,
                &candidates,
                [first_index, second_index, 0],
                2,
            )? {
                return Ok(Some(witness));
            }
        }
    }
    let maximum_pairs = candidates
        .len()
        .checked_mul(candidates.len().saturating_sub(1))
        .and_then(|value| value.checked_div(2))
        .ok_or(Hadamard2092Error::FixedField)?;
    let mut pairs = Vec::with_capacity(maximum_pairs.min(Q4_REPAIR_PAIR_BUDGET));
    for first in 0..candidates.len() {
        for second in first + 1..candidates.len() {
            if !repair_moves_compatible(candidates[first].movement, candidates[second].movement) {
                continue;
            }
            if pairs.len() == Q4_REPAIR_PAIR_BUDGET {
                return Err(Hadamard2092Error::FixedField);
            }
            let mut delta = [0_i16; 4];
            for shift in 0..4 {
                delta[shift] =
                    i16::try_from(candidates[first].delta[shift] + candidates[second].delta[shift])
                        .map_err(|_| Hadamard2092Error::FixedField)?;
            }
            pairs.push(Q4RepairPair {
                delta,
                first: u16::try_from(first).map_err(|_| Hadamard2092Error::FixedField)?,
                second: u16::try_from(second).map_err(|_| Hadamard2092Error::FixedField)?,
                reserved: 0,
            });
        }
    }
    pairs.sort_unstable();
    for (third_index, third) in candidates.iter().enumerate() {
        let mut required = [0_i16; 4];
        let mut representable = true;
        for shift in 0..4 {
            let value = target[shift] - third.delta[shift];
            if let Ok(value) = i16::try_from(value) {
                required[shift] = value;
            } else {
                representable = false;
            }
        }
        if !representable {
            continue;
        }
        let begin = pairs.partition_point(|pair| pair.delta < required);
        let end = pairs.partition_point(|pair| pair.delta <= required);
        for pair in &pairs[begin..end] {
            let first_index = usize::from(pair.first);
            let second_index = usize::from(pair.second);
            if !repair_moves_compatible(candidates[first_index].movement, third.movement)
                || !repair_moves_compatible(candidates[second_index].movement, third.movement)
            {
                continue;
            }
            if let Some(witness) = finish_q4_repair(
                &mut workspace,
                &mut objective,
                &candidates,
                [first_index, second_index, third_index],
                3,
            )? {
                return Ok(Some(witness));
            }
        }
    }
    Ok(None)
}

impl G53SearchRunner {
    pub fn compile() -> Result<Self, Hadamard2092Error> {
        Ok(Self {
            workspace: G53Workspace::compile()?,
        })
    }

    /// Compile the rejected bounded eight-lift-per-modular-root control. The
    /// choice is made before search, so it adds no hot-loop branch.
    pub fn compile_with_q0_lift_bank() -> Result<Self, Hadamard2092Error> {
        let lifts = cached_g53_mod7_q0_lift_bank().map_err(|_| Hadamard2092Error::FixedField)?;
        Ok(Self {
            workspace: G53Workspace::compile_with_lifts(lifts, &[])?,
        })
    }

    /// Compile a bounded bank sampled across the exact block-energy fibres.
    /// This is discovery-only diversification; all seeds satisfy exact rows
    /// and q0, and the choice remains outside the mutation loop.
    pub fn compile_with_diverse_q0_bank() -> Result<Self, Hadamard2092Error> {
        let lifts = cached_g53_diverse_q0_lifts().map_err(|_| Hadamard2092Error::FixedField)?;
        Ok(Self {
            workspace: G53Workspace::compile_with_lifts(lifts, &[])?,
        })
    }

    /// Compile the directly replayed sample intersection of exact q0 with
    /// q1--q6 modulo 49.  This guides discovery only and cannot authorize a
    /// miss or certificate.
    pub fn compile_with_q0_mod49_sample() -> Result<Self, Hadamard2092Error> {
        let lifts = cached_g53_q0_mod49_q7_sample().map_err(|_| Hadamard2092Error::FixedField)?;
        Ok(Self {
            workspace: G53Workspace::compile_with_lifts(lifts, &[])?,
        })
    }

    /// Compile the exact-computational q0--q6 mod-49 initializer. It guides
    /// discovery but grants no pruning or negative-coverage authority.
    pub fn compile_with_mod49_q7_seed() -> Result<Self, Hadamard2092Error> {
        let mod7_lifts = cached_g53_mod7_q0_lifts().map_err(|_| Hadamard2092Error::FixedField)?;
        let mod49_lifts = cached_g53_mod49_q7_lifts().map_err(|_| Hadamard2092Error::FixedField)?;
        Ok(Self {
            workspace: G53Workspace::compile_with_lifts(mod7_lifts, mod49_lifts)?,
        })
    }

    /// Run the allocation-free mutation kernel. A successful witness is the
    /// only path that allocates, to transfer the four blocks to the caller.
    pub fn run(
        &mut self,
        config: G53SearchConfig,
        stop: &AtomicBool,
    ) -> Result<G53SearchOutcome, Hadamard2092Error> {
        if config.iterations == 0
            || usize::from(config.initial_shift_orbits) > NONZERO_SHIFT_ORBITS
            || config.shift_orbit_step == 0
            || config.initial_quotient_shifts == 0
            || usize::from(config.initial_quotient_shifts) > QUOTIENT_SHIFTS
            || config.quotient_shift_step == 0
            || config.advance_mean_square == 0
            || config.restart_after == 0
            || config.temperature == 0
            || config.quotient_prefix_retry_limit == 0
            || config.subgroup_energy_weight > 1_000_000
            || config.quotient_paf_weight > 1_000_000
            || (config.stop_at_quotient_shell
                && (config.initial_shift_orbits != 0
                    || config.subgroup_energy_weight != 0
                    || config.quotient_paf_weight == 0))
            || (config.initial_quotient_shell.is_some()
                && (config.stop_at_quotient_shell
                    || config.initial_quotient_shifts as usize != QUOTIENT_SHIFTS
                    || config.quotient_paf_weight == 0))
            || config.initial_quotient_prefix.is_some_and(|prefix| {
                config.initial_quotient_shell.is_some()
                    || !config.stop_at_quotient_shell
                    || prefix.exact_shifts == 0
                    || usize::from(prefix.exact_shifts) >= QUOTIENT_SHIFTS
                    || config.quotient_paf_weight == 0
            })
            || (config.mod7_locked
                && (!config.stop_at_quotient_shell || config.initial_quotient_shell.is_some()))
            || (config.mod49_q7_seed
                && (!config.mod7_locked || self.workspace.mod49_q7_lifts.is_empty()))
        {
            return Err(Hadamard2092Error::FixedField);
        }
        let mut random = SplitMix64(config.seed);
        if let Some(shell) = config.initial_quotient_shell {
            self.workspace.load_quotient_shell(shell);
            if !self.workspace.direct_quotient_shell_valid() {
                return Err(Hadamard2092Error::FixedField);
            }
        } else if let Some(prefix) = config.initial_quotient_prefix {
            self.workspace.load_quotient_shell(prefix.selection);
            if !self
                .workspace
                .direct_quotient_prefix_valid(usize::from(prefix.exact_shifts))
            {
                return Err(Hadamard2092Error::FixedField);
            }
        } else {
            self.workspace.initialize_for_search(
                config.mod7_locked,
                config.mod49_q7_seed,
                &mut random,
            );
        }
        let mut active = usize::from(config.initial_shift_orbits);
        let mut active_quotient = if config.quotient_paf_weight == 0 {
            0
        } else if let Some(prefix) = config.initial_quotient_prefix {
            (usize::from(prefix.exact_shifts) + usize::from(config.quotient_shift_step))
                .min(QUOTIENT_SHIFTS)
        } else {
            usize::from(config.initial_quotient_shifts)
        };
        let mut active_subgroups =
            if config.subgroup_energy_weight != 0 && active_quotient == QUOTIENT_SHIFTS {
                SUBGROUP_ORDERS.len()
            } else {
                0
            };
        let mut objective = self.workspace.recompute_intersections(
            active,
            active_subgroups,
            active_quotient,
            config.subgroup_energy_weight,
            config.quotient_paf_weight,
        );
        let mut best = objective;
        let mut best_active_quotient_residuals =
            self.workspace.active_quotient_residuals(active_quotient);
        let mut best_mod7_root_masks = config.mod7_locked.then(|| self.workspace.mod7_root_masks());
        let mut best_quotient_selection = self.workspace.selection_seed();
        let initial_residuals = self.workspace.active_quotient_residuals(active_quotient);
        let mut deepest_exact_quotient_prefix = initial_residuals[..active_quotient]
            .iter()
            .take_while(|&&value| value == 0)
            .count();
        let mut deepest_exact_quotient_selection = self.workspace.selection_seed();
        let mut deepest_exact_mod7_root_masks =
            config.mod7_locked.then(|| self.workspace.mod7_root_masks());
        let mut since_best = 0_u64;
        let mut restarts = 0_u64;
        let mut completed = 0_u64;
        let mut prefix_checkpoints = [None; QUOTIENT_SHIFTS + 1];
        let mut prefix_retries = [0_u8; QUOTIENT_SHIFTS + 1];
        if config.initial_quotient_prefix.is_some() {
            prefix_checkpoints[active_quotient] = Some(self.workspace.selection_snapshot());
        }

        while completed < config.iterations {
            if completed & 4095 == 0 && stop.load(Ordering::Relaxed) {
                break;
            }
            if config.stop_at_quotient_shell
                && active == 0
                && active_subgroups == 0
                && active_quotient == QUOTIENT_SHIFTS
            {
                if let Some(quotient_shell) = self.workspace.quotient_shell() {
                    return Ok(G53SearchOutcome {
                        iterations: completed,
                        restarts,
                        active_shift_orbits: 0,
                        active_subgroup_identities: 0,
                        active_quotient_shifts: QUOTIENT_SHIFTS as u8,
                        best_objective: 0,
                        best_active_quotient_residuals: self
                            .workspace
                            .active_quotient_residuals(QUOTIENT_SHIFTS),
                        best_mod7_root_masks: config
                            .mod7_locked
                            .then(|| self.workspace.mod7_root_masks()),
                        best_quotient_selection: self.workspace.selection_seed(),
                        deepest_exact_quotient_prefix: QUOTIENT_SHIFTS as u8,
                        deepest_exact_mod7_root_masks: config
                            .mod7_locked
                            .then(|| self.workspace.mod7_root_masks()),
                        deepest_exact_quotient_selection: self.workspace.selection_seed(),
                        quotient_shell: Some(quotient_shell),
                        witness: None,
                    });
                }
            }
            if objective == 0
                && active == NONZERO_SHIFT_ORBITS
                && active_quotient
                    == if config.quotient_paf_weight == 0 {
                        0
                    } else {
                        QUOTIENT_SHIFTS
                    }
                && active_subgroups
                    == if config.subgroup_energy_weight == 0 {
                        0
                    } else {
                        SUBGROUP_ORDERS.len()
                    }
            {
                if self.workspace.direct_witness_valid() {
                    stop.store(true, Ordering::Relaxed);
                    return Ok(G53SearchOutcome {
                        iterations: completed,
                        restarts,
                        active_shift_orbits: active as u8,
                        active_subgroup_identities: active_subgroups as u8,
                        active_quotient_shifts: active_quotient as u8,
                        best_objective: 0,
                        best_active_quotient_residuals: self
                            .workspace
                            .active_quotient_residuals(active_quotient),
                        best_mod7_root_masks: config
                            .mod7_locked
                            .then(|| self.workspace.mod7_root_masks()),
                        best_quotient_selection: self.workspace.selection_seed(),
                        deepest_exact_quotient_prefix: QUOTIENT_SHIFTS as u8,
                        deepest_exact_mod7_root_masks: config
                            .mod7_locked
                            .then(|| self.workspace.mod7_root_masks()),
                        deepest_exact_quotient_selection: self.workspace.selection_seed(),
                        quotient_shell: None,
                        witness: Some(Box::new(self.workspace.minus)),
                    });
                }
                return Err(Hadamard2092Error::FixedField);
            }
            // Curriculum graduation is heuristic and caller-tunable. The
            // final stage still requires exact zero and direct verification.
            let active_constraints = active + active_subgroups + active_quotient;
            let advance_threshold =
                i64::from(config.advance_mean_square) * active_constraints as i64;
            let ready_to_advance = if config.stop_at_quotient_shell {
                // Phase one follows the proved quotient hierarchy exactly:
                // every prefix remains a hard zero before another equation is
                // introduced. Fine PAF and subgroup constraints are disabled.
                objective == 0
            } else {
                objective <= advance_threshold
            };
            if ready_to_advance
                && (active_quotient < QUOTIENT_SHIFTS
                    || active_subgroups < SUBGROUP_ORDERS.len()
                    || active < NONZERO_SHIFT_ORBITS)
            {
                if active_quotient < QUOTIENT_SHIFTS {
                    let snapshot = self.workspace.selection_snapshot();
                    if active_quotient > deepest_exact_quotient_prefix {
                        deepest_exact_quotient_prefix = active_quotient;
                        deepest_exact_quotient_selection = self.workspace.selection_seed();
                        deepest_exact_mod7_root_masks =
                            config.mod7_locked.then(|| self.workspace.mod7_root_masks());
                    }
                    active_quotient = (active_quotient + usize::from(config.quotient_shift_step))
                        .min(QUOTIENT_SHIFTS);
                    if config.stop_at_quotient_shell {
                        prefix_checkpoints[active_quotient] = Some(snapshot);
                        prefix_retries[active_quotient] = 0;
                        prefix_checkpoints[active_quotient + 1..].fill(None);
                        prefix_retries[active_quotient + 1..].fill(0);
                    }
                } else if active_subgroups < SUBGROUP_ORDERS.len()
                    && config.subgroup_energy_weight != 0
                {
                    active_subgroups = SUBGROUP_ORDERS.len();
                } else if !config.stop_at_quotient_shell {
                    active =
                        (active + usize::from(config.shift_orbit_step)).min(NONZERO_SHIFT_ORBITS);
                } else {
                    // Exact full quotient zero is returned at the top of the
                    // next iteration after independent direct replay.
                    continue;
                }
                objective = self.workspace.recompute_intersections(
                    active,
                    active_subgroups,
                    active_quotient,
                    config.subgroup_energy_weight,
                    config.quotient_paf_weight,
                );
                best = objective;
                best_active_quotient_residuals =
                    self.workspace.active_quotient_residuals(active_quotient);
                best_mod7_root_masks = config.mod7_locked.then(|| self.workspace.mod7_root_masks());
                best_quotient_selection = self.workspace.selection_seed();
                since_best = 0;
                continue;
            }
            let Some(mutation) = self.workspace.choose_search_move(
                config.cross_block_move_interval,
                config.quotient_slot_swap_interval,
                config.mod7_locked,
                &mut random,
            ) else {
                let prior_quotient = active_quotient;
                if config.stop_at_quotient_shell {
                    active = 0;
                    if let Some(prefix) = config.initial_quotient_prefix {
                        self.workspace.load_quotient_shell(prefix.selection);
                        active_quotient = (usize::from(prefix.exact_shifts)
                            + usize::from(config.quotient_shift_step))
                        .min(QUOTIENT_SHIFTS);
                    } else {
                        active_quotient = self.workspace.restart_quotient_prefix(
                            usize::from(config.initial_quotient_shifts),
                            active_quotient,
                            config.quotient_prefix_retry_limit,
                            config.mod7_locked,
                            config.mod49_q7_seed,
                            &mut prefix_checkpoints,
                            &mut prefix_retries,
                            &mut random,
                        );
                    }
                    active_subgroups = 0;
                } else if let Some(shell) = config.initial_quotient_shell {
                    self.workspace.load_quotient_shell(shell);
                } else {
                    self.workspace.initialize_for_search(
                        config.mod7_locked,
                        config.mod49_q7_seed,
                        &mut random,
                    );
                }
                objective = self.workspace.recompute_intersections(
                    active,
                    active_subgroups,
                    active_quotient,
                    config.subgroup_energy_weight,
                    config.quotient_paf_weight,
                );
                if active_quotient != prior_quotient {
                    best = objective;
                    best_active_quotient_residuals =
                        self.workspace.active_quotient_residuals(active_quotient);
                    best_mod7_root_masks =
                        config.mod7_locked.then(|| self.workspace.mod7_root_masks());
                    best_quotient_selection = self.workspace.selection_seed();
                }
                since_best = 0;
                restarts += 1;
                continue;
            };
            let prior = objective;
            self.workspace.apply_search_move(
                mutation,
                active,
                active_subgroups,
                active_quotient,
                config.subgroup_energy_weight,
                config.quotient_paf_weight,
                &mut objective,
            );
            let accepted = if objective <= prior {
                true
            } else {
                let penalty = (objective - prior) as u64;
                random.next() % config.temperature.saturating_add(penalty) < config.temperature
            };
            if accepted {
                self.workspace.commit_search_move(mutation);
            } else {
                // Every candidate is a set of orbit toggles, so applying the
                // same fixed record twice is an exact involution.
                self.workspace.apply_search_move(
                    mutation,
                    active,
                    active_subgroups,
                    active_quotient,
                    config.subgroup_energy_weight,
                    config.quotient_paf_weight,
                    &mut objective,
                );
                debug_assert_eq!(objective, prior);
            }
            completed += 1;
            if objective < best {
                best = objective;
                best_active_quotient_residuals =
                    self.workspace.active_quotient_residuals(active_quotient);
                best_mod7_root_masks = config.mod7_locked.then(|| self.workspace.mod7_root_masks());
                best_quotient_selection = self.workspace.selection_seed();
                since_best = 0;
            } else {
                since_best += 1;
            }
            if since_best == config.restart_after {
                let prior_quotient = active_quotient;
                if config.stop_at_quotient_shell {
                    active = 0;
                    if let Some(prefix) = config.initial_quotient_prefix {
                        self.workspace.load_quotient_shell(prefix.selection);
                        active_quotient = (usize::from(prefix.exact_shifts)
                            + usize::from(config.quotient_shift_step))
                        .min(QUOTIENT_SHIFTS);
                    } else {
                        active_quotient = self.workspace.restart_quotient_prefix(
                            usize::from(config.initial_quotient_shifts),
                            active_quotient,
                            config.quotient_prefix_retry_limit,
                            config.mod7_locked,
                            config.mod49_q7_seed,
                            &mut prefix_checkpoints,
                            &mut prefix_retries,
                            &mut random,
                        );
                    }
                    active_subgroups = 0;
                } else if let Some(shell) = config.initial_quotient_shell {
                    self.workspace.load_quotient_shell(shell);
                    active = usize::from(config.initial_shift_orbits);
                    active_quotient = usize::from(config.initial_quotient_shifts);
                    active_subgroups = if config.subgroup_energy_weight != 0 {
                        SUBGROUP_ORDERS.len()
                    } else {
                        0
                    };
                } else {
                    self.workspace.initialize_for_search(
                        config.mod7_locked,
                        config.mod49_q7_seed,
                        &mut random,
                    );
                    active = usize::from(config.initial_shift_orbits);
                    active_quotient = if config.quotient_paf_weight == 0 {
                        0
                    } else {
                        usize::from(config.initial_quotient_shifts)
                    };
                    active_subgroups = if config.subgroup_energy_weight != 0
                        && active_quotient == QUOTIENT_SHIFTS
                    {
                        SUBGROUP_ORDERS.len()
                    } else {
                        0
                    };
                }
                objective = self.workspace.recompute_intersections(
                    active,
                    active_subgroups,
                    active_quotient,
                    config.subgroup_energy_weight,
                    config.quotient_paf_weight,
                );
                if active_quotient != prior_quotient || objective < best {
                    best = objective;
                    best_active_quotient_residuals =
                        self.workspace.active_quotient_residuals(active_quotient);
                    best_mod7_root_masks =
                        config.mod7_locked.then(|| self.workspace.mod7_root_masks());
                    best_quotient_selection = self.workspace.selection_seed();
                }
                since_best = 0;
                restarts += 1;
            }
        }
        Ok(G53SearchOutcome {
            iterations: completed,
            restarts,
            active_shift_orbits: active as u8,
            active_subgroup_identities: active_subgroups as u8,
            active_quotient_shifts: active_quotient as u8,
            best_objective: best,
            best_active_quotient_residuals,
            best_mod7_root_masks,
            best_quotient_selection,
            deepest_exact_quotient_prefix: deepest_exact_quotient_prefix as u8,
            deepest_exact_mod7_root_masks,
            deepest_exact_quotient_selection,
            quotient_shell: None,
            witness: None,
        })
    }
}

pub fn run_g53_heuristic_search(
    config: G53SearchConfig,
    stop: &AtomicBool,
) -> Result<G53SearchOutcome, Hadamard2092Error> {
    G53SearchRunner::compile()?.run(config, stop)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::quotient_paf_proof::{quotient_paf_into, QuotientPafInstance};
    use crate::subgroup_energy_proof::{coset_square_sum_into, SubgroupEnergyInstance};

    #[test]
    fn incremental_orbit_moves_match_direct_recomputation() {
        let mut workspace = G53Workspace::compile().unwrap();
        let mut random = SplitMix64(7);
        workspace.initialize(&mut random);
        let active = 16;
        let subgroup_weight = 1;
        let quotient_weight = 1;
        let active_subgroups = SUBGROUP_ORDERS.len();
        let active_quotient = QUOTIENT_SHIFTS;
        let mut objective = workspace.recompute_intersections(
            active,
            active_subgroups,
            active_quotient,
            subgroup_weight,
            quotient_weight,
        );
        let mut saw_composition_move = false;
        let mut saw_cross_block_move = false;
        let mut saw_quotient_slot_swap = false;
        for _ in 0..1_000 {
            let Some(mutation) = workspace.choose_search_move(4, 4, false, &mut random) else {
                continue;
            };
            let prior_zero_shift = workspace.quotient_paf[0];
            saw_composition_move |=
                mutation.kind == MOVE_SINGLE_BLOCK && mutation.remove_len != mutation.add_len;
            saw_cross_block_move |= mutation.kind == MOVE_CROSS_BLOCK;
            saw_quotient_slot_swap |= mutation.kind == MOVE_QUOTIENT_SLOT_SWAP;
            workspace.apply_search_move(
                mutation,
                active,
                active_subgroups,
                active_quotient,
                subgroup_weight,
                quotient_weight,
                &mut objective,
            );
            workspace.commit_search_move(mutation);
            if mutation.kind == MOVE_QUOTIENT_SLOT_SWAP {
                assert_eq!(workspace.quotient_paf[0], prior_zero_shift);
            }
            assert_eq!(
                objective,
                workspace.recompute_intersections(
                    active,
                    active_subgroups,
                    active_quotient,
                    subgroup_weight,
                    quotient_weight,
                )
            );
            for (block, row) in workspace.minus.iter().enumerate() {
                assert_eq!(
                    row.iter().map(|&bit| usize::from(bit)).sum::<usize>(),
                    if block == 0 { 260 } else { 261 }
                );
            }
        }
        assert!(saw_composition_move);
        assert!(saw_cross_block_move);
        assert!(saw_quotient_slot_swap);
    }

    #[test]
    fn root_scoped_coordinate_swaps_preserve_rows_mod7_and_q0() {
        let lifts = cached_g53_diverse_q0_lifts().unwrap();
        let mut workspace = G53Workspace::compile_with_lifts(lifts, &[]).unwrap();
        let mut random = SplitMix64(53_2092);
        workspace.initialize_mod7_locked(&mut random);
        let masks = workspace.mod7_root_masks();
        let mut objective = workspace.recompute_intersections(0, 0, 1, 0, 1);
        let q0 = workspace.quotient_paf[0];
        let mut exercised = 0_usize;
        for _ in 0..1_000 {
            let Some(movement) = workspace.choose_quotient_slot_swap(true, &mut random) else {
                continue;
            };
            workspace.apply_search_move(movement, 0, 0, 1, 0, 1, &mut objective);
            workspace.commit_search_move(movement);
            assert_eq!(workspace.mod7_root_masks(), masks);
            assert_eq!(workspace.quotient_paf[0], q0);
            assert_eq!(objective, 0);
            for (block, row) in workspace.minus.iter().enumerate() {
                assert_eq!(
                    row.iter().map(|&bit| usize::from(bit)).sum::<usize>(),
                    if block == 0 { 260 } else { 261 }
                );
            }
            exercised += 1;
        }
        assert!(exercised > 0);
    }

    #[test]
    fn root_scoped_cross_block_moves_preserve_rows_and_mod7() {
        let mut workspace = G53Workspace::compile().unwrap();
        let mut random = SplitMix64(53_49_2092);
        workspace.initialize_mod7_locked(&mut random);
        let masks = workspace.mod7_root_masks();
        let mut objective = workspace.recompute_intersections(0, 0, 7, 0, 1);
        let mut exercised = 0_usize;
        for _ in 0..1_000 {
            let Some(movement) = workspace.choose_cross_block_move(true, &mut random) else {
                continue;
            };
            workspace.apply_search_move(movement, 0, 0, 7, 0, 1, &mut objective);
            workspace.commit_search_move(movement);
            assert_eq!(workspace.mod7_root_masks(), masks);
            assert_eq!(objective, workspace.recompute_intersections(0, 0, 7, 0, 1));
            for (block, row) in workspace.minus.iter().enumerate() {
                assert_eq!(
                    row.iter().map(|&bit| usize::from(bit)).sum::<usize>(),
                    if block == 0 { 260 } else { 261 }
                );
            }
            exercised += 1;
        }
        assert!(exercised > 0);
    }

    #[test]
    fn bounded_search_preserves_row_counts() {
        let stop = AtomicBool::new(false);
        let outcome = run_g53_heuristic_search(
            G53SearchConfig {
                iterations: 1_000,
                ..G53SearchConfig::default()
            },
            &stop,
        )
        .unwrap();
        assert_eq!(outcome.iterations, 1_000);
        assert!(outcome.best_objective >= 0);
    }

    #[test]
    fn quotient_shell_encoding_is_fixed_width_and_rejects_out_of_range_bits() {
        let shell = G53QuotientShell {
            selected_orbits: [1, 1 << 17, 1 << 49, 0],
        };
        let text = shell.to_hex();
        assert_eq!(text.len(), G53QuotientShell::HEX_BYTES);
        assert_eq!(G53QuotientShell::from_hex(&text).unwrap(), shell);
        assert!(G53QuotientShell::from_hex(&text[..63]).is_err());
        assert!(G53QuotientShell::from_hex(
            "0004000000000000000000000000000000000000000000000000000000000000"
        )
        .is_err());
    }

    #[test]
    fn exact_prefix_seed_is_replayed_and_malformed_seed_rejected() {
        let selection = G53QuotientShell::from_hex(
            "0000d7bdff022804000251e77627148e00031bffd8aa404200036a60a256707e",
        )
        .unwrap();
        let stop = AtomicBool::new(false);
        let config = G53SearchConfig {
            iterations: 1_000,
            initial_shift_orbits: 0,
            initial_quotient_shifts: 1,
            quotient_shift_step: 3,
            subgroup_energy_weight: 0,
            stop_at_quotient_shell: true,
            mod7_locked: true,
            initial_quotient_prefix: Some(G53QuotientPrefixSeed {
                selection,
                exact_shifts: 4,
            }),
            ..G53SearchConfig::default()
        };
        let outcome = G53SearchRunner::compile()
            .unwrap()
            .run(config, &stop)
            .unwrap();
        assert!(outcome.deepest_exact_quotient_prefix >= 4);
        assert_eq!(outcome.active_quotient_shifts, 7);

        let mut malformed = config;
        let mut words = selection.selected_orbits;
        words[0] ^= 1;
        malformed.initial_quotient_prefix = Some(G53QuotientPrefixSeed {
            selection: G53QuotientShell {
                selected_orbits: words,
            },
            exact_shifts: 4,
        });
        assert!(G53SearchRunner::compile()
            .unwrap()
            .run(malformed, &stop)
            .is_err());
    }

    #[test]
    fn malformed_quotient_shell_fails_closed_before_search() {
        let stop = AtomicBool::new(false);
        let outcome = run_g53_heuristic_search(
            G53SearchConfig {
                iterations: 1,
                initial_quotient_shifts: QUOTIENT_SHIFTS as u8,
                initial_quotient_shell: Some(G53QuotientShell {
                    selected_orbits: [0; BLOCKS],
                }),
                ..G53SearchConfig::default()
            },
            &stop,
        );
        assert_eq!(outcome.unwrap_err(), Hadamard2092Error::FixedField);
    }

    #[test]
    fn quotient_shell_mining_accepts_an_exact_staged_prefix() {
        let stop = AtomicBool::new(false);
        let outcome = run_g53_heuristic_search(
            G53SearchConfig {
                iterations: 100,
                initial_shift_orbits: 0,
                initial_quotient_shifts: 1,
                subgroup_energy_weight: 0,
                stop_at_quotient_shell: true,
                ..G53SearchConfig::default()
            },
            &stop,
        )
        .unwrap();
        assert_eq!(outcome.iterations, 100);
        assert_eq!(outcome.active_shift_orbits, 0);
        assert_eq!(outcome.active_subgroup_identities, 0);
        assert!((1..=QUOTIENT_SHIFTS as u8).contains(&outcome.active_quotient_shifts));
    }

    #[test]
    fn shell_round_trip_preserves_the_orbit_selection_exactly() {
        let mut workspace = G53Workspace::compile().unwrap();
        workspace.initialize(&mut SplitMix64(2092));
        let original = workspace.selected_orbits;
        let mut selected_orbits = [0_u64; BLOCKS];
        for (block, word) in selected_orbits.iter_mut().enumerate() {
            for orbit in 0..ORBITS {
                if original[block][orbit] {
                    *word |= 1_u64 << orbit;
                }
            }
        }
        workspace.load_quotient_shell(G53QuotientShell { selected_orbits });
        assert_eq!(workspace.selected_orbits, original);
        for (block, row) in workspace.minus.iter().enumerate() {
            assert_eq!(
                row.iter().map(|&value| usize::from(value)).sum::<usize>(),
                if block == 0 { 260 } else { 261 }
            );
        }
    }

    #[test]
    fn prefix_checkpoint_retries_then_backtracks_boundedly() {
        let mut workspace = G53Workspace::compile().unwrap();
        let mut random = SplitMix64(53);
        workspace.initialize(&mut random);
        let checkpoint = workspace.selection_snapshot();
        let selected = workspace.selected_orbits;
        workspace.initialize(&mut SplitMix64(91));
        assert_ne!(workspace.selected_orbits, selected);

        let mut checkpoints = [None; QUOTIENT_SHIFTS + 1];
        let mut retries = [0_u8; QUOTIENT_SHIFTS + 1];
        checkpoints[4] = Some(checkpoint);
        let stage = workspace.restart_quotient_prefix(
            1,
            4,
            1,
            false,
            false,
            &mut checkpoints,
            &mut retries,
            &mut random,
        );
        assert_eq!(stage, 4);
        assert_eq!(workspace.selected_orbits, selected);
        assert_eq!(retries[4], 1);

        let stage = workspace.restart_quotient_prefix(
            1,
            4,
            1,
            false,
            false,
            &mut checkpoints,
            &mut retries,
            &mut random,
        );
        assert_eq!(stage, 1);
        assert!(checkpoints[4].is_none());
        assert_eq!(retries[4], 0);
    }

    #[test]
    fn mod7_locked_initializer_and_moves_preserve_the_exact_filter() {
        let mut workspace = G53Workspace::compile().unwrap();
        let mut random = SplitMix64(7_2092);
        workspace.initialize_mod7_locked(&mut random);
        let active = 0;
        let active_subgroups = 0;
        let active_quotient = QUOTIENT_SHIFTS;
        let mut objective =
            workspace.recompute_intersections(active, active_subgroups, active_quotient, 0, 1);
        assert_eq!(workspace.quotient_paf[0], QUOTIENT_TARGETS[0]);
        for _ in 0..1_000 {
            for shift in 0..QUOTIENT_SHIFTS {
                assert_eq!(
                    (workspace.quotient_paf[shift] - QUOTIENT_TARGETS[shift]).rem_euclid(7),
                    0
                );
            }
            let movement = workspace
                .choose_search_move(0, 0, true, &mut random)
                .unwrap();
            workspace.apply_search_move(
                movement,
                active,
                active_subgroups,
                active_quotient,
                0,
                1,
                &mut objective,
            );
            workspace.commit_search_move(movement);
            assert_eq!(
                objective,
                workspace.recompute_intersections(active, active_subgroups, active_quotient, 0, 1,)
            );
        }
    }

    #[test]
    fn mod49_q7_initializer_replays_rows_and_all_active_congruences() {
        let q0_lifts = cached_g53_mod7_q0_lifts().unwrap();
        let q7_lifts = cached_g53_mod49_q7_lifts().unwrap();
        let mut workspace = G53Workspace::compile_with_lifts(q0_lifts, q7_lifts).unwrap();
        workspace.initialize_mod49_q7(&mut SplitMix64(49_2092));
        workspace.recompute_quotient_paf();
        for (block, row) in workspace.minus.iter().enumerate() {
            assert_eq!(
                row.iter().copied().map(u16::from).sum::<u16>(),
                if block == 0 { 260 } else { 261 }
            );
        }
        for shift in 0..7 {
            assert_eq!(
                (workspace.quotient_paf[shift] - QUOTIENT_TARGETS[shift]).rem_euclid(49),
                0
            );
        }
    }

    #[test]
    fn subgroup_energy_cache_matches_independent_double_count_oracle() {
        let mut workspace = G53Workspace::compile().unwrap();
        workspace.initialize(&mut SplitMix64(53));
        workspace.recompute_subgroup_squares();
        let mut flat = [0_u8; CARRIER * BLOCKS];
        for block in 0..BLOCKS {
            flat[block * CARRIER..(block + 1) * CARRIER].copy_from_slice(&workspace.minus[block]);
        }
        let mut counts = [0_u16; MAX_SUBGROUP_COSETS * BLOCKS];
        for group in 0..SUBGROUP_ORDERS.len() {
            let cosets = SUBGROUP_COSETS[group];
            let direct = coset_square_sum_into(
                SubgroupEnergyInstance {
                    carrier: CARRIER as u16,
                    subgroup_order: SUBGROUP_ORDERS[group] as u16,
                    block_count: BLOCKS as u8,
                    row_weight_total: 1_043,
                    uniform_nonzero_intersection: 520,
                },
                &flat,
                &mut counts[..cosets * BLOCKS],
            )
            .unwrap();
            assert_eq!(u64::from(workspace.subgroup_squares[group] as u32), direct);
        }
    }

    #[test]
    fn quotient_paf_cache_matches_independent_fibre_oracle() {
        let mut workspace = G53Workspace::compile().unwrap();
        workspace.initialize(&mut SplitMix64(18));
        workspace.recompute_quotient_paf();
        let mut flat = [0_u8; CARRIER * BLOCKS];
        for block in 0..BLOCKS {
            flat[block * CARRIER..(block + 1) * CARRIER].copy_from_slice(&workspace.minus[block]);
        }
        let mut counts = [0_u16; QUOTIENT_ORDER * BLOCKS];
        let mut output = [0_u64; QUOTIENT_ORDER];
        quotient_paf_into(
            QuotientPafInstance {
                carrier: CARRIER as u16,
                quotient_order: QUOTIENT_ORDER as u16,
                block_count: BLOCKS as u8,
                row_weight_total: 1_043,
                uniform_nonzero_intersection: 520,
            },
            &flat,
            &mut counts,
            &mut output,
        )
        .unwrap();
        for shift in 0..QUOTIENT_SHIFTS {
            assert_eq!(
                u64::from(workspace.quotient_paf[shift] as u32),
                output[shift]
            );
        }
    }

    #[test]
    fn additive_repair_join_rejects_every_same_block_pair() {
        let first = SearchMove {
            first_block: 1,
            second_block: 0,
            remove: [3, 0],
            add: [4, 0],
            remove_len: 1,
            add_len: 1,
            kind: MOVE_SINGLE_BLOCK,
            reserved: [0; 7],
        };
        let mut second = first;
        second.remove[0] = 5;
        second.add[0] = 6;
        assert!(!repair_moves_compatible(first, second));
        second.first_block = 2;
        assert!(repair_moves_compatible(first, second));
    }
}
