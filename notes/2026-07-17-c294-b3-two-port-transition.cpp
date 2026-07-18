// C294 B3: exact two-port boundary-transition diagnostic on the fixed separator census.
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
#include <unordered_set>
#include <utility>
#include <vector>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wreturn-type"
#pragma GCC diagnostic ignored "-Wunused-function"
namespace predecessor {
#define contextual_signature_main separator_census_main
#include "2026-07-17-c294-b3-separator-census.cpp"
#undef contextual_signature_main
}  // namespace predecessor
#pragma GCC diagnostic pop

using namespace predecessor;

struct InterfaceLimitReached : std::runtime_error {
    InterfaceLimitReached() : std::runtime_error("interface state limit reached") {}
};

struct BoundaryState {
    Mask mask;
    Mask first;
    Mask second;
    int arity = 0;

    friend bool operator==(const BoundaryState &a, const BoundaryState &b) {
        return a.mask == b.mask && a.first == b.first && a.second == b.second &&
               a.arity == b.arity;
    }
};

struct BoundaryStateHash {
    size_t operator()(const BoundaryState &state) const {
        size_t hash = MaskHash{}(state.mask);
        hash ^= MaskHash{}(state.first) + 0x9e3779b97f4a7c15ULL + (hash << 6) +
                (hash >> 2);
        hash ^= MaskHash{}(state.second) + 0x9e3779b97f4a7c15ULL + (hash << 6) +
                (hash >> 2);
        hash ^= static_cast<size_t>(state.arity) * 0xbf58476d1ce4e5b9ULL;
        return hash;
    }
};

class TwoPortTransition {
  public:
    TwoPortTransition(const std::vector<Mask> &adjacency, size_t state_limit)
        : adjacency_(adjacency), state_limit_(state_limit) {
        closed_.reserve(adjacency.size());
        for (size_t vertex = 0; vertex < adjacency.size(); ++vertex) {
            closed_.push_back(adjacency[vertex] | singleton(static_cast<int>(vertex)));
        }
    }

    int unordered_id(Mask component, int first_port, int second_port) {
        Mask first = adjacency_[first_port] & component;
        Mask second = adjacency_[second_port] & component;
        int forward = interface_id(component, first, second, 2);
        int reverse = interface_id(component, second, first, 2);
        return std::min(forward, reverse);
    }

    uint8_t value(Mask mask) { return closed_nimber(mask); }

    size_t boundary_states() const { return boundary_cache_.size(); }
    size_t closed_states() const { return closed_cache_.size(); }
    size_t interface_nodes() const { return node_ids_.size(); }
    size_t total_states() const { return boundary_states() + closed_states(); }

  private:
    struct Successor {
        int offset = 0;
        int child = 0;
    };

    void claim_state() {
        if (total_states() >= state_limit_) throw InterfaceLimitReached();
    }

    std::vector<Mask> components(Mask mask) const {
        std::vector<Mask> result;
        while (!empty(mask)) {
            Mask seed = mask;
            int first = pop_first(seed);
            Mask component = singleton(first);
            Mask frontier = component;
            while (!empty(frontier)) {
                int vertex = pop_first(frontier);
                Mask fresh = and_not(adjacency_[vertex] & mask, component);
                component = component | fresh;
                frontier = frontier | fresh;
            }
            result.push_back(component);
            mask = and_not(mask, component);
        }
        return result;
    }

    uint8_t closed_nimber(Mask mask) {
        if (empty(mask)) return 0;
        std::vector<Mask> parts = components(mask);
        if (parts.size() > 1) {
            uint8_t value = 0;
            for (Mask part : parts) value ^= closed_nimber(part);
            return value;
        }
        auto found = closed_cache_.find(mask);
        if (found != closed_cache_.end()) return found->second;
        claim_state();
        std::array<uint64_t, 2> seen{};
        Mask moves = mask;
        while (!empty(moves)) {
            int vertex = pop_first(moves);
            uint8_t child = closed_nimber(and_not(mask, closed_[vertex]));
            if (child < 64) seen[0] |= 1ULL << child;
            else seen[1] |= 1ULL << (child - 64);
        }
        uint8_t value;
        if (~seen[0]) value = static_cast<uint8_t>(__builtin_ctzll(~seen[0]));
        else value = static_cast<uint8_t>(64 + __builtin_ctzll(~seen[1]));
        closed_cache_.emplace(mask, value);
        return value;
    }

    Successor successor(Mask mask, Mask first, Mask second, int arity) {
        Mask live_incidence = first;
        if (arity == 2) live_incidence = live_incidence | second;
        Mask live{};
        uint8_t offset = 0;
        for (Mask part : components(mask)) {
            if (!empty(part & live_incidence)) live = live | part;
            else offset ^= closed_nimber(part);
        }
        return {
            offset,
            interface_id(live, first & live, second & live, arity),
        };
    }

    void append_external_result(
        std::vector<int> &encoded,
        Mask mask,
        Mask first,
        Mask second,
        int arity,
        int deleted,
        int selected
    ) {
        Mask remainder = mask;
        if (selected == 0) remainder = and_not(remainder, first);
        if (selected == 1) remainder = and_not(remainder, second);
        int survivor_count = arity - __builtin_popcount(static_cast<unsigned>(deleted));
        if (survivor_count == 0) {
            encoded.push_back(closed_nimber(remainder));
            return;
        }
        Mask next_first{};
        Mask next_second{};
        if ((deleted & 1) == 0) next_first = first & remainder;
        if (arity == 2 && (deleted & 2) == 0) {
            if ((deleted & 1) != 0) next_first = second & remainder;
            else next_second = second & remainder;
        }
        Successor next = successor(
            remainder, next_first, next_second, survivor_count
        );
        encoded.push_back(next.offset);
        encoded.push_back(next.child);
    }

    int interface_id(Mask mask, Mask first, Mask second, int arity) {
        first = first & mask;
        second = arity == 2 ? second & mask : Mask{};
        BoundaryState state{mask, first, second, arity};
        auto memoized = boundary_cache_.find(state);
        if (memoized != boundary_cache_.end()) return memoized->second;
        claim_state();

        std::vector<int> encoded{arity};
        int all_ports = (1 << arity) - 1;
        for (int deleted = 1; deleted <= all_ports; ++deleted) {
            append_external_result(
                encoded, mask, first, second, arity, deleted, -1
            );
            for (int selected = 0; selected < arity; ++selected) {
                if ((deleted & (1 << selected)) == 0) continue;
                append_external_result(
                    encoded, mask, first, second, arity, deleted, selected
                );
            }
        }

        std::vector<std::vector<std::vector<int>>> moves(1 << arity);
        Mask candidates = mask;
        while (!empty(candidates)) {
            int vertex = pop_first(candidates);
            int killed = 0;
            if (!empty(first & singleton(vertex))) killed |= 1;
            if (arity == 2 && !empty(second & singleton(vertex))) killed |= 2;
            Mask remainder = and_not(mask, closed_[vertex]);
            if (killed == all_ports) {
                moves[killed].push_back({closed_nimber(remainder)});
                continue;
            }
            Mask next_first{};
            Mask next_second{};
            int survivor_count = arity - __builtin_popcount(static_cast<unsigned>(killed));
            if ((killed & 1) == 0) next_first = first & remainder;
            if (arity == 2 && (killed & 2) == 0) {
                if (killed & 1) next_first = second & remainder;
                else next_second = second & remainder;
            }
            Successor next = successor(
                remainder, next_first, next_second, survivor_count
            );
            moves[killed].push_back({next.offset, next.child});
        }
        for (auto &by_killed_set : moves) {
            std::sort(by_killed_set.begin(), by_killed_set.end());
            by_killed_set.erase(
                std::unique(by_killed_set.begin(), by_killed_set.end()),
                by_killed_set.end()
            );
            encoded.push_back(static_cast<int>(by_killed_set.size()));
            for (const auto &move : by_killed_set) {
                encoded.insert(encoded.end(), move.begin(), move.end());
            }
        }

        auto found = node_ids_.find(encoded);
        int identifier;
        if (found == node_ids_.end()) {
            identifier = static_cast<int>(node_ids_.size());
            node_ids_.emplace(std::move(encoded), identifier);
        } else {
            identifier = found->second;
        }
        boundary_cache_.emplace(state, identifier);
        return identifier;
    }

    const std::vector<Mask> &adjacency_;
    std::vector<Mask> closed_;
    size_t state_limit_;
    std::unordered_map<Mask, uint8_t, MaskHash> closed_cache_;
    std::unordered_map<BoundaryState, int, BoundaryStateHash> boundary_cache_;
    std::unordered_map<std::vector<int>, int, VectorHash> node_ids_;
};

#ifndef C294_TWO_PORT_TRANSITION_NO_MAIN
int main(int argc, char **argv) {
    if (argc < 3 || argc > 4) {
        std::cerr << "usage: c294-b3-two-port-transition GAME_STATE_LIMIT "
                     "INTERFACE_STATE_LIMIT [OUTPUT]\n";
        return 2;
    }
    size_t game_limit = std::strtoull(argv[1], nullptr, 10);
    size_t interface_limit = std::strtoull(argv[2], nullptr, 10);
    int field_order;
    int type_index;
    int graph_size;
    if (!(std::cin >> field_order >> type_index >> graph_size) ||
        graph_size < 0 || graph_size > 128) return 2;
    SeparatorCensusProbe solver(game_limit);
    solver.adjacency.resize(graph_size);
    solver.closed.resize(graph_size);
    for (int vertex = 0; vertex < graph_size; ++vertex) {
        std::cin >> solver.adjacency[vertex].lo >> solver.adjacency[vertex].hi;
        solver.closed[vertex] = solver.adjacency[vertex] | singleton(vertex);
    }
    Mask root;
    std::cin >> root.lo >> root.hi;
    bool game_stopped = false;
    int value = -1;
    try {
        value = solver.nimber(root);
    } catch (const LimitReached &) {
        game_stopped = true;
    }

    using PieceRecord = std::pair<const std::vector<int> *,
                                  const SeparatorCensusProbe::PieceEntry *>;
    std::vector<PieceRecord> pieces;
    for (const auto &[key, entry] : solver.two_port_pieces_) {
        if (entry.vertices >= 8) pieces.emplace_back(&key, &entry);
    }
    std::sort(pieces.begin(), pieces.end(), [](const auto &a, const auto &b) {
        return *a.first < *b.first;
    });

    TwoPortTransition transition(solver.adjacency, interface_limit);
    struct ClassRecord {
        uint8_t value;
        const std::vector<int> *key;
        const SeparatorCensusProbe::PieceEntry *entry;
    };
    std::unordered_map<int, ClassRecord> classes;
    uint64_t processed = 0;
    uint64_t mergers = 0;
    uint64_t conflicts = 0;
    int maximum_processed_vertices = 0;
    int stopped_piece_vertices = -1;
    bool interface_stopped = false;
    int first_merger_id = -1;
    const SeparatorCensusProbe::PieceEntry *first_merger_prior = nullptr;
    const SeparatorCensusProbe::PieceEntry *first_merger_current = nullptr;
    const auto expanded_piece = [&](const SeparatorCensusProbe::Witness &witness) {
        Mask core = solver.two_core(witness.residual);
        Mask outside = and_not(witness.residual, core);
        Mask expanded = witness.component;
        Mask roots{};
        Mask scan = witness.component;
        while (!empty(scan)) roots = roots | (solver.adjacency[pop_first(scan)] & outside);
        while (!empty(roots)) {
            int root_vertex = pop_first(roots);
            Mask attachment = solver.component_from(root_vertex, outside);
            expanded = expanded | attachment;
            roots = and_not(roots, attachment);
        }
        return expanded;
    };
    for (const auto &[key, entry] : pieces) {
        const auto &witness = entry->first;
        try {
            Mask piece = expanded_piece(witness);
            int identifier = transition.unordered_id(
                piece, witness.first_separator, witness.second_separator
            );
            uint8_t piece_value = transition.value(piece);
            auto [where, inserted] = classes.emplace(
                identifier, ClassRecord{piece_value, key, entry}
            );
            if (!inserted) {
                ++mergers;
                if (where->second.value != piece_value) ++conflicts;
                if (first_merger_prior == nullptr) {
                    first_merger_id = identifier;
                    first_merger_prior = where->second.entry;
                    first_merger_current = entry;
                }
            }
            ++processed;
            maximum_processed_vertices = std::max(
                maximum_processed_vertices, entry->vertices
            );
        } catch (const InterfaceLimitReached &) {
            interface_stopped = true;
            stopped_piece_vertices = entry->vertices;
            break;
        }
    }

    std::ofstream output_file;
    std::ostream *output = &std::cout;
    if (argc == 4) {
        output_file.open(argv[3]);
        if (!output_file) return 2;
        output = &output_file;
    }
    const auto emit_merger_occurrence = [&](const SeparatorCensusProbe::PieceEntry *entry) {
        if (entry == nullptr) {
            *output << "null";
            return;
        }
        const auto &witness = entry->first;
        *output << "{\"component\": ";
        emit_mask(*output, witness.component);
        *output << ", \"residual\": ";
        emit_mask(*output, witness.residual);
        *output << ", \"separators\": [" << witness.first_separator << ", "
                << witness.second_separator << "]}";
    };
    *output << "{\n"
            << "  \"boundary_states\": " << transition.boundary_states() << ",\n"
            << "  \"closed_states\": " << transition.closed_states() << ",\n"
            << "  \"connected_states\": " << solver.connected_states << ",\n"
            << "  \"decompositions\": " << solver.decompositions << ",\n"
            << "  \"field_order\": " << field_order << ",\n"
            << "  \"first_merger\": {\"current\": ";
    emit_merger_occurrence(first_merger_current);
    *output << ", \"interface_id\": " << first_merger_id << ", \"prior\": ";
    emit_merger_occurrence(first_merger_prior);
    *output << "},\n"
            << "  \"follower_nimber\": " << value << ",\n"
            << "  \"game_state_limit\": " << game_limit << ",\n"
            << "  \"game_stopped_at_limit\": "
            << (game_stopped ? "true" : "false") << ",\n"
            << "  \"interface_classes\": " << classes.size() << ",\n"
            << "  \"interface_mergers\": " << mergers << ",\n"
            << "  \"interface_nodes\": " << transition.interface_nodes() << ",\n"
            << "  \"interface_state_limit\": " << interface_limit << ",\n"
            << "  \"interface_stopped_at_limit\": "
            << (interface_stopped ? "true" : "false") << ",\n"
            << "  \"maximum_processed_piece_vertices\": "
            << maximum_processed_vertices << ",\n"
            << "  \"piece_classes_min_8\": " << pieces.size() << ",\n"
            << "  \"processed_piece_classes\": " << processed << ",\n"
            << "  \"stopped_piece_vertices\": " << stopped_piece_vertices << ",\n"
            << "  \"total_interface_states\": " << transition.total_states() << ",\n"
            << "  \"type_index\": " << type_index << ",\n"
            << "  \"value_conflicts\": " << conflicts << "\n"
            << "}\n";
}
#endif
