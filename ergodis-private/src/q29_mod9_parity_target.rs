//! Discovery-only parity-targeted recombination inside one exact mod-nine lift fibre.
//!
//! Every pooled row already has the required sum, energy, bounds, and residues.
//! A direct-address table joins rows `(2,3)` to rows `(0,1)` by energy and by
//! their 14 nonconstant cyclic-autocorrelation parity coordinates.  Bit zero
//! needs no table space: it is odd-support parity, hence energy parity, and the
//! exact combined energy 505 forces the required bit automatically.

use crate::{
    q29_mod9_lift::{
        replay_q29_mod9_lift, sample_distinct_q29_mod9_lifts, Q29Mod9LiftError, Q29Mod9LiftWitness,
        Q29Mod9LiftWorkspace,
    },
    q29_parity_support::{cyclic_autocorrelation_parity, q29_support_quartet_satisfies_parity},
};

const ROW_POOL: usize = 1_024;
const PARITY_KEYS: usize = 1 << 14;
const ENERGY_VALUES: usize = 506;
const JOIN_SLOTS: usize = ENERGY_VALUES * PARITY_KEYS;

pub const Q29_PARITY_TARGET_WORKSPACE_BYTES: usize = ROW_POOL
    * core::mem::size_of::<Q29Mod9LiftWitness>()
    + ROW_POOL * core::mem::size_of::<[u16; 4]>()
    + JOIN_SLOTS * core::mem::size_of::<u32>()
    + JOIN_SLOTS * core::mem::size_of::<u16>()
    + core::mem::size_of::<u16>();

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29ParityTargetError {
    Lift(Q29Mod9LiftError),
    InvalidPoolLimit,
    InternalReplayFailure,
}

impl From<Q29Mod9LiftError> for Q29ParityTargetError {
    fn from(error: Q29Mod9LiftError) -> Self {
        Self::Lift(error)
    }
}

pub struct Q29ParityTargetWorkspace {
    samples: Box<[Q29Mod9LiftWitness]>,
    signatures: Box<[[u16; 4]]>,
    pair_values: Box<[u32]>,
    pair_epochs: Box<[u16]>,
    epoch: u16,
}

impl Q29ParityTargetWorkspace {
    #[must_use]
    pub fn new() -> Self {
        Self {
            samples: vec![Q29Mod9LiftWitness::ZERO; ROW_POOL].into_boxed_slice(),
            signatures: vec![[0; 4]; ROW_POOL].into_boxed_slice(),
            pair_values: vec![0; JOIN_SLOTS].into_boxed_slice(),
            pair_epochs: vec![0; JOIN_SLOTS].into_boxed_slice(),
            epoch: 0,
        }
    }

    #[must_use]
    pub const fn workspace_bytes(&self) -> usize {
        Q29_PARITY_TARGET_WORKSPACE_BYTES
    }
}

impl Default for Q29ParityTargetWorkspace {
    fn default() -> Self {
        Self::new()
    }
}

/// Sample a bounded row pool, then exactly join it for a parity-positive lift.
///
/// A returned witness is directly replayed.  `None` only means that this
/// bounded sampled pool had no joined witness; it has no negative authority
/// for the complete fibre.
pub fn sample_parity_targeted_q29_mod9_lift(
    residues: &[[u8; 29]; 4],
    lift: &Q29Mod9LiftWorkspace,
    workspace: &mut Q29ParityTargetWorkspace,
    random: &mut u64,
) -> Result<Option<Q29Mod9LiftWitness>, Q29ParityTargetError> {
    sample_parity_targeted_q29_mod9_lift_with_pool_limit(
        residues, lift, workspace, random, ROW_POOL,
    )
}

/// The same bounded join with an explicit prefix length for profiling and
/// adaptive search policies.
pub fn sample_parity_targeted_q29_mod9_lift_with_pool_limit(
    residues: &[[u8; 29]; 4],
    lift: &Q29Mod9LiftWorkspace,
    workspace: &mut Q29ParityTargetWorkspace,
    random: &mut u64,
    pool_limit: usize,
) -> Result<Option<Q29Mod9LiftWitness>, Q29ParityTargetError> {
    if !(1..=ROW_POOL).contains(&pool_limit) {
        return Err(Q29ParityTargetError::InvalidPoolLimit);
    }
    let produced = sample_distinct_q29_mod9_lifts(
        residues,
        lift,
        random,
        &mut workspace.samples[..pool_limit],
    )?;
    if produced == 0 {
        return Ok(None);
    }
    for index in 0..produced {
        for row in 0..4 {
            workspace.signatures[index][row] = row_signature(&workspace.samples[index].rows[row]);
        }
    }

    workspace.epoch = workspace.epoch.wrapping_add(1);
    if workspace.epoch == 0 {
        workspace.pair_epochs.fill(0);
        workspace.epoch = 1;
    }
    let epoch = workspace.epoch;
    for left in 0..produced {
        for right in 0..produced {
            let energy = usize::from(workspace.samples[left].row_energies[2])
                + usize::from(workspace.samples[right].row_energies[3]);
            if energy >= ENERGY_VALUES {
                continue;
            }
            let signature =
                usize::from((workspace.signatures[left][2] ^ workspace.signatures[right][3]) >> 1);
            let slot = energy * PARITY_KEYS + signature;
            workspace.pair_values[slot] = ((left as u32) << 16) | right as u32;
            workspace.pair_epochs[slot] = epoch;
        }
    }

    for left in 0..produced {
        for right in 0..produced {
            let left_energy = usize::from(workspace.samples[left].row_energies[0])
                + usize::from(workspace.samples[right].row_energies[1]);
            if left_energy > 505 {
                continue;
            }
            let energy = 505 - left_energy;
            let signature = usize::from(
                (workspace.signatures[left][0] ^ workspace.signatures[right][1] ^ 1) >> 1,
            );
            let slot = energy * PARITY_KEYS + signature;
            if workspace.pair_epochs[slot] != epoch {
                continue;
            }
            let pair = workspace.pair_values[slot];
            let row_two = (pair >> 16) as usize;
            let row_three = (pair & 65_535) as usize;
            let witness = Q29Mod9LiftWitness {
                rows: [
                    workspace.samples[left].rows[0],
                    workspace.samples[right].rows[1],
                    workspace.samples[row_two].rows[2],
                    workspace.samples[row_three].rows[3],
                ],
                row_energies: [
                    workspace.samples[left].row_energies[0],
                    workspace.samples[right].row_energies[1],
                    workspace.samples[row_two].row_energies[2],
                    workspace.samples[row_three].row_energies[3],
                ],
                _pad: [0; 4],
            };
            let supports = witness.rows.map(|row| row_support(&row));
            if !replay_q29_mod9_lift(residues, &witness)
                || !q29_support_quartet_satisfies_parity(supports)
            {
                return Err(Q29ParityTargetError::InternalReplayFailure);
            }
            return Ok(Some(witness));
        }
    }
    Ok(None)
}

#[inline(always)]
fn row_support(row: &[i8; 29]) -> u32 {
    let mut support = 0_u32;
    for (column, &value) in row.iter().enumerate() {
        support |= u32::from(value & 1 != 0) << column;
    }
    support
}

#[inline(always)]
fn row_signature(row: &[i8; 29]) -> u16 {
    cyclic_autocorrelation_parity(row_support(row))
}
