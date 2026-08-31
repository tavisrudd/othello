//! Exact semantic block cores for row systems over `GF(9)`.
//!
//! Domain adapters supply a dense row-major matrix and semantic block
//! boundaries. Compilation extracts minimum full-rank block masks and a
//! deterministic independent-row certificate. The reusable elimination
//! workspace allocates at construction, not during rank queries.

use std::marker::PhantomData;

use crate::semantic_sets::for_each_k_subset;

pub trait SmallField: Copy {
    const ORDER: u8;
    fn add(left: u8, right: u8) -> u8;
    fn neg(value: u8) -> u8;
    fn mul(left: u8, right: u8) -> u8;
    fn inverse(value: u8) -> u8;
}

#[derive(Debug, Clone, Copy)]
pub struct Gf9;

const fn gf9_add_value(left: u8, right: u8) -> u8 {
    ((left % 3 + right % 3) % 3) + 3 * ((left / 3 + right / 3) % 3)
}

const fn gf9_mul_value(left: u8, right: u8) -> u8 {
    let (a, b) = (left % 3, left / 3);
    let (c, d) = (right % 3, right / 3);
    ((a * c + 2 * b * d) % 3) + 3 * ((a * d + b * c) % 3)
}

const fn gf9_binary_table(multiply: bool) -> [u8; 81] {
    let mut table = [0; 81];
    let mut left = 0;
    while left < 9 {
        let mut right = 0;
        while right < 9 {
            table[left * 9 + right] = if multiply {
                gf9_mul_value(left as u8, right as u8)
            } else {
                gf9_add_value(left as u8, right as u8)
            };
            right += 1;
        }
        left += 1;
    }
    table
}

const fn gf9_inverse_table() -> [u8; 9] {
    let mut table = [0; 9];
    let mut value = 1;
    while value < 9 {
        let mut candidate = 1;
        while candidate < 9 {
            if gf9_mul_value(value as u8, candidate as u8) == 1 {
                table[value] = candidate as u8;
                break;
            }
            candidate += 1;
        }
        value += 1;
    }
    table
}

const GF9_ADD: [u8; 81] = gf9_binary_table(false);
const GF9_MUL: [u8; 81] = gf9_binary_table(true);
const GF9_NEG: [u8; 9] = [0, 2, 1, 6, 8, 7, 3, 5, 4];
const GF9_INV: [u8; 9] = gf9_inverse_table();

impl SmallField for Gf9 {
    const ORDER: u8 = 9;

    #[inline]
    fn add(left: u8, right: u8) -> u8 {
        GF9_ADD[left as usize * 9 + right as usize]
    }

    #[inline]
    fn neg(value: u8) -> u8 {
        GF9_NEG[value as usize]
    }

    #[inline]
    fn mul(left: u8, right: u8) -> u8 {
        GF9_MUL[left as usize * 9 + right as usize]
    }

    #[inline]
    fn inverse(value: u8) -> u8 {
        debug_assert_ne!(value, 0);
        GF9_INV[value as usize]
    }
}

#[derive(Debug, Clone)]
pub struct BlockSystem<F: SmallField> {
    columns: usize,
    rows: Box<[u8]>,
    block_offsets: Box<[usize]>,
    field: PhantomData<F>,
}

pub type Gf9BlockSystem = BlockSystem<Gf9>;

impl<F: SmallField> BlockSystem<F> {
    pub fn try_new(
        columns: usize,
        rows: Vec<u8>,
        block_offsets: Vec<usize>,
    ) -> Result<Self, &'static str> {
        if columns == 0 || rows.len() % columns != 0 {
            return Err("rank system has an invalid row shape");
        }
        let row_count = rows.len() / columns;
        if block_offsets.len() < 2
            || block_offsets.len() > 64
            || block_offsets[0] != 0
            || *block_offsets.last().unwrap() != row_count
            || block_offsets.windows(2).any(|pair| pair[0] >= pair[1])
        {
            return Err("rank system has invalid block offsets");
        }
        if rows.iter().any(|&value| value >= F::ORDER) {
            return Err("rank system contains a value outside its field");
        }
        Ok(Self {
            columns,
            rows: rows.into_boxed_slice(),
            block_offsets: block_offsets.into_boxed_slice(),
            field: PhantomData,
        })
    }

    #[must_use]
    pub fn columns(&self) -> usize {
        self.columns
    }

    #[must_use]
    pub fn row_count(&self) -> usize {
        self.rows.len() / self.columns
    }

    #[must_use]
    pub fn block_count(&self) -> usize {
        self.block_offsets.len() - 1
    }

    fn row(&self, index: usize) -> &[u8] {
        let start = index * self.columns;
        &self.rows[start..start + self.columns]
    }

    /// Materialize a one-block subsystem from replay row indices.
    pub fn select_rows(&self, indices: &[u32]) -> Result<Self, &'static str> {
        let mut rows = Vec::with_capacity(indices.len() * self.columns);
        for &index in indices {
            if index as usize >= self.row_count() {
                return Err("rank certificate row index is out of range");
            }
            rows.extend_from_slice(self.row(index as usize));
        }
        Self::try_new(self.columns, rows, vec![0, indices.len()])
    }
}

#[derive(Debug)]
pub struct RankWorkspace<F: SmallField> {
    matrix: Box<[u8]>,
    basis: Box<[u8]>,
    scratch: Box<[u8]>,
    pivots: Box<[usize]>,
    columns: usize,
    capacity_rows: usize,
    field: PhantomData<F>,
}

pub type Gf9RankWorkspace = RankWorkspace<Gf9>;

impl<F: SmallField> RankWorkspace<F> {
    #[must_use]
    pub fn new(capacity_rows: usize, columns: usize) -> Self {
        let capacity_rank = capacity_rows.min(columns);
        let compact_entries = capacity_rank
            .checked_mul(columns)
            .expect("rank workspace capacity overflow");
        let use_online_basis = capacity_rows > columns;
        Self {
            matrix: vec![0; (!use_online_basis as usize) * compact_entries].into_boxed_slice(),
            basis: vec![0; (use_online_basis as usize) * compact_entries].into_boxed_slice(),
            scratch: vec![0; (use_online_basis as usize) * columns].into_boxed_slice(),
            pivots: vec![0; (use_online_basis as usize) * capacity_rank].into_boxed_slice(),
            columns,
            capacity_rows,
            field: PhantomData,
        }
    }

    /// Heap payload reserved by the reusable rank state, excluding allocators' metadata.
    #[must_use]
    pub fn payload_bytes(&self) -> usize {
        self.matrix.len()
            + self.basis.len()
            + self.scratch.len()
            + self.pivots.len() * std::mem::size_of::<usize>()
    }

    /// Rank the selected semantic blocks. This method allocates nothing.
    pub fn rank_blocks(&mut self, system: &BlockSystem<F>, block_mask: u64) -> usize {
        assert_eq!(self.columns, system.columns);
        if self.capacity_rows <= self.columns {
            let mut used_rows = 0;
            for block in 0..system.block_count() {
                if block_mask & (1_u64 << block) == 0 {
                    continue;
                }
                for row in system.block_offsets[block]..system.block_offsets[block + 1] {
                    assert!(used_rows < self.capacity_rows);
                    let start = used_rows * self.columns;
                    self.matrix[start..start + self.columns].copy_from_slice(system.row(row));
                    used_rows += 1;
                }
            }
            return self.rank_matrix_prefix(used_rows);
        }
        self.rank_blocks_online(system, block_mask)
    }

    fn rank_blocks_online(&mut self, system: &BlockSystem<F>, block_mask: u64) -> usize {
        let mut used_rows = 0;
        let mut rank = 0;
        for block in 0..system.block_count() {
            if block_mask & (1_u64 << block) == 0 {
                continue;
            }
            for row in system.block_offsets[block]..system.block_offsets[block + 1] {
                assert!(used_rows < self.capacity_rows);
                used_rows += 1;
                self.scratch.copy_from_slice(system.row(row));
                for basis_row in 0..rank {
                    let pivot = self.pivots[basis_row];
                    let factor = self.scratch[pivot];
                    if factor == 0 {
                        continue;
                    }
                    let basis_start = basis_row * self.columns;
                    for column in pivot..self.columns {
                        self.scratch[column] = F::add(
                            self.scratch[column],
                            F::neg(F::mul(factor, self.basis[basis_start + column])),
                        );
                    }
                }
                let Some(pivot) = self.scratch.iter().position(|&value| value != 0) else {
                    continue;
                };
                let scale = F::inverse(self.scratch[pivot]);
                let basis_start = rank * self.columns;
                for column in pivot..self.columns {
                    self.basis[basis_start + column] = F::mul(scale, self.scratch[column]);
                }
                self.pivots[rank] = pivot;
                rank += 1;
                if rank == self.pivots.len() {
                    return rank;
                }
            }
        }
        rank
    }

    fn rank_matrix_prefix(&mut self, rows: usize) -> usize {
        let mut pivot_row = 0;
        for column in 0..self.columns {
            let Some(pivot) =
                (pivot_row..rows).find(|&row| self.matrix[row * self.columns + column] != 0)
            else {
                continue;
            };
            if pivot != pivot_row {
                for entry in 0..self.columns {
                    self.matrix.swap(
                        pivot_row * self.columns + entry,
                        pivot * self.columns + entry,
                    );
                }
            }
            let scale = F::inverse(self.matrix[pivot_row * self.columns + column]);
            for entry in column..self.columns {
                let index = pivot_row * self.columns + entry;
                self.matrix[index] = F::mul(scale, self.matrix[index]);
            }
            for row in (pivot_row + 1)..rows {
                let factor = self.matrix[row * self.columns + column];
                if factor == 0 {
                    continue;
                }
                for entry in column..self.columns {
                    let index = row * self.columns + entry;
                    let pivot_index = pivot_row * self.columns + entry;
                    self.matrix[index] = F::add(
                        self.matrix[index],
                        F::neg(F::mul(factor, self.matrix[pivot_index])),
                    );
                }
            }
            pivot_row += 1;
            if pivot_row == rows {
                break;
            }
        }
        pivot_row
    }
}

#[derive(Debug, Clone)]
pub struct SemanticRankCore {
    pub rank: usize,
    pub minimum_block_size: usize,
    pub minimum_block_masks: Box<[u64]>,
    pub rank_loss_if_removed: Box<[usize]>,
    pub independent_rows: Box<[u32]>,
}

impl SemanticRankCore {
    /// Independently replay the row basis, block cores, and ablations.
    #[must_use]
    pub fn verify<F: SmallField>(&self, system: &BlockSystem<F>) -> bool {
        if self.independent_rows.len() != self.rank
            || self.minimum_block_masks.is_empty()
            || self.rank_loss_if_removed.len() != system.block_count()
        {
            return false;
        }
        let certificate = match system.select_rows(&self.independent_rows) {
            Ok(value) => value,
            Err(_) => return false,
        };
        let mut workspace = RankWorkspace::<F>::new(system.row_count(), system.columns);
        if workspace.rank_blocks(&certificate, 1) != self.rank {
            return false;
        }
        let full_mask = (1_u64 << system.block_count()) - 1;
        if workspace.rank_blocks(system, full_mask) != self.rank {
            return false;
        }
        for size in 0..self.minimum_block_size {
            let mut found = false;
            for_each_k_subset(system.block_count(), size, |mask| {
                found |= workspace.rank_blocks(system, mask) == self.rank;
            });
            if found {
                return false;
            }
        }
        let mut cursor = 0;
        let mut mismatch = false;
        for_each_k_subset(system.block_count(), self.minimum_block_size, |mask| {
            if workspace.rank_blocks(system, mask) == self.rank {
                mismatch |= self.minimum_block_masks.get(cursor) != Some(&mask);
                cursor += 1;
            }
        });
        if mismatch || cursor != self.minimum_block_masks.len() {
            return false;
        }
        self.rank_loss_if_removed
            .iter()
            .enumerate()
            .all(|(block, &loss)| {
                self.rank - workspace.rank_blocks(system, full_mask ^ (1_u64 << block)) == loss
            })
    }
}

pub fn compile_semantic_rank_core<F: SmallField>(system: &BlockSystem<F>) -> SemanticRankCore {
    assert!(
        system.block_count() <= 20,
        "exact block census is capped at 20"
    );
    assert!(system.block_count() < 64);
    let full_mask = (1_u64 << system.block_count()) - 1;
    let mut workspace = RankWorkspace::<F>::new(system.row_count(), system.columns);
    let rank = workspace.rank_blocks(system, full_mask);
    let mut minimum_block_masks = Vec::new();
    let mut minimum_block_size = 0;
    for size in 0..=system.block_count() {
        for_each_k_subset(system.block_count(), size, |mask| {
            if workspace.rank_blocks(system, mask) == rank {
                minimum_block_masks.push(mask);
            }
        });
        if !minimum_block_masks.is_empty() {
            minimum_block_size = size;
            break;
        }
    }
    let rank_loss_if_removed = (0..system.block_count())
        .map(|block| rank - workspace.rank_blocks(system, full_mask ^ (1_u64 << block)))
        .collect::<Vec<_>>()
        .into_boxed_slice();

    let mut basis = vec![0_u8; system.columns * system.columns];
    let mut occupied = vec![false; system.columns];
    let mut scratch = vec![0_u8; system.columns];
    let mut independent_rows = Vec::with_capacity(rank);
    for row_index in 0..system.row_count() {
        scratch.copy_from_slice(system.row(row_index));
        for pivot in 0..system.columns {
            if scratch[pivot] == 0 || !occupied[pivot] {
                continue;
            }
            let factor = scratch[pivot];
            for column in pivot..system.columns {
                scratch[column] = F::add(
                    scratch[column],
                    F::neg(F::mul(factor, basis[pivot * system.columns + column])),
                );
            }
        }
        let Some(pivot) = scratch.iter().position(|&value| value != 0) else {
            continue;
        };
        let scale = F::inverse(scratch[pivot]);
        for column in pivot..system.columns {
            basis[pivot * system.columns + column] = F::mul(scale, scratch[column]);
        }
        for existing_pivot in 0..system.columns {
            if !occupied[existing_pivot] {
                continue;
            }
            let factor = basis[existing_pivot * system.columns + pivot];
            if factor == 0 {
                continue;
            }
            for column in pivot..system.columns {
                let existing = existing_pivot * system.columns + column;
                basis[existing] = F::add(
                    basis[existing],
                    F::neg(F::mul(factor, basis[pivot * system.columns + column])),
                );
            }
        }
        occupied[pivot] = true;
        independent_rows.push(row_index as u32);
    }
    assert_eq!(independent_rows.len(), rank);
    SemanticRankCore {
        rank,
        minimum_block_size,
        minimum_block_masks: minimum_block_masks.into_boxed_slice(),
        rank_loss_if_removed,
        independent_rows: independent_rows.into_boxed_slice(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[derive(Clone, Copy)]
    struct Gf2;

    impl SmallField for Gf2 {
        const ORDER: u8 = 2;

        fn add(left: u8, right: u8) -> u8 {
            left ^ right
        }

        fn neg(value: u8) -> u8 {
            value
        }

        fn mul(left: u8, right: u8) -> u8 {
            left & right
        }

        fn inverse(value: u8) -> u8 {
            assert_eq!(value, 1);
            1
        }
    }

    #[test]
    fn semantic_rank_core_extracts_and_replays_redundant_blocks() {
        let system = Gf9BlockSystem::try_new(
            3,
            vec![1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1],
            vec![0, 2, 3, 4],
        )
        .unwrap();
        let core = compile_semantic_rank_core(&system);
        assert_eq!(core.rank, 3);
        assert_eq!(&*core.minimum_block_masks, &[0b101]);
        assert_eq!(&*core.rank_loss_if_removed, &[1, 0, 1]);
        assert_eq!(&*core.independent_rows, &[0, 1, 3]);
        assert!(core.verify(&system));

        let mut corrupted = core.clone();
        corrupted.independent_rows[2] = corrupted.independent_rows[1];
        assert!(!corrupted.verify(&system));
        let mut incomplete = core.clone();
        incomplete.minimum_block_masks = Vec::new().into_boxed_slice();
        assert!(!incomplete.verify(&system));
        assert!(system.select_rows(&[system.row_count() as u32]).is_err());
    }

    #[test]
    fn malformed_rank_systems_fail_closed() {
        assert!(Gf9BlockSystem::try_new(0, Vec::new(), vec![0, 0]).is_err());
        assert!(Gf9BlockSystem::try_new(2, vec![0, 0, 0], vec![0, 1]).is_err());
        assert!(Gf9BlockSystem::try_new(1, vec![9], vec![0, 1]).is_err());
        assert!(Gf9BlockSystem::try_new(1, vec![0, 1], vec![0, 1, 1, 2]).is_err());
        assert!(Gf9BlockSystem::try_new(1, vec![0], vec![0; 65]).is_err());
    }

    #[test]
    fn rank_workspace_reuses_storage_across_block_queries() {
        let system = Gf9BlockSystem::try_new(2, vec![1, 0, 0, 1, 1, 1], vec![0, 1, 2, 3]).unwrap();
        let mut workspace = Gf9RankWorkspace::new(3, 2);
        assert_eq!(workspace.rank_blocks(&system, 0b001), 1);
        assert_eq!(workspace.rank_blocks(&system, 0b011), 2);
        assert_eq!(workspace.rank_blocks(&system, 0b100), 1);
        assert_eq!(workspace.rank_blocks(&system, 0b111), 2);
    }

    #[test]
    fn rank_workspace_compresses_overdetermined_operational_state() {
        let dense = Gf9RankWorkspace::new(29, 30);
        let online = Gf9RankWorkspace::new(120, 30);
        assert_eq!(dense.payload_bytes(), 29 * 30);
        assert_eq!(
            online.payload_bytes(),
            30 * 30 + 30 + 30 * std::mem::size_of::<usize>()
        );
        assert!(online.payload_bytes() * 3 < 120 * 30);
    }

    #[test]
    fn compiler_is_field_generic_without_dynamic_dispatch() {
        let system = BlockSystem::<Gf2>::try_new(
            3,
            vec![1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1],
            vec![0, 2, 3, 4],
        )
        .unwrap();
        let core = compile_semantic_rank_core(&system);
        assert_eq!(core.rank, 3);
        assert_eq!(&*core.minimum_block_masks, &[0b101]);
        assert!(core.verify(&system));
    }

    #[test]
    fn gf9_adapter_satisfies_the_finite_field_laws_exhaustively() {
        for left in 0..Gf9::ORDER {
            assert_eq!(Gf9::add(left, 0), left);
            assert_eq!(Gf9::mul(left, 1), left);
            assert_eq!(Gf9::add(left, Gf9::neg(left)), 0);
            if left != 0 {
                assert_eq!(Gf9::mul(left, Gf9::inverse(left)), 1);
            }
            for middle in 0..Gf9::ORDER {
                assert!(Gf9::add(left, middle) < Gf9::ORDER);
                assert!(Gf9::mul(left, middle) < Gf9::ORDER);
                for right in 0..Gf9::ORDER {
                    assert_eq!(
                        Gf9::add(Gf9::add(left, middle), right),
                        Gf9::add(left, Gf9::add(middle, right))
                    );
                    assert_eq!(
                        Gf9::mul(Gf9::mul(left, middle), right),
                        Gf9::mul(left, Gf9::mul(middle, right))
                    );
                    assert_eq!(
                        Gf9::mul(left, Gf9::add(middle, right)),
                        Gf9::add(Gf9::mul(left, middle), Gf9::mul(left, right))
                    );
                }
            }
        }
    }
}
