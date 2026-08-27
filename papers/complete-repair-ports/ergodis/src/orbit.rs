use std::hash::{Hash, Hasher};

use rustc_hash::{FxHashMap, FxHasher};
use thiserror::Error;

use crate::packed_ternary::{TernaryError, TritBlock, TritVec};

const NONE: u32 = u32::MAX;

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct OrbitOption {
    pub label: u32,
    pub residue: Box<[u8]>,
    pub totals: Box<[i32]>,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct OrbitSyndromeResult {
    pub choices: Option<Box<[u32]>>,
    pub states_examined: u64,
    pub bound_prunes: u64,
    pub residue_prunes: u64,
    pub memo_prunes: u64,
    pub correlated_suffix_states: u64,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct OrbitMeetResult {
    pub choices: Option<Box<[u32]>>,
    pub left_assignments: u64,
    pub right_assignments: u64,
    pub unique_right_states: u32,
}

impl OrbitMeetResult {
    pub fn feasible(&self) -> bool {
        self.choices.is_some()
    }
}

impl OrbitSyndromeResult {
    pub fn feasible(&self) -> bool {
        self.choices.is_some()
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Error)]
pub enum OrbitError {
    #[error("every orbit needs at least one option")]
    EmptyFamily,
    #[error("orbit option dimensions do not match the targets")]
    DimensionMismatch,
    #[error("orbit search input exceeds its compact representation")]
    TooLarge,
    #[error(transparent)]
    Ternary(#[from] TernaryError),
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct PackedOptionRecord {
    label: u32,
    residue_start: u32,
    totals_start: u32,
    _reserved: u32,
}

const _: () = assert!(std::mem::size_of::<PackedOptionRecord>() == 16);
const _: () = assert!(std::mem::align_of::<PackedOptionRecord>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct FamilyRecord {
    option_start: u32,
    option_len: u32,
    _reserved: [u32; 2],
}

const _: () = assert!(std::mem::size_of::<FamilyRecord>() == 16);
const _: () = assert!(std::mem::align_of::<FamilyRecord>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct DeadRecord {
    key_start: u32,
    next_same_hash: u32,
    family: u32,
    _reserved: u32,
}

const _: () = assert!(std::mem::size_of::<DeadRecord>() == 16);
const _: () = assert!(std::mem::align_of::<DeadRecord>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct ResidueRecord {
    key_start: u32,
    next_same_hash: u32,
    _reserved: [u32; 2],
}

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct MeetRecord {
    key_start: u32,
    choice_start: u32,
    next_same_hash: u32,
    _reserved: u32,
}

const _: () = assert!(std::mem::size_of::<MeetRecord>() == 16);
const _: () = assert!(std::mem::align_of::<MeetRecord>() == 4);

#[derive(Default)]
struct MeetTable {
    heads: FxHashMap<u64, u32>,
    records: Vec<MeetRecord>,
    words: Vec<u64>,
    choices: Vec<u32>,
    key_width: usize,
    choice_width: usize,
}

impl MeetTable {
    fn new(key_width: usize, choice_width: usize, reservation: usize) -> Result<Self, OrbitError> {
        let word_capacity = reservation
            .checked_mul(key_width)
            .ok_or(OrbitError::TooLarge)?;
        let choice_capacity = reservation
            .checked_mul(choice_width)
            .ok_or(OrbitError::TooLarge)?;
        Ok(Self {
            heads: FxHashMap::with_capacity_and_hasher(reservation, Default::default()),
            records: Vec::with_capacity(reservation),
            words: Vec::with_capacity(word_capacity),
            choices: Vec::with_capacity(choice_capacity),
            key_width,
            choice_width,
        })
    }

    fn hash(packed: &[TritBlock], totals: &[i64]) -> u64 {
        let mut hasher = FxHasher::default();
        for block in packed {
            block.raw().hash(&mut hasher);
        }
        totals.hash(&mut hasher);
        hasher.finish()
    }

    fn matches(&self, record: MeetRecord, packed: &[TritBlock], totals: &[i64]) -> bool {
        let start = record.key_start as usize;
        let split = start + packed.len();
        self.words[start..split]
            .iter()
            .zip(packed)
            .all(|(&word, block)| word == block.raw())
            && self.words[split..start + self.key_width]
                .iter()
                .zip(totals)
                .all(|(&word, &total)| word == total as u64)
    }

    fn insert(
        &mut self,
        packed: &[TritBlock],
        totals: &[i64],
        choices: &[u32],
    ) -> Result<(), OrbitError> {
        let hash = Self::hash(packed, totals);
        let mut cursor = self.heads.get(&hash).copied().unwrap_or(NONE);
        while cursor != NONE {
            let record = self.records[cursor as usize];
            if self.matches(record, packed, totals) {
                return Ok(());
            }
            cursor = record.next_same_hash;
        }
        let key_start = u32::try_from(self.words.len()).map_err(|_| OrbitError::TooLarge)?;
        let choice_start = u32::try_from(self.choices.len()).map_err(|_| OrbitError::TooLarge)?;
        let id = u32::try_from(self.records.len()).map_err(|_| OrbitError::TooLarge)?;
        self.words.extend(packed.iter().map(|block| block.raw()));
        self.words.extend(totals.iter().map(|&total| total as u64));
        self.choices.extend_from_slice(choices);
        self.records.push(MeetRecord {
            key_start,
            choice_start,
            next_same_hash: self.heads.get(&hash).copied().unwrap_or(NONE),
            _reserved: 0,
        });
        self.heads.insert(hash, id);
        Ok(())
    }

    fn get(&self, packed: &[TritBlock], totals: &[i64]) -> Option<&[u32]> {
        let hash = Self::hash(packed, totals);
        let mut cursor = self.heads.get(&hash).copied().unwrap_or(NONE);
        while cursor != NONE {
            let record = self.records[cursor as usize];
            if self.matches(record, packed, totals) {
                let start = record.choice_start as usize;
                return Some(&self.choices[start..start + self.choice_width]);
            }
            cursor = record.next_same_hash;
        }
        None
    }
}

const _: () = assert!(std::mem::size_of::<ResidueRecord>() == 16);
const _: () = assert!(std::mem::align_of::<ResidueRecord>() == 4);

#[derive(Default)]
struct ExactResidueSet {
    heads: FxHashMap<u64, u32>,
    records: Vec<ResidueRecord>,
    words: Vec<u64>,
    block_width: usize,
}

impl ExactResidueSet {
    fn new(block_width: usize) -> Self {
        Self {
            block_width,
            ..Self::default()
        }
    }

    fn hash(blocks: &[TritBlock]) -> u64 {
        let mut hasher = FxHasher::default();
        for block in blocks {
            block.raw().hash(&mut hasher);
        }
        hasher.finish()
    }

    fn contains(&self, blocks: &[TritBlock]) -> bool {
        let hash = Self::hash(blocks);
        let mut cursor = self.heads.get(&hash).copied().unwrap_or(NONE);
        while cursor != NONE {
            let record = self.records[cursor as usize];
            let start = record.key_start as usize;
            if self.words[start..start + self.block_width]
                .iter()
                .zip(blocks)
                .all(|(&word, block)| word == block.raw())
            {
                return true;
            }
            cursor = record.next_same_hash;
        }
        false
    }

    fn insert(&mut self, blocks: &[TritBlock]) -> Result<bool, OrbitError> {
        if self.contains(blocks) {
            return Ok(false);
        }
        let key_start = u32::try_from(self.words.len()).map_err(|_| OrbitError::TooLarge)?;
        let id = u32::try_from(self.records.len()).map_err(|_| OrbitError::TooLarge)?;
        let hash = Self::hash(blocks);
        let next_same_hash = self.heads.get(&hash).copied().unwrap_or(NONE);
        self.words.extend(blocks.iter().map(|block| block.raw()));
        self.records.push(ResidueRecord {
            key_start,
            next_same_hash,
            _reserved: [0; 2],
        });
        self.heads.insert(hash, id);
        Ok(true)
    }

    fn blocks(&self, record: ResidueRecord) -> &[u64] {
        let start = record.key_start as usize;
        &self.words[start..start + self.block_width]
    }
}

#[derive(Default)]
struct DeadMemo {
    heads: FxHashMap<u64, u32>,
    records: Vec<DeadRecord>,
    words: Vec<u64>,
}

impl DeadMemo {
    fn hash(family: u32, packed: &[TritBlock], totals: &[i64]) -> u64 {
        let mut hasher = FxHasher::default();
        family.hash(&mut hasher);
        for block in packed {
            block.raw().hash(&mut hasher);
        }
        totals.hash(&mut hasher);
        hasher.finish()
    }

    fn matches(&self, record: DeadRecord, packed: &[TritBlock], totals: &[i64]) -> bool {
        let start = record.key_start as usize;
        let split = start + packed.len();
        self.words[start..split]
            .iter()
            .zip(packed)
            .all(|(&word, block)| word == block.raw())
            && self.words[split..split + totals.len()]
                .iter()
                .zip(totals)
                .all(|(&word, &total)| word == total as u64)
    }

    fn contains(&self, family: u32, packed: &[TritBlock], totals: &[i64]) -> bool {
        let hash = Self::hash(family, packed, totals);
        let mut cursor = self.heads.get(&hash).copied().unwrap_or(NONE);
        while cursor != NONE {
            let record = self.records[cursor as usize];
            if record.family == family && self.matches(record, packed, totals) {
                return true;
            }
            cursor = record.next_same_hash;
        }
        false
    }

    fn insert(
        &mut self,
        family: u32,
        packed: &[TritBlock],
        totals: &[i64],
    ) -> Result<(), OrbitError> {
        let key_start = u32::try_from(self.words.len()).map_err(|_| OrbitError::TooLarge)?;
        let id = u32::try_from(self.records.len()).map_err(|_| OrbitError::TooLarge)?;
        let hash = Self::hash(family, packed, totals);
        let next_same_hash = self.heads.get(&hash).copied().unwrap_or(NONE);
        self.words.extend(packed.iter().map(|block| block.raw()));
        self.words.extend(totals.iter().map(|&total| total as u64));
        self.records.push(DeadRecord {
            key_start,
            next_same_hash,
            family,
            _reserved: 0,
        });
        self.heads.insert(hash, id);
        Ok(())
    }
}

fn correlated_suffix_sets(
    families: &[FamilyRecord],
    options: &[PackedOptionRecord],
    residues: &[TritBlock],
    block_width: usize,
    max_states_per_suffix: usize,
) -> Result<Option<Vec<ExactResidueSet>>, OrbitError> {
    let mut last = ExactResidueSet::new(block_width);
    last.insert(&vec![TritBlock::default(); block_width])?;
    let mut reverse = vec![last];
    let mut scratch = vec![TritBlock::default(); block_width];
    for family in families.iter().rev().copied() {
        let tail = reverse.last().expect("the zero suffix is present");
        let mut current = ExactResidueSet::new(block_width);
        let option_start = family.option_start as usize;
        let option_end = option_start + family.option_len as usize;
        for option in &options[option_start..option_end] {
            let residue_start = option.residue_start as usize;
            let option_blocks = &residues[residue_start..residue_start + block_width];
            for &record in &tail.records {
                for ((value, &left), &right) in scratch
                    .iter_mut()
                    .zip(option_blocks)
                    .zip(tail.blocks(record))
                {
                    *value = left.add_mod3(TritBlock::from_raw(right));
                }
                current.insert(&scratch)?;
                if current.records.len() > max_states_per_suffix {
                    return Ok(None);
                }
            }
        }
        reverse.push(current);
    }
    reverse.reverse();
    Ok(Some(reverse))
}

#[allow(clippy::too_many_arguments)]
fn enumerate_right(
    family_index: usize,
    end: usize,
    families: &[FamilyRecord],
    options: &[PackedOptionRecord],
    residues: &[TritBlock],
    option_totals: &[i64],
    residue_blocks: usize,
    total_width: usize,
    packed: &mut [TritBlock],
    totals: &mut [i64],
    choices: &mut Vec<u32>,
    table: &mut MeetTable,
    assignments: &mut u64,
) -> Result<(), OrbitError> {
    if family_index == end {
        *assignments = assignments.checked_add(1).ok_or(OrbitError::TooLarge)?;
        return table.insert(packed, totals, choices);
    }
    let family = families[family_index];
    let start = family.option_start as usize;
    let option_end = start + family.option_len as usize;
    for option in &options[start..option_end] {
        let residue_start = option.residue_start as usize;
        let total_start = option.totals_start as usize;
        for (left, &right) in packed
            .iter_mut()
            .zip(&residues[residue_start..residue_start + residue_blocks])
        {
            *left = left.add_mod3(right);
        }
        for (left, &right) in totals
            .iter_mut()
            .zip(&option_totals[total_start..total_start + total_width])
        {
            *left += right;
        }
        choices.push(option.label);
        enumerate_right(
            family_index + 1,
            end,
            families,
            options,
            residues,
            option_totals,
            residue_blocks,
            total_width,
            packed,
            totals,
            choices,
            table,
            assignments,
        )?;
        choices.pop();
        for (left, &right) in totals
            .iter_mut()
            .zip(&option_totals[total_start..total_start + total_width])
        {
            *left -= right;
        }
        for (left, &right) in packed
            .iter_mut()
            .zip(&residues[residue_start..residue_start + residue_blocks])
        {
            *left = left.add_mod3(right).add_mod3(right);
        }
    }
    Ok(())
}

#[allow(clippy::too_many_arguments)]
fn search_left(
    family_index: usize,
    end: usize,
    families: &[FamilyRecord],
    options: &[PackedOptionRecord],
    residues: &[TritBlock],
    option_totals: &[i64],
    residue_blocks: usize,
    total_width: usize,
    target_packed: &[TritBlock],
    target_totals: &[i64],
    packed: &mut [TritBlock],
    totals: &mut [i64],
    needed_packed: &mut [TritBlock],
    needed_totals: &mut [i64],
    choices: &mut Vec<u32>,
    table: &MeetTable,
    assignments: &mut u64,
    answer: &mut Vec<u32>,
) -> Result<bool, OrbitError> {
    if family_index == end {
        *assignments = assignments.checked_add(1).ok_or(OrbitError::TooLarge)?;
        for ((needed, &target), &current) in needed_packed
            .iter_mut()
            .zip(target_packed)
            .zip(packed.iter())
        {
            *needed = target.add_mod3(current).add_mod3(current);
        }
        for ((needed, &target), &current) in needed_totals
            .iter_mut()
            .zip(target_totals)
            .zip(totals.iter())
        {
            *needed = target - current;
        }
        if let Some(right) = table.get(needed_packed, needed_totals) {
            answer.extend_from_slice(choices);
            answer.extend_from_slice(right);
            return Ok(true);
        }
        return Ok(false);
    }
    let family = families[family_index];
    let start = family.option_start as usize;
    let option_end = start + family.option_len as usize;
    for option in &options[start..option_end] {
        let residue_start = option.residue_start as usize;
        let total_start = option.totals_start as usize;
        for (left, &right) in packed
            .iter_mut()
            .zip(&residues[residue_start..residue_start + residue_blocks])
        {
            *left = left.add_mod3(right);
        }
        for (left, &right) in totals
            .iter_mut()
            .zip(&option_totals[total_start..total_start + total_width])
        {
            *left += right;
        }
        choices.push(option.label);
        if search_left(
            family_index + 1,
            end,
            families,
            options,
            residues,
            option_totals,
            residue_blocks,
            total_width,
            target_packed,
            target_totals,
            packed,
            totals,
            needed_packed,
            needed_totals,
            choices,
            table,
            assignments,
            answer,
        )? {
            return Ok(true);
        }
        choices.pop();
        for (left, &right) in totals
            .iter_mut()
            .zip(&option_totals[total_start..total_start + total_width])
        {
            *left -= right;
        }
        for (left, &right) in packed
            .iter_mut()
            .zip(&residues[residue_start..residue_start + residue_blocks])
        {
            *left = left.add_mod3(right).add_mod3(right);
        }
    }
    Ok(false)
}

struct Search<'a> {
    families: &'a [FamilyRecord],
    options: &'a [PackedOptionRecord],
    residues: &'a [TritBlock],
    option_totals: &'a [i64],
    residue_blocks: usize,
    total_width: usize,
    target_residue: &'a [u8],
    target_packed: &'a [TritBlock],
    target_totals: &'a [i64],
    suffix_min: &'a [i64],
    suffix_max: &'a [i64],
    suffix_residues: &'a [u8],
    correlated_suffixes: &'a [ExactResidueSet],
    packed: Vec<TritBlock>,
    needed: Vec<TritBlock>,
    totals: Vec<i64>,
    choices: Vec<u32>,
    dead: DeadMemo,
    states_examined: u64,
    bound_prunes: u64,
    residue_prunes: u64,
    memo_prunes: u64,
}

#[repr(C)]
#[derive(Clone, Copy)]
struct SearchFrame {
    family: u32,
    next_option: u32,
    end_option: u32,
    incoming_option: u32,
}

const _: () = assert!(std::mem::size_of::<SearchFrame>() == 16);
const _: () = assert!(std::mem::align_of::<SearchFrame>() == 4);
const NO_OPTION: u32 = u32::MAX;

enum Entry {
    Descend,
    Reject,
    Accept,
}

impl Search<'_> {
    fn enter<const CORRELATED: bool>(&mut self, family_index: usize) -> Entry {
        self.states_examined += 1;
        let suffix_total = family_index * self.total_width;
        for coordinate in 0..self.total_width {
            let current = self.totals[coordinate];
            let target = self.target_totals[coordinate];
            if current + self.suffix_min[suffix_total + coordinate] > target
                || current + self.suffix_max[suffix_total + coordinate] < target
            {
                self.bound_prunes += 1;
                return Entry::Reject;
            }
        }
        if CORRELATED {
            for ((needed, &target), &current) in self
                .needed
                .iter_mut()
                .zip(self.target_packed)
                .zip(&self.packed)
            {
                *needed = target.add_mod3(current).add_mod3(current);
            }
            if !self.correlated_suffixes[family_index].contains(&self.needed) {
                self.residue_prunes += 1;
                return Entry::Reject;
            }
        } else {
            let suffix_residue = family_index * self.target_residue.len();
            for coordinate in 0..self.target_residue.len() {
                let block = self.packed[coordinate / 21].raw();
                let current = ((block >> (3 * (coordinate % 21))) & 7) as u8;
                let needed = (self.target_residue[coordinate] + 3 - current) % 3;
                if self.suffix_residues[suffix_residue + coordinate] & (1 << needed) == 0 {
                    self.residue_prunes += 1;
                    return Entry::Reject;
                }
            }
        }
        let family_u32 = family_index as u32;
        if self.dead.contains(family_u32, &self.packed, &self.totals) {
            self.memo_prunes += 1;
            return Entry::Reject;
        }
        if family_index == self.families.len() {
            return if self
                .packed
                .iter()
                .zip(self.target_packed)
                .all(|(left, right)| left.raw() == right.raw())
                && self.totals == self.target_totals
            {
                Entry::Accept
            } else {
                Entry::Reject
            };
        }
        Entry::Descend
    }

    fn apply(&mut self, option_index: usize) {
        let option = self.options[option_index];
        let residue_start = option.residue_start as usize;
        for (left, &right) in self
            .packed
            .iter_mut()
            .zip(&self.residues[residue_start..residue_start + self.residue_blocks])
        {
            *left = left.add_mod3(right);
        }
        let totals_start = option.totals_start as usize;
        for (left, &right) in self
            .totals
            .iter_mut()
            .zip(&self.option_totals[totals_start..totals_start + self.total_width])
        {
            *left += right;
        }
        self.choices.push(option.label);
    }

    fn undo(&mut self, option_index: usize) {
        let option = self.options[option_index];
        self.choices.pop();
        let totals_start = option.totals_start as usize;
        for (left, &right) in self
            .totals
            .iter_mut()
            .zip(&self.option_totals[totals_start..totals_start + self.total_width])
        {
            *left -= right;
        }
        let residue_start = option.residue_start as usize;
        for (left, &right) in self
            .packed
            .iter_mut()
            .zip(&self.residues[residue_start..residue_start + self.residue_blocks])
        {
            *left = left.add_mod3(right).add_mod3(right);
        }
    }

    fn visit_recursive<const CORRELATED: bool>(
        &mut self,
        family_index: usize,
    ) -> Result<bool, OrbitError> {
        self.states_examined += 1;
        let suffix_total = family_index * self.total_width;
        for coordinate in 0..self.total_width {
            let current = self.totals[coordinate];
            let target = self.target_totals[coordinate];
            if current + self.suffix_min[suffix_total + coordinate] > target
                || current + self.suffix_max[suffix_total + coordinate] < target
            {
                self.bound_prunes += 1;
                return Ok(false);
            }
        }
        if CORRELATED {
            for ((needed, &target), &current) in self
                .needed
                .iter_mut()
                .zip(self.target_packed)
                .zip(&self.packed)
            {
                *needed = target.add_mod3(current).add_mod3(current);
            }
            if !self.correlated_suffixes[family_index].contains(&self.needed) {
                self.residue_prunes += 1;
                return Ok(false);
            }
        } else {
            let suffix_residue = family_index * self.target_residue.len();
            for coordinate in 0..self.target_residue.len() {
                let block = self.packed[coordinate / 21].raw();
                let current = ((block >> (3 * (coordinate % 21))) & 7) as u8;
                let needed = (self.target_residue[coordinate] + 3 - current) % 3;
                if self.suffix_residues[suffix_residue + coordinate] & (1 << needed) == 0 {
                    self.residue_prunes += 1;
                    return Ok(false);
                }
            }
        }
        let family_u32 = family_index as u32;
        if self.dead.contains(family_u32, &self.packed, &self.totals) {
            self.memo_prunes += 1;
            return Ok(false);
        }
        if family_index == self.families.len() {
            return Ok(self
                .packed
                .iter()
                .zip(self.target_packed)
                .all(|(left, right)| left.raw() == right.raw())
                && self.totals == self.target_totals);
        }
        let family = self.families[family_index];
        let start = family.option_start as usize;
        let end = start + family.option_len as usize;
        for option_index in start..end {
            let option = self.options[option_index];
            let residue_start = option.residue_start as usize;
            for (left, &right) in self
                .packed
                .iter_mut()
                .zip(&self.residues[residue_start..residue_start + self.residue_blocks])
            {
                *left = left.add_mod3(right);
            }
            let totals_start = option.totals_start as usize;
            for (left, &right) in self
                .totals
                .iter_mut()
                .zip(&self.option_totals[totals_start..totals_start + self.total_width])
            {
                *left += right;
            }
            self.choices.push(option.label);
            if self.visit_recursive::<CORRELATED>(family_index + 1)? {
                return Ok(true);
            }
            self.choices.pop();
            for (left, &right) in self
                .totals
                .iter_mut()
                .zip(&self.option_totals[totals_start..totals_start + self.total_width])
            {
                *left -= right;
            }
            for (left, &right) in self
                .packed
                .iter_mut()
                .zip(&self.residues[residue_start..residue_start + self.residue_blocks])
            {
                *left = left.add_mod3(right).add_mod3(right);
            }
        }
        self.dead.insert(family_u32, &self.packed, &self.totals)?;
        Ok(false)
    }

    #[cold]
    #[inline(never)]
    fn run<const CORRELATED: bool>(&mut self) -> Result<bool, OrbitError> {
        let mut stack = Vec::with_capacity(self.families.len() + 1);
        stack.push(SearchFrame {
            family: 0,
            next_option: NO_OPTION,
            end_option: 0,
            incoming_option: NO_OPTION,
        });
        while let Some(frame) = stack.last_mut() {
            let family_index = frame.family as usize;
            if frame.next_option == NO_OPTION {
                match self.enter::<CORRELATED>(family_index) {
                    Entry::Accept => return Ok(true),
                    Entry::Reject => {
                        let incoming = frame.incoming_option;
                        stack.pop();
                        if incoming != NO_OPTION {
                            self.undo(incoming as usize);
                        }
                        continue;
                    }
                    Entry::Descend => {
                        let family = self.families[family_index];
                        frame.next_option = family.option_start;
                        frame.end_option = family.option_start + family.option_len;
                    }
                }
            }
            if frame.next_option == frame.end_option {
                self.dead.insert(frame.family, &self.packed, &self.totals)?;
                let incoming = frame.incoming_option;
                stack.pop();
                if incoming != NO_OPTION {
                    self.undo(incoming as usize);
                }
                continue;
            }
            let option = frame.next_option;
            frame.next_option += 1;
            let next_family = frame.family + 1;
            self.apply(option as usize);
            stack.push(SearchFrame {
                family: next_family,
                next_option: NO_OPTION,
                end_option: 0,
                incoming_option: option,
            });
        }
        Ok(false)
    }
}

fn orbit_search_impl(
    option_families: &[Vec<OrbitOption>],
    target_residue: &[u8],
    target_totals: &[i32],
    max_correlated_states: Option<usize>,
) -> Result<OrbitSyndromeResult, OrbitError> {
    if option_families.iter().any(Vec::is_empty) {
        return Err(OrbitError::EmptyFamily);
    }
    let family_count = option_families.len();
    u32::try_from(family_count).map_err(|_| OrbitError::TooLarge)?;
    let width = target_residue.len();
    let total_width = target_totals.len();
    let target_digits: Vec<_> = target_residue.iter().map(|value| value % 3).collect();
    let target = TritVec::from_digits(&target_digits)?;
    let residue_blocks = target.blocks().len();

    let mut families = Vec::with_capacity(family_count);
    let mut options = Vec::new();
    let mut residues = Vec::new();
    let mut option_totals = Vec::new();
    for family in option_families {
        let option_start = u32::try_from(options.len()).map_err(|_| OrbitError::TooLarge)?;
        for option in family {
            if option.residue.len() != width || option.totals.len() != total_width {
                return Err(OrbitError::DimensionMismatch);
            }
            let digits: Vec<_> = option.residue.iter().map(|value| value % 3).collect();
            let packed = TritVec::from_digits(&digits)?;
            let residue_start = u32::try_from(residues.len()).map_err(|_| OrbitError::TooLarge)?;
            let totals_start =
                u32::try_from(option_totals.len()).map_err(|_| OrbitError::TooLarge)?;
            residues.extend_from_slice(packed.blocks());
            option_totals.extend(option.totals.iter().map(|&value| i64::from(value)));
            options.push(PackedOptionRecord {
                label: option.label,
                residue_start,
                totals_start,
                _reserved: 0,
            });
        }
        families.push(FamilyRecord {
            option_start,
            option_len: u32::try_from(family.len()).map_err(|_| OrbitError::TooLarge)?,
            _reserved: [0; 2],
        });
    }

    let stride = total_width;
    let mut suffix_min = vec![0i64; (family_count + 1) * stride];
    let mut suffix_max = vec![0i64; (family_count + 1) * stride];
    let mut suffix_residues = vec![1u8; (family_count + 1) * width];
    for family_index in (0..family_count).rev() {
        let family = families[family_index];
        let start = family.option_start as usize;
        let end = start + family.option_len as usize;
        for coordinate in 0..total_width {
            let (minimum, maximum) = options[start..end]
                .iter()
                .map(|option| option_totals[option.totals_start as usize + coordinate])
                .fold((i64::MAX, i64::MIN), |(lo, hi), value| {
                    (lo.min(value), hi.max(value))
                });
            suffix_min[family_index * stride + coordinate] =
                minimum + suffix_min[(family_index + 1) * stride + coordinate];
            suffix_max[family_index * stride + coordinate] =
                maximum + suffix_max[(family_index + 1) * stride + coordinate];
        }
        for coordinate in 0..width {
            let mut mask = 0u8;
            let tail = suffix_residues[(family_index + 1) * width + coordinate];
            for option in &options[start..end] {
                let residue_start = option.residue_start as usize;
                let digit = ((residues[residue_start + coordinate / 21].raw()
                    >> (3 * (coordinate % 21)))
                    & 7) as u8;
                for tail_digit in 0..3 {
                    if tail & (1 << tail_digit) != 0 {
                        mask |= 1 << ((digit + tail_digit) % 3);
                    }
                }
            }
            suffix_residues[family_index * width + coordinate] = mask;
        }
    }

    let correlated_suffixes = if let Some(max_states) = max_correlated_states {
        correlated_suffix_sets(&families, &options, &residues, residue_blocks, max_states)?
            .unwrap_or_default()
    } else {
        Vec::new()
    };
    let correlated_suffix_states = correlated_suffixes
        .iter()
        .try_fold(0u64, |sum, set| sum.checked_add(set.records.len() as u64))
        .ok_or(OrbitError::TooLarge)?;

    let target_totals_i64: Vec<_> = target_totals
        .iter()
        .map(|&value| i64::from(value))
        .collect();
    let mut search = Search {
        families: &families,
        options: &options,
        residues: &residues,
        option_totals: &option_totals,
        residue_blocks,
        total_width,
        target_residue: &target_digits,
        target_packed: target.blocks(),
        target_totals: &target_totals_i64,
        suffix_min: &suffix_min,
        suffix_max: &suffix_max,
        suffix_residues: &suffix_residues,
        correlated_suffixes: &correlated_suffixes,
        packed: vec![TritBlock::default(); residue_blocks],
        needed: vec![TritBlock::default(); residue_blocks],
        totals: vec![0; total_width],
        choices: Vec::with_capacity(family_count),
        dead: DeadMemo::default(),
        states_examined: 0,
        bound_prunes: 0,
        residue_prunes: 0,
        memo_prunes: 0,
    };
    // The recursive kernel is measurably faster at ordinary depths. Reserve the
    // explicit stack for inputs large enough that call-stack growth, rather
    // than instruction count, is the binding concern.
    let iterative = family_count > 32_768;
    let feasible = if correlated_suffixes.is_empty() && iterative {
        search.run::<false>()?
    } else if correlated_suffixes.is_empty() {
        search.visit_recursive::<false>(0)?
    } else if iterative {
        search.run::<true>()?
    } else {
        search.visit_recursive::<true>(0)?
    };
    Ok(OrbitSyndromeResult {
        choices: feasible.then(|| search.choices.into_boxed_slice()),
        states_examined: search.states_examined,
        bound_prunes: search.bound_prunes,
        residue_prunes: search.residue_prunes,
        memo_prunes: search.memo_prunes,
        correlated_suffix_states,
    })
}

pub fn ternary_orbit_syndrome_search(
    option_families: &[Vec<OrbitOption>],
    target_residue: &[u8],
    target_totals: &[i32],
) -> Result<OrbitSyndromeResult, OrbitError> {
    orbit_search_impl(option_families, target_residue, target_totals, None)
}

pub fn ternary_orbit_syndrome_search_correlated(
    option_families: &[Vec<OrbitOption>],
    target_residue: &[u8],
    target_totals: &[i32],
    max_states_per_suffix: usize,
) -> Result<OrbitSyndromeResult, OrbitError> {
    orbit_search_impl(
        option_families,
        target_residue,
        target_totals,
        Some(max_states_per_suffix),
    )
}

fn orbit_syndrome_meet_in_middle_impl(
    option_families: &[Vec<OrbitOption>],
    target_residue: &[u8],
    target_totals: &[i32],
    reserve: bool,
    balance_products: bool,
) -> Result<OrbitMeetResult, OrbitError> {
    if option_families.iter().any(Vec::is_empty) {
        return Err(OrbitError::EmptyFamily);
    }
    u32::try_from(option_families.len()).map_err(|_| OrbitError::TooLarge)?;
    let width = target_residue.len();
    let total_width = target_totals.len();
    let target_digits: Vec<_> = target_residue.iter().map(|value| value % 3).collect();
    let target = TritVec::from_digits(&target_digits)?;
    let residue_blocks = target.blocks().len();
    let target_totals_i64: Vec<_> = target_totals
        .iter()
        .map(|&value| i64::from(value))
        .collect();

    let mut families = Vec::with_capacity(option_families.len());
    let mut options = Vec::new();
    let mut residues = Vec::new();
    let mut option_totals = Vec::new();
    for family in option_families {
        let option_start = u32::try_from(options.len()).map_err(|_| OrbitError::TooLarge)?;
        for option in family {
            if option.residue.len() != width || option.totals.len() != total_width {
                return Err(OrbitError::DimensionMismatch);
            }
            let digits: Vec<_> = option.residue.iter().map(|value| value % 3).collect();
            let packed = TritVec::from_digits(&digits)?;
            let residue_start = u32::try_from(residues.len()).map_err(|_| OrbitError::TooLarge)?;
            let totals_start =
                u32::try_from(option_totals.len()).map_err(|_| OrbitError::TooLarge)?;
            residues.extend_from_slice(packed.blocks());
            option_totals.extend(option.totals.iter().map(|&value| i64::from(value)));
            options.push(PackedOptionRecord {
                label: option.label,
                residue_start,
                totals_start,
                _reserved: 0,
            });
        }
        families.push(FamilyRecord {
            option_start,
            option_len: u32::try_from(family.len()).map_err(|_| OrbitError::TooLarge)?,
            _reserved: [0; 2],
        });
    }

    let split = if balance_products {
        balanced_product_split(&families)
    } else {
        families.len() / 2
    };
    let right_width = families.len() - split;
    let right_bound = families[split..]
        .iter()
        .try_fold(1usize, |product, family| {
            product.checked_mul(family.option_len as usize)
        });
    let reservation = if reserve {
        right_bound.ok_or(OrbitError::TooLarge)?.min(1 << 16)
    } else {
        0
    };
    let mut table = MeetTable::new(residue_blocks + total_width, right_width, reservation)?;
    let mut right_packed = vec![TritBlock::default(); residue_blocks];
    let mut right_totals = vec![0i64; total_width];
    let mut right_choices = Vec::with_capacity(right_width);
    let mut right_assignments = 0u64;
    enumerate_right(
        split,
        families.len(),
        &families,
        &options,
        &residues,
        &option_totals,
        residue_blocks,
        total_width,
        &mut right_packed,
        &mut right_totals,
        &mut right_choices,
        &mut table,
        &mut right_assignments,
    )?;

    let unique_right_states =
        u32::try_from(table.records.len()).map_err(|_| OrbitError::TooLarge)?;
    let mut left_packed = vec![TritBlock::default(); residue_blocks];
    let mut left_totals = vec![0i64; total_width];
    let mut needed_packed = vec![TritBlock::default(); residue_blocks];
    let mut needed_totals = vec![0i64; total_width];
    let mut left_choices = Vec::with_capacity(split);
    let mut answer = Vec::with_capacity(families.len());
    let mut left_assignments = 0u64;
    let feasible = search_left(
        0,
        split,
        &families,
        &options,
        &residues,
        &option_totals,
        residue_blocks,
        total_width,
        target.blocks(),
        &target_totals_i64,
        &mut left_packed,
        &mut left_totals,
        &mut needed_packed,
        &mut needed_totals,
        &mut left_choices,
        &table,
        &mut left_assignments,
        &mut answer,
    )?;
    Ok(OrbitMeetResult {
        choices: feasible.then(|| answer.into_boxed_slice()),
        left_assignments,
        right_assignments,
        unique_right_states,
    })
}

fn balanced_product_split(families: &[FamilyRecord]) -> usize {
    let mut suffix_products = vec![1u128; families.len() + 1];
    for index in (0..families.len()).rev() {
        suffix_products[index] =
            suffix_products[index + 1].saturating_mul(u128::from(families[index].option_len));
    }
    let mut left_product = 1u128;
    let mut best = (u128::MAX, u128::MAX, 0usize);
    for (split, &right_product) in suffix_products.iter().enumerate() {
        let candidate = (
            left_product.saturating_add(right_product),
            right_product,
            split,
        );
        best = best.min(candidate);
        if let Some(family) = families.get(split) {
            left_product = left_product.saturating_mul(u128::from(family.option_len));
        }
    }
    best.2
}

pub fn ternary_orbit_syndrome_meet_in_middle(
    option_families: &[Vec<OrbitOption>],
    target_residue: &[u8],
    target_totals: &[i32],
) -> Result<OrbitMeetResult, OrbitError> {
    orbit_syndrome_meet_in_middle_impl(option_families, target_residue, target_totals, true, true)
}

#[doc(hidden)]
pub fn ternary_orbit_syndrome_meet_in_middle_unreserved(
    option_families: &[Vec<OrbitOption>],
    target_residue: &[u8],
    target_totals: &[i32],
) -> Result<OrbitMeetResult, OrbitError> {
    orbit_syndrome_meet_in_middle_impl(option_families, target_residue, target_totals, false, true)
}

#[doc(hidden)]
pub fn ternary_orbit_syndrome_meet_in_middle_count_split(
    option_families: &[Vec<OrbitOption>],
    target_residue: &[u8],
    target_totals: &[i32],
) -> Result<OrbitMeetResult, OrbitError> {
    orbit_syndrome_meet_in_middle_impl(option_families, target_residue, target_totals, true, false)
}

#[cfg(test)]
mod tests {
    use super::*;
    use proptest::prelude::*;

    #[test]
    fn finds_assignment_across_packed_block_boundary() {
        let first = OrbitOption {
            label: 7,
            residue: vec![1; 25].into_boxed_slice(),
            totals: vec![2].into_boxed_slice(),
        };
        let second = OrbitOption {
            label: 9,
            residue: vec![2; 25].into_boxed_slice(),
            totals: vec![3].into_boxed_slice(),
        };
        let result =
            ternary_orbit_syndrome_search(&[vec![first], vec![second]], &[0; 25], &[5]).unwrap();
        assert_eq!(result.choices.as_deref(), Some(&[7, 9][..]));
    }

    #[test]
    fn product_balanced_split_accounts_for_unequal_families() {
        let family = |option_len| FamilyRecord {
            option_start: 0,
            option_len,
            _reserved: [0; 2],
        };
        assert_eq!(
            balanced_product_split(&[family(2), family(2), family(64)]),
            2
        );
        assert_eq!(
            balanced_product_split(&[family(2), family(16), family(2)]),
            2
        );
    }

    #[test]
    fn product_balanced_split_preserves_first_witness() {
        let sizes = [2usize, 5, 2];
        let mut label = 0u32;
        let families: Vec<Vec<OrbitOption>> = sizes
            .into_iter()
            .map(|size| {
                (0..size)
                    .map(|option| {
                        let answer = OrbitOption {
                            label,
                            residue: vec![(label % 3) as u8, (option % 3) as u8].into_boxed_slice(),
                            totals: Box::new([]),
                        };
                        label += 1;
                        answer
                    })
                    .collect()
            })
            .collect();
        for left in 0..3 {
            for right in 0..3 {
                let target = [left, right];
                let expected = ternary_orbit_syndrome_search(&families, &target, &[]).unwrap();
                let answer =
                    ternary_orbit_syndrome_meet_in_middle(&families, &target, &[]).unwrap();
                assert_eq!(answer.choices, expected.choices);
            }
        }
    }

    proptest! {
        #[test]
        fn packed_search_matches_four_choice_brute_force(
            width in 0usize..50,
            seed in any::<u64>(),
            target_total in -2i32..7,
        ) {
            let mut state = seed;
            let mut digit = || {
                state = state.wrapping_mul(6_364_136_223_846_793_005).wrapping_add(1);
                ((state >> 32) % 3) as u8
            };
            let residues: Vec<Vec<u8>> = (0..4)
                .map(|_| (0..width).map(|_| digit()).collect())
                .collect();
            let totals = [
                (seed % 4) as i32 - 1,
                ((seed >> 4) % 4) as i32 - 1,
                ((seed >> 8) % 4) as i32 - 1,
                ((seed >> 12) % 4) as i32 - 1,
            ];
            let target: Vec<u8> = (0..width).map(|_| digit()).collect();
            let families = vec![
                vec![
                    OrbitOption { label: 0, residue: residues[0].clone().into(), totals: vec![totals[0]].into() },
                    OrbitOption { label: 1, residue: residues[1].clone().into(), totals: vec![totals[1]].into() },
                ],
                vec![
                    OrbitOption { label: 2, residue: residues[2].clone().into(), totals: vec![totals[2]].into() },
                    OrbitOption { label: 3, residue: residues[3].clone().into(), totals: vec![totals[3]].into() },
                ],
            ];
            let expected = [(0usize, 2usize), (0, 3), (1, 2), (1, 3)]
                .iter()
                .find(|&&(left, right)| {
                    totals[left] + totals[right] == target_total
                        && (0..width).all(|coordinate| {
                            (residues[left][coordinate] + residues[right][coordinate]) % 3
                                == target[coordinate]
                        })
                })
                .map(|&(left, right)| [left as u32, right as u32]);
            let answer = ternary_orbit_syndrome_search(&families, &target, &[target_total]).unwrap();
            let correlated = ternary_orbit_syndrome_search_correlated(
                &families,
                &target,
                &[target_total],
                8,
            )
            .unwrap();
            let meet = ternary_orbit_syndrome_meet_in_middle(
                &families,
                &target,
                &[target_total],
            )
            .unwrap();
            prop_assert_eq!(answer.feasible(), expected.is_some());
            prop_assert_eq!(&correlated.choices, &answer.choices);
            prop_assert_eq!(&meet.choices, &answer.choices);
            prop_assert!(correlated.correlated_suffix_states > 0);
            if let Some(expected) = expected {
                prop_assert_eq!(answer.choices.as_deref(), Some(&expected[..]));
            }
        }
    }
}
