# CARAT check for the type-I1 rank-three quotient character lattice.
# Load RatProbAlgTori.gap first.

if not IsBound(CaratZClass) then
    Error("load RatProbAlgTori.gap before this checker");
fi;
SetPrintFormattingStatus("*stdout*", false);

characterGroup := Group([
    [[-1,0,0],[1,1,-1],[0,0,-1]],
    [[0,-1,0],[-1,0,0],[0,0,-1]]
]);;
id := CaratZClass(characterGroup);;
if id <> [3,25,2] then
    Error("unexpected rank-three quotient CARAT class");
fi;

# Kunyavskii's complete exceptional list, converted to CARAT identifiers as
# displayed in Hoshi--Yamasaki, Theorem 1.2 and Example 5.3.  A rank-three
# torus is non-rational exactly for these fifteen classes.
nonrationalRankThree := [
    [3,6,3], [3,8,3], [3,8,4], [3,15,2], [3,13,2],
    [3,14,4], [3,9,2], [3,28,1], [3,29,1], [3,29,3],
    [3,31,1], [3,31,3], [3,30,1], [3,32,1], [3,32,3]
];;
if id in nonrationalRankThree then
    Error("rank-three quotient unexpectedly lies in Kunyavskii's list");
fi;

Print("rank_three_quotient_character_carat=", id, "\n");
Print("rank_three_quotient_kunyavskii_rational=true\n");
QUIT;
