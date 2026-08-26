use crate::bitset::{BitSet, BitSetError};

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct SignedIncidenceProfile {
    pub degrees: Box<[u32]>,
    pub signed_sums: Box<[i32]>,
    pub tangent_rows: Box<[u32]>,
    pub same_sign_secants: Box<[u32]>,
}

impl SignedIncidenceProfile {
    pub fn constraints_hold(&self) -> bool {
        self.tangent_rows.is_empty() && self.same_sign_secants.is_empty()
    }
}

pub fn signed_profile(
    rows: &[BitSet],
    positive: &BitSet,
    negative: &BitSet,
) -> Result<SignedIncidenceProfile, BitSetError> {
    if !positive.disjoint(negative)? {
        return Err(BitSetError::WidthMismatch);
    }
    let mut degrees = Vec::with_capacity(rows.len());
    let mut sums = Vec::with_capacity(rows.len());
    let mut tangents = Vec::new();
    let mut same_sign = Vec::new();
    for (index, row) in rows.iter().enumerate() {
        let pos = row.intersection_count(positive)?;
        let neg = row.intersection_count(negative)?;
        let degree = pos + neg;
        let sum = pos as i32 - neg as i32;
        degrees.push(degree);
        sums.push(sum);
        if degree == 1 {
            tangents.push(index as u32);
        } else if degree == 2 && sum.unsigned_abs() == 2 {
            same_sign.push(index as u32);
        }
    }
    Ok(SignedIncidenceProfile {
        degrees: degrees.into_boxed_slice(),
        signed_sums: sums.into_boxed_slice(),
        tangent_rows: tangents.into_boxed_slice(),
        same_sign_secants: same_sign.into_boxed_slice(),
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn signed_constraints_match_reference_case() {
        let rows = [
            BitSet::from_indices(4, [0, 1]).unwrap(),
            BitSet::from_indices(4, [0, 2]).unwrap(),
            BitSet::from_indices(4, [1, 2, 3]).unwrap(),
            BitSet::from_indices(4, [2, 3]).unwrap(),
        ];
        let positive = BitSet::from_indices(4, [0, 3]).unwrap();
        let negative = BitSet::from_indices(4, [1, 2]).unwrap();
        let profile = signed_profile(&rows, &positive, &negative).unwrap();
        assert!(profile.constraints_hold());
        assert_eq!(&*profile.degrees, &[2, 2, 3, 2]);
        assert_eq!(&*profile.signed_sums, &[0, 0, -1, 0]);
    }
}
