//! Fixed-width allocation-free sumsets for small binary quotient spaces.

/// Add `left XOR right XOR offset` to a 256-element bitset.
///
/// The kernel is iterative, uses fixed storage, and performs no allocation.
pub fn xor_sumset_256_into(output: &mut [u64; 4], left: &[u64; 4], right: &[u64; 4], offset: u8) {
    if output.iter().all(|&word| word == u64::MAX) {
        return;
    }
    if left.iter().all(|&word| word == u64::MAX) || right.iter().all(|&word| word == u64::MAX) {
        output.fill(u64::MAX);
        return;
    }
    for (left_word_index, &left_word) in left.iter().enumerate() {
        let mut left_bits = left_word;
        while left_bits != 0 {
            let left_bit = (left_word_index * 64 + left_bits.trailing_zeros() as usize) as u8;
            left_bits &= left_bits - 1;
            for (right_word_index, &right_word) in right.iter().enumerate() {
                let mut right_bits = right_word;
                while right_bits != 0 {
                    let right_bit =
                        (right_word_index * 64 + right_bits.trailing_zeros() as usize) as u8;
                    right_bits &= right_bits - 1;
                    let value = left_bit ^ right_bit ^ offset;
                    output[usize::from(value >> 6)] |= 1_u64 << (value & 63);
                }
            }
        }
    }
}

pub fn bitset_256_contains(bits: &[u64; 4], value: u8) -> bool {
    bits[usize::from(value >> 6)] & (1_u64 << (value & 63)) != 0
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    #[test]
    fn xor_sumset_matches_independent_pair_loop() {
        let mut left = [0_u64; 4];
        let mut right = [0_u64; 4];
        for value in [0_u8, 3, 64, 129, 255] {
            left[usize::from(value >> 6)] |= 1_u64 << (value & 63);
        }
        for value in [1_u8, 7, 65, 200] {
            right[usize::from(value >> 6)] |= 1_u64 << (value & 63);
        }
        let mut actual = [0_u64; 4];
        xor_sumset_256_into(&mut actual, &left, &right, 91);
        let mut expected = [0_u64; 4];
        for left_value in [0_u8, 3, 64, 129, 255] {
            for right_value in [1_u8, 7, 65, 200] {
                let value = left_value ^ right_value ^ 91;
                expected[usize::from(value >> 6)] |= 1_u64 << (value & 63);
            }
        }
        assert_eq!(actual, expected);
    }

    #[test]
    fn hot_kernel_allocates_nothing() {
        let left = [0x8040_2010_0804_0201_u64; 4];
        let right = [0x0102_0408_1020_4080_u64; 4];
        let mut output = [0_u64; 4];
        let (_, allocations) = tracked_allocations(|| {
            for offset in 0_u8..=255 {
                output.fill(0);
                xor_sumset_256_into(&mut output, &left, &right, offset);
                std::hint::black_box(output);
            }
        });
        assert_eq!(allocations, 0);
    }
}
