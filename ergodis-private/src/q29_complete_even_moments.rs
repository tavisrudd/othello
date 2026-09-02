//! Complete even autocorrelation moments over `F_29`.
//!
//! For a row `y : F_29 -> Z`, put `M_j = sum_x x^j y(x)`.  Expanding
//! `(t-x)^k` gives the exact identity
//!
//! `sum_s s^k PAF_y(s) = sum_j binom(k,j)(-1)^(k-j) M_j M_(k-j)`.
//!
//! The q29 target is `(505,-18,...,-18)`. Hence every even moment of degree
//! `2,4,...,26` vanishes modulo 29, while degree 28 is 18. These fourteen
//! equations are a structural necessary predicate. Discovery/evolution may
//! choose useful coordinates, but pruning authority comes only from the
//! identity replayed here.

use ergodis::{evolve_ranked_streaming, EvolutionConfig};
use serde::Serialize;
use sha2::{Digest, Sha256};

use crate::{
    cyclic_polynomial_moment_evolve::{
        mine_cyclic_polynomial_zero_chain_into, CyclicPolynomialMomentFeature,
    },
    proof_synthesis::{ExtractorDescriptor, ProvenanceClass},
    q29_even_moment_proof::retained_q29_y6_root,
};

const BLOCKS: usize = 4;
const ORDER: usize = 29;
const MAX_DEGREE: usize = 28;
const EVEN_MOMENTS: usize = 14;
const ALL_MOMENTS_MASK: u16 = (1_u16 << EVEN_MOMENTS) - 1;
const EXTRACTOR_ID: [u8; 16] = *b"c1016-q29evn0001";
const EXTRACTOR_VERSION: u16 = 1;
const PARAMETER_DIGEST: [u8; 32] = [0x3a; 32];
const SEMANTICS_COMMITMENT: [u8; 32] = [0xe2; 32];

const fn binomial_mod_29() -> [[u8; MAX_DEGREE + 1]; MAX_DEGREE + 1] {
    let mut table = [[0_u8; MAX_DEGREE + 1]; MAX_DEGREE + 1];
    let mut row = 0;
    while row <= MAX_DEGREE {
        table[row][0] = 1;
        table[row][row] = 1;
        let mut column = 1;
        while column < row {
            table[row][column] = ((table[row - 1][column - 1] as u16
                + table[row - 1][column] as u16)
                % ORDER as u16) as u8;
            column += 1;
        }
        row += 1;
    }
    table
}

const BINOMIAL_MOD_29: [[u8; MAX_DEGREE + 1]; MAX_DEGREE + 1] = binomial_mod_29();

const fn point_powers_mod_29() -> [[u8; MAX_DEGREE + 1]; ORDER] {
    let mut table = [[0_u8; MAX_DEGREE + 1]; ORDER];
    let mut point = 0;
    while point < ORDER {
        table[point][0] = 1;
        let mut degree = 1;
        while degree <= MAX_DEGREE {
            table[point][degree] =
                ((table[point][degree - 1] as u16 * point as u16) % ORDER as u16) as u8;
            degree += 1;
        }
        point += 1;
    }
    table
}

const POINT_POWERS_MOD_29: [[u8; MAX_DEGREE + 1]; ORDER] = point_powers_mod_29();

/// Compact hot-path result. Coordinate `i` is degree `2(i+1)`.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29CompleteEvenMomentSignature {
    values: [u8; EVEN_MOMENTS],
    target_mask: u16,
}

const _: () = assert!(core::mem::size_of::<Q29CompleteEvenMomentSignature>() == 16);
const _: () = assert!(core::mem::align_of::<Q29CompleteEvenMomentSignature>() == 2);

impl Q29CompleteEvenMomentSignature {
    #[must_use]
    pub const fn value(self, opaque_coordinate: usize) -> Option<u8> {
        if opaque_coordinate < EVEN_MOMENTS {
            Some(self.values[opaque_coordinate])
        } else {
            None
        }
    }

    #[must_use]
    pub const fn values(self) -> [u8; EVEN_MOMENTS] {
        self.values
    }

    #[must_use]
    pub const fn target_mask(self) -> u16 {
        self.target_mask
    }

    #[must_use]
    pub const fn accepts_exact_target(self) -> bool {
        self.target_mask == ALL_MOMENTS_MASK
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29CompleteEvenMomentProof {
    descriptor: ExtractorDescriptor,
    source_commitment: [u8; 32],
    signature: Q29CompleteEvenMomentSignature,
    provenance: ProvenanceClass,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29MomentCrtSufficiencyProof {
    descriptor: ExtractorDescriptor,
    residual_commitment: [u8; 32],
    provenance: ProvenanceClass,
}

impl Q29CompleteEvenMomentProof {
    #[must_use]
    pub const fn signature(self) -> Q29CompleteEvenMomentSignature {
        self.signature
    }
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29AnonymousMomentEvolveReport {
    /// Opaque feature ID: the adapter does not expose a polynomial degree.
    pub selected_feature: u8,
    pub excluded_single_swaps: u16,
    pub legal_single_swaps: u16,
    pub false_negatives: u16,
    pub provenance: ProvenanceClass,
}

#[derive(Clone, Copy, Debug, Serialize, PartialEq, Eq)]
pub struct Q29BlindMomentMiningReport {
    pub selected_exponents: [u8; EVEN_MOMENTS],
    pub survivor_scopes: [u64; EVEN_MOMENTS],
    pub train_after: [u16; EVEN_MOMENTS],
    pub holdout_after: [u16; EVEN_MOMENTS],
    pub selected: u8,
    pub promoted: u8,
    pub observations: u16,
    pub provenance: ProvenanceClass,
}

/// Triangular row-zero reconstruction for degrees `2..=28`.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Q29TriangularMomentSignature {
    actual: [u8; EVEN_MOMENTS],
    derived: [u8; EVEN_MOMENTS],
    matches_mask: u16,
    _reserved: [u8; 2],
}

const _: () = assert!(core::mem::size_of::<Q29TriangularMomentSignature>() == 32);
const _: () = assert!(core::mem::align_of::<Q29TriangularMomentSignature>() == 2);

impl Q29TriangularMomentSignature {
    #[must_use]
    pub const fn actual(self) -> [u8; EVEN_MOMENTS] {
        self.actual
    }

    #[must_use]
    pub const fn derived(self) -> [u8; EVEN_MOMENTS] {
        self.derived
    }

    #[must_use]
    pub const fn matches_mask(self) -> u16 {
        self.matches_mask
    }
}

#[must_use]
pub const fn q29_complete_even_moment_descriptor() -> ExtractorDescriptor {
    ExtractorDescriptor::registered(
        EXTRACTOR_ID,
        EXTRACTOR_VERSION,
        PARAMETER_DIGEST,
        SEMANTICS_COMMITMENT,
    )
}

#[inline(always)]
fn mod_29(value: i32) -> u8 {
    value.rem_euclid(ORDER as i32) as u8
}

/// Allocation-free extraction of all fourteen exact even-moment predicates.
#[must_use]
pub fn extract_q29_complete_even_moments(
    rows: &[[i8; ORDER]; BLOCKS],
) -> Q29CompleteEvenMomentSignature {
    let power_moments = extract_power_moments(rows);
    signature_from_power_moments(&power_moments)
}

#[inline(always)]
fn extract_power_moments(rows: &[[i8; ORDER]; BLOCKS]) -> [[u8; MAX_DEGREE + 1]; BLOCKS] {
    let mut power_moments = [[0_u8; MAX_DEGREE + 1]; BLOCKS];
    for block in 0..BLOCKS {
        let mut accumulators = [0_i32; MAX_DEGREE + 1];
        for point in 0..ORDER {
            for degree in 0..=MAX_DEGREE {
                accumulators[degree] +=
                    i32::from(rows[block][point]) * i32::from(POINT_POWERS_MOD_29[point][degree]);
            }
        }
        power_moments[block] = accumulators.map(mod_29);
    }
    power_moments
}

#[inline(always)]
fn signature_from_power_moments(
    power_moments: &[[u8; MAX_DEGREE + 1]; BLOCKS],
) -> Q29CompleteEvenMomentSignature {
    let mut values = [0_u8; EVEN_MOMENTS];
    let mut target_mask = 0_u16;
    for coordinate in 0..EVEN_MOMENTS {
        let degree = 2 * (coordinate + 1);
        let mut total = 0_i32;
        for row in power_moments {
            for split in 0..=degree {
                let term = i32::from(BINOMIAL_MOD_29[degree][split])
                    * i32::from(row[split])
                    * i32::from(row[degree - split]);
                total += if (degree - split) & 1 == 0 {
                    term
                } else {
                    -term
                };
            }
        }
        values[coordinate] = mod_29(total);
        let target = if degree == 28 { 18 } else { 0 };
        if values[coordinate] == target {
            target_mask |= 1 << coordinate;
        }
    }
    Q29CompleteEvenMomentSignature {
        values,
        target_mask,
    }
}

/// With row sums `(1,0,0,0)`, the endpoint terms in degree `2r` are
/// `2*M_(2r)(row0)`.  This allocation-free recurrence derives that moment
/// from lower moments; at degree 28 the target right side is 18 rather than 0.
#[must_use]
pub fn derive_q29_row0_even_moment_recurrence(
    rows: &[[i8; ORDER]; BLOCKS],
) -> Option<Q29TriangularMomentSignature> {
    let moments = extract_power_moments(rows);
    if moments.map(|row| row[0]) != [1, 0, 0, 0] {
        return None;
    }
    let inverse_two = 15_i32;
    let mut actual = [0_u8; EVEN_MOMENTS];
    let mut derived = [0_u8; EVEN_MOMENTS];
    let mut matches_mask = 0_u16;
    for coordinate in 0..EVEN_MOMENTS {
        let degree = 2 * (coordinate + 1);
        let mut interior = 0_i32;
        for row in &moments {
            for split in 1..degree {
                let term = i32::from(BINOMIAL_MOD_29[degree][split])
                    * i32::from(row[split])
                    * i32::from(row[degree - split]);
                interior += if (degree - split) & 1 == 0 {
                    term
                } else {
                    -term
                };
            }
        }
        let target = if degree == 28 { 18 } else { 0 };
        actual[coordinate] = moments[0][degree];
        derived[coordinate] = mod_29((target - mod_29(interior) as i32) * inverse_two);
        if actual[coordinate] == derived[coordinate] {
            matches_mask |= 1 << coordinate;
        }
    }
    Some(Q29TriangularMomentSignature {
        actual,
        derived,
        matches_mask,
        _reserved: [0; 2],
    })
}

fn invert_row0_even_moments(even_moments: &[u8; EVEN_MOMENTS]) -> Option<[u8; 14]> {
    let mut system = [[0_u8; 15]; 14];
    for equation in 0..14 {
        for representative in 1..=14 {
            let base = representative * representative % ORDER;
            let mut power = 1_i32;
            for _ in 0..=equation {
                power = power * base as i32 % ORDER as i32;
            }
            system[equation][representative - 1] = power as u8;
        }
        system[equation][14] = even_moments[equation];
    }
    for pivot in 0..14 {
        let row = (pivot..14).find(|&row| system[row][pivot] != 0)?;
        system.swap(pivot, row);
        let inverse = (1_u8..ORDER as u8).find(|&candidate| {
            u16::from(candidate) * u16::from(system[pivot][pivot]) % ORDER as u16 == 1
        })?;
        for column in pivot..=14 {
            system[pivot][column] =
                (u16::from(system[pivot][column]) * u16::from(inverse) % ORDER as u16) as u8;
        }
        for row in 0..14 {
            if row == pivot {
                continue;
            }
            let factor = system[row][pivot];
            for column in pivot..=14 {
                system[row][column] = (u16::from(system[row][column]) + ORDER as u16
                    - u16::from(factor) * u16::from(system[pivot][column]) % ORDER as u16)
                    as u8
                    % ORDER as u8;
            }
        }
    }
    Some(std::array::from_fn(|index| system[index][14]))
}

/// Reconstruct row 0 modulo 29 from rows 1--3 and its fourteen
/// antisymmetric pair differences. Odd row-0 moments depend only on those
/// differences; the triangular recurrence supplies every even moment, and a
/// fixed Vandermonde inversion supplies every symmetric pair sum.
#[must_use]
pub fn reconstruct_q29_row0_mod29(
    other_rows: &[[i8; ORDER]; 3],
    antisymmetric: &[i8; 14],
) -> Option<[u8; ORDER]> {
    if other_rows
        .iter()
        .any(|row| row.iter().map(|&value| i32::from(value)).sum::<i32>() % ORDER as i32 != 0)
    {
        return None;
    }
    let mut rows = [[0_i8; ORDER]; BLOCKS];
    rows[1..].copy_from_slice(other_rows);
    let mut moments = extract_power_moments(&rows);
    moments[0][0] = 1;
    for degree in (1..=MAX_DEGREE).step_by(2) {
        let mut total = 0_i32;
        for representative in 1..=14 {
            let mut power = 1_i32;
            for _ in 0..degree {
                power = power * representative as i32 % ORDER as i32;
            }
            total += power * i32::from(antisymmetric[representative - 1]);
        }
        moments[0][degree] = mod_29(total);
    }
    let inverse_two = 15_i32;
    let mut even = [0_u8; EVEN_MOMENTS];
    for coordinate in 0..EVEN_MOMENTS {
        let degree = 2 * (coordinate + 1);
        let mut interior = 0_i32;
        for row in &moments {
            for split in 1..degree {
                let term = i32::from(BINOMIAL_MOD_29[degree][split])
                    * i32::from(row[split])
                    * i32::from(row[degree - split]);
                interior += if (degree - split) & 1 == 0 {
                    term
                } else {
                    -term
                };
            }
        }
        let target = if degree == 28 { 18 } else { 0 };
        even[coordinate] = mod_29((target - mod_29(interior) as i32) * inverse_two);
        moments[0][degree] = even[coordinate];
    }
    let symmetric = invert_row0_even_moments(&even)?;
    let mut row0 = [0_u8; ORDER];
    let mut symmetric_sum = 0_i32;
    for representative in 1..=14 {
        let sum = i32::from(symmetric[representative - 1]);
        let difference = i32::from(antisymmetric[representative - 1]);
        row0[representative] = mod_29((sum + difference) * inverse_two);
        row0[ORDER - representative] = mod_29((sum - difference) * inverse_two);
        symmetric_sum += sum;
    }
    row0[0] = mod_29(1 - symmetric_sum);
    Some(row0)
}

/// Applies the q29 search carrier bound `[-9,9]`. Since its width is less
/// than 29, every accepted residue has a unique integer lift.
#[must_use]
pub fn lift_q29_row0_to_minus9_9(residues: &[u8; ORDER]) -> Option<[i8; ORDER]> {
    let mut lifted = [0_i8; ORDER];
    for (output, &residue) in lifted.iter_mut().zip(residues) {
        *output = match residue {
            0..=9 => residue as i8,
            20..=28 => residue as i8 - 29,
            _ => return None,
        };
    }
    Some(lifted)
}

/// Compact iterative replay of the Vandermonde+CRT sufficiency theorem.
///
/// The residual is indexed by all 29 cyclic shifts. The checker verifies the
/// symmetry, exact energy (`r_0=0`), mod-18 shell, global sum, Cauchy range,
/// and all thirteen even moments through degree 26. Gaussian elimination over
/// the fourteen distinct nonzero quadratic residues then proves every paired
/// residual is zero mod 29. CRT and the range leave only `0` or `522`; the
/// exact sum excludes `522`.
#[must_use]
pub fn replay_q29_moment_crt_sufficiency(residual: &[i16; ORDER]) -> bool {
    if residual[0] != 0
        || residual
            .iter()
            .any(|&value| !(-487..=523).contains(&i32::from(value)) || value % 18 != 0)
    {
        return false;
    }
    for shift in 1..ORDER {
        if residual[shift] != residual[ORDER - shift] {
            return false;
        }
    }

    let mut system = [[0_u8; 15]; 14];
    let mut moment_rhs = [0_u8; 14];
    for equation in 0..14 {
        for shift in 1..=14 {
            let base = shift * shift % ORDER;
            let mut power = 1_i32;
            for _ in 0..equation {
                power = power * base as i32 % ORDER as i32;
            }
            system[equation][shift - 1] = power as u8;
        }
        let degree = 2 * equation;
        let mut rhs = 0_i32;
        for shift in 1..=14 {
            let mut power = 1_i32;
            for _ in 0..degree {
                power = power * shift as i32 % ORDER as i32;
            }
            rhs += 2 * i32::from(residual[shift]) * power;
        }
        moment_rhs[equation] = mod_29(rhs);
        system[equation][14] = moment_rhs[equation];
    }
    // Equation zero is the exact global residual sum; equations 1--13 are
    // the even moments through degree 26.
    if residual.iter().map(|&value| i32::from(value)).sum::<i32>() != 0
        || moment_rhs.iter().any(|&value| value != 0)
    {
        return false;
    }

    for pivot in 0..14 {
        let Some(row) = (pivot..14).find(|&row| system[row][pivot] != 0) else {
            return false;
        };
        system.swap(pivot, row);
        let inverse = (1_u8..ORDER as u8)
            .find(|&candidate| {
                u16::from(candidate) * u16::from(system[pivot][pivot]) % ORDER as u16 == 1
            })
            .expect("nonzero field element");
        for column in pivot..=14 {
            system[pivot][column] =
                (u16::from(system[pivot][column]) * u16::from(inverse) % ORDER as u16) as u8;
        }
        for row in 0..14 {
            if row == pivot {
                continue;
            }
            let factor = system[row][pivot];
            for column in pivot..=14 {
                system[row][column] = (u16::from(system[row][column]) + ORDER as u16
                    - u16::from(factor) * u16::from(system[pivot][column]) % ORDER as u16)
                    as u8
                    % ORDER as u8;
            }
        }
    }
    let mut positive_522_pairs = 0_i32;
    for representative in 1..=14 {
        let recovered = system[representative - 1][14];
        if recovered != mod_29(i32::from(residual[representative])) || recovered != 0 {
            return false;
        }
        // Divisibility by 18 was checked at the boundary. The recovered zero
        // residue adds divisibility by 29. In [-487,523], only 0 and +522
        // remain; count the latter and let the exact sum eliminate it.
        if residual[representative] == 522 {
            positive_522_pairs += 1;
        } else if residual[representative] != 0 {
            return false;
        }
    }
    positive_522_pairs == 0
}

fn residual_commitment(residual: &[i16; ORDER]) -> [u8; 32] {
    let mut hash = Sha256::new();
    hash.update(EXTRACTOR_ID);
    hash.update(b"q29-moment-crt-sufficiency-v1");
    for value in residual {
        hash.update(value.to_le_bytes());
    }
    hash.finalize().into()
}

#[must_use]
pub fn derive_q29_moment_crt_sufficiency_proof(
    residual: &[i16; ORDER],
) -> Option<Q29MomentCrtSufficiencyProof> {
    replay_q29_moment_crt_sufficiency(residual).then(|| Q29MomentCrtSufficiencyProof {
        descriptor: q29_complete_even_moment_descriptor(),
        residual_commitment: residual_commitment(residual),
        provenance: ProvenanceClass::ProvedStructural,
    })
}

#[must_use]
pub fn replay_q29_moment_crt_sufficiency_proof(
    residual: &[i16; ORDER],
    proof: &Q29MomentCrtSufficiencyProof,
) -> bool {
    proof.descriptor == q29_complete_even_moment_descriptor()
        && proof.residual_commitment == residual_commitment(residual)
        && proof.provenance == ProvenanceClass::ProvedStructural
        && replay_q29_moment_crt_sufficiency(residual)
}

fn rows_commitment(rows: &[[i8; ORDER]; BLOCKS]) -> [u8; 32] {
    let mut hash = Sha256::new();
    hash.update(EXTRACTOR_ID);
    for row in rows {
        for value in row {
            hash.update(value.to_le_bytes());
        }
    }
    hash.finalize().into()
}

/// The proof is sealed to the retained discovery root and canonical extractor.
#[must_use]
pub fn derive_retained_q29_complete_even_moment_proof() -> Q29CompleteEvenMomentProof {
    let rows = retained_q29_y6_root();
    Q29CompleteEvenMomentProof {
        descriptor: q29_complete_even_moment_descriptor(),
        source_commitment: rows_commitment(&rows),
        signature: extract_q29_complete_even_moments(&rows),
        provenance: ProvenanceClass::ProvedStructural,
    }
}

/// Recomputes every theorem-derived field; feature names or serialized values
/// have no authority.
#[must_use]
pub fn replay_retained_q29_complete_even_moment_proof(proof: &Q29CompleteEvenMomentProof) -> bool {
    let rows = retained_q29_y6_root();
    proof.descriptor == q29_complete_even_moment_descriptor()
        && proof.source_commitment == rows_commitment(&rows)
        && proof.provenance == ProvenanceClass::ProvedStructural
        && proof.signature == extract_q29_complete_even_moments(&rows)
}

/// Counts, without allocation, how many legal single swaps each anonymous
/// moment coordinate rejects around the retained root.
#[must_use]
pub fn retained_q29_single_swap_feature_census() -> ([u16; EVEN_MOMENTS], u16) {
    let rows = retained_q29_y6_root();
    let mut excluded = [0_u16; EVEN_MOMENTS];
    let mut legal = 0_u16;
    for block in 0..BLOCKS {
        for left in 0..ORDER {
            for right in left + 1..ORDER {
                if rows[block][left] == rows[block][right] {
                    continue;
                }
                legal += 1;
                let mut candidate = rows;
                candidate[block].swap(left, right);
                let signature = extract_q29_complete_even_moments(&candidate);
                for (count, value) in excluded.iter_mut().zip(signature.values) {
                    *count += u16::from(value != 0);
                }
            }
        }
    }
    (excluded, legal)
}

/// Lets Ergodis select among opaque, theorem-derived coordinates.  The exact
/// target has the all-zero feature vector by the structural theorem; the
/// evolved ranking is diagnostic and never itself grants pruning authority.
#[must_use]
pub fn evolve_retained_q29_anonymous_even_moment() -> Q29AnonymousMomentEvolveReport {
    #[derive(Clone, Copy, Debug, PartialEq, Eq)]
    struct Score {
        false_negatives: u16,
        excluded: u16,
    }

    let (excluded, legal) = retained_q29_single_swap_feature_census();
    let summary = evolve_ranked_streaming(
        0_u8..EVEN_MOMENTS as u8,
        EvolutionConfig {
            generations: 1,
            beam_width: EVEN_MOMENTS,
            max_candidates: EVEN_MOMENTS,
        },
        |_candidate, _output| {},
        |candidate: &u8| Score {
            false_negatives: 0,
            excluded: excluded[usize::from(*candidate)],
        },
        |left, right| {
            left.false_negatives
                .cmp(&right.false_negatives)
                .then_with(|| right.excluded.cmp(&left.excluded))
        },
        |score| score.false_negatives == 0 && score.excluded != 0,
        |_trial| Ok::<_, std::convert::Infallible>(()),
    )
    .expect("bounded infallible anonymous moment evolution");
    let best = summary.best_admitted.expect("a q29 moment rejects a swap");
    Q29AnonymousMomentEvolveReport {
        selected_feature: best.candidate,
        excluded_single_swaps: best.score.excluded,
        legal_single_swaps: legal,
        false_negatives: best.score.false_negatives,
        provenance: ProvenanceClass::ObservedEvolved,
    }
}

fn combined_target_residual(rows: &[[i8; ORDER]; BLOCKS]) -> [i16; ORDER] {
    std::array::from_fn(|shift| {
        let mut correlation = 0_i16;
        for row in rows {
            for point in 0..ORDER {
                correlation += i16::from(row[point]) * i16::from(row[(point + shift) % ORDER]);
            }
        }
        correlation - if shift == 0 { 505 } else { -18 }
    })
}

/// Private adapter for the generic cyclic polynomial-moment miner. It supplies
/// only anonymous target-relative signals, opaque block scopes, and a
/// deterministic train/holdout split. The miner chooses exponents and learns
/// survivor scopes; promotion is restricted afterward to the independently
/// proved even-moment family.
#[must_use]
pub fn mine_retained_q29_single_swap_moments() -> Q29BlindMomentMiningReport {
    let rows = retained_q29_y6_root();
    let mut samples = Vec::<i16>::with_capacity(BLOCKS * ORDER * ORDER * ORDER / 2);
    let mut scopes = Vec::<u8>::with_capacity(BLOCKS * ORDER * ORDER / 2);
    let mut folds = Vec::<u8>::with_capacity(BLOCKS * ORDER * ORDER / 2);
    let mut observation = 0_usize;
    for block in 0..BLOCKS {
        for left in 0..ORDER {
            for right in left + 1..ORDER {
                if rows[block][left] == rows[block][right] {
                    continue;
                }
                let mut candidate = rows;
                candidate[block].swap(left, right);
                samples.extend_from_slice(&combined_target_residual(&candidate));
                scopes.push(block as u8);
                folds.push(((observation + block) & 1) as u8);
                observation += 1;
            }
        }
    }
    let mut moment_workspace = vec![0_u16; observation * MAX_DEGREE];
    let mut live_workspace = vec![0_u8; observation];
    let mut features = [CyclicPolynomialMomentFeature::default(); EVEN_MOMENTS];
    let selected = mine_cyclic_polynomial_zero_chain_into(
        &samples,
        ORDER,
        &scopes,
        &folds,
        ORDER as u16,
        MAX_DEGREE as u8,
        &mut moment_workspace,
        &mut live_workspace,
        &mut features,
    )
    .expect("valid bounded q29 moment corpus");

    let mut report = Q29BlindMomentMiningReport {
        selected_exponents: [0; EVEN_MOMENTS],
        survivor_scopes: [0; EVEN_MOMENTS],
        train_after: [0; EVEN_MOMENTS],
        holdout_after: [0; EVEN_MOMENTS],
        selected: selected as u8,
        promoted: 0,
        observations: observation as u16,
        provenance: ProvenanceClass::ObservedEvolved,
    };
    for (index, feature) in features[..selected].iter().enumerate() {
        report.selected_exponents[index] = feature.exponent;
        report.survivor_scopes[index] = feature.survivor_scope;
        report.train_after[index] = feature.train_after as u16;
        report.holdout_after[index] = feature.holdout_after as u16;
        if feature.exponent >= 2
            && feature.exponent <= MAX_DEGREE as u8
            && feature.exponent & 1 == 0
        {
            report.promoted += 1;
        }
    }
    report
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::allocation_test::tracked_allocations;

    fn direct_paf_moments(rows: &[[i8; ORDER]; BLOCKS]) -> [u8; EVEN_MOMENTS] {
        let mut correlation = [0_i32; ORDER];
        for shift in 0..ORDER {
            for row in rows {
                for point in 0..ORDER {
                    correlation[shift] +=
                        i32::from(row[point]) * i32::from(row[(point + shift) % ORDER]);
                }
            }
        }
        let mut result = [0_u8; EVEN_MOMENTS];
        for (coordinate, output) in result.iter_mut().enumerate() {
            let degree = 2 * (coordinate + 1);
            let mut total = 0_i32;
            for (shift, value) in correlation.iter().copied().enumerate() {
                let mut power = 1_i32;
                for _ in 0..degree {
                    power = power * shift as i32 % ORDER as i32;
                }
                total = i32::from(mod_29(total + i32::from(mod_29(value)) * power));
            }
            *output = mod_29(total);
        }
        result
    }

    #[test]
    fn binomial_extractor_matches_independent_direct_paf_oracle() {
        let mut state = 0x91e1_0da5_c79e_7b1d_u64;
        for _ in 0..256 {
            let mut rows = [[0_i8; ORDER]; BLOCKS];
            for row in &mut rows {
                for value in row {
                    state ^= state << 7;
                    state ^= state >> 9;
                    state ^= state << 8;
                    *value = ((state % 19) as i8) - 9;
                }
            }
            assert_eq!(
                extract_q29_complete_even_moments(&rows).values(),
                direct_paf_moments(&rows)
            );
        }
    }

    #[test]
    fn extreme_i8_boundary_matches_direct_oracle() {
        let rows = std::array::from_fn(|block| {
            std::array::from_fn(|point| {
                if (block + point) & 1 == 0 {
                    i8::MIN
                } else {
                    i8::MAX
                }
            })
        });
        assert_eq!(
            extract_q29_complete_even_moments(&rows).values(),
            direct_paf_moments(&rows)
        );
        assert_eq!(extract_q29_complete_even_moments(&rows).value(14), None);
    }

    #[test]
    fn exact_target_correlation_has_all_thirteen_zero_moments() {
        let mut direct = [0_u8; EVEN_MOMENTS];
        for (coordinate, output) in direct.iter_mut().enumerate() {
            let degree = 2 * (coordinate + 1);
            let mut total = 0_i32;
            for shift in 1..ORDER {
                let mut power = 1_i32;
                for _ in 0..degree {
                    power = power * shift as i32 % ORDER as i32;
                }
                total = i32::from(mod_29(total - 18 * power));
            }
            *output = mod_29(total);
        }
        let mut expected = [0; EVEN_MOMENTS];
        expected[EVEN_MOMENTS - 1] = 18;
        assert_eq!(direct, expected);
    }

    #[test]
    fn extraction_and_single_swap_census_allocate_nothing() {
        let rows = retained_q29_y6_root();
        let ((signature, census), allocations) = tracked_allocations(|| {
            let mut signature = extract_q29_complete_even_moments(&rows);
            for _ in 0..64 {
                signature = std::hint::black_box(extract_q29_complete_even_moments(
                    std::hint::black_box(&rows),
                ));
            }
            assert!(replay_q29_moment_crt_sufficiency(&[0; ORDER]));
            let reconstruction = reconstruct_q29_row0_mod29(&[[0; ORDER]; 3], &[0; 14])
                .expect("bounded fixed reconstruction");
            std::hint::black_box(reconstruction);
            (signature, retained_q29_single_swap_feature_census())
        });
        assert_eq!(allocations, 0);
        assert!(signature.target_mask() <= ALL_MOMENTS_MASK);
        assert!(census.1 > 0);
    }

    #[test]
    fn sealed_proof_recomputes_fields_and_rejects_forgery() {
        let proof = derive_retained_q29_complete_even_moment_proof();
        assert!(replay_retained_q29_complete_even_moment_proof(&proof));

        let mut wrong_value = proof;
        wrong_value.signature.values[0] ^= 1;
        assert!(!replay_retained_q29_complete_even_moment_proof(
            &wrong_value
        ));

        let mut wrong_source = proof;
        wrong_source.source_commitment[0] ^= 1;
        assert!(!replay_retained_q29_complete_even_moment_proof(
            &wrong_source
        ));

        let mut wrong_semantics = proof;
        wrong_semantics.descriptor = ExtractorDescriptor::registered(
            EXTRACTOR_ID,
            EXTRACTOR_VERSION,
            PARAMETER_DIGEST,
            [0; 32],
        );
        assert!(!replay_retained_q29_complete_even_moment_proof(
            &wrong_semantics
        ));
    }

    #[test]
    fn anonymous_evolve_selects_a_safe_reducing_coordinate() {
        let report = evolve_retained_q29_anonymous_even_moment();
        assert!(usize::from(report.selected_feature) < EVEN_MOMENTS);
        assert_eq!(report.false_negatives, 0);
        assert!(report.excluded_single_swaps > 0);
        assert!(report.excluded_single_swaps <= report.legal_single_swaps);
        assert_eq!(report.provenance, ProvenanceClass::ObservedEvolved);
    }

    #[test]
    fn generic_miner_blindly_rediscovers_promotable_exponents_and_scopes() {
        let first = mine_retained_q29_single_swap_moments();
        let second = mine_retained_q29_single_swap_moments();
        assert_eq!(first, second);
        assert!(first.selected > 0);
        assert_eq!(first.promoted, first.selected);
        assert!(first.observations > 0);
        for index in 0..usize::from(first.selected) {
            assert!(first.selected_exponents[index] >= 2);
            assert_eq!(first.selected_exponents[index] & 1, 0);
            assert!(first.survivor_scopes[index] < 1_u64 << BLOCKS);
        }
    }

    #[test]
    fn vandermonde_crt_sufficiency_accepts_zero_and_rejects_missing_hypotheses() {
        let zero = [0; ORDER];
        assert!(replay_q29_moment_crt_sufficiency(&zero));
        let proof = derive_q29_moment_crt_sufficiency_proof(&zero).unwrap();
        assert!(replay_q29_moment_crt_sufficiency_proof(&zero, &proof));
        let mut forged = proof;
        forged.residual_commitment[0] ^= 1;
        assert!(!replay_q29_moment_crt_sufficiency_proof(&zero, &forged));

        let mut missing_mod18 = [0_i16; ORDER];
        missing_mod18[1] = 29;
        missing_mod18[ORDER - 1] = 29;
        missing_mod18[2] = -29;
        missing_mod18[ORDER - 2] = -29;
        assert!(!replay_q29_moment_crt_sufficiency(&missing_mod18));

        let mut missing_sum = [0_i16; ORDER];
        missing_sum[1] = 522;
        missing_sum[ORDER - 1] = 522;
        assert!(!replay_q29_moment_crt_sufficiency(&missing_sum));

        let mut missing_bound = [0_i16; ORDER];
        missing_bound[1] = 522;
        missing_bound[ORDER - 1] = 522;
        missing_bound[2] = -522;
        missing_bound[ORDER - 2] = -522;
        assert!(!replay_q29_moment_crt_sufficiency(&missing_bound));

        let mut asymmetric = [0_i16; ORDER];
        asymmetric[1] = 522;
        asymmetric[2] = -522;
        assert!(!replay_q29_moment_crt_sufficiency(&asymmetric));

        let mut missing_moment = [0_i16; ORDER];
        missing_moment[1] = 18;
        missing_moment[ORDER - 1] = 18;
        missing_moment[2] = -18;
        missing_moment[ORDER - 2] = -18;
        assert!(!replay_q29_moment_crt_sufficiency(&missing_moment));
    }

    #[test]
    fn triangular_recurrence_matches_direct_moment_residual_and_detects_forgery() {
        let rows = retained_q29_y6_root();
        let recurrence = derive_q29_row0_even_moment_recurrence(&rows).unwrap();
        let signature = extract_q29_complete_even_moments(&rows);
        for coordinate in 0..EVEN_MOMENTS {
            let target = if coordinate + 1 == EVEN_MOMENTS {
                18
            } else {
                0
            };
            assert_eq!(
                signature.values()[coordinate],
                mod_29(
                    2 * (i32::from(recurrence.actual()[coordinate])
                        - i32::from(recurrence.derived()[coordinate]))
                        + target
                )
            );
        }
        let mut forged = recurrence;
        forged.derived[0] ^= 1;
        assert_ne!(forged.derived(), recurrence.derived());

        let mut wrong_sums = rows;
        wrong_sums[1][0] += 1;
        assert!(derive_q29_row0_even_moment_recurrence(&wrong_sums).is_none());
    }

    #[test]
    fn row0_reconstruction_closes_the_triangular_vandermonde_endgame() {
        let other_rows = [[0_i8; ORDER]; 3];
        let antisymmetric = [0_i8; 14];
        let residues = reconstruct_q29_row0_mod29(&other_rows, &antisymmetric).unwrap();
        let mut rows = [[0_i8; ORDER]; BLOCKS];
        rows[0] = residues.map(|value| value as i8);
        assert!(extract_q29_complete_even_moments(&rows).accepts_exact_target());
        let row0_sum = rows[0].iter().map(|&value| i32::from(value)).sum::<i32>();
        assert_eq!(mod_29(row0_sum), 1);
        let m28 = rows[0]
            .iter()
            .enumerate()
            .map(|(point, &value)| i32::from(value) * i32::from(POINT_POWERS_MOD_29[point][28]))
            .sum::<i32>();
        assert_eq!(mod_29(m28), mod_29(1 - i32::from(rows[0][0])));
        for representative in 1..=14 {
            assert_eq!(
                mod_29(
                    i32::from(rows[0][representative]) - i32::from(rows[0][ORDER - representative])
                ),
                0
            );
        }

        let mut forged = residues;
        forged[1] = (forged[1] + 1) % ORDER as u8;
        rows[0] = forged.map(|value| value as i8);
        assert!(!extract_q29_complete_even_moments(&rows).accepts_exact_target());

        assert!(lift_q29_row0_to_minus9_9(&[10; ORDER]).is_none());
        let mut lift_boundaries = [0_u8; ORDER];
        lift_boundaries[0] = 9;
        lift_boundaries[1] = 20;
        let lifted = lift_q29_row0_to_minus9_9(&lift_boundaries).unwrap();
        assert_eq!((lifted[0], lifted[1]), (9, -9));
    }
}
