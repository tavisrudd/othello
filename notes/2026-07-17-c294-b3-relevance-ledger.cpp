// C294 B3 E1: frozen-prefix relevance, xor, frontier, and parity audit.
#define C294_RECURSIVE_SEPARATOR_NORMAL_FORM_NO_MAIN
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-function"
#include "2026-07-17-c294-b3-recursive-separator-normal-form.cpp"
#pragma GCC diagnostic pop
#undef C294_RECURSIVE_SEPARATOR_NORMAL_FORM_NO_MAIN

#include <map>
#include <set>
#include <sstream>

struct CoordinateInput {
    std::array<std::array<int, 3>, 128> targets{};
    std::array<int, 128> sheet{};
    std::array<int, 128> block{};
    std::array<int, 128> position{};
    std::vector<int> order;
    std::vector<std::vector<int>> blocks;
};

struct CandidateAudit {
    std::unordered_map<std::string, std::set<int>> values;
    std::set<std::string> refined;
    bool has_conflict = false;
    Mask conflict_prior{};
    Mask conflict_current{};
    int conflict_prior_value = -1;
    int conflict_current_value = -1;
    std::unordered_map<std::string, std::pair<Mask, int>> first;

    void add(const std::string &key, Mask mask, int value) {
        refined.insert(key + "#" + std::to_string(value));
        auto [where, inserted] = first.emplace(key, std::make_pair(mask, value));
        if (!inserted && where->second.second != value && !has_conflict) {
            has_conflict = true;
            conflict_prior = where->second.first;
            conflict_current = mask;
            conflict_prior_value = where->second.second;
            conflict_current_value = value;
        }
        values[key].insert(value);
    }
};

struct BoundaryWitness {
    bool present = false;
    int cut = -1;
    uint64_t live_word = 0;
    std::vector<int> ports;
    Mask prior{};
    Mask current{};
    int prior_value = -1;
    int current_value = -1;
};

struct XorWitness {
    bool present = false;
    Mask parent{};
    Mask child{};
    int move = -1;
    int child_value = -1;
    std::vector<Mask> components;
    std::vector<int> values;
};

class RelevanceProbe : public RecursiveSeparatorProbe {
  public:
    using RecursiveSeparatorProbe::RecursiveSeparatorProbe;
    using Entry = RecursiveSeparatorProbe::Entry;

    uint8_t nimber(Mask mask) {
        if (empty(mask)) return 0;
        std::vector<Mask> parts = components(mask);
        if (parts.size() != 1) {
            ++decompositions;
            uint8_t value = 0;
            for (Mask part : parts) value ^= nimber(part);
            return value;
        }
        int vertices = size(mask);
        int twice_edges = 0;
        int maximum_degree = 0;
        Mask scan = mask;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            int degree = size(adjacency[vertex] & mask);
            twice_edges += degree;
            maximum_degree = std::max(maximum_degree, degree);
        }
        int edges = twice_edges / 2;
        if (maximum_degree <= 2) {
            ++path_cycle_hits;
            if (edges == vertices - 1) return path_nimber_[vertices];
            if (edges == vertices && vertices >= 3) return cycle_nimber_[vertices];
            throw std::runtime_error("unexpected connected maximum-degree-two graph");
        }
        if (edges == vertices - 1) {
            std::string key = tree_key(mask);
            auto found = tree_cache_.find(key);
            if (found != tree_cache_.end()) {
                ++tree_cache_hits;
                return found->second;
            }
            uint8_t value = evaluate_connected_ledger(mask);
            tree_cache_.emplace(std::move(key), value);
            ++tree_shapes;
            return value;
        }
        if (edges == vertices) {
            std::string key = unicyclic_key(mask);
            auto found = unicyclic_cache_.find(key);
            if (found != unicyclic_cache_.end()) {
                ++unicyclic_cache_hits;
                return found->second;
            }
            uint8_t value = evaluate_connected_ledger(mask);
            unicyclic_cache_.emplace(std::move(key), value);
            ++unicyclic_shapes;
            return value;
        }
        int rank = edges - vertices + 1;
        std::vector<int> absolute_key;
        if (rank >= 2 && rank <= 4) {
            absolute_key = low_cyclomatic_keys(mask, rank).candidate;
            ++low_key_requests;
        } else {
            absolute_key = sparse_absolute_core_key(mask, rank);
            ++high_key_requests;
        }
        auto found = quotient_cache_.find(absolute_key);
        if (found != quotient_cache_.end()) {
            ++quotient_cache_hits;
            return found->second.value;
        }
        uint8_t value = evaluate_connected_ledger(mask);
        std::vector<Candidate> candidates;
        std::vector<Candidate> recursive;
        if (rank >= 5 && !interface_disabled_) {
            try {
                candidates = enumerate_candidates(mask);
                recursive = normal_form(mask, candidates);
            } catch (const InterfaceLimitReached &) {
                interface_stopped_ = true;
                interface_disabled_ = true;
                candidates.clear();
                recursive.clear();
            }
        }
        Entry current{value, mask, absolute_key, {}};
        size_t class_id = parent_.size();
        parent_.push_back(class_id);
        rank_.push_back(0);
        class_value_.push_back(value);
        class_by_absolute_.emplace(absolute_key, class_id);
        for (const Candidate &candidate : candidates) {
            Entry represented = current;
            represented.pieces = {candidate};
            record_representation(abstract_key(mask, represented.pieces), class_id, represented);
        }
        std::vector<Candidate> prefix;
        for (const Candidate &candidate : recursive) {
            prefix.push_back(candidate);
            if (prefix.size() < 2) continue;
            Entry represented = current;
            represented.pieces = prefix;
            record_representation(abstract_key(mask, represented.pieces), class_id, represented);
        }
        if (!candidates.empty()) ++normal_form_insertions;
        quotient_cache_.emplace(absolute_key, std::move(current));
        if (rank >= 2 && rank <= 4) ++low_cyclomatic_shapes;
        return value;
    }

    std::vector<Entry> frozen_entries() const {
        std::vector<Entry> result;
        result.reserve(quotient_cache_.size());
        for (const auto &[key, entry] : quotient_cache_) {
            (void)key;
            result.push_back(entry);
        }
        std::sort(result.begin(), result.end(), [](const Entry &a, const Entry &b) {
            if (size(a.representative) != size(b.representative)) {
                return size(a.representative) < size(b.representative);
            }
            if (a.representative.hi != b.representative.hi) {
                return a.representative.hi < b.representative.hi;
            }
            return a.representative.lo < b.representative.lo;
        });
        return result;
    }

    uint8_t frozen_nimber(Mask mask) { return nimber(mask); }
    std::vector<Mask> split(Mask mask) { return components(mask); }
    const std::vector<std::pair<Mask, uint8_t>> &evaluated_states() const {
        return evaluated_states_;
    }

  private:
    uint8_t evaluate_connected_ledger(Mask mask) {
        if (connected_states >= limit_) {
            limit_vertices = size(mask);
            throw LimitReached();
        }
        int twice_edges = 0;
        Mask scan = mask;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            twice_edges += size(adjacency[vertex] & mask);
        }
        int rank = twice_edges / 2 - size(mask) + 1;
        ++cyclomatic_states[std::min(rank, 16)];
        ++connected_states;
        std::array<uint64_t, 2> seen{};
        Mask moves = mask;
        while (!empty(moves)) {
            int vertex = pop_first(moves);
            uint8_t child = nimber(and_not(mask, closed[vertex]));
            if (child < 64) seen[0] |= 1ULL << child;
            else seen[1] |= 1ULL << (child - 64);
        }
        uint8_t value;
        if (~seen[0]) value = static_cast<uint8_t>(__builtin_ctzll(~seen[0]));
        else value = static_cast<uint8_t>(64 + __builtin_ctzll(~seen[1]));
        evaluated_states_.emplace_back(mask, value);
        return value;
    }

    std::vector<std::pair<Mask, uint8_t>> evaluated_states_;
};

static int cyclomatic(const std::vector<Mask> &adjacency, Mask mask) {
    int twice_edges = 0;
    Mask scan = mask;
    while (!empty(scan)) {
        int vertex = pop_first(scan);
        twice_edges += size(adjacency[vertex] & mask);
    }
    return twice_edges / 2 - size(mask) + 1;
}

static std::vector<std::vector<int>> full_cut_ports(
    const std::vector<Mask> &adjacency, const CoordinateInput &coordinate
) {
    Mask past{};
    std::vector<std::vector<int>> result(coordinate.order.size() + 1);
    for (size_t cut = 0; cut <= coordinate.order.size(); ++cut) {
        if (cut != 0) {
            for (int vertex : coordinate.blocks[coordinate.order[cut - 1]]) {
                past = past | singleton(vertex);
            }
        }
        Mask future{};
        for (size_t index = cut; index < coordinate.order.size(); ++index) {
            for (int vertex : coordinate.blocks[coordinate.order[index]]) {
                future = future | singleton(vertex);
            }
        }
        Mask boundary{};
        Mask scan = past;
        while (!empty(scan)) boundary = boundary | (adjacency[pop_first(scan)] & future);
        while (!empty(boundary)) result[cut].push_back(pop_first(boundary));
    }
    return result;
}

static uint64_t boundary_word(Mask mask, const std::vector<int> &ports) {
    uint64_t result = 0;
    for (size_t index = 0; index < ports.size(); ++index) {
        if (!empty(mask & singleton(ports[index]))) result |= 1ULL << index;
    }
    return result;
}

struct SpatialSummary {
    int live_vertices = 0;
    int nonempty_blocks = 0;
    int partial_blocks = 0;
    int untouched_suffix = 0;
    int maximum_boundary = 0;
    int broken_squares = 0;
    int exposed_third_ports = 0;
    int cross_sheet_defects = 0;
    int defect_patches = 0;
    std::map<int, int> word_histogram;
    std::map<int, int> boundary_width_histogram;
};

static SpatialSummary spatial_summary(
    Mask mask, Mask root, const std::vector<Mask> &adjacency,
    const CoordinateInput &coordinate,
    const std::vector<std::vector<int>> &ports
) {
    SpatialSummary result;
    result.live_vertices = size(mask);
    std::vector<int> words(coordinate.blocks.size(), 0);
    for (size_t block = 0; block < coordinate.blocks.size(); ++block) {
        for (int vertex : coordinate.blocks[block]) {
            if (!empty(mask & singleton(vertex))) words[block] |= 1 << coordinate.position[vertex];
        }
        int live = __builtin_popcount(static_cast<unsigned>(words[block]));
        if (live != 0) ++result.nonempty_blocks;
        if (live != 0 && live != static_cast<int>(coordinate.blocks[block].size())) {
            ++result.partial_blocks;
        }
        if (coordinate.blocks[block].size() == 4 && live != 0 && live != 4) {
            ++result.broken_squares;
        }
        ++result.word_histogram[words[block]];
    }
    for (auto it = coordinate.order.rbegin(); it != coordinate.order.rend(); ++it) {
        bool unchanged = true;
        for (int vertex : coordinate.blocks[*it]) {
            if (empty(mask & singleton(vertex)) != empty(root & singleton(vertex))) {
                unchanged = false;
                break;
            }
        }
        if (!unchanged) break;
        ++result.untouched_suffix;
    }
    for (size_t cut = 0; cut < ports.size(); ++cut) {
        int width = __builtin_popcountll(boundary_word(mask, ports[cut]));
        result.maximum_boundary = std::max(result.maximum_boundary, width);
        ++result.boundary_width_histogram[width];
    }
    Mask scan = mask;
    while (!empty(scan)) {
        int vertex = pop_first(scan);
        int third = coordinate.targets[vertex][1];
        if (empty(mask & singleton(third))) ++result.exposed_third_ports;
        for (int colour = 0; colour < 3; ++colour) {
            int target = coordinate.targets[vertex][colour];
            if (coordinate.sheet[vertex] != coordinate.sheet[target] &&
                empty(mask & singleton(target))) {
                ++result.cross_sheet_defects;
            }
        }
    }
    std::set<int> defective;
    for (size_t block = 0; block < words.size(); ++block) {
        int full = (1 << coordinate.blocks[block].size()) - 1;
        if (words[block] != full) defective.insert(static_cast<int>(block));
    }
    while (!defective.empty()) {
        ++result.defect_patches;
        std::vector<int> stack{*defective.begin()};
        defective.erase(defective.begin());
        while (!stack.empty()) {
            int block = stack.back();
            stack.pop_back();
            for (int vertex : coordinate.blocks[block]) {
                int neighbour = coordinate.block[coordinate.targets[vertex][1]];
                auto found = defective.find(neighbour);
                if (found != defective.end()) {
                    stack.push_back(neighbour);
                    defective.erase(found);
                }
            }
        }
    }
    (void)adjacency;
    return result;
}

static std::string histogram_text(const std::map<int, int> &histogram) {
    std::ostringstream out;
    for (const auto &[key, count] : histogram) out << key << ':' << count << ',';
    return out.str();
}

static std::string candidate_key(int selector, const SpatialSummary &summary) {
    std::ostringstream out;
    if (selector == 0) {
        out << summary.maximum_boundary << '|' << summary.partial_blocks << '|'
            << summary.untouched_suffix << '|' << histogram_text(summary.word_histogram);
    } else if (selector == 1) {
        out << summary.live_vertices << '|' << summary.broken_squares << '|'
            << summary.exposed_third_ports << '|' << summary.cross_sheet_defects << '|'
            << summary.defect_patches;
    } else {
        out << summary.maximum_boundary << '|' << summary.untouched_suffix << '|'
            << histogram_text(summary.boundary_width_histogram) << '|'
            << summary.broken_squares << '|' << summary.exposed_third_ports;
    }
    return out.str();
}

static void emit_json_mask(std::ostream &out, Mask mask) {
    out << "{\"hi\": " << mask.hi << ", \"lo\": " << mask.lo << "}";
}

static void emit_candidate(std::ostream &out, const char *name,
                           const CandidateAudit &audit, size_t total,
                           size_t known_isomorphism_removals) {
    size_t refined_classes = audit.refined.size();
    size_t reduction = total - refined_classes;
    size_t genuine = reduction > known_isomorphism_removals
        ? reduction - known_isomorphism_removals : 0;
    out << "{\"name\": \"" << name << "\", \"raw_classes\": "
        << audit.values.size() << ", \"value_refined_classes\": " << refined_classes
        << ", \"maximum_reduction\": " << reduction
        << ", \"maximum_genuine_removals\": " << genuine
        << ", \"raw_value_conflict\": " << (audit.has_conflict ? "true" : "false")
        << ", \"first_conflict\": ";
    if (!audit.has_conflict) {
        out << "null";
    } else {
        out << "{\"current\": "; emit_json_mask(out, audit.conflict_current);
        out << ", \"current_nimber\": " << audit.conflict_current_value
            << ", \"prior\": "; emit_json_mask(out, audit.conflict_prior);
        out << ", \"prior_nimber\": " << audit.conflict_prior_value << '}';
    }
    out << '}';
}

#ifndef C294_RELEVANCE_LEDGER_NO_MAIN
int main(int argc, char **argv) {
    if (argc < 3 || argc > 4) {
        std::cerr << "usage: c294-b3-relevance-ledger GAME_LIMIT INTERFACE_LIMIT [OUTPUT]\n";
        return 2;
    }
    size_t game_limit = std::strtoull(argv[1], nullptr, 10);
    size_t interface_limit = std::strtoull(argv[2], nullptr, 10);
    int q, type, graph_size;
    if (!(std::cin >> q >> type >> graph_size) || graph_size < 0 || graph_size > 128) return 2;
    RelevanceProbe solver(game_limit, interface_limit);
    solver.adjacency.resize(graph_size);
    solver.closed.resize(graph_size);
    for (int vertex = 0; vertex < graph_size; ++vertex) {
        std::cin >> solver.adjacency[vertex].lo >> solver.adjacency[vertex].hi;
        solver.closed[vertex] = solver.adjacency[vertex] | singleton(vertex);
    }
    Mask root;
    std::cin >> root.lo >> root.hi;
    CoordinateInput coordinate;
    int block_count;
    std::cin >> block_count;
    coordinate.order.resize(block_count);
    coordinate.blocks.resize(block_count);
    for (int &block : coordinate.order) std::cin >> block;
    for (int vertex = 0; vertex < graph_size; ++vertex) {
        std::cin >> coordinate.targets[vertex][0] >> coordinate.targets[vertex][1]
                 >> coordinate.targets[vertex][2] >> coordinate.sheet[vertex]
                 >> coordinate.block[vertex] >> coordinate.position[vertex];
        coordinate.blocks[coordinate.block[vertex]].push_back(vertex);
    }
    solver.initialize_transition();
    bool stopped = false;
    int follower = -1;
    try {
        follower = solver.nimber(root);
    } catch (const LimitReached &) {
        stopped = true;
    }

    const uint64_t frozen_connected = solver.connected_states;
    const uint64_t frozen_decompositions = solver.decompositions;
    const uint64_t frozen_hits = solver.quotient_cache_hits;
    const uint64_t frozen_low_requests = solver.low_key_requests;
    const uint64_t frozen_high_requests = solver.high_key_requests;
    const size_t frozen_classes = solver.quotient_classes();
    std::vector<RelevanceProbe::Entry> entries = solver.frozen_entries();
    auto ports = full_cut_ports(solver.adjacency, coordinate);
    size_t certified_width = 0;
    for (const auto &cut : ports) certified_width = std::max(certified_width, cut.size());

    uint64_t legal_moves = 0;
    uint64_t distinct_children = 0;
    uint64_t distinct_option_values = 0;
    uint64_t p_children = 0;
    uint64_t winning_moves = 0;
    uint64_t p_states = 0;
    uint64_t n_states = 0;
    uint64_t component_emissions = 0;
    uint64_t component_terms = 0;
    uint64_t zero_components = 0;
    uint64_t parity_cancelled_terms = 0;
    uint64_t zero_xor_emissions = 0;
    uint64_t odd_move_states = 0;
    uint64_t odd_distinct_child_states = 0;
    uint64_t odd_p_child_states = 0;
    uint64_t move_terminal_z_states = 0;
    uint64_t generic_high_core_leaves = 0;
    uint64_t maximum_observed_boundary = 0;
    uint64_t total_partial_blocks = 0;
    uint64_t total_untouched_suffix = 0;
    std::map<int, uint64_t> maximum_boundary_histogram;
    std::map<int, uint64_t> boundary_word_frequency;
    CandidateAudit candidates[3];
    BoundaryWitness repeated_boundary;
    XorWitness xor_witness;
    std::unordered_map<std::string, std::pair<Mask, int>> first_boundary;

    for (const auto &entry : entries) {
        Mask mask = entry.representative;
        SpatialSummary spatial = spatial_summary(
            mask, root, solver.adjacency, coordinate, ports
        );
        maximum_observed_boundary = std::max<uint64_t>(
            maximum_observed_boundary, spatial.maximum_boundary
        );
        total_partial_blocks += spatial.partial_blocks;
        total_untouched_suffix += spatial.untouched_suffix;
        ++maximum_boundary_histogram[spatial.maximum_boundary];
        for (size_t cut = 0; cut < ports.size(); ++cut) {
            uint64_t word = boundary_word(mask, ports[cut]);
            ++boundary_word_frequency[__builtin_popcountll(word)];
            if (word == 0) continue;
            std::string key = std::to_string(cut) + ":" + std::to_string(word);
            auto [where, inserted] = first_boundary.emplace(key, std::make_pair(mask, entry.value));
            if (!inserted && where->second.first != mask && !repeated_boundary.present) {
                repeated_boundary.present = true;
                repeated_boundary.cut = static_cast<int>(cut);
                repeated_boundary.live_word = word;
                repeated_boundary.ports = ports[cut];
                repeated_boundary.prior = where->second.first;
                repeated_boundary.current = mask;
                repeated_boundary.prior_value = where->second.second;
                repeated_boundary.current_value = entry.value;
            }
        }
        for (int index = 0; index < 3; ++index) {
            candidates[index].add(candidate_key(index, spatial), mask, entry.value);
        }
        if (cyclomatic(solver.adjacency, mask) >= 5) ++generic_high_core_leaves;
    }

    for (const auto &[mask, state_value] : solver.evaluated_states()) {
        if (state_value == 0) ++p_states;
        else ++n_states;
        std::set<std::pair<uint64_t, uint64_t>> children;
        std::set<int> option_values;
        int local_p_children = 0;
        int local_terminal = 0;
        Mask moves = mask;
        while (!empty(moves)) {
            int vertex = pop_first(moves);
            Mask child = and_not(mask, solver.closed[vertex]);
            ++legal_moves;
            children.emplace(child.hi, child.lo);
            uint8_t child_value = solver.frozen_nimber(child);
            option_values.insert(child_value);
            if (child_value == 0) {
                ++p_children;
                ++local_p_children;
                if (state_value != 0) ++winning_moves;
            }
            if (empty(child)) ++local_terminal;
            std::vector<Mask> parts = solver.split(child);
            if (parts.size() > 1) {
                ++component_emissions;
                component_terms += parts.size();
                std::map<int, int> frequencies;
                int emitted = 0;
                for (Mask part : parts) {
                    int value = solver.frozen_nimber(part);
                    emitted ^= value;
                    ++frequencies[value];
                    if (value == 0) ++zero_components;
                }
                if (!xor_witness.present && size(child) <= 20) {
                    xor_witness.present = true;
                    xor_witness.parent = mask;
                    xor_witness.child = child;
                    xor_witness.move = vertex;
                    xor_witness.child_value = child_value;
                    xor_witness.components = parts;
                    for (Mask part : parts) {
                        xor_witness.values.push_back(solver.frozen_nimber(part));
                    }
                }
                for (const auto &[value, count] : frequencies) {
                    if (value != 0) parity_cancelled_terms += 2 * (count / 2);
                }
                if (emitted == 0) ++zero_xor_emissions;
                if (emitted != child_value) throw std::runtime_error("xor ledger mismatch");
            }
        }
        distinct_children += children.size();
        distinct_option_values += option_values.size();
        if (children.size() & 1U) ++odd_distinct_child_states;
        if (local_p_children & 1) ++odd_p_child_states;
        if (size(mask) & 1) ++odd_move_states;
        if (local_terminal & 1) ++move_terminal_z_states;
    }

    if (solver.connected_states != frozen_connected ||
        solver.quotient_classes() != frozen_classes) {
        throw std::runtime_error("postprocessing changed frozen state set");
    }
    size_t known_iso = q == 5 ? 943 : 3;

    std::ofstream file;
    std::ostream *out = &std::cout;
    if (argc == 4) {
        file.open(argv[3]);
        if (!file) return 2;
        out = &file;
    }
    *out << "{\n"
         << "  \"schema\": \"c294-b3-relevance-ledger-v1\",\n"
         << "  \"field_order\": " << q << ",\n"
         << "  \"type_index\": " << type << ",\n"
         << "  \"fixed_prefix\": {\"connected_states\": " << frozen_connected
         << ", \"decompositions\": " << frozen_decompositions
         << ", \"follower_nimber\": " << follower
         << ", \"game_state_limit\": " << game_limit
         << ", \"high_key_requests\": " << frozen_high_requests
         << ", \"limit_vertices\": " << solver.limit_vertices
         << ", \"low_key_requests\": " << frozen_low_requests
         << ", \"quotient_cache_hits\": " << frozen_hits
         << ", \"quotient_classes\": " << frozen_classes
         << ", \"stopped_at_limit\": " << (stopped ? "true" : "false") << "},\n"
         << "  \"search_relevance\": {\"legal_moves\": " << legal_moves
         << ", \"evaluated_states_audited\": " << solver.evaluated_states().size()
         << ", \"incomplete_states_at_stop\": "
         << frozen_connected - solver.evaluated_states().size()
         << ", \"distinct_exact_children\": " << distinct_children
         << ", \"distinct_option_nimbers\": " << distinct_option_values
         << ", \"duplicate_mex_options\": " << legal_moves - distinct_option_values
         << ", \"p_children\": " << p_children
         << ", \"winning_moves\": " << winning_moves
         << ", \"generic_high_core_leaves\": " << generic_high_core_leaves << "},\n"
         << "  \"xor_bank\": {\"component_emissions\": " << component_emissions
         << ", \"component_terms\": " << component_terms
         << ", \"parity_cancelled_nonzero_terms\": " << parity_cancelled_terms
         << ", \"zero_components\": " << zero_components
         << ", \"zero_xor_emissions\": " << zero_xor_emissions << "},\n"
         << "  \"spatial_relevance\": {\"certified_full_graph_width\": " << certified_width
         << ", \"maximum_observed_residual_width\": " << maximum_observed_boundary
         << ", \"mean_partial_blocks_numerator\": " << total_partial_blocks
         << ", \"mean_untouched_suffix_numerator\": " << total_untouched_suffix
         << ", \"residual_count_denominator\": " << entries.size()
         << ", \"distinct_nonzero_boundary_records\": " << first_boundary.size() << "},\n"
         << "  \"parity_ledger\": {\"states_with_odd_move_count\": " << odd_move_states
         << ", \"states_with_odd_distinct_child_count\": " << odd_distinct_child_states
         << ", \"states_with_odd_p_child_count\": " << odd_p_child_states
         << ", \"p_states\": " << p_states << ", \"n_states\": " << n_states
         << ", \"n_states_with_even_p_child_count\": " << n_states - odd_p_child_states
         << ", \"states_with_odd_one-ply_terminal_count\": " << move_terminal_z_states
         << ", \"move_labelled_terminal_coefficients_above_one_are_zero_by_factorial_pairing\": true},\n"
         << "  \"candidate_headroom\": [";
    emit_candidate(*out, "typed-square-word-histogram", candidates[0], entries.size(), known_iso);
    *out << ", ";
    emit_candidate(*out, "local-defect-motif", candidates[1], entries.size(), known_iso);
    *out << ", ";
    emit_candidate(*out, "boundary-profile", candidates[2], entries.size(), known_iso);
    *out << "],\n  \"first_repeated_boundary_record\": ";
    if (!repeated_boundary.present) {
        *out << "null";
    } else {
        *out << "{\"cut\": " << repeated_boundary.cut
             << ", \"live_word\": " << repeated_boundary.live_word
             << ", \"ports\": [";
        for (size_t index = 0; index < repeated_boundary.ports.size(); ++index) {
            if (index) *out << ", ";
            *out << repeated_boundary.ports[index];
        }
        *out << "], \"prior\": "; emit_json_mask(*out, repeated_boundary.prior);
        *out << ", \"prior_nimber\": " << repeated_boundary.prior_value
             << ", \"current\": "; emit_json_mask(*out, repeated_boundary.current);
        *out << ", \"current_nimber\": " << repeated_boundary.current_value << '}';
    }
    *out << ",\n  \"postprocess_invariants\": {\"connected_states_unchanged\": true, "
         << "\"quotient_classes_unchanged\": true},\n"
         << "  \"first_small_xor_witness\": ";
    if (!xor_witness.present) {
        *out << "null";
    } else {
        *out << "{\"parent\": "; emit_json_mask(*out, xor_witness.parent);
        *out << ", \"move\": " << xor_witness.move << ", \"child\": ";
        emit_json_mask(*out, xor_witness.child);
        *out << ", \"child_nimber\": " << xor_witness.child_value
             << ", \"components\": [";
        for (size_t index = 0; index < xor_witness.components.size(); ++index) {
            if (index) *out << ", ";
            *out << "{\"mask\": "; emit_json_mask(*out, xor_witness.components[index]);
            *out << ", \"nimber\": " << xor_witness.values[index] << '}';
        }
        *out << "]}";
    }
    *out << "\n}\n";
}
#endif
