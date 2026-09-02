//! Bounded schema identities for streamed external-proposer requests.
//!
//! Schemas are cold controller data. Tickets retain only the fixed-width
//! identity; providers receive the validated descriptor at claim time.

use super::ProposalRole;
use serde::{Deserialize, Serialize};
use std::collections::{BTreeMap, BTreeSet};

pub const MAX_PROPOSAL_REQUEST_SCHEMAS: usize = 64;
pub const MAX_PROPOSAL_REQUEST_SCHEMA_NAME_BYTES: usize = 96;
pub const MAX_PROPOSAL_SCHEMA_REQUEST_BYTES: u64 = 1024 * 1024;
pub const DEFAULT_PROPOSAL_REQUEST_SCHEMA_NAME: &str = "ergodis.external.byte-stream";
pub const DEFAULT_PROPOSAL_REQUEST_SCHEMA_VERSION: u16 = 1;

#[repr(transparent)]
#[derive(Clone, Copy, Debug, Eq, Hash, Ord, PartialEq, PartialOrd)]
pub struct ProposalRequestSchemaId([u8; 32]);

const _: () = assert!(std::mem::size_of::<ProposalRequestSchemaId>() == 32);
const _: () = assert!(std::mem::align_of::<ProposalRequestSchemaId>() == 1);

impl ProposalRequestSchemaId {
    pub fn from_bytes(bytes: [u8; 32]) -> Self {
        Self(bytes)
    }
    pub fn from_hex(encoded: &str) -> Result<Self, ProposalRequestSchemaError> {
        let digest =
            blake3::Hash::from_hex(encoded).map_err(|_| ProposalRequestSchemaError::InvalidId)?;
        Ok(Self(*digest.as_bytes()))
    }

    pub fn to_hex(self) -> String {
        blake3::Hash::from(self.0).to_hex().to_string()
    }

    pub fn as_bytes(self) -> [u8; 32] {
        self.0
    }
}

#[repr(u8)]
#[derive(Clone, Copy, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum ProposalRequestEncoding {
    ByteStream = 0,
    Utf8 = 1,
    CanonicalJson = 2,
    CanonicalCbor = 3,
    TypedPlan = 4,
}

#[derive(Clone, Debug, Eq, PartialEq)]
pub struct ProposalRequestSchemaSpec {
    id: ProposalRequestSchemaId,
    name: String,
    version: u16,
    encoding: ProposalRequestEncoding,
    maximum_bytes: u64,
    allowed_roles: u8,
    allowed_proposer_ids: Box<[u16]>,
}

impl ProposalRequestSchemaSpec {
    pub fn new(
        name: &str,
        version: u16,
        encoding: ProposalRequestEncoding,
        maximum_bytes: u64,
        allowed_roles: u8,
        allowed_proposer_ids: Box<[u16]>,
    ) -> Result<Self, ProposalRequestSchemaError> {
        validate_name(name)?;
        if version == 0
            || maximum_bytes == 0
            || maximum_bytes > MAX_PROPOSAL_SCHEMA_REQUEST_BYTES
            || allowed_roles == 0
            || allowed_roles & !0x0f != 0
            || allowed_proposer_ids
                .windows(2)
                .any(|pair| pair[0] >= pair[1])
        {
            return Err(ProposalRequestSchemaError::InvalidSpec);
        }
        let id = schema_id(
            name,
            version,
            encoding,
            maximum_bytes,
            allowed_roles,
            &allowed_proposer_ids,
        );
        Ok(Self {
            id,
            name: name.into(),
            version,
            encoding,
            maximum_bytes,
            allowed_roles,
            allowed_proposer_ids,
        })
    }

    pub fn id(&self) -> ProposalRequestSchemaId {
        self.id
    }

    pub fn view(&self) -> ProposalRequestSchemaView {
        ProposalRequestSchemaView {
            id: self.id.to_hex(),
            name: self.name.clone(),
            version: self.version,
            encoding: self.encoding,
            maximum_bytes: self.maximum_bytes,
            allowed_roles: self.allowed_roles,
            allowed_proposer_ids: self.allowed_proposer_ids.clone(),
        }
    }

    fn admits(&self, proposer_id: u16, role: ProposalRole, bytes: u64) -> bool {
        bytes != 0
            && bytes <= self.maximum_bytes
            && self.allowed_roles & role.mask() != 0
            && (self.allowed_proposer_ids.is_empty()
                || self
                    .allowed_proposer_ids
                    .binary_search(&proposer_id)
                    .is_ok())
    }
}

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
#[serde(deny_unknown_fields)]
pub struct ProposalRequestSchemaView {
    pub id: String,
    pub name: String,
    pub version: u16,
    pub encoding: ProposalRequestEncoding,
    pub maximum_bytes: u64,
    pub allowed_roles: u8,
    pub allowed_proposer_ids: Box<[u16]>,
}

#[derive(Clone, Debug)]
pub struct ProposalRequestSchemaRegistry {
    schemas: BTreeMap<ProposalRequestSchemaId, ProposalRequestSchemaSpec>,
}

impl ProposalRequestSchemaRegistry {
    pub fn new(
        schemas: impl IntoIterator<Item = ProposalRequestSchemaSpec>,
    ) -> Result<Self, ProposalRequestSchemaError> {
        let mut by_id = BTreeMap::new();
        let mut logical_names = BTreeSet::new();
        for schema in schemas {
            if by_id.len() == MAX_PROPOSAL_REQUEST_SCHEMAS
                || !logical_names.insert((schema.name.clone(), schema.version))
                || by_id.insert(schema.id, schema).is_some()
            {
                return Err(ProposalRequestSchemaError::InvalidRegistry);
            }
        }
        if by_id.is_empty() {
            return Err(ProposalRequestSchemaError::InvalidRegistry);
        }
        Ok(Self { schemas: by_id })
    }

    pub fn standard() -> Self {
        Self::new([ProposalRequestSchemaSpec::new(
            DEFAULT_PROPOSAL_REQUEST_SCHEMA_NAME,
            DEFAULT_PROPOSAL_REQUEST_SCHEMA_VERSION,
            ProposalRequestEncoding::ByteStream,
            MAX_PROPOSAL_SCHEMA_REQUEST_BYTES,
            0x0f,
            Box::new([]),
        )
        .expect("built-in proposal request schema is valid")])
        .expect("built-in proposal request registry is valid")
    }

    pub fn views(&self) -> Vec<ProposalRequestSchemaView> {
        self.schemas.values().map(|schema| schema.view()).collect()
    }

    pub fn validate(
        &self,
        id: ProposalRequestSchemaId,
        proposer_id: u16,
        role: ProposalRole,
        bytes: u64,
    ) -> Result<&ProposalRequestSchemaSpec, ProposalRequestSchemaError> {
        let schema = self
            .schemas
            .get(&id)
            .ok_or(ProposalRequestSchemaError::UnknownSchema)?;
        if !schema.admits(proposer_id, role, bytes) {
            return Err(ProposalRequestSchemaError::NotAdmitted);
        }
        Ok(schema)
    }

    pub fn get(
        &self,
        id: ProposalRequestSchemaId,
    ) -> Result<&ProposalRequestSchemaSpec, ProposalRequestSchemaError> {
        self.schemas
            .get(&id)
            .ok_or(ProposalRequestSchemaError::UnknownSchema)
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq, thiserror::Error)]
pub enum ProposalRequestSchemaError {
    #[error("proposal request schema identity is invalid")]
    InvalidId,
    #[error("proposal request schema specification is invalid")]
    InvalidSpec,
    #[error("proposal request schema registry is invalid")]
    InvalidRegistry,
    #[error("proposal request schema is unknown")]
    UnknownSchema,
    #[error("proposal request is not admitted by its schema")]
    NotAdmitted,
}

fn validate_name(name: &str) -> Result<(), ProposalRequestSchemaError> {
    if name.is_empty()
        || name.len() > MAX_PROPOSAL_REQUEST_SCHEMA_NAME_BYTES
        || !name.bytes().all(|byte| {
            byte.is_ascii_lowercase() || byte.is_ascii_digit() || matches!(byte, b'.' | b'_' | b'-')
        })
    {
        return Err(ProposalRequestSchemaError::InvalidSpec);
    }
    Ok(())
}

fn schema_id(
    name: &str,
    version: u16,
    encoding: ProposalRequestEncoding,
    maximum_bytes: u64,
    allowed_roles: u8,
    allowed_proposer_ids: &[u16],
) -> ProposalRequestSchemaId {
    let mut hasher = blake3::Hasher::new();
    hasher.update(b"ergodis-proposal-request-schema-v1\0");
    hasher.update(&(name.len() as u64).to_le_bytes());
    hasher.update(name.as_bytes());
    hasher.update(&version.to_le_bytes());
    hasher.update(&[encoding as u8, allowed_roles]);
    hasher.update(&maximum_bytes.to_le_bytes());
    hasher.update(&(allowed_proposer_ids.len() as u64).to_le_bytes());
    for &proposer_id in allowed_proposer_ids {
        hasher.update(&proposer_id.to_le_bytes());
    }
    ProposalRequestSchemaId(*hasher.finalize().as_bytes())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn registry_identity_binds_the_complete_descriptor() {
        let base = ProposalRequestSchemaSpec::new(
            "test.request",
            1,
            ProposalRequestEncoding::CanonicalCbor,
            1024,
            ProposalRole::Heuristic.mask(),
            vec![3, 7].into_boxed_slice(),
        )
        .unwrap();
        let changed = ProposalRequestSchemaSpec::new(
            "test.request",
            2,
            ProposalRequestEncoding::CanonicalCbor,
            1024,
            ProposalRole::Heuristic.mask(),
            vec![3, 7].into_boxed_slice(),
        )
        .unwrap();
        assert_ne!(base.id(), changed.id());
        assert_eq!(
            ProposalRequestSchemaId::from_hex(&base.id().to_hex()).unwrap(),
            base.id()
        );
    }

    #[test]
    fn registry_enforces_role_provider_and_payload_bounds() {
        let schema = ProposalRequestSchemaSpec::new(
            "test.request",
            1,
            ProposalRequestEncoding::TypedPlan,
            8,
            ProposalRole::NecessaryReduction.mask(),
            vec![9].into_boxed_slice(),
        )
        .unwrap();
        let id = schema.id();
        let registry = ProposalRequestSchemaRegistry::new([schema]).unwrap();
        assert!(registry
            .validate(id, 9, ProposalRole::NecessaryReduction, 8)
            .is_ok());
        assert_eq!(
            registry.validate(id, 8, ProposalRole::NecessaryReduction, 8),
            Err(ProposalRequestSchemaError::NotAdmitted)
        );
        assert_eq!(
            registry.validate(id, 9, ProposalRole::Heuristic, 8),
            Err(ProposalRequestSchemaError::NotAdmitted)
        );
        assert_eq!(
            registry.validate(id, 9, ProposalRole::NecessaryReduction, 9),
            Err(ProposalRequestSchemaError::NotAdmitted)
        );
    }

    #[test]
    fn malformed_or_duplicate_registries_fail_closed() {
        assert!(ProposalRequestSchemaSpec::new(
            "Bad Name",
            1,
            ProposalRequestEncoding::Utf8,
            1,
            1,
            Box::new([]),
        )
        .is_err());
        assert!(ProposalRequestSchemaSpec::new(
            "test.request",
            1,
            ProposalRequestEncoding::Utf8,
            1,
            1,
            vec![2, 2].into_boxed_slice(),
        )
        .is_err());
        assert!(ProposalRequestSchemaRegistry::new([]).is_err());
        let schema = ProposalRequestSchemaSpec::new(
            "test.request",
            1,
            ProposalRequestEncoding::Utf8,
            1,
            1,
            Box::new([]),
        )
        .unwrap();
        assert!(ProposalRequestSchemaRegistry::new([schema.clone(), schema]).is_err());
        let first = ProposalRequestSchemaSpec::new(
            "test.ambiguous",
            1,
            ProposalRequestEncoding::Utf8,
            1,
            1,
            Box::new([]),
        )
        .unwrap();
        let second = ProposalRequestSchemaSpec::new(
            "test.ambiguous",
            1,
            ProposalRequestEncoding::Utf8,
            2,
            1,
            Box::new([]),
        )
        .unwrap();
        assert!(ProposalRequestSchemaRegistry::new([first, second]).is_err());
    }
}
