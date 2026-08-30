use super::{
    ControlError, FeatureBatch, PlanOp, PlanOutput, PlanRole, PlanSpec, MAX_PLAN_OPS, PLAN_SCHEMA,
};

#[derive(Clone, Copy)]
enum LearnedNode {
    Pending,
    Leaf(bool),
    Split {
        field: u16,
        threshold: i64,
        left: u16,
        right: u16,
    },
}

struct TreeTask {
    node: usize,
    depth: usize,
    rows: Vec<u32>,
}

pub(super) fn learn_decision_tree(
    batch: &FeatureBatch,
    max_nodes: usize,
    max_depth: usize,
    training_filter: Option<(usize, i64)>,
) -> Result<(PlanSpec, usize, usize), ControlError> {
    if batch.rows() > u32::MAX as usize {
        return Err(ControlError::Invalid(
            "tree synthesis requires at most u32::MAX rows".into(),
        ));
    }
    let training_rows: Vec<u32> = (0..batch.rows() as u32)
        .filter(|&row| {
            training_filter.is_none_or(|(field, value)| batch.row(row as usize)[field] == value)
        })
        .collect();
    if training_rows.is_empty() {
        return Err(ControlError::Invalid(
            "tree training stratum is empty".into(),
        ));
    }
    let mut nodes = vec![LearnedNode::Pending];
    let mut tasks = vec![TreeTask {
        node: 0,
        depth: 0,
        rows: training_rows,
    }];
    let mut realized_depth = 0usize;
    while let Some(task) = tasks.pop() {
        realized_depth = realized_depth.max(task.depth);
        let (positive, negative) = label_weights(batch, &task.rows);
        if positive == 0 || negative == 0 {
            nodes[task.node] = LearnedNode::Leaf(positive >= negative);
            continue;
        }
        if task.depth == max_depth || nodes.len() + 2 > max_nodes {
            nodes[task.node] = LearnedNode::Leaf(positive >= negative);
            continue;
        }
        let Some((field, threshold)) = best_tree_split(batch, &task.rows) else {
            nodes[task.node] = LearnedNode::Leaf(positive >= negative);
            continue;
        };
        let mut left_rows = Vec::with_capacity(task.rows.len());
        let mut right_rows = Vec::with_capacity(task.rows.len());
        for row in task.rows {
            if batch.row(row as usize)[field] <= threshold {
                left_rows.push(row);
            } else {
                right_rows.push(row);
            }
        }
        if left_rows.is_empty() || right_rows.is_empty() {
            nodes[task.node] = LearnedNode::Leaf(positive >= negative);
            continue;
        }
        let left = nodes.len();
        nodes.push(LearnedNode::Pending);
        let right = nodes.len();
        nodes.push(LearnedNode::Pending);
        nodes[task.node] = LearnedNode::Split {
            field: field as u16,
            threshold,
            left: left as u16,
            right: right as u16,
        };
        tasks.push(TreeTask {
            node: right,
            depth: task.depth + 1,
            rows: right_rows,
        });
        tasks.push(TreeTask {
            node: left,
            depth: task.depth + 1,
            rows: left_rows,
        });
    }

    enum Emit {
        Node(u16),
        Op(PlanOp),
    }
    let mut emit = vec![Emit::Node(0)];
    let mut program = Vec::with_capacity(MAX_PLAN_OPS);
    while let Some(item) = emit.pop() {
        match item {
            Emit::Op(op) => program.push(op),
            Emit::Node(node) => match nodes[node as usize] {
                LearnedNode::Pending => unreachable!(),
                LearnedNode::Leaf(value) => program.push(PlanOp::Const {
                    value: i64::from(value),
                }),
                LearnedNode::Split {
                    field,
                    threshold,
                    left,
                    right,
                } => {
                    emit.push(Emit::Op(PlanOp::Select));
                    emit.push(Emit::Node(right));
                    emit.push(Emit::Node(left));
                    emit.push(Emit::Op(PlanOp::Le));
                    emit.push(Emit::Op(PlanOp::Const { value: threshold }));
                    emit.push(Emit::Op(PlanOp::Field {
                        name: batch.fields[field as usize].clone(),
                    }));
                }
            },
        }
        if program.len() + emit.len() > MAX_PLAN_OPS {
            return Err(ControlError::Invalid(
                "synthesized tree exceeds VM operation limit".into(),
            ));
        }
    }
    Ok((
        PlanSpec {
            schema: PLAN_SCHEMA.into(),
            name: format!("decision-tree-{}-{}", nodes.len(), realized_depth),
            role: PlanRole::Diagnostic,
            output: PlanOutput::Predicate,
            scope: None,
            program,
        },
        nodes.len(),
        realized_depth,
    ))
}

fn label_weights(batch: &FeatureBatch, rows: &[u32]) -> (u64, u64) {
    let mut positive = 0u64;
    let mut negative = 0u64;
    for &row in rows {
        let row = row as usize;
        if batch.expected(row) {
            positive = positive.saturating_add(batch.weights[row]);
        } else {
            negative = negative.saturating_add(batch.weights[row]);
        }
    }
    (positive, negative)
}

fn best_tree_split(batch: &FeatureBatch, rows: &[u32]) -> Option<(usize, i64)> {
    let (total_positive, total_negative) = label_weights(batch, rows);
    let mut best = None;
    let mut scratch = Vec::with_capacity(rows.len());
    for field in 0..batch.fields.len() {
        scratch.clear();
        scratch.extend_from_slice(rows);
        scratch.sort_unstable_by(|&left, &right| {
            batch.row(left as usize)[field]
                .cmp(&batch.row(right as usize)[field])
                .then_with(|| left.cmp(&right))
        });
        let mut left_positive = 0u64;
        let mut left_negative = 0u64;
        for position in 0..scratch.len().saturating_sub(1) {
            let row = scratch[position] as usize;
            if batch.expected(row) {
                left_positive = left_positive.saturating_add(batch.weights[row]);
            } else {
                left_negative = left_negative.saturating_add(batch.weights[row]);
            }
            let value = batch.row(row)[field];
            let next_value = batch.row(scratch[position + 1] as usize)[field];
            if value == next_value {
                continue;
            }
            let right_positive = total_positive.saturating_sub(left_positive);
            let right_negative = total_negative.saturating_sub(left_negative);
            let errors = left_positive.min(left_negative) + right_positive.min(right_negative);
            let candidate = (errors, field, value);
            if best.is_none_or(|current| candidate < current) {
                best = Some(candidate);
            }
        }
    }
    best.map(|(_, field, threshold)| (field, threshold))
}
