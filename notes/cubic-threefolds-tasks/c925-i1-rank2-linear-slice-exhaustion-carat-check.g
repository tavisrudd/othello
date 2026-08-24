# CARAT audit for every type-I1 invariant rank-two subtorus quotient.
# Load RatProbAlgTori.gap first.

if not IsBound(CaratZClass) then
    Error("load RatProbAlgTori.gap before this checker");
fi;
SetPrintFormattingStatus("*stdout*", false);

actions := [
    [
        [[3,-2,-1],[4,-3,-1],[0,0,-1]],
        [[-1,0,0],[0,-1,0],[0,-1,1]]
    ],
    [
        [[3,-2,-1],[4,-3,-1],[0,0,-1]],
        [[-3,2,0],[-4,3,0],[-2,1,1]]
    ],
    [
        [[1,0,-1],[0,1,-1],[0,0,-1]],
        [[-1,0,0],[0,-1,0],[-2,1,1]]
    ],
    [
        [[-3,1,1],[-4,1,2],[-4,2,1]],
        [[-7,4,-1],[-12,7,-2],[0,0,-1]]
    ]
];;
ids := List(actions, pair -> CaratZClass(Group(pair)));;
if ids <> [[3,25,2],[3,19,2],[3,19,2],[3,6,3]] then
    Error("unexpected rank-two quotient CARAT classes");
fi;

nonrationalRankThree := [
    [3,6,3], [3,8,3], [3,8,4], [3,15,2], [3,13,2],
    [3,14,4], [3,9,2], [3,28,1], [3,29,1], [3,29,3],
    [3,31,1], [3,31,3], [3,30,1], [3,32,1], [3,32,3]
];;
rationality := List(ids, id -> not id in nonrationalRankThree);;
if rationality <> [true,true,true,false] then
    Error("unexpected Kunyavskii rationality pattern");
fi;

Print("rank2_quotient_character_carat=", ids, "\n");
Print("rank2_quotient_kunyavskii_rational=", rationality, "\n");
QUIT;
