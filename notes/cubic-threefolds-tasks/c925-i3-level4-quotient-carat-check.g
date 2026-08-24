# CARAT check for the full type-I3 cubic-orbit rank-four quotient.
# Load RatProbAlgTori.gap first.

if not IsBound(CaratZClass) then
    Error("load RatProbAlgTori.gap before this checker");
fi;
SetPrintFormattingStatus("*stdout*", false);

characterGroup := Group([
    [[-1,0,1,-1],[1,1,1,2],[0,0,0,-1],[0,0,-1,0]],
    [[0,1,0,2],[-1,-1,0,-1],[0,0,1,0],[0,0,0,-1]]
]);;

maximalHereditaryIds := [
    [4,20,22,1], [4,30,13,1], [4,31,7,1], [4,32,21,1],
    [4,25,9,2], [4,13,6,4], [4,25,7,5], [4,24,3,4]
];;

HereditaryContainers := function(group)
    local hits, id, maximal, class, subgroup;
    hits := [];
    for id in maximalHereditaryIds do
        maximal := MatGroupZClass(id[1], id[2], id[3], id[4]);
        for class in ConjugacyClassesSubgroups(maximal) do
            subgroup := Representative(class);
            if Size(subgroup) = Size(group) and
               RepresentativeAction(GL(4,Integers), group, subgroup) <> fail then
                Add(hits, id);
                break;
            fi;
        od;
    od;
    return hits;
end;;

id := CaratZClass(characterGroup);;
containers := HereditaryContainers(characterGroup);;
if id <> [4,99,3] then
    Error("unexpected rank-four quotient character ID: ", id);
fi;
if containers <> [[4,20,22,1]] then
    Error("unexpected hereditary containers: ", containers);
fi;
Print(
    "i3_rank_four_quotient_character_carat=", id,
    " hereditary_container=", containers[1],
    "\n"
);
QUIT;
