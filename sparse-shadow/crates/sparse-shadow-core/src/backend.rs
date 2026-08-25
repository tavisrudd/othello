use std::collections::BTreeSet;

use serde::{Deserialize, Serialize};

use crate::{CanonicalArtifact, InputArtifact, ProfileInput, ShadowError, validate};

pub const BACKEND_GRAPH_SCHEMA_VERSION: &str = "sparse-shadow-colored-incidence/v1";
pub const BACKEND_COMPARISON_SCHEMA_VERSION: &str = "sparse-shadow-backend-comparison/v1";

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum ExternalBackendKind {
    Nauty,
    Bliss,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BackendDescriptor {
    pub kind: ExternalBackendKind,
    pub engine_version: String,
    pub configuration: String,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ColoredIncidenceGraph {
    pub schema: String,
    pub colors: Vec<u32>,
    pub edges: Vec<[u32; 2]>,
    pub original_vertex_nodes: Vec<u32>,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BackendObservation {
    pub canonical_graph_blake3: String,
    pub automorphism_order: u64,
    pub search_nodes: Option<u64>,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BackendComparison {
    pub schema: String,
    pub encoding_schema: String,
    pub authoritative_backend: String,
    pub native_canonical_id: String,
    pub external_backend: BackendDescriptor,
    pub raw_input: BackendObservation,
    pub native_canonical_input: BackendObservation,
    pub canonical_graph_agrees: bool,
    pub automorphism_order_agrees: bool,
}

impl BackendComparison {
    #[must_use]
    pub const fn verified(&self) -> bool {
        self.canonical_graph_agrees && self.automorphism_order_agrees
    }
}

/// Encode the enabled Paper-I relational shadow as a colored incidence graph.
///
/// Original vertices retain their typed color/weight/sign data and calibration
/// membership as color classes. Every relation edge becomes a vertex in a
/// relation-specific color class joined to its two endpoints. Consequently,
/// color-preserving graph automorphisms restrict exactly to automorphisms of
/// the relational shadow.
///
/// # Errors
///
/// Returns an error for invalid, gated, or directed inputs. Directed relation
/// gadgets are reserved for a later encoding schema.
pub fn encode_colored_incidence(
    input: &InputArtifact,
) -> Result<ColoredIncidenceGraph, ShadowError> {
    validate(input)?;
    let ProfileInput::PaperIOrientation(paper) = &input.profile else {
        return Err(ShadowError::Invalid(
            "colored-incidence v1 supports only the enabled Paper-I profile".into(),
        ));
    };
    if paper
        .shadow
        .relations
        .iter()
        .any(|relation| relation.directed)
    {
        return Err(ShadowError::Invalid(
            "colored-incidence v1 does not encode directed relations".into(),
        ));
    }

    let calibrated: BTreeSet<u32> = paper.calibrated_triangle.into_iter().flatten().collect();
    let mut vertex_keys = Vec::with_capacity(paper.shadow.vertices.len());
    for (index, vertex) in paper.shadow.vertices.iter().enumerate() {
        let index = u32::try_from(index)
            .map_err(|_| ShadowError::Invalid("Paper-I vertex count exceeds u32".into()))?;
        vertex_keys.push((
            vertex.color,
            vertex.weight,
            vertex.sign,
            calibrated.contains(&index),
        ));
    }
    let mut color_classes = vertex_keys.clone();
    color_classes.sort_unstable();
    color_classes.dedup();
    let mut colors = Vec::with_capacity(
        paper.shadow.vertices.len()
            + paper
                .shadow
                .relations
                .iter()
                .map(|relation| relation.edges.len())
                .sum::<usize>(),
    );
    for key in vertex_keys {
        let color = color_classes.binary_search(&key).map_err(|_| {
            ShadowError::Invalid("Paper-I vertex color class was not collected".into())
        })?;
        colors.push(
            u32::try_from(color)
                .map_err(|_| ShadowError::Invalid("Paper-I color count exceeds u32".into()))?,
        );
    }

    let original_vertex_nodes = (0..paper.shadow.vertices.len())
        .map(u32::try_from)
        .collect::<Result<Vec<_>, _>>()
        .map_err(|_| ShadowError::Invalid("Paper-I vertex count exceeds u32".into()))?;
    let relation_color_base = u32::try_from(color_classes.len())
        .map_err(|_| ShadowError::Invalid("Paper-I color count exceeds u32".into()))?;
    let mut edges = Vec::new();
    for (relation_index, relation) in paper.shadow.relations.iter().enumerate() {
        let relation_color = relation_color_base
            + u32::try_from(relation_index)
                .map_err(|_| ShadowError::Invalid("Paper-I relation count exceeds u32".into()))?;
        for &[left, right] in &relation.edges {
            let edge_node = u32::try_from(colors.len()).map_err(|_| {
                ShadowError::Invalid("Paper-I incidence encoding exceeds u32".into())
            })?;
            colors.push(relation_color);
            edges.push([left.min(edge_node), left.max(edge_node)]);
            edges.push([right.min(edge_node), right.max(edge_node)]);
        }
    }
    edges.sort_unstable();

    Ok(ColoredIncidenceGraph {
        schema: BACKEND_GRAPH_SCHEMA_VERSION.into(),
        colors,
        edges,
        original_vertex_nodes,
    })
}

/// Bind two observations from one external engine to the authoritative native
/// canonical artifact.
///
/// # Errors
///
/// Returns an error unless the external engine assigns the raw input and the
/// native canonical payload the same canonical graph and the same group order
/// as the native certificate.
pub fn compare_external_backend(
    native: &CanonicalArtifact,
    external_backend: BackendDescriptor,
    raw_input: BackendObservation,
    native_canonical_input: BackendObservation,
) -> Result<BackendComparison, ShadowError> {
    let canonical_graph_agrees =
        raw_input.canonical_graph_blake3 == native_canonical_input.canonical_graph_blake3;
    let automorphism_order_agrees = raw_input.automorphism_order == native.automorphism_order
        && native_canonical_input.automorphism_order == native.automorphism_order;
    let comparison = BackendComparison {
        schema: BACKEND_COMPARISON_SCHEMA_VERSION.into(),
        encoding_schema: BACKEND_GRAPH_SCHEMA_VERSION.into(),
        authoritative_backend: "native-paper-i-ir/v1".into(),
        native_canonical_id: native.canonical_id.clone(),
        external_backend,
        raw_input,
        native_canonical_input,
        canonical_graph_agrees,
        automorphism_order_agrees,
    };
    verify_backend_comparison(native, &comparison)?;
    Ok(comparison)
}

/// Check the self-consistency of a serialized external-backend comparison.
/// Engine observations remain independently reproducible only by rerunning the
/// named backend; this verifier binds their recorded agreement to the native
/// artifact and rejects corrupted wrapper fields.
///
/// # Errors
///
/// Returns an error for unsupported metadata, malformed observations, stale
/// native identity, or disagreement with the native automorphism order.
pub fn verify_backend_comparison(
    native: &CanonicalArtifact,
    comparison: &BackendComparison,
) -> Result<(), ShadowError> {
    let digest_valid =
        |digest: &str| digest.len() == 64 && digest.bytes().all(|byte| byte.is_ascii_hexdigit());
    if comparison.schema != BACKEND_COMPARISON_SCHEMA_VERSION
        || comparison.encoding_schema != BACKEND_GRAPH_SCHEMA_VERSION
        || comparison.authoritative_backend != "native-paper-i-ir/v1"
        || comparison.native_canonical_id != native.canonical_id
        || comparison.external_backend.engine_version.is_empty()
        || comparison.external_backend.configuration.is_empty()
        || !digest_valid(&comparison.raw_input.canonical_graph_blake3)
        || !digest_valid(&comparison.native_canonical_input.canonical_graph_blake3)
    {
        return Err(ShadowError::Certificate(
            "external backend comparison metadata is inconsistent".into(),
        ));
    }
    let canonical_graph_agrees = comparison.raw_input.canonical_graph_blake3
        == comparison.native_canonical_input.canonical_graph_blake3;
    let automorphism_order_agrees = comparison.raw_input.automorphism_order
        == native.automorphism_order
        && comparison.native_canonical_input.automorphism_order == native.automorphism_order;
    if comparison.canonical_graph_agrees != canonical_graph_agrees
        || comparison.automorphism_order_agrees != automorphism_order_agrees
        || !canonical_graph_agrees
        || !automorphism_order_agrees
    {
        return Err(ShadowError::Certificate(
            "external backend disagrees with the native canonical artifact".into(),
        ));
    }
    Ok(())
}
