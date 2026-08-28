// External comparison driver for VeriFIT/MATA revision
// e8c9310e389b1e62ece7080956550f70ceeed777. This file is not part of the
// Cargo build; compile it against that revision's release libmata.a.
#include <mata/nfa/algorithms.hh>

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <cstdlib>
#include <iostream>
#include <string>

using mata::nfa::Nfa;

static std::uint64_t next_random(std::uint64_t& state) {
    state ^= state << 13;
    state ^= state >> 7;
    state ^= state << 17;
    return state;
}

int main(int argc, char** argv) {
    if (argc != 5 && argc != 6) {
        return 2;
    }
    const std::string family{argv[1]};
    const auto states = static_cast<mata::nfa::State>(std::stoull(argv[2]));
    const auto generators = static_cast<mata::Symbol>(std::stoull(argv[3]));
    const auto repetitions = std::stoull(argv[4]);
    const auto outputs = argc == 6 ? std::stoull(argv[5]) : 2;
    const bool colors = family == "colors";
    if ((family != "chain" && family != "random" && !colors) || outputs < 2
        || (colors && states % outputs != 0)) {
        return 2;
    }
    const auto sink = states;
    Nfa input(colors ? states + 1 : states, {0}, {colors ? sink : states - 1});
    for (mata::Symbol generator = 0; generator < generators; ++generator) {
        std::uint64_t random = 0x9e3779b97f4a7c15ULL ^ generator;
        for (mata::nfa::State state = 0; state < states; ++state) {
            const auto target = colors
                ? static_cast<mata::nfa::State>((state + generator + 1) % states)
                : family == "chain" || generator == 0
                    ? std::min(state + 1, states - 1)
                    : static_cast<mata::nfa::State>(next_random(random) % states);
            input.delta.add(state, generator, target);
        }
    }
    if (colors) {
        // Encode a Moore output c by the unique Boolean-DFA observation word
        // `generators + c -> accepting sink`. The +1 output class is the sink.
        for (mata::nfa::State state = 0; state < states; ++state) {
            input.delta.add(state, generators + state % outputs, sink);
        }
    }
    std::size_t classes = 0;
    const auto start = std::chrono::steady_clock::now();
    for (std::uint64_t repetition = 0; repetition < repetitions; ++repetition) {
        auto output = mata::nfa::algorithms::minimize_hopcroft(input);
        classes = output.num_of_states();
        asm volatile("" : "+r"(classes) : : "memory");
    }
    const auto elapsed = std::chrono::steady_clock::now() - start;
    const auto nanoseconds =
        std::chrono::duration_cast<std::chrono::nanoseconds>(elapsed).count();
    std::cout << "mata\t" << family << '\t' << states << '\t' << generators << '\t'
              << outputs << '\t' << repetitions << '\t' << nanoseconds / repetitions << '\t'
              << classes << "\t-\n";
}
