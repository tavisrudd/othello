use thiserror::Error;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Error)]
pub enum BitSetError {
    #[error("bit index is outside the bitset")]
    OutOfRange,
    #[error("bitsets have different widths")]
    WidthMismatch,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct BitSet {
    words: Box<[u64]>,
    width: u32,
}

impl BitSet {
    pub fn zeros(width: usize) -> Self {
        Self {
            words: vec![0; width.div_ceil(64)].into_boxed_slice(),
            width: u32::try_from(width).expect("bitset width exceeds u32"),
        }
    }

    pub fn from_indices(
        width: usize,
        indices: impl IntoIterator<Item = usize>,
    ) -> Result<Self, BitSetError> {
        let mut result = Self::zeros(width);
        for index in indices {
            if index >= width {
                return Err(BitSetError::OutOfRange);
            }
            result.words[index / 64] |= 1u64 << (index % 64);
        }
        Ok(result)
    }

    #[inline]
    pub fn intersection_count(&self, right: &Self) -> Result<u32, BitSetError> {
        if self.width != right.width {
            return Err(BitSetError::WidthMismatch);
        }
        Ok(self
            .words
            .iter()
            .zip(&right.words)
            .map(|(x, y)| (x & y).count_ones())
            .sum())
    }

    pub fn intersects(&self, right: &Self) -> Result<bool, BitSetError> {
        if self.width != right.width {
            return Err(BitSetError::WidthMismatch);
        }
        Ok(self.words.iter().zip(&right.words).any(|(x, y)| x & y != 0))
    }

    pub fn disjoint(&self, right: &Self) -> Result<bool, BitSetError> {
        Ok(!self.intersects(right)?)
    }
}
