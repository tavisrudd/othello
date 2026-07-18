// C294 B3: fixed-prefix census of labelled pieces behind high-core separators.
#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <limits>
#include <map>
#include <numeric>
#include <set>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wreturn-type"
#pragma GCC diagnostic ignored "-Wunused-function"
#define private public
#define main contextual_signature_main
#include "2026-07-17-c294-b2-contextual-signature.cpp"
#pragma GCC diagnostic pop
#undef main
#undef private

class SeparatorCensusProbe : public Solver {
  public:
    explicit SeparatorCensusProbe(size_t limit) : Solver(limit) {}

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
            uint8_t value = evaluate_connected(mask);
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
            uint8_t value = evaluate_connected(mask);
            unicyclic_cache_.emplace(std::move(key), value);
            ++unicyclic_shapes;
            return value;
        }

        int cyclomatic = edges - vertices + 1;
        std::vector<int> absolute_key;
        if (cyclomatic >= 2 && cyclomatic <= 4) {
            absolute_key = low_cyclomatic_keys(mask, cyclomatic).candidate;
            ++low_key_requests;
        } else {
            absolute_key = sparse_absolute_core_key(mask, cyclomatic);
            ++high_key_requests;
        }
        auto found = quotient_cache_.find(absolute_key);
        if (found != quotient_cache_.end()) {
            ++quotient_cache_hits;
            return found->second;
        }

        uint8_t value = evaluate_connected(mask);
        quotient_cache_.emplace(absolute_key, value);
        if (cyclomatic >= 2 && cyclomatic <= 4) {
            ++low_cyclomatic_shapes;
        } else {
            record_high_core(mask, cyclomatic);
        }
        return value;
    }

    struct Witness {
        Mask residual;
        Mask component;
        int first_separator = -1;
        int second_separator = -1;
        uint64_t core_id = 0;
    };

    struct PieceEntry {
        uint64_t occurrences = 0;
        uint64_t core_classes = 0;
        uint64_t last_core_id = std::numeric_limits<uint64_t>::max();
        int vertices = 0;
        bool has_first = false;
        Witness first;
        bool has_cross_core = false;
        Witness cross_core;
    };

    struct Summary {
        uint64_t occurrences = 0;
        uint64_t classes = 0;
        uint64_t repeated_classes = 0;
        uint64_t cross_core_classes = 0;
        uint64_t occurrences_in_repeated_classes = 0;
        uint64_t occurrences_in_cross_core_classes = 0;
        uint64_t maximum_occurrences = 0;
        uint64_t maximum_core_classes = 0;
        int maximum_repeated_vertices = 0;
        int maximum_cross_core_vertices = 0;
    };

    uint64_t quotient_cache_hits = 0;
    uint64_t low_key_requests = 0;
    uint64_t high_key_requests = 0;
    uint64_t high_absolute_classes = 0;
    uint64_t high_isomorphism_classes = 0;
    uint64_t high_isomorphic_duplicates = 0;
    uint64_t one_separator_sites = 0;
    uint64_t two_separator_sites = 0;
    uint64_t two_separator_components = 0;
    uint64_t genuine_two_port_components = 0;

    size_t quotient_classes() const { return quotient_cache_.size(); }

    Summary one_summary(int minimum_vertices) const {
        return summarize(one_port_pieces_, minimum_vertices);
    }

    Summary two_summary(int minimum_vertices) const {
        return summarize(two_port_pieces_, minimum_vertices);
    }

    const PieceEntry *first_cross_core_one(int minimum_vertices) const {
        return first_cross_core(one_port_pieces_, minimum_vertices);
    }

    const PieceEntry *first_cross_core_two(int minimum_vertices) const {
        return first_cross_core(two_port_pieces_, minimum_vertices);
    }

  private:
    using PieceMap = std::unordered_map<std::vector<int>, PieceEntry, VectorHash>;

    uint8_t evaluate_connected(Mask mask) {
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
        int cyclomatic = twice_edges / 2 - size(mask) + 1;
        ++cyclomatic_states[std::min(cyclomatic, 16)];
        ++connected_states;

        std::array<uint64_t, 2> seen{};
        Mask moves = mask;
        while (!empty(moves)) {
            int vertex = pop_first(moves);
            uint8_t child = nimber(and_not(mask, closed[vertex]));
            if (child < 64) seen[0] |= 1ULL << child;
            else seen[1] |= 1ULL << (child - 64);
        }
        if (~seen[0]) return static_cast<uint8_t>(__builtin_ctzll(~seen[0]));
        return static_cast<uint8_t>(64 + __builtin_ctzll(~seen[1]));
    }

    Mask two_core(Mask mask) const {
        std::array<int, 128> degree{};
        std::vector<int> leaves;
        Mask core = mask;
        Mask scan = mask;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            degree[vertex] = size(adjacency[vertex] & mask);
            if (degree[vertex] == 1) leaves.push_back(vertex);
        }
        while (!leaves.empty()) {
            std::vector<int> next;
            for (int leaf : leaves) {
                core = and_not(core, singleton(leaf));
                Mask neighbours = adjacency[leaf] & core;
                while (!empty(neighbours)) {
                    int neighbour = pop_first(neighbours);
                    if (--degree[neighbour] == 1) next.push_back(neighbour);
                }
            }
            leaves = std::move(next);
        }
        return core;
    }

    std::vector<int> sparse_absolute_core_key(Mask mask, int cyclomatic) {
        Mask core = two_core(mask);
        std::vector<int> key{
            cyclomatic,
            static_cast<int>(core.lo & 0xffffffffULL),
            static_cast<int>(core.lo >> 32),
            static_cast<int>(core.hi & 0xffffffffULL),
            static_cast<int>(core.hi >> 32),
        };
        size_t count_index = key.size();
        key.push_back(0);
        int labelled = 0;
        Mask scan = core;
        Mask outside = and_not(mask, core);
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            if (empty(adjacency[vertex] & outside)) continue;
            key.push_back(vertex);
            key.push_back(attachment_signature_label(vertex, mask, core));
            ++labelled;
        }
        key[count_index] = labelled;
        return key;
    }

    static std::vector<int> normalize_signatures(
        const std::vector<std::vector<int>> &signatures
    ) {
        std::vector<std::vector<int>> ordered = signatures;
        std::sort(ordered.begin(), ordered.end());
        ordered.erase(std::unique(ordered.begin(), ordered.end()), ordered.end());
        std::vector<int> colors;
        colors.reserve(signatures.size());
        for (const auto &signature : signatures) {
            colors.push_back(static_cast<int>(
                std::lower_bound(ordered.begin(), ordered.end(), signature) - ordered.begin()
            ));
        }
        return colors;
    }

    std::vector<int> refine_colors(
        const std::vector<std::vector<int>> &neighbours,
        std::vector<int> colors
    ) const {
        while (true) {
            std::vector<std::vector<int>> signatures(colors.size());
            for (size_t vertex = 0; vertex < colors.size(); ++vertex) {
                signatures[vertex].push_back(colors[vertex]);
                std::vector<int> adjacent;
                for (int neighbour : neighbours[vertex]) adjacent.push_back(colors[neighbour]);
                std::sort(adjacent.begin(), adjacent.end());
                signatures[vertex].insert(
                    signatures[vertex].end(), adjacent.begin(), adjacent.end()
                );
            }
            std::vector<int> next = normalize_signatures(signatures);
            if (next == colors) return colors;
            colors = std::move(next);
        }
    }

    std::vector<int> discrete_encoding(
        int tag,
        const std::vector<std::vector<int>> &neighbours,
        const std::vector<int> &labels,
        const std::vector<int> &colors
    ) const {
        std::vector<int> order(colors.size());
        std::iota(order.begin(), order.end(), 0);
        std::sort(order.begin(), order.end(), [&](int first, int second) {
            return colors[first] < colors[second];
        });
        std::vector<int> inverse(colors.size());
        for (size_t index = 0; index < order.size(); ++index) {
            inverse[order[index]] = static_cast<int>(index);
        }
        std::vector<int> encoded{tag, static_cast<int>(order.size())};
        for (int vertex : order) encoded.push_back(labels[vertex]);
        for (size_t first = 0; first < order.size(); ++first) {
            std::vector<int> adjacent;
            for (int neighbour : neighbours[order[first]]) {
                int second = inverse[neighbour];
                if (second > static_cast<int>(first)) adjacent.push_back(second);
            }
            std::sort(adjacent.begin(), adjacent.end());
            encoded.push_back(static_cast<int>(adjacent.size()));
            encoded.insert(encoded.end(), adjacent.begin(), adjacent.end());
        }
        return encoded;
    }

    void canonical_search(
        int tag,
        const std::vector<std::vector<int>> &neighbours,
        const std::vector<int> &labels,
        std::vector<int> colors,
        std::vector<int> &best
    ) const {
        colors = refine_colors(neighbours, std::move(colors));
        std::map<int, std::vector<int>> cells;
        for (size_t vertex = 0; vertex < colors.size(); ++vertex) {
            cells[colors[vertex]].push_back(static_cast<int>(vertex));
        }
        auto cell = std::find_if(cells.begin(), cells.end(), [](const auto &entry) {
            return entry.second.size() > 1;
        });
        if (cell == cells.end()) {
            std::vector<int> encoded = discrete_encoding(tag, neighbours, labels, colors);
            if (best.empty() || encoded < best) best = std::move(encoded);
            return;
        }
        for (int selected : cell->second) {
            std::vector<std::vector<int>> signatures(colors.size());
            for (size_t vertex = 0; vertex < colors.size(); ++vertex) {
                signatures[vertex] = {
                    colors[vertex], vertex == static_cast<size_t>(selected) ? 1 : 0
                };
            }
            canonical_search(
                tag, neighbours, labels, normalize_signatures(signatures), best
            );
        }
    }

    std::vector<int> canonical_graph_key(
        int tag,
        const std::vector<std::vector<int>> &neighbours,
        const std::vector<int> &labels
    ) const {
        std::vector<std::vector<int>> initial(neighbours.size());
        for (size_t vertex = 0; vertex < neighbours.size(); ++vertex) {
            initial[vertex] = {static_cast<int>(neighbours[vertex].size()), labels[vertex]};
        }
        std::vector<int> best;
        canonical_search(tag, neighbours, labels, normalize_signatures(initial), best);
        return best;
    }

    std::vector<int> canonical_high_core_key(Mask mask, int cyclomatic) {
        Mask core = two_core(mask);
        std::vector<int> vertices;
        std::array<int, 128> local_index{};
        local_index.fill(-1);
        Mask scan = core;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            local_index[vertex] = static_cast<int>(vertices.size());
            vertices.push_back(vertex);
        }
        std::vector<std::vector<int>> neighbours(vertices.size());
        std::vector<int> labels(vertices.size());
        for (size_t index = 0; index < vertices.size(); ++index) {
            int vertex = vertices[index];
            Mask adjacent = adjacency[vertex] & core;
            while (!empty(adjacent)) {
                neighbours[index].push_back(local_index[pop_first(adjacent)]);
            }
            labels[index] = attachment_signature_label(vertex, mask, core);
        }
        return canonical_graph_key(cyclomatic, neighbours, labels);
    }

    std::vector<int> piece_key(
        Mask residual,
        Mask core,
        Mask component,
        int first_separator,
        int second_separator
    ) {
        std::vector<int> vertices;
        std::array<int, 128> local_index{};
        local_index.fill(-1);
        Mask scan = component;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            local_index[vertex] = static_cast<int>(vertices.size());
            vertices.push_back(vertex);
        }
        int ports = second_separator < 0 ? 1 : 2;
        size_t total = vertices.size() + static_cast<size_t>(ports);
        std::vector<std::vector<int>> neighbours(total);
        std::vector<int> labels(total, -1);
        for (size_t index = 0; index < vertices.size(); ++index) {
            int vertex = vertices[index];
            Mask adjacent = adjacency[vertex] & component;
            while (!empty(adjacent)) {
                neighbours[index].push_back(local_index[pop_first(adjacent)]);
            }
            labels[index] = attachment_signature_label(vertex, residual, core);
            if (!empty(adjacency[vertex] & singleton(first_separator))) {
                neighbours[index].push_back(static_cast<int>(vertices.size()));
                neighbours[vertices.size()].push_back(static_cast<int>(index));
            }
            if (ports == 2 && !empty(adjacency[vertex] & singleton(second_separator))) {
                neighbours[index].push_back(static_cast<int>(vertices.size() + 1));
                neighbours[vertices.size() + 1].push_back(static_cast<int>(index));
            }
        }
        return canonical_graph_key(-ports, neighbours, labels);
    }

    void record_piece(
        PieceMap &pieces,
        std::vector<int> key,
        const Witness &witness,
        int vertices
    ) {
        PieceEntry &entry = pieces[std::move(key)];
        ++entry.occurrences;
        entry.vertices = vertices;
        if (entry.last_core_id != witness.core_id) {
            ++entry.core_classes;
            entry.last_core_id = witness.core_id;
        }
        if (!entry.has_first) {
            entry.has_first = true;
            entry.first = witness;
        } else if (!entry.has_cross_core && entry.first.core_id != witness.core_id) {
            entry.has_cross_core = true;
            entry.cross_core = witness;
        }
    }

    void census_core(Mask residual, Mask core, uint64_t core_id) {
        Mask vertices = core;
        while (!empty(vertices)) {
            int separator = pop_first(vertices);
            Mask remainder = and_not(core, singleton(separator));
            std::vector<Mask> parts = components(remainder);
            if (parts.size() < 2) continue;
            ++one_separator_sites;
            for (Mask component : parts) {
                Witness witness{residual, component, separator, -1, core_id};
                record_piece(
                    one_port_pieces_,
                    piece_key(residual, core, component, separator, -1),
                    witness,
                    size(component)
                );
            }
        }

        std::vector<int> core_vertices;
        vertices = core;
        while (!empty(vertices)) core_vertices.push_back(pop_first(vertices));
        for (size_t first = 0; first < core_vertices.size(); ++first) {
            for (size_t second = first + 1; second < core_vertices.size(); ++second) {
                int a = core_vertices[first];
                int b = core_vertices[second];
                Mask remainder = and_not(and_not(core, singleton(a)), singleton(b));
                std::vector<Mask> parts = components(remainder);
                if (parts.size() < 2) continue;
                ++two_separator_sites;
                two_separator_components += parts.size();
                for (Mask component : parts) {
                    bool touches_a = !empty(adjacency[a] & component);
                    bool touches_b = !empty(adjacency[b] & component);
                    if (!touches_a || !touches_b) continue;
                    ++genuine_two_port_components;
                    Witness witness{residual, component, a, b, core_id};
                    record_piece(
                        two_port_pieces_,
                        piece_key(residual, core, component, a, b),
                        witness,
                        size(component)
                    );
                }
            }
        }
    }

    void record_high_core(Mask mask, int cyclomatic) {
        ++high_absolute_classes;
        std::vector<int> canonical = canonical_high_core_key(mask, cyclomatic);
        if (!canonical_high_cores_.insert(canonical).second) {
            ++high_isomorphic_duplicates;
            return;
        }
        ++high_isomorphism_classes;
        census_core(mask, two_core(mask), high_isomorphism_classes);
    }

    static Summary summarize(const PieceMap &pieces, int minimum_vertices) {
        Summary result;
        for (const auto &[key, entry] : pieces) {
            (void)key;
            if (entry.vertices < minimum_vertices) continue;
            result.occurrences += entry.occurrences;
            ++result.classes;
            result.maximum_occurrences =
                std::max(result.maximum_occurrences, entry.occurrences);
            result.maximum_core_classes =
                std::max(result.maximum_core_classes, entry.core_classes);
            if (entry.occurrences >= 2) {
                ++result.repeated_classes;
                result.occurrences_in_repeated_classes += entry.occurrences;
                result.maximum_repeated_vertices =
                    std::max(result.maximum_repeated_vertices, entry.vertices);
            }
            if (entry.core_classes >= 2) {
                ++result.cross_core_classes;
                result.occurrences_in_cross_core_classes += entry.occurrences;
                result.maximum_cross_core_vertices =
                    std::max(result.maximum_cross_core_vertices, entry.vertices);
            }
        }
        return result;
    }

    static const PieceEntry *first_cross_core(
        const PieceMap &pieces,
        int minimum_vertices
    ) {
        const PieceEntry *best = nullptr;
        const std::vector<int> *best_key = nullptr;
        for (const auto &[key, entry] : pieces) {
            if (!entry.has_cross_core || entry.vertices < minimum_vertices) continue;
            if (best == nullptr || entry.vertices < best->vertices ||
                (entry.vertices == best->vertices &&
                 (entry.first.core_id < best->first.core_id ||
                  (entry.first.core_id == best->first.core_id && key < *best_key)))) {
                best = &entry;
                best_key = &key;
            }
        }
        return best;
    }

    std::unordered_map<std::vector<int>, uint8_t, VectorHash> quotient_cache_;
    std::set<std::vector<int>> canonical_high_cores_;
    PieceMap one_port_pieces_;
    PieceMap two_port_pieces_;
};

static void emit_summary(std::ostream &output, const SeparatorCensusProbe::Summary &summary) {
    output << "{\"classes\": " << summary.classes
           << ", \"cross_core_classes\": " << summary.cross_core_classes
           << ", \"maximum_core_classes\": " << summary.maximum_core_classes
           << ", \"maximum_cross_core_vertices\": " << summary.maximum_cross_core_vertices
           << ", \"maximum_occurrences\": " << summary.maximum_occurrences
           << ", \"maximum_repeated_vertices\": " << summary.maximum_repeated_vertices
           << ", \"occurrences\": " << summary.occurrences
           << ", \"occurrences_in_cross_core_classes\": "
           << summary.occurrences_in_cross_core_classes
           << ", \"occurrences_in_repeated_classes\": "
           << summary.occurrences_in_repeated_classes
           << ", \"repeated_classes\": " << summary.repeated_classes << "}";
}

static void emit_mask(std::ostream &output, Mask mask) {
    output << "{\"hi\": " << mask.hi << ", \"lo\": " << mask.lo << "}";
}

static void emit_witness(
    std::ostream &output,
    const SeparatorCensusProbe::PieceEntry *entry
) {
    if (entry == nullptr) {
        output << "null";
        return;
    }
    const auto emit_occurrence = [&](const SeparatorCensusProbe::Witness &witness) {
        output << "{\"component\": ";
        emit_mask(output, witness.component);
        output << ", \"core_id\": " << witness.core_id << ", \"residual\": ";
        emit_mask(output, witness.residual);
        output << ", \"separators\": [" << witness.first_separator;
        if (witness.second_separator >= 0) output << ", " << witness.second_separator;
        output << "]}";
    };
    output << "{\"component_vertices\": " << entry->vertices << ", \"current\": ";
    emit_occurrence(entry->cross_core);
    output << ", \"prior\": ";
    emit_occurrence(entry->first);
    output << "}";
}

int main(int argc, char **argv) {
    if (argc < 2 || argc > 3) {
        std::cerr << "usage: c294-b3-separator-census STATE_LIMIT [OUTPUT]\n";
        return 2;
    }
    size_t limit = std::strtoull(argv[1], nullptr, 10);
    int field_order;
    int type_index;
    int graph_size;
    if (!(std::cin >> field_order >> type_index >> graph_size) ||
        graph_size < 0 || graph_size > 128) return 2;
    SeparatorCensusProbe solver(limit);
    solver.adjacency.resize(graph_size);
    solver.closed.resize(graph_size);
    for (int vertex = 0; vertex < graph_size; ++vertex) {
        std::cin >> solver.adjacency[vertex].lo >> solver.adjacency[vertex].hi;
        solver.closed[vertex] = solver.adjacency[vertex] | singleton(vertex);
    }
    Mask root;
    std::cin >> root.lo >> root.hi;
    bool stopped = false;
    int value = -1;
    try {
        value = solver.nimber(root);
    } catch (const LimitReached &) {
        stopped = true;
    }

    std::ofstream output_file;
    std::ostream *output = &std::cout;
    if (argc == 3) {
        output_file.open(argv[2]);
        if (!output_file) return 2;
        output = &output_file;
    }
    *output << "{\n"
            << "  \"connected_states\": " << solver.connected_states << ",\n"
            << "  \"decompositions\": " << solver.decompositions << ",\n"
            << "  \"field_order\": " << field_order << ",\n"
            << "  \"follower_nimber\": " << value << ",\n"
            << "  \"genuine_two_port_components\": "
            << solver.genuine_two_port_components << ",\n"
            << "  \"high_absolute_classes\": " << solver.high_absolute_classes << ",\n"
            << "  \"high_isomorphic_duplicates\": "
            << solver.high_isomorphic_duplicates << ",\n"
            << "  \"high_isomorphism_classes\": "
            << solver.high_isomorphism_classes << ",\n"
            << "  \"high_key_requests\": " << solver.high_key_requests << ",\n"
            << "  \"limit_vertices\": " << solver.limit_vertices << ",\n"
            << "  \"low_key_requests\": " << solver.low_key_requests << ",\n"
            << "  \"one_port_first_cross_core_witness\": ";
    emit_witness(*output, solver.first_cross_core_one(1));
    *output << ",\n  \"one_port_min_8_cross_core_witness\": ";
    emit_witness(*output, solver.first_cross_core_one(8));
    *output << ",\n  \"one_port_min_1\": ";
    emit_summary(*output, solver.one_summary(1));
    *output << ",\n  \"one_port_min_4\": ";
    emit_summary(*output, solver.one_summary(4));
    *output << ",\n  \"one_port_min_8\": ";
    emit_summary(*output, solver.one_summary(8));
    *output << ",\n  \"one_separator_sites\": " << solver.one_separator_sites << ",\n"
            << "  \"quotient_cache_hits\": " << solver.quotient_cache_hits << ",\n"
            << "  \"quotient_classes\": " << solver.quotient_classes() << ",\n"
            << "  \"state_limit\": " << limit << ",\n"
            << "  \"stopped_at_limit\": " << (stopped ? "true" : "false") << ",\n"
            << "  \"two_port_first_cross_core_witness\": ";
    emit_witness(*output, solver.first_cross_core_two(1));
    *output << ",\n  \"two_port_min_8_cross_core_witness\": ";
    emit_witness(*output, solver.first_cross_core_two(8));
    *output << ",\n  \"two_port_min_1\": ";
    emit_summary(*output, solver.two_summary(1));
    *output << ",\n  \"two_port_min_4\": ";
    emit_summary(*output, solver.two_summary(4));
    *output << ",\n  \"two_port_min_8\": ";
    emit_summary(*output, solver.two_summary(8));
    *output << ",\n  \"two_separator_components\": "
            << solver.two_separator_components << ",\n"
            << "  \"two_separator_sites\": " << solver.two_separator_sites << ",\n"
            << "  \"type_index\": " << type_index << "\n"
            << "}\n";
}
