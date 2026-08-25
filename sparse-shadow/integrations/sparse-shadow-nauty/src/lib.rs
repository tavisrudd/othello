//! Optional nauty baseline for the authoritative native sparse-shadow engine.

use std::os::raw::c_int;

use nauty_Traces_sys::{
    ADDONEEDGE, FALSE, NAUTYVERSIONID, SETBT, SETWD, SETWORDSNEEDED, TRUE, WORDSIZE, bit,
    densenauty, empty_graph, graph, nauty_check, optionblk, statsblk,
};
use sparse_shadow_core::{
    BackendComparison, BackendDescriptor, BackendObservation, ColoredIncidenceGraph,
    ExternalBackendKind, InputArtifact, ShadowError, canonicalize, compare_external_backend,
    encode_colored_incidence, verify_canonical_artifact,
};
use thiserror::Error;

#[derive(Debug, Error)]
pub enum NautyError {
    #[error(transparent)]
    Shadow(#[from] ShadowError),
    #[error(transparent)]
    Json(#[from] serde_json::Error),
    #[error("nauty rejected the encoded graph with status {0}")]
    Engine(c_int),
    #[error("nauty returned a non-integral or unsupported group order")]
    GroupOrder,
    #[error("colored-incidence graph exceeds nauty integer limits")]
    GraphSize,
}

/// Cross-check the raw input and the native canonical payload with bundled
/// nauty 2.9.3. The native artifact remains authoritative.
///
/// # Errors
///
/// Returns an error for invalid inputs, nauty failures, or any canonical-form
/// or automorphism-order disagreement.
pub fn cross_check(input: &InputArtifact) -> Result<BackendComparison, NautyError> {
    let native = canonicalize(input)?;
    verify_canonical_artifact(input, &native)?;
    let raw_input = observe(&encode_colored_incidence(input)?)?;
    let native_canonical_input = observe(&encode_colored_incidence(&native.canonical)?)?;
    Ok(compare_external_backend(
        &native,
        BackendDescriptor {
            kind: ExternalBackendKind::Nauty,
            engine_version: "2.9.3".into(),
            configuration: format!("dense;bundled;tls;wordsize={WORDSIZE}"),
        },
        raw_input,
        native_canonical_input,
    )?)
}

fn observe(encoded: &ColoredIncidenceGraph) -> Result<BackendObservation, NautyError> {
    let n = encoded.colors.len();
    let n_c = c_int::try_from(n).map_err(|_| NautyError::GraphSize)?;
    let m = SETWORDSNEEDED(n);
    let m_c = c_int::try_from(m).map_err(|_| NautyError::GraphSize)?;
    let mut graph = empty_graph(m, n);
    for &[left, right] in &encoded.edges {
        ADDONEEDGE(&mut graph, left as usize, right as usize, m);
    }

    let mut ordered: Vec<_> = encoded.colors.iter().copied().enumerate().collect();
    ordered.sort_unstable_by_key(|&(vertex, color)| (color, vertex));
    let mut lab: Vec<c_int> = ordered
        .iter()
        .map(|&(vertex, _)| c_int::try_from(vertex).expect("nauty graph size checked"))
        .collect();
    let mut ptn = vec![0; n];
    for position in 0..n.saturating_sub(1) {
        if ordered[position].1 == ordered[position + 1].1 {
            ptn[position] = 1;
        }
    }
    let mut orbits = vec![0; n];
    let mut canonical = empty_graph(m, n);
    let mut options = optionblk {
        getcanon: TRUE,
        defaultptn: FALSE,
        ..optionblk::default()
    };
    let mut stats = statsblk::default();
    let word_size = c_int::try_from(WORDSIZE).expect("nauty word size fits c_int");
    let version = c_int::try_from(NAUTYVERSIONID).expect("nauty version ID fits c_int");

    // SAFETY: all buffers have exactly the lengths required by nauty for
    // `n` vertices and `m` setwords. Their pointers remain valid for the call;
    // options use nauty's matching bundled 2.9.3 dispatch table.
    unsafe {
        nauty_check(word_size, m_c, n_c, version);
        densenauty(
            graph.as_mut_ptr(),
            lab.as_mut_ptr(),
            ptn.as_mut_ptr(),
            orbits.as_mut_ptr(),
            &mut options,
            &mut stats,
            m_c,
            n_c,
            canonical.as_mut_ptr(),
        );
    }
    if stats.errstatus != 0 {
        return Err(NautyError::Engine(stats.errstatus));
    }

    let canonical_colors: Vec<_> = lab
        .iter()
        .map(|&raw| encoded.colors[usize::try_from(raw).expect("nauty labeling is nonnegative")])
        .collect();
    let mut canonical_edges = Vec::with_capacity(encoded.edges.len());
    for left in 0..n {
        for right in left + 1..n {
            if contains(&canonical, left, right, m) {
                canonical_edges.push([left, right]);
            }
        }
    }
    let canonical_json =
        serde_json::to_vec(&(encoded.schema.as_str(), canonical_colors, canonical_edges))?;

    Ok(BackendObservation {
        canonical_graph_blake3: blake3::hash(&canonical_json).to_hex().to_string(),
        automorphism_order: group_order(&stats)?,
        search_nodes: Some(stats.numnodes),
    })
}

fn contains(graph: &[graph], vertex: usize, neighbor: usize, words_per_row: usize) -> bool {
    graph[vertex * words_per_row + SETWD(neighbor)] & bit[SETBT(neighbor)] != 0
}

fn group_order(stats: &statsblk) -> Result<u64, NautyError> {
    if stats.grpsize2 != 0 {
        return Err(NautyError::GroupOrder);
    }
    let order = stats.grpsize1;
    if !order.is_finite() || order < 0.0 {
        return Err(NautyError::GroupOrder);
    }
    let rounded = order.round();
    if (order - rounded).abs() > f64::EPSILON * order.max(1.0) * 8.0 {
        return Err(NautyError::GroupOrder);
    }
    format!("{rounded:.0}")
        .parse()
        .map_err(|_| NautyError::GroupOrder)
}
