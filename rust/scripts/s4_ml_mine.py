#!/usr/bin/env python3
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "matplotlib",
#   "numpy",
#   "pandas",
#   "scikit-learn",
# ]
# ///
"""ML-style feature mining for S4 dump/query logs.

The input is a cache directory produced by the Rust `s4mine` workflow, with logs named like:

    logs/mine-q19-bucket00.replies.out
    logs/mine-q19-bucket00.depth2.out

The script parses tagged rows, writes feature TSVs, then runs standard-scaled PCA, simple
classifiers, and k-means cluster summaries.  The intent is invariant discovery: use ML to identify
which interpretable columns separate the bulk, not to make proof claims.
"""

from __future__ import annotations

import argparse
import os
import re
import warnings
from pathlib import Path

WORKSPACE_DIR = Path(__file__).resolve().parents[1]
os.environ.setdefault("MPLCONFIGDIR", str(WORKSPACE_DIR / ".uv-cache" / "matplotlib"))
os.environ.setdefault("XDG_CACHE_HOME", str(WORKSPACE_DIR / ".uv-cache" / "xdg"))
(WORKSPACE_DIR / ".uv-cache" / "matplotlib").mkdir(parents=True, exist_ok=True)
(WORKSPACE_DIR / ".uv-cache" / "xdg").mkdir(parents=True, exist_ok=True)

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, balanced_accuracy_score, classification_report
from sklearn.model_selection import train_test_split
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.tree import DecisionTreeClassifier, export_text


KV_RE = re.compile(r"([A-Za-z0-9_]+)=([^ \t]+)")
TARGET_COLUMNS = {"live0", "value_known", "value_P", "value_N"}
ROOT_VALUE_COLUMNS = {"xvalue_N"}
STATE_CHILD_COLUMNS = {
    "child_P",
    "child_N",
    "child_unknown",
    "child_P_frac",
    "child_N_frac",
    "child_unknown_frac",
}


def parse_kv(line: str) -> dict[str, str]:
    return {m.group(1): m.group(2) for m in KV_RE.finditer(line)}


def parse_cell(s: str) -> tuple[int | None, int | None]:
    if "," not in s:
        return None, None
    a, b = s.split(",", 1)
    try:
        return int(a), int(b)
    except ValueError:
        return None, None


def as_int(v: object, default: int = 0) -> int:
    try:
        return int(v)  # type: ignore[arg-type]
    except Exception:
        return default


def load_rows(cache_dir: Path) -> tuple[pd.DataFrame, pd.DataFrame]:
    logs = cache_dir / "logs"
    reply_rows: list[dict[str, object]] = []
    state_rows: list[dict[str, object]] = []

    for path in sorted(logs.glob("mine-*.out")):
        source = path.name
        root_id = source.removeprefix("mine-")
        root_id = re.sub(r"\.(replies|depth[0-9]+)\.out$", "", root_id)
        q_from_name = None
        m = re.search(r"q([0-9]+)", source)
        if m:
            q_from_name = int(m.group(1))

        header_q = q_from_name
        header_t4 = ""
        for line in path.read_text().splitlines():
            if line.startswith("S4MINE "):
                kv = parse_kv(line)
                header_q = as_int(kv.get("q"), q_from_name or 0)
                tm = re.search(r"t4=\[([^\]]+)\]", line)
                if tm:
                    header_t4 = tm.group(1).replace(" ", "")
                continue
            if line.startswith("REPLY "):
                kv = parse_kv(line)
                x_r, x_c = parse_cell(kv.get("x", ""))
                y_r, y_c = parse_cell(kv.get("y", ""))
                row: dict[str, object] = {
                    "source": source,
                    "root": root_id,
                    "q": header_q,
                    "t4": header_t4,
                    "x_r": x_r,
                    "x_c": x_c,
                    "y_r": y_r,
                    "y_c": y_c,
                    "xgeom": kv.get("xgeom", ""),
                    "xvalue": kv.get("xvalue", ""),
                    "ygeom": kv.get("ygeom", ""),
                    "value": kv.get("value", ""),
                }
                for key in ["sel_on", "live_on", "dead_on"]:
                    row[key] = as_int(kv.get(key))
                q = as_int(row["q"])
                if q:
                    row["live_on_frac"] = row["live_on"] / max(q - 1, 1)  # type: ignore[operator]
                    row["dead_on_frac"] = row["dead_on"] / max(q - 1, 1)  # type: ignore[operator]
                row["live0"] = int(row["live_on"] == 0)
                row["value_known"] = int(row["value"] in {"P", "N"})
                row["value_P"] = int(row["value"] == "P")
                row["value_N"] = int(row["value"] == "N")
                row["xvalue_N"] = int(row["xvalue"] == "N")
                reply_rows.append(row)
            elif line.startswith("STATE "):
                kv = parse_kv(line)
                row = {
                    "source": source,
                    "root": root_id,
                    "q": header_q,
                    "t4": header_t4,
                    "value": kv.get("value", ""),
                }
                for key in [
                    "ply",
                    "legal",
                    "legal_root",
                    "legal_on",
                    "legal_ext",
                    "legal_int",
                    "legal_off",
                    "legal_anom",
                    "child_P",
                    "child_N",
                    "child_unknown",
                    "sel_on",
                    "live_on",
                    "dead_on",
                ]:
                    row[key] = as_int(kv.get(key))
                q = as_int(row["q"])
                legal = max(as_int(row["legal"]), 1)
                for key in ["legal_on", "legal_ext", "legal_int", "child_P", "child_N", "child_unknown"]:
                    row[f"{key}_frac"] = as_int(row[key]) / legal
                if q:
                    row["live_on_frac"] = as_int(row["live_on"]) / max(q - 1, 1)
                    row["dead_on_frac"] = as_int(row["dead_on"]) / max(q - 1, 1)
                row["live0"] = int(as_int(row["live_on"]) == 0)
                row["value_known"] = int(row["value"] in {"P", "N"})
                row["value_P"] = int(row["value"] == "P")
                row["value_N"] = int(row["value"] == "N")
                state_rows.append(row)

    return pd.DataFrame(reply_rows), pd.DataFrame(state_rows)


def numeric_feature_frame(df: pd.DataFrame, categorical: list[str], exclude: set[str]) -> pd.DataFrame:
    skip = {"source", "root", "t4", "value", *categorical, *exclude}
    num = df[[c for c in df.columns if c not in skip and pd.api.types.is_numeric_dtype(df[c])]].copy()
    for cat in categorical:
        if cat in df.columns:
            dummies = pd.get_dummies(df[cat], prefix=f"cat_{cat}", dtype=float)
            num = pd.concat([num, dummies], axis=1)
    return num.replace([np.inf, -np.inf], np.nan).fillna(0.0)


def write_pca_report(
    name: str,
    df: pd.DataFrame,
    features: pd.DataFrame,
    out_dir: Path,
    label_col: str,
    max_rows: int,
) -> None:
    if df.empty or features.empty:
        return
    sample = df
    X = features
    if len(df) > max_rows:
        sample = df.sample(max_rows, random_state=1)
        X = features.loc[sample.index]

    scaler = StandardScaler()
    Xs = scaler.fit_transform(X)
    ncomp = min(6, Xs.shape[0], Xs.shape[1])
    pca = PCA(n_components=ncomp, random_state=1)
    coords = pca.fit_transform(Xs)

    proj = pd.DataFrame(coords[:, : min(3, ncomp)], columns=[f"PC{i+1}" for i in range(min(3, ncomp))])
    for col in ["source", "root", "q", label_col, "live0", "value", "xgeom", "ygeom"]:
        if col in sample.columns:
            proj[col] = sample[col].to_numpy()
    proj.to_csv(out_dir / f"{name}-pca-projection.tsv", sep="\t", index=False)

    with (out_dir / f"{name}-pca-report.txt").open("w") as f:
        f.write(f"{name} rows={len(df)} sampled={len(sample)} features={X.shape[1]}\n")
        f.write("explained_variance_ratio=" + ",".join(f"{x:.4f}" for x in pca.explained_variance_ratio_) + "\n\n")
        loadings = pd.DataFrame(
            pca.components_.T,
            index=X.columns,
            columns=[f"PC{i+1}" for i in range(ncomp)],
        )
        for pc in loadings.columns[:4]:
            f.write(f"{pc} top loadings:\n")
            top = loadings[pc].abs().sort_values(ascending=False).head(12).index
            for feat in top:
                f.write(f"  {feat}\t{loadings.loc[feat, pc]:+.4f}\n")
            f.write("\n")

    if ncomp >= 2:
        fig, ax = plt.subplots(figsize=(8, 6))
        qvals = sample["q"].to_numpy() if "q" in sample else np.zeros(len(sample))
        scatter = ax.scatter(coords[:, 0], coords[:, 1], c=qvals, s=8, alpha=0.55, cmap="viridis")
        ax.set_title(f"{name} PCA by q")
        ax.set_xlabel("PC1")
        ax.set_ylabel("PC2")
        fig.colorbar(scatter, ax=ax, label="q")
        fig.tight_layout()
        fig.savefig(out_dir / f"{name}-pca-q.png", dpi=150)
        plt.close(fig)


def sample_rows_for_target(
    df: pd.DataFrame,
    X: pd.DataFrame,
    y: pd.Series,
    max_rows: int,
    random_state: int,
) -> tuple[pd.DataFrame, pd.DataFrame, pd.Series]:
    if len(df) <= max_rows:
        return df, X, y
    parts = []
    rng = np.random.default_rng(random_state)
    counts = y.value_counts()
    if len(counts) == 2:
        minority = counts.idxmin()
        majority = counts.idxmax()
        min_idx = y[y == minority].index
        max_idx = y[y == majority].index
        keep_min = min_idx.to_numpy()
        keep_majority_n = max(0, max_rows - len(keep_min))
        keep_majority_n = min(keep_majority_n, len(max_idx))
        keep_majority = rng.choice(max_idx.to_numpy(), size=keep_majority_n, replace=False)
        idx = np.concatenate([keep_min, keep_majority])
    else:
        per_class = max(1, max_rows // max(len(counts), 1))
        for value in counts.index:
            class_idx = y[y == value].index.to_numpy()
            take = min(per_class, len(class_idx))
            parts.append(rng.choice(class_idx, size=take, replace=False))
        idx = np.concatenate(parts) if parts else np.array([], dtype=int)
    rng.shuffle(idx)
    return df.loc[idx], X.loc[idx], y.loc[idx]


def train_reports(
    name: str,
    df: pd.DataFrame,
    X: pd.DataFrame,
    out_dir: Path,
    targets: list[str],
    max_train_rows: int,
    include_logreg: bool,
    include_forest: bool,
) -> None:
    if df.empty or X.empty:
        return
    with (out_dir / f"{name}-classifiers.txt").open("w") as f:
        for target in targets:
            if target not in df.columns:
                continue
            y = df[target].astype(int)
            counts = y.value_counts().to_dict()
            f.write(f"\nTARGET {target} counts={counts}\n")
            if y.nunique() < 2 or len(df) < 20:
                f.write("  skipped: need at least two classes and 20 rows\n")
                continue
            train_df, train_X, train_y = sample_rows_for_target(df, X, y, max_train_rows, random_state=11)
            f.write(f"  training_rows={len(train_df)} sampled_from={len(df)}\n")
            stratify = train_y if train_y.value_counts().min() >= 2 else None
            X_train, X_test, y_train, y_test = train_test_split(
                train_X, train_y, test_size=0.25, random_state=2, stratify=stratify
            )

            models = [
                (
                    "tree_depth4",
                    DecisionTreeClassifier(max_depth=4, min_samples_leaf=10, class_weight="balanced", random_state=2),
                ),
            ]
            if include_logreg:
                models.insert(
                    0,
                    (
                        "logreg_l1",
                        make_pipeline(
                            StandardScaler(),
                            LogisticRegression(
                                penalty="l1",
                                solver="liblinear",
                                class_weight="balanced",
                                max_iter=1000,
                                random_state=2,
                            ),
                        ),
                    ),
                )
            if include_forest:
                models.append(
                    (
                        "forest",
                        RandomForestClassifier(
                            n_estimators=200,
                            max_depth=7,
                            min_samples_leaf=10,
                            class_weight="balanced_subsample",
                            n_jobs=-1,
                            random_state=2,
                        ),
                    )
                )
            for model_name, model in models:
                with warnings.catch_warnings():
                    warnings.filterwarnings("ignore", category=FutureWarning, module="sklearn.linear_model._logistic")
                    warnings.filterwarnings(
                        "ignore",
                        message="Inconsistent values: penalty=l1.*",
                        category=UserWarning,
                        module="sklearn.linear_model._logistic",
                    )
                    model.fit(X_train, y_train)
                pred = model.predict(X_test)
                f.write(
                    f"  {model_name}: acc={accuracy_score(y_test, pred):.4f} "
                    f"bal_acc={balanced_accuracy_score(y_test, pred):.4f}\n"
                )
                if model_name == "logreg_l1":
                    lr = model.named_steps["logisticregression"]
                    coefs = pd.Series(lr.coef_[0], index=X.columns)
                    for feat, val in coefs.abs().sort_values(ascending=False).head(12).items():
                        f.write(f"    coef {feat}\t{coefs.loc[feat]:+.4f}\n")
                elif model_name == "tree_depth4":
                    f.write(export_text(model, feature_names=list(X.columns), max_depth=4))
                elif model_name == "forest":
                    imps = pd.Series(model.feature_importances_, index=X.columns)
                    for feat, val in imps.sort_values(ascending=False).head(12).items():
                        f.write(f"    importance {feat}\t{val:.4f}\n")
            f.write("  classification_report tree_depth4:\n")
            tree = DecisionTreeClassifier(max_depth=4, min_samples_leaf=10, class_weight="balanced", random_state=2)
            tree.fit(X_train, y_train)
            f.write(classification_report(y_test, tree.predict(X_test), zero_division=0))


def cluster_report(name: str, df: pd.DataFrame, X: pd.DataFrame, out_dir: Path, k: int, max_rows: int) -> None:
    if df.empty or len(df) < k or X.empty:
        return
    sample = df
    Xuse = X
    if len(df) > max_rows:
        sample = df.sample(max_rows, random_state=3)
        Xuse = X.loc[sample.index]
    Xs = StandardScaler().fit_transform(Xuse)
    km = KMeans(n_clusters=k, n_init=20, random_state=3)
    labels = km.fit_predict(Xs)
    tmp = sample.copy()
    tmp["cluster"] = labels
    rows = []
    for cid, part in tmp.groupby("cluster"):
        row = {
            "cluster": cid,
            "n": len(part),
            "q_counts": dict(part["q"].value_counts().sort_index()) if "q" in part else {},
            "live0_rate": float(part["live0"].mean()) if "live0" in part else 0.0,
            "value_counts": dict(part["value"].value_counts()) if "value" in part else {},
        }
        if "ygeom" in part:
            row["ygeom_counts"] = dict(part["ygeom"].value_counts())
        rows.append(row)
    pd.DataFrame(rows).to_csv(out_dir / f"{name}-clusters.tsv", sep="\t", index=False)


def grouped_summary(df: pd.DataFrame, name: str, out_dir: Path) -> None:
    if df.empty:
        return
    groups = []
    cols = ["q", "root"]
    for keys, part in df.groupby(cols):
        row = {"q": keys[0], "root": keys[1], "rows": len(part)}
        for col in ["live0", "value_known", "value_P", "value_N"]:
            if col in part:
                row[f"{col}_sum"] = int(part[col].sum())
                row[f"{col}_rate"] = float(part[col].mean())
        if "value" in part:
            row["value_counts"] = dict(part["value"].value_counts())
        groups.append(row)
    pd.DataFrame(groups).sort_values(["q", "root"]).to_csv(out_dir / f"{name}-group-summary.tsv", sep="\t", index=False)


def value_count_string(part: pd.DataFrame) -> str:
    if "value" not in part:
        return ""
    counts = part["value"].value_counts().to_dict()
    return ",".join(f"{k}:{v}" for k, v in sorted(counts.items()))


def numeric_stats(part: pd.DataFrame, col: str, prefix: str, row: dict[str, object]) -> None:
    if col not in part:
        return
    series = part[col]
    row[f"{prefix}_min"] = int(series.min())
    row[f"{prefix}_max"] = int(series.max())
    row[f"{prefix}_avg"] = float(series.mean())


def joint_summary(df: pd.DataFrame, name: str, out_dir: Path, group_cols: list[str], stats_cols: list[str]) -> None:
    if df.empty:
        return
    rows = []
    for keys, part in df.groupby(group_cols, dropna=False):
        if not isinstance(keys, tuple):
            keys = (keys,)
        row: dict[str, object] = {col: key for col, key in zip(group_cols, keys, strict=True)}
        row["rows"] = len(part)
        for col in ["live0", "value_known", "value_P", "value_N"]:
            if col in part:
                row[f"{col}_sum"] = int(part[col].sum())
                row[f"{col}_rate"] = float(part[col].mean())
        row["value_counts"] = value_count_string(part)
        for col in stats_cols:
            numeric_stats(part, col, col, row)
        rows.append(row)
    pd.DataFrame(rows).sort_values(group_cols + ["rows"], ascending=[True] * len(group_cols) + [False]).to_csv(
        out_dir / f"{name}-joint-summary.tsv", sep="\t", index=False
    )


def expected_live_lower_bound(q: int, xgeom: str, ygeom: str) -> int:
    on_count = int(xgeom == "on") + int(ygeom == "on")
    if on_count == 2:
        return max(0, q - 7)
    if on_count == 1:
        return max(0, q - 13)
    return max(0, q - 19)


def conic_bound_report(replies: pd.DataFrame, out_dir: Path) -> None:
    if replies.empty:
        return
    rows = []
    for (q_raw, xgeom, ygeom), part in replies.groupby(["q", "xgeom", "ygeom"], dropna=False):
        q = int(q_raw)
        live_min = int(part["live_on"].min())
        bound = expected_live_lower_bound(q, str(xgeom), str(ygeom))
        rows.append(
            {
                "q": q,
                "xgeom": xgeom,
                "ygeom": ygeom,
                "rows": len(part),
                "live_min": live_min,
                "live_max": int(part["live_on"].max()),
                "dead_max": int(part["dead_on"].max()),
                "live0_sum": int(part["live0"].sum()),
                "expected_live_lower_bound": bound,
                "slack": live_min - bound,
                "meets_bound": live_min >= bound,
            }
        )
    table = pd.DataFrame(rows).sort_values(["q", "xgeom", "ygeom"])
    table.to_csv(out_dir / "conic-bound-report.tsv", sep="\t", index=False)

    bad = table[~table["meets_bound"]]
    with (out_dir / "conic-bound-report.txt").open("w") as f:
        f.write("Conic two-ply depletion bound from S4 reply rows\n")
        f.write("  off/off lower bound: max(0, q - 19)\n")
        f.write("  off/on lower bound:  max(0, q - 13)\n")
        f.write("  on/on lower bound:   max(0, q - 7)\n")
        f.write("This is a mining check for a proof target, not a proof.\n\n")
        f.write(f"groups={len(table)} failures={len(bad)}\n")
        if len(bad):
            f.write(bad.to_string(index=False))
            f.write("\n")
        else:
            f.write("All mined q/xgeom/ygeom groups meet the proposed lower bound.\n")


def target_group_report(df: pd.DataFrame, name: str, out_dir: Path, targets: list[str], group_cols: list[str]) -> None:
    if df.empty:
        return
    rows = []
    for col in group_cols:
        if col not in df.columns:
            continue
        for value, part in df.groupby(col, dropna=False):
            row = {"feature": col, "value": value, "rows": len(part)}
            for target in targets:
                if target in part:
                    row[f"{target}_sum"] = int(part[target].sum())
                    row[f"{target}_rate"] = float(part[target].mean())
            rows.append(row)
    if rows:
        pd.DataFrame(rows).sort_values(["feature", "rows"], ascending=[True, False]).to_csv(
            out_dir / f"{name}-target-groups.tsv", sep="\t", index=False
        )


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--cache-dir", type=Path, default=Path("s4-dumps/2026-07-08"))
    ap.add_argument("--out-dir", type=Path, default=None)
    ap.add_argument("--max-pca-rows", type=int, default=40000)
    ap.add_argument("--max-cluster-rows", type=int, default=40000)
    ap.add_argument("--max-train-rows", type=int, default=40000)
    ap.add_argument("--cluster", action="store_true", help="Also run k-means cluster summaries.")
    ap.add_argument("--logreg", action="store_true", help="Also train L1 logistic models; slower than tree-only.")
    ap.add_argument("--forest", action="store_true", help="Also train random forests; slower than the default reports.")
    args = ap.parse_args()

    out_dir = args.out_dir or (args.cache_dir / "ml")
    out_dir.mkdir(parents=True, exist_ok=True)

    replies, states = load_rows(args.cache_dir)
    replies.to_csv(out_dir / "reply-features.tsv", sep="\t", index=False)
    states.to_csv(out_dir / "state-features.tsv", sep="\t", index=False)
    grouped_summary(replies, "reply", out_dir)
    grouped_summary(states, "state", out_dir)
    conic_bound_report(replies, out_dir)
    joint_summary(
        replies,
        "reply-geom",
        out_dir,
        ["q", "xgeom", "ygeom"],
        ["sel_on", "live_on", "dead_on"],
    )
    joint_summary(
        replies,
        "reply-geom-value",
        out_dir,
        ["q", "xgeom", "xvalue", "ygeom"],
        ["sel_on", "live_on", "dead_on"],
    )
    joint_summary(
        states,
        "state-shape",
        out_dir,
        ["q", "ply", "sel_on", "live_on"],
        ["legal", "legal_on", "legal_ext", "legal_int", "dead_on"],
    )
    target_group_report(
        replies,
        "reply",
        out_dir,
        ["live0", "value_known", "value_P", "value_N"],
        ["q", "xgeom", "xvalue", "ygeom", "sel_on", "live_on", "dead_on"],
    )
    target_group_report(
        states,
        "state",
        out_dir,
        ["live0", "value_known", "value_P", "value_N"],
        ["q", "ply", "legal_on", "legal_ext", "legal_int", "sel_on", "live_on", "dead_on"],
    )

    feature_sets = [
        (
            "reply-geom",
            replies,
            numeric_feature_frame(replies, ["xgeom", "ygeom"], TARGET_COLUMNS | ROOT_VALUE_COLUMNS),
        ),
        (
            "reply-with-rootvalue",
            replies,
            numeric_feature_frame(replies, ["xgeom", "xvalue", "ygeom"], TARGET_COLUMNS),
        ),
        (
            "state-shape",
            states,
            numeric_feature_frame(states, [], TARGET_COLUMNS | STATE_CHILD_COLUMNS),
        ),
        (
            "state-with-children",
            states,
            numeric_feature_frame(states, [], TARGET_COLUMNS),
        ),
    ]

    for name, df, X in feature_sets:
        write_pca_report(name, df, X, out_dir, "value", args.max_pca_rows)
        train_reports(
            name,
            df,
            X,
            out_dir,
            ["live0", "value_known", "value_P", "value_N"],
            args.max_train_rows,
            args.logreg,
            args.forest,
        )
        if args.cluster:
            cluster_report(name, df, X, out_dir, k=8, max_rows=args.max_cluster_rows)

    with (out_dir / "README.txt").open("w") as f:
        f.write(f"cache_dir={args.cache_dir}\n")
        f.write(f"reply_rows={len(replies)}\n")
        f.write(f"state_rows={len(states)}\n")
        f.write("Feature matrices exclude direct target-label columns; projection TSVs keep labels for inspection.\n")
        f.write("Feature sets:\n")
        for name, _df, X in feature_sets:
            f.write(f"  {name}: features={len(X.columns)}\n")
        f.write(f"L1 logistic reports included: {args.logreg}\n")
        f.write(f"Random forest reports included: {args.forest}\n")
        f.write(f"K-means cluster reports included: {args.cluster}\n")
        f.write(
            "Generated files: feature TSVs, joint summaries, conic-bound reports, "
            "PCA reports/projections/PNGs, classifier reports, optional cluster summaries.\n"
        )
        f.write("Use this as invariant-discovery output, not proof evidence.\n")
    print((out_dir / "README.txt").read_text())


if __name__ == "__main__":
    main()
