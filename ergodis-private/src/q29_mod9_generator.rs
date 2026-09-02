//! Constructive residue-first generator for the unrestricted q29 shell.
//!
//! The nontrivial mod-three factor is represented as
//! `F_3[t]/Phi_29(t) = F_{3^28}`. Three components are sampled and the fourth
//! norm is solved in the quadratic fixed-field split. A fixed Gaussian
//! workspace Hensel-lifts the canonical length-29 rows to mod nine. Every
//! output is replayed against all 29 correlations and four augmentations.

use crate::q29_mod3_norm::row_residues_from_nontrivial_component_mod9;

const DEGREE: usize = 28;
const ORDER: usize = 29;
const BLOCKS: usize = 4;
const VARIABLES: usize = BLOCKS * ORDER;
const EQUATIONS: usize = 15 + BLOCKS;
const STRIDE: usize = VARIABLES + 1;
const FIELD_ORDER: u64 = 22_876_792_454_961;
const FIXED_ORDER: u64 = 4_782_969;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct FieldElement {
    coefficients: [u8; DEGREE],
    _pad: [u8; 4],
}

const _: () = assert!(core::mem::size_of::<FieldElement>() == 32);
const _: () = assert!(core::mem::align_of::<FieldElement>() == 1);

impl FieldElement {
    const ZERO: Self = Self {
        coefficients: [0; DEGREE],
        _pad: [0; 4],
    };
    const ONE: Self = {
        let mut coefficients = [0; DEGREE];
        coefficients[0] = 1;
        Self {
            coefficients,
            _pad: [0; 4],
        }
    };
    const MINUS_ONE: Self = {
        let mut coefficients = [0; DEGREE];
        coefficients[0] = 2;
        Self {
            coefficients,
            _pad: [0; 4],
        }
    };

    #[inline(always)]
    fn add(self, rhs: Self) -> Self {
        let mut output = Self::ZERO;
        for index in 0..DEGREE {
            output.coefficients[index] = (self.coefficients[index] + rhs.coefficients[index]) % 3;
        }
        output
    }

    #[inline(always)]
    fn sub(self, rhs: Self) -> Self {
        let mut output = Self::ZERO;
        for index in 0..DEGREE {
            output.coefficients[index] =
                (self.coefficients[index] + 3 - rhs.coefficients[index]) % 3;
        }
        output
    }

    #[inline(always)]
    fn mul(self, rhs: Self) -> Self {
        let mut product = [0_u8; 2 * DEGREE - 1];
        for left in 0..DEGREE {
            for right in 0..DEGREE {
                product[left + right] =
                    (product[left + right] + self.coefficients[left] * rhs.coefficients[right]) % 3;
            }
        }
        for degree in (DEGREE..product.len()).rev() {
            let coefficient = product[degree];
            if coefficient == 0 {
                continue;
            }
            product[degree] = 0;
            let base = degree - DEGREE;
            for offset in 0..DEGREE {
                product[base + offset] = (product[base + offset] + 2 * coefficient) % 3;
            }
        }
        let mut output = Self::ZERO;
        output.coefficients.copy_from_slice(&product[..DEGREE]);
        output
    }

    #[inline(always)]
    fn square(self) -> Self {
        self.mul(self)
    }

    fn pow(mut self, mut exponent: u64) -> Self {
        let mut output = Self::ONE;
        while exponent != 0 {
            if exponent & 1 != 0 {
                output = output.mul(self);
            }
            exponent >>= 1;
            if exponent != 0 {
                self = self.square();
            }
        }
        output
    }

    fn inverse(self) -> Self {
        debug_assert!(self != Self::ZERO);
        self.pow(FIELD_ORDER - 2)
    }

    fn conjugate(mut self) -> Self {
        for _ in 0..14 {
            self = self.square().mul(self);
        }
        self
    }

    fn norm(self) -> Self {
        self.mul(self.conjugate())
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29Mod9GeneratorError {
    NoFixedNonsquare,
    NormSquareRootFailure,
    LinearLiftInconsistent,
    DirectReplayFailure,
}

#[repr(u8)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29Mod9GeneratorProvenance {
    ProvedStructuralDirectReplay = 1,
}

/// The discovery distribution used to select one structurally valid shell.
/// This is deliberately separate from proof provenance: changing the policy
/// changes search coverage, but never upgrades a miss into negative evidence.
#[repr(u8)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum Q29Mod9GeneratorPolicy {
    RandomNormRandomHensel = 1,
    DeterministicSection = 2,
    RandomNormLowLiftHensel = 3,
}

#[repr(C, align(64))]
pub struct Q29Mod9GeneratorWorkspace {
    matrix: [u8; EQUATIONS * STRIDE],
    solution: [u8; VARIABLES],
    pivot_columns: [u8; EQUATIONS],
    norm_preimage: FieldElement,
    nonsquare_norm: FieldElement,
    _pad: [u8; 10],
}

const _: () = assert!(core::mem::size_of::<Q29Mod9GeneratorWorkspace>() == 2_432);
const _: () = assert!(core::mem::align_of::<Q29Mod9GeneratorWorkspace>() == 64);

impl Q29Mod9GeneratorWorkspace {
    pub fn new() -> Result<Self, Q29Mod9GeneratorError> {
        let (norm_preimage, nonsquare_norm) = find_nonsquare_norm()?;
        Ok(Self {
            matrix: [0; EQUATIONS * STRIDE],
            solution: [0; VARIABLES],
            pivot_columns: [u8::MAX; EQUATIONS],
            norm_preimage,
            nonsquare_norm,
            _pad: [0; 10],
        })
    }
}

#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29Mod9Rows {
    pub seed: u64,
    pub rows: [[u8; ORDER]; BLOCKS],
    pub provenance: Q29Mod9GeneratorProvenance,
    pub policy: Q29Mod9GeneratorPolicy,
    _pad: [u8; 2],
}

const _: () = assert!(core::mem::size_of::<Q29Mod9Rows>() == 128);
const _: () = assert!(core::mem::align_of::<Q29Mod9Rows>() == 64);

/// Generate one (nonuniform) constructive mod-nine shell point. This is a
/// sound discovery source, not an enumeration or negative-coverage claim.
pub fn generate_q29_mod9_rows(
    seed: u64,
    workspace: &mut Q29Mod9GeneratorWorkspace,
) -> Result<Q29Mod9Rows, Q29Mod9GeneratorError> {
    generate_q29_mod9_rows_inner::<true, true>(seed, workspace)
}

/// Deterministic-section control with one norm preimage and zero free lift
/// variables. It is an A/B control, not the production discovery sampler.
pub fn generate_q29_mod9_rows_deterministic(
    seed: u64,
    workspace: &mut Q29Mod9GeneratorWorkspace,
) -> Result<Q29Mod9Rows, Q29Mod9GeneratorError> {
    generate_q29_mod9_rows_inner::<false, false>(seed, workspace)
}

/// Discovery policy that samples the norm fibre but selects the zero-free-
/// variable Hensel section. This biases toward the bounded integer-lift DP;
/// it is not a uniform shell sampler and has no negative authority.
pub fn generate_q29_mod9_rows_low_lift(
    seed: u64,
    workspace: &mut Q29Mod9GeneratorWorkspace,
) -> Result<Q29Mod9Rows, Q29Mod9GeneratorError> {
    generate_q29_mod9_rows_inner::<true, false>(seed, workspace)
}

fn generate_q29_mod9_rows_inner<const RANDOMIZE_NORM: bool, const RANDOMIZE_HENSEL: bool>(
    seed: u64,
    workspace: &mut Q29Mod9GeneratorWorkspace,
) -> Result<Q29Mod9Rows, Q29Mod9GeneratorError> {
    let mut random = normalized_random_state(seed);
    let mut components = [FieldElement::ZERO; BLOCKS];
    let mut norm_sum = FieldElement::ZERO;
    for component in &mut components[..3] {
        *component = random_field_element(&mut random);
        norm_sum = norm_sum.add(component.norm());
    }
    components[3] = solve_norm::<RANDOMIZE_NORM>(
        FieldElement::ONE.sub(norm_sum),
        workspace.norm_preimage,
        workspace.nonsquare_norm,
        &mut random,
    )?;

    let mut rows = [[0_u8; ORDER]; BLOCKS];
    for block in 0..BLOCKS {
        rows[block] = row_residues_from_nontrivial_component_mod9(
            &components[block].coefficients,
            u8::from(block == 0),
        )
        .map_err(|_| Q29Mod9GeneratorError::DirectReplayFailure)?;
    }
    if !direct_replay(&rows, 3) {
        return Err(Q29Mod9GeneratorError::DirectReplayFailure);
    }
    hensel_lift_rows::<RANDOMIZE_HENSEL>(&mut rows, workspace, &mut random)?;
    if !direct_replay(&rows, 9) {
        return Err(Q29Mod9GeneratorError::DirectReplayFailure);
    }
    Ok(Q29Mod9Rows {
        seed,
        rows,
        provenance: Q29Mod9GeneratorProvenance::ProvedStructuralDirectReplay,
        policy: match (RANDOMIZE_NORM, RANDOMIZE_HENSEL) {
            (true, true) => Q29Mod9GeneratorPolicy::RandomNormRandomHensel,
            (false, false) => Q29Mod9GeneratorPolicy::DeterministicSection,
            (true, false) => Q29Mod9GeneratorPolicy::RandomNormLowLiftHensel,
            (false, true) => unreachable!("unregistered generator policy"),
        },
        _pad: [0; 2],
    })
}

fn find_nonsquare_norm() -> Result<(FieldElement, FieldElement), Q29Mod9GeneratorError> {
    for basis in 1..DEGREE {
        for coefficient in 1..=2 {
            let mut candidate = FieldElement::ONE;
            candidate.coefficients[basis] = coefficient;
            let norm = candidate.norm();
            if norm != FieldElement::ZERO
                && norm.pow((FIXED_ORDER - 1) / 2) == FieldElement::MINUS_ONE
            {
                return Ok((candidate, norm));
            }
        }
    }
    Err(Q29Mod9GeneratorError::NoFixedNonsquare)
}

fn solve_norm<const RANDOMIZE_FIBRE: bool>(
    target: FieldElement,
    nonsquare_preimage: FieldElement,
    nonsquare_norm: FieldElement,
    random: &mut u64,
) -> Result<FieldElement, Q29Mod9GeneratorError> {
    if target == FieldElement::ZERO {
        return Ok(FieldElement::ZERO);
    }
    let root = if let Some(root) = sqrt_fixed(target, nonsquare_norm) {
        root
    } else {
        let quotient = target.mul(nonsquare_norm.inverse());
        nonsquare_preimage.mul(
            sqrt_fixed(quotient, nonsquare_norm)
                .ok_or(Q29Mod9GeneratorError::NormSquareRootFailure)?,
        )
    };
    if RANDOMIZE_FIBRE {
        let source = loop {
            // Retrying zero preserves the intended nonzero norm-fibre source;
            // no distinguished replacement point is injected.
            let source = random_field_element(random);
            if source != FieldElement::ZERO {
                break source;
            }
        };
        Ok(root.mul(source.pow(FIXED_ORDER - 1)))
    } else {
        Ok(root)
    }
}

fn sqrt_fixed(value: FieldElement, nonsquare: FieldElement) -> Option<FieldElement> {
    if value == FieldElement::ZERO {
        return Some(FieldElement::ZERO);
    }
    if value.pow((FIXED_ORDER - 1) / 2) != FieldElement::ONE {
        return None;
    }
    let mut c = nonsquare.pow(597_871);
    let mut root = value.pow(298_936);
    let mut residue = value.pow(597_871);
    let mut power = 3_u8;
    while residue != FieldElement::ONE {
        let mut probe = residue;
        let mut index = 0_u8;
        while probe != FieldElement::ONE && index < power {
            probe = probe.square();
            index += 1;
        }
        if index == power {
            return None;
        }
        let mut correction = c;
        for _ in 0..(power - index - 1) {
            correction = correction.square();
        }
        root = root.mul(correction);
        c = correction.square();
        residue = residue.mul(c);
        power = index;
    }
    Some(root)
}

fn hensel_lift_rows<const RANDOMIZE_FIBRES: bool>(
    rows: &mut [[u8; ORDER]; BLOCKS],
    workspace: &mut Q29Mod9GeneratorWorkspace,
    random: &mut u64,
) -> Result<(), Q29Mod9GeneratorError> {
    workspace.matrix.fill(0);
    workspace.solution.fill(0);
    workspace.pivot_columns.fill(u8::MAX);
    for shift in 0..15 {
        let current = combined_correlation(rows, shift);
        let difference = (i32::from(shift == 0) - current).rem_euclid(9);
        debug_assert_eq!(difference % 3, 0);
        workspace.matrix[shift * STRIDE + VARIABLES] = (difference / 3) as u8;
        for block in 0..BLOCKS {
            for point in 0..ORDER {
                workspace.matrix[shift * STRIDE + block * ORDER + point] =
                    ((u16::from(rows[block][(point + shift) % ORDER])
                        + u16::from(rows[block][(point + ORDER - shift) % ORDER]))
                        % 3) as u8;
            }
        }
    }
    for block in 0..BLOCKS {
        let equation = 15 + block;
        let sum = rows[block]
            .iter()
            .fold(0_i32, |total, &value| total + i32::from(value));
        let difference = (i32::from(block == 0) - sum).rem_euclid(9);
        debug_assert_eq!(difference % 3, 0);
        workspace.matrix[equation * STRIDE + VARIABLES] = (difference / 3) as u8;
        for point in 0..ORDER {
            workspace.matrix[equation * STRIDE + block * ORDER + point] = 1;
        }
    }
    solve_linear_system::<RANDOMIZE_FIBRES>(workspace, random)?;
    for block in 0..BLOCKS {
        for point in 0..ORDER {
            rows[block][point] =
                (rows[block][point] + 3 * workspace.solution[block * ORDER + point]) % 9;
        }
    }
    Ok(())
}

fn solve_linear_system<const RANDOMIZE_FIBRES: bool>(
    workspace: &mut Q29Mod9GeneratorWorkspace,
    random: &mut u64,
) -> Result<(), Q29Mod9GeneratorError> {
    let mut rank = 0_usize;
    for column in 0..VARIABLES {
        let mut pivot = rank;
        while pivot < EQUATIONS && workspace.matrix[pivot * STRIDE + column] == 0 {
            pivot += 1;
        }
        if pivot == EQUATIONS {
            continue;
        }
        if pivot != rank {
            for entry in column..=VARIABLES {
                workspace
                    .matrix
                    .swap(rank * STRIDE + entry, pivot * STRIDE + entry);
            }
        }
        if workspace.matrix[rank * STRIDE + column] == 2 {
            for entry in column..=VARIABLES {
                let index = rank * STRIDE + entry;
                workspace.matrix[index] = (2 * workspace.matrix[index]) % 3;
            }
        }
        for row in 0..EQUATIONS {
            if row == rank {
                continue;
            }
            let factor = workspace.matrix[row * STRIDE + column];
            if factor == 0 {
                continue;
            }
            for entry in column..=VARIABLES {
                let index = row * STRIDE + entry;
                let pivot_value = workspace.matrix[rank * STRIDE + entry];
                workspace.matrix[index] =
                    (workspace.matrix[index] + 3 - factor * pivot_value % 3) % 3;
            }
        }
        workspace.pivot_columns[rank] = column as u8;
        rank += 1;
        if rank == EQUATIONS {
            break;
        }
    }
    for row in rank..EQUATIONS {
        let mut nonzero = false;
        for column in 0..VARIABLES {
            nonzero |= workspace.matrix[row * STRIDE + column] != 0;
        }
        if !nonzero && workspace.matrix[row * STRIDE + VARIABLES] != 0 {
            return Err(Q29Mod9GeneratorError::LinearLiftInconsistent);
        }
    }
    if RANDOMIZE_FIBRES {
        for column in 0..VARIABLES {
            let mut is_pivot = false;
            for &pivot in &workspace.pivot_columns[..rank] {
                is_pivot |= usize::from(pivot) == column;
            }
            if !is_pivot {
                workspace.solution[column] = sample_trit(random);
            }
        }
    }
    for row in 0..rank {
        let pivot = usize::from(workspace.pivot_columns[row]);
        let mut value = workspace.matrix[row * STRIDE + VARIABLES];
        for column in 0..VARIABLES {
            if column != pivot {
                value = (value + 3
                    - workspace.matrix[row * STRIDE + column] * workspace.solution[column] % 3)
                    % 3;
            }
        }
        workspace.solution[pivot] = value;
    }
    Ok(())
}

#[inline(always)]
fn combined_correlation(rows: &[[u8; ORDER]; BLOCKS], shift: usize) -> i32 {
    let mut total = 0_i32;
    for row in rows {
        for point in 0..ORDER {
            total += i32::from(row[point]) * i32::from(row[(point + shift) % ORDER]);
        }
    }
    total
}

fn direct_replay(rows: &[[u8; ORDER]; BLOCKS], modulus: i32) -> bool {
    for block in 0..BLOCKS {
        let sum = rows[block]
            .iter()
            .fold(0_i32, |total, &value| total + i32::from(value));
        if sum.rem_euclid(modulus) != i32::from(block == 0) {
            return false;
        }
    }
    for shift in 0..ORDER {
        if combined_correlation(rows, shift).rem_euclid(modulus) != i32::from(shift == 0) {
            return false;
        }
    }
    true
}

fn random_field_element(random: &mut u64) -> FieldElement {
    let mut output = FieldElement::ZERO;
    for coefficient in &mut output.coefficients {
        *coefficient = sample_trit(random);
    }
    output
}

fn sample_trit(random: &mut u64) -> u8 {
    // Marsaglia xorshift64 (13,7,17) permutes the nonzero states in one
    // maximal-period orbit. Its 2^64-1 outputs split exactly evenly mod 3.
    (next_random(random) % 3) as u8
}

#[inline(always)]
fn normalized_random_state(seed: u64) -> u64 {
    let state = seed.wrapping_add(0x9e37_79b9_7f4a_7c15);
    if state == 0 {
        0xd1b5_4a32_d192_ed03
    } else {
        state
    }
}

#[inline(always)]
fn next_random(state: &mut u64) -> u64 {
    *state ^= *state << 13;
    *state ^= *state >> 7;
    *state ^= *state << 17;
    *state
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn independent_product(left: FieldElement, right: FieldElement) -> FieldElement {
        let mut cyclic = [0_u8; ORDER];
        for i in 0..DEGREE {
            for j in 0..DEGREE {
                cyclic[(i + j) % ORDER] =
                    (cyclic[(i + j) % ORDER] + left.coefficients[i] * right.coefficients[j]) % 3;
            }
        }
        let tail = cyclic[28];
        let mut output = FieldElement::ZERO;
        for index in 0..DEGREE {
            output.coefficients[index] = (cyclic[index] + 3 - tail) % 3;
        }
        output
    }

    #[test]
    fn field_product_matches_independent_cyclic_quotient() {
        let mut random = 0xd1b5_4a32_d192_ed03;
        for _ in 0..1_000 {
            let left = random_field_element(&mut random);
            let right = random_field_element(&mut random);
            assert_eq!(left.mul(right), independent_product(left, right));
        }
    }

    #[test]
    fn fixed_polynomial_and_involution_replay() {
        let mut generator = FieldElement::ZERO;
        generator.coefficients[1] = 1;
        assert_eq!(generator.pow(29), FieldElement::ONE);
        assert_ne!(generator, FieldElement::ONE);
        let mut random = 0x1234_5678_9abc_def0;
        for _ in 0..100 {
            let value = random_field_element(&mut random);
            assert_eq!(value.conjugate().conjugate(), value);
            assert_eq!(value.norm().conjugate(), value.norm());
        }
    }

    #[test]
    fn generated_rows_pass_all_direct_mod9_equations() {
        let mut workspace = Q29Mod9GeneratorWorkspace::new().unwrap();
        for seed in 1..=100 {
            let generated = generate_q29_mod9_rows(seed, &mut workspace).unwrap();
            assert!(direct_replay(&generated.rows, 9));
        }
    }

    #[test]
    fn randomized_fibres_differ_from_deterministic_control() {
        let mut randomized_workspace = Q29Mod9GeneratorWorkspace::new().unwrap();
        let mut deterministic_workspace = Q29Mod9GeneratorWorkspace::new().unwrap();
        let randomized = generate_q29_mod9_rows(0xace1, &mut randomized_workspace).unwrap();
        let deterministic =
            generate_q29_mod9_rows_deterministic(0xace1, &mut deterministic_workspace).unwrap();
        assert_eq!(
            randomized.policy,
            Q29Mod9GeneratorPolicy::RandomNormRandomHensel
        );
        assert_eq!(
            deterministic.policy,
            Q29Mod9GeneratorPolicy::DeterministicSection
        );
        assert_ne!(randomized.rows, deterministic.rows);
        assert!(direct_replay(&randomized.rows, 9));
        assert!(direct_replay(&deterministic.rows, 9));
    }

    #[test]
    fn norm_fibre_randomization_changes_preimage_not_norm() {
        let workspace = Q29Mod9GeneratorWorkspace::new().unwrap();
        let target = workspace.nonsquare_norm;
        let mut deterministic_random = 0x1020_3040_5060_7080;
        let mut fibre_random = deterministic_random;
        let deterministic = solve_norm::<false>(
            target,
            workspace.norm_preimage,
            workspace.nonsquare_norm,
            &mut deterministic_random,
        )
        .unwrap();
        let randomized = solve_norm::<true>(
            target,
            workspace.norm_preimage,
            workspace.nonsquare_norm,
            &mut fibre_random,
        )
        .unwrap();
        assert_ne!(deterministic, randomized);
        assert_eq!(deterministic.norm(), target);
        assert_eq!(randomized.norm(), target);

        let mut low_workspace = Q29Mod9GeneratorWorkspace::new().unwrap();
        let mut control_workspace = Q29Mod9GeneratorWorkspace::new().unwrap();
        let low = generate_q29_mod9_rows_low_lift(0xace1, &mut low_workspace).unwrap();
        let control = generate_q29_mod9_rows_deterministic(0xace1, &mut control_workspace).unwrap();
        assert_eq!(low.policy, Q29Mod9GeneratorPolicy::RandomNormLowLiftHensel);
        assert_eq!(control.policy, Q29Mod9GeneratorPolicy::DeterministicSection);
        assert_ne!(low.rows, control.rows);
        assert_ne!(low.rows[3], control.rows[3]);
        assert!(direct_replay(&low.rows, 9));
        assert!(direct_replay(&control.rows, 9));
    }

    #[test]
    fn generator_loop_allocates_nothing() {
        let mut workspace = Q29Mod9GeneratorWorkspace::new().unwrap();
        let (_, allocations) = tracked_allocations(|| {
            for seed in 1..=100 {
                let generated = generate_q29_mod9_rows(seed, &mut workspace).unwrap();
                assert!(direct_replay(&generated.rows, 9));
            }
        });
        assert_eq!(allocations, 0);
    }

    fn apply_linear(map: &[u64; 64], mut value: u64) -> u64 {
        let mut output = 0_u64;
        while value != 0 {
            let bit = value.trailing_zeros() as usize;
            output ^= map[bit];
            value &= value - 1;
        }
        output
    }

    fn xorshift_power(mut exponent: u64) -> u64 {
        let mut map = [0_u64; 64];
        for (bit, image) in map.iter_mut().enumerate() {
            let mut basis = 1_u64 << bit;
            *image = next_random(&mut basis);
        }
        let mut value = 1_u64;
        while exponent != 0 {
            if exponent & 1 != 0 {
                value = apply_linear(&map, value);
            }
            let prior = map;
            for bit in 0..64 {
                map[bit] = apply_linear(&prior, prior[bit]);
            }
            exponent >>= 1;
        }
        value
    }

    #[test]
    fn xorshift_has_full_nonzero_period_and_seed_zero_is_normalized() {
        const PERIOD: u64 = u64::MAX;
        const PRIME_FACTORS: [u64; 7] = [3, 5, 17, 257, 641, 65_537, 6_700_417];
        assert_eq!(xorshift_power(PERIOD), 1);
        for factor in PRIME_FACTORS {
            assert_ne!(xorshift_power(PERIOD / factor), 1);
        }
        assert_ne!(
            normalized_random_state(0_u64.wrapping_sub(0x9e37_79b9_7f4a_7c15)),
            0
        );
    }
}
