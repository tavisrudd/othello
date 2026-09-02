//! Structural even-moment and sparse-trade proofs for the retained q29 root.
//!
//! For rows `y_i : F_29 -> Z` with augmentations `(1,0,0,0)`, write
//! `M_j(i)=sum_a a^j y_i(a)` in `F_29`.  If `C_s` is their combined cyclic
//! autocorrelation, direct binomial expansion gives
//!
//! `sum_s s^2 C_s = 2 M_2(0) - 2 sum_i M_1(i)^2`,
//! `sum_s s^4 C_s = 2 M_4(0) - 8 sum_i M_1(i)M_3(i) + 6 sum_i M_2(i)^2`.
//!
//! The exact q29 target `(505,-18,...,-18)` has both moments zero modulo 29.
//! These are structural necessary predicates, not corpus-learned claims.
//! The retained residual also has a compact group-ring explanation: it is
//! exactly `AA* - BB*` for two six-point sets differing by a two-for-two
//! exchange.  All authority below comes from canonical recomputation.

use serde::Serialize;
use sha2::{Digest, Sha256};

use crate::{
    proof_synthesis::{ExtractorDescriptor, ProvenanceClass},
    q29_inventory_scope::{extract_q29_inventories, Q29InventoryError, Q29_ROW_LENGTH},
};

const BLOCKS: usize = 4;
const PRIME: i32 = 29;
const MOMENT_DEGREES: usize = 4;
const MOMENT_EXTRACTOR_ID: [u8; 16] = *b"c1016-q29mom0001";
const MOMENT_EXTRACTOR_VERSION: u16 = 1;
const MOMENT_PARAMETER_DIGEST: [u8; 32] = [
    0x2a, 0x3d, 0x1f, 0x2e, 0xd1, 0x39, 0x4d, 0x57, 0xc0, 0x04, 0x2a, 0xbe, 0x10, 0x94, 0xa4, 0xc3,
    0xc1, 0xe5, 0x6a, 0xff, 0x10, 0xf6, 0x12, 0xa5, 0xb2, 0x53, 0xcf, 0xd3, 0x3f, 0x82, 0xb0, 0x77,
];
const MOMENT_SEMANTICS_COMMITMENT: [u8; 32] = [
    0xee, 0x5f, 0xb0, 0x3a, 0x1c, 0xc9, 0xcf, 0x41, 0x85, 0xe8, 0x05, 0x1e, 0x17, 0x31, 0x4f, 0x5f,
    0x47, 0x22, 0x60, 0x43, 0xfa, 0x22, 0x02, 0xad, 0x45, 0x78, 0x34, 0x4d, 0x5d, 0x9b, 0xdd, 0x03,
];
const TRADE_EXTRACTOR_ID: [u8; 16] = *b"c1016-q29trd0001";
const TRADE_EXTRACTOR_VERSION: u16 = 1;
const TRADE_PARAMETER_DIGEST: [u8; 32] = [
    0xb2, 0x3f, 0xc4, 0xfe, 0x72, 0x76, 0x49, 0x30, 0xf0, 0x97, 0xcb, 0x18, 0x07, 0x20, 0x72, 0x91,
    0x95, 0x7b, 0x20, 0x52, 0x63, 0xaf, 0xdf, 0x30, 0x0f, 0x06, 0x17, 0xd0, 0xf7, 0x5e, 0x3f, 0x85,
];
const TRADE_SEMANTICS_COMMITMENT: [u8; 32] = [
    0x3f, 0x39, 0x51, 0x33, 0xcb, 0x21, 0xcf, 0xc4, 0x0c, 0xa5, 0x51, 0x5b, 0x1d, 0x3f, 0x0f, 0xd6,
    0xd6, 0x34, 0xb1, 0x61, 0x0c, 0x0b, 0xac, 0x67, 0x31, 0x4d, 0x38, 0x56, 0x8a, 0xaf, 0xcb, 0x2d,
];

const TRADE_A: [usize; 6] = [0, 1, 2, 7, 18, 21];
const TRADE_B: [usize; 6] = [0, 1, 2, 8, 17, 18];

pub const Q29_MOMENT_PROVENANCE: ProvenanceClass = ProvenanceClass::ProvedStructural;
pub const Q29_RETAINED_ROOT_PROVENANCE: ProvenanceClass = ProvenanceClass::ObservedEvolved;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29MomentError {
    Inventory(Q29InventoryError),
    NotResidualTrade,
}

impl From<Q29InventoryError> for Q29MomentError {
    fn from(value: Q29InventoryError) -> Self {
        Self::Inventory(value)
    }
}

/// Four row moments followed by the two exact-target predicates.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29EvenMomentSignature {
    moments: [[u8; MOMENT_DEGREES]; BLOCKS],
    t2: u8,
    t4: u8,
    accepts_t2: u8,
    accepts_t2_t4: u8,
    _reserved: [u8; 12],
}

const _: () = assert!(core::mem::size_of::<Q29EvenMomentSignature>() == 32);
const _: () = assert!(core::mem::align_of::<Q29EvenMomentSignature>() == 1);

impl Q29EvenMomentSignature {
    #[must_use]
    pub const fn t2(self) -> u8 {
        self.t2
    }

    #[must_use]
    pub const fn t4(self) -> u8 {
        self.t4
    }

    #[must_use]
    pub const fn accepts_t2(self) -> bool {
        self.accepts_t2 != 0
    }

    #[must_use]
    pub const fn accepts_t2_t4(self) -> bool {
        self.accepts_t2_t4 != 0
    }

    #[must_use]
    pub const fn row_moment(self, block: usize, degree: usize) -> Option<u8> {
        if block < BLOCKS && degree >= 1 && degree <= MOMENT_DEGREES {
            Some(self.moments[block][degree - 1])
        } else {
            None
        }
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29EvenMomentProof {
    descriptor: ExtractorDescriptor,
    source_data_commitment: [u8; 32],
    signature: Q29EvenMomentSignature,
    provenance: ProvenanceClass,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29SingleSwapCensus {
    pub legal_swaps: u32,
    pub t2_survivors: u32,
    pub t2_t4_survivors: u32,
    pub exact_repairs: u32,
    pub t2_survivors_by_block: [u16; BLOCKS],
    pub source_t2: u8,
    pub source_t4: u8,
    pub required_delta_t2: u8,
    pub required_delta_t4: u8,
    pub root_provenance: ProvenanceClass,
    pub theorem_provenance: ProvenanceClass,
    pub census_provenance: ProvenanceClass,
    pub _reserved: [u8; 3],
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29TradeWitness {
    a_mask: u32,
    b_mask: u32,
    multiplier: u8,
    orientation: i8,
    _reserved: [u8; 6],
}

const _: () = assert!(core::mem::size_of::<Q29TradeWitness>() == 16);
const _: () = assert!(core::mem::align_of::<Q29TradeWitness>() == 4);

impl Q29TradeWitness {
    #[must_use]
    pub const fn a_mask(self) -> u32 {
        self.a_mask
    }

    #[must_use]
    pub const fn b_mask(self) -> u32 {
        self.b_mask
    }

    #[must_use]
    pub const fn multiplier(self) -> u8 {
        self.multiplier
    }

    #[must_use]
    pub const fn orientation(self) -> i8 {
        self.orientation
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29TradeProof {
    descriptor: ExtractorDescriptor,
    source_data_commitment: [u8; 32],
    residual: [i8; Q29_ROW_LENGTH],
    witness: Q29TradeWitness,
    provenance: ProvenanceClass,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29TradeRepairCensus {
    pub candidates: u32,
    pub bounded_candidates: u32,
    pub energy_preserving_candidates: u32,
    pub exact_repairs: u32,
    pub root_provenance: ProvenanceClass,
    pub trade_provenance: ProvenanceClass,
    pub census_provenance: ProvenanceClass,
    pub _reserved: u8,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29TradePairCensus {
    pub bounded_applications: u32,
    pub application_pairs: u32,
    pub bounded_pairs: u32,
    pub energy_preserving_pairs: u32,
    pub exact_repairs: u32,
    pub root_provenance: ProvenanceClass,
    pub trade_provenance: ProvenanceClass,
    pub census_provenance: ProvenanceClass,
    pub _reserved: u8,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29TradeTripleCensus {
    pub bounded_applications: u32,
    pub application_triples: u32,
    pub bounded_triples: u32,
    pub energy_preserving_triples: u32,
    pub moment_preserving_triples: u32,
    pub exact_repairs: u32,
    pub root_provenance: ProvenanceClass,
    pub trade_provenance: ProvenanceClass,
    pub census_provenance: ProvenanceClass,
    pub _reserved: u8,
}

#[repr(C)]
#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29TradeQuadrupleCensus {
    pub application_quadruples: u64,
    pub bounded_applications: u32,
    pub bounded_quadruples: u32,
    pub energy_preserving_quadruples: u32,
    pub moment_preserving_quadruples: u32,
    pub exact_repairs: u32,
    pub root_provenance: ProvenanceClass,
    pub trade_provenance: ProvenanceClass,
    pub census_provenance: ProvenanceClass,
    pub _reserved: u8,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29TradeTablebaseReport {
    pub local_states: [u32; BLOCKS],
    pub distinct_left_pair_keys: u32,
    pub right_pair_probes: u64,
    pub exact_repairs: u32,
    pub root_provenance: ProvenanceClass,
    pub trade_provenance: ProvenanceClass,
    pub census_provenance: ProvenanceClass,
}

#[repr(C)]
#[derive(Clone, Copy)]
struct Q29TradeApplication {
    block: u8,
    translation: u8,
    orientation: i8,
    _reserved: [u8; 5],
}

const _: () = assert!(std::mem::size_of::<Q29TradeApplication>() == 8);
const _: () = assert!(std::mem::align_of::<Q29TradeApplication>() == 1);

const Q29_TRADE_APPLICATIONS_PER_BLOCK: usize = Q29_ROW_LENGTH * 2;
const Q29_TRADE_LOCAL_STATES: usize = 1
    + Q29_TRADE_APPLICATIONS_PER_BLOCK
    + Q29_TRADE_APPLICATIONS_PER_BLOCK * (Q29_TRADE_APPLICATIONS_PER_BLOCK + 1) / 2;
const Q29_TRADE_PAIR_TT_SLOTS: usize = 1 << 24;

/// Cold RAM-for-compute workspace for the exact trade-template tablebase.
/// Hot keys are contiguous 32-byte full-correlation deltas; witness words are
/// kept in a cold sibling array and resolved only after a hit.
pub struct Q29TradeTablebaseWorkspace {
    local_deltas: [Vec<[i16; 16]>; BLOCKS],
    local_moves: [Vec<u16>; BLOCKS],
    pair_deltas: Vec<[i16; 16]>,
    pair_moves: Vec<u32>,
    slots: Vec<u32>,
}

impl Q29TradeTablebaseWorkspace {
    #[must_use]
    pub fn new() -> Self {
        Self {
            local_deltas: std::array::from_fn(|_| Vec::with_capacity(Q29_TRADE_LOCAL_STATES)),
            local_moves: std::array::from_fn(|_| Vec::with_capacity(Q29_TRADE_LOCAL_STATES)),
            pair_deltas: Vec::with_capacity(Q29_TRADE_LOCAL_STATES * Q29_TRADE_LOCAL_STATES),
            pair_moves: Vec::with_capacity(Q29_TRADE_LOCAL_STATES * Q29_TRADE_LOCAL_STATES),
            slots: vec![0; Q29_TRADE_PAIR_TT_SLOTS],
        }
    }

    #[must_use]
    pub fn bytes(&self) -> usize {
        self.local_deltas.iter().map(Vec::capacity).sum::<usize>()
            * std::mem::size_of::<[i16; 16]>()
            + self.local_moves.iter().map(Vec::capacity).sum::<usize>() * std::mem::size_of::<u16>()
            + self.pair_deltas.capacity() * std::mem::size_of::<[i16; 16]>()
            + self.pair_moves.capacity() * std::mem::size_of::<u32>()
            + self.slots.capacity() * std::mem::size_of::<u32>()
    }
}

impl Default for Q29TradeTablebaseWorkspace {
    fn default() -> Self {
        Self::new()
    }
}

#[must_use]
pub const fn q29_moment_descriptor() -> ExtractorDescriptor {
    ExtractorDescriptor::registered(
        MOMENT_EXTRACTOR_ID,
        MOMENT_EXTRACTOR_VERSION,
        MOMENT_PARAMETER_DIGEST,
        MOMENT_SEMANTICS_COMMITMENT,
    )
}

#[must_use]
pub const fn q29_trade_descriptor() -> ExtractorDescriptor {
    ExtractorDescriptor::registered(
        TRADE_EXTRACTOR_ID,
        TRADE_EXTRACTOR_VERSION,
        TRADE_PARAMETER_DIGEST,
        TRADE_SEMANTICS_COMMITMENT,
    )
}

/// Allocation-free canonical extraction of the two structural moments.
pub fn extract_q29_even_moments(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
) -> Result<Q29EvenMomentSignature, Q29MomentError> {
    extract_q29_inventories(rows)?;
    let mut moments = [[0_u8; MOMENT_DEGREES]; BLOCKS];
    for block in 0..BLOCKS {
        for point in 0..Q29_ROW_LENGTH {
            let mut power = point as i32;
            for degree in 0..MOMENT_DEGREES {
                let term = i32::from(rows[block][point]) * power;
                moments[block][degree] =
                    (i32::from(moments[block][degree]) + term).rem_euclid(PRIME) as u8;
                power = power * point as i32 % PRIME;
            }
        }
    }
    Ok(signature_from_moments(moments))
}

#[inline(always)]
fn signature_from_moments(moments: [[u8; MOMENT_DEGREES]; BLOCKS]) -> Q29EvenMomentSignature {
    let mut t2 = 2 * i32::from(moments[0][1]);
    let mut t4 = 2 * i32::from(moments[0][3]);
    for row in moments {
        let m1 = i32::from(row[0]);
        let m2 = i32::from(row[1]);
        let m3 = i32::from(row[2]);
        t2 -= 2 * m1 * m1;
        t4 += -8 * m1 * m3 + 6 * m2 * m2;
    }
    let t2 = t2.rem_euclid(PRIME) as u8;
    let t4 = t4.rem_euclid(PRIME) as u8;
    Q29EvenMomentSignature {
        moments,
        t2,
        t4,
        accepts_t2: u8::from(t2 == 0),
        accepts_t2_t4: u8::from(t2 == 0 && t4 == 0),
        _reserved: [0; 12],
    }
}

pub fn derive_q29_even_moment_proof(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
) -> Result<Q29EvenMomentProof, Q29MomentError> {
    Ok(Q29EvenMomentProof {
        descriptor: q29_moment_descriptor(),
        source_data_commitment: rows_commitment(rows, MOMENT_EXTRACTOR_ID),
        signature: extract_q29_even_moments(rows)?,
        provenance: ProvenanceClass::ProvedStructural,
    })
}

/// Replay binds extractor identity, parameters, semantics, source bytes, and
/// independently recomputed fields.  Serialized feature names have no role.
#[must_use]
pub fn replay_q29_even_moment_proof(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
    proof: &Q29EvenMomentProof,
) -> bool {
    proof.descriptor == q29_moment_descriptor()
        && proof.provenance == ProvenanceClass::ProvedStructural
        && proof.source_data_commitment == rows_commitment(rows, MOMENT_EXTRACTOR_ID)
        && extract_q29_even_moments(rows).is_ok_and(|signature| signature == proof.signature)
}

/// Exact finite census of every unequal-value transposition around `rows`.
/// The moment update is constant-size; any survivor is directly replayed
/// against all 29 target correlations before it is counted as a repair.
pub fn census_q29_single_swaps(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
) -> Result<Q29SingleSwapCensus, Q29MomentError> {
    let source = extract_q29_even_moments(rows)?;
    let mut report = Q29SingleSwapCensus {
        legal_swaps: 0,
        t2_survivors: 0,
        t2_t4_survivors: 0,
        exact_repairs: 0,
        t2_survivors_by_block: [0; BLOCKS],
        source_t2: source.t2,
        source_t4: source.t4,
        required_delta_t2: (PRIME - i32::from(source.t2)).rem_euclid(PRIME) as u8,
        required_delta_t4: (PRIME - i32::from(source.t4)).rem_euclid(PRIME) as u8,
        root_provenance: ProvenanceClass::ObservedEvolved,
        theorem_provenance: ProvenanceClass::ProvedStructural,
        census_provenance: ProvenanceClass::ExactComputational,
        _reserved: [0; 3],
    };
    for block in 0..BLOCKS {
        for first in 0..Q29_ROW_LENGTH {
            for second in first + 1..Q29_ROW_LENGTH {
                let left = rows[block][first];
                let right = rows[block][second];
                if left == right {
                    continue;
                }
                report.legal_swaps += 1;
                let difference = i32::from(right) - i32::from(left);
                let mut changed = source.moments;
                let mut left_power = first as i32;
                let mut right_power = second as i32;
                for degree in 0..MOMENT_DEGREES {
                    changed[block][degree] = (i32::from(changed[block][degree])
                        + difference * (left_power - right_power))
                        .rem_euclid(PRIME) as u8;
                    left_power = left_power * first as i32 % PRIME;
                    right_power = right_power * second as i32 % PRIME;
                }
                let candidate = signature_from_moments(changed);
                if !candidate.accepts_t2() {
                    continue;
                }
                report.t2_survivors += 1;
                report.t2_survivors_by_block[block] += 1;
                if !candidate.accepts_t2_t4() {
                    continue;
                }
                report.t2_t4_survivors += 1;
                let mut repaired = *rows;
                repaired[block].swap(first, second);
                report.exact_repairs += u32::from(direct_exact_q29(&repaired));
            }
        }
    }
    Ok(report)
}

/// Canonical evolved root whose full residual has squared y-score six.
#[must_use]
pub const fn retained_q29_y6_root() -> [[i8; Q29_ROW_LENGTH]; BLOCKS] {
    [
        [
            -1, -1, 1, -1, -1, -1, -1, -1, -1, 0, 0, -1, 1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 0, 1, 0, 0,
            -1, 0, 1,
        ],
        [
            1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, -1, 0, -1, -5, 1, 0, -1, 0, 1, 0, -1, 0, 1, -1, -1,
            1, 1,
        ],
        [
            7, -1, -4, 0, -1, -2, -1, -2, -1, -1, -3, -1, 9, -2, -1, -4, 1, 0, 0, 0, 0, -1, 6, 0,
            -1, 0, -1, 5, -1,
        ],
        [
            4, -2, 5, -1, -1, -2, -1, -5, -1, 5, -1, 0, 0, -1, 2, -1, -1, 5, 6, -1, -1, -1, -1, -1,
            -1, -1, -2, -1, 0,
        ],
    ]
}

/// Extract the full signed residual from the exact q29 target.
pub fn extract_q29_residual(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
) -> Result<[i8; Q29_ROW_LENGTH], Q29MomentError> {
    extract_q29_inventories(rows)?;
    let mut residual = [0_i8; Q29_ROW_LENGTH];
    for shift in 0..Q29_ROW_LENGTH {
        let correlation = combined_correlation(rows, shift);
        let target = if shift == 0 { 505 } else { -18 };
        residual[shift] =
            i8::try_from(correlation - target).map_err(|_| Q29MomentError::NotResidualTrade)?;
    }
    Ok(residual)
}

/// Detect the six-point trade up to multiplication by a unit and orientation.
/// Translation is absent because autocorrelation is translation invariant.
pub fn detect_q29_six_point_trade(
    residual: &[i8; Q29_ROW_LENGTH],
) -> Result<Q29TradeWitness, Q29MomentError> {
    for multiplier in 1..Q29_ROW_LENGTH {
        let mut a_mask = 0_u32;
        let mut b_mask = 0_u32;
        for &point in &TRADE_A {
            a_mask |= 1_u32 << (point * multiplier % Q29_ROW_LENGTH);
        }
        for &point in &TRADE_B {
            b_mask |= 1_u32 << (point * multiplier % Q29_ROW_LENGTH);
        }
        for orientation in [1_i8, -1] {
            let witness = Q29TradeWitness {
                a_mask,
                b_mask,
                multiplier: multiplier as u8,
                orientation,
                _reserved: [0; 6],
            };
            if replay_trade_witness(residual, witness) {
                return Ok(witness);
            }
        }
    }
    Err(Q29MomentError::NotResidualTrade)
}

#[must_use]
pub fn replay_trade_witness(residual: &[i8; Q29_ROW_LENGTH], witness: Q29TradeWitness) -> bool {
    if witness.multiplier == 0
        || usize::from(witness.multiplier) >= Q29_ROW_LENGTH
        || !matches!(witness.orientation, -1 | 1)
        || witness.a_mask.count_ones() != 6
        || witness.b_mask.count_ones() != 6
    {
        return false;
    }
    for shift in 0..Q29_ROW_LENGTH {
        let mut a_correlation = 0_i8;
        let mut b_correlation = 0_i8;
        for point in 0..Q29_ROW_LENGTH {
            a_correlation += i8::from(
                witness.a_mask & (1_u32 << point) != 0
                    && witness.a_mask & (1_u32 << ((point + shift) % Q29_ROW_LENGTH)) != 0,
            );
            b_correlation += i8::from(
                witness.b_mask & (1_u32 << point) != 0
                    && witness.b_mask & (1_u32 << ((point + shift) % Q29_ROW_LENGTH)) != 0,
            );
        }
        if witness.orientation * (a_correlation - b_correlation) != residual[shift] {
            return false;
        }
    }
    true
}

pub fn derive_q29_trade_proof(
    residual: &[i8; Q29_ROW_LENGTH],
) -> Result<Q29TradeProof, Q29MomentError> {
    Ok(Q29TradeProof {
        descriptor: q29_trade_descriptor(),
        source_data_commitment: residual_commitment(residual),
        residual: *residual,
        witness: detect_q29_six_point_trade(residual)?,
        provenance: ProvenanceClass::ProvedStructural,
    })
}

#[must_use]
pub fn replay_q29_trade_proof(residual: &[i8; Q29_ROW_LENGTH], proof: &Q29TradeProof) -> bool {
    proof.descriptor == q29_trade_descriptor()
        && proof.provenance == ProvenanceClass::ProvedStructural
        && proof.source_data_commitment == residual_commitment(residual)
        && proof.residual == *residual
        && replay_trade_witness(residual, proof.witness)
}

/// Test every translated orientation of the detected trade as a one-row
/// additive repair.  These candidates preserve row sums by construction;
/// bounds, energy, and every original correlation are replayed directly.
pub fn census_q29_trade_repairs(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
    witness: Q29TradeWitness,
) -> Result<Q29TradeRepairCensus, Q29MomentError> {
    extract_q29_inventories(rows)?;
    let mut report = Q29TradeRepairCensus {
        candidates: 0,
        bounded_candidates: 0,
        energy_preserving_candidates: 0,
        exact_repairs: 0,
        root_provenance: ProvenanceClass::ObservedEvolved,
        trade_provenance: ProvenanceClass::ProvedStructural,
        census_provenance: ProvenanceClass::ExactComputational,
        _reserved: 0,
    };
    for block in 0..BLOCKS {
        for translation in 0..Q29_ROW_LENGTH {
            for orientation in [1_i8, -1] {
                report.candidates += 1;
                let mut candidate = *rows;
                let mut bounded = true;
                for point in 0..Q29_ROW_LENGTH {
                    let source = (point + Q29_ROW_LENGTH - translation) % Q29_ROW_LENGTH;
                    let in_a = witness.a_mask & (1_u32 << source) != 0;
                    let in_b = witness.b_mask & (1_u32 << source) != 0;
                    let delta = orientation * (i8::from(in_b) - i8::from(in_a));
                    candidate[block][point] += delta;
                    bounded &= (-9..=9).contains(&candidate[block][point]);
                }
                if !bounded {
                    continue;
                }
                report.bounded_candidates += 1;
                if combined_correlation(&candidate, 0) != 505 {
                    continue;
                }
                report.energy_preserving_candidates += 1;
                report.exact_repairs += u32::from(direct_exact_q29(&candidate));
            }
        }
    }
    Ok(report)
}

/// Exhaust every pair (with replacement) of bounded translated/oriented
/// applications of the detected trade.  Same-row pairs are applied
/// sequentially to the complete row; no additive PAF delta is assumed.
pub fn census_q29_trade_pair_repairs(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
    witness: Q29TradeWitness,
) -> Result<(Q29TradePairCensus, Option<[[i8; Q29_ROW_LENGTH]; BLOCKS]>), Q29MomentError> {
    extract_q29_inventories(rows)?;
    let mut applications = [Q29TradeApplication {
        block: 0,
        translation: 0,
        orientation: 1,
        _reserved: [0; 5],
    }; BLOCKS * Q29_ROW_LENGTH * 2];
    let mut application_count = 0_usize;
    for block in 0..BLOCKS {
        for translation in 0..Q29_ROW_LENGTH {
            for orientation in [1_i8, -1] {
                let application = Q29TradeApplication {
                    block: block as u8,
                    translation: translation as u8,
                    orientation,
                    _reserved: [0; 5],
                };
                let mut candidate = *rows;
                if apply_trade(&mut candidate, witness, application) {
                    applications[application_count] = application;
                    application_count += 1;
                }
            }
        }
    }
    let mut report = Q29TradePairCensus {
        bounded_applications: application_count as u32,
        application_pairs: 0,
        bounded_pairs: 0,
        energy_preserving_pairs: 0,
        exact_repairs: 0,
        root_provenance: ProvenanceClass::ObservedEvolved,
        trade_provenance: ProvenanceClass::ProvedStructural,
        census_provenance: ProvenanceClass::ExactComputational,
        _reserved: 0,
    };
    let mut first_exact = None;
    for left in 0..application_count {
        for right in left..application_count {
            report.application_pairs += 1;
            let mut candidate = *rows;
            if !apply_trade(&mut candidate, witness, applications[left])
                || !apply_trade(&mut candidate, witness, applications[right])
            {
                continue;
            }
            report.bounded_pairs += 1;
            if combined_correlation(&candidate, 0) != 505 {
                continue;
            }
            report.energy_preserving_pairs += 1;
            if direct_exact_q29(&candidate) {
                report.exact_repairs += 1;
                first_exact.get_or_insert(candidate);
            }
        }
    }
    Ok((report, first_exact))
}

/// Exhaust every triple (with replacement) of bounded applications of the
/// proved trade. Applications are replayed sequentially, including within a
/// row. The moment gate is necessary only; every reported hit receives full
/// direct q29 replay.
pub fn census_q29_trade_triple_repairs(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
    witness: Q29TradeWitness,
) -> Result<(Q29TradeTripleCensus, Option<[[i8; Q29_ROW_LENGTH]; BLOCKS]>), Q29MomentError> {
    extract_q29_inventories(rows)?;
    let mut applications = [Q29TradeApplication {
        block: 0,
        translation: 0,
        orientation: 1,
        _reserved: [0; 5],
    }; BLOCKS * Q29_ROW_LENGTH * 2];
    let mut application_count = 0_usize;
    for block in 0..BLOCKS {
        for translation in 0..Q29_ROW_LENGTH {
            for orientation in [1_i8, -1] {
                let application = Q29TradeApplication {
                    block: block as u8,
                    translation: translation as u8,
                    orientation,
                    _reserved: [0; 5],
                };
                let mut candidate = *rows;
                if apply_trade(&mut candidate, witness, application) {
                    applications[application_count] = application;
                    application_count += 1;
                }
            }
        }
    }
    let mut report = Q29TradeTripleCensus {
        bounded_applications: application_count as u32,
        application_triples: 0,
        bounded_triples: 0,
        energy_preserving_triples: 0,
        moment_preserving_triples: 0,
        exact_repairs: 0,
        root_provenance: ProvenanceClass::ObservedEvolved,
        trade_provenance: ProvenanceClass::ProvedStructural,
        census_provenance: ProvenanceClass::ExactComputational,
        _reserved: 0,
    };
    let mut first_exact = None;
    for first in 0..application_count {
        for second in first..application_count {
            for third in second..application_count {
                report.application_triples += 1;
                let mut candidate = *rows;
                if !apply_trade(&mut candidate, witness, applications[first])
                    || !apply_trade(&mut candidate, witness, applications[second])
                    || !apply_trade(&mut candidate, witness, applications[third])
                {
                    continue;
                }
                report.bounded_triples += 1;
                if combined_correlation(&candidate, 0) != 505 {
                    continue;
                }
                report.energy_preserving_triples += 1;
                if !extract_q29_even_moments(&candidate)?.accepts_t2_t4() {
                    continue;
                }
                report.moment_preserving_triples += 1;
                if direct_exact_q29(&candidate) {
                    report.exact_repairs += 1;
                    first_exact.get_or_insert(candidate);
                }
            }
        }
    }
    Ok((report, first_exact))
}

/// Exhaust every quadruple (with replacement) of bounded applications of the
/// proved trade, with sequential same-row semantics and direct replay of hits.
pub fn census_q29_trade_quadruple_repairs(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
    witness: Q29TradeWitness,
) -> Result<
    (
        Q29TradeQuadrupleCensus,
        Option<[[i8; Q29_ROW_LENGTH]; BLOCKS]>,
    ),
    Q29MomentError,
> {
    extract_q29_inventories(rows)?;
    let mut applications = [Q29TradeApplication {
        block: 0,
        translation: 0,
        orientation: 1,
        _reserved: [0; 5],
    }; BLOCKS * Q29_ROW_LENGTH * 2];
    let mut application_count = 0_usize;
    for block in 0..BLOCKS {
        for translation in 0..Q29_ROW_LENGTH {
            for orientation in [1_i8, -1] {
                let application = Q29TradeApplication {
                    block: block as u8,
                    translation: translation as u8,
                    orientation,
                    _reserved: [0; 5],
                };
                let mut candidate = *rows;
                if apply_trade(&mut candidate, witness, application) {
                    applications[application_count] = application;
                    application_count += 1;
                }
            }
        }
    }
    let mut report = Q29TradeQuadrupleCensus {
        application_quadruples: 0,
        bounded_applications: application_count as u32,
        bounded_quadruples: 0,
        energy_preserving_quadruples: 0,
        moment_preserving_quadruples: 0,
        exact_repairs: 0,
        root_provenance: ProvenanceClass::ObservedEvolved,
        trade_provenance: ProvenanceClass::ProvedStructural,
        census_provenance: ProvenanceClass::ExactComputational,
        _reserved: 0,
    };
    let mut first_exact = None;
    for first in 0..application_count {
        for second in first..application_count {
            for third in second..application_count {
                for fourth in third..application_count {
                    report.application_quadruples += 1;
                    let mut candidate = *rows;
                    if !apply_trade(&mut candidate, witness, applications[first])
                        || !apply_trade(&mut candidate, witness, applications[second])
                        || !apply_trade(&mut candidate, witness, applications[third])
                        || !apply_trade(&mut candidate, witness, applications[fourth])
                    {
                        continue;
                    }
                    report.bounded_quadruples += 1;
                    if combined_correlation(&candidate, 0) != 505 {
                        continue;
                    }
                    report.energy_preserving_quadruples += 1;
                    if !extract_q29_even_moments(&candidate)?.accepts_t2_t4() {
                        continue;
                    }
                    report.moment_preserving_quadruples += 1;
                    if direct_exact_q29(&candidate) {
                        report.exact_repairs += 1;
                        first_exact.get_or_insert(candidate);
                    }
                }
            }
        }
    }
    Ok((report, first_exact))
}

fn apply_trade(
    rows: &mut [[i8; Q29_ROW_LENGTH]; BLOCKS],
    witness: Q29TradeWitness,
    application: Q29TradeApplication,
) -> bool {
    let row = &mut rows[usize::from(application.block)];
    for point in 0..Q29_ROW_LENGTH {
        let source =
            (point + Q29_ROW_LENGTH - usize::from(application.translation)) % Q29_ROW_LENGTH;
        let in_a = witness.a_mask & (1_u32 << source) != 0;
        let in_b = witness.b_mask & (1_u32 << source) != 0;
        let delta = application.orientation * (i8::from(in_b) - i8::from(in_a));
        let Some(value) = row[point].checked_add(delta) else {
            return false;
        };
        if !(-9..=9).contains(&value) {
            return false;
        }
        row[point] = value;
    }
    true
}

#[inline(always)]
fn trade_delta_hash(delta: &[i16; 16]) -> usize {
    let mut hash = 0x9e37_79b9_7f4a_7c15_u64;
    for &value in delta {
        hash ^= u64::from(value as u16);
        hash = hash.rotate_left(13).wrapping_mul(0xbf58_476d_1ce4_e5b9);
    }
    hash as usize
}

fn trade_application(index: usize, block: usize) -> Q29TradeApplication {
    Q29TradeApplication {
        block: block as u8,
        translation: (index / 2) as u8,
        orientation: if index & 1 == 0 { 1 } else { -1 },
        _reserved: [0; 5],
    }
}

#[inline(always)]
fn row_correlation(row: &[i8; Q29_ROW_LENGTH], shift: usize) -> i32 {
    (0..Q29_ROW_LENGTH)
        .map(|point| i32::from(row[point]) * i32::from(row[(point + shift) % Q29_ROW_LENGTH]))
        .sum()
}

fn apply_trade_net(
    row: &[i8; Q29_ROW_LENGTH],
    witness: Q29TradeWitness,
    first: Option<usize>,
    second: Option<usize>,
    block: usize,
) -> Option<[i8; Q29_ROW_LENGTH]> {
    let mut changed = *row;
    for application_index in [first, second].into_iter().flatten() {
        let application = trade_application(application_index, block);
        for point in 0..Q29_ROW_LENGTH {
            let source =
                (point + Q29_ROW_LENGTH - usize::from(application.translation)) % Q29_ROW_LENGTH;
            let in_a = witness.a_mask & (1_u32 << source) != 0;
            let in_b = witness.b_mask & (1_u32 << source) != 0;
            changed[point] += application.orientation * (i8::from(in_b) - i8::from(in_a));
        }
    }
    changed
        .iter()
        .all(|value| (-9..=9).contains(value))
        .then_some(changed)
}

fn compile_trade_local_states(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
    block: usize,
    witness: Q29TradeWitness,
    deltas: &mut Vec<[i16; 16]>,
    moves: &mut Vec<u16>,
) {
    deltas.clear();
    moves.clear();
    let base: [i32; 16] = std::array::from_fn(|shift| {
        if shift < 15 {
            row_correlation(&rows[block], shift)
        } else {
            0
        }
    });
    deltas.push([0; 16]);
    moves.push(u16::MAX);
    for first in 0..Q29_TRADE_APPLICATIONS_PER_BLOCK {
        if let Some(changed) = apply_trade_net(&rows[block], witness, Some(first), None, block) {
            deltas.push(std::array::from_fn(|shift| {
                if shift < 15 {
                    (row_correlation(&changed, shift) - base[shift]) as i16
                } else {
                    0
                }
            }));
            moves.push(first as u16 | 0xff00);
        }
        for second in first..Q29_TRADE_APPLICATIONS_PER_BLOCK {
            let Some(changed) =
                apply_trade_net(&rows[block], witness, Some(first), Some(second), block)
            else {
                continue;
            };
            deltas.push(std::array::from_fn(|shift| {
                if shift < 15 {
                    (row_correlation(&changed, shift) - base[shift]) as i16
                } else {
                    0
                }
            }));
            moves.push(first as u16 | ((second as u16) << 8));
        }
    }
}

#[inline(always)]
fn apply_local_trade_code(
    rows: &mut [[i8; Q29_ROW_LENGTH]; BLOCKS],
    block: usize,
    witness: Q29TradeWitness,
    code: u16,
) -> bool {
    let first = (code != u16::MAX).then_some(usize::from(code & 0xff));
    let second = (code >> 8 != 0xff).then_some(usize::from(code >> 8));
    let Some(changed) = apply_trade_net(&rows[block], witness, first, second, block) else {
        return false;
    };
    rows[block] = changed;
    true
}

/// Join every net state containing at most two proved trade applications per
/// row. Cross-row PAF deltas add exactly; same-row states are always rescored
/// from the complete modified row. The left TT key contains energy and all
/// independent q29 correlations, so one preimage per identical key is sound.
pub fn census_q29_trade_tablebase(
    rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
    witness: Q29TradeWitness,
    workspace: &mut Q29TradeTablebaseWorkspace,
) -> Result<
    (
        Q29TradeTablebaseReport,
        Option<[[i8; Q29_ROW_LENGTH]; BLOCKS]>,
    ),
    Q29MomentError,
> {
    extract_q29_inventories(rows)?;
    for block in 0..BLOCKS {
        compile_trade_local_states(
            rows,
            block,
            witness,
            &mut workspace.local_deltas[block],
            &mut workspace.local_moves[block],
        );
    }
    workspace.pair_deltas.clear();
    workspace.pair_moves.clear();
    workspace.slots.fill(0);
    for left in 0..workspace.local_deltas[0].len() {
        for right in 0..workspace.local_deltas[1].len() {
            let delta: [i16; 16] = std::array::from_fn(|index| {
                workspace.local_deltas[0][left][index] + workspace.local_deltas[1][right][index]
            });
            let mut slot = trade_delta_hash(&delta) & (Q29_TRADE_PAIR_TT_SLOTS - 1);
            loop {
                let stored = workspace.slots[slot];
                if stored == 0 {
                    let index = workspace.pair_deltas.len();
                    workspace.pair_deltas.push(delta);
                    workspace
                        .pair_moves
                        .push(left as u32 | ((right as u32) << 16));
                    workspace.slots[slot] = index as u32 + 1;
                    break;
                }
                if workspace.pair_deltas[stored as usize - 1] == delta {
                    break;
                }
                slot = (slot + 1) & (Q29_TRADE_PAIR_TT_SLOTS - 1);
            }
        }
    }
    let target: [i16; 16] = std::array::from_fn(|shift| {
        if shift < 15 {
            let wanted = if shift == 0 { 505 } else { -18 };
            (wanted - combined_correlation(rows, shift)) as i16
        } else {
            0
        }
    });
    let mut probes = 0_u64;
    for left in 0..workspace.local_deltas[2].len() {
        for right in 0..workspace.local_deltas[3].len() {
            probes += 1;
            let desired: [i16; 16] = std::array::from_fn(|index| {
                target[index]
                    - workspace.local_deltas[2][left][index]
                    - workspace.local_deltas[3][right][index]
            });
            let mut slot = trade_delta_hash(&desired) & (Q29_TRADE_PAIR_TT_SLOTS - 1);
            loop {
                let stored = workspace.slots[slot];
                if stored == 0 {
                    break;
                }
                let pair_index = stored as usize - 1;
                if workspace.pair_deltas[pair_index] == desired {
                    let pair = workspace.pair_moves[pair_index];
                    let mut candidate = *rows;
                    let codes = [
                        workspace.local_moves[0][(pair & 0xffff) as usize],
                        workspace.local_moves[1][(pair >> 16) as usize],
                        workspace.local_moves[2][left],
                        workspace.local_moves[3][right],
                    ];
                    if (0..BLOCKS).all(|block| {
                        apply_local_trade_code(&mut candidate, block, witness, codes[block])
                    }) && direct_exact_q29(&candidate)
                    {
                        let report = Q29TradeTablebaseReport {
                            local_states: workspace
                                .local_deltas
                                .each_ref()
                                .map(|states| states.len() as u32),
                            distinct_left_pair_keys: workspace.pair_deltas.len() as u32,
                            right_pair_probes: probes,
                            exact_repairs: 1,
                            root_provenance: ProvenanceClass::ObservedEvolved,
                            trade_provenance: ProvenanceClass::ProvedStructural,
                            census_provenance: ProvenanceClass::ExactComputational,
                        };
                        return Ok((report, Some(candidate)));
                    }
                    break;
                }
                slot = (slot + 1) & (Q29_TRADE_PAIR_TT_SLOTS - 1);
            }
        }
    }
    Ok((
        Q29TradeTablebaseReport {
            local_states: workspace
                .local_deltas
                .each_ref()
                .map(|states| states.len() as u32),
            distinct_left_pair_keys: workspace.pair_deltas.len() as u32,
            right_pair_probes: probes,
            exact_repairs: 0,
            root_provenance: ProvenanceClass::ObservedEvolved,
            trade_provenance: ProvenanceClass::ProvedStructural,
            census_provenance: ProvenanceClass::ExactComputational,
        },
        None,
    ))
}

#[inline(always)]
fn combined_correlation(rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS], shift: usize) -> i32 {
    let mut correlation = 0_i32;
    for row in rows {
        for point in 0..Q29_ROW_LENGTH {
            correlation += i32::from(row[point]) * i32::from(row[(point + shift) % Q29_ROW_LENGTH]);
        }
    }
    correlation
}

#[inline(always)]
fn direct_exact_q29(rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS]) -> bool {
    combined_correlation(rows, 0) == 505
        && (1..Q29_ROW_LENGTH).all(|shift| combined_correlation(rows, shift) == -18)
}

fn rows_commitment(rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS], extractor_id: [u8; 16]) -> [u8; 32] {
    let mut digest = Sha256::new();
    digest.update(extractor_id);
    for row in rows {
        for &value in row {
            digest.update([value as u8]);
        }
    }
    digest.finalize().into()
}

fn residual_commitment(residual: &[i8; Q29_ROW_LENGTH]) -> [u8; 32] {
    let mut digest = Sha256::new();
    digest.update(TRADE_EXTRACTOR_ID);
    for &value in residual {
        digest.update([value as u8]);
    }
    digest.finalize().into()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn independent_direct_moment(rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS], degree: u32) -> u8 {
        let mut total = 0_i64;
        for shift in 0..Q29_ROW_LENGTH {
            let mut correlation = 0_i64;
            for row in rows {
                for left in 0..Q29_ROW_LENGTH {
                    for right in 0..Q29_ROW_LENGTH {
                        if (right + Q29_ROW_LENGTH - left) % Q29_ROW_LENGTH == shift {
                            correlation += i64::from(row[left]) * i64::from(row[right]);
                        }
                    }
                }
            }
            total += i64::from((shift as i32).pow(degree).rem_euclid(PRIME)) * correlation;
        }
        total.rem_euclid(i64::from(PRIME)) as u8
    }

    fn independent_trade_residual(a_mask: u32, b_mask: u32) -> [i8; Q29_ROW_LENGTH] {
        let mut residual = [0_i8; Q29_ROW_LENGTH];
        for left in 0..Q29_ROW_LENGTH {
            for right in 0..Q29_ROW_LENGTH {
                let shift = (right + Q29_ROW_LENGTH - left) % Q29_ROW_LENGTH;
                if a_mask & (1_u32 << left) != 0 && a_mask & (1_u32 << right) != 0 {
                    residual[shift] += 1;
                }
                if b_mask & (1_u32 << left) != 0 && b_mask & (1_u32 << right) != 0 {
                    residual[shift] -= 1;
                }
            }
        }
        residual
    }

    fn independent_single_swap_census(
        rows: &[[i8; Q29_ROW_LENGTH]; BLOCKS],
    ) -> (u32, u32, u32, [u16; BLOCKS]) {
        let mut legal = 0_u32;
        let mut t2 = 0_u32;
        let mut both = 0_u32;
        let mut by_block = [0_u16; BLOCKS];
        for block in 0..BLOCKS {
            for first in 0..Q29_ROW_LENGTH {
                for second in first + 1..Q29_ROW_LENGTH {
                    if rows[block][first] == rows[block][second] {
                        continue;
                    }
                    legal += 1;
                    let mut candidate = *rows;
                    candidate[block].swap(first, second);
                    let direct_t2 = independent_direct_moment(&candidate, 2);
                    let direct_t4 = independent_direct_moment(&candidate, 4);
                    if direct_t2 == 0 {
                        t2 += 1;
                        by_block[block] += 1;
                        both += u32::from(direct_t4 == 0);
                    }
                }
            }
        }
        (legal, t2, both, by_block)
    }

    #[test]
    fn retained_root_moments_match_independent_full_group_ring_oracle() {
        let rows = retained_q29_y6_root();
        let signature = extract_q29_even_moments(&rows).unwrap();
        assert_eq!(signature.t2(), 1);
        assert_eq!(signature.t4(), 16);
        assert_eq!(signature.t2(), independent_direct_moment(&rows, 2));
        assert_eq!(signature.t4(), independent_direct_moment(&rows, 4));
    }

    #[test]
    fn exact_single_swap_census_has_no_radius_one_repair() {
        let rows = retained_q29_y6_root();
        let report = census_q29_single_swaps(&rows).unwrap();
        assert_eq!(report.legal_swaps, 1_154);
        assert_eq!(report.t2_survivors, 30);
        assert_eq!(report.t2_survivors_by_block, [10, 20, 0, 0]);
        assert_eq!(report.t2_t4_survivors, 0);
        assert_eq!(report.exact_repairs, 0);
        assert_eq!(report.required_delta_t2, 28);
        assert_eq!(report.required_delta_t4, 13);
        assert_eq!(
            independent_single_swap_census(&rows),
            (1_154, 30, 0, [10, 20, 0, 0])
        );
    }

    #[test]
    fn six_point_trade_replays_by_independent_pair_enumeration() {
        let residual = extract_q29_residual(&retained_q29_y6_root()).unwrap();
        let witness = detect_q29_six_point_trade(&residual).unwrap();
        assert_eq!(witness.multiplier(), 1);
        assert_eq!(witness.orientation(), 1);
        assert_eq!(
            independent_trade_residual(witness.a_mask(), witness.b_mask()),
            residual
        );
        assert!(replay_trade_witness(&residual, witness));
    }

    #[test]
    fn translated_trade_repair_census_is_exact_and_scoped() {
        let rows = retained_q29_y6_root();
        let residual = extract_q29_residual(&rows).unwrap();
        let witness = detect_q29_six_point_trade(&residual).unwrap();
        let report = census_q29_trade_repairs(&rows, witness).unwrap();
        assert_eq!(report.candidates, 232);
        assert_eq!(report.energy_preserving_candidates, 14);
        assert_eq!(report.exact_repairs, 0);
        assert_eq!(report.root_provenance, ProvenanceClass::ObservedEvolved);
        assert_eq!(report.trade_provenance, ProvenanceClass::ProvedStructural);
        assert_eq!(
            report.census_provenance,
            ProvenanceClass::ExactComputational
        );
    }

    #[test]
    fn paired_trade_family_is_exhausted_with_sequential_same_row_replay() {
        let rows = retained_q29_y6_root();
        let residual = extract_q29_residual(&rows).unwrap();
        let witness = detect_q29_six_point_trade(&residual).unwrap();
        let ((report, hit), allocations) =
            tracked_allocations(|| census_q29_trade_pair_repairs(&rows, witness).unwrap());
        assert_eq!(allocations, 0);
        assert_eq!(report.bounded_applications, 228);
        assert_eq!(report.application_pairs, 26_106);
        assert_eq!(report.bounded_pairs, 26_106);
        assert_eq!(report.energy_preserving_pairs, 1_428);
        assert_eq!(report.exact_repairs, u32::from(hit.is_some()));
        if let Some(hit) = hit {
            assert!(direct_exact_q29(&hit));
        }
    }

    #[test]
    fn triple_trade_family_is_exhausted_with_moment_and_direct_replay() {
        let rows = retained_q29_y6_root();
        let residual = extract_q29_residual(&rows).unwrap();
        let witness = detect_q29_six_point_trade(&residual).unwrap();
        let ((report, hit), allocations) =
            tracked_allocations(|| census_q29_trade_triple_repairs(&rows, witness).unwrap());
        assert_eq!(allocations, 0);
        assert_eq!(report.bounded_applications, 228);
        assert_eq!(report.application_triples, 2_001_460);
        assert_eq!(report.bounded_triples, 2_001_440);
        assert_eq!(report.energy_preserving_triples, 73_419);
        assert_eq!(report.moment_preserving_triples, 51);
        assert_eq!(report.exact_repairs, 0);
        assert_eq!(report.exact_repairs, u32::from(hit.is_some()));
        if let Some(hit) = hit {
            assert!(direct_exact_q29(&hit));
        }
    }

    #[test]
    fn quadruple_trade_family_is_exhausted_with_moment_and_direct_replay() {
        let rows = retained_q29_y6_root();
        let residual = extract_q29_residual(&rows).unwrap();
        let witness = detect_q29_six_point_trade(&residual).unwrap();
        let ((report, hit), allocations) =
            tracked_allocations(|| census_q29_trade_quadruple_repairs(&rows, witness).unwrap());
        assert_eq!(allocations, 0);
        assert_eq!(report.bounded_applications, 228);
        assert_eq!(report.application_quadruples, 115_584_315);
        assert_eq!(report.bounded_quadruples, 115_579_786);
        assert_eq!(report.energy_preserving_quadruples, 3_424_084);
        assert_eq!(report.moment_preserving_quadruples, 4_604);
        assert_eq!(report.exact_repairs, 0);
        assert_eq!(report.exact_repairs, u32::from(hit.is_some()));
        if let Some(hit) = hit {
            assert!(direct_exact_q29(&hit));
        }
    }

    #[test]
    fn per_row_trade_tablebase_is_exact_and_allocation_free() {
        let rows = retained_q29_y6_root();
        let residual = extract_q29_residual(&rows).unwrap();
        let witness = detect_q29_six_point_trade(&residual).unwrap();
        let mut workspace = Q29TradeTablebaseWorkspace::new();
        let ((report, hit), allocations) = tracked_allocations(|| {
            census_q29_trade_tablebase(&rows, witness, &mut workspace).unwrap()
        });
        assert_eq!(allocations, 0);
        assert!(workspace.bytes() < 256 * 1024 * 1024);
        assert_eq!(report.exact_repairs, u32::from(hit.is_some()));
        if let Some(hit) = hit {
            assert!(direct_exact_q29(&hit));
        }
    }

    #[test]
    fn proofs_reject_changed_sources_and_forged_semantics() {
        let rows = retained_q29_y6_root();
        let moment_proof = derive_q29_even_moment_proof(&rows).unwrap();
        assert!(replay_q29_even_moment_proof(&rows, &moment_proof));
        let mut changed_rows = rows;
        changed_rows[0].swap(0, 2);
        assert!(!replay_q29_even_moment_proof(&changed_rows, &moment_proof));
        let mut forged_moment = moment_proof;
        forged_moment.signature.t2 = 0;
        forged_moment.signature.accepts_t2 = 1;
        assert!(!replay_q29_even_moment_proof(&rows, &forged_moment));

        let residual = extract_q29_residual(&rows).unwrap();
        let trade_proof = derive_q29_trade_proof(&residual).unwrap();
        assert!(replay_q29_trade_proof(&residual, &trade_proof));
        let mut changed_residual = residual;
        changed_residual[2] = 1;
        changed_residual[27] = 1;
        assert!(!replay_q29_trade_proof(&changed_residual, &trade_proof));
        let mut forged_trade = trade_proof;
        forged_trade.witness.a_mask ^= 1 << 4;
        assert!(!replay_q29_trade_proof(&residual, &forged_trade));
    }

    #[test]
    fn extraction_census_and_trade_kernels_allocate_nothing() {
        let rows = retained_q29_y6_root();
        let residual = extract_q29_residual(&rows).unwrap();
        let witness = detect_q29_six_point_trade(&residual).unwrap();
        let (_, allocations) = tracked_allocations(|| {
            for _ in 0..100 {
                assert_eq!(extract_q29_even_moments(&rows).unwrap().t2(), 1);
                assert_eq!(census_q29_single_swaps(&rows).unwrap().t2_survivors, 30);
                assert_eq!(detect_q29_six_point_trade(&residual).unwrap(), witness);
                assert_eq!(
                    census_q29_trade_repairs(&rows, witness)
                        .unwrap()
                        .energy_preserving_candidates,
                    14
                );
            }
        });
        assert_eq!(allocations, 0);
    }
}
