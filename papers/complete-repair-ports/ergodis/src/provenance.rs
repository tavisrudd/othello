//! Flat, domain-neutral provenance sidecars.
//!
//! Exact quotient values do not by themselves lift concrete witnesses.  This
//! arena gives adapters one common representation for replayable provenance
//! DAGs while leaving the meaning of node kinds and payload words to the
//! adapter.  Children must precede their parent, so structural validity is
//! independently checkable in one forward scan.

use crate::observational::{
    verify_compilation, CompiledObservation, FinitePresentation, ObservationalError,
    PresentationFingerprint,
};
use thiserror::Error;

#[derive(Debug, Error, PartialEq, Eq)]
pub enum ProvenanceError {
    #[error("a provenance pool exceeds its compact representation")]
    Overflow,
    #[error("child provenance ID {child} does not precede its parent")]
    UnknownChild { child: u32 },
    #[error("unknown provenance node {node}")]
    UnknownNode { node: u32 },
    #[error("provenance node {node} has malformed pool ranges or child IDs")]
    Corrupt { node: u32 },
}

#[derive(Debug, Error, PartialEq, Eq)]
pub enum ReplayError {
    #[error(transparent)]
    Observational(#[from] ObservationalError),
    #[error("the sidecar presentation fingerprint does not match")]
    PresentationMismatch,
    #[error("the sidecar adapter/law ID does not match")]
    AdapterId,
    #[error("replay record {record} is malformed")]
    Record { record: u32 },
    #[error(transparent)]
    Provenance(#[from] ProvenanceError),
}

#[repr(transparent)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, PartialOrd, Ord)]
pub struct ProvenanceId(u32);

const _: () = assert!(std::mem::size_of::<ProvenanceId>() == 4);
const _: () = assert!(std::mem::align_of::<ProvenanceId>() == 4);

impl ProvenanceId {
    pub fn index(self) -> u32 {
        self.0
    }
}

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
struct ProvenanceNode {
    kind: u32,
    payload_start: u32,
    payload_len: u32,
    child_start: u32,
    child_len: u32,
    _reserved: [u32; 3],
}

const _: () = assert!(std::mem::size_of::<ProvenanceNode>() == 32);
const _: () = assert!(std::mem::align_of::<ProvenanceNode>() == 4);

#[derive(Clone, Copy, Debug)]
pub struct ProvenanceView<'a> {
    kind: u32,
    payload: &'a [u32],
    children: &'a [u32],
}

impl<'a> ProvenanceView<'a> {
    pub fn kind(self) -> u32 {
        self.kind
    }

    pub fn payload(self) -> &'a [u32] {
        self.payload
    }

    pub fn children(self) -> impl ExactSizeIterator<Item = ProvenanceId> + 'a {
        self.children.iter().copied().map(ProvenanceId)
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ProvenanceStorage {
    pub node_bytes: usize,
    pub payload_bytes: usize,
    pub child_bytes: usize,
}

const NO_PROVENANCE: u32 = u32::MAX;

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct ReplayRecord {
    pub start_state: u32,
    path_start: u32,
    path_len: u32,
    pub terminal_state: u32,
    pub observation: u32,
    provenance: u32,
    _flags: u32,
    _reserved: u32,
}

const _: () = assert!(std::mem::size_of::<ReplayRecord>() == 32);
const _: () = assert!(std::mem::align_of::<ReplayRecord>() == 4);

#[derive(Clone, Copy, Debug)]
pub struct ReplayView<'a> {
    pub record: ReplayRecord,
    pub path: &'a [u32],
    pub provenance: Option<ProvenanceId>,
}

#[derive(Clone, Debug)]
pub struct ReplaySidecar {
    fingerprint: PresentationFingerprint,
    adapter_id: u32,
    infinity: u32,
    arena: ProvenanceArena,
    records: Vec<ReplayRecord>,
    paths: Vec<u32>,
}

impl ReplaySidecar {
    pub fn new(fingerprint: PresentationFingerprint, adapter_id: u32, infinity: u32) -> Self {
        Self {
            fingerprint,
            adapter_id,
            infinity,
            arena: ProvenanceArena::default(),
            records: Vec::new(),
            paths: Vec::new(),
        }
    }

    pub fn adapter_id(&self) -> u32 {
        self.adapter_id
    }

    pub fn infinity(&self) -> u32 {
        self.infinity
    }

    pub fn arena(&self) -> &ProvenanceArena {
        &self.arena
    }

    pub fn arena_mut(&mut self) -> &mut ProvenanceArena {
        &mut self.arena
    }

    pub fn bind(
        &mut self,
        start_state: u32,
        path: &[u32],
        terminal_state: u32,
        observation: u32,
        provenance: Option<ProvenanceId>,
    ) -> Result<u32, ProvenanceError> {
        if provenance.is_some_and(|node| node.0 as usize >= self.arena.len()) {
            return Err(ProvenanceError::UnknownNode {
                node: provenance.expect("checked some").0,
            });
        }
        let path_start = u32::try_from(self.paths.len()).map_err(|_| ProvenanceError::Overflow)?;
        let path_len = u32::try_from(path.len()).map_err(|_| ProvenanceError::Overflow)?;
        let record = u32::try_from(self.records.len()).map_err(|_| ProvenanceError::Overflow)?;
        self.paths.extend_from_slice(path);
        self.records.push(ReplayRecord {
            start_state,
            path_start,
            path_len,
            terminal_state,
            observation,
            provenance: provenance.map_or(NO_PROVENANCE, ProvenanceId::index),
            _flags: 0,
            _reserved: 0,
        });
        Ok(record)
    }

    pub fn records(&self) -> impl ExactSizeIterator<Item = ReplayView<'_>> {
        self.records.iter().copied().map(|record| {
            let start = record.path_start as usize;
            let end = start + record.path_len as usize;
            ReplayView {
                record,
                path: &self.paths[start..end],
                provenance: (record.provenance != NO_PROVENANCE)
                    .then_some(ProvenanceId(record.provenance)),
            }
        })
    }

    pub fn verify(
        &self,
        expected_adapter_id: u32,
        presentation: &FinitePresentation,
        compiled: &CompiledObservation,
    ) -> Result<(), ReplayError> {
        verify_compilation(presentation, compiled)?;
        self.arena.verify()?;
        if self.fingerprint != presentation.fingerprint() {
            return Err(ReplayError::PresentationMismatch);
        }
        if self.adapter_id == 0 || self.adapter_id != expected_adapter_id {
            return Err(ReplayError::AdapterId);
        }
        let mut next_path = 0_u32;
        for (record_id, record) in self.records.iter().copied().enumerate() {
            let record_id = record_id as u32;
            if record.path_start != next_path
                || record.start_state as usize >= presentation.state_count()
                || record._flags != 0
                || record._reserved != 0
            {
                return Err(ReplayError::Record { record: record_id });
            }
            next_path = next_path
                .checked_add(record.path_len)
                .ok_or(ReplayError::Record { record: record_id })?;
            let start = record.path_start as usize;
            let Some(path) = self.paths.get(start..next_path as usize) else {
                return Err(ReplayError::Record { record: record_id });
            };
            let mut concrete = record.start_state;
            let mut class = compiled.state_classes()[concrete as usize];
            for &generator in path {
                concrete = presentation
                    .transition(generator, concrete)
                    .ok_or(ReplayError::Record { record: record_id })?;
                class = compiled
                    .transition(generator, class)
                    .ok_or(ReplayError::Record { record: record_id })?;
                if compiled.state_classes()[concrete as usize] != class {
                    return Err(ReplayError::Record { record: record_id });
                }
            }
            if concrete != record.terminal_state
                || presentation.observations()[concrete as usize] != record.observation
                || compiled.class_outputs()[class as usize] != record.observation
            {
                return Err(ReplayError::Record { record: record_id });
            }
            if record.provenance == NO_PROVENANCE {
                if record.observation != self.infinity {
                    return Err(ReplayError::Record { record: record_id });
                }
            } else {
                self.arena.get(ProvenanceId(record.provenance))?;
            }
        }
        if next_path as usize != self.paths.len() {
            return Err(ReplayError::Record {
                record: self.records.len() as u32,
            });
        }
        Ok(())
    }

    pub fn replay_storage_bytes(&self) -> usize {
        std::mem::size_of_val(self.records.as_slice())
            + std::mem::size_of_val(self.paths.as_slice())
    }
}

#[derive(Clone, Debug, Default)]
pub struct ProvenanceArena {
    nodes: Vec<ProvenanceNode>,
    payloads: Vec<u32>,
    children: Vec<u32>,
}

impl ProvenanceArena {
    pub fn push(
        &mut self,
        kind: u32,
        payload: &[u32],
        children: &[ProvenanceId],
    ) -> Result<ProvenanceId, ProvenanceError> {
        let node_id = u32::try_from(self.nodes.len()).map_err(|_| ProvenanceError::Overflow)?;
        for &child in children {
            if child.0 >= node_id {
                return Err(ProvenanceError::UnknownChild { child: child.0 });
            }
        }
        let payload_start =
            u32::try_from(self.payloads.len()).map_err(|_| ProvenanceError::Overflow)?;
        let payload_len = u32::try_from(payload.len()).map_err(|_| ProvenanceError::Overflow)?;
        let child_start =
            u32::try_from(self.children.len()).map_err(|_| ProvenanceError::Overflow)?;
        let child_len = u32::try_from(children.len()).map_err(|_| ProvenanceError::Overflow)?;
        self.payloads.extend_from_slice(payload);
        self.children
            .extend(children.iter().map(|child| child.index()));
        self.nodes.push(ProvenanceNode {
            kind,
            payload_start,
            payload_len,
            child_start,
            child_len,
            _reserved: [0; 3],
        });
        Ok(ProvenanceId(node_id))
    }

    pub fn get(&self, node: ProvenanceId) -> Result<ProvenanceView<'_>, ProvenanceError> {
        let Some(record) = self.nodes.get(node.0 as usize).copied() else {
            return Err(ProvenanceError::UnknownNode { node: node.0 });
        };
        let payload_start = record.payload_start as usize;
        let payload_end = payload_start
            .checked_add(record.payload_len as usize)
            .ok_or(ProvenanceError::Corrupt { node: node.0 })?;
        let child_start = record.child_start as usize;
        let child_end = child_start
            .checked_add(record.child_len as usize)
            .ok_or(ProvenanceError::Corrupt { node: node.0 })?;
        let payload = self
            .payloads
            .get(payload_start..payload_end)
            .ok_or(ProvenanceError::Corrupt { node: node.0 })?;
        let children = self
            .children
            .get(child_start..child_end)
            .ok_or(ProvenanceError::Corrupt { node: node.0 })?;
        Ok(ProvenanceView {
            kind: record.kind,
            payload,
            children,
        })
    }

    pub fn verify(&self) -> Result<(), ProvenanceError> {
        let mut next_payload = 0_u32;
        let mut next_child = 0_u32;
        for (node, record) in self.nodes.iter().copied().enumerate() {
            let node = node as u32;
            if record.payload_start != next_payload || record.child_start != next_child {
                return Err(ProvenanceError::Corrupt { node });
            }
            next_payload = next_payload
                .checked_add(record.payload_len)
                .ok_or(ProvenanceError::Corrupt { node })?;
            next_child = next_child
                .checked_add(record.child_len)
                .ok_or(ProvenanceError::Corrupt { node })?;
            let view = self.get(ProvenanceId(node))?;
            if view.children().any(|child| child.0 >= node) {
                return Err(ProvenanceError::Corrupt { node });
            }
        }
        if next_payload as usize != self.payloads.len()
            || next_child as usize != self.children.len()
        {
            return Err(ProvenanceError::Corrupt {
                node: self.nodes.len() as u32,
            });
        }
        Ok(())
    }

    pub fn len(&self) -> usize {
        self.nodes.len()
    }

    pub fn is_empty(&self) -> bool {
        self.nodes.is_empty()
    }

    pub fn storage(&self) -> ProvenanceStorage {
        ProvenanceStorage {
            node_bytes: std::mem::size_of_val(self.nodes.as_slice()),
            payload_bytes: std::mem::size_of_val(self.payloads.as_slice()),
            child_bytes: std::mem::size_of_val(self.children.as_slice()),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::observational::{compile_observational, GeneratorSpec};

    #[test]
    fn flat_dag_replays_and_verifies() {
        let mut arena = ProvenanceArena::default();
        let left = arena.push(1, &[10], &[]).unwrap();
        let right = arena.push(1, &[20], &[]).unwrap();
        let root = arena.push(2, &[30, 40], &[left, right]).unwrap();
        arena.verify().unwrap();
        let view = arena.get(root).unwrap();
        assert_eq!(view.kind(), 2);
        assert_eq!(view.payload(), [30, 40]);
        assert_eq!(view.children().collect::<Vec<_>>(), [left, right]);
    }

    #[test]
    fn rejects_forward_edges_and_corruption() {
        let mut arena = ProvenanceArena::default();
        let imaginary = ProvenanceId(0);
        assert_eq!(
            arena.push(1, &[], &[imaginary]),
            Err(ProvenanceError::UnknownChild { child: 0 })
        );
        let root = arena.push(1, &[7], &[]).unwrap();
        arena.nodes[root.0 as usize].payload_start = u32::MAX;
        assert!(matches!(
            arena.verify(),
            Err(ProvenanceError::Corrupt { .. })
        ));
    }

    #[test]
    fn replay_sidecar_binds_profile_adapter_and_concrete_trace() {
        let presentation = FinitePresentation::new(
            [2],
            vec![0, 1],
            [GeneratorSpec {
                source_sort: 0,
                target_sort: 0,
                transitions: vec![0, 1].into_boxed_slice(),
            }],
        )
        .unwrap();
        let compiled = compile_observational(&presentation).unwrap();
        let mut sidecar = ReplaySidecar::new(presentation.fingerprint(), 7, 9);
        let root = sidecar.arena_mut().push(11, &[0], &[]).unwrap();
        sidecar.bind(0, &[0], 0, 0, Some(root)).unwrap();
        sidecar.verify(7, &presentation, &compiled).unwrap();

        let mut wrong_profile = sidecar.clone();
        wrong_profile.fingerprint.low ^= 1;
        assert_eq!(
            wrong_profile.verify(7, &presentation, &compiled),
            Err(ReplayError::PresentationMismatch)
        );
        assert_eq!(
            sidecar.verify(8, &presentation, &compiled),
            Err(ReplayError::AdapterId)
        );

        let mut wrong_generator = sidecar.clone();
        wrong_generator.paths[0] = u32::MAX;
        assert!(matches!(
            wrong_generator.verify(7, &presentation, &compiled),
            Err(ReplayError::Record { .. })
        ));

        let mut missing_witness = sidecar.clone();
        missing_witness.records[0].provenance = NO_PROVENANCE;
        assert!(matches!(
            missing_witness.verify(7, &presentation, &compiled),
            Err(ReplayError::Record { .. })
        ));

        let mut wrong_observation = sidecar;
        wrong_observation.records[0].observation = 1;
        assert!(matches!(
            wrong_observation.verify(7, &presentation, &compiled),
            Err(ReplayError::Record { .. })
        ));
    }
}
