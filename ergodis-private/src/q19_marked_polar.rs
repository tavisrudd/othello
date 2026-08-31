//! Private marked-polar falsifier over `F_19`.

use anyhow::Result;
use ergodis::observational::{
    compile_observational_with_policy, verify_compilation, CertificatePolicy, FinitePresentation,
    GeneratorSpec,
};

const Q: u32 = 19;
const PROJECTIVE_POINTS: usize = 20;

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct MarkedPolarCensus {
    pub projective_members: u32,
    pub split_squarefree_members: u32,
    pub finite_only_members: u32,
    pub common_root_mask: u32,
    pub availability_mask: u32,
    pub marked_classes: u32,
    pub split_root_masks: Box<[u32]>,
}

pub fn compile_q19_marked_polar() -> Result<MarkedPolarCensus> {
    let mut projective_members = 0_u32;
    let mut split_root_masks = Vec::with_capacity(6);
    for constant in 0..Q {
        for cubic in 0..Q {
            for quartic in 0..Q {
                let coefficients = [constant, cubic, quartic];
                let Some(first) = coefficients.iter().find(|&&value| value != 0) else {
                    continue;
                };
                if *first != 1 {
                    continue;
                }
                projective_members += 1;
                let roots = root_mask(constant, cubic, quartic);
                if roots.count_ones() == 4 {
                    split_root_masks.push(roots);
                }
            }
        }
    }

    let common_root_mask = split_root_masks
        .iter()
        .copied()
        .reduce(|left, right| left & right)
        .unwrap_or(0);
    let finite_only_members = split_root_masks
        .iter()
        .filter(|mask| **mask & (1_u32 << (PROJECTIVE_POINTS - 1)) == 0)
        .count() as u32;
    let mut availability_mask = 0_u32;
    for marker in 0..PROJECTIVE_POINTS {
        if split_root_masks
            .iter()
            .any(|mask| mask & (1_u32 << marker) == 0)
        {
            availability_mask |= 1_u32 << marker;
        }
    }

    let target_start = PROJECTIVE_POINTS as u32;
    let mut observations = vec![0_u32; PROJECTIVE_POINTS];
    observations.extend([0, 1]);
    let transitions = (0..PROJECTIVE_POINTS)
        .map(|marker| target_start + u32::from(availability_mask & (1_u32 << marker) != 0))
        .collect::<Vec<_>>()
        .into_boxed_slice();
    let presentation = FinitePresentation::new(
        [PROJECTIVE_POINTS as u32, 2],
        observations,
        [GeneratorSpec {
            source_sort: 0,
            target_sort: 1,
            transitions,
        }],
    )?;
    let compilation =
        compile_observational_with_policy(&presentation, CertificatePolicy::AdaptiveTranscript)?;
    verify_compilation(&presentation, &compilation)?;

    Ok(MarkedPolarCensus {
        projective_members,
        split_squarefree_members: split_root_masks.len() as u32,
        finite_only_members,
        common_root_mask,
        availability_mask,
        marked_classes: compilation.class_ranges()[0].len,
        split_root_masks: split_root_masks.into_boxed_slice(),
    })
}

#[inline]
fn root_mask(constant: u32, cubic: u32, quartic: u32) -> u32 {
    let mut roots = 0_u32;
    for value in 0..Q {
        let square = value * value % Q;
        let cubic_value = square * value % Q;
        let quartic_value = cubic_value * value % Q;
        if (constant + cubic * cubic_value + quartic * quartic_value) % Q == 0 {
            roots |= 1_u32 << value;
        }
    }
    if quartic == 0 {
        roots |= 1_u32 << (PROJECTIVE_POINTS - 1);
    }
    roots
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn q19_marker_is_observationally_necessary() {
        let census = compile_q19_marked_polar().unwrap();
        assert_eq!(census.projective_members, 381);
        assert_eq!(census.split_squarefree_members, 6);
        assert_eq!(census.finite_only_members, 0);
        assert_eq!(census.common_root_mask, 1_u32 << 19);
        assert_eq!(census.availability_mask, (1_u32 << 19) - 1);
        assert_eq!(census.marked_classes, 2);
    }
}
