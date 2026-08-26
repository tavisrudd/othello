use thiserror::Error;

const LANES: usize = 21;
const fn lane_mask(bit: u32) -> u64 {
    let mut mask = 0u64;
    let mut lane = 0;
    while lane < LANES {
        mask |= 1u64 << (3 * lane as u32 + bit);
        lane += 1;
    }
    mask
}
const ONE_MASK: u64 = lane_mask(0);
const TWO_MASK: u64 = lane_mask(1);
const HIGH_MASK: u64 = lane_mask(2);
const VALID_MASK: u64 = ONE_MASK | TWO_MASK;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Error)]
pub enum TernaryError {
    #[error("a ternary digit lies outside 0..=2")]
    InvalidDigit,
    #[error("packed ternary vectors have different widths")]
    WidthMismatch,
}

#[repr(transparent)]
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, Hash)]
pub struct TritBlock(u64);

const _: () = assert!(std::mem::size_of::<TritBlock>() == 8);
const _: () = assert!(std::mem::align_of::<TritBlock>() == 8);

impl TritBlock {
    #[inline(always)]
    pub(crate) const fn from_raw(value: u64) -> Self {
        Self(value)
    }

    #[inline(always)]
    pub(crate) fn add_mod3(self, right: Self) -> Self {
        let raw = self.0 + right.0;
        let threes = (raw & ONE_MASK) & ((raw & TWO_MASK) >> 1);
        let fours = (raw & HIGH_MASK) >> 2;
        Self(raw - 3 * (threes | fours))
    }

    #[inline(always)]
    pub(crate) const fn raw(self) -> u64 {
        self.0
    }
}

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct TritVec {
    blocks: Box<[TritBlock]>,
    width: u32,
}

impl TritVec {
    pub fn from_digits(digits: &[u8]) -> Result<Self, TernaryError> {
        if digits.iter().any(|&digit| digit > 2) {
            return Err(TernaryError::InvalidDigit);
        }
        let mut blocks = vec![TritBlock::default(); digits.len().div_ceil(LANES)];
        for (index, &digit) in digits.iter().enumerate() {
            blocks[index / LANES].0 |= (digit as u64) << (3 * (index % LANES));
        }
        Ok(Self {
            blocks: blocks.into_boxed_slice(),
            width: digits.len() as u32,
        })
    }

    pub fn add_assign(&mut self, right: &Self) -> Result<(), TernaryError> {
        if self.width != right.width {
            return Err(TernaryError::WidthMismatch);
        }
        for (left, right) in self.blocks.iter_mut().zip(right.blocks.iter()) {
            *left = left.add_mod3(*right);
        }
        Ok(())
    }

    #[inline]
    pub(crate) fn blocks(&self) -> &[TritBlock] {
        &self.blocks
    }

    pub fn digits(&self) -> Box<[u8]> {
        (0..self.width as usize)
            .map(|index| ((self.blocks[index / LANES].0 >> (3 * (index % LANES))) & 7) as u8)
            .collect::<Vec<_>>()
            .into_boxed_slice()
    }

    pub fn validate(&self) -> bool {
        self.blocks.iter().all(|block| {
            block.0 & !VALID_MASK == 0 && ((block.0 & ONE_MASK) & ((block.0 & TWO_MASK) >> 1)) == 0
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use proptest::prelude::*;

    #[test]
    fn packed_addition_crosses_block_boundary() {
        let left: Vec<_> = (0..50).map(|index| (index % 3) as u8).collect();
        let right: Vec<_> = (0..50).map(|index| ((2 * index + 1) % 3) as u8).collect();
        let expected: Vec<_> = left.iter().zip(&right).map(|(x, y)| (x + y) % 3).collect();
        let mut packed = TritVec::from_digits(&left).unwrap();
        packed
            .add_assign(&TritVec::from_digits(&right).unwrap())
            .unwrap();
        assert!(packed.validate());
        assert_eq!(&*packed.digits(), &expected);
    }

    proptest! {
        #[test]
        fn packed_addition_matches_scalar(
            pairs in proptest::collection::vec((0u8..3, 0u8..3), 0..160)
        ) {
            let left: Vec<_> = pairs.iter().map(|pair| pair.0).collect();
            let right: Vec<_> = pairs.iter().map(|pair| pair.1).collect();
            let expected: Vec<_> = pairs.iter().map(|pair| (pair.0 + pair.1) % 3).collect();
            let mut packed = TritVec::from_digits(&left).unwrap();
            packed.add_assign(&TritVec::from_digits(&right).unwrap()).unwrap();
            prop_assert!(packed.validate());
            prop_assert_eq!(&*packed.digits(), &expected);
        }
    }
}
