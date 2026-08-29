//! Certified coordinate-orbit covers for nonempty-support optimization.
//!
//! This module compiles the backend-neutral part of first-support symmetry
//! breaking.  It certifies coordinate orbits only.  A domain adapter remains
//! responsible for proving that its feasible family and objective are
//! invariant under the supplied action and that feasible supports are nonempty.

use crate::group_action::{
    compile_permutation_orbits, verify_permutation_orbits, FinitePermutationAction,
    OrbitCompileError, OrbitPartition, OrbitStorage,
};
use std::io::Write;
use thiserror::Error;

/// One external-solver subproblem, anchored at a canonical coordinate.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct AnchoredSupportSubproblem {
    orbit: u32,
    anchor: u32,
}

const _: () = assert!(std::mem::size_of::<AnchoredSupportSubproblem>() == 8);
const _: () = assert!(std::mem::align_of::<AnchoredSupportSubproblem>() == 4);

impl AnchoredSupportSubproblem {
    pub fn orbit(self) -> u32 {
        self.orbit
    }

    /// Coordinate whose support variable must be fixed to one.
    pub fn anchor(self) -> u32 {
        self.anchor
    }
}

/// A replayable cover of every nonempty support by anchored subproblems.
///
/// If a domain's feasible supports and objective are invariant under the
/// supplied action, optimizing once for each returned anchor is exact.  This
/// type deliberately does not claim or encode that domain-specific premise.
#[derive(Debug)]
pub struct NonemptySupportOrbitCover {
    partition: OrbitPartition,
}

impl NonemptySupportOrbitCover {
    pub fn point_count(&self) -> u32 {
        self.partition.point_orbits().len() as u32
    }

    pub fn subproblem_count(&self) -> u32 {
        self.partition.representatives().len() as u32
    }

    pub fn anchors(&self) -> &[u32] {
        self.partition.representatives()
    }

    /// Return the anchored subproblem covering a support containing `point`.
    pub fn subproblem_for_point(&self, point: u32) -> Option<AnchoredSupportSubproblem> {
        let orbit = self.partition.orbit(point)?;
        let anchor = self.partition.representative(point)?;
        Some(AnchoredSupportSubproblem { orbit, anchor })
    }

    /// Iterate without allocating over the external-solver requests.
    pub fn subproblems(&self) -> impl ExactSizeIterator<Item = AnchoredSupportSubproblem> + '_ {
        self.partition
            .representatives()
            .iter()
            .copied()
            .enumerate()
            .map(|(orbit, anchor)| AnchoredSupportSubproblem {
                orbit: orbit as u32,
                anchor,
            })
    }

    pub fn storage(&self) -> OrbitStorage {
        self.partition.storage()
    }
}

/// Compile and immediately replay a coordinate-orbit cover.
pub fn compile_nonempty_support_orbit_cover<A: FinitePermutationAction>(
    action: &A,
) -> Result<NonemptySupportOrbitCover, OrbitCompileError<A::Error>> {
    let partition = compile_permutation_orbits(action)?;
    Ok(NonemptySupportOrbitCover { partition })
}

/// Independently replay the permutation and orbit-coverage certificate.
pub fn verify_nonempty_support_orbit_cover<A: FinitePermutationAction>(
    action: &A,
    cover: &NonemptySupportOrbitCover,
) -> Result<(), OrbitCompileError<A::Error>> {
    verify_permutation_orbits(action, &cover.partition)
}

/// One feasible support and its exact objective value.
#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BinarySupportCandidate {
    support: u64,
    cost: u64,
}

const _: () = assert!(std::mem::size_of::<BinarySupportCandidate>() == 16);
const _: () = assert!(std::mem::align_of::<BinarySupportCandidate>() == 8);

impl BinarySupportCandidate {
    pub const fn new(support: u64, cost: u64) -> Self {
        Self { support, cost }
    }

    pub fn support(self) -> u64 {
        self.support
    }

    pub fn cost(self) -> u64 {
        self.cost
    }
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum ExplicitBinarySupportError {
    #[error("explicit binary support models are limited to 64 coordinates")]
    Shape,
    #[error("feasible candidate {candidate} has empty support")]
    EmptySupport { candidate: u32 },
    #[error("feasible candidate {candidate} has a coordinate outside the model")]
    SupportOutOfRange { candidate: u32 },
    #[error("explicit binary support {support:#x} occurs more than once")]
    DuplicateSupport { support: u64 },
}

/// A small, exhaustively checkable semantic model used to test the trust
/// boundary before admitting theorem-specific domain adapters.
#[derive(Debug)]
pub struct ExplicitBinarySupportProblem {
    point_count: u8,
    candidates: Box<[BinarySupportCandidate]>,
}

impl ExplicitBinarySupportProblem {
    pub fn new(
        point_count: u32,
        mut candidates: Vec<BinarySupportCandidate>,
    ) -> Result<Self, ExplicitBinarySupportError> {
        if point_count > 64 {
            return Err(ExplicitBinarySupportError::Shape);
        }
        let valid_mask = if point_count == 64 {
            u64::MAX
        } else {
            (1_u64 << point_count) - 1
        };
        for (candidate, entry) in candidates.iter().enumerate() {
            if entry.support == 0 {
                return Err(ExplicitBinarySupportError::EmptySupport {
                    candidate: candidate as u32,
                });
            }
            if entry.support & !valid_mask != 0 {
                return Err(ExplicitBinarySupportError::SupportOutOfRange {
                    candidate: candidate as u32,
                });
            }
        }
        candidates.sort_unstable_by_key(|candidate| candidate.support);
        for pair in candidates.windows(2) {
            if pair[0].support == pair[1].support {
                return Err(ExplicitBinarySupportError::DuplicateSupport {
                    support: pair[0].support,
                });
            }
        }
        Ok(Self {
            point_count: point_count as u8,
            candidates: candidates.into_boxed_slice(),
        })
    }

    pub fn point_count(&self) -> u32 {
        u32::from(self.point_count)
    }

    pub fn candidates(&self) -> &[BinarySupportCandidate] {
        &self.candidates
    }

    pub fn direct_minimum(&self) -> Option<BinarySupportCandidate> {
        self.candidates
            .iter()
            .copied()
            .min_by_key(|candidate| (candidate.cost, candidate.support))
    }

    /// Stable non-cryptographic identity for the exact explicit model.
    pub fn fingerprint(&self) -> SemanticModelFingerprint {
        let mut hash = [0xcbf2_9ce4_8422_2325_u64, 0x6c62_272e_07bb_0142_u64];
        semantic_fingerprint_word(&mut hash, 0x4553_4250);
        semantic_fingerprint_word(&mut hash, 1);
        semantic_fingerprint_word(&mut hash, u64::from(self.point_count()));
        semantic_fingerprint_word(&mut hash, self.candidates.len() as u64);
        for candidate in &self.candidates {
            semantic_fingerprint_word(&mut hash, candidate.support);
            semantic_fingerprint_word(&mut hash, candidate.cost);
        }
        SemanticModelFingerprint {
            low: hash[0],
            high: hash[1],
        }
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct SemanticModelFingerprint {
    low: u64,
    high: u64,
}

const _: () = assert!(std::mem::size_of::<SemanticModelFingerprint>() == 16);
const _: () = assert!(std::mem::align_of::<SemanticModelFingerprint>() == 8);

impl SemanticModelFingerprint {
    pub fn low(self) -> u64 {
        self.low
    }

    pub fn high(self) -> u64 {
        self.high
    }
}

fn semantic_fingerprint_word(hash: &mut [u64; 2], word: u64) {
    for byte in word.to_le_bytes() {
        hash[0] ^= u64::from(byte);
        hash[0] = hash[0].wrapping_mul(0x0000_0100_0000_01b3);
        hash[1] ^= u64::from(byte).wrapping_add(0x9d);
        hash[1] = hash[1].wrapping_mul(0x0000_0100_0000_01e7);
    }
}

#[derive(Debug, Error)]
pub enum ExplicitSupportSymmetryError<E> {
    #[error(transparent)]
    Orbit(#[from] OrbitCompileError<E>),
    #[error("the semantic model and coordinate action have different point counts")]
    PointCount,
    #[error("generator {generator} failed on coordinate {point}")]
    Action {
        generator: u32,
        point: u32,
        error: E,
    },
    #[error("generator {generator} mapped coordinate {point} outside the model")]
    Target {
        generator: u32,
        point: u32,
        target: u32,
    },
    #[error(
        "generator {generator} maps feasible support {support:#x} to absent support {image:#x}"
    )]
    MissingImage {
        generator: u32,
        support: u64,
        image: u64,
    },
    #[error(
        "generator {generator} changes the cost of support {support:#x} from {cost} to {image_cost}"
    )]
    CostChanged {
        generator: u32,
        support: u64,
        cost: u64,
        image_cost: u64,
    },
}

/// A consumed semantic model whose nonempty-support and generator-invariance
/// obligations have both been checked.
#[derive(Debug)]
pub struct VerifiedExplicitBinarySupportProblem {
    problem: ExplicitBinarySupportProblem,
    cover: NonemptySupportOrbitCover,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct AnchoredBinarySupportOptimum {
    candidate: BinarySupportCandidate,
    subproblem: AnchoredSupportSubproblem,
}

#[derive(Debug, Error)]
pub enum AnchoredModelWriteError {
    #[error("the requested anchored subproblem is not in the certified cover")]
    Subproblem,
    #[error("the anchored model could not be written")]
    Io(#[from] std::io::Error),
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct AnchoredBackendResult {
    fingerprint: SemanticModelFingerprint,
    support: u64,
    cost: u64,
    orbit: u32,
    anchor: u32,
    candidate: u32,
    _reserved: u32,
}

const _: () = assert!(std::mem::size_of::<AnchoredBackendResult>() == 48);
const _: () = assert!(std::mem::align_of::<AnchoredBackendResult>() == 8);

impl AnchoredBackendResult {
    pub fn new(
        fingerprint: SemanticModelFingerprint,
        subproblem: AnchoredSupportSubproblem,
        candidate: u32,
        support: u64,
        cost: u64,
    ) -> Self {
        Self {
            fingerprint,
            support,
            cost,
            orbit: subproblem.orbit,
            anchor: subproblem.anchor,
            candidate,
            _reserved: 0,
        }
    }

    pub fn fingerprint(self) -> SemanticModelFingerprint {
        self.fingerprint
    }

    pub fn subproblem(self) -> AnchoredSupportSubproblem {
        AnchoredSupportSubproblem {
            orbit: self.orbit,
            anchor: self.anchor,
        }
    }

    pub fn candidate(self) -> u32 {
        self.candidate
    }

    pub fn support(self) -> u64 {
        self.support
    }

    pub fn cost(self) -> u64 {
        self.cost
    }
}

#[derive(Clone, Copy, Debug, Error, PartialEq, Eq)]
pub enum AnchoredBackendResultError {
    #[error("the backend result is bound to a different semantic model")]
    Fingerprint,
    #[error("the backend result names a noncanonical anchored subproblem")]
    Subproblem,
    #[error("the backend result names an unknown candidate")]
    Candidate,
    #[error("the backend result's support or cost does not match its candidate")]
    Claim,
    #[error("the backend result's candidate does not satisfy the anchor")]
    Anchor,
    #[error("the backend result is feasible but is not the exact anchored optimum")]
    Optimality,
    #[error("a feasible anchored subproblem has no backend result")]
    MissingSubproblem,
    #[error("an anchored subproblem has more than one backend result")]
    DuplicateSubproblem,
}

impl AnchoredBinarySupportOptimum {
    pub fn candidate(self) -> BinarySupportCandidate {
        self.candidate
    }

    pub fn subproblem(self) -> AnchoredSupportSubproblem {
        self.subproblem
    }
}

impl VerifiedExplicitBinarySupportProblem {
    pub fn problem(&self) -> &ExplicitBinarySupportProblem {
        &self.problem
    }

    pub fn cover(&self) -> &NonemptySupportOrbitCover {
        &self.cover
    }

    pub fn fingerprint(&self) -> SemanticModelFingerprint {
        let source = self.problem.fingerprint();
        let mut hash = [0xcbf2_9ce4_8422_2325_u64, 0x6c62_272e_07bb_0142_u64];
        semantic_fingerprint_word(&mut hash, 0x4553_4252);
        semantic_fingerprint_word(&mut hash, 1);
        semantic_fingerprint_word(&mut hash, source.low);
        semantic_fingerprint_word(&mut hash, source.high);
        semantic_fingerprint_word(&mut hash, self.cover.point_count().into());
        semantic_fingerprint_word(&mut hash, self.cover.subproblem_count().into());
        for &orbit in self.cover.partition.point_orbits() {
            semantic_fingerprint_word(&mut hash, u64::from(orbit));
        }
        for &anchor in self.cover.anchors() {
            semantic_fingerprint_word(&mut hash, u64::from(anchor));
        }
        SemanticModelFingerprint {
            low: hash[0],
            high: hash[1],
        }
    }

    /// Independently replay both the generic orbit certificate and the
    /// explicit domain-invariance obligation.
    pub fn verify<A: FinitePermutationAction>(
        &self,
        action: &A,
    ) -> Result<(), ExplicitSupportSymmetryError<A::Error>> {
        if action.point_count() != self.problem.point_count() {
            return Err(ExplicitSupportSymmetryError::PointCount);
        }
        verify_nonempty_support_orbit_cover(action, &self.cover)?;
        verify_explicit_binary_support_invariance(action, &self.problem)
    }

    /// Mimic independent backend solves, one per anchor, without allocating.
    pub fn anchored_minimum(&self) -> Option<AnchoredBinarySupportOptimum> {
        let mut best = None;
        for subproblem in self.cover.subproblems() {
            let anchor_bit = 1_u64 << subproblem.anchor();
            let local = self
                .problem
                .candidates
                .iter()
                .copied()
                .filter(|candidate| candidate.support & anchor_bit != 0)
                .min_by_key(|candidate| (candidate.cost, candidate.support));
            let Some(candidate) = local else {
                continue;
            };
            let answer = AnchoredBinarySupportOptimum {
                candidate,
                subproblem,
            };
            if best.is_none_or(|current: AnchoredBinarySupportOptimum| {
                (candidate.cost, candidate.support, subproblem.orbit)
                    < (
                        current.candidate.cost,
                        current.candidate.support,
                        current.subproblem.orbit,
                    )
            }) {
                best = Some(answer);
            }
        }
        best
    }

    /// Stream a deterministic LP model for one certified anchor.
    ///
    /// Candidate variable `z_i` selects the `i`th canonical explicit support.
    /// A fixed-zero dummy makes even an infeasible anchor syntactically valid.
    pub fn write_anchored_lp<W: Write + ?Sized>(
        &self,
        subproblem: AnchoredSupportSubproblem,
        writer: &mut W,
    ) -> Result<(), AnchoredModelWriteError> {
        self.validate_subproblem(subproblem)
            .ok_or(AnchoredModelWriteError::Subproblem)?;
        let fingerprint = self.fingerprint();
        writeln!(writer, "\\ Ergodis explicit-support LP v1")?;
        writeln!(
            writer,
            "\\ fingerprint {:016x}{:016x}",
            fingerprint.high, fingerprint.low
        )?;
        writeln!(
            writer,
            "\\ orbit {} anchor {}",
            subproblem.orbit, subproblem.anchor
        )?;
        writeln!(writer, "Minimize")?;
        write!(writer, " obj: 0 dummy")?;
        for (candidate, entry) in self.problem.candidates.iter().enumerate() {
            write!(writer, " + {} z_{}", entry.cost, candidate)?;
        }
        writeln!(writer)?;
        writeln!(writer, "Subject To")?;
        write!(writer, " choose_one: dummy")?;
        for candidate in 0..self.problem.candidates.len() {
            write!(writer, " + z_{candidate}")?;
        }
        writeln!(writer, " = 1")?;
        writeln!(writer, " fix_dummy: dummy = 0")?;
        write!(writer, " anchor_hit: dummy")?;
        let anchor_bit = 1_u64 << subproblem.anchor;
        for (candidate, entry) in self.problem.candidates.iter().enumerate() {
            if entry.support & anchor_bit != 0 {
                write!(writer, " + z_{candidate}")?;
            }
        }
        writeln!(writer, " = 1")?;
        writeln!(writer, "Binary")?;
        writeln!(writer, " dummy")?;
        for candidate in 0..self.problem.candidates.len() {
            writeln!(writer, " z_{candidate}")?;
        }
        writeln!(writer, "End")?;
        Ok(())
    }

    /// Construct the exact small-model result corresponding to a candidate.
    /// External adapters should populate the same record from solver output.
    pub fn backend_result(
        &self,
        subproblem: AnchoredSupportSubproblem,
        candidate: u32,
    ) -> Option<AnchoredBackendResult> {
        self.validate_subproblem(subproblem)?;
        let entry = *self.problem.candidates.get(candidate as usize)?;
        Some(AnchoredBackendResult::new(
            self.fingerprint(),
            subproblem,
            candidate,
            entry.support,
            entry.cost,
        ))
    }

    /// Replay model identity, feasibility, objective, and exact small-model
    /// optimality without trusting the external backend.
    pub fn verify_backend_result(
        &self,
        result: AnchoredBackendResult,
    ) -> Result<BinarySupportCandidate, AnchoredBackendResultError> {
        if result._reserved != 0 || result.fingerprint != self.fingerprint() {
            return Err(AnchoredBackendResultError::Fingerprint);
        }
        let subproblem = result.subproblem();
        self.validate_subproblem(subproblem)
            .ok_or(AnchoredBackendResultError::Subproblem)?;
        let candidate = *self
            .problem
            .candidates
            .get(result.candidate as usize)
            .ok_or(AnchoredBackendResultError::Candidate)?;
        if candidate.support != result.support || candidate.cost != result.cost {
            return Err(AnchoredBackendResultError::Claim);
        }
        if candidate.support & (1_u64 << subproblem.anchor) == 0 {
            return Err(AnchoredBackendResultError::Anchor);
        }
        let optimum = self
            .anchored_candidate(subproblem)
            .ok_or(AnchoredBackendResultError::Optimality)?;
        if candidate != optimum {
            return Err(AnchoredBackendResultError::Optimality);
        }
        Ok(candidate)
    }

    /// Replay a complete set of independent anchored solves and return the
    /// exact global optimum. Infeasible anchors have no result record and are
    /// checked directly against the bounded explicit model.
    pub fn verify_complete_backend_results(
        &self,
        results: &[AnchoredBackendResult],
    ) -> Result<Option<AnchoredBinarySupportOptimum>, AnchoredBackendResultError> {
        for &result in results {
            self.verify_backend_result(result)?;
        }
        let mut global = None;
        for subproblem in self.cover.subproblems() {
            let mut matches = results
                .iter()
                .copied()
                .filter(|result| result.subproblem() == subproblem);
            let first = matches.next();
            if matches.next().is_some() {
                return Err(AnchoredBackendResultError::DuplicateSubproblem);
            }
            let local = self.anchored_candidate(subproblem);
            match (local, first) {
                (Some(_), None) => return Err(AnchoredBackendResultError::MissingSubproblem),
                (None, Some(_)) => return Err(AnchoredBackendResultError::Optimality),
                (None, None) => {}
                (Some(candidate), Some(_)) => {
                    let answer = AnchoredBinarySupportOptimum {
                        candidate,
                        subproblem,
                    };
                    if global.is_none_or(|current: AnchoredBinarySupportOptimum| {
                        (candidate.cost, candidate.support, subproblem.orbit)
                            < (
                                current.candidate.cost,
                                current.candidate.support,
                                current.subproblem.orbit,
                            )
                    }) {
                        global = Some(answer);
                    }
                }
            }
        }
        Ok(global)
    }

    fn validate_subproblem(
        &self,
        subproblem: AnchoredSupportSubproblem,
    ) -> Option<AnchoredSupportSubproblem> {
        self.cover
            .subproblems()
            .find(|&candidate| candidate == subproblem)
    }

    fn anchored_candidate(
        &self,
        subproblem: AnchoredSupportSubproblem,
    ) -> Option<BinarySupportCandidate> {
        let anchor_bit = 1_u64 << subproblem.anchor;
        self.problem
            .candidates
            .iter()
            .copied()
            .filter(|candidate| candidate.support & anchor_bit != 0)
            .min_by_key(|candidate| (candidate.cost, candidate.support))
    }
}

/// Consume a small explicit model only after checking every semantic premise
/// needed by the orbit-cover theorem.
pub fn compile_verified_explicit_binary_support<A: FinitePermutationAction>(
    action: &A,
    problem: ExplicitBinarySupportProblem,
) -> Result<VerifiedExplicitBinarySupportProblem, ExplicitSupportSymmetryError<A::Error>> {
    if action.point_count() != problem.point_count() {
        return Err(ExplicitSupportSymmetryError::PointCount);
    }
    let cover = compile_nonempty_support_orbit_cover(action)?;
    verify_explicit_binary_support_invariance(action, &problem)?;
    Ok(VerifiedExplicitBinarySupportProblem { problem, cover })
}

pub fn verify_explicit_binary_support_invariance<A: FinitePermutationAction>(
    action: &A,
    problem: &ExplicitBinarySupportProblem,
) -> Result<(), ExplicitSupportSymmetryError<A::Error>> {
    if action.point_count() != problem.point_count() {
        return Err(ExplicitSupportSymmetryError::PointCount);
    }
    for generator in 0..action.generator_count() {
        for candidate in &problem.candidates {
            let mut source = candidate.support;
            let mut image = 0_u64;
            while source != 0 {
                let point = source.trailing_zeros();
                source &= source - 1;
                let target = action.apply(generator, point).map_err(|error| {
                    ExplicitSupportSymmetryError::Action {
                        generator,
                        point,
                        error,
                    }
                })?;
                if target >= problem.point_count() {
                    return Err(ExplicitSupportSymmetryError::Target {
                        generator,
                        point,
                        target,
                    });
                }
                image |= 1_u64 << target;
            }
            let image_index = problem
                .candidates
                .binary_search_by_key(&image, |entry| entry.support)
                .map_err(|_| ExplicitSupportSymmetryError::MissingImage {
                    generator,
                    support: candidate.support,
                    image,
                })?;
            let image_cost = problem.candidates[image_index].cost;
            if image_cost != candidate.cost {
                return Err(ExplicitSupportSymmetryError::CostChanged {
                    generator,
                    support: candidate.support,
                    cost: candidate.cost,
                    image_cost,
                });
            }
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::convert::Infallible;

    /// Product translations on repeated coordinate blocks.
    struct ProductTranslation {
        width: u32,
        height: u32,
        blocks: u32,
    }

    struct TableAction<const N: usize, const G: usize>([[u32; N]; G]);

    impl<const N: usize, const G: usize> FinitePermutationAction for TableAction<N, G> {
        type Error = Infallible;

        fn point_count(&self) -> u32 {
            N as u32
        }

        fn generator_count(&self) -> u32 {
            G as u32
        }

        fn apply(&self, generator: u32, point: u32) -> Result<u32, Self::Error> {
            Ok(self.0[generator as usize][point as usize])
        }
    }

    impl FinitePermutationAction for ProductTranslation {
        type Error = Infallible;

        fn point_count(&self) -> u32 {
            self.width * self.height * self.blocks
        }

        fn generator_count(&self) -> u32 {
            2
        }

        fn apply(&self, generator: u32, point: u32) -> Result<u32, Self::Error> {
            let block_size = self.width * self.height;
            let block = point / block_size;
            let local = point % block_size;
            let x = local % self.width;
            let y = local / self.width;
            let (next_x, next_y) = match generator {
                0 => ((x + 1) % self.width, y),
                1 => (x, (y + 1) % self.height),
                _ => unreachable!(),
            };
            Ok(block * block_size + next_y * self.width + next_x)
        }
    }

    #[test]
    fn gross_translation_shape_compiles_to_two_anchors() {
        let action = ProductTranslation {
            width: 12,
            height: 6,
            blocks: 2,
        };
        let cover = compile_nonempty_support_orbit_cover(&action).unwrap();

        assert_eq!(cover.point_count(), 144);
        assert_eq!(cover.subproblem_count(), 2);
        assert_eq!(cover.anchors(), &[0, 72]);
        assert_eq!(cover.subproblems().len(), 2);
        assert_eq!(cover.subproblem_for_point(71).unwrap().anchor(), 0);
        assert_eq!(cover.subproblem_for_point(143).unwrap().anchor(), 72);
        assert_eq!(cover.subproblem_for_point(144), None);
        verify_nonempty_support_orbit_cover(&action, &cover).unwrap();
    }

    #[test]
    fn anchor_iteration_uses_flat_canonical_records() {
        let action = ProductTranslation {
            width: 3,
            height: 2,
            blocks: 3,
        };
        let cover = compile_nonempty_support_orbit_cover(&action).unwrap();
        let mut expected_orbit = 0;
        let mut expected_anchor = 0;
        for subproblem in cover.subproblems() {
            assert_eq!(subproblem.orbit(), expected_orbit);
            assert_eq!(subproblem.anchor(), expected_anchor);
            expected_orbit += 1;
            expected_anchor += 6;
        }
        assert_eq!(expected_orbit, 3);
    }

    #[test]
    fn verified_binary_model_matches_direct_and_anchored_minima() {
        let action = TableAction([[1, 2, 0]]);
        let candidates = vec![
            BinarySupportCandidate::new(0b001, 7),
            BinarySupportCandidate::new(0b010, 7),
            BinarySupportCandidate::new(0b100, 7),
            BinarySupportCandidate::new(0b011, 9),
            BinarySupportCandidate::new(0b110, 9),
            BinarySupportCandidate::new(0b101, 9),
            BinarySupportCandidate::new(0b111, 11),
        ];
        let problem = ExplicitBinarySupportProblem::new(3, candidates).unwrap();
        let verified = compile_verified_explicit_binary_support(&action, problem).unwrap();

        assert_eq!(verified.cover().anchors(), &[0]);
        assert_eq!(
            verified.problem().direct_minimum(),
            Some(BinarySupportCandidate::new(0b001, 7))
        );
        let anchored = verified.anchored_minimum().unwrap();
        assert_eq!(
            anchored.candidate(),
            verified.problem().direct_minimum().unwrap()
        );
        assert_eq!(anchored.subproblem().anchor(), 0);
        verified.verify(&action).unwrap();

        let corrupted_action = TableAction([[0, 1, 2]]);
        assert!(verified.verify(&corrupted_action).is_err());
    }

    #[test]
    fn explicit_model_rejects_empty_out_of_range_and_duplicate_supports() {
        assert_eq!(
            ExplicitBinarySupportProblem::new(2, vec![BinarySupportCandidate::new(0, 1)])
                .unwrap_err(),
            ExplicitBinarySupportError::EmptySupport { candidate: 0 }
        );
        assert_eq!(
            ExplicitBinarySupportProblem::new(2, vec![BinarySupportCandidate::new(0b100, 1)])
                .unwrap_err(),
            ExplicitBinarySupportError::SupportOutOfRange { candidate: 0 }
        );
        assert_eq!(
            ExplicitBinarySupportProblem::new(
                2,
                vec![
                    BinarySupportCandidate::new(0b01, 1),
                    BinarySupportCandidate::new(0b01, 2),
                ],
            )
            .unwrap_err(),
            ExplicitBinarySupportError::DuplicateSupport { support: 0b01 }
        );
    }

    #[test]
    fn invariance_verifier_rejects_missing_images_and_changed_costs() {
        let swap = TableAction([[1, 0]]);
        let missing =
            ExplicitBinarySupportProblem::new(2, vec![BinarySupportCandidate::new(0b01, 1)])
                .unwrap();
        assert!(matches!(
            compile_verified_explicit_binary_support(&swap, missing),
            Err(ExplicitSupportSymmetryError::MissingImage {
                generator: 0,
                support: 0b01,
                image: 0b10,
            })
        ));

        let changed = ExplicitBinarySupportProblem::new(
            2,
            vec![
                BinarySupportCandidate::new(0b01, 1),
                BinarySupportCandidate::new(0b10, 2),
            ],
        )
        .unwrap();
        assert!(matches!(
            compile_verified_explicit_binary_support(&swap, changed),
            Err(ExplicitSupportSymmetryError::CostChanged {
                generator: 0,
                support: 0b01,
                cost: 1,
                image_cost: 2,
            })
        ));
    }

    #[test]
    fn semantic_compiler_rejects_a_nonpermutation_before_domain_checks() {
        let malformed = TableAction([[0, 0]]);
        let problem =
            ExplicitBinarySupportProblem::new(2, vec![BinarySupportCandidate::new(0b01, 1)])
                .unwrap();
        assert!(matches!(
            compile_verified_explicit_binary_support(&malformed, problem),
            Err(ExplicitSupportSymmetryError::Orbit(
                OrbitCompileError::NotPermutation { .. }
            ))
        ));
    }

    #[test]
    fn anchored_lp_is_deterministic_and_streamed() {
        let action = TableAction([[1, 2, 0]]);
        let problem = ExplicitBinarySupportProblem::new(
            3,
            vec![
                BinarySupportCandidate::new(0b100, 7),
                BinarySupportCandidate::new(0b001, 7),
                BinarySupportCandidate::new(0b010, 7),
                BinarySupportCandidate::new(0b111, 11),
            ],
        )
        .unwrap();
        let verified = compile_verified_explicit_binary_support(&action, problem).unwrap();
        let subproblem = verified.cover().subproblems().next().unwrap();
        let mut bytes = Vec::new();
        verified.write_anchored_lp(subproblem, &mut bytes).unwrap();
        let text = String::from_utf8(bytes).unwrap();
        let fingerprint = verified.fingerprint();
        let expected = format!(
            "\\ Ergodis explicit-support LP v1\n\\ fingerprint {:016x}{:016x}\n\\ orbit 0 anchor 0\nMinimize\n obj: 0 dummy + 7 z_0 + 7 z_1 + 7 z_2 + 11 z_3\nSubject To\n choose_one: dummy + z_0 + z_1 + z_2 + z_3 = 1\n fix_dummy: dummy = 0\n anchor_hit: dummy + z_0 + z_3 = 1\nBinary\n dummy\n z_0\n z_1\n z_2\n z_3\nEnd\n",
            fingerprint.high(),
            fingerprint.low()
        );
        assert_eq!(text, expected);

        let invalid = AnchoredSupportSubproblem {
            orbit: 0,
            anchor: 1,
        };
        assert!(matches!(
            verified.write_anchored_lp(invalid, &mut Vec::new()),
            Err(AnchoredModelWriteError::Subproblem)
        ));
    }

    #[test]
    fn backend_result_replay_rejects_identity_claim_and_optimality_corruption() {
        let action = TableAction([[1, 2, 0]]);
        let problem = ExplicitBinarySupportProblem::new(
            3,
            vec![
                BinarySupportCandidate::new(0b001, 7),
                BinarySupportCandidate::new(0b010, 7),
                BinarySupportCandidate::new(0b100, 7),
                BinarySupportCandidate::new(0b011, 9),
                BinarySupportCandidate::new(0b110, 9),
                BinarySupportCandidate::new(0b101, 9),
            ],
        )
        .unwrap();
        let verified = compile_verified_explicit_binary_support(&action, problem).unwrap();
        let subproblem = verified.cover().subproblems().next().unwrap();
        let result = verified.backend_result(subproblem, 0).unwrap();
        assert_eq!(
            verified.verify_backend_result(result).unwrap(),
            BinarySupportCandidate::new(0b001, 7)
        );
        assert_eq!(
            verified
                .verify_complete_backend_results(&[result])
                .unwrap()
                .unwrap()
                .candidate(),
            BinarySupportCandidate::new(0b001, 7)
        );
        assert_eq!(
            verified.verify_complete_backend_results(&[]),
            Err(AnchoredBackendResultError::MissingSubproblem)
        );
        assert_eq!(
            verified.verify_complete_backend_results(&[result, result]),
            Err(AnchoredBackendResultError::DuplicateSubproblem)
        );

        let mut wrong_fingerprint = result;
        wrong_fingerprint.fingerprint.low ^= 1;
        assert_eq!(
            verified.verify_backend_result(wrong_fingerprint),
            Err(AnchoredBackendResultError::Fingerprint)
        );

        let mut wrong_claim = result;
        wrong_claim.cost += 1;
        assert_eq!(
            verified.verify_backend_result(wrong_claim),
            Err(AnchoredBackendResultError::Claim)
        );

        let unanchored = verified.backend_result(subproblem, 1).unwrap();
        assert_eq!(
            verified.verify_backend_result(unanchored),
            Err(AnchoredBackendResultError::Anchor)
        );

        let suboptimal_index = verified
            .problem()
            .candidates()
            .iter()
            .position(|candidate| candidate.support() == 0b011)
            .unwrap() as u32;
        let suboptimal = verified
            .backend_result(subproblem, suboptimal_index)
            .unwrap();
        assert_eq!(
            verified.verify_backend_result(suboptimal),
            Err(AnchoredBackendResultError::Optimality)
        );

        let mut wrong_subproblem = result;
        wrong_subproblem.anchor = 1;
        assert_eq!(
            verified.verify_backend_result(wrong_subproblem),
            Err(AnchoredBackendResultError::Subproblem)
        );
    }

    #[test]
    fn complete_backend_replay_covers_multiple_orbits_and_binds_the_cover() {
        let candidates = || {
            vec![
                BinarySupportCandidate::new(0b0001, 5),
                BinarySupportCandidate::new(0b0010, 5),
                BinarySupportCandidate::new(0b0100, 7),
                BinarySupportCandidate::new(0b1000, 7),
            ]
        };
        let two_orbits = TableAction([[1, 0, 3, 2]]);
        let verified = compile_verified_explicit_binary_support(
            &two_orbits,
            ExplicitBinarySupportProblem::new(4, candidates()).unwrap(),
        )
        .unwrap();
        assert_eq!(verified.cover().anchors(), &[0, 2]);
        let mut subproblems = verified.cover().subproblems();
        let first = subproblems.next().unwrap();
        let second = subproblems.next().unwrap();
        let results = [
            verified.backend_result(first, 0).unwrap(),
            verified.backend_result(second, 2).unwrap(),
        ];
        assert_eq!(
            verified
                .verify_complete_backend_results(&results)
                .unwrap()
                .unwrap()
                .candidate(),
            BinarySupportCandidate::new(0b0001, 5)
        );

        let identity = TableAction([[0, 1, 2, 3]]);
        let identity_verified = compile_verified_explicit_binary_support(
            &identity,
            ExplicitBinarySupportProblem::new(4, candidates()).unwrap(),
        )
        .unwrap();
        assert_ne!(verified.fingerprint(), identity_verified.fingerprint());
        assert_eq!(
            identity_verified.verify_backend_result(results[0]),
            Err(AnchoredBackendResultError::Fingerprint)
        );
    }
}
