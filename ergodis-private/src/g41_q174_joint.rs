//! Exact joint q58/q87 profile census through the common q174 refinement.

use serde::Serialize;
use sha2::{Digest, Sha256};
use thiserror::Error;

use crate::feature_synthesis::ResidualTuple;
use crate::g41_q29_evolve::{
    compile_inventory, digit_counts, FineInventory, FineOrbit, G41Q29EvolveError, Q29_COSETS,
};
use crate::g41_q29_exact_tablebase::translate_261_g41_q29_block_spec;
use crate::proof_synthesis::evolve_bounded_homogeneous_relations;

const CARRIER: usize = 522;
const MODULUS: usize = 174;
const CLASSES: usize = 46;
const Q58_MODULUS: usize = 58;
const Q58_CLASSES: usize = 16;
const Q87_MODULUS: usize = 87;
const TARGET_Q87_DEFECT: u16 = 523;
pub const G41_Q174_Q87_DEFECT_SHIFTS: [usize; 2] = [4, 6];
pub const G41_Q174_Q87_SCOPED_DEFECTS: usize = G41_Q174_Q87_DEFECT_SHIFTS.len();
const SLOTS: usize = 6;
const COORDINATES: usize = 8;
const LANE_BITS: u32 = 2;
const STATE_BITS: u32 = (CLASSES as u32) * LANE_BITS;
const STATE_MASK: u128 = (1_u128 << STATE_BITS) - 1;
const MAX_SIDE_STATES: usize = 1 << 24;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct KeyedState {
    key: u64,
    state_low: u64,
    state_high: u64,
    q58_state: u64,
    q87_low: u64,
    q87_high: u64,
}

const _: () = assert!(std::mem::size_of::<KeyedState>() == 48);

impl KeyedState {
    #[inline(always)]
    fn new(key: u64, state: u128, q58_state: u64, q87_state: u128) -> Self {
        Self {
            key,
            state_low: state as u64,
            state_high: (state >> 64) as u64,
            q58_state,
            q87_low: q87_state as u64,
            q87_high: (q87_state >> 64) as u64,
        }
    }

    #[inline(always)]
    fn state(self) -> u128 {
        u128::from(self.state_low) | (u128::from(self.state_high) << 64)
    }

    #[inline(always)]
    fn q87_state(self) -> u128 {
        u128::from(self.q87_low) | (u128::from(self.q87_high) << 64)
    }
}

#[repr(C)]
#[derive(Clone, Copy)]
struct HotState {
    state_low: u64,
    state_high: u64,
    q58_state: u64,
    q87_low: u64,
    q87_high: u64,
}

const _: () = assert!(std::mem::size_of::<HotState>() == 40);

impl HotState {
    fn new(state: u128, q58_state: u64, q87_state: u128) -> Self {
        Self {
            state_low: state as u64,
            state_high: (state >> 64) as u64,
            q58_state,
            q87_low: q87_state as u64,
            q87_high: (q87_state >> 64) as u64,
        }
    }

    #[inline(always)]
    fn state(self) -> u128 {
        u128::from(self.state_low) | (u128::from(self.state_high) << 64)
    }

    #[inline(always)]
    fn q87_state(self) -> u128 {
        u128::from(self.q87_low) | (u128::from(self.q87_high) << 64)
    }
}

#[derive(Clone, Debug, Error, PartialEq, Eq)]
pub enum G41Q174JointError {
    #[error("g41 q174 joint semantics are invalid")]
    SemanticMismatch,
    #[error("g41 q174 joint side {side} stage {stage} retained more than {states} states")]
    StateBudget { side: u8, stage: u8, states: u64 },
    #[error("g41 q174 joint profile budget was exceeded")]
    ProfileBudget,
    #[error(transparent)]
    Evolve(#[from] G41Q29EvolveError),
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct G41Q174JointProfile {
    pub q58_energy: u16,
    pub q58_residuals: ResidualTuple<i16, 7>,
    pub q87_energy: u16,
    pub q87_defects: [u16; G41_Q174_Q87_SCOPED_DEFECTS],
}

impl Default for G41Q174JointProfile {
    fn default() -> Self {
        Self {
            q58_energy: 0,
            q58_residuals: ResidualTuple::from_array([0; 7]),
            q87_energy: 0,
            q87_defects: [0; G41_Q174_Q87_SCOPED_DEFECTS],
        }
    }
}

const _: () = assert!(std::mem::size_of::<G41Q174JointProfile>() == 22);

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174JointReport {
    pub mask: u8,
    pub digits: u32,
    pub q29_coefficients: [u8; COORDINATES],
    pub q87_defect_shifts: [usize; G41_Q174_Q87_SCOPED_DEFECTS],
    pub orbit_classes: u8,
    pub slot_states: [u32; SLOTS],
    pub left_slots: [u8; 3],
    pub right_slots: [u8; 3],
    pub partition_attempts: Vec<G41Q174PartitionAttempt>,
    pub left_states: u32,
    pub right_states: u32,
    pub pairs_visited: u64,
    pub q87_energy_pair_survivors: u64,
    pub q87_cache_hits: u64,
    pub q87_cache_misses: u64,
    pub q87_cache_entries: u32,
    pub q58_cache_hits: u64,
    pub q58_cache_misses: u64,
    pub q58_cache_collisions: u64,
    pub exact_q58_coefficient_states: u32,
    pub q58_profile_pair_survivors: u64,
    pub exact_joint_profiles: u32,
    pub joint_profile_digest: [u8; 32],
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174PartitionAttempt {
    pub left_slots: [u8; 3],
    pub right_slots: [u8; 3],
    pub maximum_raw_product: u64,
    pub left_states: Option<u32>,
    pub right_states: Option<u32>,
    pub failed_side: Option<u8>,
    pub failed_stage: Option<u8>,
    pub failure_states: Option<u64>,
}

pub struct G41Q174JointTablebase {
    pub report: G41Q174JointReport,
    pub profiles: Box<[G41Q174JointProfile]>,
    representative_states: Box<[u128]>,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174AllocationWitnessReport {
    pub mask: u8,
    pub digits: u32,
    pub target_state: u128,
    pub q58_class_coefficients: [u8; Q58_CLASSES],
    pub left_slots: [u8; 3],
    pub right_slots: [u8; 3],
    pub orbit_masks: Option<[u16; SLOTS]>,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174Q87ReplayReport {
    pub combined_nonzero_defects: Vec<u16>,
    pub all_nonzero_defects_equal_523: bool,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174TargetFibreReport {
    pub target_profiles: u16,
    pub slot_states: [u32; SLOTS],
    pub left_slots: [u8; 3],
    pub right_slots: [u8; 3],
    pub left_states: u32,
    pub right_states: u32,
    pub states_by_target: Vec<Box<[u128]>>,
    pub canonical_states_by_target: Vec<Box<[u128]>>,
    pub pairs_visited: u64,
    pub q87_target_pairs: u64,
    pub q87_cache_hits: u64,
    pub q87_cache_misses: u64,
    pub q87_cache_entries: u32,
    pub q58_cache_hits: u64,
    pub q58_cache_misses: u64,
    pub q58_cache_collisions: u64,
    pub matching_pairs: u64,
    pub unique_states: u64,
    pub canonical_components: u64,
    pub maximum_states: u64,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174SourceProjectionIndexReport {
    pub mask: u8,
    pub digits: u32,
    pub slot_states: [u32; SLOTS],
    pub left_slots: [u8; 3],
    pub right_slots: [u8; 3],
    pub left_states: u32,
    pub right_states: u32,
    pub left_projection_keys: u32,
    pub right_projection_keys: u32,
    pub left_projection_prefixes: u32,
    pub right_projection_prefixes: u32,
    pub maximum_left_fibre: u32,
    pub maximum_right_fibre: u32,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174SourceProjectionBatchReport {
    pub source: G41Q174SourceProjectionIndexReport,
    pub target_projections: u32,
    pub compatible_projection_triples: u64,
    pub compatible_state_pairs: u64,
    pub provenance: &'static str,
}

pub struct G41Q174FlipAction {
    generators: [u128; 7],
    changed_lanes: [[u8; 4]; 7],
    valid_pattern_masks: [[u8; 6]; 7],
    valid_pattern_counts: [u8; 7],
    pub proof: G41Q174FlipProofReport,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174TranslationProofReport {
    pub extractor: &'static str,
    pub extractor_version: u16,
    pub translation: u16,
    pub slot_permutation: [u8; SLOTS],
    pub lane_permutation: Box<[u8]>,
    pub large_orbit_permutation: [[u8; 14]; SLOTS],
    pub large_orbit_lengths: [u8; SLOTS],
    pub quadratic_basis_checks: u32,
    pub q29_projection_fixed: bool,
    pub source_orbits_verified: bool,
    pub proof_commitment: [u8; 32],
    pub verified: bool,
    pub provenance: &'static str,
}

pub struct G41Q174TranslationAction {
    lane_permutation: [u8; CLASSES],
    pub proof: G41Q174TranslationProofReport,
}

impl G41Q174FlipAction {
    pub fn compile() -> Result<Self, G41Q174JointError> {
        let proof = prove_g41_q174_coset_complement_symmetry()?;
        let generators = proof
            .generator_words
            .map(|words| u128::from(words[0]) | (u128::from(words[1]) << 64));
        Ok(Self {
            generators,
            changed_lanes: proof.changed_lanes,
            valid_pattern_masks: proof.valid_pattern_masks,
            valid_pattern_counts: proof.valid_pattern_counts,
            proof,
        })
    }

    #[inline(always)]
    fn applicable(&self, state: u128, coordinate: usize) -> bool {
        let mut pattern = 0_u8;
        for (index, &lane) in self.changed_lanes[coordinate].iter().enumerate() {
            match coefficient(state, usize::from(lane)) {
                0 => {}
                3 => pattern |= 1 << index,
                _ => return false,
            }
        }
        self.valid_pattern_masks[coordinate][..usize::from(self.valid_pattern_counts[coordinate])]
            .contains(&pattern)
    }

    #[inline(always)]
    pub fn canonicalize(&self, mut state: u128) -> u128 {
        for coordinate in 0..7 {
            if self.applicable(state, coordinate) {
                state = state.min(state ^ self.generators[coordinate]);
            }
        }
        state
    }

    /// Expands the complete proved symmetry orbit into caller-owned storage.
    pub fn expand(&self, state: u128, output: &mut [u128; 128]) -> usize {
        let canonical = self.canonicalize(state);
        let mut active = [0_u128; 7];
        let mut active_len = 0_usize;
        for coordinate in 0..7 {
            if self.applicable(canonical, coordinate) {
                active[active_len] = self.generators[coordinate];
                active_len += 1;
            }
        }
        let length = 1_usize << active_len;
        for (subset, target) in output[..length].iter_mut().enumerate() {
            let mut expanded = canonical;
            for (index, &generator) in active[..active_len].iter().enumerate() {
                if subset & (1 << index) != 0 {
                    expanded ^= generator;
                }
            }
            *target = expanded;
        }
        output[..length].sort_unstable();
        length
    }
}

impl G41Q174TranslationAction {
    pub fn compile() -> Result<Self, G41Q174JointError> {
        let proof = prove_g41_q174_translation_261()?;
        let lane_permutation: [u8; CLASSES] = proof
            .lane_permutation
            .as_ref()
            .try_into()
            .map_err(|_| G41Q174JointError::SemanticMismatch)?;
        Ok(Self {
            lane_permutation,
            proof,
        })
    }

    #[inline(always)]
    pub fn translate(&self, state: u128) -> Result<u128, G41Q174JointError> {
        translate_q174_state_with_permutation(state, self.lane_permutation)
    }
}

#[inline(always)]
fn translate_q174_state_with_permutation(
    state: u128,
    lane_permutation: [u8; CLASSES],
) -> Result<u128, G41Q174JointError> {
    if state & !STATE_MASK != 0 {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let mut translated = 0_u128;
    for source in 0..CLASSES {
        translated |=
            u128::from(coefficient(state, source)) << (2 * usize::from(lane_permutation[source]));
    }
    Ok(translated)
}

pub fn translate_g41_q174_block_spec(
    mask: u8,
    digits: u32,
) -> Result<(u8, u32), G41Q174JointError> {
    translate_261_g41_q29_block_spec(mask, digits).map_err(|_| G41Q174JointError::SemanticMismatch)
}

fn same_translated_orbit(source: &FineOrbit, target: &FineOrbit) -> bool {
    if source.len != target.len {
        return false;
    }
    let length = usize::from(source.len);
    let mut translated = [0_u16; 12];
    translated[..length].copy_from_slice(&source.points[..length]);
    for point in &mut translated[..length] {
        *point = ((*point as usize + 261) % CARRIER) as u16;
    }
    translated[..length].sort_unstable();
    let mut expected = target.points;
    expected[..length].sort_unstable();
    translated[..length] == expected[..length]
}

pub fn prove_g41_q174_translation_261() -> Result<G41Q174TranslationProofReport, G41Q174JointError>
{
    const SLOT_PERMUTATION: [u8; SLOTS] = [1, 0, 3, 2, 5, 4];
    let layout = compile_layout()?;
    let q58_layout = compile_q58_layout()?;
    let q87_layout = compile_q87_layout()?;
    let inventory = compile_inventory()?;
    let lane_permutation: [u8; CLASSES] = std::array::from_fn(|source| {
        usize::from(layout.class_of[(usize::from(layout.representatives[source]) + 87) % MODULUS])
            as u8
    });
    for source in 0..CLASSES {
        let target = usize::from(lane_permutation[source]);
        let source_residue = usize::from(layout.representatives[source]) % 29;
        let target_residue = usize::from(layout.representatives[target]) % 29;
        let source_coordinate = if source_residue == 0 {
            None
        } else {
            Q29_COSETS
                .iter()
                .position(|coset| coset.contains(&source_residue))
        };
        let target_coordinate = if target_residue == 0 {
            None
        } else {
            Q29_COSETS
                .iter()
                .position(|coset| coset.contains(&target_residue))
        };
        if usize::from(lane_permutation[target]) != source || source_coordinate != target_coordinate
        {
            return Err(G41Q174JointError::SemanticMismatch);
        }
    }
    let mut large_orbit_permutation = [[u8::MAX; 14]; SLOTS];
    for source_slot in 0..SLOTS {
        let target_slot = usize::from(SLOT_PERMUTATION[source_slot]);
        if !same_translated_orbit(&inventory.small[source_slot], &inventory.small[target_slot])
            || translate_q174_state_with_permutation(
                orbit_state(&layout, &inventory.small[source_slot])?,
                lane_permutation,
            )? != orbit_state(&layout, &inventory.small[target_slot])?
        {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        for source_orbit in 0..usize::from(inventory.large_len[source_slot]) {
            let source = &inventory.large[source_slot][source_orbit];
            let Some(target_orbit) = inventory.large[target_slot]
                [..usize::from(inventory.large_len[target_slot])]
                .iter()
                .position(|target| same_translated_orbit(source, target))
            else {
                return Err(G41Q174JointError::SemanticMismatch);
            };
            if translate_q174_state_with_permutation(
                orbit_state(&layout, source)?,
                lane_permutation,
            )? != orbit_state(&layout, &inventory.large[target_slot][target_orbit])?
            {
                return Err(G41Q174JointError::SemanticMismatch);
            }
            large_orbit_permutation[source_slot][source_orbit] = target_orbit as u8;
        }
    }
    let mut quadratic_basis_checks = 0_u32;
    let mut check = |state| -> Result<(), G41Q174JointError> {
        let translated = translate_q174_state_with_permutation(state, lane_permutation)?;
        quadratic_basis_checks += 1;
        if projection(&layout, state) != projection(&layout, translated)
            || raw_joint_profile_values(&layout, &q58_layout, &q87_layout, state)
                != raw_joint_profile_values(&layout, &q58_layout, &q87_layout, translated)
        {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        Ok(())
    };
    check(0)?;
    for lane in 0..CLASSES {
        check(1_u128 << (2 * lane))?;
        check(2_u128 << (2 * lane))?;
    }
    for first in 0..CLASSES {
        for second in first + 1..CLASSES {
            check((1_u128 << (2 * first)) | (1_u128 << (2 * second)))?;
        }
    }
    let mut hasher = Sha256::new();
    hasher.update(b"ergodis-private:g41-q174-translation-261:v1");
    hasher.update((CARRIER as u16).to_le_bytes());
    hasher.update((261_u16).to_le_bytes());
    hasher.update(SLOT_PERMUTATION);
    hasher.update(lane_permutation);
    hasher.update(inventory.large_len);
    for permutation in large_orbit_permutation {
        hasher.update(permutation);
    }
    hasher.update(quadratic_basis_checks.to_le_bytes());
    Ok(G41Q174TranslationProofReport {
        extractor: "ergodis-private.g41-q174-translation-261",
        extractor_version: 1,
        translation: 261,
        slot_permutation: SLOT_PERMUTATION,
        lane_permutation: lane_permutation.into(),
        large_orbit_permutation,
        large_orbit_lengths: inventory.large_len,
        quadratic_basis_checks,
        q29_projection_fixed: true,
        source_orbits_verified: true,
        proof_commitment: hasher.finalize().into(),
        verified: true,
        provenance: "sealed structural source bijection: translation by 261 is the unique nontrivial multiplier-commuting translation, swaps the three q18 slot pairs, is zero modulo 29, permutes all canonical q174 source orbits exactly, fixes q87 coefficients, and negates only the q58 anti-character; the complete quadratic basis independently verifies every retained broad profile coordinate, with no observed target fibre used",
    })
}

#[derive(Clone, Copy, Debug, Default)]
struct Q87LocalEnergyBounds {
    minimum: u8,
    maximum: u8,
    residues_mod_four: u8,
    valid: bool,
}

struct Q87EnergyBounds {
    local: Box<[Q87LocalEnergyBounds]>,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174SourceFeasibilityReport {
    pub mask: u8,
    pub digits: u32,
    pub q29_coefficients: [u8; COORDINATES],
    pub target_state: u128,
    pub feasible: bool,
    pub states_after_lane: Box<[u32]>,
    pub workspace_bytes: u64,
    pub semantic_commitment: [u8; 32],
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174Q87EnergyBoundProbeReport {
    pub mask: u8,
    pub digits: u32,
    pub q29_coefficients: [u8; COORDINATES],
    pub target_q87_energies: Box<[u16]>,
    pub left_states: u32,
    pub right_states: u32,
    pub left_states_with_complement: u64,
    pub left_states_rejected: u64,
    pub candidate_pairs: u64,
    pub pairs_avoided: u64,
    pub per_energy: Box<[G41Q174Q87EnergyScopeReport]>,
    pub workspace_bytes: u64,
    pub provenance: &'static str,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174Q87EnergyScopeReport {
    pub target_q87_energy: u16,
    pub left_states_rejected: u64,
    pub pairs_avoided: u64,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174Q87InteractionReport {
    pub extractor: &'static str,
    pub extractor_version: u16,
    pub defect_shifts: [usize; G41_Q174_Q87_SCOPED_DEFECTS],
    pub coordinate_adjacency: [[u8; COORDINATES]; G41_Q174_Q87_SCOPED_DEFECTS],
    pub scopes: Box<[G41Q174Q87InteractionScopeReport]>,
    pub semantic_commitment: [u8; 32],
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174Q87InteractionScopeReport {
    pub coordinate_mask: u8,
    pub edge_count: u8,
    pub minimum_elimination_width: u8,
    pub elimination_order: [u8; COORDINATES],
    pub minimum_linear_frontier_width: u8,
    pub linear_frontier_order: [u8; COORDINATES],
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174Q87PhaseProofReport {
    pub extractor: &'static str,
    pub extractor_version: u16,
    pub relations: [G41Q174Q87PhaseRelation; 7],
    pub quadratic_basis_checks: u32,
    pub evolution_candidates_tested: u64,
    pub evolved_coefficients: [[i8; 4]; 7],
    pub proof_commitment: [u8; 32],
    pub verified: bool,
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174Q87PhaseRelation {
    pub q29_shift: u8,
    pub repeated_q87_class: u8,
    pub singleton_q87_class: u8,
}

#[derive(Clone, Debug, Serialize, PartialEq, Eq)]
pub struct G41Q174FlipProofReport {
    pub extractor: &'static str,
    pub extractor_version: u16,
    pub generator_words: [[u64; 2]; 7],
    pub changed_lanes: [[u8; 4]; 7],
    pub valid_pattern_masks: [[u8; 6]; 7],
    pub valid_pattern_counts: [u8; 7],
    pub profile_coordinates: u8,
    pub source_balance_verified: bool,
    pub proof_commitment: [u8; 32],
    pub verified: bool,
    pub provenance: &'static str,
}

#[derive(Clone, Copy, Debug, Default)]
struct LaneChoice {
    used: [u8; SLOTS],
}

/// Reusable exact source-membership checker for packed q174 states.
///
/// Construction binds the source block and allocates the bounded workspace.
/// `check` allocates nothing; `report` boxes its diagnostic frontier counts.
pub struct G41Q174SourceFeasibilityWorkspace {
    mask: u8,
    digits: u32,
    target_counts: [u8; SLOTS],
    radices: [u32; SLOTS],
    state_count: usize,
    fixed_state: u128,
    multiplicities: [[u8; SLOTS]; CLASSES],
    current_seen: Box<[u8]>,
    next_seen: Box<[u8]>,
    current: Vec<u32>,
    next: Vec<u32>,
    semantic_commitment: [u8; 32],
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct TargetState {
    target: u8,
    state_high: u64,
    state_low: u64,
}

const _: () = assert!(std::mem::size_of::<TargetState>() == 24);

impl TargetState {
    #[inline(always)]
    fn new(target: usize, state: u128) -> Self {
        Self {
            target: target as u8,
            state_high: (state >> 64) as u64,
            state_low: state as u64,
        }
    }

    #[inline(always)]
    fn state(self) -> u128 {
        u128::from(self.state_low) | (u128::from(self.state_high) << 64)
    }
}

pub fn replay_g41_q174_q87_defects(
    states: [u128; 4],
) -> Result<G41Q174Q87ReplayReport, G41Q174JointError> {
    if states.into_iter().any(|state| state & !STATE_MASK != 0) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let defects: [[u16; 43]; 4] = std::array::from_fn(|block| {
        q87_defect_vector(&layout, states[block]).expect("packed state was validated")
    });
    let combined_nonzero_defects: [u16; 43] =
        std::array::from_fn(|shift| defects.iter().map(|block| block[shift]).sum::<u16>());
    Ok(G41Q174Q87ReplayReport {
        all_nonzero_defects_equal_523: combined_nonzero_defects
            .into_iter()
            .all(|defect| defect == 523),
        combined_nonzero_defects: combined_nonzero_defects.to_vec(),
        provenance: "independent direct q87 coefficient expansion from four packed q174 states followed by all 43 conjugacy-reduced nonzero cyclic correlations; no scoped feature extractor is reused",
    })
}

fn q87_defect_vector(layout: &Layout, state: u128) -> Result<[u16; 43], G41Q174JointError> {
    let coefficients: [i32; Q87_MODULUS] = std::array::from_fn(|residue| {
        i32::from(residue_coefficient(layout, state, residue))
            + i32::from(residue_coefficient(layout, state, residue + Q87_MODULUS))
    });
    let zero: i32 = coefficients.iter().map(|value| value * value).sum();
    let mut defects = [0_u16; 43];
    for shift in 1..=43 {
        let correlation: i32 = (0..Q87_MODULUS)
            .map(|residue| coefficients[residue] * coefficients[(residue + shift) % Q87_MODULUS])
            .sum();
        defects[shift - 1] = (zero - correlation)
            .try_into()
            .map_err(|_| G41Q174JointError::SemanticMismatch)?;
    }
    Ok(defects)
}

pub fn g41_q174_q87_defect_vector(state: u128) -> Result<[u16; 43], G41Q174JointError> {
    if state & !STATE_MASK != 0 {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    q87_defect_vector(&compile_layout()?, state)
}

pub fn compile_g41_q174_target_fibres(
    mask: u8,
    digits: u32,
    q29_coefficients: [u8; COORDINATES],
    targets: &[G41Q174JointProfile],
    maximum_states: usize,
) -> Result<G41Q174TargetFibreReport, G41Q174JointError> {
    type Q58Cache = Q58ProfileCache<{ 1 << 20 }>;
    type Q87Cache = Q87ProfileCache<{ 1 << 20 }>;
    if targets.is_empty()
        || targets.len() > u8::MAX as usize
        || maximum_states == 0
        || mask >= 64
        || q29_coefficients.iter().any(|&value| value > 18)
        || !targets.windows(2).all(|pair| pair[0] < pair[1])
    {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let q58_layout = compile_q58_layout()?;
    let q87_layout = compile_q87_layout()?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let contributions = [
        slot_states(&layout, &inventory, 0, mask, counts[0])?,
        slot_states(&layout, &inventory, 1, mask, counts[1])?,
        slot_states(&layout, &inventory, 2, mask, counts[2])?,
        slot_states(&layout, &inventory, 3, mask, counts[3])?,
        slot_states(&layout, &inventory, 4, mask, counts[4])?,
        slot_states(&layout, &inventory, 5, mask, counts[5])?,
    ];
    let cardinalities = contributions.each_ref().map(|values| values.len() as u32);
    let (mut left_slots, mut right_slots, mut left, mut right, _partition_attempts) =
        compile_partitioned_sides(
            &layout,
            contributions.each_ref().map(|values| values.as_slice()),
            cardinalities,
            q29_coefficients,
            6,
        )?;
    if left.len() > right.len() {
        std::mem::swap(&mut left_slots, &mut right_slots);
        std::mem::swap(&mut left, &mut right);
    }
    let mut hot_left = Vec::with_capacity(left.len());
    for state in left {
        hot_left.push(HotState::new(
            state,
            q58_state(&layout, &q58_layout, state),
            q87_state(&layout, state),
        ));
    }
    let mut keyed_right = Vec::with_capacity(right.len());
    for state in right {
        let key = pack_projection(projection(&layout, state))
            .ok_or(G41Q174JointError::SemanticMismatch)?;
        keyed_right.push(KeyedState::new(
            key,
            state,
            q58_state(&layout, &q58_layout, state),
            q87_state(&layout, state),
        ));
    }
    keyed_right.sort_unstable();
    let q29_defects = quotient_defects(q29_coefficients);
    let mut q87_targets: Vec<Q87Terms> = targets
        .iter()
        .map(|target| Q87Terms {
            energy: target.q87_energy,
            defects: target.q87_defects,
            _reserved: 0,
        })
        .collect();
    q87_targets.sort_unstable();
    q87_targets.dedup();
    let mut q58_cache = Q58Cache::new();
    let mut q87_cache = Q87Cache::new();
    let mut states = Vec::with_capacity(maximum_states);
    let mut pairs_visited = 0_u64;
    let mut q87_target_pairs = 0_u64;
    let mut matching_pairs = 0_u64;
    for &left_state in &hot_left {
        let Some(key) = complement_key(&layout, left_state.state(), q29_coefficients) else {
            continue;
        };
        let start = keyed_right.partition_point(|entry| entry.key < key);
        let end = keyed_right.partition_point(|entry| entry.key <= key);
        for &entry in &keyed_right[start..end] {
            pairs_visited += 1;
            let combined_q87 = add_states(left_state.q87_state(), entry.q87_state());
            let Some(q87_terms) = q87_cache.get_or_compile(combined_q87, &q87_layout)? else {
                continue;
            };
            if q87_targets.binary_search(&q87_terms).is_err() {
                continue;
            }
            q87_target_pairs += 1;
            let q58_state = left_state.q58_state + entry.q58_state;
            let Some(q58_terms) = q58_cache.get_or_compile(q58_state, &q58_layout, q29_defects)?
            else {
                continue;
            };
            let profile = G41Q174JointProfile {
                q58_energy: q58_terms.energy,
                q58_residuals: q58_terms.residuals,
                q87_energy: q87_terms.energy,
                q87_defects: q87_terms.defects,
            };
            let Ok(target) = targets.binary_search(&profile) else {
                continue;
            };
            matching_pairs += 1;
            if states.len() == states.capacity() {
                return Err(G41Q174JointError::ProfileBudget);
            }
            states.push(TargetState::new(
                target,
                add_states(left_state.state(), entry.state() & STATE_MASK),
            ));
        }
    }
    states.sort_unstable();
    states.dedup();
    let unique_states = states.len() as u64;
    let flip_action = G41Q174FlipAction::compile()?;
    let mut canonical_states = Vec::with_capacity(states.len());
    for state in &states {
        canonical_states.push(TargetState::new(
            usize::from(state.target),
            flip_action.canonicalize(state.state()),
        ));
    }
    canonical_states.sort_unstable();
    canonical_states.dedup();
    let canonical_components = canonical_states.len() as u64;
    let mut states_by_target: Vec<Vec<u128>> = (0..targets.len()).map(|_| Vec::new()).collect();
    for state in states {
        states_by_target[usize::from(state.target)].push(state.state());
    }
    let mut canonical_states_by_target: Vec<Vec<u128>> =
        (0..targets.len()).map(|_| Vec::new()).collect();
    for state in canonical_states {
        canonical_states_by_target[usize::from(state.target)].push(state.state());
    }
    Ok(G41Q174TargetFibreReport {
        target_profiles: targets.len() as u16,
        slot_states: cardinalities,
        left_slots: left_slots.map(|slot| slot as u8),
        right_slots: right_slots.map(|slot| slot as u8),
        left_states: hot_left.len() as u32,
        right_states: keyed_right.len() as u32,
        states_by_target: states_by_target
            .into_iter()
            .map(Vec::into_boxed_slice)
            .collect(),
        canonical_states_by_target: canonical_states_by_target
            .into_iter()
            .map(Vec::into_boxed_slice)
            .collect(),
        pairs_visited,
        q87_target_pairs,
        q87_cache_hits: q87_cache.hits,
        q87_cache_misses: q87_cache.misses,
        q87_cache_entries: q87_cache.len() as u32,
        q58_cache_hits: q58_cache.hits,
        q58_cache_misses: q58_cache.misses,
        q58_cache_collisions: q58_cache.collisions,
        matching_pairs,
        unique_states,
        canonical_components,
        maximum_states: maximum_states as u64,
        workspace_bytes: contributions
            .iter()
            .map(|values| values.capacity() as u64 * std::mem::size_of::<u128>() as u64)
            .sum::<u64>()
            + hot_left.capacity() as u64 * std::mem::size_of::<HotState>() as u64
            + keyed_right.capacity() as u64 * std::mem::size_of::<KeyedState>() as u64
            + Q58Cache::bytes()
            + Q87Cache::bytes()
            + unique_states * std::mem::size_of::<TargetState>() as u64
            + maximum_states as u64 * std::mem::size_of::<TargetState>() as u64,
        provenance: "exact bounded target-fibre lift; the canonical six-slot q174 MITM is replayed once, a bounded exact 72-bit transposition table reuses combined q87 quadratic profiles and a precompiled exact target-q87 key rejects irrelevant pairs before q58 extraction, all packed q174 states matching one of the sorted full target profiles are retained and deduplicated, and a separately sealed symbolic/source-balance theorem emits canonical seeds for seven disjoint profile-preserving source bijections while retaining full states for independent q87 replay; absence is authoritative only for these bound target profiles",
    })
}

impl G41Q174JointTablebase {
    pub fn representative_state(&self, profile: usize) -> Option<u128> {
        self.representative_states.get(profile).copied()
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct SlotChoice {
    state: u128,
    orbit_mask: u16,
}

struct Layout {
    class_of: [u8; MODULUS],
    representatives: [u8; CLASSES],
}

struct Q58Layout {
    class_of: [u8; Q58_MODULUS],
    representatives: [u8; Q58_CLASSES],
}

struct Q87Layout {
    lane_weights: [u8; 24],
    terms: [[Q87Term; Q87_MODULUS]; G41_Q174_Q87_SCOPED_DEFECTS],
    term_lengths: [u8; G41_Q174_Q87_SCOPED_DEFECTS],
}

#[derive(Clone, Copy, Debug, Default)]
struct Q87Term {
    first: u8,
    second: u8,
    weight: u8,
}

fn compile_layout() -> Result<Layout, G41Q174JointError> {
    let mut class_of = [u8::MAX; MODULUS];
    let mut representatives = [0_u8; CLASSES];
    let mut classes = 0_usize;
    for residue in 0..MODULUS {
        if class_of[residue] != u8::MAX {
            continue;
        }
        if classes == CLASSES {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        representatives[classes] = residue as u8;
        let mut point = residue;
        loop {
            if class_of[point] != u8::MAX && class_of[point] != classes as u8 {
                return Err(G41Q174JointError::SemanticMismatch);
            }
            class_of[point] = classes as u8;
            point = point * 41 % MODULUS;
            if point == residue {
                break;
            }
        }
        classes += 1;
    }
    if classes != CLASSES {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    Ok(Layout {
        class_of,
        representatives,
    })
}

fn compile_q58_layout() -> Result<Q58Layout, G41Q174JointError> {
    let mut class_of = [u8::MAX; Q58_MODULUS];
    let mut representatives = [0_u8; Q58_CLASSES];
    let mut classes = 0_usize;
    for residue in 0..Q58_MODULUS {
        if class_of[residue] != u8::MAX {
            continue;
        }
        if classes == Q58_CLASSES {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        representatives[classes] = residue as u8;
        let mut point = residue;
        loop {
            class_of[point] = classes as u8;
            point = point * 41 % Q58_MODULUS;
            if point == residue {
                break;
            }
        }
        classes += 1;
    }
    if classes != Q58_CLASSES {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    Ok(Q58Layout {
        class_of,
        representatives,
    })
}

fn compile_q87_layout() -> Result<Q87Layout, G41Q174JointError> {
    let mut scoped_classes = G41_Q174_Q87_DEFECT_SHIFTS.map(canonical_q87_shift_class);
    scoped_classes.sort_unstable();
    if scoped_classes.windows(2).any(|pair| pair[0] == pair[1]) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let mut lane_of = [u8::MAX; Q87_MODULUS];
    for coordinate in 0..COORDINATES {
        let residue = if coordinate == 0 {
            0
        } else {
            Q29_COSETS[coordinate - 1][0]
        };
        for lift in 0..3 {
            let lane = (3 * coordinate + lift) as u8;
            let representative = residue + 29 * lift;
            if lane_of[representative] != u8::MAX {
                continue;
            }
            let mut point = representative;
            loop {
                if lane_of[point] != u8::MAX && lane_of[point] != lane {
                    return Err(G41Q174JointError::SemanticMismatch);
                }
                lane_of[point] = lane;
                point = point * 41 % Q87_MODULUS;
                if point == representative {
                    break;
                }
            }
        }
    }
    if lane_of.contains(&u8::MAX) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let mut lane_weights = [0_u8; 24];
    for &lane in &lane_of {
        lane_weights[usize::from(lane)] += 1;
    }
    let mut terms = [[Q87Term::default(); Q87_MODULUS]; G41_Q174_Q87_SCOPED_DEFECTS];
    let mut term_lengths = [0_u8; G41_Q174_Q87_SCOPED_DEFECTS];
    for (coordinate, &shift) in G41_Q174_Q87_DEFECT_SHIFTS.iter().enumerate() {
        let mut weights = [[0_u8; 24]; 24];
        for residue in 0..Q87_MODULUS {
            let first = usize::from(lane_of[residue]);
            let second = usize::from(lane_of[(residue + shift) % Q87_MODULUS]);
            let (first, second) = if first <= second {
                (first, second)
            } else {
                (second, first)
            };
            weights[first][second] += 1;
        }
        for first in 0..24 {
            for second in first..24 {
                if weights[first][second] != 0 {
                    let index = usize::from(term_lengths[coordinate]);
                    terms[coordinate][index] = Q87Term {
                        first: first as u8,
                        second: second as u8,
                        weight: weights[first][second],
                    };
                    term_lengths[coordinate] += 1;
                }
            }
        }
    }
    Ok(Q87Layout {
        lane_weights,
        terms,
        term_lengths,
    })
}

fn q87_coordinate_adjacency(
    layout: &Q87Layout,
) -> [[u8; COORDINATES]; G41_Q174_Q87_SCOPED_DEFECTS] {
    let mut adjacency = [[0_u8; COORDINATES]; G41_Q174_Q87_SCOPED_DEFECTS];
    for coordinate in 0..G41_Q174_Q87_SCOPED_DEFECTS {
        for term in &layout.terms[coordinate][..usize::from(layout.term_lengths[coordinate])] {
            let first = usize::from(term.first) / 3;
            let second = usize::from(term.second) / 3;
            if first != second {
                adjacency[coordinate][first] |= 1 << second;
                adjacency[coordinate][second] |= 1 << first;
            }
        }
    }
    adjacency
}

#[inline]
fn elimination_width(mut adjacency: [u8; COORDINATES], order: [u8; COORDINATES]) -> u8 {
    let mut live = u8::MAX;
    let mut width = 0_u8;
    for vertex in order {
        let vertex_bit = 1_u8 << vertex;
        let neighbours = adjacency[usize::from(vertex)] & live & !vertex_bit;
        width = width.max(neighbours.count_ones() as u8);
        let mut pending = neighbours;
        while pending != 0 {
            let neighbour = pending.trailing_zeros() as usize;
            pending &= pending - 1;
            adjacency[neighbour] |= neighbours & !(1 << neighbour);
        }
        live &= !vertex_bit;
    }
    width
}

fn next_permutation(values: &mut [u8; COORDINATES]) -> bool {
    let Some(pivot) = (0..COORDINATES - 1)
        .rev()
        .find(|&index| values[index] < values[index + 1])
    else {
        return false;
    };
    let successor = (pivot + 1..COORDINATES)
        .rev()
        .find(|&index| values[pivot] < values[index])
        .expect("a pivot has a successor");
    values.swap(pivot, successor);
    values[pivot + 1..].reverse();
    true
}

fn minimum_elimination_order(adjacency: [u8; COORDINATES]) -> (u8, [u8; COORDINATES]) {
    let mut order = std::array::from_fn(|index| index as u8);
    let mut best_order = order;
    let mut best_width = u8::MAX;
    loop {
        let width = elimination_width(adjacency, order);
        if (width, order) < (best_width, best_order) {
            best_width = width;
            best_order = order;
        }
        if !next_permutation(&mut order) {
            return (best_width, best_order);
        }
    }
}

#[inline]
fn linear_frontier_width(adjacency: [u8; COORDINATES], order: [u8; COORDINATES]) -> u8 {
    let mut assigned = 0_u8;
    let mut width = 0_u8;
    for vertex in order {
        assigned |= 1 << vertex;
        let unassigned = !assigned;
        let mut boundary = 0_u8;
        let mut pending = assigned;
        while pending != 0 {
            let candidate = pending.trailing_zeros() as usize;
            pending &= pending - 1;
            if adjacency[candidate] & unassigned != 0 {
                boundary += 1;
            }
        }
        width = width.max(boundary);
    }
    width
}

fn minimum_linear_frontier_order(adjacency: [u8; COORDINATES]) -> (u8, [u8; COORDINATES]) {
    let mut order = std::array::from_fn(|index| index as u8);
    let mut best_order = order;
    let mut best_width = u8::MAX;
    loop {
        let width = linear_frontier_width(adjacency, order);
        if (width, order) < (best_width, best_order) {
            best_width = width;
            best_order = order;
        }
        if !next_permutation(&mut order) {
            return (best_width, best_order);
        }
    }
}

/// Extracts the exact eight-coordinate factor graphs of the scoped q87
/// quadratic predicates and exhaustively minimizes induced width for every
/// nonempty predicate scope. This is cold proof-synthesis code; the resulting
/// fixed order is intended to drive bounded iterative hot kernels.
pub fn analyze_g41_q174_q87_interactions() -> Result<G41Q174Q87InteractionReport, G41Q174JointError>
{
    let layout = compile_q87_layout()?;
    let coordinate_adjacency = q87_coordinate_adjacency(&layout);
    let mut scopes = Vec::with_capacity((1 << G41_Q174_Q87_SCOPED_DEFECTS) - 1);
    let mut hasher = Sha256::new();
    hasher.update(b"ergodis-private:g41-q174-q87-interaction:v1");
    for shift in G41_Q174_Q87_DEFECT_SHIFTS {
        hasher.update((shift as u64).to_le_bytes());
    }
    for adjacency in coordinate_adjacency {
        hasher.update(adjacency);
    }
    for coordinate_mask in 1..(1_u8 << G41_Q174_Q87_SCOPED_DEFECTS) {
        let mut union = [0_u8; COORDINATES];
        for coordinate in 0..G41_Q174_Q87_SCOPED_DEFECTS {
            if coordinate_mask & (1 << coordinate) != 0 {
                for vertex in 0..COORDINATES {
                    union[vertex] |= coordinate_adjacency[coordinate][vertex];
                }
            }
        }
        let edge_count = union.iter().map(|mask| mask.count_ones()).sum::<u32>() as u8 / 2;
        let (minimum_elimination_width, elimination_order) = minimum_elimination_order(union);
        let (minimum_linear_frontier_width, linear_frontier_order) =
            minimum_linear_frontier_order(union);
        hasher.update([
            coordinate_mask,
            edge_count,
            minimum_elimination_width,
            minimum_linear_frontier_width,
        ]);
        hasher.update(elimination_order);
        hasher.update(linear_frontier_order);
        scopes.push(G41Q174Q87InteractionScopeReport {
            coordinate_mask,
            edge_count,
            minimum_elimination_width,
            elimination_order,
            minimum_linear_frontier_width,
            linear_frontier_order,
        });
    }
    Ok(G41Q174Q87InteractionReport {
        extractor: "ergodis-private.g41-q174-q87-interaction",
        extractor_version: 1,
        defect_shifts: G41_Q174_Q87_DEFECT_SHIFTS,
        coordinate_adjacency,
        scopes: scopes.into_boxed_slice(),
        semantic_commitment: hasher.finalize().into(),
        provenance: "exact factor graph extracted from the canonical multiplier-orbit q87 quadratic terms; every nonempty feature mask is evaluated over all 8! iterative elimination orders with deterministic lexicographic tie-breaking; this proves structural width only and authorizes no search rejection by itself",
    })
}

fn q87_phase_relations() -> Result<[G41Q174Q87PhaseRelation; 7], G41Q174JointError> {
    let mut relations = [G41Q174Q87PhaseRelation {
        q29_shift: 0,
        repeated_q87_class: 0,
        singleton_q87_class: 0,
    }; 7];
    for (coordinate, coset) in Q29_COSETS.iter().enumerate() {
        let shift = coset[0];
        let mut classes = [
            canonical_q87_shift_class(shift),
            canonical_q87_shift_class(shift + 29),
            canonical_q87_shift_class(shift + 58),
        ];
        classes.sort_unstable();
        let (repeated, singleton) = if classes[0] == classes[1] && classes[1] != classes[2] {
            (classes[0], classes[2])
        } else if classes[0] != classes[1] && classes[1] == classes[2] {
            (classes[1], classes[0])
        } else {
            return Err(G41Q174JointError::SemanticMismatch);
        };
        relations[coordinate] = G41Q174Q87PhaseRelation {
            q29_shift: shift as u8,
            repeated_q87_class: repeated as u8,
            singleton_q87_class: singleton as u8,
        };
    }
    Ok(relations)
}

#[cfg(test)]
fn q87_phase_relation_value(
    layout: &Layout,
    state: u128,
    coordinate: usize,
    relation: G41Q174Q87PhaseRelation,
) -> Result<i32, G41Q174JointError> {
    let observation = q87_phase_observation(layout, state, coordinate, relation)?;
    Ok(2 * observation[0] + observation[1] - 2 * observation[2] - observation[3])
}

#[cfg(test)]
fn q87_phase_observation(
    layout: &Layout,
    state: u128,
    coordinate: usize,
    relation: G41Q174Q87PhaseRelation,
) -> Result<[i32; 4], G41Q174JointError> {
    let defects = q87_defect_vector(layout, state)?;
    Ok([
        i32::from(defects[usize::from(relation.repeated_q87_class - 1)]),
        i32::from(defects[usize::from(relation.singleton_q87_class - 1)]),
        i32::from(q87_energy(q87_state(layout, state))),
        quotient_defects(projection(layout, state))[coordinate],
    ])
}

fn q87_phase_observations(
    layout: &Layout,
    relations: [G41Q174Q87PhaseRelation; 7],
    state: u128,
) -> Result<[[i32; 4]; 7], G41Q174JointError> {
    let defects = q87_defect_vector(layout, state)?;
    let energy = i32::from(q87_energy(q87_state(layout, state)));
    let q29_defects = quotient_defects(projection(layout, state));
    Ok(std::array::from_fn(|coordinate| {
        let relation = relations[coordinate];
        [
            i32::from(defects[usize::from(relation.repeated_q87_class - 1)]),
            i32::from(defects[usize::from(relation.singleton_q87_class - 1)]),
            energy,
            q29_defects[coordinate],
        ]
    }))
}

/// Proves the three-phase q87-to-q29 defect identity on the complete
/// quadratic basis of canonical q174 multiplier-orbit coefficient space.
pub fn prove_g41_q174_q87_phase_relations() -> Result<G41Q174Q87PhaseProofReport, G41Q174JointError>
{
    let layout = compile_layout()?;
    let relations = q87_phase_relations()?;
    let mut basis_states = Vec::with_capacity(1 + 2 * CLASSES + CLASSES * (CLASSES - 1) / 2);
    basis_states.push(0);
    for lane in 0..CLASSES {
        basis_states.push(1_u128 << (2 * lane));
        basis_states.push(2_u128 << (2 * lane));
    }
    for first in 0..CLASSES {
        for second in first + 1..CLASSES {
            basis_states.push((1_u128 << (2 * first)) | (1_u128 << (2 * second)));
        }
    }
    let mut basis_observations = Vec::with_capacity(basis_states.len());
    for state in basis_states {
        let observations = q87_phase_observations(&layout, relations, state)?;
        if observations
            .iter()
            .any(|row| 2 * row[0] + row[1] - 2 * row[2] - row[3] != 0)
        {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        basis_observations.push(observations);
    }
    let quadratic_basis_checks = basis_observations.len() as u32;
    let mut evolution_candidates_tested = 0_u64;
    let mut evolved_coefficients = [[0_i8; 4]; 7];
    for coordinate in 0..relations.len() {
        let observations = basis_observations
            .iter()
            .map(|rows| rows[coordinate])
            .collect::<Vec<_>>();
        let mut output = [[0_i8; 4]; 2];
        let (tested, found) = evolve_bounded_homogeneous_relations(&observations, 2, &mut output)
            .map_err(|_| G41Q174JointError::SemanticMismatch)?;
        if found != 1 {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        evolution_candidates_tested += tested;
        evolved_coefficients[coordinate] = output[0];
    }
    let mut hasher = Sha256::new();
    hasher.update(b"ergodis-private:g41-q174-q87-phase-proof:v1");
    hasher.update((MODULUS as u16).to_le_bytes());
    hasher.update((Q87_MODULUS as u16).to_le_bytes());
    hasher.update((29_u16).to_le_bytes());
    hasher.update((41_u16).to_le_bytes());
    hasher.update(quadratic_basis_checks.to_le_bytes());
    hasher.update(evolution_candidates_tested.to_le_bytes());
    for relation in relations {
        hasher.update([
            relation.q29_shift,
            relation.repeated_q87_class,
            relation.singleton_q87_class,
        ]);
    }
    for coefficients in evolved_coefficients {
        hasher.update(coefficients.map(|value| value as u8));
    }
    Ok(G41Q174Q87PhaseProofReport {
        extractor: "ergodis-private.g41-q174-q87-phase-proof",
        extractor_version: 1,
        relations,
        quadratic_basis_checks,
        evolution_candidates_tested,
        evolved_coefficients,
        proof_commitment: hasher.finalize().into(),
        verified: true,
        provenance: "symbolic quadratic proof over the canonical 46-lane q174 multiplier-invariant coefficient space: for each q29 shift, the three q87 phase correlations at s,s+29,s+58 sum to its q29 correlation; q87 multiplier/conjugacy symmetry identifies two phase defects, giving 2*D_repeated + D_singleton = 2*D_29 + D_q29; zero, both diagonal basis values, and every cross-lane basis pair are checked, so no observed target fibre or large certificate is trusted",
    })
}

fn canonical_q87_shift_class(shift: usize) -> usize {
    let mut point = shift;
    let mut minimum = shift.min(Q87_MODULUS - shift);
    loop {
        point = point * 41 % Q87_MODULUS;
        minimum = minimum.min(point.min(Q87_MODULUS - point));
        if point == shift {
            return minimum;
        }
    }
}

#[inline(always)]
const fn coefficient(state: u128, class: usize) -> u8 {
    ((state >> (LANE_BITS * class as u32)) & 3) as u8
}

#[inline(always)]
fn add_states(left: u128, right: u128) -> u128 {
    left + right
}

#[inline(always)]
fn state_complement(state: u128, target: u128) -> Option<u128> {
    let mut complement = 0_u128;
    for class in 0..CLASSES {
        let value = coefficient(target, class).checked_sub(coefficient(state, class))?;
        complement |= u128::from(value) << (LANE_BITS * class as u32);
    }
    Some(complement)
}

#[inline(always)]
fn state_sum_within(first: u128, second: u128, target: u128) -> Option<u128> {
    let mut sum = 0_u128;
    for class in 0..CLASSES {
        let value = coefficient(first, class) + coefficient(second, class);
        if value > coefficient(target, class) {
            return None;
        }
        sum |= u128::from(value) << (LANE_BITS * class as u32);
    }
    Some(sum)
}

fn orbit_state(layout: &Layout, orbit: &FineOrbit) -> Result<u128, G41Q174JointError> {
    let mut state = 0_u128;
    for class in 0..CLASSES {
        let representative = usize::from(layout.representatives[class]);
        let value = orbit.points[..usize::from(orbit.len)]
            .iter()
            .filter(|&&point| usize::from(point) % MODULUS == representative)
            .count() as u8;
        if value > 3 {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        for residue in 0..MODULUS {
            if usize::from(layout.class_of[residue]) == class
                && orbit.points[..usize::from(orbit.len)]
                    .iter()
                    .filter(|&&point| usize::from(point) % MODULUS == residue)
                    .count() as u8
                    != value
            {
                return Err(G41Q174JointError::SemanticMismatch);
            }
        }
        state |= u128::from(value) << (LANE_BITS * class as u32);
    }
    Ok(state)
}

impl G41Q174SourceFeasibilityWorkspace {
    pub fn new(mask: u8, digits: u32) -> Result<Self, G41Q174JointError> {
        if mask >= 64 {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        let layout = compile_layout()?;
        let inventory = compile_inventory()?;
        let target_counts = digit_counts(digits);
        if (0..SLOTS).any(|slot| target_counts[slot] > inventory.large_len[slot]) {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        let radices = target_counts.map(|count| u32::from(count) + 1);
        let state_count = radices
            .iter()
            .try_fold(1_usize, |product, &radix| {
                product.checked_mul(radix as usize)
            })
            .ok_or(G41Q174JointError::StateBudget {
                side: 8,
                stage: 0,
                states: u64::MAX,
            })?;
        let mut fixed_state = 0_u128;
        let mut multiplicities = [[0_u8; SLOTS]; CLASSES];
        for slot in 0..SLOTS {
            if mask & (1 << slot) != 0 {
                fixed_state =
                    add_states(fixed_state, orbit_state(&layout, &inventory.small[slot])?);
            }
            for orbit in &inventory.large[slot][..usize::from(inventory.large_len[slot])] {
                let state = orbit_state(&layout, orbit)?;
                let mut nonzero = None;
                for class in 0..CLASSES {
                    let value = coefficient(state, class);
                    if value == 0 {
                        continue;
                    }
                    if value != if slot < 4 { 1 } else { 3 } || nonzero.is_some() {
                        return Err(G41Q174JointError::SemanticMismatch);
                    }
                    nonzero = Some(class);
                }
                let class = nonzero.ok_or(G41Q174JointError::SemanticMismatch)?;
                multiplicities[class][slot] = multiplicities[class][slot]
                    .checked_add(1)
                    .ok_or(G41Q174JointError::SemanticMismatch)?;
            }
        }
        let mut hasher = Sha256::new();
        hasher.update(b"c1016.g41.q174.source-feasibility");
        hasher.update(1_u16.to_le_bytes());
        hasher.update(mask.to_le_bytes());
        hasher.update(digits.to_le_bytes());
        hasher.update(fixed_state.to_le_bytes());
        for lanes in multiplicities {
            hasher.update(lanes);
        }
        let semantic_commitment = hasher.finalize().into();
        Ok(Self {
            mask,
            digits,
            target_counts,
            radices,
            state_count,
            fixed_state,
            multiplicities,
            current_seen: vec![0_u8; state_count].into_boxed_slice(),
            next_seen: vec![0_u8; state_count].into_boxed_slice(),
            current: Vec::with_capacity(state_count),
            next: Vec::with_capacity(state_count),
            semantic_commitment,
        })
    }

    pub fn workspace_bytes(&self) -> u64 {
        (self.state_count * (2 + 2 * std::mem::size_of::<u32>())) as u64
    }

    #[inline(always)]
    fn encode(&self, counts: [u8; SLOTS]) -> u32 {
        let mut key = 0_u32;
        let mut stride = 1_u32;
        for slot in 0..SLOTS {
            key += u32::from(counts[slot]) * stride;
            stride *= self.radices[slot];
        }
        key
    }

    #[inline(always)]
    fn decode(&self, mut key: u32) -> [u8; SLOTS] {
        std::array::from_fn(|slot| {
            let count = (key % self.radices[slot]) as u8;
            key /= self.radices[slot];
            count
        })
    }

    fn clear(&mut self) {
        for &key in &self.current {
            self.current_seen[key as usize] = 0;
        }
        for &key in &self.next {
            self.next_seen[key as usize] = 0;
        }
        self.current.clear();
        self.next.clear();
    }

    fn check_impl(
        &mut self,
        q29_coefficients: [u8; COORDINATES],
        target_state: u128,
        states_after_lane: &mut [u32; CLASSES],
    ) -> Result<bool, G41Q174JointError> {
        if target_state & !STATE_MASK != 0 || q29_coefficients.iter().any(|&value| value > 18) {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        let layout = compile_layout()?;
        if projection(&layout, target_state) != q29_coefficients {
            return Ok(false);
        }
        let mut residual = 0_u128;
        for class in 0..CLASSES {
            let Some(value) =
                coefficient(target_state, class).checked_sub(coefficient(self.fixed_state, class))
            else {
                return Ok(false);
            };
            residual |= u128::from(value) << (LANE_BITS * class as u32);
        }
        self.clear();
        self.current.push(0);
        self.current_seen[0] = 1;
        let mut choices = [LaneChoice::default(); 729];
        for class in 0..CLASSES {
            for &key in &self.next {
                self.next_seen[key as usize] = 0;
            }
            self.next.clear();
            let target = coefficient(residual, class);
            let choice_count =
                compile_lane_choices(self.multiplicities[class], target, &mut choices);
            if choice_count == 0 {
                return Ok(false);
            }
            for &key in &self.current {
                let used = self.decode(key);
                for choice in &choices[..choice_count] {
                    let mut combined = [0_u8; SLOTS];
                    let mut within = true;
                    for slot in 0..SLOTS {
                        combined[slot] = used[slot] + choice.used[slot];
                        within &= combined[slot] <= self.target_counts[slot];
                    }
                    if !within {
                        continue;
                    }
                    let next_key = self.encode(combined);
                    if self.next_seen[next_key as usize] == 0 {
                        self.next_seen[next_key as usize] = 1;
                        self.next.push(next_key);
                    }
                }
            }
            for &key in &self.current {
                self.current_seen[key as usize] = 0;
            }
            std::mem::swap(&mut self.current, &mut self.next);
            std::mem::swap(&mut self.current_seen, &mut self.next_seen);
            states_after_lane[class] = self.current.len() as u32;
            if self.current.is_empty() {
                return Ok(false);
            }
        }
        Ok(self.current_seen[self.encode(self.target_counts) as usize] != 0)
    }

    pub fn check(
        &mut self,
        q29_coefficients: [u8; COORDINATES],
        target_state: u128,
    ) -> Result<bool, G41Q174JointError> {
        self.check_impl(q29_coefficients, target_state, &mut [0; CLASSES])
    }

    pub fn report(
        &mut self,
        q29_coefficients: [u8; COORDINATES],
        target_state: u128,
    ) -> Result<G41Q174SourceFeasibilityReport, G41Q174JointError> {
        let mut states_after_lane = [0_u32; CLASSES];
        let feasible = self.check_impl(q29_coefficients, target_state, &mut states_after_lane)?;
        Ok(G41Q174SourceFeasibilityReport {
            mask: self.mask,
            digits: self.digits,
            q29_coefficients,
            target_state,
            feasible,
            states_after_lane: states_after_lane.into(),
            workspace_bytes: self.workspace_bytes(),
            semantic_commitment: self.semantic_commitment,
            provenance: "sealed exact whole-fibre source-membership theorem: every selectable large orbit is rebound to its canonical q174 lane, and a bounded iterative six-row lane DP decides whether all 46 lane demands and source row counts are simultaneously realizable; no source preimage is selected, recursion and hot-loop allocation are absent",
        })
    }
}

fn compile_lane_choices(
    multiplicities: [u8; SLOTS],
    target: u8,
    output: &mut [LaneChoice; 729],
) -> usize {
    let mut combinations = 1_u32;
    for multiplicity in multiplicities {
        combinations *= u32::from(multiplicity) + 1;
    }
    let mut length = 0_usize;
    for mut code in 0..combinations {
        let mut used = [0_u8; SLOTS];
        let mut value = 0_u8;
        for slot in 0..SLOTS {
            let radix = u32::from(multiplicities[slot]) + 1;
            used[slot] = (code % radix) as u8;
            code /= radix;
            value += used[slot] * if slot < 4 { 1 } else { 3 };
        }
        if value == target {
            output[length] = LaneChoice { used };
            length += 1;
        }
    }
    length
}

#[inline(always)]
fn residue_coefficient(layout: &Layout, state: u128, residue: usize) -> u8 {
    coefficient(state, usize::from(layout.class_of[residue]))
}

fn projection(layout: &Layout, state: u128) -> [u8; COORDINATES] {
    std::array::from_fn(|coordinate| {
        let residue = if coordinate == 0 {
            0
        } else {
            Q29_COSETS[coordinate - 1][0]
        };
        (0..6)
            .map(|lift| residue_coefficient(layout, state, residue + 29 * lift))
            .sum()
    })
}

#[inline(always)]
fn projection_within(layout: &Layout, state: u128, target: [u8; COORDINATES]) -> bool {
    projection(layout, state)
        .into_iter()
        .zip(target)
        .all(|(value, target)| value <= target)
}

fn pack_projection(values: [u8; COORDINATES]) -> Option<u64> {
    let mut packed = 0_u64;
    for value in values {
        if value > 31 {
            return None;
        }
        packed = (packed << 5) | u64::from(value);
    }
    Some(packed)
}

fn complement_key(layout: &Layout, state: u128, target: [u8; COORDINATES]) -> Option<u64> {
    let values = projection(layout, state);
    let mut complement = [0_u8; COORDINATES];
    for coordinate in 0..COORDINATES {
        complement[coordinate] = target[coordinate].checked_sub(values[coordinate])?;
    }
    pack_projection(complement)
}

fn slot_states(
    layout: &Layout,
    inventory: &FineInventory,
    slot: usize,
    mask: u8,
    count: u8,
) -> Result<Vec<u128>, G41Q174JointError> {
    let initial = if mask & (1 << slot) != 0 {
        orbit_state(layout, &inventory.small[slot])?
    } else {
        0
    };
    let length = inventory.large_len[slot];
    let mut large_states = [0_u128; 14];
    for orbit in 0..length {
        large_states[usize::from(orbit)] =
            orbit_state(layout, &inventory.large[slot][usize::from(orbit)])?;
    }
    let mut states = Vec::with_capacity(1_usize << length);
    for subset in 0_u16..1_u16 << length {
        if subset.count_ones() != u32::from(count) {
            continue;
        }
        let mut state = initial;
        for orbit in 0..length {
            if subset & (1 << orbit) != 0 {
                state = add_states(state, large_states[usize::from(orbit)]);
            }
        }
        states.push(state);
    }
    states.sort_unstable();
    states.dedup();
    Ok(states)
}

fn slot_choices(
    layout: &Layout,
    inventory: &FineInventory,
    slot: usize,
    mask: u8,
    count: u8,
) -> Result<Vec<SlotChoice>, G41Q174JointError> {
    let initial = if mask & (1 << slot) != 0 {
        orbit_state(layout, &inventory.small[slot])?
    } else {
        0
    };
    let length = inventory.large_len[slot];
    let mut large_states = [0_u128; 14];
    for orbit in 0..length {
        large_states[usize::from(orbit)] =
            orbit_state(layout, &inventory.large[slot][usize::from(orbit)])?;
    }
    let mut choices = Vec::with_capacity(1_usize << length);
    for subset in 0_u16..1_u16 << length {
        if subset.count_ones() != u32::from(count) {
            continue;
        }
        let mut state = initial;
        for orbit in 0..length {
            if subset & (1 << orbit) != 0 {
                state = add_states(state, large_states[usize::from(orbit)]);
            }
        }
        choices.push(SlotChoice {
            state,
            orbit_mask: subset,
        });
    }
    choices.sort_unstable();
    choices.dedup_by_key(|choice| choice.state);
    Ok(choices)
}

fn compile_partitioned_sides(
    layout: &Layout,
    contributions: [&[u128]; SLOTS],
    cardinalities: [u32; SLOTS],
    target: [u8; COORDINATES],
    side_base: u8,
) -> Result<
    (
        [usize; 3],
        [usize; 3],
        Vec<u128>,
        Vec<u128>,
        Vec<G41Q174PartitionAttempt>,
    ),
    G41Q174JointError,
> {
    compile_partitioned_sides_with_limit(
        layout,
        contributions,
        cardinalities,
        target,
        side_base,
        MAX_SIDE_STATES,
    )
}

fn compile_partitioned_sides_with_limit(
    layout: &Layout,
    contributions: [&[u128]; SLOTS],
    cardinalities: [u32; SLOTS],
    target: [u8; COORDINATES],
    side_base: u8,
    maximum_states: usize,
) -> Result<
    (
        [usize; 3],
        [usize; 3],
        Vec<u128>,
        Vec<u128>,
        Vec<G41Q174PartitionAttempt>,
    ),
    G41Q174JointError,
> {
    let mut candidates = [([0_usize; 3], [0_usize; 3], u128::MAX); 10];
    let mut candidate = 0_usize;
    for second in 1..SLOTS - 1 {
        for third in second + 1..SLOTS {
            let mut left = [0, second, third];
            let mut right = [0_usize; 3];
            let mut cursor = 0;
            for slot in 0..SLOTS {
                if !left.contains(&slot) {
                    right[cursor] = slot;
                    cursor += 1;
                }
            }
            left.sort_unstable_by_key(|&slot| cardinalities[slot]);
            right.sort_unstable_by_key(|&slot| cardinalities[slot]);
            let score = [left, right]
                .map(|slots| {
                    slots
                        .into_iter()
                        .map(|slot| u128::from(cardinalities[slot]))
                        .product::<u128>()
                })
                .into_iter()
                .max()
                .unwrap_or(u128::MAX);
            candidates[candidate] = (left, right, score);
            candidate += 1;
        }
    }
    candidates.sort_unstable_by_key(|&(left, right, score)| (score, left, right));
    let mut last_budget = None;
    let mut attempts = Vec::with_capacity(candidates.len());
    for (left_slots, right_slots, score) in candidates {
        let maximum_raw_product = score
            .try_into()
            .map_err(|_| G41Q174JointError::StateBudget {
                side: side_base,
                stage: 0,
                states: u64::MAX,
            })?;
        let left = match compile_side(
            layout,
            left_slots.map(|slot| contributions[slot]),
            target,
            side_base,
            maximum_states,
        ) {
            Ok(states) => states,
            Err(
                error @ G41Q174JointError::StateBudget {
                    side,
                    stage,
                    states,
                },
            ) => {
                attempts.push(G41Q174PartitionAttempt {
                    left_slots: left_slots.map(|slot| slot as u8),
                    right_slots: right_slots.map(|slot| slot as u8),
                    maximum_raw_product,
                    left_states: None,
                    right_states: None,
                    failed_side: Some(side),
                    failed_stage: Some(stage),
                    failure_states: Some(states),
                });
                last_budget = Some(error);
                continue;
            }
            Err(error) => return Err(error),
        };
        let right = match compile_side(
            layout,
            right_slots.map(|slot| contributions[slot]),
            target,
            side_base + 1,
            maximum_states,
        ) {
            Ok(states) => states,
            Err(
                error @ G41Q174JointError::StateBudget {
                    side,
                    stage,
                    states,
                },
            ) => {
                attempts.push(G41Q174PartitionAttempt {
                    left_slots: left_slots.map(|slot| slot as u8),
                    right_slots: right_slots.map(|slot| slot as u8),
                    maximum_raw_product,
                    left_states: Some(left.len() as u32),
                    right_states: None,
                    failed_side: Some(side),
                    failed_stage: Some(stage),
                    failure_states: Some(states),
                });
                last_budget = Some(error);
                continue;
            }
            Err(error) => return Err(error),
        };
        attempts.push(G41Q174PartitionAttempt {
            left_slots: left_slots.map(|slot| slot as u8),
            right_slots: right_slots.map(|slot| slot as u8),
            maximum_raw_product,
            left_states: Some(left.len() as u32),
            right_states: Some(right.len() as u32),
            failed_side: None,
            failed_stage: None,
            failure_states: None,
        });
        return Ok((left_slots, right_slots, left, right, attempts));
    }
    Err(last_budget.unwrap_or(G41Q174JointError::SemanticMismatch))
}

fn compile_side(
    layout: &Layout,
    slots: [&[u128]; 3],
    target: [u8; COORDINATES],
    side: u8,
    maximum_states: usize,
) -> Result<Vec<u128>, G41Q174JointError> {
    let mut current = vec![0_u128];
    for (stage, contributions) in slots.into_iter().enumerate() {
        let raw = current.len().saturating_mul(contributions.len());
        let mut next = Vec::with_capacity(raw.min(maximum_states));
        for &left in &current {
            for &right in contributions {
                let state = add_states(left, right);
                if projection_within(layout, state, target) {
                    if next.len() == maximum_states {
                        return Err(G41Q174JointError::StateBudget {
                            side,
                            stage: stage as u8,
                            states: maximum_states as u64 + 1,
                        });
                    }
                    next.push(state);
                }
            }
        }
        next.sort_unstable();
        next.dedup();
        current = next;
    }
    Ok(current)
}

fn quotient_defects(q29: [u8; COORDINATES]) -> [i32; 7] {
    let mut values = [0_i32; 29];
    values[0] = i32::from(q29[0]);
    for (coordinate, coset) in Q29_COSETS.iter().enumerate() {
        for &residue in coset {
            values[residue] = i32::from(q29[coordinate + 1]);
        }
    }
    let zero: i32 = values.iter().map(|&value| value * value).sum();
    std::array::from_fn(|coordinate| {
        let shift = Q29_COSETS[coordinate][0];
        zero - (0..29)
            .map(|residue| values[residue] * values[(residue + shift) % 29])
            .sum::<i32>()
    })
}

#[cfg(test)]
fn q58_coefficients(layout: &Layout, state: u128) -> [i32; 58] {
    std::array::from_fn(|residue| {
        (0..3)
            .map(|lift| i32::from(residue_coefficient(layout, state, residue + 58 * lift)))
            .sum()
    })
}

#[cfg(test)]
fn q87_coefficients(layout: &Layout, state: u128) -> [i32; 87] {
    std::array::from_fn(|residue| {
        i32::from(residue_coefficient(layout, state, residue))
            + i32::from(residue_coefficient(layout, state, residue + 87))
    })
}

#[inline(always)]
fn q58_lane(state: u64, class: usize) -> i32 {
    ((state >> (4 * class)) & 15) as i32
}

#[inline(always)]
fn q58_state(layout: &Layout, q58_layout: &Q58Layout, state: u128) -> u64 {
    let mut packed = 0_u64;
    for class in 0..Q58_CLASSES {
        let residue = usize::from(q58_layout.representatives[class]);
        let value: u8 = (0..3)
            .map(|lift| residue_coefficient(layout, state, residue + 58 * lift))
            .sum();
        packed |= u64::from(value) << (4 * class);
    }
    packed
}

fn q87_state(layout: &Layout, state: u128) -> u128 {
    let mut packed = 0_u128;
    for coordinate in 0..COORDINATES {
        let residue = if coordinate == 0 {
            0
        } else {
            Q29_COSETS[coordinate - 1][0]
        };
        for lift in 0..3 {
            let value = residue_coefficient(layout, state, residue + 29 * lift)
                + residue_coefficient(layout, state, residue + 29 * lift + 87);
            packed |= u128::from(value) << (3 * (3 * coordinate + lift));
        }
    }
    packed
}

#[inline(always)]
fn q87_energy(state: u128) -> u16 {
    let mut energy = 0_i32;
    for coordinate in 0..COORDINATES {
        let values: [i32; 3] =
            std::array::from_fn(|lift| ((state >> (3 * (3 * coordinate + lift))) & 7) as i32);
        let [a, b, c] = values;
        let local = a * a + b * b + c * c - a * b - b * c - c * a;
        energy += if coordinate == 0 { local } else { 4 * local };
    }
    energy as u16
}

impl Q87EnergyBounds {
    const PARTIAL_STATES: usize = 7 * 7 * 7;
    const REMAINING_SUMS: usize = 19;

    fn compile() -> Self {
        let mut local =
            vec![Q87LocalEnergyBounds::default(); Self::PARTIAL_STATES * Self::REMAINING_SUMS]
                .into_boxed_slice();
        for a in 0..=6_u8 {
            for b in 0..=6_u8 {
                for c in 0..=6_u8 {
                    let partial = usize::from(a) + 7 * (usize::from(b) + 7 * usize::from(c));
                    for da in 0..=6 - a {
                        for db in 0..=6 - b {
                            for dc in 0..=6 - c {
                                let remaining = usize::from(da + db + dc);
                                let values = [a + da, b + db, c + dc].map(i16::from);
                                let [x, y, z] = values;
                                let energy = (x * x + y * y + z * z - x * y - y * z - z * x) as u8;
                                let bound = &mut local[partial * Self::REMAINING_SUMS + remaining];
                                if !bound.valid {
                                    bound.minimum = energy;
                                    bound.maximum = energy;
                                    bound.valid = true;
                                } else {
                                    bound.minimum = bound.minimum.min(energy);
                                    bound.maximum = bound.maximum.max(energy);
                                }
                                bound.residues_mod_four |= 1 << (energy & 3);
                            }
                        }
                    }
                }
            }
        }
        Self { local }
    }

    #[inline(always)]
    fn get(&self, a: u8, b: u8, c: u8, remaining: u8) -> Q87LocalEnergyBounds {
        if a > 6 || b > 6 || c > 6 || remaining > 18 {
            return Q87LocalEnergyBounds::default();
        }
        let partial = usize::from(a) + 7 * (usize::from(b) + 7 * usize::from(c));
        self.local[partial * Self::REMAINING_SUMS + usize::from(remaining)]
    }
}

#[inline(always)]
fn q87_target_energy_within_bounds(
    bounds: &Q87EnergyBounds,
    partial_state: u128,
    q29_target: [u8; COORDINATES],
    target_energies: &[u16],
) -> bool {
    let mut minimum = 0_u16;
    let mut maximum = 0_u16;
    let mut zero_residues = 0_u8;
    for coordinate in 0..COORDINATES {
        let lanes: [u8; 3] = std::array::from_fn(|lift| {
            ((partial_state >> (3 * (3 * coordinate + lift))) & 7) as u8
        });
        let Some(remaining) = q29_target[coordinate].checked_sub(lanes.into_iter().sum()) else {
            return false;
        };
        let local = bounds.get(lanes[0], lanes[1], lanes[2], remaining);
        if !local.valid {
            return false;
        }
        let weight = if coordinate == 0 { 1 } else { 4 };
        minimum += u16::from(local.minimum) * weight;
        maximum += u16::from(local.maximum) * weight;
        if coordinate == 0 {
            zero_residues = local.residues_mod_four;
        }
    }
    target_energies.iter().any(|&energy| {
        (minimum..=maximum).contains(&energy) && zero_residues & (1 << (energy & 3)) != 0
    })
}

pub fn g41_q174_q87_energy(target_state: u128) -> Result<u16, G41Q174JointError> {
    if target_state & !STATE_MASK != 0 {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    Ok(q87_energy(q87_state(&layout, target_state)))
}

pub fn g41_q174_joint_profile(
    target_state: u128,
) -> Result<G41Q174JointProfile, G41Q174JointError> {
    if target_state & !STATE_MASK != 0 {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let q58_layout = compile_q58_layout()?;
    let q87_layout = compile_q87_layout()?;
    let q29_coefficients = projection(&layout, target_state);
    let (q58_energy, q58_residuals) = q58_profile(
        &q58_layout,
        q58_state(&layout, &q58_layout, target_state),
        quotient_defects(q29_coefficients),
    )
    .ok_or(G41Q174JointError::SemanticMismatch)?;
    let q87_state = q87_state(&layout, target_state);
    Ok(G41Q174JointProfile {
        q58_energy,
        q58_residuals,
        q87_energy: q87_energy(q87_state),
        q87_defects: q87_defects(&q87_layout, q87_state)
            .ok_or(G41Q174JointError::SemanticMismatch)?,
    })
}

const FLIP_PROFILE_COORDINATES: usize = 11;

fn q29_coset_complement_generators(
    layout: &Layout,
) -> Result<([u128; 7], [[u8; 4]; 7]), G41Q174JointError> {
    let mut generators = [0_u128; 7];
    let mut changed_lanes = [[u8::MAX; 4]; 7];
    let mut lengths = [0_usize; 7];
    for lane in 0..CLASSES {
        let representative = usize::from(layout.representatives[lane]);
        let residue = representative % 29;
        let Some(coordinate) = Q29_COSETS.iter().position(|coset| coset.contains(&residue)) else {
            continue;
        };
        if representative % 3 == 0 {
            continue;
        }
        let index = lengths[coordinate];
        if index == 4 {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        changed_lanes[coordinate][index] = lane as u8;
        generators[coordinate] |= 3_u128 << (2 * lane);
        lengths[coordinate] += 1;
    }
    if lengths != [4; 7]
        || generators.iter().enumerate().any(|(index, &generator)| {
            generators[..index]
                .iter()
                .any(|&previous| previous & generator != 0)
        })
    {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    Ok((generators, changed_lanes))
}

fn raw_joint_profile_values(
    layout: &Layout,
    q58_layout: &Q58Layout,
    q87_layout: &Q87Layout,
    state: u128,
) -> [i32; FLIP_PROFILE_COORDINATES] {
    let q58 = q58_state(layout, q58_layout, state);
    let difference: [i32; 29] = std::array::from_fn(|residue| {
        let first = q58_lane(q58, usize::from(q58_layout.class_of[residue]));
        let second = q58_lane(q58, usize::from(q58_layout.class_of[residue + 29]));
        if residue & 1 == 0 {
            first - second
        } else {
            second - first
        }
    });
    let q58_energy: i32 = difference.iter().map(|&value| value * value).sum();
    let q58_residuals: [i32; 7] = std::array::from_fn(|coordinate| {
        let shift = Q29_COSETS[coordinate][0];
        (0..29)
            .map(|residue| difference[residue] * difference[(residue + shift) % 29])
            .sum()
    });
    let q87 = q87_state(layout, state);
    let values: [i32; 24] = std::array::from_fn(|lane| ((q87 >> (3 * lane)) & 7) as i32);
    let q87_zero: i32 = values
        .iter()
        .zip(q87_layout.lane_weights)
        .map(|(&value, weight)| i32::from(weight) * value * value)
        .sum();
    let q87_defects: [i32; G41_Q174_Q87_SCOPED_DEFECTS] = std::array::from_fn(|coordinate| {
        q87_zero
            - q87_layout.terms[coordinate][..usize::from(q87_layout.term_lengths[coordinate])]
                .iter()
                .map(|term| {
                    i32::from(term.weight)
                        * values[usize::from(term.first)]
                        * values[usize::from(term.second)]
                })
                .sum::<i32>()
    });
    let mut output = [0_i32; FLIP_PROFILE_COORDINATES];
    output[0] = q58_energy;
    output[1..8].copy_from_slice(&q58_residuals);
    output[8] = i32::from(q87_energy(q87));
    output[9..].copy_from_slice(&q87_defects);
    output
}

fn flip_difference(
    layout: &Layout,
    q58_layout: &Q58Layout,
    q87_layout: &Q87Layout,
    generator: u128,
    feature: usize,
    state: u128,
) -> i32 {
    raw_joint_profile_values(layout, q58_layout, q87_layout, state ^ generator)[feature]
        - raw_joint_profile_values(layout, q58_layout, q87_layout, state)[feature]
}

fn fixed_flip_pattern_is_symbolic_symmetry(
    layout: &Layout,
    q58_layout: &Q58Layout,
    q87_layout: &Q87Layout,
    generator: u128,
    lanes: [u8; 4],
    pattern: u8,
) -> bool {
    let mut base = 0_u128;
    for (index, &lane) in lanes.iter().enumerate() {
        if pattern & (1 << index) != 0 {
            base |= 3_u128 << (2 * usize::from(lane));
        }
    }
    for feature in 0..FLIP_PROFILE_COORDINATES {
        if flip_difference(layout, q58_layout, q87_layout, generator, feature, base) != 0 {
            return false;
        }
        for first in 0..CLASSES {
            if generator & (3_u128 << (2 * first)) != 0 {
                continue;
            }
            let unit = 1_u128 << (2 * first);
            if flip_difference(
                layout,
                q58_layout,
                q87_layout,
                generator,
                feature,
                base | unit,
            ) != 0
                || flip_difference(
                    layout,
                    q58_layout,
                    q87_layout,
                    generator,
                    feature,
                    base | (2 * unit),
                ) != 0
            {
                return false;
            }
            for second in first + 1..CLASSES {
                if generator & (3_u128 << (2 * second)) != 0 {
                    continue;
                }
                if flip_difference(
                    layout,
                    q58_layout,
                    q87_layout,
                    generator,
                    feature,
                    base | unit | (1_u128 << (2 * second)),
                ) != 0
                {
                    return false;
                }
            }
        }
    }
    true
}

pub fn prove_g41_q174_coset_complement_symmetry(
) -> Result<G41Q174FlipProofReport, G41Q174JointError> {
    let layout = compile_layout()?;
    let q58_layout = compile_q58_layout()?;
    let q87_layout = compile_q87_layout()?;
    let (generators, changed_lanes) = q29_coset_complement_generators(&layout)?;
    let inventory = compile_inventory()?;
    let mut source_multiplicities = [[0_u8; SLOTS]; CLASSES];
    for slot in 0..SLOTS {
        let small = orbit_state(&layout, &inventory.small[slot])?;
        if generators.iter().any(|&generator| small & generator != 0) {
            return Err(G41Q174JointError::SemanticMismatch);
        }
        for orbit in &inventory.large[slot][..usize::from(inventory.large_len[slot])] {
            let state = orbit_state(&layout, orbit)?;
            let mut source_lane = None;
            for lane in 0..CLASSES {
                if coefficient(state, lane) == 0 {
                    continue;
                }
                if source_lane.is_some() || coefficient(state, lane) != if slot < 4 { 1 } else { 3 }
                {
                    return Err(G41Q174JointError::SemanticMismatch);
                }
                source_lane = Some(lane);
            }
            let lane = source_lane.ok_or(G41Q174JointError::SemanticMismatch)?;
            source_multiplicities[lane][slot] += 1;
        }
    }
    let mut valid_pattern_masks = [[0_u8; 6]; 7];
    let mut valid_pattern_counts = [0_u8; 7];
    let mut hasher = Sha256::new();
    hasher.update(b"c1016.g41.q174.coset-complement-symmetry");
    hasher.update(1_u16.to_le_bytes());
    for multiplicities in source_multiplicities {
        hasher.update(multiplicities);
    }
    for (coordinate, (&generator, lanes)) in generators.iter().zip(changed_lanes).enumerate() {
        hasher.update(generator.to_le_bytes());
        hasher.update(lanes);
        for pattern in 0_u8..16 {
            if pattern.count_ones() != 2
                || !fixed_flip_pattern_is_symbolic_symmetry(
                    &layout,
                    &q58_layout,
                    &q87_layout,
                    generator,
                    lanes,
                    pattern,
                )
            {
                continue;
            }
            let index = usize::from(valid_pattern_counts[coordinate]);
            for slot in 0..SLOTS {
                let mut selected = 0_u8;
                let mut unselected = 0_u8;
                for (lane_index, &lane) in lanes.iter().enumerate() {
                    if pattern & (1 << lane_index) != 0 {
                        selected += source_multiplicities[usize::from(lane)][slot];
                    } else {
                        unselected += source_multiplicities[usize::from(lane)][slot];
                    }
                }
                if selected != unselected {
                    return Err(G41Q174JointError::SemanticMismatch);
                }
            }
            valid_pattern_masks[coordinate][index] = pattern;
            valid_pattern_counts[coordinate] += 1;
            hasher.update([pattern]);
        }
        if valid_pattern_counts[coordinate] == 0 {
            return Err(G41Q174JointError::SemanticMismatch);
        }
    }
    Ok(G41Q174FlipProofReport {
        extractor: "c1016.g41.q174.coset-complement-symmetry",
        extractor_version: 1,
        generator_words: generators.map(|generator| [generator as u64, (generator >> 64) as u64]),
        changed_lanes,
        valid_pattern_masks,
        valid_pattern_counts,
        profile_coordinates: FLIP_PROFILE_COORDINATES as u8,
        source_balance_verified: true,
        proof_commitment: hasher.finalize().into(),
        verified: true,
        provenance: "symbolic structural proof: the seven disjoint generators are derived canonically from nonzero q29 multiplier cosets and the q174 lanes nonzero modulo three; the six two-zero/two-three strata are proposed without observed-fibre input, exact quadratic interpolation over every outside lane and lane pair proves which strata preserve q58 energy, seven q58 correlations, q87 energy, and two independent scoped q87 coordinates, and canonical source-orbit extraction proves equal per-slot inventory on the two sides so orbit complementation is a source-level row-count-preserving bijection",
    })
}

pub fn probe_g41_q174_q87_energy_bounds(
    mask: u8,
    digits: u32,
    q29_coefficients: [u8; COORDINATES],
    target_q87_energies: &[u16],
) -> Result<G41Q174Q87EnergyBoundProbeReport, G41Q174JointError> {
    if mask >= 64
        || target_q87_energies.is_empty()
        || target_q87_energies.iter().any(|&energy| energy > 523)
        || q29_coefficients.iter().any(|&value| value > 18)
    {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let mut target_energies = target_q87_energies.to_vec();
    target_energies.sort_unstable();
    target_energies.dedup();
    let layout = compile_layout()?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let contributions = [
        slot_states(&layout, &inventory, 0, mask, counts[0])?,
        slot_states(&layout, &inventory, 1, mask, counts[1])?,
        slot_states(&layout, &inventory, 2, mask, counts[2])?,
        slot_states(&layout, &inventory, 3, mask, counts[3])?,
        slot_states(&layout, &inventory, 4, mask, counts[4])?,
        slot_states(&layout, &inventory, 5, mask, counts[5])?,
    ];
    let cardinalities = contributions.each_ref().map(|values| values.len() as u32);
    let (_left_slots, _right_slots, left, right, _attempts) = compile_partitioned_sides(
        &layout,
        contributions.each_ref().map(|values| values.as_slice()),
        cardinalities,
        q29_coefficients,
        10,
    )?;
    let mut right_keys = Vec::with_capacity(right.len());
    for &state in &right {
        right_keys.push(
            pack_projection(projection(&layout, state))
                .ok_or(G41Q174JointError::SemanticMismatch)?,
        );
    }
    right_keys.sort_unstable();
    let bounds = Q87EnergyBounds::compile();
    let mut left_states_with_complement = 0_u64;
    let mut left_states_rejected = 0_u64;
    let mut candidate_pairs = 0_u64;
    let mut pairs_avoided = 0_u64;
    let mut per_energy: Vec<G41Q174Q87EnergyScopeReport> = target_energies
        .iter()
        .map(|&target_q87_energy| G41Q174Q87EnergyScopeReport {
            target_q87_energy,
            left_states_rejected: 0,
            pairs_avoided: 0,
        })
        .collect();
    for &state in &left {
        let Some(key) = complement_key(&layout, state, q29_coefficients) else {
            continue;
        };
        let start = right_keys.partition_point(|&candidate| candidate < key);
        let end = right_keys.partition_point(|&candidate| candidate <= key);
        if start == end {
            continue;
        }
        left_states_with_complement += 1;
        candidate_pairs += (end - start) as u64;
        let q87_partial = q87_state(&layout, state);
        if !q87_target_energy_within_bounds(
            &bounds,
            q87_partial,
            q29_coefficients,
            &target_energies,
        ) {
            left_states_rejected += 1;
            pairs_avoided += (end - start) as u64;
        }
        for scope in &mut per_energy {
            if !q87_target_energy_within_bounds(
                &bounds,
                q87_partial,
                q29_coefficients,
                std::slice::from_ref(&scope.target_q87_energy),
            ) {
                scope.left_states_rejected += 1;
                scope.pairs_avoided += (end - start) as u64;
            }
        }
    }
    Ok(G41Q174Q87EnergyBoundProbeReport {
        mask,
        digits,
        q29_coefficients,
        target_q87_energies: target_energies.into_boxed_slice(),
        left_states: left.len() as u32,
        right_states: right.len() as u32,
        left_states_with_complement,
        left_states_rejected,
        candidate_pairs,
        pairs_avoided,
        per_energy: per_energy.into_boxed_slice(),
        workspace_bytes: contributions
            .iter()
            .map(|states| states.capacity() as u64 * std::mem::size_of::<u128>() as u64)
            .sum::<u64>()
            + left.capacity() as u64 * std::mem::size_of::<u128>() as u64
            + right.capacity() as u64 * std::mem::size_of::<u128>() as u64
            + right_keys.capacity() as u64 * std::mem::size_of::<u64>() as u64
            + bounds.local.len() as u64 * std::mem::size_of::<Q87LocalEnergyBounds>() as u64,
        provenance: "exact target-independent q87 energy-bound probe; fixed q29 sums turn each three-lift coordinate into a finite local energy set, seven coordinates contribute multiples of four, and the reported interval-plus-congruence rejection counts whole presorted complement ranges without visiting their pairs",
    })
}

#[inline(always)]
fn q87_defects(layout: &Q87Layout, state: u128) -> Option<[u16; G41_Q174_Q87_SCOPED_DEFECTS]> {
    let values: [i32; 24] = std::array::from_fn(|lane| ((state >> (3 * lane)) & 7) as i32);
    let zero: i32 = values
        .iter()
        .zip(layout.lane_weights)
        .map(|(&value, weight)| i32::from(weight) * value * value)
        .sum();
    let mut defects = [0_u16; G41_Q174_Q87_SCOPED_DEFECTS];
    for coordinate in 0..G41_Q174_Q87_SCOPED_DEFECTS {
        let correlation: i32 = layout.terms[coordinate]
            [..usize::from(layout.term_lengths[coordinate])]
            .iter()
            .map(|term| {
                i32::from(term.weight)
                    * values[usize::from(term.first)]
                    * values[usize::from(term.second)]
            })
            .sum();
        defects[coordinate] = (zero - correlation).try_into().ok()?;
        if defects[coordinate] > 523 {
            return None;
        }
    }
    Some(defects)
}

fn q58_profile(
    layout: &Q58Layout,
    state: u64,
    q29_defects: [i32; 7],
) -> Option<(u16, ResidualTuple<i16, 7>)> {
    let difference: [i32; 29] = std::array::from_fn(|residue| {
        let first = q58_lane(state, usize::from(layout.class_of[residue]));
        let second = q58_lane(state, usize::from(layout.class_of[residue + 29]));
        if residue & 1 == 0 {
            first - second
        } else {
            second - first
        }
    });
    let q58_energy: i32 = difference.iter().map(|&value| value * value).sum();
    if q58_energy > 523 {
        return None;
    }
    let mut residuals = [0_i16; 7];
    for coordinate in 0..7 {
        let shift = Q29_COSETS[coordinate][0];
        let residual: i32 = (0..29)
            .map(|residue| difference[residue] * difference[(residue + shift) % 29])
            .sum();
        let first = q29_defects[coordinate] + q58_energy - residual;
        let second = q29_defects[coordinate] + q58_energy + residual;
        if first & 1 != 0
            || second & 1 != 0
            || !(0..=1046).contains(&first)
            || !(0..=1046).contains(&second)
        {
            return None;
        }
        let Ok(residual) = residual.try_into() else {
            return None;
        };
        residuals[coordinate] = residual;
    }
    Some((q58_energy as u16, ResidualTuple::from_array(residuals)))
}

struct ProfileWorkspace<const CAPACITY: usize> {
    keys: Box<[G41Q174JointProfile]>,
    states: Box<[u128]>,
    occupied: Box<[u8]>,
    touched: Vec<u32>,
}

#[derive(Clone, Copy, Debug)]
struct Q58Terms {
    energy: u16,
    residuals: ResidualTuple<i16, 7>,
}

impl Default for Q58Terms {
    fn default() -> Self {
        Self {
            energy: 0,
            residuals: ResidualTuple::from_array([0; 7]),
        }
    }
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, PartialOrd, Ord)]
struct Q87Terms {
    energy: u16,
    defects: [u16; G41_Q174_Q87_SCOPED_DEFECTS],
    _reserved: u16,
}

const _: () = assert!(std::mem::size_of::<Q87Terms>() == 8);

/// Exact bounded transposition table for the 72-bit packed q87 coefficient
/// state. Equality checks all 72 bits and insertion fails closed at 3/4 load.
struct Q87ProfileCache<const CAPACITY: usize> {
    keys_low: Box<[u64]>,
    tags_high_plus_one: Box<[u16]>,
    values: Box<[Q87Terms]>,
    touched: Vec<u32>,
    hits: u64,
    misses: u64,
}

impl<const CAPACITY: usize> Q87ProfileCache<CAPACITY> {
    fn new() -> Self {
        assert!(CAPACITY.is_power_of_two());
        Self {
            keys_low: vec![0_u64; CAPACITY].into_boxed_slice(),
            tags_high_plus_one: vec![0_u16; CAPACITY].into_boxed_slice(),
            values: vec![Q87Terms::default(); CAPACITY].into_boxed_slice(),
            touched: Vec::with_capacity(3 * CAPACITY / 4),
            hits: 0,
            misses: 0,
        }
    }

    #[inline(always)]
    fn get_or_compile(
        &mut self,
        state: u128,
        layout: &Q87Layout,
    ) -> Result<Option<Q87Terms>, G41Q174JointError> {
        debug_assert_eq!(state >> 72, 0);
        let low = state as u64;
        let tag = (state >> 64) as u16 + 1;
        let mut hash = low ^ u64::from(tag).wrapping_mul(0x9e37_79b9_7f4a_7c15);
        hash ^= hash >> 30;
        hash = hash.wrapping_mul(0xbf58_476d_1ce4_e5b9);
        hash ^= hash >> 27;
        let mut slot = hash as usize & (CAPACITY - 1);
        loop {
            if self.tags_high_plus_one[slot] == 0 {
                if self.touched.len() == 3 * CAPACITY / 4 {
                    return Err(G41Q174JointError::ProfileBudget);
                }
                self.misses += 1;
                self.keys_low[slot] = low;
                self.tags_high_plus_one[slot] = tag;
                self.touched.push(slot as u32);
                let energy = q87_energy(state);
                let value = if energy <= TARGET_Q87_DEFECT {
                    q87_defects(layout, state).map(|defects| Q87Terms {
                        energy,
                        defects,
                        _reserved: 0,
                    })
                } else {
                    None
                };
                self.values[slot] = value.unwrap_or(Q87Terms {
                    energy: TARGET_Q87_DEFECT + 1,
                    defects: [0; G41_Q174_Q87_SCOPED_DEFECTS],
                    _reserved: 0,
                });
                return Ok(value);
            }
            if self.tags_high_plus_one[slot] == tag && self.keys_low[slot] == low {
                self.hits += 1;
                let value = self.values[slot];
                return Ok((value.energy <= TARGET_Q87_DEFECT).then_some(value));
            }
            slot = (slot + 1) & (CAPACITY - 1);
        }
    }

    const fn bytes() -> u64 {
        (CAPACITY
            * (std::mem::size_of::<u64>()
                + std::mem::size_of::<u16>()
                + std::mem::size_of::<Q87Terms>())
            + 3 * CAPACITY / 4 * std::mem::size_of::<u32>()) as u64
    }

    fn len(&self) -> usize {
        self.touched.len()
    }
}

struct Q58ProfileCache<const CAPACITY: usize> {
    keys: Box<[u64]>,
    values: Box<[Q58Terms]>,
    status: Box<[u8]>,
    touched: Vec<u32>,
    hits: u64,
    misses: u64,
    collisions: u64,
}

impl<const CAPACITY: usize> Q58ProfileCache<CAPACITY> {
    fn new() -> Self {
        assert!(CAPACITY.is_power_of_two());
        Self {
            keys: vec![0_u64; CAPACITY].into_boxed_slice(),
            values: vec![Q58Terms::default(); CAPACITY].into_boxed_slice(),
            status: vec![0_u8; CAPACITY].into_boxed_slice(),
            touched: Vec::with_capacity(3 * CAPACITY / 4),
            hits: 0,
            misses: 0,
            collisions: 0,
        }
    }

    #[inline(always)]
    fn get_or_compile(
        &mut self,
        state: u64,
        layout: &Q58Layout,
        q29_defects: [i32; 7],
    ) -> Result<Option<Q58Terms>, G41Q174JointError> {
        let mut hash = state;
        hash ^= hash >> 30;
        hash = hash.wrapping_mul(0xbf58_476d_1ce4_e5b9);
        hash ^= hash >> 27;
        hash = hash.wrapping_mul(0x94d0_49bb_1331_11eb);
        hash ^= hash >> 31;
        let mut slot = hash as usize & (CAPACITY - 1);
        loop {
            if self.status[slot] == 0 {
                if self.touched.len() == 3 * CAPACITY / 4 {
                    return Err(G41Q174JointError::ProfileBudget);
                }
                self.keys[slot] = state;
                self.misses += 1;
                self.touched.push(slot as u32);
                if let Some((energy, residuals)) = q58_profile(layout, state, q29_defects) {
                    self.values[slot] = Q58Terms { energy, residuals };
                    self.status[slot] = 2;
                    return Ok(Some(self.values[slot]));
                }
                self.status[slot] = 1;
                return Ok(None);
            }
            if self.keys[slot] == state {
                self.hits += 1;
                return Ok((self.status[slot] == 2).then_some(self.values[slot]));
            }
            self.collisions += 1;
            slot = (slot + 1) & (CAPACITY - 1);
        }
    }

    const fn bytes() -> u64 {
        (CAPACITY
            * (std::mem::size_of::<u64>()
                + std::mem::size_of::<Q58Terms>()
                + std::mem::size_of::<u8>())
            + 3 * CAPACITY / 4 * std::mem::size_of::<u32>()) as u64
    }

    fn len(&self) -> usize {
        self.touched.len()
    }
}

impl<const CAPACITY: usize> ProfileWorkspace<CAPACITY> {
    fn new() -> Self {
        assert!(CAPACITY.is_power_of_two());
        Self {
            keys: vec![G41Q174JointProfile::default(); CAPACITY].into_boxed_slice(),
            states: vec![0_u128; CAPACITY].into_boxed_slice(),
            occupied: vec![0_u8; CAPACITY].into_boxed_slice(),
            touched: Vec::with_capacity(3 * CAPACITY / 4),
        }
    }

    #[inline(always)]
    fn insert(
        &mut self,
        profile: G41Q174JointProfile,
        state: u128,
    ) -> Result<(), G41Q174JointError> {
        let mut hash = u64::from(profile.q58_energy) ^ (u64::from(profile.q87_energy) << 32);
        for residual in profile.q58_residuals.as_array() {
            hash ^= (*residual as u16 as u64)
                .wrapping_add(hash << 6)
                .wrapping_add(hash >> 2);
        }
        for defect in profile.q87_defects {
            hash ^= u64::from(defect)
                .wrapping_add(hash << 6)
                .wrapping_add(hash >> 2);
        }
        let mut slot = hash as usize & (CAPACITY - 1);
        loop {
            if self.occupied[slot] == 0 {
                if self.touched.len() == 3 * CAPACITY / 4 {
                    return Err(G41Q174JointError::ProfileBudget);
                }
                self.occupied[slot] = 1;
                self.keys[slot] = profile;
                self.states[slot] = state;
                self.touched.push(slot as u32);
                return Ok(());
            }
            if self.keys[slot] == profile {
                self.states[slot] = self.states[slot].min(state);
                return Ok(());
            }
            slot = (slot + 1) & (CAPACITY - 1);
        }
    }

    fn into_sorted_outputs(mut self) -> (Box<[G41Q174JointProfile]>, Box<[u128]>) {
        let keys = &self.keys;
        let states = &self.states;
        self.touched.sort_unstable_by_key(|&slot| {
            let index = slot as usize;
            (keys[index], states[index])
        });
        let mut profiles = Vec::with_capacity(self.touched.len());
        let mut representative_states = Vec::with_capacity(self.touched.len());
        for slot in self.touched {
            let index = slot as usize;
            profiles.push(self.keys[index]);
            representative_states.push(self.states[index]);
        }
        (
            profiles.into_boxed_slice(),
            representative_states.into_boxed_slice(),
        )
    }

    const fn bytes() -> u64 {
        (CAPACITY
            * (std::mem::size_of::<G41Q174JointProfile>()
                + std::mem::size_of::<u128>()
                + std::mem::size_of::<u8>())
            + 3 * CAPACITY / 4 * std::mem::size_of::<u32>()) as u64
    }
}

fn reconstruct_side(
    slots: [usize; 3],
    choices: &[Vec<SlotChoice>; SLOTS],
    target: u128,
) -> Option<[u16; SLOTS]> {
    let mut orbit_masks = [0_u16; SLOTS];
    for first in &choices[slots[0]] {
        for second in &choices[slots[1]] {
            let Some(partial) = state_sum_within(first.state, second.state, target) else {
                continue;
            };
            let Some(required) = state_complement(partial, target) else {
                continue;
            };
            let Ok(position) =
                choices[slots[2]].binary_search_by_key(&required, |choice| choice.state)
            else {
                continue;
            };
            orbit_masks[slots[0]] = first.orbit_mask;
            orbit_masks[slots[1]] = second.orbit_mask;
            orbit_masks[slots[2]] = choices[slots[2]][position].orbit_mask;
            return Some(orbit_masks);
        }
    }
    None
}

pub fn find_g41_q174_allocation_witness(
    mask: u8,
    digits: u32,
    target_state: u128,
) -> Result<G41Q174AllocationWitnessReport, G41Q174JointError> {
    if mask >= 64 || target_state & !STATE_MASK != 0 {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let q58_layout = compile_q58_layout()?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let choices = [
        slot_choices(&layout, &inventory, 0, mask, counts[0])?,
        slot_choices(&layout, &inventory, 1, mask, counts[1])?,
        slot_choices(&layout, &inventory, 2, mask, counts[2])?,
        slot_choices(&layout, &inventory, 3, mask, counts[3])?,
        slot_choices(&layout, &inventory, 4, mask, counts[4])?,
        slot_choices(&layout, &inventory, 5, mask, counts[5])?,
    ];
    let cardinalities = choices.each_ref().map(|values| values.len() as u32);
    let states: [Vec<u128>; SLOTS] =
        std::array::from_fn(|slot| choices[slot].iter().map(|choice| choice.state).collect());
    let target_projection = projection(&layout, target_state);
    let (left_slots, right_slots, left_states, right_states, _partition_attempts) =
        compile_partitioned_sides(
            &layout,
            states.each_ref().map(|values| values.as_slice()),
            cardinalities,
            target_projection,
            4,
        )?;
    let mut orbit_masks = None;
    for left_state in left_states {
        let Some(required) = state_complement(left_state, target_state) else {
            continue;
        };
        if right_states.binary_search(&required).is_err() {
            continue;
        }
        let Some(mut left_masks) = reconstruct_side(left_slots, &choices, left_state) else {
            return Err(G41Q174JointError::SemanticMismatch);
        };
        let Some(right_masks) = reconstruct_side(right_slots, &choices, required) else {
            return Err(G41Q174JointError::SemanticMismatch);
        };
        for slot in right_slots {
            left_masks[slot] = right_masks[slot];
        }
        orbit_masks = Some(left_masks);
        break;
    }
    Ok(G41Q174AllocationWitnessReport {
        mask,
        digits,
        target_state,
        q58_class_coefficients: {
            let packed = q58_state(&layout, &q58_layout, target_state);
            std::array::from_fn(|class| q58_lane(packed, class) as u8)
        },
        left_slots: left_slots.map(|slot| slot as u8),
        right_slots: right_slots.map(|slot| slot as u8),
        orbit_masks,
        provenance: "independent bounded q174 target-state reconstruction; exact lane complement joins two iterative three-slot images, then two presorted two-plus-one slot joins recover canonical fine-orbit masks; no profile representative is treated as an original-space witness without this replay",
    })
}

pub fn probe_g41_q174_source_projection_index(
    mask: u8,
    digits: u32,
) -> Result<G41Q174SourceProjectionIndexReport, G41Q174JointError> {
    if mask >= 64 {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let contributions = [
        slot_states(&layout, &inventory, 0, mask, counts[0])?,
        slot_states(&layout, &inventory, 1, mask, counts[1])?,
        slot_states(&layout, &inventory, 2, mask, counts[2])?,
        slot_states(&layout, &inventory, 3, mask, counts[3])?,
        slot_states(&layout, &inventory, 4, mask, counts[4])?,
        slot_states(&layout, &inventory, 5, mask, counts[5])?,
    ];
    let slot_states = contributions.each_ref().map(|states| states.len() as u32);
    let (left_slots, right_slots, left, right, _) = compile_partitioned_sides(
        &layout,
        contributions.each_ref().map(|states| states.as_slice()),
        slot_states,
        [18; COORDINATES],
        12,
    )?;
    let mut left_keys = Vec::with_capacity(left.len());
    for &state in &left {
        left_keys.push(
            pack_projection(projection(&layout, state))
                .ok_or(G41Q174JointError::SemanticMismatch)?,
        );
    }
    let mut right_keys = Vec::with_capacity(right.len());
    for &state in &right {
        right_keys.push(
            pack_projection(projection(&layout, state))
                .ok_or(G41Q174JointError::SemanticMismatch)?,
        );
    }
    let summarize = |keys: &mut Vec<u64>| -> (u32, u32, u32) {
        keys.sort_unstable();
        let mut groups = 0_u32;
        let mut maximum = 0_u32;
        let mut cursor = 0_usize;
        while cursor < keys.len() {
            let end = keys[cursor..].partition_point(|&key| key == keys[cursor]) + cursor;
            groups += 1;
            maximum = maximum.max((end - cursor) as u32);
            cursor = end;
        }
        let mut prefixes = Vec::with_capacity(groups as usize);
        let mut cursor = 0_usize;
        while cursor < keys.len() {
            prefixes.push((keys[cursor] & ((1_u64 << 20) - 1)) as u32);
            cursor += keys[cursor..].partition_point(|&key| key == keys[cursor]);
        }
        prefixes.sort_unstable();
        prefixes.dedup();
        (groups, maximum, prefixes.len() as u32)
    };
    let (left_projection_keys, maximum_left_fibre, left_projection_prefixes) =
        summarize(&mut left_keys);
    let (right_projection_keys, maximum_right_fibre, right_projection_prefixes) =
        summarize(&mut right_keys);
    Ok(G41Q174SourceProjectionIndexReport {
        mask,
        digits,
        slot_states,
        left_slots: left_slots.map(|slot| slot as u8),
        right_slots: right_slots.map(|slot| slot as u8),
        left_states: left.len() as u32,
        right_states: right.len() as u32,
        left_projection_keys,
        right_projection_keys,
        left_projection_prefixes,
        right_projection_prefixes,
        maximum_left_fibre,
        maximum_right_fibre,
        workspace_bytes: contributions
            .iter()
            .map(|states| states.capacity() as u64 * std::mem::size_of::<u128>() as u64)
            .sum::<u64>()
            + (left.capacity() + right.capacity()) as u64 * std::mem::size_of::<u128>() as u64
            + (left_keys.capacity() + right_keys.capacity()) as u64
                * std::mem::size_of::<u64>() as u64,
        provenance: "exact source-side q174 index probe with the q29 projection bound relaxed to its full coefficient cube; all six source-slot images are combined iteratively without recursion, projection keys are packed and sorted once, and the reported key multiplicities measure the batch-query reuse available before any q29 coefficient is selected",
    })
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
struct ProjectionKeyCount {
    prefix: u32,
    suffix: u32,
    count: u32,
}

fn packed_four_subtract(target: u32, source: u32) -> Option<u32> {
    let mut result = 0_u32;
    for lane in 0..4 {
        let target_lane = (target >> (5 * lane)) & 31;
        let source_lane = (source >> (5 * lane)) & 31;
        let difference = target_lane.checked_sub(source_lane)?;
        result |= difference << (5 * lane);
    }
    Some(result)
}

fn projection_key_counts(
    layout: &Layout,
    states: &[u128],
) -> Result<Vec<ProjectionKeyCount>, G41Q174JointError> {
    let mut keys = Vec::with_capacity(states.len());
    for &state in states {
        keys.push(
            pack_projection(projection(layout, state))
                .ok_or(G41Q174JointError::SemanticMismatch)?,
        );
    }
    keys.sort_unstable();
    let mut counted = Vec::with_capacity(keys.len());
    let mut cursor = 0_usize;
    while cursor < keys.len() {
        let key = keys[cursor];
        let end = keys[cursor..].partition_point(|&candidate| candidate == key) + cursor;
        counted.push(ProjectionKeyCount {
            prefix: (key & ((1_u64 << 20) - 1)) as u32,
            suffix: (key >> 20) as u32,
            count: (end - cursor) as u32,
        });
        cursor = end;
    }
    counted.sort_unstable_by_key(|entry| (entry.prefix, entry.suffix));
    Ok(counted)
}

pub fn probe_g41_q174_source_projection_batch(
    mask: u8,
    digits: u32,
    targets: &[[u8; COORDINATES]],
) -> Result<G41Q174SourceProjectionBatchReport, G41Q174JointError> {
    if mask >= 64 || targets.is_empty() || targets.iter().flatten().any(|&value| value > 18) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let source = probe_g41_q174_source_projection_index(mask, digits)?;
    let layout = compile_layout()?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    let contributions = [
        slot_states(&layout, &inventory, 0, mask, counts[0])?,
        slot_states(&layout, &inventory, 1, mask, counts[1])?,
        slot_states(&layout, &inventory, 2, mask, counts[2])?,
        slot_states(&layout, &inventory, 3, mask, counts[3])?,
        slot_states(&layout, &inventory, 4, mask, counts[4])?,
        slot_states(&layout, &inventory, 5, mask, counts[5])?,
    ];
    let cardinalities = contributions.each_ref().map(|states| states.len() as u32);
    let (_, _, left, right, _) = compile_partitioned_sides(
        &layout,
        contributions.each_ref().map(|states| states.as_slice()),
        cardinalities,
        [18; COORDINATES],
        14,
    )?;
    let left = projection_key_counts(&layout, &left)?;
    let right = projection_key_counts(&layout, &right)?;
    let mut targets = targets
        .iter()
        .map(|&target| {
            let key = pack_projection(target).ok_or(G41Q174JointError::SemanticMismatch)?;
            Ok(ProjectionKeyCount {
                prefix: (key & ((1_u64 << 20) - 1)) as u32,
                suffix: (key >> 20) as u32,
                count: 1,
            })
        })
        .collect::<Result<Vec<_>, G41Q174JointError>>()?;
    targets.sort_unstable();
    targets.dedup();
    let mut compatible_projection_triples = 0_u64;
    let mut compatible_state_pairs = 0_u64;
    let mut target_cursor = 0_usize;
    while target_cursor < targets.len() {
        let target_prefix = targets[target_cursor].prefix;
        let target_end = targets[target_cursor..]
            .partition_point(|entry| entry.prefix == target_prefix)
            + target_cursor;
        let target_suffixes = &targets[target_cursor..target_end];
        let mut left_cursor = 0_usize;
        while left_cursor < left.len() {
            let left_prefix = left[left_cursor].prefix;
            let left_end = left[left_cursor..].partition_point(|entry| entry.prefix == left_prefix)
                + left_cursor;
            let Some(right_prefix) = packed_four_subtract(target_prefix, left_prefix) else {
                left_cursor = left_end;
                continue;
            };
            let right_start = right.partition_point(|entry| entry.prefix < right_prefix);
            let right_end = right.partition_point(|entry| entry.prefix <= right_prefix);
            if right_start != right_end {
                for target in target_suffixes {
                    for left_entry in &left[left_cursor..left_end] {
                        let Some(right_suffix) =
                            packed_four_subtract(target.suffix, left_entry.suffix)
                        else {
                            continue;
                        };
                        let right_group = &right[right_start..right_end];
                        let position =
                            right_group.partition_point(|entry| entry.suffix < right_suffix);
                        if position < right_group.len()
                            && right_group[position].suffix == right_suffix
                        {
                            compatible_projection_triples = compatible_projection_triples
                                .checked_add(1)
                                .ok_or(G41Q174JointError::ProfileBudget)?;
                            compatible_state_pairs = compatible_state_pairs
                                .checked_add(
                                    u64::from(left_entry.count)
                                        * u64::from(right_group[position].count),
                                )
                                .ok_or(G41Q174JointError::ProfileBudget)?;
                        }
                    }
                }
            }
            left_cursor = left_end;
        }
        target_cursor = target_end;
    }
    Ok(G41Q174SourceProjectionBatchReport {
        source,
        target_projections: targets.len() as u32,
        compatible_projection_triples,
        compatible_state_pairs,
        provenance: "exact batched additive q29 projection join over one reusable source-side q174 index; four-coordinate prefix groups route only componentwise-compatible triples, four-coordinate suffix subtraction and binary search are collision-free, and state-pair multiplicity uses exact per-key fibre counts without choosing a representative",
    })
}

pub fn compile_g41_q174_joint_tablebase(
    mask: u8,
    digits: u32,
    q29_coefficients: [u8; COORDINATES],
) -> Result<G41Q174JointTablebase, G41Q174JointError> {
    // Block two exceeds the 3/4 load bounds of both 2^22 and 2^23 tables
    // once the three independent q87 coordinates are retained. Keep the hot table
    // fixed and fail-closed, but size it for the measured all-block interface.
    type Profiles = ProfileWorkspace<{ 1 << 24 }>;
    type Q58Cache = Q58ProfileCache<{ 1 << 20 }>;
    type Q87Cache = Q87ProfileCache<{ 1 << 20 }>;
    if mask >= 64 || q29_coefficients.iter().any(|&value| value > 18) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let layout = compile_layout()?;
    let q58_layout = compile_q58_layout()?;
    let q87_layout = compile_q87_layout()?;
    let inventory = compile_inventory()?;
    let counts = digit_counts(digits);
    if (0..SLOTS).any(|slot| counts[slot] > inventory.large_len[slot]) {
        return Err(G41Q174JointError::SemanticMismatch);
    }
    let contributions = [
        slot_states(&layout, &inventory, 0, mask, counts[0])?,
        slot_states(&layout, &inventory, 1, mask, counts[1])?,
        slot_states(&layout, &inventory, 2, mask, counts[2])?,
        slot_states(&layout, &inventory, 3, mask, counts[3])?,
        slot_states(&layout, &inventory, 4, mask, counts[4])?,
        slot_states(&layout, &inventory, 5, mask, counts[5])?,
    ];
    let slot_counts = contributions.each_ref().map(|states| states.len() as u32);
    let (mut left_slots, mut right_slots, mut left, mut right, partition_attempts) =
        compile_partitioned_sides(
            &layout,
            contributions.each_ref().map(|values| values.as_slice()),
            slot_counts,
            q29_coefficients,
            0,
        )?;
    if left.len() > right.len() {
        std::mem::swap(&mut left_slots, &mut right_slots);
        std::mem::swap(&mut left, &mut right);
    }
    let mut hot_left = Vec::with_capacity(left.len());
    for state in left {
        hot_left.push(HotState::new(
            state,
            q58_state(&layout, &q58_layout, state),
            q87_state(&layout, state),
        ));
    }
    let mut keyed_right = Vec::with_capacity(right.len());
    for state in right {
        let key = pack_projection(projection(&layout, state))
            .ok_or(G41Q174JointError::SemanticMismatch)?;
        keyed_right.push(KeyedState::new(
            key,
            state,
            q58_state(&layout, &q58_layout, state),
            q87_state(&layout, state),
        ));
    }
    keyed_right.sort_unstable();
    let q29_defects = quotient_defects(q29_coefficients);
    let mut q58_cache = Q58Cache::new();
    let mut q87_cache = Q87Cache::new();
    let mut workspace = Profiles::new();
    let mut pairs_visited = 0_u64;
    let mut q87_energy_pair_survivors = 0_u64;
    let mut q58_profile_pair_survivors = 0_u64;
    for &left_state in &hot_left {
        let Some(key) = complement_key(&layout, left_state.state(), q29_coefficients) else {
            continue;
        };
        let start = keyed_right.partition_point(|entry| entry.key < key);
        let end = keyed_right.partition_point(|entry| entry.key <= key);
        for &entry in &keyed_right[start..end] {
            pairs_visited = pairs_visited
                .checked_add(1)
                .ok_or(G41Q174JointError::ProfileBudget)?;
            let combined_q87 = add_states(left_state.q87_state(), entry.q87_state());
            let Some(q87_terms) = q87_cache.get_or_compile(combined_q87, &q87_layout)? else {
                continue;
            };
            q87_energy_pair_survivors += 1;
            let q58_state = left_state.q58_state + entry.q58_state;
            let Some(q58_terms) = q58_cache.get_or_compile(q58_state, &q58_layout, q29_defects)?
            else {
                continue;
            };
            q58_profile_pair_survivors = q58_profile_pair_survivors
                .checked_add(1)
                .ok_or(G41Q174JointError::ProfileBudget)?;
            let state = add_states(left_state.state(), entry.state() & STATE_MASK);
            workspace.insert(
                G41Q174JointProfile {
                    q58_energy: q58_terms.energy,
                    q58_residuals: q58_terms.residuals,
                    q87_energy: q87_terms.energy,
                    q87_defects: q87_terms.defects,
                },
                state,
            )?;
        }
    }
    let exact_q58_coefficient_states = q58_cache.len() as u32;
    let (profiles, representative_states) = workspace.into_sorted_outputs();
    let mut hasher = Sha256::new();
    for (&profile, &state) in profiles.iter().zip(representative_states.iter()) {
        hasher.update(profile.q58_energy.to_le_bytes());
        for residual in profile.q58_residuals.as_array() {
            hasher.update(residual.to_le_bytes());
        }
        hasher.update(profile.q87_energy.to_le_bytes());
        for defect in profile.q87_defects {
            hasher.update(defect.to_le_bytes());
        }
        hasher.update(state.to_le_bytes());
    }
    Ok(G41Q174JointTablebase {
        report: G41Q174JointReport {
            mask,
            digits,
            q29_coefficients,
            q87_defect_shifts: G41_Q174_Q87_DEFECT_SHIFTS,
            orbit_classes: CLASSES as u8,
            slot_states: slot_counts,
            left_slots: left_slots.map(|slot| slot as u8),
            right_slots: right_slots.map(|slot| slot as u8),
            partition_attempts,
            left_states: hot_left.len() as u32,
            right_states: keyed_right.len() as u32,
            pairs_visited,
            q87_energy_pair_survivors,
            q87_cache_hits: q87_cache.hits,
            q87_cache_misses: q87_cache.misses,
            q87_cache_entries: q87_cache.len() as u32,
            exact_q58_coefficient_states,
            q58_profile_pair_survivors,
            q58_cache_hits: q58_cache.hits,
            q58_cache_misses: q58_cache.misses,
            q58_cache_collisions: q58_cache.collisions,
            exact_joint_profiles: profiles.len() as u32,
            joint_profile_digest: hasher.finalize().into(),
            workspace_bytes: contributions
                .iter()
                .map(|states| states.capacity() as u64 * std::mem::size_of::<u128>() as u64)
                .sum::<u64>()
                + hot_left.capacity() as u64 * std::mem::size_of::<HotState>() as u64
                + keyed_right.capacity() as u64 * std::mem::size_of::<KeyedState>() as u64
                + Q58Cache::bytes()
                + Q87Cache::bytes()
                + Profiles::bytes()
                + profiles.len() as u64 * std::mem::size_of::<G41Q174JointProfile>() as u64
                + representative_states.len() as u64 * std::mem::size_of::<u128>() as u64,
            provenance: "exact common-refinement q174 census; 46 multiplier-orbit lanes of two bits encode all q58/q87 correlations; a bounded deterministic search over all ten three-plus-three slot partitions joins the exact q29 projection and fails closed if every partition exceeds its state budget; bounded exact transposition tables compute each 72-bit q87 quadratic profile and q58 anti-profile once per packed coefficient state, then every pair is folded directly into the broad theorem key consisting of q58 anti-profile, q87 energy, and independent q87 defect coordinates at multiplier-class representatives 4 and 6; the sealed three-phase theorem proves shift 33 from shift 4, q87 energy, and the already-bound q29 defect, while redundant shift 10 is in the class of shift 4 and evolved shift 1 is deliberately deferred to the bounded target-fibre endgame; both fixed hash stages allocate nothing hot and fail closed at their explicit load limits; the table stores one representative state only for discovery and makes no claim that it represents all full-length preimages",
        },
        profiles,
        representative_states,
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn q174_multiplier_partition_has_the_expected_orbits() {
        let layout = compile_layout().unwrap();
        assert_eq!(layout.representatives[0], 0);
        assert!(layout
            .class_of
            .iter()
            .all(|&class| usize::from(class) < CLASSES));
        for residue in 0..MODULUS {
            assert_eq!(
                layout.class_of[residue],
                layout.class_of[residue * 41 % MODULUS]
            );
        }
        let mut scoped_classes = G41_Q174_Q87_DEFECT_SHIFTS.map(canonical_q87_shift_class);
        scoped_classes.sort_unstable();
        assert!(scoped_classes.windows(2).all(|pair| pair[0] < pair[1]));
        assert_eq!(canonical_q87_shift_class(4), canonical_q87_shift_class(10));
    }

    #[test]
    fn q87_interaction_graph_matches_direct_residue_oracle() {
        let report = analyze_g41_q174_q87_interactions().unwrap();
        assert_eq!(report.scopes.len(), 3);
        let mut direct_lane_of = [u8::MAX; Q87_MODULUS];
        for residue in 0..Q87_MODULUS {
            let reduced = residue % 29;
            let coordinate = if reduced == 0 {
                0
            } else {
                1 + Q29_COSETS
                    .iter()
                    .position(|coset| coset.contains(&reduced))
                    .unwrap()
            };
            let representative = if coordinate == 0 {
                0
            } else {
                Q29_COSETS[coordinate - 1][0]
            };
            let lift = (0..3)
                .find(|&candidate| {
                    let mut point = representative + 29 * candidate;
                    loop {
                        if point == residue {
                            return true;
                        }
                        point = point * 41 % Q87_MODULUS;
                        if point == representative + 29 * candidate {
                            return false;
                        }
                    }
                })
                .unwrap();
            direct_lane_of[residue] = (3 * coordinate + lift) as u8;
        }
        for (feature, &shift) in G41_Q174_Q87_DEFECT_SHIFTS.iter().enumerate() {
            let mut expected = [0_u8; COORDINATES];
            for residue in 0..Q87_MODULUS {
                let first = usize::from(direct_lane_of[residue]) / 3;
                let second = usize::from(direct_lane_of[(residue + shift) % Q87_MODULUS]) / 3;
                if first != second {
                    expected[first] |= 1 << second;
                    expected[second] |= 1 << first;
                }
            }
            assert_eq!(report.coordinate_adjacency[feature], expected);
        }
        for scope in &report.scopes {
            assert!(scope.coordinate_mask != 0);
            assert_eq!(
                elimination_width(
                    report
                        .coordinate_adjacency
                        .iter()
                        .enumerate()
                        .filter(|(index, _)| scope.coordinate_mask & (1 << index) != 0)
                        .fold([0_u8; COORDINATES], |mut union, (_, adjacency)| {
                            for vertex in 0..COORDINATES {
                                union[vertex] |= adjacency[vertex];
                            }
                            union
                        }),
                    scope.elimination_order,
                ),
                scope.minimum_elimination_width
            );
            let union = report
                .coordinate_adjacency
                .iter()
                .enumerate()
                .filter(|(index, _)| scope.coordinate_mask & (1 << index) != 0)
                .fold([0_u8; COORDINATES], |mut union, (_, adjacency)| {
                    for vertex in 0..COORDINATES {
                        union[vertex] |= adjacency[vertex];
                    }
                    union
                });
            assert_eq!(
                linear_frontier_width(union, scope.linear_frontier_order),
                scope.minimum_linear_frontier_width
            );
        }
    }

    #[test]
    fn q87_phase_relations_are_quadratic_identities_and_reject_wrong_binding() {
        let proof = prove_g41_q174_q87_phase_relations().unwrap();
        assert!(proof.verified);
        assert_eq!(proof.quadratic_basis_checks, 1 + 2 * 46 + 46 * 45 / 2);
        assert!(proof.evolution_candidates_tested > 0);
        assert_eq!(proof.evolved_coefficients, [[2, 1, -2, -1]; 7]);
        assert_eq!(
            proof.relations[3],
            G41Q174Q87PhaseRelation {
                q29_shift: 4,
                repeated_q87_class: 4,
                singleton_q87_class: 33,
            }
        );
        let layout = compile_layout().unwrap();
        let mut forged = proof.relations[3];
        forged.singleton_q87_class = 6;
        assert!((0..CLASSES).any(|lane| {
            q87_phase_relation_value(&layout, 1_u128 << (2 * lane), 3, forged).unwrap() != 0
        }));
    }

    #[test]
    fn translation_261_is_an_exact_zero_allocation_source_profile_bijection() {
        let action = G41Q174TranslationAction::compile().unwrap();
        assert!(action.proof.verified);
        assert!(action.proof.q29_projection_fixed);
        assert!(action.proof.source_orbits_verified);
        assert_eq!(
            action.proof.quadratic_basis_checks,
            1 + 2 * 46 + 46 * 45 / 2
        );
        let mut state = 0_u128;
        for lane in 0..CLASSES {
            state |= u128::from((3 * lane % 4) as u8) << (2 * lane);
        }
        let (translated, allocations) = tracked_allocations(|| action.translate(state).unwrap());
        assert_eq!(allocations, 0);
        assert_eq!(action.translate(translated), Ok(state));
        assert_eq!(
            g41_q174_joint_profile(state),
            g41_q174_joint_profile(translated)
        );
        let spec = (20_u8, 2_215_340_u32);
        let translated_spec = translate_g41_q174_block_spec(spec.0, spec.1).unwrap();
        assert_eq!(
            translate_g41_q174_block_spec(translated_spec.0, translated_spec.1),
            Ok(spec)
        );
        assert_eq!(
            action.translate(1_u128 << STATE_BITS),
            Err(G41Q174JointError::SemanticMismatch)
        );
    }

    #[test]
    fn all_disjoint_fine_orbits_fill_every_q174_residue_exactly_three_times() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let mut state = 0_u128;
        for slot in 0..SLOTS {
            state = add_states(state, orbit_state(&layout, &inventory.small[slot]).unwrap());
            for orbit in &inventory.large[slot][..usize::from(inventory.large_len[slot])] {
                state = add_states(state, orbit_state(&layout, orbit).unwrap());
            }
        }
        assert!((0..CLASSES).all(|class| coefficient(state, class) == 3));
    }

    #[test]
    fn partition_search_recovers_when_the_first_balanced_partition_exceeds_budget() {
        let layout = compile_layout().unwrap();
        let independent = [
            [0_u128, 1_u128],
            [0_u128, 1_u128 << 2],
            [0_u128, 1_u128 << 4],
        ];
        let contributions = [
            independent[0].as_slice(),
            independent[1].as_slice(),
            independent[2].as_slice(),
            independent[0].as_slice(),
            independent[1].as_slice(),
            independent[2].as_slice(),
        ];
        assert!(matches!(
            compile_side(
                &layout,
                [contributions[0], contributions[1], contributions[2]],
                [1; 8],
                0,
                6
            ),
            Err(G41Q174JointError::StateBudget { .. })
        ));
        let (left_slots, right_slots, left, right, attempts) =
            compile_partitioned_sides_with_limit(
                &layout,
                contributions,
                [2; SLOTS],
                [1; COORDINATES],
                0,
                6,
            )
            .unwrap();
        assert_eq!(left_slots, [0, 1, 3]);
        assert_eq!(right_slots, [2, 4, 5]);
        assert_eq!(left.len(), 4);
        assert_eq!(right.len(), 4);
        assert_eq!(attempts.len(), 2);
        assert_eq!(attempts[0].failed_stage, Some(2));
        assert!(attempts[1].failed_stage.is_none());
    }

    #[test]
    fn q174_state_projects_to_direct_q29_q58_and_q87_orbit_counts() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let orbit = &inventory.large[4][3];
        let state = orbit_state(&layout, orbit).unwrap();
        let direct29: [u8; 29] = std::array::from_fn(|residue| {
            orbit.points[..usize::from(orbit.len)]
                .iter()
                .filter(|&&point| usize::from(point) % 29 == residue)
                .count() as u8
        });
        let direct58: [i32; 58] = std::array::from_fn(|residue| {
            orbit.points[..usize::from(orbit.len)]
                .iter()
                .filter(|&&point| usize::from(point) % 58 == residue)
                .count() as i32
        });
        let direct87: [i32; 87] = std::array::from_fn(|residue| {
            orbit.points[..usize::from(orbit.len)]
                .iter()
                .filter(|&&point| usize::from(point) % 87 == residue)
                .count() as i32
        });
        assert_eq!(q58_coefficients(&layout, state), direct58);
        assert_eq!(q87_coefficients(&layout, state), direct87);
        let q87_layout = compile_q87_layout().unwrap();
        let scoped = q87_defects(&q87_layout, q87_state(&layout, state)).unwrap();
        let zero: i32 = direct87.iter().map(|&value| value * value).sum();
        let direct_scoped: [u16; G41_Q174_Q87_SCOPED_DEFECTS] =
            G41_Q174_Q87_DEFECT_SHIFTS.map(|shift| {
                (zero
                    - (0..Q87_MODULUS)
                        .map(|residue| {
                            direct87[residue] * direct87[(residue + shift) % Q87_MODULUS]
                        })
                        .sum::<i32>()) as u16
            });
        assert_eq!(scoped, direct_scoped);
        let replay = replay_g41_q174_q87_defects([state; 4]).unwrap();
        for (index, &defect) in replay.combined_nonzero_defects.iter().enumerate() {
            let shift = index + 1;
            let direct = zero
                - (0..Q87_MODULUS)
                    .map(|residue| direct87[residue] * direct87[(residue + shift) % Q87_MODULUS])
                    .sum::<i32>();
            assert_eq!(i32::from(defect), 4 * direct);
        }
        assert_eq!(
            replay_g41_q174_q87_defects([1_u128 << STATE_BITS; 4]),
            Err(G41Q174JointError::SemanticMismatch)
        );
        let q58_layout = compile_q58_layout().unwrap();
        let packed_q58 = q58_state(&layout, &q58_layout, state);
        for class in 0..Q58_CLASSES {
            assert_eq!(
                q58_lane(packed_q58, class),
                direct58[usize::from(q58_layout.representatives[class])]
            );
        }
        let projected = projection(&layout, state);
        assert_eq!(projected[0], direct29[0]);
        for coordinate in 1..COORDINATES {
            assert!(Q29_COSETS[coordinate - 1]
                .iter()
                .all(|&residue| direct29[residue] == projected[coordinate]));
        }
    }

    #[test]
    fn q87_partial_energy_theorem_never_rejects_direct_orbit_pairs() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let bounds = Q87EnergyBounds::compile();
        let mut atoms = Vec::new();
        for slot in 0..SLOTS {
            for orbit in &inventory.large[slot][..usize::from(inventory.large_len[slot])] {
                atoms.push(orbit_state(&layout, orbit).unwrap());
            }
        }
        for &left in &atoms {
            for &right in &atoms {
                let Some(combined) = state_sum_within(left, right, STATE_MASK) else {
                    continue;
                };
                let energy = q87_energy(q87_state(&layout, combined));
                assert!(q87_target_energy_within_bounds(
                    &bounds,
                    q87_state(&layout, left),
                    projection(&layout, combined),
                    &[energy],
                ));
            }
        }
        assert!(!q87_target_energy_within_bounds(
            &bounds,
            0,
            [0; COORDINATES],
            &[1],
        ));
    }

    #[test]
    fn coset_complement_strata_prove_profile_symmetry() {
        let layout = compile_layout().unwrap();
        let q58_layout = compile_q58_layout().unwrap();
        let q87_layout = compile_q87_layout().unwrap();
        let (generators, changed_lanes) = q29_coset_complement_generators(&layout).unwrap();
        let proof = prove_g41_q174_coset_complement_symmetry().unwrap();
        assert!(proof.verified);
        assert_eq!(proof.profile_coordinates, 11);
        let mut union = 0_u128;
        for &generator in &generators {
            assert_eq!(generator.count_ones(), 8);
            assert_eq!(union & generator, 0);
            union |= generator;
        }
        assert_eq!(union.count_ones(), 56);
        for (coordinate, (generator, lanes)) in
            generators.into_iter().zip(changed_lanes).enumerate()
        {
            assert!(proof.valid_pattern_counts[coordinate] >= 2);
            for &pattern in &proof.valid_pattern_masks[coordinate]
                [..usize::from(proof.valid_pattern_counts[coordinate])]
            {
                let mut state = 0_u128;
                for lane in 0..CLASSES {
                    state |= u128::from((lane % 4) as u8) << (2 * lane);
                }
                for (index, &lane) in lanes.iter().enumerate() {
                    let shift = 2 * usize::from(lane);
                    state &= !(3_u128 << shift);
                    if pattern & (1 << index) != 0 {
                        state |= 3_u128 << shift;
                    }
                }
                assert_eq!(
                    raw_joint_profile_values(&layout, &q58_layout, &q87_layout, state),
                    raw_joint_profile_values(&layout, &q58_layout, &q87_layout, state ^ generator,)
                );
            }
        }
    }

    #[test]
    fn proved_flip_action_canonicalizes_and_expands_without_allocation() {
        let action = G41Q174FlipAction::compile().unwrap();
        let layout = compile_layout().unwrap();
        let q58_layout = compile_q58_layout().unwrap();
        let q87_layout = compile_q87_layout().unwrap();
        let mut state = 0_u128;
        for coordinate in 0..7 {
            let pattern = action.valid_pattern_masks[coordinate][0];
            for (index, &lane) in action.changed_lanes[coordinate].iter().enumerate() {
                if pattern & (1 << index) != 0 {
                    state |= 3_u128 << (2 * usize::from(lane));
                }
            }
        }
        let expected = raw_joint_profile_values(&layout, &q58_layout, &q87_layout, state);
        let mut expanded = [0_u128; 128];
        let (_, allocations) = tracked_allocations(|| action.expand(state, &mut expanded));
        assert_eq!(allocations, 0);
        assert_eq!(action.expand(state, &mut expanded), 128);
        let canonical = action.canonicalize(state);
        assert_eq!(expanded[0], canonical);
        assert!(expanded[..128].iter().all(|&candidate| {
            action.canonicalize(candidate) == canonical
                && raw_joint_profile_values(&layout, &q58_layout, &q87_layout, candidate)
                    == expected
        }));
    }

    #[test]
    fn joint_profile_hash_insertion_allocates_nothing_hot() {
        let mut workspace = ProfileWorkspace::<16>::new();
        let (_, allocations) = tracked_allocations(|| {
            for energy in 0..8_u16 {
                workspace
                    .insert(
                        G41Q174JointProfile {
                            q58_energy: energy,
                            q58_residuals: ResidualTuple::from_array([energy as i16; 7]),
                            q87_energy: 2 * energy,
                            q87_defects: [energy; G41_Q174_Q87_SCOPED_DEFECTS],
                        },
                        u128::from(energy),
                    )
                    .unwrap();
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn q58_profile_cache_allocates_nothing_hot() {
        let layout = compile_q58_layout().unwrap();
        let mut workspace = Q58ProfileCache::<16>::new();
        let (_, allocations) = tracked_allocations(|| {
            for state in 0..8_u64 {
                let _ = workspace.get_or_compile(state, &layout, [0; 7]).unwrap();
            }
        });
        assert_eq!(allocations, 0);
    }

    #[test]
    fn q87_profile_cache_is_exact_across_hits_and_collisions() {
        let layout = compile_q87_layout().unwrap();
        let mut workspace = Q87ProfileCache::<8>::new();
        let states = [
            0_u128,
            1,
            2_u128 << 9,
            (3_u128 << 66) | 5,
            (6_u128 << 69) | (4_u128 << 12),
        ];
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..3 {
                for state in states {
                    let expected_energy = q87_energy(state);
                    let expected = (expected_energy <= TARGET_Q87_DEFECT)
                        .then(|| q87_defects(&layout, state))
                        .flatten()
                        .map(|defects| Q87Terms {
                            energy: expected_energy,
                            defects,
                            _reserved: 0,
                        });
                    assert_eq!(workspace.get_or_compile(state, &layout).unwrap(), expected);
                }
            }
        });
        assert_eq!(allocations, 0);
        assert_eq!(workspace.hits + workspace.misses, 15);
        assert!(workspace.len() <= 6);

        let mut bounded = Q87ProfileCache::<4>::new();
        for state in 0..3_u128 {
            bounded.get_or_compile(state, &layout).unwrap();
        }
        assert_eq!(
            bounded.get_or_compile(3, &layout),
            Err(G41Q174JointError::ProfileBudget)
        );
    }

    #[test]
    fn q174_allocation_witness_reconstructs_a_small_direct_target() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let target = orbit_state(&layout, &inventory.large[0][0]).unwrap();
        let report = find_g41_q174_allocation_witness(0, 1, target).unwrap();
        assert_eq!(report.orbit_masks, Some([1, 0, 0, 0, 0, 0]));
    }

    #[test]
    fn source_feasibility_matches_independent_small_orbit_closure() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let digits = 9;
        let mut workspace = G41Q174SourceFeasibilityWorkspace::new(0, digits).unwrap();
        let first: Vec<u128> = inventory.large[0][..usize::from(inventory.large_len[0])]
            .iter()
            .map(|orbit| orbit_state(&layout, orbit).unwrap())
            .collect();
        let second: Vec<u128> = inventory.large[1][..usize::from(inventory.large_len[1])]
            .iter()
            .map(|orbit| orbit_state(&layout, orbit).unwrap())
            .collect();
        let mut direct = Vec::new();
        for &left in &first {
            for &right in &second {
                direct.push(add_states(left, right));
            }
        }
        direct.sort_unstable();
        direct.dedup();
        let mut candidates = first.clone();
        candidates.extend_from_slice(&second);
        let atoms = candidates.clone();
        candidates.clear();
        for &left in &atoms {
            for &right in &atoms {
                candidates.push(add_states(left, right));
            }
        }
        candidates.sort_unstable();
        candidates.dedup();
        for state in candidates {
            let expected = direct.binary_search(&state).is_ok();
            let actual = workspace.check(projection(&layout, state), state).unwrap();
            assert_eq!(
                actual,
                expected,
                "state={state:#x} projection={:?}",
                projection(&layout, state)
            );
        }
    }

    #[test]
    fn source_feasibility_rejects_wrong_projection_and_allocates_nothing_hot() {
        let layout = compile_layout().unwrap();
        let inventory = compile_inventory().unwrap();
        let state = orbit_state(&layout, &inventory.large[0][0]).unwrap();
        let coefficients = projection(&layout, state);
        let mut workspace = G41Q174SourceFeasibilityWorkspace::new(0, 1).unwrap();
        assert!(workspace.check(coefficients, state).unwrap());
        let mut wrong = coefficients;
        wrong[1] = wrong[1].saturating_add(1);
        assert!(!workspace.check(wrong, state).unwrap());
        let (_, allocations) =
            tracked_allocations(|| workspace.check(coefficients, state).unwrap());
        assert_eq!(allocations, 0);
    }

    #[test]
    fn packed_projection_prefix_subtraction_is_lane_exact() {
        let pack = |lanes: [u32; 4]| {
            lanes
                .into_iter()
                .enumerate()
                .fold(0_u32, |word, (lane, value)| word | (value << (5 * lane)))
        };
        assert_eq!(
            packed_four_subtract(pack([18, 9, 7, 11]), pack([3, 9, 2, 4])),
            Some(pack([15, 0, 5, 7]))
        );
        assert_eq!(
            packed_four_subtract(pack([2, 9, 7, 11]), pack([3, 0, 0, 0])),
            None
        );
    }
}
