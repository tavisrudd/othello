//! C1060: certified Lagrangian bounds for the weighted repair scheduler.
//!
//! The layered dynamic program in [`crate::scheduler`] carries a Pareto
//! frontier of load vectors. On a generic wide-load instance that frontier is
//! the whole cost: the C1038 L2 row reaches a peak frontier of about a hundred
//! thousand states and spends tens of billions of pairwise dominance
//! comparisons on them, while examining under two million transitions. The
//! frontier is not being enumerated because the answer needs it; it is being
//! enumerated because the dynamic program has no way to know that a state can
//! no longer reach the optimum.
//!
//! This module supplies that missing information as a *certified* bound, and
//! with it a branch-and-bound search that never materializes a frontier.
//!
//! # The bound
//!
//! Relax the scheduling problem to its linear program: choose `x[d][i] >= 0`
//! with `sum_i x[d][i] <= 1` for each demand `d` and
//! `sum_{d,i} load[d][i][r] * x[d][i] <= capacity[r]` for each resource `r`,
//! maximizing `sum x`. For any nonnegative resource multipliers `y` the
//! Lagrangian
//!
//! ```text
//!   g(y) = sum_r capacity[r] * y[r] + sum_d max(0, max_i (1 - load[d][i] . y))
//! ```
//!
//! is an upper bound on the linear-programming optimum, hence on the integer
//! optimum. The inner `max` *defines* the per-demand multiplier `u[d]`, so
//! dual feasibility holds by construction: **every** `y >= 0` yields a valid
//! bound. Bound quality depends on `y`; bound *validity* does not. That is what
//! makes the certificate cheap — a checker never has to trust how `y` was
//! found, only that it is nonnegative, which it can see.
//!
//! Multipliers are carried as integer numerators over [`DUAL_DENOMINATOR`], so
//! the bound and its floor are computed in exact integer arithmetic on both the
//! solver side and the checker side. No floating-point value enters the
//! certificate or the proof.
//!
//! # The certificate
//!
//! A certified answer is a pair: the dual vector `y` and a primal assignment.
//! It proves optimality exactly when
//!
//! * the assignment is feasible (each demand used at most once, each chosen
//!   load vector really is one of that demand's options, every capacity
//!   respected), and
//! * `floor(g(y))` equals the number of demands the assignment repairs.
//!
//! Then no schedule repairs more than `floor(g(y))` demands and one schedule
//! repairs exactly that many, so the assignment is optimal. The whole object is
//! one integer per resource plus one record per repaired demand; the check is a
//! few hundred integer multiplications. When the root bound does not meet the
//! primal value the search still returns the exact optimum, but reports
//! [`CertifiedSchedule::certified`] as false: this scheme has no compact proof
//! for that case and the caller must fall back to the frontier certificate.

use std::fmt;

/// Denominator of every dual multiplier. A power of two so the snap from the
/// fitted floating-point vector is exact and the products stay small.
pub const DUAL_DENOMINATOR: i64 = 4_096;

/// Largest instance this module accepts, so every workspace can be presized and
/// every intermediate product is provably inside `i64`.
pub const MAX_BOUND_DEMANDS: usize = 4_096;
/// Largest resource count this module accepts.
pub const MAX_BOUND_RESOURCES: usize = 64;

/// Reasons a certified solve or a certificate check is refused.
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum BoundError {
    /// The instance exceeds a declared bound of this module.
    TooLarge,
    /// The instance is malformed: an option whose width is not the resource
    /// count, or a demand with no options.
    Malformed,
    /// A multiplier was negative, so the Lagrangian is not an upper bound.
    NegativeMultiplier,
    /// The certificate's multiplier vector is not one per resource.
    MultiplierWidth,
    /// The certificate names a demand twice, or names a demand that does not
    /// exist.
    DemandReused,
    /// A certified load vector is not an option of the demand it is filed
    /// under.
    NotAnOption,
    /// The certified assignment exceeds a capacity.
    CapacityExceeded,
    /// The dual bound does not meet the primal value, so the pair proves
    /// nothing.
    BoundDoesNotClose {
        /// `floor(g(y))`, the largest repair count the dual admits.
        dual: u32,
        /// The number of demands the primal assignment repairs.
        primal: u32,
    },
}

impl fmt::Display for BoundError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::TooLarge => write!(formatter, "instance exceeds the declared bounds"),
            Self::Malformed => write!(formatter, "instance is malformed"),
            Self::NegativeMultiplier => write!(formatter, "a dual multiplier is negative"),
            Self::MultiplierWidth => {
                write!(formatter, "multiplier count is not the resource count")
            }
            Self::DemandReused => write!(formatter, "a demand is scheduled more than once"),
            Self::NotAnOption => write!(formatter, "a certified load vector is not an option"),
            Self::CapacityExceeded => {
                write!(formatter, "the certified assignment exceeds a capacity")
            }
            Self::BoundDoesNotClose { dual, primal } => write!(
                formatter,
                "dual bound {dual} does not meet primal value {primal}"
            ),
        }
    }
}

impl std::error::Error for BoundError {}

/// A nonnegative dual vector together with the per-demand slack it induces.
///
/// The slack `u[d]` is derived from the multipliers, never supplied, so a
/// `LagrangianDual` is dual-feasible by construction.
#[derive(Clone, Debug)]
pub struct LagrangianDual {
    /// One numerator per resource, over [`DUAL_DENOMINATOR`], nonnegative.
    multipliers: Vec<i64>,
    /// `suffix[d]` is `sum_{j >= d} u[j]`, numerators over the same denominator.
    suffix_slack: Vec<i64>,
}

impl LagrangianDual {
    /// Builds the dual induced by an explicit multiplier vector.
    ///
    /// This is the checker's entry point: it recomputes every per-demand slack
    /// from the multipliers alone.
    pub fn from_multipliers(
        multipliers: &[i64],
        families: &[Vec<Vec<u32>>],
    ) -> Result<Self, BoundError> {
        if multipliers.len() > MAX_BOUND_RESOURCES {
            return Err(BoundError::TooLarge);
        }
        if families.len() > MAX_BOUND_DEMANDS {
            return Err(BoundError::TooLarge);
        }
        if multipliers.iter().any(|&value| value < 0) {
            return Err(BoundError::NegativeMultiplier);
        }
        let width = multipliers.len();
        let mut suffix_slack = vec![0_i64; families.len() + 1];
        for (demand, options) in families.iter().enumerate().rev() {
            if options.is_empty() {
                return Err(BoundError::Malformed);
            }
            let mut slack = 0_i64;
            for option in options {
                if option.len() != width {
                    return Err(BoundError::Malformed);
                }
                let mut dual_load = 0_i64;
                for (&load, &multiplier) in option.iter().zip(multipliers.iter()) {
                    dual_load += i64::from(load) * multiplier;
                }
                slack = slack.max(DUAL_DENOMINATOR - dual_load);
            }
            suffix_slack[demand] = suffix_slack[demand + 1] + slack.max(0);
        }
        Ok(Self {
            multipliers: multipliers.to_vec(),
            suffix_slack,
        })
    }

    /// Fits a dual by projected subgradient descent on `g`, then snaps it to the
    /// [`DUAL_DENOMINATOR`] grid.
    ///
    /// Only the *quality* of the result depends on this search; the snapped
    /// vector is clamped nonnegative, so whatever it returns induces a valid
    /// bound. Floating point is confined to this function and never reaches the
    /// bound, the search, or the certificate.
    pub fn fit(
        capacities: &[u32],
        families: &[Vec<Vec<u32>>],
        iterations: u32,
    ) -> Result<Self, BoundError> {
        let width = capacities.len();
        if width > MAX_BOUND_RESOURCES || families.len() > MAX_BOUND_DEMANDS {
            return Err(BoundError::TooLarge);
        }
        if families
            .iter()
            .any(|options| options.is_empty() || options.iter().any(|option| option.len() != width))
        {
            return Err(BoundError::Malformed);
        }

        let mut point = vec![0.05_f64; width];
        let mut subgradient = vec![0.0_f64; width];
        let mut best_point = point.clone();
        let mut best_value = lagrangian(capacities, families, &point);
        for step_index in 0..iterations {
            subgradient.clear();
            subgradient.extend(capacities.iter().map(|&capacity| f64::from(capacity)));
            for options in families {
                let mut best_slack = 0.0_f64;
                let mut argmax: Option<&Vec<u32>> = None;
                for option in options {
                    let slack = 1.0 - dual_load(option, &point);
                    if slack > best_slack {
                        best_slack = slack;
                        argmax = Some(option);
                    }
                }
                if let Some(option) = argmax {
                    for (entry, &load) in subgradient.iter_mut().zip(option.iter()) {
                        *entry -= f64::from(load);
                    }
                }
            }
            let step = 0.005 / (1.0 + f64::from(step_index)).sqrt();
            for (coordinate, &slope) in point.iter_mut().zip(subgradient.iter()) {
                *coordinate = (*coordinate - step * slope).max(0.0);
            }
            let value = lagrangian(capacities, families, &point);
            if value < best_value {
                best_value = value;
                best_point.copy_from_slice(&point);
            }
        }

        let multipliers: Vec<i64> = best_point
            .iter()
            .map(|&coordinate| {
                let scaled = (coordinate * DUAL_DENOMINATOR as f64).round();
                if scaled.is_finite() && scaled > 0.0 {
                    (scaled as i64).min(DUAL_DENOMINATOR)
                } else {
                    0
                }
            })
            .collect();
        Self::from_multipliers(&multipliers, families)
    }

    /// The multiplier numerators, over [`DUAL_DENOMINATOR`].
    pub fn multipliers(&self) -> &[i64] {
        &self.multipliers
    }

    /// `DUAL_DENOMINATOR * g(y)` restricted to demands `from_demand..`, with
    /// `residual` in place of the full capacities. Exact integer arithmetic.
    pub fn bound_numerator(&self, residual: &[u32], from_demand: usize) -> i64 {
        let mut total = self.suffix_slack[from_demand.min(self.suffix_slack.len() - 1)];
        for (&capacity, &multiplier) in residual.iter().zip(self.multipliers.iter()) {
            total += i64::from(capacity) * multiplier;
        }
        total
    }

    /// The largest number of demands in `from_demand..` that any schedule can
    /// repair inside `residual`.
    pub fn bound(&self, residual: &[u32], from_demand: usize) -> u32 {
        let numerator = self.bound_numerator(residual, from_demand);
        if numerator <= 0 {
            return 0;
        }
        let floor = numerator / DUAL_DENOMINATOR;
        u32::try_from(floor).unwrap_or(u32::MAX)
    }
}

fn dual_load(option: &[u32], point: &[f64]) -> f64 {
    option
        .iter()
        .zip(point.iter())
        .map(|(&load, &coordinate)| f64::from(load) * coordinate)
        .sum()
}

fn lagrangian(capacities: &[u32], families: &[Vec<Vec<u32>>], point: &[f64]) -> f64 {
    let mut total: f64 = capacities
        .iter()
        .zip(point.iter())
        .map(|(&capacity, &coordinate)| f64::from(capacity) * coordinate)
        .sum();
    for options in families {
        let mut slack = 0.0_f64;
        for option in options {
            slack = slack.max(1.0 - dual_load(option, point));
        }
        total += slack;
    }
    total
}

/// One scheduled demand: which demand, and which of its options.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BoundChoice {
    /// Index into the family list.
    pub demand: u32,
    /// Index into that demand's option list.
    pub option: u32,
}

/// The answer of a certified branch-and-bound solve.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct CertifiedSchedule {
    /// The optimal assignment, in increasing demand order.
    pub assignment: Vec<BoundChoice>,
    /// Dual multiplier numerators over [`DUAL_DENOMINATOR`].
    pub multipliers: Vec<i64>,
    /// `floor(g(y))` at the full capacities.
    pub root_bound: u32,
    /// Whether the dual bound meets the primal value, i.e. whether the pair
    /// `(multipliers, assignment)` is a complete optimality proof.
    pub certified: bool,
    /// Search nodes expanded, for the performance A/B.
    pub nodes: u64,
}

impl CertifiedSchedule {
    /// Number of demands repaired.
    pub fn repaired_count(&self) -> u32 {
        self.assignment.len() as u32
    }

    /// Serialized size of the certificate: the multipliers plus the assignment.
    pub fn certificate_bytes(&self) -> u64 {
        (self.multipliers.len() * std::mem::size_of::<i64>()
            + self.assignment.len() * std::mem::size_of::<BoundChoice>()) as u64
    }
}

/// Presized scratch for [`solve_certified_with_workspace`].
///
/// The search loop touches nothing outside this workspace, so a warmed
/// workspace makes the loop allocation-free.
#[derive(Debug, Default)]
pub struct BoundWorkspace {
    /// `(depth + 1) * width` residual capacities, one row per stack frame.
    residual: Vec<u32>,
    /// Per frame: which option index is being tried next.
    cursor: Vec<u32>,
    /// Per frame: repairs accumulated on the path to it.
    repairs: Vec<u32>,
    /// Per frame: the option chosen to reach the next frame, or `NO_OPTION`.
    choice: Vec<u32>,
    /// The incumbent path, same shape as `choice`.
    best_choice: Vec<u32>,
    /// Per demand, its option indexes in ascending dual load.
    order: Vec<u32>,
    /// Start of each demand's slice of `order`, plus a terminator.
    order_base: Vec<usize>,
}

const NO_OPTION: u32 = u32::MAX;

impl BoundWorkspace {
    /// A workspace with no capacity reserved yet.
    pub fn new() -> Self {
        Self::default()
    }

    /// Reserves every buffer for an instance of this shape, so a later solve of
    /// the same shape allocates nothing.
    pub fn reserve(&mut self, demands: usize, width: usize, options: usize) {
        self.residual.resize((demands + 1) * width, 0);
        self.cursor.resize(demands + 1, 0);
        self.repairs.resize(demands + 1, 0);
        self.choice.resize(demands + 1, NO_OPTION);
        self.best_choice.resize(demands + 1, NO_OPTION);
        self.order.resize(options, 0);
        self.order_base.resize(demands + 1, 0);
    }

    /// Releases reserved capacity.
    pub fn shrink_to_fit(&mut self) {
        self.residual.shrink_to_fit();
        self.cursor.shrink_to_fit();
        self.repairs.shrink_to_fit();
        self.choice.shrink_to_fit();
        self.best_choice.shrink_to_fit();
        self.order.shrink_to_fit();
        self.order_base.shrink_to_fit();
    }
}

/// Solves exactly by depth-first branch and bound under the certified
/// Lagrangian bound, allocating a fresh workspace.
pub fn solve_certified(
    capacities: &[u32],
    families: &[Vec<Vec<u32>>],
    iterations: u32,
) -> Result<CertifiedSchedule, BoundError> {
    let mut workspace = BoundWorkspace::new();
    solve_certified_with_workspace(capacities, families, iterations, &mut workspace)
}

/// Solves exactly by depth-first branch and bound under the certified
/// Lagrangian bound, reusing `workspace`.
///
/// The traversal is iterative: the search stack lives in the workspace, so no
/// recursion depth tracks the instance. After the dual fit, which is cold, the
/// search loop performs no allocation.
pub fn solve_certified_with_workspace(
    capacities: &[u32],
    families: &[Vec<Vec<u32>>],
    iterations: u32,
    workspace: &mut BoundWorkspace,
) -> Result<CertifiedSchedule, BoundError> {
    let mut budget = iterations.max(1);
    let mut nodes = 0_u64;
    for round in 0..MAX_DUAL_FIT_ROUNDS {
        let dual = LagrangianDual::fit(capacities, families, budget)?;
        prepare(capacities, families, &dual, workspace);
        nodes += search(capacities, families, &dual, workspace);
        let answer = finish(capacities, families, dual, workspace, nodes);
        if answer.certified || round + 1 == MAX_DUAL_FIT_ROUNDS {
            return Ok(answer);
        }
        // The search already returned the exact optimum; only the *proof* is
        // missing, and a sharper dual is the one thing that can supply it. Each
        // extra round costs a fit and a re-search under a better bound, so the
        // escalation is bounded and the answer never changes.
        budget = budget.saturating_mul(2);
    }
    unreachable!("the loop returns on its last round")
}

/// How many times the dual-fit budget may double before the solve gives up on
/// producing a compact proof and returns the exact optimum uncertified.
pub const MAX_DUAL_FIT_ROUNDS: u32 = 4;

/// Cold setup: sizes every workspace buffer and fixes the option order.
///
/// Options are tried cheapest-first in the dual metric, so the first dive
/// reaches a strong incumbent before any bound is tested. The order is a
/// heuristic; exactness does not depend on it.
fn prepare(
    capacities: &[u32],
    families: &[Vec<Vec<u32>>],
    dual: &LagrangianDual,
    workspace: &mut BoundWorkspace,
) {
    let width = capacities.len();
    let demands = families.len();
    let option_total: usize = families.iter().map(Vec::len).sum();
    workspace.reserve(demands, width, option_total);

    let mut cursor = 0_usize;
    for (demand, options) in families.iter().enumerate() {
        workspace.order_base[demand] = cursor;
        let slice = &mut workspace.order[cursor..cursor + options.len()];
        for (index, slot) in slice.iter_mut().enumerate() {
            *slot = index as u32;
        }
        slice.sort_unstable_by_key(|&index| {
            let option = &options[index as usize];
            option
                .iter()
                .zip(dual.multipliers.iter())
                .map(|(&load, &multiplier)| i64::from(load) * multiplier)
                .sum::<i64>()
        });
        cursor += options.len();
    }
    workspace.order_base[demands] = cursor;
}

/// The allocation-free depth-first branch-and-bound loop.
///
/// Reads `capacities`, `families` and `dual`; writes only into `workspace`.
/// Returns the number of nodes expanded, leaving the incumbent path in
/// `workspace.best_choice`.
fn search(
    capacities: &[u32],
    families: &[Vec<Vec<u32>>],
    dual: &LagrangianDual,
    workspace: &mut BoundWorkspace,
) -> u64 {
    let width = capacities.len();
    let demands = families.len();
    workspace.residual[0..width].copy_from_slice(capacities);
    workspace.cursor[0] = 0;
    workspace.repairs[0] = 0;
    workspace.choice.fill(NO_OPTION);
    workspace.best_choice.fill(NO_OPTION);

    let mut best = 0_u32;
    let mut nodes = 0_u64;
    let mut depth = 0_usize;

    loop {
        if depth == demands {
            if workspace.repairs[depth] > best {
                best = workspace.repairs[depth];
                workspace.best_choice.copy_from_slice(&workspace.choice);
            }
            if depth == 0 {
                break;
            }
            depth -= 1;
            continue;
        }

        if workspace.cursor[depth] == 0 {
            nodes += 1;
            if workspace.repairs[depth] > best {
                best = workspace.repairs[depth];
                workspace.best_choice.copy_from_slice(&workspace.choice);
            }
            let residual = &workspace.residual[depth * width..depth * width + width];
            if workspace.repairs[depth] + dual.bound(residual, depth) <= best {
                if depth == 0 {
                    break;
                }
                depth -= 1;
                continue;
            }
        }

        let options = &families[depth];
        let slot = workspace.cursor[depth] as usize;
        if slot > options.len() {
            workspace.cursor[depth] = 0;
            workspace.choice[depth] = NO_OPTION;
            if depth == 0 {
                break;
            }
            depth -= 1;
            continue;
        }
        workspace.cursor[depth] += 1;

        if slot == options.len() {
            // The skip branch: this demand goes unrepaired.
            workspace.choice[depth] = NO_OPTION;
            let (here, next) = workspace.residual.split_at_mut((depth + 1) * width);
            next[0..width].copy_from_slice(&here[depth * width..depth * width + width]);
            workspace.repairs[depth + 1] = workspace.repairs[depth];
            workspace.cursor[depth + 1] = 0;
            depth += 1;
            continue;
        }

        let option = &options[workspace.order[workspace.order_base[depth] + slot] as usize];
        let (here, next) = workspace.residual.split_at_mut((depth + 1) * width);
        let residual = &here[depth * width..depth * width + width];
        let mut feasible = true;
        for coordinate in 0..width {
            let load = option[coordinate];
            if load > residual[coordinate] {
                feasible = false;
                break;
            }
            next[coordinate] = residual[coordinate] - load;
        }
        if !feasible {
            continue;
        }
        workspace.choice[depth] = workspace.order[workspace.order_base[depth] + slot];
        workspace.repairs[depth + 1] = workspace.repairs[depth] + 1;
        workspace.cursor[depth + 1] = 0;
        depth += 1;
    }

    nodes
}

/// Cold assembly of the answer from the incumbent path.
fn finish(
    capacities: &[u32],
    families: &[Vec<Vec<u32>>],
    dual: LagrangianDual,
    workspace: &BoundWorkspace,
    nodes: u64,
) -> CertifiedSchedule {
    let demands = families.len();
    let assignment: Vec<BoundChoice> = workspace.best_choice[..demands]
        .iter()
        .enumerate()
        .filter_map(|(demand, &option)| {
            (option != NO_OPTION).then_some(BoundChoice {
                demand: demand as u32,
                option,
            })
        })
        .collect();
    let root_bound = dual.bound(capacities, 0);
    CertifiedSchedule {
        certified: root_bound == assignment.len() as u32,
        assignment,
        multipliers: dual.multipliers,
        root_bound,
        nodes,
    }
}

/// Independently checks a certificate and returns the optimum it proves.
///
/// The checker never solves the instance and never sees the search. It rebuilds
/// the dual slacks from the multipliers, checks the primal assignment against
/// the instance, and reports success only when the two meet.
pub fn verify_certificate(
    capacities: &[u32],
    families: &[Vec<Vec<u32>>],
    multipliers: &[i64],
    assignment: &[BoundChoice],
) -> Result<u32, BoundError> {
    let width = capacities.len();
    if multipliers.len() != width {
        return Err(BoundError::MultiplierWidth);
    }
    let dual = LagrangianDual::from_multipliers(multipliers, families)?;

    let mut totals = vec![0_u64; width];
    let mut previous: Option<u32> = None;
    for choice in assignment {
        let demand = choice.demand as usize;
        if demand >= families.len() {
            return Err(BoundError::DemandReused);
        }
        if previous.is_some_and(|last| last >= choice.demand) {
            return Err(BoundError::DemandReused);
        }
        previous = Some(choice.demand);
        let options = &families[demand];
        let option = options
            .get(choice.option as usize)
            .ok_or(BoundError::NotAnOption)?;
        for (total, &load) in totals.iter_mut().zip(option.iter()) {
            *total += u64::from(load);
        }
    }
    for (&total, &capacity) in totals.iter().zip(capacities.iter()) {
        if total > u64::from(capacity) {
            return Err(BoundError::CapacityExceeded);
        }
    }

    let primal = assignment.len() as u32;
    let dual_value = dual.bound(capacities, 0);
    if dual_value != primal {
        return Err(BoundError::BoundDoesNotClose {
            dual: dual_value,
            primal,
        });
    }
    Ok(primal)
}

#[cfg(test)]
mod tests {
    use super::*;

    fn tiny() -> (Vec<u32>, Vec<Vec<Vec<u32>>>) {
        (
            vec![5, 5],
            vec![
                vec![vec![2, 1], vec![1, 3]],
                vec![vec![3, 3], vec![1, 1]],
                vec![vec![4, 4]],
            ],
        )
    }

    #[test]
    fn every_nonnegative_dual_is_a_valid_bound() {
        let (capacities, families) = tiny();
        for scale in [0_i64, 1, 7, 100, DUAL_DENOMINATOR] {
            let dual = LagrangianDual::from_multipliers(&vec![scale; capacities.len()], &families)
                .unwrap();
            assert!(dual.bound(&capacities, 0) >= 2, "bound must not undercut");
        }
    }

    #[test]
    fn a_negative_multiplier_is_refused() {
        let (_, families) = tiny();
        assert!(matches!(
            LagrangianDual::from_multipliers(&[-1, 0], &families),
            Err(BoundError::NegativeMultiplier)
        ));
    }

    #[test]
    fn branch_and_bound_matches_brute_force_on_small_instances() {
        let (capacities, families) = tiny();
        let answer = solve_certified(&capacities, &families, 400).unwrap();
        // Brute force over every choice, skip included.
        let mut best = 0_u32;
        let mut index = vec![0_usize; families.len()];
        loop {
            let mut totals = vec![0_u64; capacities.len()];
            let mut count = 0_u32;
            for (demand, &slot) in index.iter().enumerate() {
                if slot < families[demand].len() {
                    count += 1;
                    for (total, &load) in totals.iter_mut().zip(families[demand][slot].iter()) {
                        *total += u64::from(load);
                    }
                }
            }
            if totals
                .iter()
                .zip(capacities.iter())
                .all(|(&total, &capacity)| total <= u64::from(capacity))
            {
                best = best.max(count);
            }
            let mut position = 0;
            while position < index.len() {
                index[position] += 1;
                if index[position] <= families[position].len() {
                    break;
                }
                index[position] = 0;
                position += 1;
            }
            if position == index.len() {
                break;
            }
        }
        assert_eq!(answer.repaired_count(), best);
    }

    #[test]
    fn a_certificate_verifies_and_a_forged_one_does_not() {
        let (capacities, families) = tiny();
        let answer = solve_certified(&capacities, &families, 2_000).unwrap();
        if !answer.certified {
            return;
        }
        assert_eq!(
            verify_certificate(
                &capacities,
                &families,
                &answer.multipliers,
                &answer.assignment
            ),
            Ok(answer.repaired_count())
        );

        // Forgery 1: claim one more repaired demand than the assignment holds.
        let mut padded = answer.assignment.clone();
        padded.push(BoundChoice {
            demand: families.len() as u32,
            option: 0,
        });
        assert!(
            verify_certificate(&capacities, &families, &answer.multipliers, &padded).is_err(),
            "a demand outside the instance must be refused"
        );

        // Forgery 2: keep the count but swap in a load vector that is not an
        // option of its demand.
        let mut swapped = answer.assignment.clone();
        swapped[0].option = 99;
        assert_eq!(
            verify_certificate(&capacities, &families, &answer.multipliers, &swapped),
            Err(BoundError::NotAnOption)
        );

        // Forgery 3: inflate the multipliers so the dual no longer meets the
        // primal value. The checker must reject the pair, not the instance.
        let inflated: Vec<i64> = answer
            .multipliers
            .iter()
            .map(|&value| value + DUAL_DENOMINATOR)
            .collect();
        assert!(matches!(
            verify_certificate(&capacities, &families, &inflated, &answer.assignment),
            Err(BoundError::BoundDoesNotClose { .. })
        ));
    }

    #[test]
    fn a_reused_demand_is_refused() {
        let (capacities, families) = tiny();
        let answer = solve_certified(&capacities, &families, 400).unwrap();
        let repeated = vec![
            BoundChoice {
                demand: 0,
                option: 0
            };
            2
        ];
        assert_eq!(
            verify_certificate(&capacities, &families, &answer.multipliers, &repeated),
            Err(BoundError::DemandReused)
        );
        let _ = answer;
    }

    #[test]
    fn a_capacity_violation_is_refused() {
        let capacities = vec![3_u32];
        let families = vec![vec![vec![2_u32]], vec![vec![2_u32]]];
        assert_eq!(
            verify_certificate(
                &capacities,
                &families,
                &[0],
                &[
                    BoundChoice {
                        demand: 0,
                        option: 0
                    },
                    BoundChoice {
                        demand: 1,
                        option: 0
                    },
                ]
            ),
            Err(BoundError::CapacityExceeded)
        );
    }

    #[test]
    fn a_warm_workspace_allocates_nothing_in_the_search_loop() {
        let (capacities, families) = tiny();
        let mut workspace = BoundWorkspace::new();
        // The dual fit and the answer assembly are cold; only the traversal is
        // required to be allocation-free, so the guard wraps exactly that.
        let dual = LagrangianDual::fit(&capacities, &families, 200).unwrap();
        prepare(&capacities, &families, &dual, &mut workspace);
        let first = search(&capacities, &families, &dual, &mut workspace);
        let guard = crate::test_alloc::HotLoopAllocationGuard::enter();
        let second = search(&capacities, &families, &dual, &mut workspace);
        drop(guard);
        assert_eq!(first, second, "the search must be deterministic");
        assert_eq!(
            finish(&capacities, &families, dual, &workspace, second).repaired_count(),
            solve_certified(&capacities, &families, 200)
                .unwrap()
                .repaired_count()
        );
    }
}
